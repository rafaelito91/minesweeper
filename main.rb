require_relative 'minesweeper'
require_relative 'game_printer'
require_relative 'real_printer'
require_relative 'spoiler_printer'

def game_creation
	puts "Hi, welcome to Minesweeper!"
	puts "Would you kindly inform how many lines do you want in your board?"
	lines = gets.strip.to_i
	puts "Ok! What about the columns? How many colums would you like?"
	columns = gets.strip.to_i
	puts "Finally, how many bombs would you like in your board? Beware! The more bombs you add, the harder the game becomes."
	bombs = gets.strip.to_i
	puts "Right. Processing...."
	[lines, columns, bombs]
end

start_parameters = game_creation
minesweeper = Minesweeper.new(start_parameters[0], start_parameters[1], start_parameters[2])
printer = GamePrinter.new(minesweeper.board)
puts "Game started!!!\n\n"

while minesweeper.still_playing? do
	printer.print_board
	is_play = printer.is_play_or_flag
	play = printer.obtain_play
	
	if is_play
		minesweeper.play(play)
	else
		is_safe = minesweeper.flag(play)
		printer.flag_response(play, is_safe)
	end
end

if minesweeper.victory?
	printer.anounce_game_won
else
	printer.anounce_game_lost 
	SpoilerPrinter.new(minesweeper.board).print_board
end

RealPrinter.new(minesweeper.board).ask_total_map