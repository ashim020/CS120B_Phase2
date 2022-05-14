   /* cs152-miniL phase2 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
#include "y.tab.h"   
int currLine, currPos = 1;
%}

   /* some common rules */
LETTER 	[a-z|A-Z]
DIGIT 	[0-9]
COMMENT ##.*\n
%%
   /* specific lexer rules in regex */

"("		{return L_PAREN; currPos += yyleng;}
")"		{return R_PAREN; currPos += yyleng;}
":"		{return COLON; currPos += yyleng;}
"["		{return L_BRACKET; currPos += yyleng;}
"]"		{return R_BRACKET; currPos += yyleng;}
":="		{return ASSIGN; currPos += yyleng;}
"or"		{return OR; currPos += yyleng;}
"and"		{return AND; currPos += yyleng;}
"not"		{return NOT; currPos += yyleng;}
"true"		{return TRUE; currPos += yyleng;}
"false"		{return FALSE; currPos += yyleng;}
"function"	{return FUNCTION; currPos += yyleng;}
"beginparams"	{return BEGINPARAMS; currPos += yyleng;}
"endparams"	{return ENDPARAMS; currPos += yyleng;}
"beginlocals"	{return BEGINLOCALS; currPos += yyleng;}
"endlocals"	{return ENDLOCALS; currPos += yyleng;}
"beginbody"	{return BEGINBODY; currPos += yyleng;}
"endbody"	{return ENDBODY; currPos += yyleng;}
"integer"	{return INTEGER; currPos += yyleng;}
"array"		{return ARRAY; currPos += yyleng;}
"enum"		{return ENUM; currPos += yyleng;}
"of"		{return OF; currPos += yyleng;}
"if"		{return IF; currPos += yyleng;}
"then"		{return THEN; currPos += yyleng;}
"endif"		{return ENDIF; currPos += yyleng;}
"else"		{return ELSE; currPos += yyleng;}
"for"		{return FOR; currPos += yyleng;}
"while"		{return WHILE; currPos += yyleng;}
"do"		{return DO; currPos += yyleng;}
"beginloop"	{return BEGINLOOP; currPos += yyleng;}
"endloop"	{return ENDLOOP; currPos += yyleng;}
"continue"	{return CONTINUE; currPos += yyleng;}
"read"		{return READ; currPos += yyleng;}
"write"		{return WRITE; currPos += yyleng;}
"return"	{return RETURN; currPos += yyleng;}
"=="		{return EQ; currPos += yyleng;}
"<="		{return LTE; currPos += yyleng;}
">="		{return GTE; currPos += yyleng;}
"<>"		{return NEQ; currPos += yyleng;}
">"		{return GT; currPos += yyleng;}
"<"		{return LT; currPos += yyleng;}
"+"		{return ADD; currPos += yyleng;}
"-"		{return SUB; currPos += yyleng;}
"*"		{return MULT; currPos += yyleng;}
"/"		{return DIV; currPos += yyleng;}
"%"		{return MOD; currPos += yyleng;}
","		{return COMMA; currPos += yyleng;}
";"		{return SEMICOLON; currPos += yyleng;}

"\n"+		{currLine++; currPos = 1;}
{DIGIT}+	{return NUMBER; currPos += yyleng;}
[ \t]+		{currPos += yyleng;}
{COMMENT} 	{currLine++; currPos = 1;}

{LETTER}|{LETTER}({LETTER}|{DIGIT}|_)*({LETTER}|{DIGIT})	{return IDENT; currPos += yyleng;}
({DIGIT}|_)({LETTER}|{DIGIT}|_)*({LETTER}|{DIGIT})		{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(0);}
{LETTER}({LETTER}|{DIGIT}|_)*(_)				{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}
.								{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}

%%

