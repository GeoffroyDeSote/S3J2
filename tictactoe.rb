# The tic tac toe game
# Here is the rules
#   - Two players only
#   - Program ask player name

require 'pry'
class Board

  attr_reader :cases
  attr_accessor :state

  def initialize(cases=[])
    @cases = cases
    # create 9 cases and push it on a list
    9.times do
      @cases.push(BoardCase.new)
    @state = "game" #state could be game, win, or tie
    end
  end

  def display
    # format each values of boardcase in a beautifull array
    format_array = []
    @cases.each do |a_case|
      case a_case.value
      when nil
        format_array << "|   |"
      when 'o'
        format_array << "| o |"
      when 'x'
        format_array << "| x |"
      end
    end
    puts format_array[0..2].join
    puts format_array[3..5].join
    puts format_array[6..8].join
  end

  def change_case_value(nbcase, new_value)
    # change the case value
    @cases[nbcase].value = new_value  end

  def can_change_value?(nbcase)
    # check if there is no value
    if @cases[nbcase].value != nil
      return false
    else true
    end
  end
  # Return nil if there is no winner, return 1 if player1 win and 2 if player2 win
  def winner?
    wins = [ # Here is all the possibilites to win
      [0, 1, 2], [3, 4, 5], [6, 7, 8],  # <-- Horizontal wins
      [0, 3, 6], [1, 4, 7], [2, 5, 8],  # <-- Vertical wins
      [0, 4, 8], [2, 4, 6],             # <-- Diagonal wins
    ]
    if wins.any? { |win| win.all? {|a_case| @cases[a_case].value == 'o'}}
      @state = "win"

      return 1
    end
    if wins.any? { |win| win.all? {|a_case| @cases[a_case].value == 'x'}}
      @state = "win"
      return 2
    end
  end

  # Return true if game is TIE
  def tie?
    if @cases.all? { |spot| spot == 'x' || spot == 'o' }

      @state = "tie"

      return true
    end
  end
end

# A classe to manage a Case
class BoardCase
  # get the value of a case readable
  attr_accessor :value

  def initialize(value=nil)
    @value = value
  end
end

# Define a Player
class Player
  # a player as a name
  attr_reader :sign, :name
  attr_accessor :state

  def initialize(name, sign)
    @name = name
    @sign = sign
    @state = "player"
  end
end

# Will take in charge the game
class Game

  attr_reader :board, :players

  def initialize(players=[])
    # Create two players, ask their name and initialise a board
    intro
    puts "Creation des joueurs"
    puts "===================="
    puts "Player1 name ?"
    @player1 = Player.new(gets.chomp, "o")
    players.push(@player1)
    puts "Player2 name ?"
    @player2 = Player.new(gets.chomp, "x")
    players.push(@player2)
    @players = players
    puts "Creation du plateau de jeu"
    puts"Chacune des cases correspond à un chiffre entre 0 et 8"
    @board = Board.new

  end

  def intro
    # A small introduction to TicTacToe
    puts "========================="
    puts "|                       |"
    puts "|      TIC TAC TOE      |"
    puts "|                       |"
    puts "========================="
  end

  def go
    # Launch the game until there is a winner or a tie
    @board.display
    while @player1.state != "winner" || @board.state != "tie" || @player2.state != "winner"
      if @player2.state == "winner"
        puts "#{@player2.name} WIN"
        break
      end
      turn(@player1)
      if @player1.state != "winner" && @player2.state != "winner"
        turn(@player2)
      elsif @board.state == "tie"
        puts "It's a TIE"
      elsif @player1.state == "winner"
        puts "#{@player1.name} WIN"
        break
      elsif @player2.state == "winner"
        puts "#{@player2.name} WIN"
        break
      end
    end
  end


  def turn(player)
    # A turn ask for a move, change case, display and look for winner or tie
    puts "#{player.name} turn:"
    choice = gets.chomp.to_i
    @board.change_case_value(choice,player.sign)
    @board.display
    if @board.winner? || @board.tie?
      case @board.winner?
      when 1
        @player1.state = "winner"
      when 2
        @player2.state = "winner"
      end
      if @board.tie?
        @board.state = "tie"
      end
    end
  end
end

my_game = Game.new.go