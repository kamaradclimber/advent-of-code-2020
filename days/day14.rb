# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day14 < Day
  def solve_part1
    @memory = Hash.new(0)
    program = input.split("\n")

    program.each do |instruction|
      case instruction
      when /mask = (.+)/
        parse_mask(Regexp.last_match(1))
      when /mem\[(\d+)\] = (\d+)/
        @memory[Regexp.last_match(1).to_i] = mask_it(Regexp.last_match(2).to_i)
      else
        raise 'Invalid instruction'
      end
    end

    @memory.values.sum
  end

  def solve_part2
    @memory = Hash.new(0)
    program = input.split("\n")
    program.each do |instruction|
      case instruction
      when /mask = (.+)/
        parse_mask_part2(Regexp.last_match(1))
      when /mem\[(\d+)\] = (\d+)/
        # not correct here since we should iterate over all possible addresse not only the one initialized
        @memory.each_key do |address|
          @memory[address] = Regexp.last_match(2).to_i if mask_it_parse2(Regexp.last_match(1).to_i, address)
        end
      else
        raise 'Invalid instruction'
      end
    end

    @memory.values.sum
  end

  def parse_mask(mask)
    @clear = 0
    @set = 0
    mask.chars.reverse.each_with_index do |v, power|
      case v
      when 'X'
        # nothing, we keep the bit as is
      when '1'
        @set |= 1 << power
      when '0'
        @clear |= 1 << power
      end
    end
  end

  def parse_mask_part2(mask)
    @ignore = 0
    @set = 0
    mask.chars.reverse.each_with_index do |v, power|
      case v
      when 'X'
        @ignore |= 1 << power
      when '1'
        @set |= 1 << power
      when '0'
        # nothing, bits are kept
      end
    end
  end

  def mask_it_parse2(target_address, candidate_address)
    target_address |= @set
    target_address |= @ignore
    candidate_address |= @ignore
    target_address == candidate_address
  end

  def mask_it(value)
    debug "Value: #{value}"
    debug "Value b: #{value.to_s(2)}"
    debug "Set b:   #{@set.to_s(2)}"
    value |= @set
    debug "sets:    #{value.to_s(2)}"
    value &= ~@clear
    debug "clear:   #{value.to_s(2)}"
    debug "clearD:  #{value}"
    value
  end

  def debug(string)
    # puts string
  end
end
