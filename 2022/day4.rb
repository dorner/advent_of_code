require_relative '../lib/utils'
input = Utils.input

def count_lines(input, method)
  total = 0
  input.lines.each do |line|
    first_range, second_range = line.split(',').map do |section|
      first, last = section.split('-')
      Range.new(first.to_i, last.to_i)
    end
    total += 1 if first_range.send(method, second_range) || second_range.send(method, first_range)
  end
  total
end

puts count_lines(input, :cover?)
puts count_lines(input, :overlaps?)
