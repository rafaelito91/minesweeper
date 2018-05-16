require_relative 'minesweeper'

minesweeper = Minesweeper.new(5, 5, 3)

game_ongoing = true

while game_ongoing do
	puts "New play!"
	puts "Inform desired line"
	line = gets 
	puts "Inform desired column"
	column = gets

	game_ongoing = minesweeper.play([line.to_i, column.to_i])
end
