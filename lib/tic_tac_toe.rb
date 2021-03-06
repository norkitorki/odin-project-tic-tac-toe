# frozen_string_literal: true

require_relative 'game_board'
require_relative 'player'
require_relative 'scoreboard'

# class for tic-tac-toe game
class TicTacToe
  attr_reader :player1, :player2, :game_number
  attr_accessor :active_player

  def initialize(player1, player2, board = GameBoard)
    @board = board.new(ranks: 3, files: 3)
    @active_player = @player1 = player1
    @player2       = player2
    @game_number   = 0
    @scoreboard    = Scoreboard.new(
      title: 'Standings', players: [player1.name, player2.name]
    )
  end

  def to_s
    "\n#{active_player.name}'s turn.\n\n#{board}\nAvailable fields:\
    #{board.empty_fields.join(', ')}\n\n"
  end

  def play
    beginning_player = active_player
    loop do
      puts self
      place_piece(find_empty_field(player_input), active_player.piece)
      break post_game_operations if player_won? || draw?

      switch_players
    end
    switch_players if active_player == beginning_player
    post_game_continuation
  end

  def player_input
    print '=> '
    gets.chomp.strip.upcase
  end

  def find_empty_field(position)
    position = player_input until board.empty_fields.include?(position.to_sym)
    position
  end

  def place_piece(position, piece)
    board.field(position, piece)
  end

  def switch_players
    self.active_player = active_player == player1 ? player2 : player1
  end

  def player_won?
    linear_match?(board.columns) || linear_match?(board.rows) ||
      diagonal_match?(board.columns) || diagonal_match?(board.columns.reverse)
  end

  def draw?
    board.full?
  end

  private

  attr_reader :scoreboard, :board

  def linear_match?(fields)
    fields.each { |row| return true if row.all?(active_player.piece) }
    false
  end

  def diagonal_match?(fields)
    fields.map.with_index { |field, i| field[i] }.all?(active_player.piece)
  end

  def game_results
    "\n#{board}\n#{scoreboard}\n"
  end

  def handle_win
    puts "\n#{active_player.name} has won game ##{game_number}."
    scoreboard.update_score(active_player.name, +1)
    puts game_results
  end

  def handle_draw
    puts "\nGame ##{game_number} ended in a draw."
    puts game_results
  end

  def post_game_operations
    @game_number += 1
    player_won? ? handle_win : handle_draw
    board.clear
  end

  def post_game_continuation
    print 'Do you want to continue the game? y/n ? '
    input = player_input until %w[Y N].include?(input)
    input == 'Y' ? play : false
  end
end
