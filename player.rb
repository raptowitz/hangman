# frozen_string_literal: true

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
