# frozen_string_literal: true

# game logic
class Game
  def initialize(player, board)
    @player = player
    @board = board
  end

  def play_game
    words = File.readlines('5desk.txt')
    words.keep_if { |word| word.chomp.length > 5 && word.chomp.length < 12 }
    secret_word = words.sample.chomp
    @board.display(secret_word)
  end
end

# human player
class Player
end

# display
class Board
  def display(secret_word)
    @secret_word = secret_word
    p Array.new(secret_word.length, '?')
  end
end

new_game = Game.new(Player.new, Board.new)
new_game.play_game
