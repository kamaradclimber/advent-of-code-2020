# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day11 < Day
  def occupied_at_stability(threshold_to_empty)
    grid = input.split("\n").map(&:chars)
    boat = nil
    new_boat = if part1?
                 Boat.new(grid)
               else
                 Part2Boat.new(grid)
               end
    while boat != new_boat
      boat = new_boat
      new_boat = boat.dup
      new_boat.for_each do |x, y|
        case new_boat.get(x, y)
        when 'L'
          new_boat.set(x, y, '#') if boat.neighbors(x, y).all? { |c| %(L .).include?(c) }
        when '#'
          new_boat.set(x, y, 'L') if boat.neighbors(x, y).count { |c| c == '#' } >= threshold_to_empty
        end
      end
    end
    new_boat.occupied_count
  end

  def solve_part1
    occupied_at_stability(4)
  end

  def solve_part2
    occupied_at_stability(5)
  end

  class Boat
    attr_reader :grid

    def initialize(grid)
      @grid = grid
    end

    def occupied_count
      occupied = 0
      for_each { |x, y| occupied += 1 if get(x, y) == '#' }
      occupied
    end

    def to_s
      grid.map(&:join).join("\n")
    end

    def for_each
      grid.each_with_index do |line, y|
        line.each_with_index do |_, x|
          yield [x, y]
        end
      end
    end

    def ==(other)
      other.is_a?(self.class) && @grid == other.grid
    end

    def dup
      new_grid = @grid.map(&:dup)
      self.class.new(new_grid)
    end

    def get(x, y)
      @grid[y][x]
    end

    def set(x, y, value)
      @grid[y][x] = value
    end

    def neighbors(x, y)
      [
        [x - 1, y], [x - 1, y - 1], [x - 1, y + 1],
        [x, y - 1], [x, y + 1],
        [x + 1, y - 1], [x + 1, y], [x + 1, y + 1]
      ].select { |a, b| a >= 0 && b >= 0 && a < grid.first.size && b < grid.size }
        .map { |a, b| get(a, b) }
    end
  end

  class Part2Boat < Boat
    def neighbors(x, y)
      neighbors_coords(x, y).map { |a, b| get(a, b) }
    end

    def dup
      new_grid = @grid.map(&:dup)
      duplicata = self.class.new(new_grid)
      duplicata.instance_variable_set(:@neighbors, @neighbors)
      duplicata
    end

    def neighbors_coords(x, y)
      @neighbors ||= {}
      @neighbors[y] ||= {}
      @neighbors[y][x] ||= []
      return @neighbors[y][x] if @neighbors[y][x].any?

      [
        [0, 1], [0, -1],
        [-1, -1], [-1, 0], [-1, 1],
        [1, -1], [1, 0], [1, 1]
      ].each do |delta_x, delta_y|
        @neighbors[y][x] << first_seat(x, y, delta_x, delta_y)
      end
      @neighbors[y][x].compact!
      @neighbors[y][x]
    end

    # return coordinates of first seat from x,y in a given direction given by delta_x, delta_y
    # return nil if there is no seat in that direction
    def first_seat(x, y, delta_x, delta_y)
      return nil unless x + delta_x >= 0 && y + delta_y >= 0 && x + delta_x < grid.first.size && y + delta_y < grid.size

      if %w[# L].include?(get(x + delta_x, y + delta_y))
        [x + delta_x, y + delta_y]
      else
        first_seat(x + delta_x, y + delta_y, delta_x, delta_y)
      end
    end
  end
end
