# frozen_string_literal: true

require 'aoc'

class Day5 < Day
  # @param pass [String]
  # @return [Integer, Integer, Integer] [row, seat, seatid]
  def boarding_pass(string)
    seat_id = string.gsub(/(F|L)/, '0').gsub(/(B|R)/, '1').to_i(2)
    row, column = seat_id.divmod(8)

    # row & column seems useless in this problem!
    [row, column, seat_id]
  end

  def solve_part1
    input.split("\n").map { |pass| boarding_pass(pass)[2] }.max
  end

  def solve_part2
    all_seats = input.split("\n").map { |pass| boarding_pass(pass)[2] }.sort

    all_seats.each_cons(2).find do |seat_a, seat_b|
      seat_a != seat_b - 1
    end.first + 1
  end
end
