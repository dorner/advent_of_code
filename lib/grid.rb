require_relative './point'

class Grid
  def initialize(lines, pin_map)
    @pins = {}
    @pin_map = pin_map
    @grid = {}
    lines.each_with_index do |line, i|
      line.chars.each_with_index do |char, j|
        pin_value = pin_map[char]
        if pin_value
          @pins[pin_map[char]] ||= Set.new
          point = pin_value.new(j, i)
          @pins[pin_map[char]].add(point)
        end
      end
    end
  end

  def pin_at?(point, direction, type=nil)
    type = @pins.keys.first if type.nil?
    @pins[type].include?(point.add_vector(direction))
  end

  def max_y
    @pins.values.map { |type| type.map(&:y)}.flatten.max
  end

  def max_x
    @pins.values.map { |type| type.map(&:x)}.flatten.max
  end

  def min_y
    @pins.values.map { |type| type.map(&:y)}.flatten.min
  end

  def min_x
    @pins.values.map { |type| type.map(&:x)}.flatten.min
  end

  def debug
    min_y = self.min_y
    max_y = self.max_y
    min_x = self.min_x
    max_x = self.max_x
    (min_y..max_y).each do |i|
      (min_x..max_x).each do |j|
        if @pins.none? { |key, vals|
          if vals.include?(Point.new(j, i))
            print @pin_map.key(key)
            true
          end
        }
          print '.'
        end
      end
      puts ''
    end
    puts "\n\n"
  end

end
