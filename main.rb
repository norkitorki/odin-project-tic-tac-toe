require_relative './lib/tic_tac_toe'

TicTacToe.new(
  GameBoard,
  Player.new('Player 1', 'X'), Player.new('Player 2', 'O')
).play
