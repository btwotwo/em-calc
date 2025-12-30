# frozen_string_literal: true

require 'strscan'
require_relative 'tokenizer/errors'

module Calculator
  class Tokenizer
    OPERATORS = {
      /\+/ => TokenKind::PLUS,
      /-/ => TokenKind::MINUS,
      %r{/} => TokenKind::DIV,
      /\*/ => TokenKind::MUL,
      /\(/ => TokenKind::PAREN_OPEN,
      /\)/ => TokenKind::PAREN_CLOSE,
      /sqrt/ => TokenKind::SQRT
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
          tokens << Token::Literal.new(TokenKind::NUMBER, num.to_f)
          next
        end

        raise TokenizerParseError, scanner.pos
      end

      tokens
    end
  end
end
