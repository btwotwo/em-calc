# frozen_string_literal: true

require_relative 'tokenizer/errors'

module Calculator
  class Tokenizer
    OPERATORS = {
      '+' => TokenKind::PLUS,
      '-' => TokenKind::MINUS,
      '/' => TokenKind::DIV,
      '*' => TokenKind::MUL,
      '(' => TokenKind::PAREN_OPEN,
      ')' => TokenKind::PAREN_CLOSE
    }.freeze

    # @param input [String]
    def call(input)
      i = 0
      tokens = []
      while i < input.length
        char = input[i]
        if char == ' '
          i += 1
          next
        end

        token, chars_consumed = get_token(char, i, input)
        tokens << token

        i += chars_consumed
      end

      tokens
    end

    private

    def get_token(char, pos, input)
      sym = OPERATORS[char]
      if sym
        [Token::Operator.new(sym), 1]
      elsif numeric?(char)
        number, chars_consumed = parse_number(pos, input)
        [Token::Literal.new(TokenKind::NUMBER, number), chars_consumed]
      else
        raise TokenizerParseError, pos
      end
    end

    # @param input [String]
    # @return [Float, Integer] the parsed number and the amount of tokens consumed
    def parse_number(num_start, input)
      num_end = scan_number_end(num_start, input)

      [input[num_start..num_end].to_f, num_end - num_start + 1]
    end

    def scan_number_end(num_start, input)
      pos = num_start
      num_end = num_start

      seen_dot = false

      while pos < input.length
        ch = input[pos]
        if dot?(ch)
          raise TokenizerParseError, pos, "Invalid dot at #{pos}" if seen_dot

          seen_dot = true
        elsif !numeric?(ch)
          break
        end

        num_end = pos
        pos += 1
      end

      num_end
    end

    def numeric?(char)
      char =~ /[0-9]/
    end

    def dot?(char)
      char == '.'
    end
  end
end
