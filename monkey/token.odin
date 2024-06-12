package monkey

TokenType :: enum {
	Illegal,
	Eof,
	Ident,
	Int,
	Assign,
	Plus,
	Comma,
	Semicolon,
	LParen,
	RParen,
	LBrace,
	RBrace,
	Fn,
	Let,
}

name_ttype :: proc(type: TokenType) -> string {
	switch type {
	case .Illegal:
		return "ILLEGAL"
	case .Eof:
		return "EOF"
	case .Ident:
		return "IDENT"
	case .Int:
		return "INT"
	case .Assign:
		return "="
	case .Plus:
		return "+"
	case .Comma:
		return ","
	case .Semicolon:
		return ";"
	case .LParen:
		return "("
	case .RParen:
		return ")"
	case .LBrace:
		return "{"
	case .RBrace:
		return "}"
	case .Fn:
		return "FN"
	case .Let:
		return "LET"
	}
	panic("invalid type")
}

Token :: struct {
	type:    TokenType,
	literal: string,
}

lookup_ident :: proc(ident: string) -> TokenType {
	switch ident {
	case "fn":
		return .Fn
	case "let":
		return .Let
	case:
		return .Ident
	}
}
