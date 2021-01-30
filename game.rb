# frozen_string_literal: true

require "yaml"

# dictionary
module Dictionary
  def secret_word
    words = File.readlines('5desk.txt')
    words.keep_if { |word| word.chomp.length > 5 && word.chomp.length < 12 }
    @secret_word = words.sample.chomp.downcase
    # p @secret_word
  end
end

# game logic
class Game
  include Dictionary

  def initialize(board, player)
    @player = player
    @board = board
  end

  def serialize
    saved_game = YAML.dump(self)
    filename = 'saved_games/saved_game.yaml'
    File.open(filename, 'w') do |file|
      file.puts saved_game
    end
  end

  def self.deserialize(yaml_string)
    YAML.safe_load(yaml_string)
  end

  def start_game
    @board.blank_board(secret_word)
    until @board.lives.zero?
      play_game
      break if @board.game_over?
    end
    display_results
  end

  def play_game
    p @guess = @player.guess
    if @guess == 'save'
      serialize
    elsif word_contains?(@guess)
      find_letter
    else
      @board.wrong_letter(@guess)
    end
    # puts "\e[H\e[2J"
    @board.display
  end

  def word_contains?(guess)
    @guess = guess
    @secret_word.include?(@guess)
  end

  def find_letter
    @secret_word.split(//).each_with_index do |letter, index|
      @board.place_guess(letter, index) if letter == @guess
    end
  end

  def display_results
    if @board.game_over?
      puts "\nYou win! \nThe secret word was #{@secret_word}"
    else
      puts "\nTry again! \nThe secret word was #{@secret_word}"
    end
    play_again
  end

  def play_again
    puts 'Play again? (y/n)'
    if gets.chomp == 'y'
      puts "\e[H\e[2J"
      new_game = Game.new(Board.new, Player.new)
      new_game.start_game
    else
      puts 'Thanks for playing friend!'
    end
  end
end

# human player
class Player
  def initialize
    @guessed_letters = []
  end

  def guess
    puts "Guess a letter of the secret word or enter 'save' to store your game!"
    @guess = gets.chomp.downcase
    validate unless @guess == 'save'
    @guess
  end

  def validate
    until @guess.length == 1 && @guess.match?(/[[:alpha:]]/) &&
          @guessed_letters.none?(@guess)
      puts 'Guess one letter'
      @guess = gets.chomp.downcase
    end
    @guessed_letters.push(@guess)
    @guess
  end
end

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

new_game = Game.new(Board.new, Player.new)
#yaml = new_game.serialize
#p yaml
#puts YAML.load(yaml)
new_game.start_game
