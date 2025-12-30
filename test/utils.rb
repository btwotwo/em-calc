module Calculator
  module Expression
    class Binary
      def to_tokens
        operator_kind = case kind
                        in Expression::Kind::MUL then TokenKind::MUL
                        in Expression::Kind::DIV then TokenKind::DIV
                        in Expression::Kind::SUB then TokenKind::MINUS
                        in Expression::Kind::ADD then TokenKind::PLUS
                        end
        [
          *left_expr.to_tokens,
          Token::Operator.new(operator_kind),
          *right_expr.to_tokens
        ]
      end
    end

    class Unary
      def to_tokens
        [
          Token::Operator.new(TokenKind::MINUS),
          *expr.to_tokens
        ]
      end
    end

    class Literal
      def to_tokens
        [
          Token::Literal.new(kind: TokenKind::NUMBER, value: value)
        ]
      end
    end

    class Group
      def to_tokens
        [
          Token::Operator.new(TokenKind::PAREN_OPEN),
          expr.to_tokens,
          Token::Operator.new(TokenKind::PAREN_CLOSE)
        ]
      end
    end
  end
end
