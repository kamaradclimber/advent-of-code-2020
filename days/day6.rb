# frozen_string_literal: true

require 'aoc'

class Day6 < Day
  def solve_part1
    input.split("\n\n").map do |group|
      group.gsub("\n", '').chars.uniq.size
    end.sum
  end

  def solve_part2
    input.split("\n\n").map do |group|
      all_chars = group.gsub("\n", '').chars.uniq
      all_chars.select do |char|
        group.split("\n").all? do |line|
          line.chars.include?(char)
        end
      end.size
    end.sum
  end
end
