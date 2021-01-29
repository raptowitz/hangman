# frozen_string_literal: true

# game logic
class Game
  def play_game
    words = File.readlines('5desk.txt')
    words.keep_if { |word| word.chomp.length > 5 && word.chomp.length < 12 }
    puts words.sample(1)
  end
end

new_game = Game.new
new_game.play_game
