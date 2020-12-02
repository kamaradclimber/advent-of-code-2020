# frozen_string_literal: true

require 'aoc'

class Day2 < Day
  def solve_part1
    input.split("\n").count do |line|
      raise "Invalid line #{line}" unless line =~ /(\d+)-(\d+) (.): (.+)$/

      letter = Regexp.last_match(3)
      password = Regexp.last_match(4)
      count = password.chars.count(letter)
      (Regexp.last_match(1).to_i..Regexp.last_match(2).to_i).include?(count)
    end
  end

  def solve_part2
    input.split("\n").count do |line|
      raise "Invalid line #{line}" unless line =~ /(\d+)-(\d+) (.): (.+)$/

      letter = Regexp.last_match(3)
      password = Regexp.last_match(4)
      [Regexp.last_match(1).to_i, Regexp.last_match(2).to_i].one? do |pos|
        password[pos - 1] == letter
      end
    end
  end
end
