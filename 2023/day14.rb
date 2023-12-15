require_relative '../lib/utils'
input = Utils.lines
sample_input = Utils.lines(true)

def part1(input)
  sum = 0
  grid = input.map(&:chars)
  (0...grid[0].length).each do |x|
    curr_points = grid.length
    (0...grid.length).each do |y|
      ch = grid[y][x]
      case ch
      when '#'
        curr_points = grid.length - y - 1
      when 'O'
        sum += curr_points
        curr_points -= 1
      end
    end
  end
  sum
end

def move_rocks(grid, vector)
  if vector
end

def part2(input)

end

puts part1(input)
