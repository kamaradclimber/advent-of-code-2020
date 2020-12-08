# frozen_string_literal: true

require 'aoc'

class Day8 < Day
  def solve_part1
    sequence = BootSequence.new(input)
    begin
      sequence.run
    rescue BootSequence::InfiniteLoop
      return sequence.acc
    end
    raise 'The boot sequence does not have an infinite loop'
  end

  def solve_part2
    sequence = nil
    input.split("\n").size.times do |i|
      sequence = BootSequence.new(input)
      begin
        sequence.mutate(i)
        sequence.run
        break
      rescue BootSequence::ImmutableInstruction, BootSequence::InfiniteLoop
        # move to next mutation
      end
    end
    sequence.acc
  end

  class BootSequence
    class InfiniteLoop < RuntimeError; end

    class ImmutableInstruction < RuntimeError; end

    attr_reader :pos, :acc, :instructions

    def initialize(instructions)
      @pos = 0
      @acc = 0
      @instructions = instructions.split("\n")
      @executed = Set.new
    end

    def mutate(mutate_pos)
      instructions[mutate_pos] = case instructions[mutate_pos]
                                 when /jmp (.+)/
                                   'nop'
                                 when /nop (.+)/
                                   "jmp #{Regexp.last_match(1)}"
                                 else
                                   raise ImmutableInstruction
                                 end
    end

    # @return [TrueClass, FalseClass] true if we should stop because program terminate
    # @raise [InfiniteLoop] if an infinite loop is detected
    def one_step
      line = instructions[pos]
      @executed << pos
      case line
      when /acc (-|\+)(\d+)/
        @acc += parse_signed(Regexp.last_match(1), Regexp.last_match(2))
        @pos += 1
      when /jmp (-|\+)(\d+)/
        @pos += parse_signed(Regexp.last_match(1), Regexp.last_match(2))
      when /nop/
        @pos += 1
      else
        raise "Unknown instruction: #{line}"
      end
      raise InfiniteLoop if @executed.include?(pos)

      # detect end of program
      pos >= @instructions.size
    end

    def parse_signed(sign, string)
      if sign == '+'
        string.to_i
      else
        -string.to_i
      end
    end

    def run
      loop do
        break if one_step
      end
      acc
    end
  end
end
