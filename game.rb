# frozen_string_literal: true

# game logic
class Game
  def initialize(player, board)
    @player = player
    @board = board
    @secret_word = nil
  end

  def play_game
    create_secret_word
    @board.display(@secret_word)
    check_word(@player.guess)
  end

  def create_secret_word
    words = File.readlines('5desk.txt')
    words.keep_if { |word| word.chomp.length > 5 && word.chomp.length < 12 }
    @secret_word = words.sample.chomp
    p @secret_word
  end

  def check_word(guess)
    @secret_word.include?(guess)
  end

end

# human player
class Player
  def guess
    gets.chomp
  end
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
