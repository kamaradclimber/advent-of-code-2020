# frozen_string_literal: true

require 'day15'

RSpec.describe Day15 do
  subject { described_class.new(input: input, part: part) }
  describe 'part 1' do
    let(:part) { 1 }
    {
      '0,3,6' => 436,
      '1,3,2' => 1,
      '2,1,3' => 10,
      '1,2,3' => 27,
      '2,3,1' => 78,
      '3,2,1' => 438,
      '3,1,2' => 1836
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
      '0,3,6' => 175594,
      '1,3,2' => 2578,
      '2,1,3' => 3544142,
      '1,2,3' => 261214,
      '2,3,1' => 6895259,
      '3,2,1' => 18,
      '3,1,2' => 362
    }.each do |example, solution|
      context "example #{example[0..15]}" do
        let(:input) { example }
        it "works on example #{example[0..15].gsub("\n", ', ')}" do
          expect(subject.solve).to eq(solution)
        end
      end
    end

    context 'real input' do
      pending 'finds a solution for part2' do
        solution = subject.solve
        puts "Solution for part 2 is #{solution}"
      end
    end
  end

  let(:input) do
    '7,14,0,17,11,1,2'
  end
end
