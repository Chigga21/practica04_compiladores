#include <stdio.h>

#include "scanner.h"

extern int yylex(void);

int main(void)
{
	int token;
	int has_errors = 0;

	while ((token = yylex()) != TOK_EOF) {
		printf("[%s:%s]\n", scanner_token_name(token), scanner_token_lexeme());
		if (token == TOK_ERROR) {
			has_errors = 1;
		}
	}

	return has_errors;
}

const char *scanner_token_name(int token)
{
	switch (token) {
		case TOK_EOF:   return "EOF";
		case TOK_ERROR: return "ERROR";
		case TOK_KW_THEOREM: return "KW_THEOREM";
		case TOK_KW_PROOF: return "KW_PROOF";
		case TOK_KW_THEREFORE: return "KW_THEREFORE";
		case TOK_KW_QED: return "KW_QED";
		case TOK_KW_LET: return "KW_LET";
		case TOK_KW_EXISTS: return "KW_EXISTS";
		case TOK_KW_DATA: return "KW_DATA";
		case TOK_KW_ABSURD: return "KW_ABSURD";
		case TOK_KW_IF: return "KW_IF";
		case TOK_KW_ELSE: return "KW_ELSE";
		case TOK_KW_WHILE: return "KW_WHILE";
		case TOK_KW_FORALL: return "KW_FORALL";
		case TOK_KW_IN: return "KW_IN";
		case TOK_KW_STEP: return "KW_STEP";
		case TOK_KW_MATCH: return "KW_MATCH";
		case TOK_KW_CASE: return "KW_CASE";
		case TOK_KW_BREAK: return "KW_BREAK";
		case TOK_KW_LEFT: return "KW_LEFT";
		case TOK_KW_RIGHT: return "KW_RIGHT";
		case TOK_TYPE_INT: return "TYPE_INT";
		case TOK_TYPE_FLOAT: return "TYPE_FLOAT";
		case TOK_TYPE_BOOL: return "TYPE_BOOL";
		case TOK_TYPE_CHAR: return "TYPE_CHAR";
		case TOK_TYPE_STRING: return "TYPE_STRING";
		case TOK_TYPE_ARRAY: return "TYPE_ARRAY";
		case TOK_TYPE_TRUE: return "TYPE_TRUE";
		case TOK_TYPE_FALSE: return "TYPE_FALSE";
		case TOK_NATIVE_PRINT: return "NATIVE_PRINT";
		case TOK_NATIVE_LEN: return "NATIVE_LEN";
		case TOK_NATIVE_PUSH: return "NATIVE_PUSH";
		case TOK_NATIVE_COPY: return "NATIVE_COPY";
		case TOK_NATIVE_TOFLOAT: return "NATIVE_TOFLOAT";
		case TOK_NATIVE_TOINT: return "NATIVE_TOINT";
		case TOK_IDENTIFIER: return "IDENTIFIER";
		case TOK_WILDCARD: return "WILDCARD";
		case TOK_INT_LITERAL: return "INT_LITERAL";
		case TOK_FLOAT_LITERAL: return "FLOAT_LITERAL";
		case TOK_BOOL_LITERAL: return "BOOL_LITERAL";
		case TOK_CHAR_LITERAL: return "CHAR_LITERAL";
		case TOK_STRING_LITERAL: return "STRING_LITERAL";
		case TOK_PLUS: return "PLUS";
		case TOK_MINUS: return "MINUS";
		case TOK_MUL: return "MUL";
		case TOK_DIV: return "DIV";
		case TOK_MOD: return "MOD";
		case TOK_SHL: return "SHL";
		case TOK_SHR: return "SHR";
		case TOK_BIT_AND: return "BIT_AND";
		case TOK_BIT_OR: return "BIT_OR";
		case TOK_BIT_XOR: return "BIT_XOR";
		case TOK_BIT_NOT: return "BIT_NOT";
		case TOK_AND: return "AND";
		case TOK_OR: return "OR";
		case TOK_NOT: return "NOT";
		case TOK_EQ: return "EQ";
		case TOK_NEQ: return "NEQ";
		case TOK_LT: return "LT";
		case TOK_LE: return "LE";
		case TOK_GT: return "GT";
		case TOK_GE: return "GE";
		case TOK_ASSIGN: return "ASSIGN";
		case TOK_ARROW: return "ARROW";
		case TOK_COLON: return "COLON";
		case TOK_DOT: return "DOT";
		case TOK_COMMA: return "COMMA";
		case TOK_SEMICOLON: return "SEMICOLON";
		case TOK_LPAREN: return "LPAREN";
		case TOK_RPAREN: return "RPAREN";
		case TOK_LBRACE: return "LBRACE";
		case TOK_RBRACE: return "RBRACE";
		case TOK_LBRACKET: return "LBRACKET";
		case TOK_RBRACKET: return "RBRACKET";
		default: return "UNKNOWN";
	}
}
