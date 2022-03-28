-- |

module MiniJuvix.Syntax.Concrete.Scoped.InfoTable where
import MiniJuvix.Prelude
import MiniJuvix.Syntax.Concrete.Language

newtype FunctionInfo = FunctionInfo {
  _functionInfoType :: Expression
  }

newtype ConstructorInfo = ConstructorInfo {
  _constructorInfoType :: Expression
  }

data AxiomInfo = AxiomInfo {
  _axiomInfoType :: Expression,
  _axiomInfoBackends :: [BackendItem]
  }

newtype InductiveInfo = InductiveInfo {
  _inductiveInfoDef :: InductiveDef 'Scoped
  }

data InfoTable = InfoTable {
  _infoConstructors :: HashMap ConstructorRef ConstructorInfo,
  _infoAxioms :: HashMap AxiomRef AxiomInfo,
  _infoInductives :: HashMap InductiveRef InductiveInfo,
  _infoFunctions :: HashMap FunctionRef FunctionInfo
  }

emptyInfoTable :: InfoTable
emptyInfoTable = InfoTable {
  _infoConstructors = mempty,
  _infoAxioms = mempty,
  _infoInductives = mempty,
  _infoFunctions = mempty
  }

makeLenses ''InfoTable
makeLenses ''InductiveInfo
makeLenses ''ConstructorInfo
makeLenses ''AxiomInfo
makeLenses ''FunctionInfo
