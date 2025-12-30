module Calculator
  module Expression
    module Kind
      ADD = :add
      SUB = :sub
      MUL = :mul
      DIV = :div

      NEGATE = :negate

      NUMBER = :number
    end

    class Binary < Data.define(:kind, :left_expr, :right_expr)
      def evaluate
        case kind
        in Kind::ADD then left_expr.evaluate + right_expr.evaluate
        in Kind::SUB then left_expr.evaluate - right_expr.evaluate
        in Kind::MUL then left_expr.evaluate * right_expr.evaluate
        in Kind::DIV then left_expr.evaluate / right_expr.evaluate
        else
          raise ArgumentError, 'Invalid expression kind!'
        end
      end
    end

    class Unary < Data.define(:kind, :expr)
      def evaluate
        case kind
        in Kind::NEGATE then -expr.evaluate
        else
          raise ArgumentError, 'Invalid expression kind!'

        end
      end
    end

    class Literal < Data.define(:kind, :value)
      def evaluate
        case kind
        in Kind::NUMBER then value
        else
          raise ArgumentError, 'Invalid expression kind!'
        end
      end
    end

    class Group < Data.define(:expr)
      def evaluate
        expr.evaluate
      end
    end
  end
end
