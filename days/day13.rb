# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day13 < Day
  def solve_part1
    lines = input.split("\n")
    earliest_timestamp = lines.first.to_i
    buses = lines[1].split(',').reject { |b| b == 'x' }.map(&:to_i)

    bus_to_take = buses.min_by { |bus| earliest_start(earliest_timestamp, bus) }
    (earliest_start(earliest_timestamp, bus_to_take) - earliest_timestamp) * bus_to_take
  end

  def earliest_start(now, bus)
    (now / bus + 1) * bus
  end

  # @return 1/a mod b
  # @raise RuntimeError if it's not possible
  def invmod(a, b)
    raise 'No inverse' unless a.gcd(b) == 1

    c = 1
    c += 1 while (c * a) % b != 1
    c
  end

  def solve_part2
    lines = input.split("\n")
    buses = lines.last.split(',').each_with_index.map do |b, i|
      next if b == 'x'

      [b.to_i, b.to_i - i]
    end.compact

    n = buses.map(&:first).inject(:*)

    series = buses.map do |m, r|
      nhat = n / m
      r * invmod(nhat, m) * nhat
    end

    series.sum % n
  end
end
