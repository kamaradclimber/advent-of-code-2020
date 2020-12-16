# frozen_string_literal: true

require 'aoc'
require 'pry'

class Day16 < Day
  def parse
    rule_section, my_ticket, nearby_tickets = input.split("\n\n")

    @rules = rule_section.split("\n").map do |rule|
      raise "Invalid rule #{rule}" unless rule =~ /(.+): (\d+)-(\d+) or (\d+)-(\d+)/

      acceptable_ranges = [(Regexp.last_match(2).to_i..Regexp.last_match(3).to_i),
                           (Regexp.last_match(4).to_i..Regexp.last_match(5).to_i)]
      [Regexp.last_match(1), acceptable_ranges]
    end.to_h

    @my_ticket = my_ticket.split("\n")[1].split(',').map(&:to_i)
    @tickets = nearby_tickets.split("\n").drop(1).map do |line|
      line.split(',').map(&:to_i)
    end
  end

  def solve_part1
    parse
    @tickets.map do |ticket|
      ticket.reject { |number| valid?(number) }
    end.flatten.compact.sum
  end

  def solve_part2
    parse

    # get a list of possible values
    @possible_names = @my_ticket.size.times.map do
      @rules.keys.dup
    end
    valid_tickets = @tickets.select { |t| ticket_valid?(t) }

    valid_tickets.each do |ticket|
      ticket.each_with_index do |number, field_index|
        @rules.each do |field_name, ranges|
          deduce(field_index, field_name) if ranges.none? { |r| r.include?(number) }
        end
      end
    end
    @possible_names.each_with_index do |names, index|
      case names.size
      when 0
        raise "Deduction contradictory for field #{index}"
      when 1
        # puts "Field #{index} is #{names.first}"
      else
        raise "We could not deduced field #{index}, remaining #{names.join(', ')}"
      end
    end

    @possible_names.each_with_index.map do |names, index|
      next unless names.first =~ /^departure/

      @my_ticket[index]
    end.compact.inject(&:*) || 0
  end

  def deduce(field_index, field_name)
    @possible_names[field_index] -= [field_name]
    # puts "Field #{field_index} cannot be #{field_name}, remaining possibility: #{@possible_names[field_index].join(', ')}"
    case @possible_names[field_index].size
    when 0
      raise "Impossible deduction for field #{field_index}"
    when 1
      known_field = @possible_names[field_index].first
      @possible_names.each_with_index do |names, index|
        next if index == field_index

        if names.include?(known_field)
          # puts "Rejecting #{field_name} on field #{index} because it is the only possibility for field #{field_index}"
          deduce(index, known_field)
        end
      end
    end
  end

  def ticket_valid?(ticket)
    ticket.all? { |number| valid?(number) }
  end

  def valid?(number)
    @rules.any? do |_, ranges|
      ranges.any? { |r| r.include?(number) }
    end
  end
end
