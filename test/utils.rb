module Calculator
  module Expression
    class Binary
      def to_tokens
        operator_kind = case kind
                        in Expression::Kind::MUL then Token::Kind::MUL
                        in Expression::Kind::DIV then Token::Kind::DIV
                        in Expression::Kind::SUB then Token::Kind::MINUS
                        in Expression::Kind::ADD then Token::Kind::PLUS
                        end
        [
          Token::Operator.new(Token::Kind::PAREN_OPEN),
          *left_expr.to_tokens,
          Token::Operator.new(operator_kind),
          *right_expr.to_tokens,
          Token::Operator.new(Token::Kind::PAREN_CLOSE)
        ]
      end
    end

    class Unary
      def to_tokens
        [
          Token::Operator.new(Token::Kind::MINUS),
          Token::Operator.new(Token::Kind::PAREN_OPEN),
          *expr.to_tokens,
          Token::Operator.new(Token::Kind::PAREN_CLOSE)
        ]
      end
    end

    class Literal
      def to_tokens
        [
          Token::Literal.new(kind: Token::Kind::NUMBER, value: value)
        ]
      end
    end

    class Group
      def to_tokens
        [
          Token::Operator.new(Token::Kind::PAREN_OPEN),
          *expr.to_tokens,
          Token::Operator.new(Token::Kind::PAREN_CLOSE)
        ]
      end
    end

    class Function
      def to_tokens
        [
          Token::Operator.new(Token::Kind::SQRT), # Only sqrt for now
          Token::Operator.new(Token::Kind::PAREN_OPEN),
          *expr.to_tokens,
          Token::Operator.new(Token::Kind::PAREN_CLOSE)
        ]
      end
    end
  end
end
