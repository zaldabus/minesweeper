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
    @user_board.display

    user_input, x, y = @user.prompt

    reveal(x,y) if user_input == 'R'

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
  attr_accessor :solution_board, :user_board

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
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @rows[x][y]
  end

  def []=(pos)
    x, y = pos[0], pos[1]
    @rows[x][y] = "_"
  end

end