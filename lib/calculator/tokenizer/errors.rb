module Calculator
  class Tokenizer
    class TokenizerParseError < StandardError
      attr_reader :position

      def initialize(position, msg = "Invalid character at #{position}")
        @position = position
        super
      end
    end
  end
end
