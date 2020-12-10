# frozen_string_literal: true

require 'aoc'
require 'pry'

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

    diffs = ([0] + chargers + [builtin]).each_cons(2).map { |a, b| b - a }
    # ugly move to string to make a simple split. There is surely an enumerable method for this
    subsequences_combinations = diffs.join.split('3').map { |el| el.chars.map(&:to_i) }.map do |sub|
      next 1 if sub.size < 2

      # TODO: we shoudll not have to convert back to numbers (the
      # subsequences could be refactored to deal with diffs only)
      sequence = (sub + [3]).inject([0]) { |mem, el| mem + [mem.last + el] }
      start = sequence.first
      last = sequence.last
      subsub = sequence[1..sequence.size - 2]
      subsequences(start, subsub, last)
    end
    subsequences_combinations.inject(1) { |mem, el| mem * el }
  end

  # non optimimed version of part2
  def subsequences(start, sub, last)
    to_test = []
    to_test << sub
    valid_combinations = 0
    while to_test.any?
      next_to_test = Set.new
      to_test
        .select { |subset| find_path(start, subset, last) }
        .tap { |subsets| valid_combinations += subsets.size }
        .each do |subset|
        subset.combination(subset.size - 1).to_a.each do |s|
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
