# frozen_string_literal: true

require 'aoc'

class Day3 < Day
  def solve_part1
    grid = input.split("\n").map(&:chars)
    count_for_slope(3, 1, grid)
  end

  def solve_part2
    grid = input.split("\n").map(&:chars)
    [
      [1, 1],
      [3, 1],
      [5, 1],
      [7, 1],
      [1, 2]
    ].map { |x, y| count_for_slope(x, y, grid) }.inject(1) { |a, b| a * b }
  end

  def count_for_slope(delta_x, delta_y, grid)
    y = 0
    x = 0

    trees = 0

    while y < grid.size - 1
      x += delta_x
      y += delta_y
      trees += 1 if grid[y][x % grid.first.size] == '#'
    end
    trees
  end
end
