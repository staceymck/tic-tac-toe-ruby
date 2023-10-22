require './player'

class Game
  attr_accessor :board, :winner, :turns, :computer_player
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
  CORNERS = [0, 2, 6, 8]
  CENTER = 4

  def initialize
    @board = Array.new(9, " ")
    @winner = "No one"
    @players = [Player.new(name: "Player 1", token: "X"), Player.new(name: "Player 2", token: "O")]
    @turns = 0
    @computer_player = nil # maybe move this logic into the player class as part of refactor?
    @computer_game = false
  end

  def player_1
    players[0]
  end

  def player_2
    players[1]
  end

  def share_instructions
    puts "How to play:"
    puts "#{player_1.name} is #{player_1.token} and #{player_2.name} is #{player_2.token}"
    puts "Select a position by entering a number on each turn"
    print_board([1, 2, 3, 4, 5, 6, 7, 8, 9])

    puts "Press 1 to play 1v1. Press 2 to play the computer."
    get_game_choice
    print_board(board)
  end

  def play
    share_instructions

    until finished?
      if current_player == computer_player # MVP2 - randomly choose if computer goes 1st or second
        puts "Computer thinking..."
        get_computer_move
      else
        puts "#{current_player.name}, choose a position"
        get_player_move
      end
      sleep(2)
      print_board(board)
    end

    declare_winner
  end

  def get_game_choice
    choice = gets.chomp
    if !["1", "2"].include?(choice)
      puts "Pick 1 or 2, mate"
      get_game_choice
    end
    
    if choice == "2"
      computer_game = true
      self.computer_player = players[0] # MVP2 - randomly choose if computer goes 1st or second
    end

    puts computer_player.name
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
  
  def get_player_move
    position = gets.chomp.to_i - 1
    if valid_move?(position)
      board[position] = current_player.token
      self.turns += 1
    else
      puts "That's not an option. Choose again."
      get_player_move
    end
  end

  def get_computer_move
    position = if winnable_computer_play
      winnable_computer_play.find{|position| !position_taken?(position)}
    elsif opponent_play_to_block
      opponent_play_to_block.find{|position| !position_taken?(position)}
    elsif open_corner
      open_corner
    else
      [0..8].find{|position| valid_move?(position)}
    end

    puts "position is #{position}"
    board[position] = current_player.token
    self.turns += 1
  end

  def winnable_computer_play
    WINNING_COMBOS.find do |combo|
      filled_spots_count = 0
      open_spots_count = 0

      combo.each do |position|
        filled_spots_count += 1 if board[position] == current_player.token
        open_spots_count += 1 if !position_taken?(position)
      end

      filled_spots_count == 2 && open_spots_count == 1
    end
  end

  def opponent_play_to_block
    WINNING_COMBOS.find do |combo|
      filled_spots_count = 0
      open_spots_count = 0

      combo.each do |position|
        filled_spots_count += 1 if board[position] == opponent.token
        open_spots_count += 1 if !position_taken?(position)
      end

      filled_spots_count == 2 && open_spots_count == 1
    end
  end

  def open_corner
    CORNERS.find do |corner|
      !position_taken?(corner)
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

  def opponent
    turns.even? ? players[1] : players[2]
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
