class GameBoard
  attr_reader :ranks, :files

  def initialize(ranks: 3, files: ranks)
    @ranks  = ranks
    @files  = files
    @fields = create_fields
  end

  def to_s
    top_line << board.join(row_seperator) << bottom_line << board_files << "\n"
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
      (1..ranks).map { |rank| "#{file}#{rank}".to_sym }
    end.flatten
  end

  def columns
    fields.map { |position| field(position) }.each_slice(ranks).to_a
  end

  def rows
    columns.transpose
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
      fields[file] = (1..ranks).map { ' ' }
      file = file.next
    end

    fields
  end

  def board
    ranks = board_ranks
    rows  = @fields.values.transpose.reverse

    rows.map.with_index do |row, i|
      offset = board_offset[ranks[i].length..]
      offset << ranks[i] << '┃ ' << row.join(' │ ') << " ┃\n"
    end
  end

  def board_ranks
    ranks.downto(1).to_a.map do |rank|
      padding = ' ' * (ranks.to_s.length - rank.to_s.length + 1)
      rank.to_s << padding
    end
  end

  def board_files
    padding = board_offset << '  '
    padding << @fields.keys.join('   ')
  end

  def board_offset
    ' ' * (ranks.to_s.length + 1)
  end

  def row_seperator
    seperator = '┠' << Array.new(files, '───').join('┼') << "┨\n"
    board_offset << seperator
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

  def top_line
    board_offset << '┏' << Array.new(files, '━━━').join('┯') << "┓\n"
  end

  def bottom_line
    board_offset << '┗' << Array.new(files, '━━━').join('┷') << "┛\n"
  end
end
