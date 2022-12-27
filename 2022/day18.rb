require_relative '../lib/utils'
input = Utils.input

Cube = Struct.new(:x, :y, :z)

cubes = input.lines(chomp: true).map { |line| Cube.new(*line.split(',').map(&:to_i))}

max_x = 0
max_y = 0
max_z = 0

def next_coords(x, y, z)
  [
    [x+1, y, z],
    [x-1, y, z],
    [x, y-1, z],
    [x, y+1, z],
    [x, y, z+1],
    [x, y, z-1]
  ]
end

grid = {}
cubes.each do |cube|
  grid[cube.x] ||= {}
  grid[cube.x][cube.y] ||= {}
  grid[cube.x][cube.y][cube.z] = true
  max_x = [max_x, cube.x].max
  max_y = [max_y, cube.y].max
  max_z = [max_z, cube.z].max
end

sides = 0
grid.keys.each do |x|
  grid[x].keys.each do |y|
    grid[x][y].keys.each do |z|
      next_coords(x, y, z).each do |coord|
        sides += 1 if grid.dig(*coord).nil?
      end
    end
  end
end

puts sides

# part 2

@seen = {}

def find_pocket(grid, x, y, z, max_x, max_y, max_z, from_coords)
  if @seen.include?([x, y, z])
    return @seen[[x, y, z]]
  end
  if grid.dig(x, y, z)
    @seen[[x, y, z]] = true
    return true
  end
  if x == max_x || y == max_y || z == max_z || x == 0 || y == 0 || z == 0
    @seen[[x, y, z]] = false
    return false
  end
  result = next_coords(x, y, z).all? do |coord|
    next if from_coords == coord
    find_pocket(grid, coord[0], coord[1], coord[2], max_x, max_y, max_z, [x, y, z])
  end
  @seen[[x, y, z]] = result
  result
end

pockets = []
(1...max_x).each do |x|
  (1...max_y).each do |y|
    (1...max_z).each do |z|
      if !grid.dig(x, y, z) && find_pocket(grid, x, y, z, max_x, max_y, max_z, nil)
        pockets.push([x, y, z])
      end
    end
  end
end

pockets.each do |pocket|
  next_coords(*pocket).each do |coord|
    sides -= 1 if grid.dig(*coord)
  end
end

puts sides

