require_relative '../lib/player'
require_relative './player_template_validator.rb'

describe Player do
  include PlayerTemplateValidator

  let(:player) { Player.new('John', 'X') }

  it 'should play the player template role' do
    expect(name_defined?(player)).to eq(true)
    expect(piece_defined?(player)).to eq(true)
  end

  it 'should return the name' do
    expect(player.name).to eq('John')
  end

  it 'should return the piece' do
    expect(player.piece).to eq('X')
  end
end
