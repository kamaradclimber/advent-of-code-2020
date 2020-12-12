# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day12 < Day
  def solve_part1
    s = Ship.new
    input.split("\n").each do |instruction|
      s.act(instruction)
    end
    s.distance
  end

  def solve_part2
    s = Ship2.new
    input.split("\n").each do |instruction|
      s.act(instruction)
    end
    s.distance
  end

  class Ship
    def initialize
      @deg = 90
      @x = 0
      @y = 0
    end

    def to_s
      "#{@x} #{@y}, facing #{@deg}"
    end

    def distance
      @x.abs + @y.abs
    end

    def rotate(deg)
      @deg += deg
      @deg = @deg % 360
    end

    def act(instruction)
      case instruction
      when /R(\d+)/
        rotate(Regexp.last_match(1).to_i)
      when /L(\d+)/
        rotate(-Regexp.last_match(1).to_i)
      when /([A-Z])(\d+)/
        move(Regexp.last_match(1), Regexp.last_match(2).to_i)
      else
        raise "Unknown instruction: #{instruction}"
      end
    end

    def move(mov_dir, units)
      case mov_dir
      when 'N'
        @y += units
      when 'S'
        @y -= units
      when 'W'
        @x -= units
      when 'E'
        @x += units
      when 'F'
        move(direction, units)
      end
    end

    def direction
      { 0 => 'N', 90 => 'E', 180 => 'S', 270 => 'W' }[@deg]
    end
  end

  class Ship2
    def initialize
      @x = 0
      @y = 0
      @waypoint_rel_x = 10
      @waypoint_rel_y = 1
    end

    def act(instruction)
      case instruction
      when /N(\d+)/
        @waypoint_rel_y += Regexp.last_match(1).to_i
      when /S(\d+)/
        @waypoint_rel_y -= Regexp.last_match(1).to_i
      when /E(\d+)/
        @waypoint_rel_x += Regexp.last_match(1).to_i
      when /W(\d+)/
        @waypoint_rel_x -= Regexp.last_match(1).to_i
      when /F(\d+)/
        @x += @waypoint_rel_x * Regexp.last_match(1).to_i
        @y += @waypoint_rel_y * Regexp.last_match(1).to_i
      when /R(\d+)/
        (Regexp.last_match(1).to_i / 90).times do
          @waypoint_rel_x, @waypoint_rel_y = @waypoint_rel_y, -@waypoint_rel_x
        end
      when /L(\d+)/
        (Regexp.last_match(1).to_i / 90).times do
          @waypoint_rel_x, @waypoint_rel_y = -@waypoint_rel_y, @waypoint_rel_x
        end
      else
        raise "Unknown instruction: #{instruction}"
      end
    end

    def to_s
      "#{@x} #{@y}, waypoint relative pos: #{@waypoint_rel_x} #{@waypoint_rel_y}"
    end

    def distance
      @x.abs + @y.abs
    end
  end
end
