# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day18 < Day
  def solve_part1
    input.split("\n").map do |line|
      compute(line)
    end.sum
  end

  # rubocop:disable Style/PerlBackrefs
  def compute(line)
    case line
    when /^(\d+)$/
      $1.to_i
    when /^(.+) \+ (\d+)$/
      compute($1) + $2.to_i
    when /^(.+) \* (\d+)$/
      compute($1) * $2.to_i
    when /\)$/
      right_expr = find_right_parenthesis_group(line)
      reduction = compute(right_expr[1..-2])
      compute(line.gsub(right_expr, reduction.to_s))
    else
      raise NotImplementedError, "No parsing defined for: #{line}"
    end
  end
  # rubocop:enable Style/PerlBackrefs

  # this suppose this is well parenthesed
  def find_right_parenthesis_group(line)
    i = line.size - 2
    count = 1
    until count == 0
      case line[i]
      when ')'
        count += 1
      when '('
        count -= 1
      end
      i -= 1
    end
    line[i + 1..]
  end

  def solve_part2
    input.split("\n").map do |line|
      compute_part2(line)
    end.sum
  end

  # rubocop:disable Style/PerlBackrefs
  def compute_part2(line)
    case line
    when /^(\d+)$/
      $1.to_i
    when /^(\d+) \+ (\d+)(.*)/
      sum = ($1.to_i + $2.to_i).to_s
      compute_part2("#{sum}#{$3}")
    when /^(\d+) \* (.+)/
      $1.to_i * compute_part2($2)
    when /\(/
      # at least one parenthesed group
      compute_part2(reduction(line))
    else
      raise NotImplementedError, "No parsing defined for: #{line}"
    end
  end
  # rubocop:enable Style/PerlBackrefs

  def reduction(line)
    left = find_most_left_parenthesis(line)
    i = left + 1
    count = 1
    until count == 0
      case line[i]
      when '('
        count += 1
      when ')'
        count -= 1
      end
      i += 1
    end
    sub_line = line[left..i - 1]
    line.gsub(sub_line, compute_part2(sub_line[1..-2]).to_s)
  end

  def find_most_left_parenthesis(line)
    line.chars.find_index { |c| c == '(' }
  end
end
