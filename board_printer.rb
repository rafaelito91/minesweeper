class BoardPrinter
	
	attr_accessor :board
	
	def initialize(game_board)
		@board = game_board
	end

	def print_board
		puts get_message
		puts "\n\n"
		for line in @board do
			line_representation = " "
			for cell in line do
				line_representation << get_cell_value(cell) + " "
			end
			puts line_representation
		end
		puts "\n\n"
	end

	def get_cell_value(cell)
		raise NotImplementedError.new "Method is not implemented in this class, only in its child"
	end

	def get_message
		raise NotImplementedError.new "Method is not implemented in this class, only in its child"
	end
end