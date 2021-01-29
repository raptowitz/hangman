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
    find_index if check_word(@player.guess)
  end

  def create_secret_word
    words = File.readlines('5desk.txt')
    words.keep_if { |word| word.chomp.length > 5 && word.chomp.length < 12 }
    @secret_word = words.sample.chomp
    p @secret_word
  end

  def check_word(guess)
    @guess = guess
    @secret_word.include?(@guess)
  end

  def find_index
    @secret_word.split(//).each_with_index do |letter, index|
      @board.place_guess(letter, index) if letter == @guess
    end
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
    p @display = Array.new(secret_word.length, '?')
  end

  def place_guess(letter, index)
    @letter = letter
    @index = index
    @display[@index] = @letter
  end

end

new_game = Game.new(Player.new, Board.new)
new_game.play_game
