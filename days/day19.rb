# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day19 < Day
  def solve_part1
    rules, messages = input.split("\n\n")
    messages = messages.split("\n")

    rules = rules.split("\n").map do |line|
      id, rule = line.split(': ')
      [id.to_i, parse_rule(rule)]
    end.to_h
    # now we need to resolve rule ids
    rules.transform_values! do |rule|
      resolve(rules, rule)
    end

    messages.count do |message|
      rules[0].match(message)&.empty?
    end
  end

  def resolve(rules, rule)
    case rule
    when Integer
      rule = rules[rule]
    when ConcatRule
      rule.rule1 = rules[rule.rule1]
      rule.rule2 = rules[rule.rule2]
    when UnionRule
      rule.rule1 = resolve(rules, rule.rule1)
      rule.rule2 = resolve(rules, rule.rule2)
    end
    rule
  end

  def parse_rule(rule)
    case rule
    when /^(\d+)$/
      Regexp.last_match(1).to_i
    when /^"(.)"$/
      ExactRule.new.tap { |r| r.char = Regexp.last_match(1) }
    when /^(\d+) (\d+)$/
      ConcatRule.new.tap do |r|
        # ugly abuse of dynamic typing, we will resolve this after parsing all rules
        r.rule1 = Regexp.last_match(1).to_i
        r.rule2 = Regexp.last_match(2).to_i
      end
    when /^(.+) \| (.+)$/
      UnionRule.new.tap do |r|
        # ugly abuse of dynamic typing, we will resolve this after parsing all rules
        r.rule1 = parse_rule(Regexp.last_match(1))
        r.rule2 = parse_rule(Regexp.last_match(2))
      end
    else
      raise "Unparsable rule: '#{rule}'"
    end
  end

  class Rule
  end

  class ExactRule < Rule
    attr_accessor :char

    # @return [String] part of the string that was not matched
    #                  or nil/false if did not matched
    def match(string)
      string[1..] if string[0] == char
    end
  end

  class ConcatRule < Rule
    attr_accessor :rule1, :rule2

    def match(string)
      rem = rule1.match(string)
      return nil unless rem

      rem = rule2.match(rem)
      return nil unless rem

      rem
    end
  end

  class UnionRule < Rule
    attr_accessor :rule1, :rule2

    def match(string)
      rule1.match(string) || rule2.match(string)
    end
  end
end
