#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'tokenizer'

module Calculator
  if $PROGRAM_NAME == __FILE__
    input = readline(chomp: true)
    tokens = Tokenizer.new.call(input)
    puts tokens
  end
end
