type type_ =
  | TInt8
  | TInt16
  | TInt32
  | TInt64
  | TUInt8
  | TUInt16
  | TUInt32
  | TUInt64
  | TFloat32
  | TFloat64
  | TString
  | TBool
  | TChar
  | TStruct of struct_
  | TEnum of enum
  | TList of type_
  | TTuple of type_ list
  | TFunc of type_ list * type_

and struct_ = Struct of string * field list

and field = Field of string * type_

and enum = Enum of string * variant list

and variant = Variant of string * type_

type unary_op =
  | Neg
  | Not
  | BinNot

type arith_op =
  | Add
  | Sub
  | Mul
  | Div
  | Mod

type cmp_op =
  | Eq
  | Ne
  | Lt
  | Le
  | Gt
  | Ge

type logic_op =
  | And
  | Or

type bit_op =
  | BinAnd
  | BinOr
  | BinXor
  | BinShl
  | BinShr

type expr =
  | Int of int
  | Bool of bool
  | Float of float
  | String of string
  | Array of expr list
  | Tuple of expr list
  | Var of string
  | Call of expr * expr list
  | Index of expr * expr
  | Unary of unary_op * expr
  | ArithOp of arith_op * expr * expr
  | CmpOp of cmp_op * expr * expr
  | LogicOp of logic_op * expr * expr
  | BitOp of bit_op * expr * expr
  | Assign of expr * expr
  | ChanRecv of string
  | ChanSend of string * expr

type stmt =
  | Expr of expr
  | Let of string * type_ * expr
  | Return of expr
  | If of expr * stmt list * stmt list
  | While of expr * stmt list
  | For of string * expr * expr * stmt list
  | Closure of string list * arg list * type_ * stmt list
  | Break
  | Continue

and arg = Arg of string * type_

type program = Program of func list * struct_ list * enum list

and func = Func of string * arg list * type_ * stmt list
