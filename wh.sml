structure wh = struct (* Module for interfacing with parser and lexer *)
(* Most of the following is "boilerplate" code that needs to be slightly edited on a per parser basis. *)
structure whLrVals = whLrValsFun(structure Token = LrParser.Token)
structure whLex = whLexFun(structure Tokens = whLrVals.Tokens);
structure whParser =
Join(structure LrParser = LrParser
structure ParserData = whLrVals.ParserData
structure Lex = whLex)
val invoke = fn lexstream => (* The invoke function invokes the parser given a lexer *)
let val print_error = fn (str,pos,_) =>
TextIO.output(TextIO.stdOut,
"***wh Parser Error at character position " ^ (Int.toString pos)
^ "***\n" ^ str^ "\n")
in whParser.parse(0,lexstream,print_error,())
end
fun newLexer fcn = (* newLexer creates a lexer from a given input-reading function *)
let val lexer = whParser.makeLexer fcn
val _ = whLex.UserDeclarations.init()
in lexer
end
fun stringToLexer str = (* creates a lexer from a string *)
let val done = ref false
in newLexer (fn n => if (!done) then "" else (done := true; str))
end
fun fileToLexer filename = (* creates a lexer from a file *)
let val inStream = TextIO.openIn(filename)
in newLexer (fn n => TextIO.inputAll(inStream))
end
fun lexerToParser (lexer) = (* creates a parser from a lexer *)
let val dummyEOF = whLrVals.Tokens.EOF(0,0)
val (result,lexer) = invoke lexer
val (nextToken,lexer) = whParser.Stream.get lexer
in if whParser.sameToken(nextToken,dummyEOF) then
result
else (TextIO.output(TextIO.stdOut,
"*** wh PARSER WARNING -- unconsumed input ***\n");
result)
end
val parseString = lexerToParser o stringToLexer (* parses a string *)
val parseFile = lexerToParser o fileToLexer (* parses a file *)
end (* struct *)