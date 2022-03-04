structure AST =
struct
datatype Type = TYPE  

datatype exp = Int of int |Bool of bool |Var of string | Type of Type 
| UnApp of unop * exp 
| BinApp of binop * exp * exp
| BinAppS of binop * exp * string 
| TriApp of triop * exp * exp * exp 

and unop = NOT| TELDA  |READ |WRITE | WHILE 
and binop = PLUS | MINUS |DECLSEQ |DECL| TIMES | VARL |DIV | MOD |PROG|BLOCK |INT |BOOL 
 | AND| OR|LT| LEQ| GT| GEQ |EQ |NEQ|COMSEQ|SET |WH 
and triop = ITE 
(* Various AST functions omitted from this slide *)
end
 