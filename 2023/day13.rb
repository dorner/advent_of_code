require_relative '../lib/utils'
input = Utils.lines
sample_input = Utils.lines(true)

Pattern = Struct.new(:rows, :cols) do
  def initialize(rows)
    self.rows = rows
    self.cols = Array.new(rows[0].length) { Array.new(rows.length) }
    rows.each_with_index do |row, i|
      row.each_with_index do |c, j|
        self.cols[j][i] = c
      end
    end
  end
end

def parse_patterns(input)
  patterns = []
  rows = []
  input.each do |line|
    if line == ""
      patterns.push(Pattern.new(rows))
      rows = []
    else
      rows.push(line.chars)
    end
  end
  patterns.push(Pattern.new(rows))
  patterns
end

def find_reflections(arr)
  reflections = []
  (0..arr.length-1).each do |i|
    reflections.push(i) if arr[i] == arr[i+1]
  end
  reflections
end

def reflection_extent(arr, reflection)
  return 0 if reflection.nil?

  curr_left = reflection
  curr_right = reflection + 1
  while true
    curr_left -= 1
    curr_right += 1
    return nil if arr[curr_left] != arr[curr_right]

    return reflection + 1 if curr_right == arr.length - 1 || curr_left == 0
  end
  nil
end

def part1(input)
  total = 0
  patterns = parse_patterns(input)
  patterns.each do |pattern|
    verticals = find_reflections(pattern.cols)
    num_verticals = verticals.map { |r| reflection_extent(pattern.cols, r) }.compact.sum
    horiz = find_reflections(pattern.rows)
    num_horiz = horiz.map { |r| reflection_extent(pattern.rows, r) }.compact.sum

    puts "Horiz #{horiz} num_horiz #{num_horiz} vert #{verticals} num_vert #{num_verticals}"
    puts pattern.rows.map { |r| r.join('')}
    puts
    puts pattern.rows.transpose.map { |r| r.join('')}

    total += (num_horiz * 100) + num_verticals
  end
  total
end

def part2(input)

end

puts part1(input)
