# AST_generator

# How to use the program

The main file of the program is while_ast.sml which you have to run in order to parse a file or a string. The instructions are as follows : 

1. The lex and yacc files are already compiled and the lex.sml , yacc.desc , yacc.sig , yacc.sml are generated and are included in the submitted program2.

2. In the terminal first go to project's directory and type `sml` in the terminal to activate sml command prompt.

3. Then type `use "while_ast.sml" ; ` in the command 

4. Now type `parseFile "FileName" ; ` in the terminal to parse a file. The file should be present in the project's directory. If u want to parse a string then type `parseString "String" ;` in the terminal.

5. The result of the function (an AST) would be output on the terminal.

6. Type `ctrl + z` then enter to exit sml command prompt


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

Numeral -> [“+” | “˜”][Digit]+ | [Digit]+

## AST datatype definition

For this assignment I have used four kinds of nodes for AST namely UnApp, BinApp, BinApps ,TriApp



1. UnApps (unop * exp) : It includes unary operators such as NOT and TELDA and Unary functions such as READ , WRITE, WHILE which will take variable as a prameter 

2. BinApp (binop * exp * exp ) : It includes binary operators such as *PLUS*, *MINUS*, *TIMES*, *DIV*, *MOD*, *AND*, *OR*, *LT*, *LEQ*, *GT*, *GEQ* ,*EQ* ,*NEQ* and some binary functions such as *DECLSEQ* (declare sequence, used to declare variables recursively in the tree. When used this operator the left child represent a Declaration and the right child represent a DeclarationSeq ), *VARL* (Variable list , Used to declare a Variable list. When used this operator the left child will represent a variable and the right child will represent the remaining variable list ) ,*PROG* (The left child represet the name of the program and the right child represent the Block ),*BLOCK*(the left child represent the Declarationsequence and the right child represent the CommandSeqa ) ,*COMSEQ* (This operator recursively defines all the command in the AST, The left child represent the command and the right child represent the remaining command seq ),*SET* (this operator is used to assign the values to the variable (:=) the left child represent the variable name the right child represent the expression),*WH*(This is the operator for while loop the left child represent the boolean expression which when true , it keeps on  executing the expression on the right child of the node)

3. BinApps(binop * exp * string) : *DECL* (declaration of variables, the left child represents the varibale list and the right child represent the TYPE) , since TYPE is a string so we need the right child to store value of the string type hence we needed to create another type of node having right child to store values of type string 

4. TriApps (triop * exp * exp * exp ) : *ITE* ( this is the if then else operator , this operator has three children nodes , the first node represent the boolean expression the second child represent represent the Command sequence to be executed when the boolean expression in the if block is true, the 3rd child contains the command sequence to be exeuted when the boolean expression inside the if block is false )

## Syntax-directed translation

Start : PROG Identifier DCOLON Block -> ( AST.BinApp(AST.PROG , Identifier , Block )) 

Block: DeclarationSeq CommandSeqa -> (AST.BinApp(AST.BLOCK ,DeclarationSeq , CommandSeqa)) 
|CommandSeqa  -> (AST.BinApp(AST.BLOCK ,AST.Int(0) , CommandSeqa)) 




CommandSeqa : LBR RBR -> (AST.Int(0))         
| LBR  CommandSeq RBR -> (CommandSeq)

CommandSeq : Command SCOLON -> (Command )
|Command SCOLON CommandSeq -> ( AST.BinApp(AST.COMSEQ , Command , CommandSeq)) 

Command : Var SET Exp-> (AST.BinApp(AST.SET , Var , Exp) )
| READ Var -> (AST.UnApp(AST.READ  , Var)) 
| WRITE intexp -> (AST.UnApp(AST.WRITE  , intexp)) 
| IF boolexp THEN CommandSeqa ELSE CommandSeqa ENDIF -> (AST.TriApp(AST.ITE, boolexp  ,CommandSeqa1 ,  CommandSeqa2 ))
| WHILE boolexp DO CommandSeqa ENDWH -> (AST.BinApp(AST.WH , boolexp , CommandSeqa ))

Exp : intexp-> (intexp) | boolexp-> (boolexp) 

intexp : Term -> (Term)
| intexp MINUS Term -> (AST.BinApp(AST.MINUS,intexp,Term))
Term : Factor -> (Factor)
| Term TIMES Factor -> (AST.BinApp(AST.TIMES,Term,Factor))  
| Term DIV Factor -> (AST.BinApp(AST.DIV,Term,Factor))
| Term MOD Factor -> (AST.BinApp(AST.MOD,Term,Factor))

Factor : Unit -> (Unit)
| Var -> (Var) 
| TELDA Factor -> (AST.UnApp(AST.TELDA , Factor))
| LPAREN intexp RPAREN -> (intexp)

Unit : INT -> (AST.Int(INT))

Var : VAR -> (AST.Var(VAR))

boolexp : BTerm-> (BTerm)
| boolexp OR BTerm -> (AST.BinApp(AST.OR,boolexp,BTerm))

BTerm : Bfactor -> (Bfactor)
| BTerm AND Bfactor -> (AST.BinApp(AST.AND,BTerm,Bfactor))

Bfactor : BUnit -> (BUnit)
|Var -> (Var) 

