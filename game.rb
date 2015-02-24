require_relative 'board'
require_relative 'tile'
require 'yaml'
require 'byebug'

class Game
  attr_reader :board

  def initialize
    @board = Board.new(5, 5, 4)
  end

  def run
    until won? || lost?
      board.display

      move = get_move(board)
      board.populate_mines(move) unless board.populated?
      if move.last
        board.place_flag(move)
      else
        board.make_move(move)
      end
    end

    board.tiles.each { |tile| tile.reveal if tile.mine? } if lost?
    board.display

    puts "That's too bad" if lost?
    puts "You won!" if won?
  end

  def won?
    @board.tiles.each do |tile|
      # return false unless tile.mine? || tile.revealed?
      return false if !tile.mine? && !tile.revealed?
    end

    true
  end

  def lost?
    @board.tiles.any? do |tile|
      tile.mine? && tile.revealed?
    end
  end

  def get_move(board)
    # coords = [-1, -1]
    loop do
      puts "Where do you want to move?"
      input = gets.chomp.downcase
      if input.include?('save')
        name = input.split(' ').last

        save(name)
        next
      end
      if input.include?('load')
        name = input.split(' ').last
        load(name)
        next
      end
      flag = (input[0] == "f")
      coords = input.scan(/\d+/).map(&:to_i).first(2) << flag
      return coords if board.in_bound?(coords)
      puts "Invalid move"
    end
    # [1, 1, true]
  end

  def save(save_name)
    puts "Saving game '#{save_name}'..", ' '
    File.write("#{save_name}.yml", @board.to_yaml)
  end

  def load(load_name)
    puts "Loading game '#{load_name}'..", ' '
    contents = File.read("#{load_name}.yml")
    @board = YAML::load(contents)
    @board.display
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.run
end
