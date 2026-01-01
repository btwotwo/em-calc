# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/calculator'

module Calculator
  describe Parser do
    describe 'when given a valid' do
      it 'unary expression, it should return correct ast' do
        tokens = [
          Token::Operator.new(:minus),
          Token::Literal.new(:number, 1),
          Token::Operator.new(:plus),
          Token::Literal.new(:number, 2)
        ]

        expr = Parser.call(tokens)
        
        _(expr).must_equal Expression::Binary.new(
          :add,
          Expression::Unary.new(:negate, Expression::Literal.new(:number, 1)),
          Expression::Literal.new(:number, 2)
        )
      end
    end

    describe 'basic binary operation' do
      test_cases = [
        { token: Token::Kind::MUL, op: Expression::Kind::MUL },
        { token: Token::Kind::DIV, op: Expression::Kind::DIV },
        { token: Token::Kind::PLUS, op: Expression::Kind::ADD },
        { token: Token::Kind::MINUS, op: Expression::Kind::SUB }
      ]

      test_cases.each do |test_case|
        it "should correctly handle #{test_case[:token]}" do
          expr = Parser.call([
                               Token::Literal.new(:number, 1),
                               Token::Operator.new(test_case[:token]),
                               Token::Literal.new(:number, 2)
                             ])

          _(expr).must_equal Expression::Binary.new(
            test_case[:op],
            Expression::Literal.new(:number, 1),
            Expression::Literal.new(:number, 2)
          )
        end
      end
    end
  end
end
