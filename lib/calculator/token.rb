# frozen_string_literal: true

module Calculator
  module Token
    module Kind
      PLUS = :plus
      MINUS = :minus
      DIV = :div
      MUL = :mul
      PAREN_OPEN = :paren_open
      PAREN_CLOSE = :paren_close
      NUMBER = :number
      SQRT = :sqrt
    end

    Operator = Data.define(:kind)
    Literal = Data.define(:kind, :value)
  end
end
