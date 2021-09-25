# frozen_string_literal: true

require_relative '../lib/tic_tac_toe'
require_relative '../lib/game_board'
require_relative '../lib/player'

# rubocop: disable Metrics/BlockLength
describe TicTacToe do
  subject(:tic_tac_toe) { described_class.new(player_one, player_two, GameBoard) }
  let(:player_one) { Player.new('Player1', 'X') }
  let(:player_two) { Player.new('Player2', 'O') }
  let(:board) { tic_tac_toe.instance_variable_get(:@board) }

  describe '#to_s' do
    it 'should send a message to board#to_s' do
      expect(board).to receive(:to_s).once
      tic_tac_toe.to_s
    end

    before { allow(board).to receive(:empty_fields).and_return(board.empty_fields) }

    it 'should send a message to board#empty_fields' do
      expect(board).to receive(:empty_fields).once
      tic_tac_toe.to_s
    end
  end

  describe '#play' do
    context 'when one of the game ending conditions are met' do
      before do
        allow(tic_tac_toe).to receive(:puts)
        allow(tic_tac_toe).to receive(:find_empty_field)
        allow(tic_tac_toe).to receive(:player_input)
        allow(tic_tac_toe).to receive(:place_piece)
        allow(tic_tac_toe).to receive(:post_game_continuation)
        allow(tic_tac_toe).to receive(:post_game_operations)
      end

      context 'when a player has won' do
        before { allow(tic_tac_toe).to receive(:player_won?).and_return(true) }

        it 'should call post_game_operations' do
          expect(tic_tac_toe).to receive(:post_game_operations).once
          tic_tac_toe.play
        end
      end

      context 'when the game ends in a draw' do
        before { allow(tic_tac_toe).to receive(:draw?).and_return(true) }

        it 'should call post_game_operations' do
          expect(tic_tac_toe).to receive(:post_game_operations).once
          tic_tac_toe.play
        end
      end
    end
  end

  describe '#player_input' do
    # located inside #play method

    before do
      allow(tic_tac_toe).to receive(:print)
      input = ' a1  '
      allow(tic_tac_toe).to receive(:gets).and_return(input)
    end

    it 'should request input from the user' do
      expect(tic_tac_toe).to receive(:gets).once
      tic_tac_toe.player_input
    end

    it 'should return the input stripped of whitespace and uppercased' do
      result = tic_tac_toe.player_input
      expect(result).to eq('A1')
    end
  end

  describe '#find_empty_field' do
    # located inside #play method

    context 'when the position is an empty field on the board' do
      let(:valid_position) { 'A2' }

      it 'should not send a message to player_input' do
        expect(tic_tac_toe).not_to receive(:player_input)
        tic_tac_toe.find_empty_field(valid_position)
      end

      it 'should return the position' do
        expect(tic_tac_toe.find_empty_field(valid_position)).to eq('A2')
      end
    end

    context 'when the position on the board is not empty or invalid' do
      let(:invalid_position) { 'C12' }

      before do
        number = '4'
        symbol = ':foo'
        position = 'C1'
        allow(tic_tac_toe).to receive(:player_input).and_return(number, symbol, position)
      end

      it 'should send a message to player_input until the position is valid' do
        expect(tic_tac_toe).to receive(:player_input).exactly(3).times
        tic_tac_toe.find_empty_field(invalid_position)
      end

      it 'should return the position once its valid' do
        position = tic_tac_toe.find_empty_field(invalid_position)
        expect(position).to eq('C1')
      end
    end
  end

  describe '#place_piece' do
    # located in #play method

    before do
      allow(board).to receive(:field)
    end

    it 'should send a message to board#field' do
      position = 'B2'
      piece = 'X'
      expect(board).to receive(:field).with(position, piece).once
      tic_tac_toe.place_piece(position, piece)
    end
  end

  describe '#switch_players' do
    # located in #play

    context 'when active_player is player1' do
      it 'should set active_player to player2' do
        player2 = tic_tac_toe.player2
        tic_tac_toe.active_player = tic_tac_toe.player1
        expect { tic_tac_toe.switch_players }.to change { tic_tac_toe.active_player }.to(player2)
      end
    end

    context 'when active_player is player2' do
      it 'should set active_player to player1' do
        player1 = tic_tac_toe.player1
        tic_tac_toe.active_player = tic_tac_toe.player2
        expect { tic_tac_toe.switch_players }.to change { tic_tac_toe.active_player }.to(player1)
      end
    end
  end

  describe '#player_won?' do
    # located in #play method

    context 'when there is no match' do
      context 'when the board is empty' do
        it 'should return false' do
          expect(tic_tac_toe.player_won?).to eq(false)
        end
      end

      context 'when every position on the board is full' do
        before do
          %w[A1 B1 C1 A2 B2 C2 A3 B3 C3].each_with_index { |pos, i| tic_tac_toe.place_piece(pos, i.to_s) }
        end

        it 'should return false' do
          expect(tic_tac_toe.player_won?).to eq(false)
        end
      end
    end

    context 'when there is a match' do
      context 'when a player has a horizontal match' do
        before do
          piece = tic_tac_toe.active_player.piece
          %w[A1 B1 C1].each { |pos| tic_tac_toe.place_piece(pos, piece) }
        end

        it 'should return true' do
          expect(tic_tac_toe.player_won?).to eq(true)
        end
      end

      context 'when a player has a vertical match' do
        before do
          piece = tic_tac_toe.active_player.piece
          %w[B1 B2 B3].each { |pos| tic_tac_toe.place_piece(pos, piece) }
        end

        it 'should return true' do
          expect(tic_tac_toe.player_won?).to eq(true)
        end
      end

      context 'when a player has a diagonal match' do
        before do
          piece = tic_tac_toe.active_player.piece
          %w[A1 B2 C3].each { |pos| tic_tac_toe.place_piece(pos, piece) }
        end

        it 'should return true' do
          expect(tic_tac_toe.player_won?).to eq(true)
        end
      end
    end
  end

  describe '#draw?' do
    it 'should send a message to board#full?' do
      expect(board).to receive(:full?).once
      tic_tac_toe.draw?
    end

    context 'when the board is full and no player has a match' do
      before do
        %w[A1 B1 C1 A2 B2 C2 A3 B3 C3].each_with_index { |pos, i| tic_tac_toe.place_piece(pos, i.to_s) }
      end

      it 'should return true' do
        expect(tic_tac_toe.draw?).to eq(true)
      end
    end

    context 'when the board is not full' do
      context 'when the board is empty' do
        it 'should return false' do
          expect(tic_tac_toe.draw?).to eq(false)
        end
      end

      context 'when some positions on the board are occupied' do
        before do
          %w[B1 B2 C1 C3].each { |pos| tic_tac_toe.place_piece(pos, 'K') }
        end

        it 'should return false' do
          expect(tic_tac_toe.draw?).to eq(false)
        end
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
