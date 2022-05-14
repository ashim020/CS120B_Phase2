    /* cs152-miniL phase2 */
%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *msg);
extern int currLine;
extern int currPos;
FILE * yyin;
%}

%union{
  /* put your types here */
  char * identVal;
  int numVal;
}

%error-verbose
%start program
%token FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE ASSIGN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET RETURN MULT DIV MOD ADD SUB LT LTE GT GTE EQ NEQ NOT AND OR ENUM
%token <identVal> IDENT
%token <numVal> NUMBER
%locations

/* %start program */

%% 

  /* write your rules here */
program:	  functions	{printf("program->functions\n");}
		| error		{yyerrok; yyclearin;}
		;
functions:	  			{printf("functions->epsilon\n");}
		| function functions	{printf("functions->functions functions\n");}
		;
function:	  FUNCTION ident SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY
				{printf("function->FUNCTION ident SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY\n");}
		;
declarations:						{printf("declarations->epsilon\n");}
		| declaration SEMICOLON declarations	{printf("declarations->declaration SEMICOLON declarations\n");}
		| declaration error			{yyerrok;}
		;
declaration:	  identifiers COLON INTEGER							{printf("declaration->identifiers COLON INTEGER\n");}
		| identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER	
				{printf("declaration->identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n", $5);}
		| identifiers COLON ENUM L_PAREN identifiers R_PAREN
				{printf("declaration->identifiers COLON ENUM L_PAREN identifiers R_PAREN\n", $5);}
		;
identifiers:	  ident				{printf("identifiers->ident\n");}
		| ident COMMA identifiers	{printf("identifiers->ident COMMA identifiers\n");}
		;
ident:		  IDENT		{printf("ident->IDENT\n", $1);}
		;
statements:	  statement SEMICOLON statements	{printf("statements->statement SEMICOLON statements\n");}
		| statement SEMICOLON			{printf("statements->statement SEMICOLON\n");}
		| statement error			{yyerrok;}
		;
statement:	  svar		{printf("statements->svar\n");}
		| sif		{printf("statements->sif\n");}
		| swhile	{printf("statements->swhile\n");}
		| sdo		{printf("statements->sdo\n");}
		| sfor		{printf("statements->sfor\n");}
		| sread		{printf("statements->sread\n");}
		| swrite	{printf("statements->swrite\n");}
		| scontinue	{printf("statements->scontinue\n");}
		| sreturn	{printf("statements->sreturn\n");}
		;
svar:		  var ASSIGN expression		{printf("svar->var ASSIGN expression\n");}
		;
sif:		  IF bool_expr THEN statements ENDIF			{printf("sif->IF bool_expr THEN statements ENDIF\n");}
		| IF bool_expr THEN statements ELSE statements ENDIF	{printf("sif->IF bool_expr THEN statements ELSE statements ENDIF\n");}
		;
swhile:		  WHILE bool_expr BEGINLOOP statements ENDLOOP		{printf("swhile->WHILE bool_expr BEGINLOOP statements ENDLOOP\n");}
		;
sdo:		  DO BEGINLOOP statements ENDLOOP WHILE bool_expr	{printf("sdo->DO BEGINLOOP statements ENDLOOP WHILE bool_expr\n");}
		;
varLoop:	  			{printf("varLoop->epsilon\n");}
		| COMMA var varLoop	{printf("varLoop->COMMA var varLoop\n");}
		;
sread:		  READ var varLoop	{printf("sread->READ var varLoop");}
		;
swrite:		  WRITE var varLoop	{printf("swrite->WRITE var varLoop");}
		;
scontinue:	  CONTINUE		{printf("scontinue->CONTINUE");}
		;
sreturn:	  RETURN expression	{printf("sreturn->RETURN expression");}
		;
bool_expr:	  relation_&_expr			{printf("bool_expr->relation_&_expr\n");}
		| bool_expr OR relation_&_expr		{printf("bool_expr->bool_expr OR relation_&_expr\n");}
		;
relation_&_expr:  rel_expr_cond				{printf("relation_&_expr->rel_expr_cond\n");}
		| relation_&_expr AND rel_expr_cond	{printf("relation_&_expr->relation_&_expr AND rel_expr_cond\n");}
		;
rel_expr_cond:	  relation_expr			{printf("rel_expr_cond->relation_expr\n");}
		| NOT relation_expr		{printf("rel_expr_cond->NOT relation_expr\n");}
relation_expr:	  ece				{printf("relation_expr->ece\n");}
		| TRUE				{printf("relation_expr->TRUE\n");}
		| FALSE				{printf("relation_expr->FALSE\n");}
		| L_PAREN bool_expr R_PAREN	{printf("relation_expr->L_PAREN bool_expr R_PAREN\n");}
		;
ece:		  expression comp expression	{printf("ece->expression comp expression"\n");}
		;
comp:		  EQ	{printf("comp->EQ\n");}
		| NEQ	{printf("comp->NEQ\n");}
		| LT	{printf("comp->LT\n");}
		| GT	{printf("comp->GT\n");}
		| LTE	{printf("comp->LTE\n");}
		| GTE	{printf("comp->GTE\n");}
		;
expression:	  multi_expr addSubExpr		{printf("expression->multi_expr addSubExpr\n");}
		| error				{yyerrok;}
		;
addSubExpr:					{printf("addSubExpr->epsilon\n");}
		| ADD expression		{printf("addSubExpr->ADD expression\n");}
		| SUB expression		{printf("addSubExpr->SUB expression\n");}
		;
multi_expr:	  term				{printf("multi_expr->term\n");}
		| term MULT multi_expr		{printf("multi_expr->term MULT multi_expr\n");}
		| term DIV multi_expr		{printf("multi_expr->term DIV multi_expr\n");}
		| term MOD multi_expr		{printf("multi_expr->term MOD multi_expr\n");}
		;
term:		  SUB var						{printf("term->SUB var\n");}
		| var							{printf("term->var\n");}
		| SUB NUMBER						{printf("term->SUB NUMBER %d\n", $2);}
		| NUMBER						{printf("term->NUMBER %d\n", $1);}
		| SUB L_PAREN expression R_PAREN			{printf("term->SUB L_PAREN expression R_PAREN\n");}
		| L_PAREN expression R_PAREN				{printf("term->L_PAREN expression R_PAREN\n");}
		| ident L_PAREN expression expressionLoop R_PAREN	{printf("term->ident L_PAREN expression expressionLoop R_PAREN\n");}
		;
expressionLoop:   					{printf("expressionLoop->epsilon\n");}
	      	| COMMA expression expressionLoop	{printf("exprssionLoop->COMMA expression expressionLoop\n");}
		;
var:		  ident							{printf("var->ident\n");}
		| ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET	{printf("var->ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET");}
		;
%% 

int main(int argc, char **argv) {
   if(argc >= 2) {
      yyin = fopen(argv[1], "r");
      if(yyin == NULL) {
         yyin = stdin;
      }
   } else {
      yyin = stdin;
   }
   yyparse();
   return 1;
}

void yyerror(const char *msg) {
    /* implement your error handling */
    printf("Error: On line %d, column %d: %s \n", currLine, currPos, msg);
}
