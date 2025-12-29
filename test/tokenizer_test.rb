# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/calculator'

module Calculator
  describe Tokenizer do
    before do
      @tokenizer = Calculator::Tokenizer.new
    end

    describe 'when given a valid string' do
      it 'should return a list of tokens' do
        tokens = @tokenizer.call('1 + 2')
        _(tokens).must_equal [
          Token::Literal.new(:number, 1),
          Token::Operator.new(:plus),
          Token::Literal.new(:number, 2)
        ]
      end
    end

    describe 'when valid string contains floating point number' do
      it 'should parse correct number' do
        tokens = @tokenizer.call('0 + 1.2')
        _(tokens).must_equal [
          Token::Literal.new(:number, 0),
          Token::Operator.new(:plus),
          Token::Literal.new(:number, 1.2)
        ]
      end

      it 'should fail on the incorrect number' do
        _ { @tokenizer.call('0+1.2.2') }.must_raise
      end
    end
  end
end
