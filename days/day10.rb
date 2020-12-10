# frozen_string_literal: true

require 'aoc'

class Day10 < Day
  def solve_part1
    chargers = input.split("\n").map(&:to_i).sort

    builtin = chargers.max + 3

    chargers << builtin

    current_jolt = 0
    differences = chargers.map do |charger|
      difference = charger - current_jolt
      raise "Cannot move from #{current_jolt} to #{charger}" if difference > 3

      current_jolt = charger
      difference
    end.tally
    differences[1] * differences[3]
  end

  def solve_part2
    chargers = input.split("\n").map(&:to_i).sort
    builtin = chargers.max + 3

    to_test = []
    to_test << chargers
    valid_combinations = 0
    puts "Min size #{builtin / 3}"
    while to_test.any?
      puts "Combinaisons to test #{to_test.size}, size #{to_test.first.size}"
      next_to_test = Set.new
      to_test
        .select { |subset| find_path(0, subset, builtin) }
        .tap { |subsets| valid_combinations += subsets.size }
        .each do |subset|
        children(subset).to_a.each do |s|
          next_to_test << s
        end
      end
      to_test = next_to_test
    end
    valid_combinations
  end

  def children(chargers)
    chargers.combination(chargers.size - 1)
  end

  # return [FalseClass] false if there is no path with those chargers
  def find_path(start, chargers, builtin)
    chargers = chargers.dup
    current_jolt = start
    chargers << builtin
    chargers.sort.each do |charger|
      difference = charger - current_jolt
      return false if difference > 3
      current_jolt = charger
    end
    true
  end
end
