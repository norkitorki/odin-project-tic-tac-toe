# frozen_string_literal: false

require_relative '../lib/game_board'

# rubocop: disable Metrics/BlockLength
describe GameBoard do
  subject(:game_board) { described_class.new(ranks: 3, files: 3) }

  it 'should play the game board role' do
    expect(game_board).to respond_to(:files)
    expect(game_board).to respond_to(:to_s)
    expect(game_board).to respond_to(:field)
    expect(game_board).to respond_to(:fields)
    expect(game_board).to respond_to(:columns)
    expect(game_board).to respond_to(:rows)
    expect(game_board).to respond_to(:empty_fields)
    expect(game_board).to respond_to(:full?)
    expect(game_board).to respond_to(:clear)
  end

  describe '#to_s' do
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
  end

  describe '#field' do
    context 'when position is valid' do
      it 'should place a game piece at position' do
        expect(game_board.field(:A1, 'X')).to eq('X')
      end

      it 'should retrieve a game piece' do
        game_board.field(:A1, 'Y')
        expect(game_board.field(:A1)).to eq('Y')
      end

      it 'should raise an error when piece is too long' do
        expect { game_board.field(:B2, 'xYx') }.to raise_error(ArgumentError)
      end
    end

    context 'when the position is invalid' do
      it 'should raise an error when the position could not be found' do
        expect { game_board.field(:C4) }.to raise_error(IndexError)
      end
    end
  end

  describe '#fields' do
    it 'should return every position' do
      expect(game_board.fields).to eq(%i[A1 A2 A3 B1 B2 B3 C1 C2 C3])
    end
  end

  describe '#columns' do
    before { game_board.field(:A2, 'X') }

    it 'should return every column' do
      expect(game_board.columns).to eq([[' ', 'X', ' '], [' ', ' ', ' '], [' ', ' ', ' ']])
    end
  end

  describe '#rows' do
    before { game_board.field(:A2, 'X') }

    it 'should return every row' do
      expect(game_board.rows).to eq(
        [[' ', ' ', ' '], ['X', ' ', ' '], [' ', ' ', ' ']]
      )
    end
  end

  describe '#empty_fields' do
    before do
      game_board.field(:A2, 'X')
      game_board.field(:C2, 'Y')
    end

    it 'should return every empty field' do
      expect(game_board.empty_fields).to eq(%i[A1 A3 B1 B2 B3 C1 C3])
    end
  end

  describe '#full?' do
    context 'when the board is full' do
      subject(:full_board) { described_class.new(ranks: 1, files: 1) }

      before { full_board.field(:A1, 'D') }

      it 'should return true' do
        expect(full_board.full?).to eq(true)
      end
    end

    context 'when the board is not full' do
      it 'should return false' do
        expect(game_board.full?).to eq(false)
      end
    end
  end

  describe '#clear' do
    before do
      game_board.field(:A3, 'W')
      game_board.field(:A2, 'W')
      game_board.field(:C3, 'W')
    end

    it 'should clear the board' do
      expect(game_board.clear).to eq(game_board.empty_fields)
    end
  end
end
# rubocop: enable Metrics/BlockLength
