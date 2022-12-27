require_relative '../lib/utils'
input = Utils.input

grid = input.lines(chomp: true).map { |row| row.chars.map(&:to_i)}

# part 1
def is_visible?(grid, i, j)
  height = grid[i][j]
  return true if (0...i).all? { |x| grid[x][j] < height }
  return true if (i+1..grid.length-1).all? { |x| grid[x][j] < height}
  return true if (0...j).all? { |x| grid[i][x] < height }
  return true if (j+1..grid[i].length-1).all? { |x| grid[i][x] < height }
  false
end

total = 0
grid.each_with_index do |row, i|
  row.each_with_index do |_, j|
    total += 1 if is_visible?(grid, i, j)
  end
end
puts total

# part 2

def top_score(grid, i, j, height)
  total = 0
  (0...j).to_a.reverse_each do |row|
    total += 1
    break if grid[i][row] >= height
  end
  total
end

def left_score(grid, i, j, height)
  total = 0
  (0...i).to_a.reverse_each do |col|
    total += 1
    break if grid[col][j] >= height
  end
  total
end

def bottom_score(grid, i, j, height)
  total = 0
  (i+1..grid.length-1).each do |row|
    total += 1
    break if grid[row][j] >= height
  end
  total
end

def right_score(grid, i, j, height)
  total = 0
  (j+1..grid[i].length-1).to_a.each do |col|
    total += 1
    break if grid[i][col] >= height
  end
  total
end

def scenic_score(grid, i, j)
  height = grid[i][j]
  top_score(grid, i, j, height) *
    left_score(grid, i, j, height) *
    right_score(grid, i, j, height) *
    bottom_score(grid, i, j, height)
end

max = 0
grid[1...grid.length-1].each_with_index do |row, i|
  row[1...grid[i].length-1].each_with_index do |_, j|
    max = [max, scenic_score(grid, i+1, j+1)].max
  end
end
puts max
