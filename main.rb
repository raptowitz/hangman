# frozen_string_literal: true

require 'yaml'
require_relative 'dictionary.rb'
require_relative 'player.rb'
require_relative 'display.rb'
require_relative 'game.rb'

new_game = Game.new(Board.new, Player.new)
new_game.choose_game
