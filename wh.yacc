(* no SML code in this case *)

%% (* separates initial section from middle section of .yacc file *)
%name wh
%pos int
%term
INT of int
| BOOL of bool 
|TYPE of string 
| PLUS | MINUS | TIMES | DIV | MOD|PROG|TT| FF| NOT| AND| OR |LT |LEQ |GT|GEQ | EQ |NEQ 
| LPAREN (* "(" *)| RPAREN (* ")" *)| EOF (* End of file*)| VAR of string |TELDA| DCOLON
| VARI|COMMA| LBR|COLON|SCOLON| RBR| SET | READ| WRITE| IF|THEN|ELSE|ENDIF|DO | ENDWH |WHILE


%nonterm
Start of AST.exp
| Exp of AST.exp
| intexp of AST.exp 
| boolexp of AST.exp
| BTerm of AST.exp
| Bfactor of AST.exp
| BUnit of AST.exp
| Term of AST.exp
| Factor of AST.exp
| Unit of AST.exp
| Var of AST.exp 
| Comparison of AST.exp 
| Program of AST.exp 
| Block of AST.exp 
| Identifier of AST.exp
| DeclarationSeq of AST.exp 
| CommandSeq of AST.exp 
| CommandSeqa of AST.exp 
| Declaration of AST.exp 
| VariableList of AST.exp
|Command of AST.exp 
|Type of AST.exp 
%start Start
%keyword
%eop EOF
%noshift EOF
%nodefault
%verbose
%value INT(0)
%% 
Start : PROG Identifier DCOLON Block( AST.BinApp(AST.PROG , Identifier , Block ))
Identifier : Var(Var)
Block: DeclarationSeq CommandSeqa(AST.BinApp(AST.BLOCK ,DeclarationSeq , CommandSeqa)) 
|CommandSeqa (AST.BinApp(AST.BLOCK ,AST.Int(0) , CommandSeqa)) 

DeclarationSeq :
Declaration( Declaration)
| DeclarationSeq Declaration(AST.BinApp(AST.DECLSEQ , DeclarationSeq , Declaration))

Declaration : VARI VariableList COLON TYPE SCOLON (AST.BinAppS(AST.DECL , VariableList , TYPE))

CommandSeqa : LBR RBR (AST.Int(0)) 
| LBR  CommandSeq RBR (CommandSeq)

CommandSeq : Command SCOLON (Command )
|Command SCOLON CommandSeq ( AST.BinApp(AST.COMSEQ , Command , CommandSeq)) 

Command : Var SET Exp(AST.BinApp(AST.SET , Var , Exp) )
| READ Var (AST.UnApp(AST.READ  , Var)) 
| WRITE intexp (AST.UnApp(AST.WRITE  , intexp)) 
| IF boolexp THEN CommandSeqa ELSE CommandSeqa ENDIF (AST.TriApp(AST.ITE, boolexp  ,CommandSeqa1 ,  CommandSeqa2 ))
| WHILE boolexp DO CommandSeqa ENDWH (AST.BinApp(AST.WH , boolexp , CommandSeqa ))



VariableList : Var (Var) 
| Var COMMA VariableList ( AST.BinApp(AST.VARL , Var , VariableList1)) 

Exp : intexp(intexp) | boolexp(boolexp)   (*sort the reduce reduce conflict*)

intexp : Term (Term)
(* The following rules specify left associativity *)
| intexp PLUS Term (AST.BinApp(AST.PLUS,intexp,Term))
| intexp MINUS Term (AST.BinApp(AST.MINUS,intexp,Term))
Term : Factor (Factor)
(* The following rules specify left associativity *)
| Term TIMES Factor (AST.BinApp(AST.TIMES,Term,Factor))
| Term DIV Factor (AST.BinApp(AST.DIV,Term,Factor))
| Term MOD Factor (AST.BinApp(AST.MOD,Term,Factor))
Factor : Unit (Unit)
| Var (Var) 
| TELDA Factor (AST.UnApp(AST.TELDA , Factor))
(* The following rule specifies right associativity *)
| LPAREN intexp RPAREN (intexp)
Unit : INT (AST.Int(INT))

Var : VAR (AST.Var(VAR))

boolexp : BTerm(BTerm)
| boolexp OR BTerm (AST.BinApp(AST.OR,boolexp,BTerm))
BTerm : Bfactor (Bfactor)
(* The following rules specify left associativity *)
| BTerm AND Bfactor (AST.BinApp(AST.AND,BTerm,Bfactor))
Bfactor : BUnit (BUnit)
|Var (Var) 

|Comparison(Comparison) 
| NOT Bfactor (AST.UnApp(AST.NOT , Bfactor))
(* The following rule specifies right associativity *)
| LPAREN boolexp RPAREN (boolexp)
Comparison: 
intexp LT intexp ( AST.BinApp(AST.LT, intexp1 , intexp2))
|intexp GT intexp ( AST.BinApp(AST.GT, intexp1 , intexp2))
|intexp LEQ intexp ( AST.BinApp(AST.LEQ, intexp1 , intexp2))
|intexp GEQ intexp ( AST.BinApp(AST.GEQ, intexp1 , intexp2))
|intexp EQ intexp ( AST.BinApp(AST.EQ, intexp1 , intexp2))
|intexp NEQ intexp ( AST.BinApp(AST.NEQ, intexp1 , intexp2))

BUnit : BOOL (AST.Bool(BOOL))
