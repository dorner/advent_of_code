require_relative '../lib/utils'
require 'dijkstra'

input = Utils.lines
sample_input = Utils.lines(true)

def debug(grid)
  grid.each do |row|
    puts row.join('')
  end
end

def expand_grid(grid)
  grid.each do |row|
    row.fill('*') unless row.index('#')
  end

  (0..grid[0].length).each do |i|
    if grid.none? { |row| row[i] == '#'}
      grid.each { |row| row[i] = '*' }
    end
  end
end

def part1_distance(p1, p2)
  (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

def part2_distance(grid, p1, p2)
  distance_diff = 1
  curr = [p1[0], p1[1]]
  distance = 0
  while curr[0] > p2[0]
    curr[0] -= 1
    if grid[curr[0]][curr[1]] == '*'
      distance += distance_diff
    else
      distance += 1
    end
  end
  while curr[0] < p2[0]
    curr[0] += 1
    if grid[curr[0]][curr[1]] == '*'
      distance += distance_diff
    else
      distance += 1
    end
  end
  while curr[1] > p2[1]
    curr[1] -= 1
    if grid[curr[0]][curr[1]] == '*'
      distance += distance_diff
    else
      distance += 1
    end
  end
  while curr[1] < p2[1]
    curr[1] += 1
    if grid[curr[0]][curr[1]] == '*'
      distance += distance_diff
    else
      distance += 1
    end
  end
  distance
end

def setup_data(input)
  grid = input.map(&:chars)
  expand_grid(grid)
  galaxies = []
  grid.each_with_index do |row, i|
    row.each_with_index do |c, j|
      galaxies.push([i, j]) if c == '#'
    end
  end
  pairs = galaxies.combination(2).to_a
  [grid, pairs]
end

def part1(input)
  _, pairs = setup_data(input)
  pairs.map { |p| part1_distance(p[0], p[1])}.sum
end

def part2(input)
  grid, pairs = setup_data(input)
  distance_diff = 1_000_000
  edges = []
  grid.each_with_index do |row, i|
    row.each_with_index do |col, j|
      dist = col == '*' ? distance_diff : 1
      edges.push([[i, j], [i-1, j], dist]) if i > 0
      edges.push([[i, j], [i+1, j], dist]) if i < row.length
      edges.push([[i, j], [i, j-1], dist]) if j > 0
      edges.push([[i, j], [i, j+1], dist]) if j < col.length
    end
  end
  puts pairs.size
  pairs.map do |p|
    dist = Dijkstra.new(p[0], p[1], edges).cost
    puts "#{p[0].join(',')} to #{p[1].join(',')}: #{dist}"
    dist
  end.sum
end

puts part1(input)
puts part2(input)
