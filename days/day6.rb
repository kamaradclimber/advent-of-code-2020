# frozen_string_literal: true

require 'aoc'

module CharSet
  refine String do
    # uniq chars from a string without \n
    def char_set
      gsub("\n", '').chars.uniq
    end
  end
end

class Day6 < Day
  using CharSet
  def solve_part1
    groups.map(&:char_set).map(&:size).sum
  end

  def solve_part2
    groups.map do |group|
      forms = group.split("\n").map(&:chars)
      group.char_set.select do |char|
        forms.all? { |answers| answers.include?(char) }
      end.size
    end.sum
  end

  def groups
    input.split("\n\n")
  end
end
