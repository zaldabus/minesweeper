require 'debugger'



class Minesweeper

  attr_accessor :solution_board, :user_board

  def initialize
    @solution_board = Board.new
    @user_board = Board.new
    @user = User.new
  end

  def play
    @solution_board.seed_bombs
    @solution_board.add_numbers_to_board

    loop do
      @user_board.display

      user_input, x, y = @user.prompt
      action(user_input, x, y)

      if lose?(x,y)
        @solution_board.display
        puts "You lose idiot!"
        return
      end
      return "You win!" if won?
    end
  end

  def action(user_input, x, y)
    reveal(x,y) if user_input == 'R'
    flag(x,y) if user_input == 'F'
    unflag(x,y) if user_input == 'U'
  end

  def lose?(x,y)
    @user_board[[x,y]] == 'X'
  end

  def won?
    @solution_board.total_nums == @user_board.total_nums
  end

  def flag(x,y)
    @user_board[[x,y]] = 'F'
  end

  def unflag(x,y)
    @user_board.rows[x][y] = "*"
  end

  def reveal(x,y)
    @user_board[[x,y]] = @solution_board[[x,y]]

    queue = [[x,y]]
    already_checked = []

    until queue.empty?
      neighbor_pos = queue.shift
      already_checked << neighbor_pos

      next if already_checked.include?(neighbor_pos)
      next if @user_board[neighbor_pos] == 'F'

      if @solution_board[neighbor_pos].is_a?(Fixnum)
        @user_board[neighbor_pos] = @solution_board[neighbor_pos]
        @user_board.total_nums += 1
      elsif @solution_board[neighbor_pos] == "*"
        @user_board[neighbor_pos] = "_"

        neighbors = Board.get_neighbors([neighbor_pos[0],neighbor_pos[1]])

        #neighbors = Board.get_neighbors([neighbor_pos[0],neighbor_pos[1]])
        queue += neighbors.reject {|el| already_checked.include?(el) || queue.include?(el)}
      end
    end
  end

end

class User
  def prompt
    puts "What would you like to do? (R)eveal, (F)lag, (U)nflag"
    puts "For instance: R 3,5"
    input = gets.chomp.split(" ")
    user_action = input[0]
    x,y = input[1].split(",").map(&:to_i)

    [user_action, x, y]
  end
end

class Board
  ROWS = 9
  attr_accessor :rows, :total_nums

  def self.blank_grid
    Array.new(ROWS) {Array.new(ROWS) {"*"}}
  end

  def initialize(rows = self.class.blank_grid)
    @rows = rows
    @total_nums = 0
  end

  def display
    @rows.each { |row|  puts row.join(" ") }
  end

  def seed_bombs
    seeded_bombs = 0

    until seeded_bombs == ((ROWS*ROWS)/(ROWS*1.1)).round
      ran_x, ran_y = rand(ROWS), rand(ROWS)

      if @rows[ran_x][ran_y] == '*'
        @rows[ran_x][ran_y] = 'X'
        seeded_bombs += 1
      end
    end
  end

  def add_numbers_to_board
    @rows.each_index do |i|
      @rows.each_index do |j|
        next if @rows[i][j] == 'X'

        num_bombs = count_neighboring_bombs([i,j])

        if num_bombs > 0
          @rows[i][j] = num_bombs
          @total_nums += 1
        end
      end
    end
  end

  def self.get_neighbors(pos) #Doesn't include out of bounds.
    [[0,1], [0,-1], [1,1], [-1,1],[1,0], [-1,0], [-1,-1], [1,-1]].map do |elem|
      [elem[0]+pos[0], elem[1]+pos[1]].delete_if {|el| Board.out_of_bounds?(el)}
    end
  end

  def count_neighboring_bombs(pos)
    neighbors = Board.get_neighbors(pos)
    num_bombs = 0

    neighbors.each do |neighbor_pos|
      num_bombs += 1 if self[neighbor_pos] == 'X'
    end

    num_bombs
  end

  def self.out_of_bounds?(pos)
    pos[0] < 0 || pos[0] == ROWS || pos[1] < 0 || pos[1] == ROWS
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @rows[x][y]
  end

  def []=(pos, value)
    x, y = pos[0], pos[1]
    value = (value == "*" ? "_" : value)
    @rows[x][y] = value
  end
end


g = Minesweeper.new
g.play