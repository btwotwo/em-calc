# frozen_string_literal: true

require_relative 'parser/expression'
require_relative 'parser/errors'

module Calculator
  # The parser is implemented using recursive descent approach.
  #
  # The following grammar was used:
  # expression      -> additive ;
  # additive        -> multiplicative ( ('+' | '-' ) multiplicative )* ;
  # multiplicative  -> unary ( ('*' | '/') unary )* ;
  # unary           -> "-" unary | function_call ;
  # function_call   -> Identifier "(" expression ")" | primary;
  # primary         -> NumberLiteral | "(" expression ")" ;
  class Parser
    # @param tokens [Array]
    def self.call(tokens)
      new(tokens).call
    end

    def initialize(tokens)
      @tokens = tokens
      @pos = 0
    end

    # @param tokens [Array]
    def call
      expr = expression
      raise ParserError, 'Extra tokens left in the expression!' unless eof?

      expr
    end

    private

    def expression
      parse_additive
    end

    def parse_additive
      left = parse_multiplicative
      while current_matches?(TokenKind::PLUS) || current_matches?(TokenKind::MINUS)
        token = consume_token
        operation_kind = case token.kind
                         in TokenKind::PLUS then Expression::Kind::ADD
                         in TokenKind::MINUS then Expression::Kind::SUB
                         end
        right = parse_multiplicative
        expr = Expression::Binary.new(operation_kind, left, right)

        left = expr
      end

      left
    end

    def parse_multiplicative
      left = parse_unary

      while current_matches?(TokenKind::DIV) || current_matches?(TokenKind::MUL)
        token = consume_token
        operation_kind = case token.kind
                         in TokenKind::DIV then Expression::Kind::DIV
                         in TokenKind::MUL then Expression::Kind::MUL
                         end
        right = parse_unary
        expr = Expression::Binary.new(operation_kind, left, right)
        left = expr
      end

      left
    end

    def parse_unary
      if current_matches?(TokenKind::MINUS)
        consume_token
        expr = parse_unary
        Expression::Unary.new(Expression::Kind::NEGATE, expr)
      else
        parse_function_call
      end
    end

    def parse_function_call
      if current_matches?(TokenKind::SQRT)
        consume_token
        if current_token.kind == TokenKind::PAREN_OPEN
          consume_token
          expr = expression

          raise ParserError, 'Unclosed paren in function call.' unless current_token.kind == TokenKind::PAREN_CLOSE

          consume_token

          Expression::Function.new(Expression::Kind::SQRT, expr)
        end
      else
        parse_primary
      end
    end

    def parse_primary
      raise ParserError, 'Encountered unfinished expression!' if eof?

      token = consume_token

      if token.kind == TokenKind::NUMBER
        Expression::Literal.new(Expression::Kind::NUMBER, token.value)
      elsif token.kind == TokenKind::PAREN_OPEN
        expr = expression
        raise ParserError, 'Encountered unclosed paren' if eof?

        next_token = consume_token
        raise ParserError, 'Encountered unclosed paren' unless next_token.kind == TokenKind::PAREN_CLOSE

        Expression::Group.new(expr)

      else
        raise ParserError, "Unexpected token #{token.inspect}"
      end
    end

    def current_matches?(token_kind)
      !eof? && current_token.kind == token_kind
    end

    def eof?
      @pos >= @tokens.length
    end

    def consume_token
      token = @tokens[@pos]
      @pos += 1
      token
    end

    def current_token
      @tokens[@pos]
    end
  end
end
