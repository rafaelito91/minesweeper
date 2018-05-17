require_relative 'minesweeper'
require_relative 'game_printer'
require_relative 'real_printer'
require_relative 'spoiler_printer'

minesweeper = Minesweeper.new(10, 20, 50)
printer = GamePrinter.new(minesweeper.board)

while minesweeper.still_playing? do
	is_play = (rand > 0.5)
	random_play = [rand(10) + 1, rand(20) + 1]

	if is_play
		minesweeper.play(random_play)
	else
		is_safe = minesweeper.flag(random_play)
	end
	
	GamePrinter.new(minesweeper.board).print_board
	puts "\n ----------------------- \n"
end

if minesweeper.victory?
	printer.anounce_game_won
else
	printer.anounce_game_lost 
	SpoilerPrinter.new(minesweeper.board).print_board
	RealPrinter.new(minesweeper.board).print_board
end