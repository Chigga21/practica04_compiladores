%option noyywrap yylineno nounput noinput

%{
#include "scanner.h"

static const char *token_lexeme = "";

#define RET(t) do { token_lexeme = yytext; return (t); } while (0)
%}

%x COMMENT

DIG      [0-9]
HEXD     [0-9a-fA-F]
INT_DEC  {DIG}+(_{DIG}+)*
INT_HEX  0[xX]{HEXD}+(_{HEXD}+)*
INT_BIN  0[bB][01]+(_[01]+)*
INT      ({INT_DEC}|{INT_HEX}|{INT_BIN})
EXP      [eE][+-]?{DIG}+
FLOAT    ({DIG}+\.{DIG}+{EXP}?|{DIG}+{EXP})
NUM_TAIL [0-9a-zA-Z_]*(\.{DIG}[0-9a-zA-Z_]*)*\.?
BAD_NUM  ({DIG}{NUM_TAIL}|{DIG}[0-9_]*(\.{DIG}[0-9_]*)?[eE][+-]{NUM_TAIL})
ID       [a-zA-Z_][a-zA-Z0-9_]*
WS       [ \t\r\n]+

U8       ([\xC2-\xDF][\x80-\xBF]|[\xE0-\xEF][\x80-\xBF][\x80-\xBF]|[\xF0-\xF4][\x80-\xBF][\x80-\xBF][\x80-\xBF])
ESC      \\[ntr\\'"0]
CH       ([^'\\\r\n\x80-\xFF]|{U8}|{ESC})
STR_CH   ([^"\\\r\n]|{ESC})
CHAR_ANY ([^'\\\r\n]|\\[^\r\n])
STR_ANY  ([^"\\\r\n]|\\[^\r\n])

%%

"/*"                  { BEGIN(COMMENT); }
<COMMENT>"*/"         { BEGIN(INITIAL); }
<COMMENT>[^*\n]+       { }
<COMMENT>"*"          { }
<COMMENT>\n           { }
<COMMENT><<EOF>>       {
                          BEGIN(INITIAL);
                          token_lexeme = "/*";
                          return TOK_ERROR;
                      }

"//"[^\r\n]*          { }
{WS}                  { }

"theorem"             { RET(TOK_KW_THEOREM); }
"proof"               { RET(TOK_KW_PROOF); }
"therefore"           { RET(TOK_KW_THEREFORE); }
"qed"                 { RET(TOK_KW_QED); }
"let"                 { RET(TOK_KW_LET); }
"exists"              { RET(TOK_KW_EXISTS); }
"data"                { RET(TOK_KW_DATA); }
"absurd"              { RET(TOK_KW_ABSURD); }
"if"                  { RET(TOK_KW_IF); }
"else"                { RET(TOK_KW_ELSE); }
"while"               { RET(TOK_KW_WHILE); }
"forall"              { RET(TOK_KW_FORALL); }
"in"                  { RET(TOK_KW_IN); }
"step"                { RET(TOK_KW_STEP); }
"match"               { RET(TOK_KW_MATCH); }
"case"                { RET(TOK_KW_CASE); }
"break"               { RET(TOK_KW_BREAK); }
"left"                { RET(TOK_KW_LEFT); }
"right"               { RET(TOK_KW_RIGHT); }
"true"|"false"        { RET(TOK_BOOL_LITERAL); }

"Int"                 { RET(TOK_TYPE_INT); }
"Float"               { RET(TOK_TYPE_FLOAT); }
"Bool"                { RET(TOK_TYPE_BOOL); }
"Char"                { RET(TOK_TYPE_CHAR); }
"String"              { RET(TOK_TYPE_STRING); }
"Array"               { RET(TOK_TYPE_ARRAY); }
"True"                { RET(TOK_TYPE_TRUE); }
"False"               { RET(TOK_TYPE_FALSE); }

"print"               { RET(TOK_NATIVE_PRINT); }
"len"                 { RET(TOK_NATIVE_LEN); }
"push"                { RET(TOK_NATIVE_PUSH); }
"copy"                { RET(TOK_NATIVE_COPY); }
"toFloat"             { RET(TOK_NATIVE_TOFLOAT); }
"toInt"               { RET(TOK_NATIVE_TOINT); }

"_"                   { RET(TOK_WILDCARD); }

"->"                  { RET(TOK_ARROW); }
"<<"                  { RET(TOK_SHL); }
">>"                  { RET(TOK_SHR); }
"<="                  { RET(TOK_LE); }
">="                  { RET(TOK_GE); }
"=="                  { RET(TOK_EQ); }
"!="                  { RET(TOK_NEQ); }
"&&"                  { RET(TOK_AND); }
"||"                  { RET(TOK_OR); }

"="                   { RET(TOK_ASSIGN); }
"<"                   { RET(TOK_LT); }
">"                   { RET(TOK_GT); }
"!"                   { RET(TOK_NOT); }
"+"                   { RET(TOK_PLUS); }
"-"                   { RET(TOK_MINUS); }
"*"                   { RET(TOK_MUL); }
"/"                   { RET(TOK_DIV); }
"%"                   { RET(TOK_MOD); }
"&"                   { RET(TOK_BIT_AND); }
"|"                   { RET(TOK_BIT_OR); }
"^"                   { RET(TOK_BIT_XOR); }
"~"                   { RET(TOK_BIT_NOT); }

":"                   { RET(TOK_COLON); }
"."                   { RET(TOK_DOT); }
","                   { RET(TOK_COMMA); }
";"                   { RET(TOK_SEMICOLON); }
"("                   { RET(TOK_LPAREN); }
")"                   { RET(TOK_RPAREN); }
"{"                   { RET(TOK_LBRACE); }
"}"                   { RET(TOK_RBRACE); }
"["                   { RET(TOK_LBRACKET); }
"]"                   { RET(TOK_RBRACKET); }

{FLOAT}/\.{ID}        { RET(TOK_FLOAT_LITERAL); }
{INT}/\.{ID}          { RET(TOK_INT_LITERAL); }
{FLOAT}               { RET(TOK_FLOAT_LITERAL); }
{INT}                 { RET(TOK_INT_LITERAL); }
{BAD_NUM}             { RET(TOK_ERROR); }

\'{CH}\'              { RET(TOK_CHAR_LITERAL); }
\'{CHAR_ANY}*\'       { RET(TOK_ERROR); }
\'{CHAR_ANY}*\\?      { RET(TOK_ERROR); }

\"{STR_CH}*\"         { RET(TOK_STRING_LITERAL); }
\"{STR_ANY}*\"        { RET(TOK_ERROR); }
\"{STR_ANY}*\\?       { RET(TOK_ERROR); }

{ID}                  { RET(TOK_IDENTIFIER); }

<<EOF>>               { RET(TOK_EOF); }

{U8}                  { RET(TOK_ERROR); }
.                     { RET(TOK_ERROR); }

%%

const char *scanner_token_lexeme(void)
{
    return token_lexeme;
}
