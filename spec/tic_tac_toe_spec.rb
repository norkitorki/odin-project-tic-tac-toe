require_relative '../lib/tic_tac_toe'

describe TicTacToe do
  game_board_template = GameBoard
  let(:tic_tac_toe) {
    TicTacToe.new(
      game_board_template,
      Player.new('John', 'X'), Player.new('Jane', 'O')
    )
  }
  let(:game_board_dummy) { game_board_template.new(ranks: 3, files: 3) }

  it 'should print the current turn to the console' do
    expect(tic_tac_toe.to_s).to eq(
    <<~GAME

      John's turn.

      #{game_board_dummy}
      Available fields:    A1, A2, A3, B1, B2, B3, C1, C2, C3

    GAME
    )
  end
end
