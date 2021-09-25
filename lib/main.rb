# frozen_string_literal: true

require_relative 'tic_tac_toe'

TicTacToe.new(
  Player.new('Player 1', 'X'), Player.new('Player 2', 'O'), GameBoard
).play
