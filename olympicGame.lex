%{

#define TITLE 300
#define SPORT 301
#define YEARS 302
#define NAME 303
#define YEAR_NUM 304
#define COMMA 305
#define THROUGH 306
#define SINCE 307
#define ALL 308
#define CURRENTYEAR 2021
#include <string.h> 
#include <stdio.h>
#include <stdlib.h>

union {
  int ival;
  char name [30];
  char str [80];
} yylval;



extern int atoi (const char *);
%}

%option noyywrap

/* exclusive start condition -- deals with C++ style comments */ 
%x COMMENT

%%
[A-Z][a-z]+(" "[A-Z][a-z]+)* {strcpy (yylval.name, yytext); return TITLE; }	
189[2-9][\n]* { yylval.ival = atoi (yytext); return YEAR_NUM; }
[2-9][0-9][0-9][0-9]  { yylval.ival = atoi (yytext); return YEAR_NUM; }
19[0-9][0-9] { yylval.ival = atoi (yytext); return YEAR_NUM; }
2020 { yylval.ival = atoi(yytext)+1; return YEAR_NUM; }
"<sport>"  { strcpy (yylval.name, yytext); return SPORT; }
"<years>"	{ strcpy (yylval.name, yytext); return YEARS; }

\"[A-Z][a-z]+(" "[A-Z][a-z]+)*([A-Z][a-z]+)*\" { strcpy (yylval.str, yytext); return NAME; }
"," { strcpy (yylval.str, yytext); return COMMA; }
"since"   { strcpy (yylval.name, yytext); return SINCE; }
"all"   { strcpy (yylval.name, yytext); return ALL; }
"through"|[-]   { strcpy (yylval.name, yytext); return THROUGH; }

[\n\r] /*skip*/
[\t]	/*skip*/
[" "] /*skip spaces*/

.		{ fprintf(stderr,"unrecognized %c\n",yytext[0]);}

%%

int main (int argc, char **argv)
{
   int token;

   if (argc != 2) {
      fprintf(stderr, "Usage: mylex <input file name> \n");
      exit (1);
   }
	FILE *fp=fopen("result.txt","w");

   yyin = fopen (argv[1], "r");
	fprintf(fp,"TOKEN					LEXEME				SEMANTIC VALUE\n");	
	fprintf(fp,"--------------------------------------------------------------------------------------\n");	
	char str[30]="from until";
	char sign[30];
   while ((token = yylex ()) != 0)
   {
     switch (token) {
	 case TITLE: fprintf(fp,"TITLE:					%s					\n", yylval.name);
	              break;
	 case SPORT: fprintf (fp,"SPORT:					%s					\n", yylval.name);
	              break;
	 case YEARS: fprintf (fp,"YEARS:					%s 					\n", yylval.name);
	              break;
	 case NAME: fprintf (fp,"NAME:					%s					\n", yylval.str);
	              break;		  
	 case YEAR_NUM: 
	 if(yylval.ival==2020)
				 yylval.ival++;
							fprintf (fp,"YEAR_NUM:				%d\n", yylval.ival);
	              break;
	 case COMMA: fprintf (fp,"COMMA:					%s\n", yylval.str);
	              break;
	 case THROUGH: 
				strcpy(sign,yylval.name);
				strcpy(yylval.name,str);
							fprintf (fp,"THROUGH:				%s	  			%s \n",sign, yylval.name);
	             break;
	 case SINCE: fprintf (fp,"SINCE:					%s\n", yylval.name);
	              break;
	 case ALL: fprintf (fp,"ALL:					%s\n", yylval.name);
	              break;				  
         default:     fprintf (stderr, "error ... \n"); exit (1);
     } 
	 }
   fclose (yyin);
   exit (0);

}
