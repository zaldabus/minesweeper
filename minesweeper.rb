
class Minesweeper

  attr_accessor :solution_board, :user_board

  def initialize
    @solution_board = Board.new
    @solution_board.seed_bombs
    @user_board = Board.new
    @user = User.new
    p @solution
    p @user_board
  end

  def play
    turn
  end

  def turn
    loop do
    @user_board.display

    user_input, x, y = @user.prompt

    reveal(x,y) if user_input == 'R'
    flag(x,y) if user_input == 'F'
    unflag(x,y) if user_input == 'U'
    break if user_input == 'exit'
  end
  end

  def flag(x,y)
    @user_board[[x,y]] = 'F'
  end

  def unflag(x,y)
    @user_board.rows[x][y] = "*"
  end

  def reveal(x,y)
    @user_board[[x,y]] = @solution_board[[x,y]]

    game_over if @user_board[[x,y]] == 'X'


  end

  def game_over
    puts 'You lose'
  end

end

class User

  def prompt
    puts "The fuck u wanna do?"
    input = gets.chomp.split(" ")
    user_action = input[0]
    x,y = input[1].split(",").map(&:to_i)

    [user_action, x, y]
  end


end



class Board
  ROWS = 9
  attr_accessor :rows

  def self.blank_grid
    Array.new(9) {Array.new(9) {"*"}} #then does this make sense?
  end

  def initialize(rows = self.class.blank_grid)
    #this is in Minesweeper class. not board class irgh tnow.
    @rows = rows
  end

  def display
    p @rows
  end

  def seed_bombs
    #how do we mark the bombs? just like B?
    seeded_bombs = 0

    until seeded_bombs == 10
      ran_x = rand(9)
      ran_y = rand(9)

      if @rows[ran_x][ran_y] == '*'
        @rows[ran_x][ran_y] = 'X'
        seeded_bombs += 1
      end
    end

    add_nums
  end

  def add_nums
    @rows.each_index do |i|
      @rows.each_index do |j|
        next if @rows[i][j] == 'X'
        num_bombs = count_neighboring_bombs([i,j])
        @rows[i][j] = num_bombs if num_bombs > 0
      end
    end
  end

  def count_neighboring_bombs(pos) #[x,y]
    neighbors = [
      [0,1],
      [0,-1],
      [1,1],
      [-1,1],
      [1,0],
      [-1,0],
      [-1,-1],
      [1,-1]
    ].map {|elem| [elem[0]+pos[0], elem[1]+pos[1]]}

    num_bombs = 0
    neighbors.each do |neighbor_pos|
      next if out_of_bounds?(neighbor_pos)
      num_bombs += 1 if self[neighbor_pos] == 'X'
    end
    num_bombs
  end

  def out_of_bounds?(pos)
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