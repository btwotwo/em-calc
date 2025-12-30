# frozen_string_literal: true

require 'prop_check'
require_relative '../lib/calculator'
require_relative 'utils'
module Calculator
  G = PropCheck::Generators

  describe Parser do
    def expression_leaf_generator
      G.instance(Expression::Literal, kind: G.constant(:number), value: G.real_positive_float)
    end

    def unary_kind_gen
      G.one_of(
        G.constant(Expression::Kind::NEGATE)
      )
    end

    def binary_kind_gen
      G.one_of(
        G.constant(Expression::Kind::ADD),
        G.constant(Expression::Kind::SUB),
        G.constant(Expression::Kind::MUL),
        G.constant(Expression::Kind::DIV)
      )
    end

    def expression_generator
      G.tree(expression_leaf_generator) do |subtree_gen|
        G.one_of(
          G.instance(Expression::Binary, kind: binary_kind_gen, left_expr: subtree_gen, right_expr: subtree_gen),
          G.instance(Expression::Unary, kind: unary_kind_gen, expr: subtree_gen),
          G.instance(Expression::Group, expr: subtree_gen)
        )
      end
    end

    it 'test' do
      PropCheck.forall(expression_generator) do |expr|
        tokens = expr.to_tokens
        parsed_expr = Parser.call(tokens)

        _(parsed_expr).must_equal expr
      end
    end
  end
end
