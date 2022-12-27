require_relative '../lib/utils'
input = Utils.input
map, instructions = input.split("\n\n")
grid = map.lines(chomp: true).map(&:chars)
max_length = grid.map { |row| row.length}.max

# pad with empty spaces to make logic simpler when traversing
grid.unshift(Array.new(max_length) { ' ' })
grid.each_with_index do |row, i|
  row.unshift(' ')
  if row.length < max_length
    row.concat(Array.new(max_length - row.length) { ' ' })
  end
  row.push(' ')
end
grid.push(Array.new(max_length) { ' ' })

row_starts = {}
row_ends = {}
col_starts = {}
col_ends = {}

grid.each_with_index do |row, i|
  row.each_with_index do |col, j|
    if col != ' ' && row[j-1] == ' '
      row_starts[i] = j
    end
    if col == ' ' && row[j-1] != ' '
      row_ends[i] = j - 1
    end
  end
end

grid[0].each_with_index do |_, j|
  grid.each_with_index do |_, i|
    if grid[i][j] != ' ' && grid[i-1][j] == ' '
      col_starts[j] = i
    end
    if grid[i][j] == ' ' && grid[i-1][j] != ' '
      col_ends[j] = i - 1
    end
  end
end

def debug(grid, moves)
  grid.each_with_index do |row, i|
    new_row = row.dup
    moves.keys.each_with_index do |pos|
      if pos[0] == i
        new_row[pos[1]] = moves[pos] % 10
      end
    end
    puts "#{i} #{new_row.join('')}"
  end
end

instructions = instructions.scan(/(\d+)([LR])/).flatten

LEFT = [0, -1]
RIGHT = [0, 1]
DOWN = [1, 0]
UP = [-1, 0]

def next_facing(facing, instruction)
  if instruction == 'R'
    case facing
    when LEFT
      UP
    when UP
      RIGHT
    when RIGHT
      DOWN
    when DOWN
      LEFT
    end
  else
    case facing
    when LEFT
      DOWN
    when DOWN
      RIGHT
    when RIGHT
      UP
    when UP
      LEFT
    end
  end
end

position = [1, grid[1].index { |c| c == '.' }]
facing = RIGHT

def wrap(col_starts, col_ends, row_starts, row_ends, y, x)
  orig_y = y
  orig_x = x
  if col_starts[x] && y == col_starts[x] - 1
    y = col_ends[x]
  end
  if col_ends[x] && x != 0 && y == col_ends[x] + 1
    y = col_starts[x]
  end
  if row_starts[y] && y == 0 || x == row_starts[y] - 1
    x = row_ends[y]
  end
  if row_ends[y] && y != 0 && x == row_ends[y] + 1
    x = row_starts[y]
  end
  if orig_y != y || orig_x != x
    puts "Wrapping #{orig_y}, #{orig_x} to #{y}, #{x}"
  end
  [y, x]
end

def name(facing)
  case facing
  when RIGHT
    '>'
  when LEFT
    '<'
  when UP
    '^'
  when DOWN
    'v'
  end
end

moves = {}
move = 1
instructions.each do |inst|
  if %w(L R).include?(inst)
    facing = next_facing(facing, inst)
  else
    puts "#{move} #{name(facing)} #{inst}"
    num = inst.to_i
    (1..num).each do
      next_pos = [position[0] + facing[0], position[1] + facing[1]]
      next_pos = wrap(col_starts, col_ends, row_starts, row_ends, next_pos[0], next_pos[1])
      next_char = grid[next_pos[0]][next_pos[1]]
      if next_char == '#'
        puts "Hit rock at #{next_pos}"
        break
      end
      moves[position] = name(facing)
      position = next_pos
    end
    move += 1
    moves[position] = '*'
    puts "now at #{position}"
    #                debug(grid, moves)

  end
end
#debug(grid, moves)

def score(direction)
  case direction
  when RIGHT
    0
  when DOWN
    1
  when LEFT
    2
  when UP
    3
  end
end

puts (1000 * position[0]) + (4 * position[1]) + score(facing)
