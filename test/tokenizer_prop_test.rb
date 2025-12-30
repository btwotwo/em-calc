# frozen_string_literal: true

require 'minitest'
require 'minitest/autorun'

require 'prop_check'

require_relative '../lib/calculator/'

module Calculator
  G = PropCheck::Generators
  OPERATOR_SYMBOLS = {
    TokenKind::PLUS => '+',
    TokenKind::MINUS => '-',
    TokenKind::DIV => '/',
    TokenKind::MUL => '*',
    TokenKind::PAREN_OPEN => '(',
    TokenKind::PAREN_CLOSE => ')'
  }.freeze
  
  describe Tokenizer do
    def convert_token(token)
      case token.kind
      when TokenKind::NUMBER
        token.value.to_s
      else
        OPERATOR_SYMBOLS.fetch(token.kind) do
          raise ArgumentError, "Unknown token encountered: #{token.inspect}"
        end
      end
    end

    def token_kind_generator
      tokens_gen = Tokenizer::OPERATORS.values.map do |type|
        G.constant(type)
      end

      G.one_of(*tokens_gen)
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
      G.instance(
        Token::Operator,
        kind: token_kind_generator
      )
    end

    def num_literal_generator
      G.instance(Token::Literal,
                 kind: G.constant(:number),
                 value: decimal_number_str_generator.map(&:to_f))
    end

    def tokens_generator
      G.array(G.one_of(operator_generator, num_literal_generator))
    end

    describe 'when given a random tokenized input converted to string' do
      it 'should be tokenized to the exact same input' do
        PropCheck.forall(tokens_generator) do |tokens|
          tokens_string = tokens.map { |token| convert_token(token) }.join(' ')
          tokenized_string = Tokenizer.call(tokens_string)

          _(tokenized_string).must_equal tokens
        end
      end
    end
  end
end
