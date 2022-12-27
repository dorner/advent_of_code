require_relative '../lib/utils'
input = Utils.input

ROCK = 1
PAPER = 2
SCISSORS = 3

LOSE = 0
DRAW = 3
WIN = 6

CHARACTER_MAP = {
  'A' => ROCK,
  'B' => PAPER,
  'C' => SCISSORS,
  'X' => ROCK,
  'Y' => PAPER,
  'Z' => SCISSORS
}

WIN_CYCLE = [ROCK, PAPER, SCISSORS]

def game_score(them, you)
  return DRAW if them == you
  return LOSE if WIN_CYCLE.index(them) == (WIN_CYCLE.index(you) + 1) % 3
  WIN
end

total = 0
input.lines.each do |line|
  them, you = line.split(' ').map { |c| CHARACTER_MAP[c] }
  total += you + game_score(them, you)
end

puts total

# PART 2

GAME_SCORE_MAP = {
  'X' => LOSE,
  'Y' => DRAW,
  'Z' => WIN
}

def your_move(them, score)
  return them if score == DRAW
  return WIN_CYCLE[(WIN_CYCLE.index(them) + 1) % 3] if score == WIN
  WIN_CYCLE[(WIN_CYCLE.index(them) - 1) % 3]
end

total = 0
input.lines.each do |line|
  tokens = line.split(' ')
  them = CHARACTER_MAP[tokens[0]]
  score = GAME_SCORE_MAP[tokens[1]]
  total += your_move(them, score) + score
end

puts total
