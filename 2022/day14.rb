require_relative '../lib/utils'
input = Utils.input

class Grid
  MIN_X = 300
  MIN_Y = 0
  MAX_X = 900
  MAX_Y = 164

  attr_accessor :resting

  def initialize(lines, stop_at_max=true)
    @stop_at_max = stop_at_max
    @grid = (MIN_X..MAX_X).map { |x| [x, (MIN_Y..MAX_Y).map { '.'}] }.to_h
    lines.each do |line|
      positions = line.split(' -> ')
      positions[1..].each_with_index do |pos, i|
        x, y = pos.split(',')
        old_x, old_y = positions[i].split(',')
        add_line(old_x.to_i, x.to_i, old_y.to_i, y.to_i)
      end
    end
  end

  def add_line(x1, x2, y1, y2)
    if x1 == x2
      y_range = y1 < y2 ? (y1..y2) : (y2..y1)
      y_range.each do |y|
        @grid[x1][y] = '#'
      end
    else
      x_range = x1 < x2 ? (x1..x2) : (x2..x1)
      x_range.each do |x|
        @grid[x][y1] = '#'
      end
    end
  end

  def start
    @resting = 0
    ret_val = nil
    while ret_val != 'DONE'
      ret_val = move(500, 0)
    end
  end

  def move(i, j)
    if @stop_at_max && j >= MAX_Y
      return 'DONE'
    elsif !@stop_at_max && i == 500 && j == 0 && @grid[i][j] != '.'
      return 'DONE'
    end
    moves = [
      [i, j+1],
      [i-1, j+1],
      [i+1, j+1]
    ]
    moves.each do |mx, my|
      if @grid[mx][my] == '.'
        return move(mx, my)
      end
    end
    @resting += 1
    @grid[i][j] = 'o'
  end
end

lines = input.lines(chomp: true)

# part 1
grid = Grid.new(lines)
grid.start
puts grid.resting

# part 2
lines += ["#{Grid::MIN_X},#{Grid::MAX_Y+1} -> #{Grid::MAX_X},#{Grid::MAX_Y+1}"]
grid = Grid.new(lines, false)
grid.start
puts grid.resting
