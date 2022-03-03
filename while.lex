
open Tokens
type pos = int
type lexresult= (svalue,pos) token

fun eof () = Tokens.EOF(0,0)
fun integer(str,lexPos) =
case Int.fromString(str) of
NONE => raise Fail("Shouldn't happen: sequence of digits not recognized as integer -- " ^ str)
| SOME(n) => INT(n,lexPos,lexPos)
fun init() = ()

%%
%header (functor WhileLexFun(structure Tokens: While_TOKENS));
alpha=[a-zA-Z];
digit=[0-9];
alphaNumUnd=[a-zA-Z0-9_];
whitespace=[\ \t\n];
symbol=[+*^()\[];
any= [^];

%%
"program" => (PROG(yypos, yypos));
"tt" => (BEXP(yytex,yypos));
"ff" => (BEXP(yytex,yypos));
"!" => (NOT(yypos,yypos));
"&&"  => (AND(yypos, yypos));
"||" => (OR(yypos , yypos));
"<" => (LT(yypos, yypos)) ;
"<=" => (LEQ(yypos, yypos)) ;
"=" => (EQ(yypos , yypos));
">" => (GT(yypos, yypos)) ;
">=" => (GEQ(yypos, yypos)) ;
"<>" => (NEQ(yypos, yypos)) ;
"+" => (PLUS(yypos,yypos));
"-" => (MINUS(yypos,yypos));
"/" => (DIV(yypos , yypos));
"%" => (MOD(yypos , yypos));
":="=> (ASSI(yypos , yypos)); 
"," => (COMMA(yypos , yypos));
"::"=> (DUBCOL(yypos , yypos)); 
":" => (COLON(yypos , yypos));
";" => (SCOLON(yypos , yypos));
"int" => (INT(yypos , yypos));
"bool"=> (BOOL(yypos , yypos));
"var"=> (VAR(yypos , yypos));
"("=> (LP(yypos , yypos));
")"=> (RP(yypos , yypos));
"{"=> (LB(yypos , yypos));
"}"=> (RB(yypos , yypos));
"["=> (LS(yypos , yypos));
"read"=> (READ(yypos , yypos));
"write"=> (WRITE(yypos , yypos));
"if"=> (IF(yypos , yypos));
"then"=> (THEN(yypos , yypos));
"else"=> (ELSE(yypos , yypos));
"endif"=> (ENDIF(yypos , yypos));
"while"=> (WHILE(yypos , yypos));
"do"=> (DO(yypos , yypos));
"endwh"=> (ENDWH(yypos , yypos));
"~" => (TEL(yypos , yypos));
"+" => (PLUS(yypos , yypos)) ; 
[+|~]{digit}+ => (integer(yytext,yypos));
{whitespace} => (lex());
{any} => (
raise Fail("Slip scanner: unexpected character \"" ^ yytext ^ "\""));