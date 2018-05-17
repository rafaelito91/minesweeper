require_relative 'cell'
require_relative 'board_printer'

class RealPrinter < BoardPrinter
	
	POSITIVE_ANSWER = "Y"
	NEGATIVE_ANSWER = "N"

	def get_cell_value(cell)
		cell.get_value
	end

	def get_message
		"Whole game board:"
	end
	
	def ask_total_map
		repeat_dialog = true
		while repeat_dialog do
			puts "Wanna see the entire board? Obs: (Y/N) case insensitive"
			answer = gets.strip.upcase
			if answer == POSITIVE_ANSWER
				puts "Here it is"
				print_board
				repeat_dialog = false
			end
			if answer == NEGATIVE_ANSWER
				puts "Ok. Have a nice day!"
				repeat_dialog = false
			end
			puts "Sorry. Not a valid answer!"
		end
	end
	
end