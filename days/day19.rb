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
      rules[0].match(message, true)&.empty?
    end
  end

  def solve_part2
    @input = input
             .gsub(/\n8: 42\n/, "\n8: 42 | 42 8\n")
             .gsub(/\n11: 42 31\n/, "\n11: 42 31 | 42 11 31\n")
    solve_part1
  end

  def resolve(rules, rule)
    case rule
    when Integer
      rule = rules[rule]
    when ConcatRule
      rule.each_with_index do |r,i|
        rule[i] = resolve(rules, r)
      end
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
    when /^(.+) \| (.+)$/
      UnionRule.new.tap do |r|
        # ugly abuse of dynamic typing, we will resolve this after parsing all rules
        r.rule1 = parse_rule(Regexp.last_match(1))
        r.rule2 = parse_rule(Regexp.last_match(2))
      end
    when /^(.+)$/
      ConcatRule.new($1)
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
    def match(string, must_be_terminal)
      if string[0] == char
        return nil if !must_be_terminal && string.size == 1
        string[1..]
      else
        nil
      end
    end
  end

  class ConcatRule < Rule
    attr_accessor :rules

    def initialize(s)
      super()
      @rules = s.split(' ').map(&:to_i)
    end

    def [](i)
      @rules[i]
    end

    def []=(i,val)
      @rules[i] = val
    end

    def each_with_index(&block)
      @rules.each_with_index(&block)
    end

    def match(string, must_be_terminal)
      return nil if string == ""

      rem = string
      @rules.each_with_index do |r, i|
        binding.pry if $DEBUG
        rem = r.match(rem, must_be_terminal && (i == @rules.size - 1))
        return nil unless rem
      end
      rem
    end
  end

  class UnionRule < Rule
    attr_accessor :rule1, :rule2

    def match(string, must_be_terminal)
      return nil if string == ""

      rem1 = rule1.match(string, must_be_terminal)
      rem2 = rule2.match(string, must_be_terminal)

      #return rem2 unless rem1
      #return rem1 unless rem2
      if must_be_terminal
        if rem1 != '' && rem2 != ''
          return nil
        else
          ''
        end
      else
        [rem1,rem2] if rem1 && rem2
        rem1 || rem2
      end
      # from here, both rem are non empty
      # in part1 we can be greedy without any issue because there are no loops



    end
  end
end
