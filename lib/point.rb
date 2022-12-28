class Point
  attr_accessor :x, :y, :grid_char
  def initialize(x, y, c=nil)
    self.x = x
    self.y = y
    self.grid_char = c
  end

  def self.from_point(point)
    self.new(point.x, point.y, point.grid_char)
  end

  def ==(point)
    point&.x == self.x && point&.y == self.y
  end

  def eql?(point)
    self == point
  end

  def hash
    [self.x, self.y].hash
  end

  def add_vector(vector)
    self.class.new(self.x + vector.x, self.y + vector.y, self.grid_char)
  end

  def to_s
    "#{self.x},#{self.y}"
  end

end

Point::UP = Point.new(0, -1)
Point::DOWN = Point.new(0, 1)
Point::LEFT = Point.new(-1, 0)
Point::RIGHT = Point.new(1, 0)
