#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/calculator'

module Calculator
  if $PROGRAM_NAME == __FILE__
    input = readline(chomp: true)
    tokens = Tokenizer.new.call(input)
    puts tokens
  end
end
