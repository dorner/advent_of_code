require_relative '../lib/point'

class Grid
  attr_accessor :start
  def initialize(lines, start_char=nil)
    @grid = []
    lines.each_with_index do |line, i|
      line.chars.each_with_index do |char, j|
        @grid[j] ||= []
        @grid[j][i] = Point.new(j, i, char)
        if start_char && char == start_char
          self.start = @grid[j][i]
        end
      end
    end
  end

  def each_row
    @grid.dup.each_with_index { |row, i| yield row, i }
  end

  def column_at(i)
    @grid.map { |row| row[i] }
  end

  def each_col
    (0..max_x).each { yield column_at(_1), _1 }
  end

  def add_row(i, row)
    @grid.insert(i, row.map.with_index { |c, j| Point.new(j, i, c)})
  end

  def add_col(j, col)
    @grid.each_with_index do |row, i|
      row.insert(i, Point.new(j, i, col[i]))
    end
  end

  def at(point_or_x, y=nil)
    point_x, point_y = y ? [point_or_x, y] : [point_or_x.x, point_or_x.y]
    return nil if point_x < min_x || point_x > max_x || point_y < min_y || point_y > max_y

    @grid.dig(point_x, point_y)
  end

  def in_dir(point, dir)
    self.at(point.add_vector(dir))
  end

  def max_x
    @grid[0].length
  end

  def max_y
    @grid.length
  end

  def min_y
    0
  end

  def min_x
    0
  end

  def debug
    min_y = self.min_y
    max_y = self.max_y
    min_x = self.min_x
    max_x = self.max_x
    (min_y..max_y).each do |i|
      (min_x..max_x).each do |j|
        print at(j, i)&.grid_char || ''
      end
      puts ''
    end
    puts "\n\n"
  end
end
