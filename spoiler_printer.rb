require_relative 'cell'
require_relative 'board_printer'

class SpoilerPrinter < BoardPrinter
	
	def get_cell_value(cell)
		cell.get_value_for_spoiler
	end
	
	def get_message
		"Bomb locations:"
	end
end