# frozen_string_literal: true

require 'strscan'
require_relative 'tokenizer/errors'

module Calculator
  class Tokenizer
    OPERATORS = {
      /\+/ => Token::Kind::PLUS,
      /-/ => Token::Kind::MINUS,
      %r{/} => Token::Kind::DIV,
      /\*/ => Token::Kind::MUL,
      /\(/ => Token::Kind::PAREN_OPEN,
      /\)/ => Token::Kind::PAREN_CLOSE,
      /sqrt/ => Token::Kind::SQRT
    }.freeze

    NUM_PATTERN = /\d+(\.\d+)?/.freeze

    def self.call(input)
      new(input).call
    end

    def initialize(input)
      @input = input
    end

    def call
      tokens = []
      scanner = StringScanner.new(@input)
      until scanner.eos?
        scanner.skip(/\s+/)
        next if scanner.eos?

        _, op = OPERATORS.find do |pattern, _op|
          scanner.scan(pattern)
        end

        if op
          tokens << Token::Operator.new(op)
          next
        end

        num = scanner.scan(NUM_PATTERN)

        if num
          tokens << Token::Literal.new(Token::Kind::NUMBER, num.to_f)
          next
        end

        raise TokenizerParseError, scanner.pos
      end

      tokens
    end
  end
end
