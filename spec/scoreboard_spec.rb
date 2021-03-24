require_relative '../lib/scoreboard'
require_relative './scoreboard_template_validator'

describe Scoreboard do
  include ScoreboardTemplateValidator

  let(:scoreboard) {
    Scoreboard.new(
      title: 'Standings',
      players: %w[John Jane],
      default_score: 10
    )
  }

  it 'should play the scoreboard role' do
    expect(to_s_defined?(scoreboard)).to eq(true)
    expect(update_score_defined?(scoreboard)).to eq(true)
  end

  it 'should print the scoreboard' do
    expect(scoreboard.to_s).to eq(
      "Standings\n\nJohn | Jane\n–––––––––––\n10   | 10  \n"
    )
  end

  context 'get_score method' do
    it 'should return the score of a player' do
      expect(scoreboard.get_score('Jane')).to eq(10)
    end

    it 'should raise an exception if a player is not found' do
      expect{scoreboard.get_score('Mark')}.to raise_error(
        ArgumentError, 'Mark was not found'
      )
    end
  end

  it 'should assign the score of a player' do
    scoreboard.set_score('John', 15)
    expect(scoreboard.get_score('John')).to eq(15)
  end

  context 'update_score method' do
    it 'should add to the existing score of a player' do
      scoreboard.update_score('Jane', 2)
      expect(scoreboard.get_score('Jane')).to eq(12)
    end

    it 'should subtract from the existing score of a player' do
      scoreboard.update_score('Jane', -3)
      expect(scoreboard.get_score('Jane')).to eq(7)
    end
  end

  context 'add_player method' do
    it 'should add a new player' do
      scoreboard.add_player('Jake')
      expect(scoreboard.get_score('Jake')).to eq(10)
    end

    it 'should add a new player with a score' do
      scoreboard.add_player('Jake', 180000)
      expect(scoreboard.get_score('Jake')).to eq(180000)
    end
  end

  it 'should remove a player' do
    scoreboard.remove_player('John')
    expect{scoreboard.get_score('John')}.to raise_error(ArgumentError)
  end

  it 'should reset the scoreboard' do
    scoreboard.update_score('John', 4)
    scoreboard.update_score('Jane', 7)
    expect(scoreboard.reset).to eq(10)
    expect(scoreboard.get_score('John')).to eq(10)
    expect(scoreboard.get_score('Jane')).to eq(10)
  end
end
