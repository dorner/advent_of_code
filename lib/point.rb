class Point
  attr_accessor :x, :y
  def initialize(x, y)
    self.x = x
    self.y = y
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
    Point.new(self.x + vector.x, self.y + vector.y)
  end

  def to_s
    "#{self.y},#{self.x}"
  end

end

Point::UP = Point.new(0, -1)
Point::DOWN = Point.new(0, 1)
Point::LEFT = Point.new(-1, 0)
Point::RIGHT = Point.new(1, 0)
