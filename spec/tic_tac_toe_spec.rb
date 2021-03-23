require '../lib/tic_tac_toe'

describe TicTacToe do
  let(:tic_tac_toe) {
    TicTacToe.new(
      GameBoard.new(ranks: 3, files: 3),
      Player.new('John', 'X'),
      Player.new('Jane', 'O')
    )
  }


end
