# frozen_string_literal: true

# dictionary
module Dictionary
  def secret_word
    words = File.readlines('5desk.txt')
    words.keep_if { |word| word.chomp.length > 5 && word.chomp.length < 12 }
    @secret_word = words.sample.chomp.downcase
    p @secret_word
  end
end

# game logic
class Game
  include Dictionary

  def initialize(board, player)
    @player = player
    @board = board
    @wrong_letters = []
    @lives = 8
  end

  def play_game
    @board.blank_board(secret_word)
    until @lives.zero?
      if word_contains(@player.guess)
        find_letter
      else
        wrong_letter
      end
      @board.display
    end
  end

  def word_contains(guess)
    @guess = guess
    @secret_word.include?(@guess)
  end

  def find_letter
    @secret_word.split(//).each_with_index do |letter, index|
      @board.place_guess(letter, index) if letter == @guess
    end
  end

  def wrong_letter
    @wrong_letters.push(@guess)
    puts "\nUsed Letters: #{@wrong_letters.join(' ')}"
    puts "#{@lives -= 1} guesses left"
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
  def blank_board(secret_word)
    @secret_word = secret_word
    @display = Array.new(secret_word.length, '_')
    display
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

new_game = Game.new(Board.new, Player.new)
new_game.play_game
