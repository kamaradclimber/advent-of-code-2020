# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day4 < Day
  def solve_part1
    input
      .split("\n\n")
      .map { |blocks| Passeport.new(blocks) }
      .count(&:valid?)
  end

  def solve_part2
    input
      .split("\n\n")
      .map { |blocks| SeriousPasseport.new(blocks) }
      .count(&:valid?)
  end

  class Passeport
    def initialize(block)
      @h = block.split("\n").flat_map { |l| l.split(' ') }.map do |c|
        key, value = c.split(':')
        [key, value]
      end.to_h
    end

    def valid?
      %w[byr iyr eyr hgt hcl ecl pid].all? do |k|
        @h.key?(k)
      end
    end
  end

  class SeriousPasseport < Passeport
    def valid?
      return false unless super

      return false unless year_in?('byr', (1920..2002))
      return false unless year_in?('iyr', (2010..2020))
      return false unless year_in?('eyr', (2020..2030))

      return false unless valid_height?('hgt')

      return false unless @h['hcl'] =~ /^#(\h{6})$/
      return false unless %w[amb blu brn gry grn hzl oth].include? @h['ecl']

      return false unless @h['pid'] =~ /^(\d{9})$/

      true
    end

    private

    def valid_height?(field)
      return false unless @h[field] =~ /^(\d+)(in|cm)$/

      h = Regexp.last_match(1).to_i

      case Regexp.last_match(2)
      when 'cm'
        (150..193).include?(h)
      when 'in'
        (59..76).include?(h)
      end
    end

    def year_in?(field, range)
      @h[field].to_i.to_s == @h[field] && range.include?(@h[field].to_i)
    end
  end
end
