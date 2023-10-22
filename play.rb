require './game'

# Play tic tac toe!
Game.new.play

at_exit do
  puts "Thanks for playing!"
end