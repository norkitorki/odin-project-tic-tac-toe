require './player'

class Scoreboard
  attr_reader :title, :players, :default_score

  def initialize(title: '', players: [], default_score: 0)
    @title = title
    @players = players.map { |name| [name, default_score] }.to_h
    @default_score = default_score
  end

  def to_s
    <<~SCOREBOARD
      #{title}\n
      #{row_for(:name)}
      #{row_seperator}
      #{row_for(:score)}
    SCOREBOARD
  end

  def get_score(name)
    argument_validation(name, -1)
    players[name]
  end

  def set_score(name, score)
    argument_validation(name, score)
    players[name] = score
  end

  def update_score(name, score)
    argument_validation(name, score)
    players[name] += score
  end

  def add_player(name, score = default_score)
    argument_validation(players.first[0], score)
    players[name] = score
  end

  def remove_player(name)
    argument_validation(name, -1)
    players.delete(name)
  end

  def reset
    @players = players.map { |player| [player[0], default_score] }.to_h
    default_score
  end

  private

  def argument_validation(player, score)
    raise ArgumentError, "#{player} was not found" unless @players.key?(player)
    raise ArgumentError, 'Score must be numeric' unless score.is_a?(Numeric)
  end

  def row_padding(player)
    name  = player.first
    score = player.last.to_s
    padding = [name.length, score.length].max

    {
      name: "#{name}#{' ' * (padding - name.length)}",
      score: "#{score}#{' ' * (padding - score.length)}"
    }
  end

  def row_for(key)
    players.map { |player| row_padding(player)[key] }.join(' | ')
  end

  def row_seperator
    '–' * row_for(:name).length
  end
end
