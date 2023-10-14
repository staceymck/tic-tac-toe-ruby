require 'test/unit'
require './game'

class GameTest < Test::Unit::TestCase

  def setup
    @game = Game.new
  end

  attr_accessor :game

  test "a new game starts with a blank board" do
    assert_block do
      game.board.all? {|position| position == " "}
    end
  end

  test "a board has 9 positions" do
    assert_equal 9, game.board.length
  end

  test "a game has two players" do
    assert_equal 2, game.players.count
  end

  test "game is over when a player has won" do
    game.board = ["X", "X", "X", "", "", "", "", "", "", ""]
    assert game.won?
    assert game.finished?
  end

  test "game is over when there is a draw" do
    game.board = ["X", "O", "X", "O", "X", "O", "O", "X", "O"]
    assert game.draw? 
    assert game.finished?
  end

  test "#print_board displays board status to user" do
    board = ["X", "X", "X", "", "", "", "", "", "", ""]
    output = capture_output do 
      game.print_board(board)
    end

    assert output.includes("X | X | X")
    assert output.includes("-----")
    assert output.includes(" |  | ")
  end
end