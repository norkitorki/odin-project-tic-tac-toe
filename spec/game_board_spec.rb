require_relative '../lib/game_board'
require_relative './game_board_template_validator'

describe GameBoard do
  include GameBoardTemplateValidator

  let(:game_board) { GameBoard.new(ranks: 3, files: 3) }

  it 'should play the game board role' do
    expect(files_defined?(game_board)).to eq(true)
    expect(to_s_defined?(game_board)).to eq(true)
    expect(field_defined?(game_board)).to eq(true)
    expect(fields_defined?(game_board)).to eq(true)
    expect(columns_defined?(game_board)).to eq(true)
    expect(rows_defined?(game_board)).to eq(true)
    expect(empty_fields_defined?(game_board)).to eq(true)
    expect(full_defined?(game_board)).to eq(true)
    expect(clear_defined?(game_board)).to eq(true)
  end

  it 'should print the board' do
    expect(game_board.to_s).to eq(
      <<~BOARD
          ┏━━━┯━━━┯━━━┓
        3 ┃   │   │   ┃
          ┠───┼───┼───┨
        2 ┃   │   │   ┃
          ┠───┼───┼───┨
        1 ┃   │   │   ┃
          ┗━━━┷━━━┷━━━┛
            A   B   C
      BOARD
    )
  end

  context 'field method' do
    it 'should place a game piece' do
      expect(game_board.field(:A1, 'X')).to eq('X')
    end

    it 'should retrieve a game piece' do
      game_board.field(:A1, 'Y')
      expect(game_board.field(:A1)).to eq('Y')
    end

    it 'should raise an error when piece is too long' do
      expect{game_board.field(:B2, 'xYx')}.to raise_error(ArgumentError)
    end

    it 'should raise an error when the position could not be found' do
      expect{game_board.field(:C4)}.to raise_error(IndexError)
    end
  end

  it 'should return every field' do
    expect(game_board.fields).to eq(
      [:A1, :A2, :A3, :B1, :B2, :B3, :C1, :C2, :C3]
    )
  end

  it 'should return every column' do
    game_board.field(:A2, 'X')
    expect(game_board.columns).to eq(
      [[" ", "X", " "], [" ", " ", " "], [" ", " ", " "]]
    )
  end

  it 'should return every row' do
    game_board.field(:A2, 'X')
    expect(game_board.rows).to eq(
      [[" ", " ", " "], ["X", " ", " "], [" ", " ", " "]]
    )
  end

  it 'should return every empty fields position on the board' do
    game_board.field(:A2, 'X')
    game_board.field(:C2, 'Y')
    expect(game_board.empty_fields).to eq([:A1, :A3, :B1, :B2, :B3, :C1, :C3])
  end

  it 'should determine if every field is filled' do
    dummy_board = GameBoard.new(ranks: 1)
    dummy_board.field(:A1, 'D')
    expect(dummy_board.full?).to eq(true)
    expect(game_board.full?).to eq(false)
  end

  it 'should clear the board' do
    game_board.field(:A3, 'W')
    game_board.field(:A2, 'W')
    game_board.field(:C3, 'W')
    expect(game_board.clear).to eq(game_board.empty_fields)
  end
end
