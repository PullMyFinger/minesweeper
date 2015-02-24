class Tile
  attr_reader :neighbors

  def initialize(pos)
    @mine =     false
    @revealed = false
    @flagged =  false
    @x, @y = pos
    @neighbors = []
  end
  
  def reveal
    @revealed = true
    if self.neighbor_bomb_count == 0
      applicable = @neighbors.reject do |neighbor|
        neighbor.mine? || neighbor.revealed? || neighbor.flag?
      end
      applicable.each { |neighbor| neighbor.reveal }
    end
  end

  def neighbor?(tile)
    @neighbors.include?(tile)
  end

  def populate_neighbors(board)
    shifts = [[-1, 0], [1, 0], [0, 1], [0, -1],
              [-1, 1], [-1, -1], [1, 1], [1, -1]]
    shifts.each do |x_shift, y_shift|
      coords = [@x + x_shift, @y + y_shift]
      @neighbors << board[coords] if board.in_bound?(coords)
    end
  end

  def neighbor_bomb_count
    neighbors.count { |neighbor| neighbor.mine? }
  end

  def mine?
    @mine
  end

  def set_mine
    @mine = true
  end

  def toggle_flag
    # @flagged ? @flagged = false : @flagged = true
    @flagged = !@flagged
  end

  def revealed?
    @revealed
  end

  def flag?
    @flagged
  end

  def render
    if flag?
      "F"
    elsif !revealed?
      " "
    elsif mine?
      "X"
    else
      neighbor_bomb_count == 0 ? "-" : neighbor_bomb_count
    end
  end
  #
  # def render_dev
  #   if flag?
  #     "F"
  #   elsif mine?
  #     "X"
  #   else
  #     neighbor_bomb_count == 0 ? "_" : neighbor_bomb_count
  #   end
  # end

end
