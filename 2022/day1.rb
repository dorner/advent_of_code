require_relative '../lib/utils'
input = Utils.input

elves = input.split("\n\n").map { |elf| elf.split("\n")}
totals = elves.map { |e| e.map(&:to_i).sum}
puts totals.max

# part 2

puts totals.sort.reverse[0..2].sum
