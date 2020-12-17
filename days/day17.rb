# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day17 < Day
  def solve_part1
    grid = Grid.new
    input.split("\n").each_with_index do |line, y|
      line.chars.each_with_index do |active, x|
        point = Point3D.new(x, y, 0)
        grid.active!(point) if active == '#'
      end
    end
    simulate_boot_sequence(grid)
  end

  def solve_part2
    grid = Grid.new
    input.split("\n").each_with_index do |line, y|
      line.chars.each_with_index do |active, x|
        point = Point4D.new(x, y, 0, 0)
        grid.active!(point) if active == '#'
      end
    end
    simulate_boot_sequence(grid)
  end

  def simulate_boot_sequence(grid)
    6.times do
      new_grid = Grid.new
      grid.relevant_points.each do |point|
        active_neighbors = point.neighbors_coords.count { |neighbor| grid.active?(neighbor) }
        if grid.active?(point)
          new_grid.active!(point) if (2..3).include?(active_neighbors)
        elsif active_neighbors == 3
          new_grid.active!(point)
        end
      end
      grid = new_grid
    end
    grid.active_count
  end

  class Point4D
    def initialize(x, y, z, t)
      @x = x
      @y = y
      @z = z
      @t = t
    end

    attr_reader :x, :y, :z, :t

    def ==(other)
      other.is_a?(self.class) && x == other.x && y == other.y && z == other.z && t == other.t
    end

    alias eql? ==

    def hash
      x
    end

    def neighbors_coords
      close_points = (t - 1..t + 1).map do |tp|
        (z - 1..z + 1).map do |zp|
          (y - 1..y + 1).map do |yp|
            (x - 1..x + 1).map do |xp|
              self.class.new(xp, yp, zp, tp)
            end
          end
        end
      end.flatten(3)
      close_points - [self]
    end
  end

  class Point3D
    def initialize(x, y, z)
      @x = x
      @y = y
      @z = z
    end

    attr_reader :x, :y, :z

    def ==(other)
      other.is_a?(self.class) && x == other.x && y == other.y && z == other.z
    end

    alias eql? ==

    def hash
      x
    end

    def neighbors_coords
      close_points = (z - 1..z + 1).map do |zp|
        (y - 1..y + 1).map do |yp|
          (x - 1..x + 1).map do |xp|
            self.class.new(xp, yp, zp)
          end
        end
      end.flatten(2)
      close_points - [self]
    end
  end

  class Grid
    def coords
      @grid.keys
    end

    def relevant_points
      (coords.flat_map(&:neighbors_coords) + coords).uniq
    end

    def initialize
      @grid = Hash.new(0)
    end

    def active?(point)
      @grid[point] == 1
    end

    def active!(point)
      @grid[point] = 1
    end

    def active_count
      @grid.size
    end
  end
end
