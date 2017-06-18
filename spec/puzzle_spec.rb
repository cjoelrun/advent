require 'spec_helper'
require_relative '../lib/puzzle'

describe Puzzle do

  it 'should parse directions correctly' do
    puzzle = Puzzle.new('R4, R3, R5, L3, L10')
    expected = [['R', 4], ['R', 3], ['R', 5], ['L', 3], ['L', 10]]
    puzzle.directions.zip(expected).each do |actual, expected|
      expect(actual.direction).to eq expected[0]
      expect(actual.distance).to eq expected[1]
    end
  end

  [
      ['R2, L3', 5],
      ['R2, R2, R2', 2],
      ['R5, L5, R5, R3', 12],
      ['R1, L1', 2],
      ['L1, L1', 2],
      ['L1, R1', 2],
      ['R1, R1', 2]
  ].each do |document, distance|
    describe "Given the document #{document}" do
      it "returns the correct distance of #{distance}" do
        puzzle = Puzzle.new(document)
        #puts "#{puzzle.location} hi\n"
        expect(puzzle.distance).to eq(distance)
      end
    end
  end

  [
      ['R1', :EAST],
      ['R1, R1', :SOUTH],
      ['R1, R1, R1', :WEST],
      ['R1, R1, R1, R1', :NORTH],
      ['R1, R1, R1, R1, R1, ', :EAST],
  ].each do |document, heading|
    describe "Give the document #{document}" do
      it 'should calculate headings corrections' do
        puzzle = Puzzle.new(document)
        #puts "#{puzzle.location} hi\n"
        expect(puzzle.heading).to eq(heading)
      end
    end
  end

  it 'should raise DirectionError when given bad direction' do
    expect { Puzzle.new('U1') }.to raise_error(DirectionError)
  end

end
