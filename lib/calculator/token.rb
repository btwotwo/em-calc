# frozen_string_literal: true

module Calculator
  module TokenKind
    PLUS = :plus
    MINUS = :minus
    DIV = :div
    MUL = :mul
    PAREN_OPEN = :paren_open
    PAREN_CLOSE = :paren_close
    NUMBER = :number
  end

  module Token
    Operator = Data.define(:kind)
    Literal = Data.define(:kind, :value)
  end
end
