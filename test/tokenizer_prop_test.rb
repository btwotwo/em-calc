# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require 'prop_check'

require_relative '../src/tokenizer'

module Calculator
  G = PropCheck::Generators
  OPERATOR_SYMBOLS = Tokenizer::OPERATORS.invert

  describe Tokenizer do
    def convert_token(token)
      case token.type
      when TokenKind::NUMBER
        token.value.to_s
      else
        OPERATOR_SYMBOLS.fetch(token.type) do
          raise ArgumentError, "Unknown token encountered: #{token.inspect}"
        end
      end
    end

    def decimal_number_str_generator
      G.tuple(
        G.positive_integer,
        G.positive_integer
      )
       .map do |int_part, frac_part|
        "#{int_part}.#{frac_part}"
      end
    end

    def operator_generator
      G.one_of(*Tokenizer::OPERATORS.values.map { |type| G.constant(type) }).map { |op| Token::Operator.new(op) }
    end

    def num_literal_generator
      decimal_number_str_generator.map { |num_str| Token::Literal.new(:number, num_str.to_f) }
    end

    def tokens_generator
      G.array(G.one_of(operator_generator, num_literal_generator))
    end

    before do
      @tokenizer = Calculator::Tokenizer.new
    end

    describe 'when given a random tokenized input converted to string' do
      it 'should be tokenized to the exact same input' do
        PropCheck.forall(tokens_generator) do |tokens|
          tokens_string = tokens.map { |token| convert_token(token) }.join(' ')
          tokenized_string = @tokenizer.call(tokens_string)

          _(tokenized_string).must_equal tokens
        end
      end
    end
  end
end
