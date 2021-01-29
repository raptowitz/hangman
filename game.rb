# frozen_string_literal: true

# game logic
class Game
  def initialize
    @player = Player.new
    @board = Board.new(create_secret_word)
  end

  def play_game
    @board.display
    find_letters if check_word(@player.guess)
    @board.display
  end

  def create_secret_word
    words = File.readlines('5desk.txt')
    words.keep_if { |word| word.chomp.length > 5 && word.chomp.length < 12 }
    @secret_word = words.sample.chomp.downcase
    p @secret_word
  end

  def check_word(guess)
    @guess = guess
    @secret_word.include?(@guess)
  end

  def find_letters
    @secret_word.split(//).each_with_index do |letter, index|
      @board.place_guess(letter, index) if letter == @guess
    end
  end
end

# human player
class Player
  def guess
    gets.chomp.downcase
  end
end

# display
class Board
  def initialize(secret_word)
    @secret_word = secret_word
    @display = Array.new(secret_word.length, '_')
  end

  def display
    puts @display.join(' ')
  end

  def place_guess(letter, index)
    @letter = letter
    @index = index
    @display[@index] = @letter
  end
end

new_game = Game.new
new_game.play_game
