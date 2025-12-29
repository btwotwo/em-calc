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

    Binary = Data.define(:kind, :left_expr, :right_expr)
    Unary = Data.define(:kind, :expr)
    Literal = Data.define(:kind, :value)
    Group = Data.define(:expr)
  end
end
