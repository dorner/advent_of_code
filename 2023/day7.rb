require_relative '../lib/utils'
sample_input = Utils.lines(true)
input = Utils.lines

RANKED_CARDS = 'AKQJT98765432'.chars.map.with_index { |k, i| [k, 13-i]}.to_h
JOKER_RANKED_CARDS = 'AKQT98765432J'.chars.map.with_index { |k, i| [k, 13-i]}.to_h
FIVE_OF_A_KIND = 7
FOUR_OF_A_KIND = 6
FULL_HOUSE = 5
THREE_OF_A_KIND = 4
TWO_PAIR = 3
ONE_PAIR = 2
HIGH_CARD = 1

Hand = Struct.new(:cards, :bid, :use_jokers, :rank, :type) do
  def initialize(*args)
    super
    self.type = self.use_jokers ? calculate_type_with_jokers : calculate_type
  end

  def winnings
    self.rank * self.bid
  end

  def calculate_type_with_jokers
    found = Hash.new(0)
    jokers = 0
    self.cards.each do |card|
      if card == 'J'
        jokers += 1
      else
        found[card] += 1
      end
    end
    repeats = found.values
    found_pairs = 0
    found_three = false
    repeats.each do |val|
      case val
      when 5
        return FIVE_OF_A_KIND
      when 4
        return jokers == 1 ? FIVE_OF_A_KIND : FOUR_OF_A_KIND
      when 3
        found_three = true
      when 2
        found_pairs += 1
      end
    end

    if found_three
      return FULL_HOUSE if found_pairs == 1

      return case jokers
      when 2; FIVE_OF_A_KIND
      when 1; FOUR_OF_A_KIND
      else; THREE_OF_A_KIND
      end
    end

    case found_pairs
    when 2
      jokers == 1 ? FULL_HOUSE : TWO_PAIR
    when 1
      case jokers
      when 3; FIVE_OF_A_KIND
      when 2; FOUR_OF_A_KIND
      when 1; THREE_OF_A_KIND
      else; ONE_PAIR
      end
    else
      case jokers
      when 4, 5; FIVE_OF_A_KIND
      when 3; FOUR_OF_A_KIND;
      when 2; THREE_OF_A_KIND;
      when 1; ONE_PAIR;
      else; HIGH_CARD
      end
    end
  end

  def calculate_type
    found = Hash.new(0)
    self.cards.each do |card|
      found[card] += 1
    end
    repeats = found.values
    found_pairs = 0
    found_three = false
    repeats.each do |val|
      case val
      when 5
        return FIVE_OF_A_KIND
      when 4
        return FOUR_OF_A_KIND
      when 3
        found_three = true
      when 2
        found_pairs += 1
      end
    end
    if found_three
      return found_pairs.zero? ? THREE_OF_A_KIND : FULL_HOUSE
    end
    case found_pairs
    when 2
      TWO_PAIR
    when 1
      ONE_PAIR
    else
      HIGH_CARD
    end
  end

  def <=>(other)
    type_comp = self.type <=> other.type
    return type_comp unless type_comp.zero?

    ranking_list = self.use_jokers ? JOKER_RANKED_CARDS : RANKED_CARDS
    other.cards.each_with_index do |card, i|
      rank_comp = ranking_list[self.cards[i]] <=> ranking_list[card]
      return rank_comp unless rank_comp.zero?
    end
  end
end

def parse_input(input, use_jokers=false)
  input.map do |line|
    cards, bid = line.split(' ')
    Hand.new(cards.chars, bid.to_i, use_jokers)
  end
end

def part1(input)
  hands = parse_input(input)
  hands.sort!
  hands.each_with_index { |h, i| h.rank = i + 1}
  hands.map(&:winnings).sum
end

def part2(input)
  hands = parse_input(input, true)
  hands.sort!
  hands.each_with_index { |h, i| h.rank = i + 1}
  hands.map(&:winnings).sum
end

puts part1(input)
puts part2(input)
