require_relative '../lib/utils'
input = Utils.lines

Card = Struct.new(:id, :winning, :mine, :copies) do
  def initialize(id, winning, mine)
    super
    self.copies = 1
  end
end

def wins(card)
  (card.winning & card.mine).size
end

def points(card)
  wins = wins(card)
  return 0 if wins.zero?

  2**(wins-1)
end

def parse_cards(input)
  input.map do |line|
    id_part, nums_part = line.split(':')
    id = id_part.match(/Card\s+(\d+)/)[0]
    winning_part, mine_part = nums_part.split('|')
    winning = winning_part.split(' ').map(&:to_i)
    mine = mine_part.split(' ').map(&:to_i)
    Card.new(id, winning, mine)
  end
end

def part1(input)
  cards = parse_cards(input)
  puts cards.map { |c| points(c) }.sum
end

def part2(input)
  cards = parse_cards(input)
  cards.each_with_index do |card, i|
    (1..wins(card)).each do |j|
      cards[i+j].copies += card.copies
    end
  end
  puts cards.map(&:copies).sum
end

part1(input)
part2(input)

