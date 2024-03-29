module MiniJuvix.Translation.AbstractToMicroJuvix where

import qualified Data.HashMap.Strict as HashMap
import MiniJuvix.Prelude
import qualified MiniJuvix.Syntax.Abstract.Language.Extra as A
import qualified MiniJuvix.Syntax.Concrete.Scoped.Name as S
import MiniJuvix.Syntax.MicroJuvix.Language
import qualified MiniJuvix.Syntax.Usage as A

translateModule :: A.TopModule -> Module
translateModule m =
  Module
    { _moduleName = goTopModuleName (m ^. A.moduleName),
      _moduleBody = goModuleBody (m ^. A.moduleBody)
    }

goTopModuleName :: A.TopModuleName -> Name
goTopModuleName = goSymbol . S.topModulePathName

goName :: S.Name -> Name
goName = goSymbol . S.nameUnqualify

goSymbol :: S.Symbol -> Name
goSymbol s =
  Name
    { _nameText = S.symbolText s,
      _nameId = S._nameId s,
      _nameKind = getNameKind s
    }

unsupported :: Text -> a
unsupported thing = error ("Not yet supported: " <> thing)

goImport :: A.TopModule -> ModuleBody
goImport m = goModuleBody (m ^. A.moduleBody)

goModuleBody :: A.ModuleBody -> ModuleBody
goModuleBody b
  | not (HashMap.null (b ^. A.moduleLocalModules)) = unsupported "local modules"
  | otherwise =
    ModuleBody
      { _moduleInductives =
          HashMap.fromList
            [ (d ^. indexedThing . inductiveName, d)
              | d <- map (fmap goInductiveDef) (toList (b ^. A.moduleInductives))
            ],
        _moduleFunctions =
          HashMap.fromList
            [ (f ^. indexedThing . funDefName, f)
              | f <- map (fmap goFunctionDef) (toList (b ^. A.moduleFunctions))
            ],
        _moduleForeigns = b ^. A.moduleForeigns
      }

-- <> mconcatMap goImport (b ^. A.moduleImports)

goTypeIden :: A.Iden -> TypeIden
goTypeIden i = case i of
  A.IdenFunction {} -> unsupported "functions in types"
  A.IdenConstructor {} -> unsupported "constructors in types"
  A.IdenVar {} -> unsupported "type variables"
  A.IdenInductive d -> TypeIdenInductive (goName d)
  A.IdenAxiom {} -> unsupported "axioms in types"

goFunctionParameter :: A.FunctionParameter -> Type
goFunctionParameter f = case f ^. A.paramName of
  Just {} -> unsupported "named function arguments"
  _ -> case f ^. A.paramUsage of
    A.UsageOmega -> goType (f ^. A.paramType)
    _ -> unsupported "usages"

goFunction :: A.Function -> Function
goFunction (A.Function l r) = Function (goFunctionParameter l) (goType r)

goFunctionDef :: A.FunctionDef -> FunctionDef
goFunctionDef f =
  FunctionDef
    { _funDefName = goSymbol (f ^. A.funDefName),
      _funDefTypeSig = goType (f ^. A.funDefTypeSig),
      _funDefClauses = fmap goFunctionClause (f ^. A.funDefClauses)
    }

goFunctionClause :: A.FunctionClause -> FunctionClause
goFunctionClause c =
  FunctionClause
    { _clausePatterns = map goPattern (c ^. A.clausePatterns),
      _clauseBody = goExpression (c ^. A.clauseBody)
    }

goPattern :: A.Pattern -> Pattern
goPattern p = case p of
  A.PatternVariable v -> PatternVariable (goSymbol v)
  A.PatternConstructorApp c -> PatternConstructorApp (goConstructorApp c)
  A.PatternWildcard -> PatternWildcard
  A.PatternEmpty -> unsupported "pattern empty"

goConstructorApp :: A.ConstructorApp -> ConstructorApp
goConstructorApp c =
  ConstructorApp
    (goName (c ^. A.constrAppConstructor))
    (map goPattern (c ^. A.constrAppParameters))

goType :: A.Expression -> Type
goType e = case e of
  A.ExpressionIden i -> TypeIden (goTypeIden i)
  A.ExpressionUniverse {} -> unsupported "universes in types"
  A.ExpressionApplication {} -> unsupported "application in types"
  A.ExpressionFunction f -> TypeFunction (goFunction f)
  A.ExpressionLiteral {} -> unsupported "literals in types"

goApplication :: A.Application -> Application
goApplication (A.Application f x) = Application (goExpression f) (goExpression x)

goIden :: A.Iden -> Iden
goIden i = case i of
  A.IdenFunction n -> IdenFunction (goName n)
  A.IdenConstructor c -> IdenConstructor (goName c)
  A.IdenVar v -> IdenVar (goSymbol v)
  A.IdenAxiom {} -> unsupported "axiom identifier"
  A.IdenInductive {} -> unsupported "inductive identifier"

goExpression :: A.Expression -> Expression
goExpression e = case e of
  A.ExpressionIden i -> ExpressionIden (goIden i)
  A.ExpressionUniverse {} -> unsupported "universes in expression"
  A.ExpressionFunction {} -> unsupported "function type in expressions"
  A.ExpressionApplication a -> ExpressionApplication (goApplication a)
  A.ExpressionLiteral {} -> unsupported "literals in expression"

goInductiveDef :: A.InductiveDef -> InductiveDef
goInductiveDef i = case i ^. A.inductiveType of
  Just {} -> unsupported "inductive indices"
  _ ->
    InductiveDef
      { _inductiveName = indName,
        _inductiveConstructors = map goConstructorDef (i ^. A.inductiveConstructors)
      }
  where
    indName = goSymbol (i ^. A.inductiveName)
    goConstructorDef :: A.InductiveConstructorDef -> InductiveConstructorDef
    goConstructorDef c =
      InductiveConstructorDef
        { _constructorName = goSymbol (c ^. A.constructorName),
          _constructorParameters = goConstructorType (c ^. A.constructorType)
        }
    goConstructorType :: A.Expression -> [Type]
    goConstructorType = fst . viewExpressionFunctionType

-- TODO: add docs or an example
viewExpressionFunctionType :: A.Expression -> ([Type], Type)
viewExpressionFunctionType e = case e of
  A.ExpressionFunction f -> first toList (viewFunctionType f)
  A.ExpressionIden i -> ([], TypeIden (goTypeIden i))
  A.ExpressionApplication {} -> unsupported "application in a type"
  A.ExpressionUniverse {} -> unsupported "universe in a type"
  A.ExpressionLiteral {} -> unsupported "literal in a type"

viewFunctionType :: A.Function -> (NonEmpty Type, Type)
viewFunctionType (A.Function p r) = (goFunctionParameter p :| args, ret)
  where
    (args, ret) = viewExpressionFunctionType r
