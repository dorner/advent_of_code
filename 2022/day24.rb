require_relative '../lib/utils'
require_relative '../lib/grid'

lines = Utils.lines

class Wall < Point; end
class Me < Point
  def grid_char; 'E'; end
end
class Endpoint < Point
  def grid_char
    '.'
  end
end

class Blizzard < Point
  attr_accessor :direction
  def initialize(x, y, char)
    super(x, y, char)
    self.direction = case char
                     when '>'
                       Point::RIGHT
                     when '<'
                       Point::LEFT
                     when '^'
                       Point::UP
                     when 'v'
                       Point::DOWN
                     end
  end

  def ==(other)
    super && other.class == self.class && other.direction == self.direction
  end

  def expandable?
    false
  end

end

$min_moves = 1_000_000

class Day24Grid < Grid
  attr_accessor :me, :endpoint, :current_move

  def expandable?; false; end

  def debug
    puts current_move
    super
  end

  def initialize(*args)
    super(*args)
    self.current_move = 1
  end

  def pin_me
    self.row_at(0).each do |point|
      unless point.is_a?(Wall)
        self.me = Me.from_point(point)
        self.move_pin(self.me, self.me.x, self.me.y)
      end
    end
  end

  def pin_end
    self.row_at(self.length - 1).each do |point|
      self.endpoint = Endpoint.from_point(point) unless point.is_a?(Wall)
    end
  end

  def reissue_blizzard(old_bliz, new_bliz)
    point = case old_bliz.direction
            when Point::UP
              Blizzard.new(new_bliz.x, self.max_y - 1, new_bliz.grid_char)
            when Point::DOWN
              Blizzard.new(new_bliz.x, self.min_y + 1, new_bliz.grid_char)
            when Point::LEFT
              Blizzard.new(self.max_x - 1, new_bliz.y, new_bliz.grid_char)
            when Point::RIGHT
              Blizzard.new(self.min_x + 1, new_bliz.y, new_bliz.grid_char)
            end
    self.move_pin(old_bliz, point.x, point.y)
  end

  def dup
    grid = super
    grid.me = self.pins[Me].values.flatten.last
    grid
  end
end

def possible_moves(grid)
  desired_x_dir = grid.me.x - grid.endpoint.x > 0 ? Point::LEFT : Point::RIGHT
  desired_y_dir = grid.me.y - grid.endpoint.y > 0 ? Point::UP : Point::DOWN
  moves = []
  directions = [desired_x_dir, desired_y_dir, Point::DOWN, Point::RIGHT, Point::UP, Point::LEFT].uniq
  directions.each do |dir|
    new_move = grid.me.add_vector(dir)
    next if new_move.x <= grid.min_x ||
      new_move.x >= grid.max_x ||
      new_move.y <= grid.min_y ||
      new_move.y >= grid.max_y

    moves.push(new_move) unless grid.pin_at(new_move.x, new_move.y)
  end
  moves
end

def perform_move(grid)
  puts grid.me
  return if grid.current_move > $min_moves

  if grid.me.x == grid.endpoint.x && grid.me.y == grid.endpoint.y
    $min_moves = [$min_moves, grid.current_move].min
    return
  end

  #  grid.debug

  grid.start_move
  grid.each_pin(type: Blizzard) do |blizzard|
    new_bliz = blizzard.add_vector(blizzard.direction)
    if grid.pin_at?(new_bliz, Wall)
      grid.reissue_blizzard(blizzard, new_bliz)
    else
      grid.move_pin(blizzard, new_bliz.x, new_bliz.y)
    end
  end
  grid.end_move
  moves = possible_moves(grid)
  moves.push(grid.me) if !grid.pin_at?(grid.me, Blizzard)
  if moves.size == 1
    new_grid = grid.dup
    new_grid.move_pin(new_grid.me, moves.first.x, moves.first.y)
    new_grid.current_move += 1
    return perform_move(new_grid)
  end
  moves.each do |move|
    new_grid = grid.dup
    new_grid.move_pin(new_grid.me, move.x, move.y)
    new_grid.current_move += 1
    perform_move(new_grid)
  end
end

pin_map = { '#' => Wall, '>' => Blizzard, '<' => Blizzard, '^' => Blizzard, 'v' => Blizzard, 'E' => Me }
grid = Day24Grid.new(lines, pin_map)
grid.pin_me
grid.pin_end

perform_move(grid)
puts $min_moves
