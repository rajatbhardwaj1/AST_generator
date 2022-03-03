structure AST =
struct
datatype iexp = Int of int
| Node of binop * iexp * iexp
and binop = PLUS | MINUS | TIMES | DIV | MOD  |LT|LEQ |  EQ| GT| GEQ| NEQ
datatype bexp = BOOL of BOOL | Node of boolop * bexp * bexp 
and boolop = NOT | AND | OR
datatype cmnd = Cmnd of cmnd 
|
(* Various AST functions omitted from this slide *)
end