class Board

  def initialize(width, height, bombs)
    @board = Array.new(width) { |x| Array.new(height) { |y| Tile.new([x, y]) } }
    @width =  width
    @height = height
    @bombs =  bombs
    @board.flatten.each { |tile| tile.populate_neighbors(self) }
  end

  def make_move(coords)
    if in_bound?(coords)
      tile = self[coords]
      tile.reveal
    else
      puts "Pick a real move...dummy"
    end
  end

  def [](coords)
    x, y = coords
    @board[x][y]
  end

  def populate_mines(coords)
    count = 0
    until count == @bombs
      rand_x, rand_y = rand(@width), rand(@height)
      rand_tile = @board[rand_x][rand_y]
      tile = self[coords]

      unless rand_tile.mine? ||
             rand_tile == tile ||
             tile.neighbor?(rand_tile)

        rand_tile.set_mine
        count += 1
      end
    end
  end

  def populated?
    tiles.any?(&:mine?)
  end

  def in_bound?(coords)
    x, y = coords
    x.between?(0, @width - 1) && y.between?(0, @height - 1)
  end

  def render
    lines = @board.transpose.reverse.map do |row|
      line = row.map do |tile|
        tile.render
      end.join(" | ")
      "| #{line} |"
    end
    [ "-" * (@width * 4 + 1),
      lines,
      "-" * (@width * 4 + 1) ]
  end

  def display
    puts render
  end

  def place_flag(coords)
    self[coords].toggle_flag if in_bound?(coords)
  end

  def tiles
    @board.flatten
  end
end
