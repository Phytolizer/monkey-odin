package monkey

import "core:log"
import "core:strings"
import "core:unicode"

Lexer :: struct {
	input:         string,
	token_start:   int,
	position:      int,
	read_position: int,
	ch:            u8,
	ch_len:        int,
}

lexer_init :: proc(l: ^Lexer, input: string) {
	l.input = input
	l.token_start = 0
	l.position = 0
	l.read_position = 0
	lexer_read_char(l)
}

lexer_read_char :: proc(l: ^Lexer) {
	if l.read_position >= len(l.input) {
		l.ch = '\x00'
		l.ch_len = 0
	} else {
		l.ch = l.input[l.read_position]
	}
	l.position = l.read_position
	l.read_position += 1
}

lexer_make_token :: proc(l: ^Lexer, type: TokenType) -> Token {
	tok: Token
	tok.type = type
	tok.literal = lexer_current_literal(l)
	return tok
}

lexer_next_token :: proc(l: ^Lexer) -> Token {
	lexer_read_whitespace(l)
	l.token_start = l.position

	tok: Token

	switch l.ch {
	case '\x00':
		tok.type = .Eof
		tok.literal = ""
	case '=':
		lexer_read_char(l)
		tok = lexer_make_token(l, .Assign)
	case '+':
		lexer_read_char(l)
		tok = lexer_make_token(l, .Plus)
	case '(':
		lexer_read_char(l)
		tok = lexer_make_token(l, .LParen)
	case ')':
		lexer_read_char(l)
		tok = lexer_make_token(l, .RParen)
	case '{':
		lexer_read_char(l)
		tok = lexer_make_token(l, .LBrace)
	case '}':
		lexer_read_char(l)
		tok = lexer_make_token(l, .RBrace)
	case ',':
		lexer_read_char(l)
		tok = lexer_make_token(l, .Comma)
	case ';':
		lexer_read_char(l)
		tok = lexer_make_token(l, .Semicolon)
	case:
		if is_letter(l.ch) {
			lexer_read_identifier(l)
			tok = lexer_make_token(l, lookup_ident(lexer_current_literal(l)))
		} else if is_digit(l.ch) {
			lexer_read_number(l)
			tok = lexer_make_token(l, .Int)
		} else {
			lexer_read_char(l)
			tok = lexer_make_token(l, .Illegal)
		}
	}

	return tok
}

lexer_current_literal :: proc(l: ^Lexer) -> string {
	return l.input[l.token_start:l.position]
}

lexer_read_identifier :: proc(l: ^Lexer) {
	lexer_read_proc(l, is_letter)
}

lexer_read_whitespace :: proc(l: ^Lexer) {
	lexer_read_proc(l, is_space)
}

lexer_read_number :: proc(l: ^Lexer) {
	lexer_read_proc(l, is_digit)
}

lexer_read_proc :: proc(l: ^Lexer, p: proc(_: u8) -> bool) {
	for p(l.ch) {
		lexer_read_char(l)
	}
}

is_space :: proc(c: u8) -> bool {
	switch (c) {
	case ' ', '\r', '\n', '\t':
		return true
	case:
		return false
	}
}

is_letter :: proc(c: u8) -> bool {
	switch (c) {
	case 'a' ..= 'z', 'A' ..= 'Z', '_':
		return true
	case:
		return false
	}
}

is_digit :: proc(c: u8) -> bool {
	switch (c) {
	case '0' ..= '9':
		return true
	case:
		return false
	}
}
