require_relative '../lib/utils'
input = Utils.lines
sample_input = Utils.lines(true)

def hash_func(str)
  total = 0
  str.chars.each do |c|
    total = (total + c.ord) * 17 % 256
  end
  total
end

def part1(input)
  input.first.split(',').map { |c| hash_func(c)}.sum
end

Lens = Struct.new(:label, :focal_length)

def focal_power(box, i)
  box_num = i + 1
  total = 0
  box.each_with_index do |lens, j|
    total += box_num * (j + 1) * lens.focal_length
  end
  total
end

def part2(input)
  steps = input.first.split(',')
  boxes = Array.new(256) { [] }
  steps.each do |step|
    _, label, operation, length = step.match(/(.*)([=-])(\d*)/).to_a
    box = hash_func(label)
    if operation == '='
      existing = boxes[box].find { |b| b.label == label }
      if existing
        existing.focal_length = length.to_i
      else
        boxes[box].push(Lens.new(label, length.to_i))
      end
    else
      boxes[box].delete_if { |l| l.label == label }
    end
  end
  total = 0
  boxes.each_with_index do |box, i|
    total += focal_power(box, i)
  end
  total
end

puts part1(input)
puts part2(input)
