%{
#include <stdio.h>

void yyerror(char *s) {
	printf("error: %s\n",s);
}

int yywrap(void) {
	return 1;
}
%}

%union {
  int integer;
  char * identifier;
}

%token <integer> INT
%token <identifier> IDENT
%token TYPE_INT

%%

S			: BLOC	
	{
		return(0);
	}
;

BLOC			: '{' '}'
			| '{' STATEMENT_LIST '}'
			| '{' DECLARATION_LIST '}'
			| '{' DECLARATION_LIST STATEMENT_LIST '}'

DECLARATION	: VARIABLE ';'

DECLARATION_LIST : DECLARATION
			| DECLARATION_LIST DECLARATION

STATEMENT	: ';'
			| ASSIGNMENT ';'

STATEMENT_LIST : STATEMENT
			| STATEMENT_LIST STATEMENT

VARIABLE	: TYPE_INT IDENT
	{
		declare_intvar($2);
	}


ASSIGNMENT	: IDENT '=' EXPRESSION
	{
		assign_intvar($1);
	}

EXPRESSION	: TERM
			| EXPRESSION '+' TERM 	
	{
		gen_op32('+');
	}
			| EXPRESSION '-' TERM 	
	{
		gen_op32('-');
	}
;

TERM			: FACTOR
			| TERM '*' FACTOR 	
	{
		gen_op32('*');
	}
			| TERM '/' FACTOR 	
	{
		gen_op32('/');
	}
;

FACTOR		: INT
	{
		gen_int($1);
	}
			| IDENT
	{
		gen_intvar($1);
	}
			| '(' EXPRESSION ')'
			| '-' FACTOR
	{
		gen_negative();
	}
;

%%
