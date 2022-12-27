require_relative '../lib/utils'
input = Utils.input
class Pos
  attr_accessor :x, :y, :pos
  def initialize(name)
    @name = name
    @x = 0
    @y = 0
  end

  def to_s
    "(#{@name}: #{@x},#{@y})"
  end

  def to_a
    [@x, @y]
  end
end

VECTOR_FROM_DIRECTION = {
  'D' => [0, 1],
  'U' => [0, -1],
  'L' => [-1, 0],
  'R' => [1, 0]
}

def add_vector(current, new)
  current.x += new[0]
  current.y += new[1]
end

def touching?(head, tail)
  (head.x - tail.x).abs <= 1 && (head.y - tail.y).abs <= 1
end

def catch_up(head, tail)
  return if touching?(head, tail)
  if (head.x - tail.x).abs >= 1 && (head.y - tail.y).abs >= 1 # diagonal
    tail.y -= 1 if tail.y - head.y > 0
    tail.x -= 1 if tail.x - head.x > 0
    tail.y += 1 if head.y - tail.y > 0
    tail.x += 1 if head.x - tail.x > 0
  elsif (head.x - tail.x).abs >= 1 || (head.y - tail.y).abs >= 1
    tail.y -= 1 if tail.y - head.y > 1
    tail.x -= 1 if tail.x - head.x > 1
    tail.y += 1 if head.y - tail.y > 1
    tail.x += 1 if head.x - tail.x > 1
  end
end

def perform(input, head, tails)
  visited = Set.new
  visited.add([0, 0])
  input.lines.each do |move|
    direction, num = move.split(' ')
    (1..num.to_i).each do
      add_vector(head, VECTOR_FROM_DIRECTION[direction])
      catch_up(head, tails[0])
      tails[1..].each_with_index do |next_tail, i|
        catch_up(tails[i], next_tail)
      end
      visited.add(tails.last.to_a)
    end
  end

  puts visited.count
end

# part 1
perform(input, Pos.new('H'), [Pos.new('T')])

# part 2
tails = (0..8).map { |i| Pos.new(i+1) }
perform(input, Pos.new('H'), tails)
