# frozen_string_literal: true

require 'day13'

RSpec.describe Day13 do
  subject { described_class.new(input: input, part: part) }
  describe 'part 1' do
    let(:part) { 1 }
    {
      '939
7,13,x,x,59,x,31,19' => 295
    }.each do |example, solution|
      context "example #{example[0..15]}" do
        let(:input) { example }
        it "works on example #{example[0..15].gsub("\n", ', ')}" do
          expect(subject.solve).to eq(solution)
        end
      end
    end

    context 'real input' do
      it 'finds a solution for part1' do
        solution = subject.solve
        puts "Solution for part 1 is #{solution}"
      end
    end
  end

  describe 'part 2' do
    let(:part) { 2 }
    {
      '7,13,x,x,59,x,31,19' => 1068781,
      '17,x,13,19' => 3417,
      '67,7,59,61' => 754018,
      '67,x,7,59,61' => 779210,
      '67,7,x,59,61' => 1261476,
      '1789,37,47,1889' => 1202161486
    }.each do |example, solution|
      context "example #{example[0..15]}" do
        let(:input) { example }
        it "works on example #{example[0..15].gsub("\n", ', ')}" do
          expect(subject.solve).to eq(solution)
        end
      end
    end

    context 'real input' do
      it 'finds a solution for part2' do
        solution = subject.solve
        puts "Solution for part 2 is #{solution}"
      end
    end
  end

  let(:input) do
    %(1000510
19,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,523,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,17,13,x,x,x,x,x,x,x,x,x,x,29,x,853,x,x,x,x,x,37,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,23) # rubocop:disable Layout/LineLength
  end
end