|Comparison-> (Comparison) 
| NOT Bfactor -> (AST.UnApp(AST.NOT , Bfactor))
| LPAREN boolexp RPAREN -> (boolexp)

Comparison: 
intexp LT intexp -> ( AST.BinApp(AST.LT, intexp1 , intexp2)) 
|intexp GT intexp -> ( AST.BinApp(AST.GT, intexp1 , intexp2))
|intexp LEQ intexp -> ( AST.BinApp(AST.LEQ, intexp1 , intexp2))
|intexp GEQ intexp -> ( AST.BinApp(AST.GEQ, intexp1 , intexp2))
|intexp EQ intexp -> ( AST.BinApp(AST.EQ, intexp1 , intexp2))
|intexp NEQ intexp -> ( AST.BinApp(AST.NEQ, intexp1 , intexp2))

|boolexp LT boolexp -> ( AST.BinApp(AST.LT, boolexp1 , boolexp2)) 
|boolexp GT boolexp -> ( AST.BinApp(AST.GT, boolexp1 , boolexp2))
|boolexp LEQ boolexp -> ( AST.BinApp(AST.LEQ, boolexp1 , boolexp2))
|boolexp GEQ boolexp -> ( AST.BinApp(AST.GEQ, boolexp1 , boolexp2))
|boolexp EQ boolexp -> ( AST.BinApp(AST.EQ, boolexp1 , boolexp2))
|boolexp NEQ boolexp -> ( AST.BinApp(AST.NEQ, boolexp1 , boolexp2))

|boolexp LT intexp -> ( AST.BinApp(AST.LT, boolexp , intexp)) 
|boolexp GT intexp -> ( AST.BinApp(AST.GT, boolexp , intexp))
|boolexp LEQ intexp -> ( AST.BinApp(AST.LEQ, boolexp , intexp))
|boolexp GEQ intexp -> ( AST.BinApp(AST.GEQ, boolexp , intexp))
|boolexp EQ intexp -> ( AST.BinApp(AST.EQ, boolexp , intexp))
|boolexp NEQ intexp -> ( AST.BinApp(AST.NEQ, boolexp , intexp))

|intexp LT boolexp -> ( AST.BinApp(AST.LT, intexp , boolexp)) 
|intexp GT boolexp -> ( AST.BinApp(AST.GT, intexp , boolexp))
|intexp LEQ boolexp -> ( AST.BinApp(AST.LEQ, intexp , boolexp))
|intexp GEQ boolexp -> ( AST.BinApp(AST.GEQ, intexp , boolexp))
|intexp EQ boolexp -> ( AST.BinApp(AST.EQ, intexp , boolexp))
|intexp NEQ boolexp -> ( AST.BinApp(AST.NEQ, intexp , boolexp))


BUnit : BOOL -> (AST.Bool(BOOL))


Identifier : Var-> (Var)

## Auxiliary functions and Data

DeclarationSeq : Declaration -> ( Declaration)
| DeclarationSeq Declaration -> (AST.BinApp(AST.DECLSEQ , DeclarationSeq , Declaration))

Declaration : VARI VariableList COLON TYPE SCOLON ->  (AST.BinAppS(AST.DECL , VariableList , TYPE))  

VariableList : Var ->  (Var) 
| Var COMMA VariableList -> ( AST.BinApp(AST.VARL , Var , VariableList1)) 

command : READ Var -> (AST.UnApp(AST.READ  , Var)) 
| WRITE intexp -> (AST.UnApp(AST.WRITE  , intexp)) 

## Other Design Decisions



1. Since I have kept seperate expression for the boolean expression and the integer expressions, there are 2 reduce| reduce conflicts because in case of x := y, the parser desnot know whether to reduce y as a boolean or an integer, this can be taken care by typechecking in the next phase of the assignement. 

2. One of the major design decision I took is the comparison of boolean and integer. We can take tt=1 and ff=0 and compare the bools and integers. Since there is a reduce reduce conflict in the grammar, the parser is unable to parse the sentences like (A < C) < D, since it parses D as an integer, so we need to allow integer- bool comparision so as to parse the expressions like these. The modern programming languages such as C++ also allow the int-bool comparison so this design decision is valid. Since in the assignement it was mentioned we can compare bools among each other thats why I had to take this design .decision to allow bool-bool , int - bool comparison both. This lead to many shift-reduce and reduce-reduce conflicts, these conflicts can be prevented by typechecking in the next phase of the assignemt.

## Other Implementation Decisions

1. I used an extra non terminal symbol CommandSeqa so as to help with 0 commands program since we need to put braces also, in case the number of command sequences are 0 then the node of the ast will have int(0) as the value.

2. When the Declaration sequence have 0 declarations, The value of the node will be int(0) 

3. In ast.sml, I have used different operators instead of different datatypes. For example *PROG* and *ADD* are both *binop* the are distinguished purely based on their name i.e. PROG and ADD 

## Acknowledgements
Sources used 

1.  http://cs.wellesley.edu/~cs235/fall08/lectures/35_YACC_revised.pdf (The glue code (named wh.sml) is copied from this ppt, the formats of lex file and yacc file are also copied from here)

2. http://rogerprice.org/ug/ug.pdf 
