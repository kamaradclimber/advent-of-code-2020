# frozen_string_literal: true

require 'aoc'

class Day1 < Day
  attr_reader :numbers

  def solve_part1
    @numbers = input.split("\n").map(&:to_i).sort
    find_sum(2020)
  end

  def find_sum(target)
    i = 0
    j = numbers.size - 1
    until numbers[i] + numbers[j] == target
      if numbers[i] + numbers[j] > target
        j -= 1
      elsif numbers[i] + numbers[j] < target
        i += 1
      end
      return if i == numbers.size || j == -1
    end
    numbers[i] * numbers[j]
  end

  def solve_part2
    @numbers = input.split("\n").map(&:to_i).sort

    third = numbers.find { |n| find_sum(2020 - n) }
    find_sum(2020 - third) * third
  end
end
