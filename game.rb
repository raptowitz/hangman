# frozen_string_literal: true

# game logic
class Game
  include Dictionary

  def initialize(board, player)
    @player = player
    @board = board
  end

  def serialize
    saved_game = YAML.dump(self)
    puts 'Enter a name for your saved game'
    File.open("saved_games/#{gets.chomp}.yaml", 'w') do |file|
      file.puts saved_game
    end
  end

  def choose_game
    puts 'Would you like to start a (1) new game (2) load saved game'
    if gets.chomp == '1'
      puts "\e[H\e[2J"
      new_game = Game.new(Board.new, Player.new)
      new_game.start_game
    else
      load_saved_games
    end
  end

  def load_saved_games
    puts 'Which game would you like to load?'
    Dir.new('saved_games').each do |file|
      puts file unless file.start_with?('.')
    end
    open_saved_game
  end

  def open_saved_game
    @filename = "saved_games/#{gets.chomp}.yaml"
    File.open(@filename, 'r') do |file|
      new_game = YAML.load(file)
      new_game.play_game
    end
  end

  def start_game
    @board.blank_board(secret_word)
    play_game
  end

  def play_game
    puts "\e[H\e[2J"
    @board.display
    until @board.lives.zero?
      guess_letters
      break if @guess == 'save'
      break if @board.game_over?
    end
    display_results
  end

  def guess_letters
    @guess = @player.guess
    if @guess == 'save'
      serialize
    else
      check_guess
    end
  end

  def check_guess
    if word_contains?(@guess)
      find_letter
    else
      @board.wrong_letter(@guess)
    end
    puts "\e[H\e[2J"
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
    if @guess == 'save'
      puts 'Game saved.'
    elsif @board.game_over?
      puts "\nYou win! \nThe secret word was #{@secret_word}"
    else
      puts "\nTry again! \nThe secret word was #{@secret_word}"
    end
    play_again
  end

  def play_again
    puts 'Play again? (y/n)'
    if gets.chomp == 'y'
      choose_game
    else
      puts 'Thanks for playing friend!'
    end
  end
end
