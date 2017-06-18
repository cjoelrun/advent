#!/usr/bin/env ruby
require_relative './lib/puzzle'

STDIN.read.split("\n").each do |a|
  puts a
  puzzle = Puzzle.new(a)
  puts puzzle.directions
  puts puzzle.distance
end