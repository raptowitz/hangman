# frozen_string_literal: true

# display
class Board
  attr_reader :lives, :wrong_letters

  def initialize
    @wrong_letters = []
    @lives = 8
  end

  def blank_board(secret_word)
    @secret_word = secret_word
    @display = Array.new(secret_word.length, '_')
    display
  end

  def display
    puts "Used Letters: #{@wrong_letters.join(' ')}"
    puts "#{@lives} guesses left"
    puts "\n #{@display.join(' ')}"
  end

  def place_guess(letter, index)
    @letter = letter
    @index = index
    @display[@index] = @letter
  end

  def wrong_letter(guess)
    @guess = guess
    @wrong_letters.push(@guess)
    @lives -= 1
  end

  def game_over?
    @display.none? { |space| space == '_' }
  end
end
