require_relative 'cell'
require_relative 'board_printer'

class GamePrinter < BoardPrinter
	
	PLAY_ANSWER = "P"
	FLAG_ANSWER = "F"

	def get_cell_value(cell)
		cell.get_value_for_game
	end

	def get_message
		"Actual game board:"
	end

	def flag_response(coordinates, is_safe)
		message = "The flag identified that the cell located at coordinates [#{coordinates[0]}, #{coordinates[1]}] is "
		if is_safe
			message << "safe to play"
		else
			message << "dangerous to play"
		end
		puts message
	end

	def is_play_or_flag
		is_play = false
		repeat_dialog = true
		while repeat_dialog do
			puts "Would you like to make a Play(P) or use a Flag(F)? Obs: (P/F) case insensitive"
			answer = gets.strip.upcase
			if (answer != PLAY_ANSWER) and (answer != FLAG_ANSWER)
				puts "Sorry. Not a valid answer!"
			end
			if answer == PLAY_ANSWER
				repeat_dialog = false
				is_play = true
				puts "New play!"
			end
			if answer == FLAG_ANSWER
				repeat_dialog = false
				is_play = false
				puts "New flag!"
			end
		end
		is_play
	end

	def obtain_play
		puts "Inform desired line"
		line = gets.strip.to_i
		puts "Inform desired column"
		column = gets.strip.to_i
		puts "\n\n\n"
		[line, column]
	end

	def anounce_game_won
		puts "#####################################################"
		puts "#  OHHHHHHHHHHHHHHHHH YEAHHHHHHHHHHHHHH             #"
		puts "#  YYYYYYYYOOOOOOOOUUUUUUU WOOOOOOOOOONNNNNN        #"
		puts "#  \\o\\  \\o/  /o/                                    #"
		puts "#####################################################"
		puts "\n\n"
	end

	def anounce_game_lost
		puts "#####################################################"
		puts "# NNNNNNNNOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO   #"
		puts "#    OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!#"
		puts "#      YOU LOST! :(((((( GOOD LUCK NEXT TIME        #"
		puts "#####################################################"
		puts "\n\n"
	end

end