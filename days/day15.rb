# frozen_string_literal: true

require 'aoc'

class Day15 < Day
  def solve_part1
    solve_part(2020)
  end

  def solve_part2
    solve_part(30000000)
  end

  def solve_part(nth)
    # store "number" => "turns they were spoken"
    @spoken_numbers = {}
    @last_spoken = nil
    input.split(',').map(&:to_i).each_with_index do |number, turn|
      speak(number, turn)
      @last_spoken = number
    end
    turn = input.split(',').size
    while turn < nth
      @last_spoken = if @spoken_numbers[@last_spoken].size == 1
                       0
                     else
                       @spoken_numbers[@last_spoken][-1] - @spoken_numbers[@last_spoken][-2]
                     end
      speak(@last_spoken, turn)
      turn += 1
    end

    @last_spoken
  end

  def speak(number, turn)
    @spoken_numbers[number] ||= []
    @spoken_numbers[number] << turn
    @spoken_numbers[number] = @spoken_numbers[number].last(2)
  end
end
