# AST_generator
## Context Free Grammer

Start -> “program” Identifier “::” Block 

Block -> DeclarationSeq CommandSeqa 

DeclarationSeq -> Declaration | DeclarationSeq Declaration

Declaration -> “var” VariableList “:” Type “;” 

Type -> “int” | “bool” .

VariableList -> Var | Var "," VariableList 

CommandSeqa -> "{" "}" | "{" CommandSeq "}"

CommandSeq -> Command ";" |  Command ";" CommandSeq

Command ->  Var “:=” Exp | "read" Var | "write" Var | "if" boolexp "then" CommandSeqa "else" CommandSeqa "endif"|
“while” boolexp “do” CommandSeqa “endwh” 

Exp -> intexp | boolexp 

intexp -> intexp AddOp IntTerm | IntTerm 

IntTerm -> IntTerm MultOp IntFactor | IntFactor 

IntFactor -> Numeral | V ariable |“(”intexp“)” | “˜”IntFactor 

boolexp -> boolexp “||” BoolTerm | BoolTerm 

BoolTerm -> BoolTerm “&&” BoolFactor | BoolFactor 
BoolF actor -> “tt” | “ff” | Variable | Comparison |
“(”boolexp“)” | “!”BoolFactor 

Comparison -> intexp RelOp intexp |boolexp RelOP boolexp |boolexp RelOP intexp |intexp RelOP boolexp 

Variable -> Identifier 

RelOp -> “<” | “<=” | “=” | “>” | “>=” | “<>” 

AddOp -> “+” | “−”

MultOp -> “∗” | “/” | “%” 

Identifier -> Letter [Letter | Digit]*

Numeral -> [“+” | “˜”][Digit]^+^ | [Digit]^+^

## AST datatype definition

For this assignment I have used four kinds of nodes for AST namely UnApp, BinApp, BinApps ,TriApp



1. UnApps (unop * exp) : It includes unary operators such as NOT and TELDA and Unary functions such as READ , WRITE, WHILE which will take variable as a prameter 

2. BinApp (binop * exp * exp ) : It includes binary operators such as *PLUS*, *MINUS*, *TIMES*, *DIV*, *MOD*, *AND*, *OR*, *LT*, *LEQ*, *GT*, *GEQ* ,*EQ* ,*NEQ* and some binary functions such as *DECLSEQ* (declare sequence, used to declare variables recursively in the tree. When used this operator the left child represent a Declaration and the right child represent a DeclarationSeq ), *VARL* (Variable list , Used to declare a Variable list. When used this operator the left child will represent a variable and the right child will represent the remaining variable list ) ,*PROG* (The left child represet the name of the program and the right child represent the Block ),*BLOCK*(the left child represent the Declarationsequence and the right child represent the CommandSeqa ) ,*COMSEQ* (This operator recursively defines all the command in the AST, The left child represent the command and the right child represent the remaining command seq ),*SET* (this operator is used to assign the values to the variable (:=) the left child represent the variable name the right child represent the expression),*WH*(This is the operator for while loop the left child represent the boolean expression which when true , it keeps on  executing the expression on the right child of the node)

3. BinApps(binop * exp * string) : *DECL* (declaration of variables, the left child represents the varibale list and the right child represent the TYPE) , since TYPE is a string so we need the right child to store value of the string type hence we needed to create another type of node having right child to store values of type string 

4. TriApps (triop * exp * exp * exp ) : *ITE* ( this is the if then else operator , this operator has three children nodes , the first node represent the boolean expression the second child represent represent the Command sequence to be executed when the boolean expression in the if block is true, the 3rd child contains the command sequence to be exeuted when the boolean expression inside the if block is false )

## Syntax-directed translation
