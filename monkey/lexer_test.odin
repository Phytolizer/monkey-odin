package monkey

import "core:log"
import "core:testing"

@(test)
next_token :: proc(t: ^testing.T) {
	input :: `let five = 5;
let ten = 10;

let add = fn(x, y) {
  x + y;
};

let result = add(five, ten);
`
	TestCase :: struct {
		expected_type:    TokenType,
		expected_literal: string,
	}
	tests :: [?]TestCase {
		TestCase{.Let, "let"},
		TestCase{.Ident, "five"},
		TestCase{.Assign, "="},
		TestCase{.Int, "5"},
		TestCase{.Semicolon, ";"},
		TestCase{.Let, "let"},
		TestCase{.Ident, "ten"},
		TestCase{.Assign, "="},
		TestCase{.Int, "10"},
		TestCase{.Semicolon, ";"},
		TestCase{.Let, "let"},
		TestCase{.Ident, "add"},
		TestCase{.Assign, "="},
		TestCase{.Fn, "fn"},
		TestCase{.LParen, "("},
		TestCase{.Ident, "x"},
		TestCase{.Comma, ","},
		TestCase{.Ident, "y"},
		TestCase{.RParen, ")"},
		TestCase{.LBrace, "{"},
		TestCase{.Ident, "x"},
		TestCase{.Plus, "+"},
		TestCase{.Ident, "y"},
		TestCase{.Semicolon, ";"},
		TestCase{.RBrace, "}"},
		TestCase{.Semicolon, ";"},
		TestCase{.Let, "let"},
		TestCase{.Ident, "result"},
		TestCase{.Assign, "="},
		TestCase{.Ident, "add"},
		TestCase{.LParen, "("},
		TestCase{.Ident, "five"},
		TestCase{.Comma, ","},
		TestCase{.Ident, "ten"},
		TestCase{.RParen, ")"},
		TestCase{.Semicolon, ";"},
		TestCase{.Eof, ""},
	}

	l: Lexer
	lexer_init(&l, input)

	context.logger.lowest_level = .Debug
	for tt, i in tests {
		tok := lexer_next_token(&l)

		log.infof("tests[%d] - %v = %v", i, tok, tt)
		if !testing.expectf(
			t,
			tok.type == tt.expected_type,
			"tests[%d] - tokentype wrong. expected=%q, got=%q",
			i,
			name_ttype(tt.expected_type),
			name_ttype(tok.type),
		) {
			return
		}
		if !testing.expectf(
			t,
			tok.literal == tt.expected_literal,
			"tests[%d] - literal wrong. expected=%q, got=%q",
			i,
			tt.expected_literal,
			tok.literal,
		) {
			return
		}
	}
}
