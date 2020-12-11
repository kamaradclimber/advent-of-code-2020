# frozen_string_literal: true

require 'aoc'

class Day11 < Day
  def solve_part1
    boat = input.split("\n").map(&:chars)

  end

  class Boat
    def initialize(grid)
      @grid = grid
    end

    def get(x,y)
      @grid[y][x]
    end

    def set(x,y, value)
      @grid[y][x] = value
    end

    def neighbors(x,y)
      [
        [x-1,y],[x-1,y-1],[x-1,y+1],
        [x,y-1],[x,y+1],
        [x+1,y-1],[x+1,y],[x+1,y+1]
      ].select { |a,b| a >= 0 && b >= 0 && a < grid.first.size && b < grid.size }
        .map { |a,b| get(a,b) }
    end
  end
end
