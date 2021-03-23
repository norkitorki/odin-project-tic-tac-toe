require_relative '../lib/tic_tac_toe'

describe TicTacToe do
  let(:tic_tac_toe) {
    TicTacToe.new(GameBoard, Player.new('John', 'X'), Player.new('Jane', 'O'))
  }

  it 'should print the current turn to the console' do
    expect(tic_tac_toe.to_s).to eq(
    <<~GAME

      John's turn.

      #{tic_tac_toe.board}
      Available fields:       A1, A2, A3, B1, B2, B3, C1, C2, C3

    GAME
    )
  end
end
