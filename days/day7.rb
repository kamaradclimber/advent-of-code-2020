# frozen_string_literal: true

require 'aoc'

class Day7 < Day
  TARGET = 'shiny gold'
  def solve_part1
    rules = parse_rules(input)

    possible_bags = Set.new
    solution_size = -1

    while possible_bags.size != solution_size
      solution_size = possible_bags.size
      rules.each do |container, contained_bags|
        possible_bags << container if contained_bags.keys.any? { |b| possible_bags.include?(b) || b == TARGET }
      end
    end
    puts possible_bags.to_a.join(', ')
    possible_bags.size
  end

  def solve_part2
    rules = parse_rules(input)
    counts = {}
    count_bags(TARGET, rules, counts)
  end

  def count_bags(bag, rules, counts)
    return counts[bag] if counts.key?(bag)

    count = rules[bag].map do |contained_bag, quantity|
      (1 + count_bags(contained_bag, rules, counts)) * quantity
    end.sum
    counts[bag] = count
    count
  end

  def parse_rules(input)
    rules = {}
    input.split("\n").each do |line|
      raise "Invalid line: #{line}" unless line =~ /(.+) bags contain (.+)\.$/

      container_bag = Regexp.last_match(1)
      raise "Multiple rules for #{container_bag}" if rules.key?(container_bag)

      rules[container_bag] = {}
      next if Regexp.last_match(2).strip == 'no other bags'

      Regexp.last_match(2).split(', ').each do |contained_bag|
        raise "Invalid contained bag: #{contained_bag}" unless contained_bag =~ /(\d+) (.+) bag(s)?/

        rules[container_bag][Regexp.last_match(2)] = Regexp.last_match(1).to_i
      end
    end
    rules
  end
end
