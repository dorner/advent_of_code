require_relative '../lib/utils'
input = Utils.input

start_string, procedures = input.split("\n\n")
start = []
start_string.lines.each do |line|
  next unless line.include?('[')
  crates = line.chars.
    to_a.
    each_slice(4).
    map do |slice|
    slice.join.scan(/[A-Z]/).first
  end
  crates.each_with_index do |crate, i|
    start[i] ||= []
    start[i].unshift(crate) if crate.present?
  end
end

Move = Struct.new(:num, :from, :to)

moves = procedures.lines.map do |line|
  Move.new(*line.scan(/\d+/))
end

# part 1

crates = start.deep_dup
moves.each do |move|
  (1..move.num.to_i).each do
    elem = crates[move.from.to_i - 1].pop
    crates[move.to.to_i - 1].push(elem)
  end
end

puts crates.map { |pos| pos.last }.join

# part 2
crates = start.deep_dup
moves.each do |move|
  elems = crates[move.from.to_i - 1].pop(move.num.to_i)
  crates[move.to.to_i - 1].push(*elems)
end

puts crates.map { |pos| pos.last }.join
