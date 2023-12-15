require_relative '../lib/point'

NORTH = Point::UP
SOUTH = Point::DOWN
WEST = Point::LEFT
EAST = Point::RIGHT

NORTHWEST = NORTH.add_vector(WEST)
NORTHEAST = NORTH.add_vector(EAST)
SOUTHWEST = SOUTH.add_vector(WEST)
SOUTHEAST = SOUTH.add_vector(EAST)

ALL_DIRECTIONS = [NORTH, SOUTH, WEST, EAST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST]

class Grid
  def expandable?
    true
  end

  attr_accessor :pins

  def initialize(lines, pin_map)
    @pins = {}
    @pin_map = pin_map
    lines.each_with_index do |line, i|
      line.chars.each_with_index do |char, j|
        pin_value = pin_map[char]
        if pin_value
          @pins[pin_value] ||= {}
          @pins[pin_value][[j, i]] ||= []
          point = pin_value.new(j, i, char)
          @pins[pin_value][[j, i]] << point
        end
      end
    end
  end

  def move_pin(pin, x, y)
    set = @in_move ? @move_pins : @pins
    current_list = set.dig(pin.class, [pin.x, pin.y])
    pin_index = current_list&.index(pin)
    current_list.delete_at(pin_index) if pin_index
    pin.x = x
    pin.y = y
    set[pin.class] ||= {}
    set[pin.class][[x, y]] ||= []
    set[pin.class][[x, y]] << pin
  end

  def length
    self.max_y - self.min_y
  end

  def row_at(y)
    (self.min_x..self.max_x).map do |x|
      pin = self.pin_at(x, y)
      next pin if pin
      Point.new(x, y)
    end
  end

  def pin_at(x, y)
    @pins.each do |_, type_pins|
      loc_pins = type_pins[[x, y]]
      return loc_pins.first if loc_pins&.any?
    end
    nil
  end

  def pin_at_point(point, type)
    @pins[type][[point.x, point.y]]&.first
  end

  def pins_at(x, y)
    @pins.values.map { |pin| pin[[x, y]]}.flatten.compact
  end

  def pin_in_direction(point, direction, type)
    self.pin_at_point(point.add_vector(direction), type)
  end

  def pin_in_direction?(point, direction, type=nil)
    self.pin_at?(point.add_vector(direction), type)
  end

  def surrounding_pins(point, type=nil)
    ALL_DIRECTIONS.map { |vector|
      self.pin_at_point(point.add_vector(vector), type)
    }.compact
  end

  def pin_at?(point, type=nil)
    type = @pins.keys.first if type.nil?
    @pins[type][[point.x, point.y]]&.any?
  end

  def max_y
    return @max_y if @max_y
    val = @pins.values.map { |type_pins| type_pins.keys.map { |k| k[1]}}.flatten.max
    @max_y = val unless self.expandable?
    val
  end

  def max_x
    return @max_x if @max_x
    val = @pins.values.map { |type_pins| type_pins.keys.map { |k| k[0]}}.flatten.max
    @max_x = val unless self.expandable?
    val
  end

  def min_y
    return @min_y if @min_y
    val = @pins.values.map { |type_pins| type_pins.keys.map { |k| k[1]}}.flatten.min
    @min_y = val unless self.expandable?
    val
  end

  def min_x
    return @min_x if @min_x
    val = @pins.values.map { |type_pins| type_pins.keys.map { |k| k[0]}}.flatten.min
    @min_x = val unless self.expandable?
    val
  end

  def start_move
    @in_move = true
    @move_pins = @pins.to_h { |k, v| [k, v.deep_dup]}
  end

  def end_move
    @in_move = false
    @pins = @move_pins
  end

  def each_pin(type: nil)
    pins = type ? @pins[type] : @pins.values.flatten
    pins.values.flatten.each { |p| yield p }
  end

  def debug
    min_y = self.min_y
    max_y = self.max_y
    min_x = self.min_x
    max_x = self.max_x
    (min_y..max_y).each do |i|
      (min_x..max_x).each do |j|
        pins = self.pins_at(j, i)
        print pins.size > 1 ? pins.size : pins.first&.grid_char || '.'
      end
      puts ''
    end
    puts "\n\n"
  end

  def dup
    grid = super
    grid.pins = self.pins.to_h { |k, v| [k, v.deep_dup]}
    grid
  end
end
