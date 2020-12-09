# frozen_string_literal: true

require 'aoc'

class Day9 < Day
  def initialize(part:, input:, preamble_size: 25)
    super(part: part, input: input)
    @preamble_size = preamble_size
  end

  def solve_part1
    numbers = input.split("\n").map(&:to_i)
    preamble = numbers.take(@preamble_size)
    numbers = numbers.drop(@preamble_size)
    buffer = preamble
    numbers.find do |n|
      valid = buffer.combination(2).none? { |a, b| a + b == n }
      buffer.shift
      buffer << n
      valid
    end
  end

  def solve_part2
    weak_point = solve_part1
    numbers = input.split("\n").map(&:to_i)
    i = 0
    loop do
      j = i + 1
      set = Set.new
      sum = numbers[i] + numbers[j]
      set << numbers[i]
      set << numbers[j]
      while sum < weak_point
        j += 1
        sum += numbers[j]
        set << numbers[j]
      end
      return set.max + set.min if sum == weak_point

      i += 1
    end
  end
end
