class GameBoard
  attr_reader :ranks, :files

  def initialize(ranks: 3, files: ranks)
    @ranks  = ranks
    @files  = files
    @fields = create_fields
  end

  def to_s
    build_board.push(files_row).join(row_seperator) << "\n"
  end

  def field(position = :A1, piece = nil)
    raise ArgumentError, 'Piece length must be 1' unless piece_valid?(piece)

    file = position.upcase[/[A-Z]+/].to_sym
    rank = position[/\d+/].to_i - 1
    raise IndexError, 'Field out of range' unless field_in_range?(file, rank)

    if piece
      @fields[file][rank] = piece_padding(file, piece)
    else
      @fields[file][rank]
    end
  end

  def fields
    @fields.keys.map do |file|
      @fields.values.map.with_index { |_, rank| "#{file}#{rank + 1}".to_sym }
    end.flatten
  end

  def columns
    fields.map { |position| field(position) }.each_slice(files).to_a
  end

  def rows
    fields.map { |position| field(position) }.each_slice(ranks).to_a.transpose
  end

  def empty_fields
    fields.select { |pos| field(pos) == ' ' }
  end

  def full?
    empty_fields.empty?
  end

  def clear
    fields.each { |pos| field(pos, ' ') }
  end

  private

  def create_fields
    fields = {}
    file   = :A
    files.times do
      fields[file] = []
      ranks.times { fields[file] << ' ' * file.length }
      file = file.next
    end

    fields
  end

  def files_row
    padding = ' ' * (ranks.to_s.length + 3)
    "#{padding}#{@fields.keys.join(' | ')}"
  end

  def row_seperator
    padding   = ' ' * (ranks.to_s.length + 1)
    seperator = '–' * (files_row.length - ranks.to_s.length + 1)
    " |\n#{padding}#{seperator}\n"
  end

  def build_board
    @fields.values.transpose.reverse.map.with_index do |row, i|
      rank = ranks - i
      rank_padding = ' ' * (ranks.to_s.length - rank.to_s.length)
      row.unshift("#{rank}#{rank_padding}").join(' | ')
    end
  end

  def piece_valid?(piece)
    !piece || piece.to_s.length == 1
  end

  def field_in_range?(file, rank)
    @fields.key?(file) && @fields[file][rank]
  end

  def piece_padding(file, piece)
    file.length > 1 ? piece << ' ' * (file.length - 1) : piece
  end
end
