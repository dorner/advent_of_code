require_relative '../lib/utils'
input = Utils.input

Game = Struct.new(:id, :samples) do
  def valid?(good_sample)
    self.samples.each do |sample|
      %i(blue red green).each do |color|
        return false if sample.send(color) > good_sample.send(color)
      end
    end
    true
  end

  def min_sample
    samp = Sample.new
    %i(red green blue).each do |color|
      samp.send("#{color}=", self.samples.map(&color).max)
    end
    samp
  end

end

Sample = Struct.new(:red, :green, :blue) do
  def initialize(red:0, green:0, blue:0)
    self.red = red
    self.green = green
    self.blue = blue
  end

  def power
    self.red * self.blue * self.green
  end
end

def parse_games(input)
  input.lines.map do |line|
    identifier, game_list = line.split(':')
    id = identifier.match(/\d+/)[0].to_i
    game = Game.new(id: id, samples: [])
    samples = game_list.split(';')
    samples.map do |raw_sample|
      sample = Sample.new
      types = raw_sample.split(',')
      types.each do |type|
        num, color = type.scan(/(\d+) (\w+)/)[0]
        sample.send("#{color}=", num.to_i)
      end
      game.samples.push(sample)
    end
    game
  end
end

def part1(input)
  games = parse_games(input)
  good_game = Sample.new(red: 12, green: 13, blue: 14)
  valid_games = games.select { |g| g.valid?(good_game) }
  puts valid_games.map(&:id).sum
end

def part2(input)
  games = parse_games(input)
  puts games.map { |g| g.min_sample.power }.sum
end

part1(input)
part2(input)
