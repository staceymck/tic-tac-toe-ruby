require './player'

class Game
  attr_accessor :board, :winner, :turns
  attr_reader :players

  WINNING_COMBOS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ]

  def initialize
    @board = Array.new(9, " ")
    @winner = "No one"
    @players = [Player.new(name: "Player 1", token: "X"), Player.new(name: "Player 2", token: "O")]
    @turns = 0
  end

  def player_1
    players[0]
  end

  def player_2
    players[1]
  end

  def play
    puts "How to play:"
    puts "#{player_1.name} is #{player_1.token} and #{player_2.name} is #{player_2.token}."
    puts "Select a position by entering a number on each turn"
    print_board([1, 2, 3, 4, 5, 6, 7, 8, 9])

    puts "Let's get started!"
    print_board(board)

    until finished?
      puts "#{current_player.name}, choose a position."
      get_move
      print_board(board)
    end

    declare_winner
  end

  def print_board(board)
    puts ""
    puts "#{board[0]}|#{board[1]}|#{board[2]}"
    puts "-----"
    puts "#{board[3]}|#{board[4]}|#{board[5]}"
    puts "-----"
    puts "#{board[6]}|#{board[7]}|#{board[8]}"
    puts ""
  end
  
  def get_move
    position = gets.chomp.to_i - 1
    if valid_move?(position)
      board[position] = current_player.token
      self.turns += 1
    else
      puts "That's not an option. Choose again."
      get_move
    end
  end

  def valid_move?(position)
    (0..8).cover?(position) && !position_taken?(position)
  end

  def position_taken?(position)
    !board[position].strip.empty?
  end

  def current_player
    turns.even? ? players[0] : players[1]
  end

  def winning_combo
    WINNING_COMBOS.find do |combo|
      board[combo[0]] == board[combo[1]] && board[combo[1]] == board[combo[2]] && position_taken?(combo[0])
    end
  end

  def finished?
    won? || draw?
  end

  def draw?
    board.none? {|spot| spot.strip.empty?}
  end

  def won?
    !!winning_combo
  end

  def declare_winner
    winner = if !!winning_combo
      winner_token = board[winning_combo[0]]
      players.find{|player| player.token == winner_token}.name
    elsif draw?
      "Cat ^-^"
    else 
      "No winner"
    end

    puts "Game over. The winner is......#{winner}"
  end

  def end_game
    board = Array.new(9, "")
  end
end
