module MiniJuvix.Parsing.Lexer where


import MiniJuvix.Utils.Prelude
import qualified Text.Megaparsec.Char.Lexer as L
import qualified MiniJuvix.Parsing.Base as P
import MiniJuvix.Parsing.Base hiding (space)
import GHC.Unicode

type OperatorSym = Text

space ∷ ∀ m e. MonadParsec e Text m ⇒ m ()
space = L.space space1 lineComment block
  where
    lineComment = L.skipLineComment "--"
    block = L.skipBlockComment "{-" "-}"

lexeme ∷ MonadParsec e Text m ⇒ m a → m a
lexeme = L.lexeme space

symbol ∷ MonadParsec e Text m ⇒ Text → m ()
symbol = void . L.symbol space

decimal ∷ (MonadParsec e Text m, Num n) ⇒ m n
decimal = lexeme L.decimal

identifier ∷ MonadParsec e Text m ⇒ m Text
identifier = lexeme bareIdentifier

-- | Same as @identifier@ but does not consume space after it.
bareIdentifier ∷ MonadParsec e Text m ⇒ m Text
bareIdentifier = do
  notFollowedBy (choice allKeywords)
  P.takeWhile1P Nothing (isAlphaNum .||. (`elem`("_'-" ∷ String)))

dottedIdentifier ∷ ∀ e m. MonadParsec e Text m ⇒ m (NonEmpty Text)
dottedIdentifier = P.sepBy1 bareIdentifier dot 
  where
  dot = P.char '.'

allKeywords ∷ MonadParsec e Text m ⇒ [m ()]
allKeywords =
  [
    kwArrowR
  , kwAxiom
  , kwCase
  , kwColon
  , kwColonOmega
  , kwColonOne
  , kwColonZero
  , kwEnd
  , kwEval
  , kwHiding
  , kwImport
  , kwInductive
  , kwInfix
  , kwInfixl
  , kwInfixr
  , kwLambda
  , kwLet
  , kwMapsTo
  , kwModule
  , kwOpen
  , kwPostfix
  , kwPrefix
  , kwPrint
  , kwSemicolon
  , kwType
  , kwUsing
  , kwWhere
  , kwWildcard
  ]

parens ∷ MonadParsec e Text m ⇒ m a → m a
parens = between (symbol "(") (symbol ")")

braces ∷ MonadParsec e Text m ⇒ m a → m a
braces = between (symbol "{") (symbol "}")

kwLet ∷ MonadParsec e Text m ⇒ m ()
kwLet = symbol "let"

kwInductive ∷ MonadParsec e Text m ⇒ m ()
kwInductive = symbol "inductive"

kwSemicolon ∷ MonadParsec e Text m ⇒ m ()
kwSemicolon = symbol ";"

kwDef ∷ MonadParsec e Text m ⇒ m ()
kwDef = symbol "≔" <|> symbol ":="

kwEval ∷ MonadParsec e Text m ⇒ m ()
kwEval = symbol "eval"

kwPrint ∷ MonadParsec e Text m ⇒ m ()
kwPrint = symbol "print"

kwColon ∷ MonadParsec e Text m ⇒ m ()
kwColon = symbol ":"

kwColonZero ∷ MonadParsec e Text m ⇒ m ()
kwColonZero = symbol ":0"

kwColonOne ∷ MonadParsec e Text m ⇒ m ()
kwColonOne = symbol ":1"

kwColonOmega ∷ MonadParsec e Text m ⇒ m ()
kwColonOmega = symbol ":ω" <|> symbol ":any"

kwArrowR ∷ MonadParsec e Text m ⇒ m ()
kwArrowR = symbol "→" <|> symbol "->"

kwMapsTo ∷ MonadParsec e Text m ⇒ m ()
kwMapsTo = symbol "↦" <|> symbol "->"

kwLambda ∷ MonadParsec e Text m ⇒ m ()
kwLambda = symbol "λ" <|> symbol "\\"

kwCase ∷ MonadParsec e Text m ⇒ m ()
kwCase = symbol "case"

kwType ∷ MonadParsec e Text m ⇒ m ()
kwType = symbol "Type"

kwInfix ∷ MonadParsec e Text m ⇒ m ()
kwInfix = symbol "infix"

kwInfixr ∷ MonadParsec e Text m ⇒ m ()
kwInfixr = symbol "infixr"

kwInfixl ∷ MonadParsec e Text m ⇒ m ()
kwInfixl = symbol "infixl"

kwPostfix ∷ MonadParsec e Text m ⇒ m ()
kwPostfix = symbol "postfix"

kwPrefix ∷ MonadParsec e Text m ⇒ m ()
kwPrefix = symbol "prefix"

kwOpen ∷ MonadParsec e Text m ⇒ m ()
kwOpen = symbol "open"

kwImport ∷ MonadParsec e Text m ⇒ m ()
kwImport = symbol "import"

kwHiding ∷ MonadParsec e Text m ⇒ m ()
kwHiding = symbol "hiding"

kwUsing ∷ MonadParsec e Text m ⇒ m ()
kwUsing = symbol "using"

kwModule ∷ MonadParsec e Text m ⇒ m ()
kwModule = symbol "module"

kwEnd ∷ MonadParsec e Text m ⇒ m ()
kwEnd = symbol "end"

kwWhere ∷ MonadParsec e Text m ⇒ m ()
kwWhere = symbol "where"

kwAxiom ∷ MonadParsec e Text m ⇒ m ()
kwAxiom = symbol "axiom"

kwWildcard ∷ MonadParsec e Text m ⇒ m ()
kwWildcard = symbol "_"
