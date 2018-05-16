require_relative 'cell'

class Minesweeper
	
	WIN_STATUS = "WON"
	LOSS_STATUS = "LOST"
	FINISH_STATUS = "FINISHED"

	START_STATUS = "STARTED"
	PLAY_STATUS = "PLAYING"

	
	attr_accessor :board
	attr_accessor :status
	attr_accessor :cells_to_unlock
	
	def initialize(lines, columns, bombs)
		total_cells = lines * columns
		raise ArgumentError.new("The informed amount of bombs will cover or exceed the entire board") if bombs >= total_cells
		status = START_STATUS
		@cells_to_unlock = total_cells - bombs
		initialize_board(lines,columns)
		fill_bombs(lines, columns, bombs)
		anounce_game_start
	end

	def initialize_board(lines, columns)
		@board = Array.new(lines){Array.new(columns)}
		for line in 0..(lines - 1) do
			for column in 0..(columns -1) do
				@board[line][column] = Cell.new(false)			
			end
		end
	end

	def coordinates_valid?(coordinates)
		line = coordinates[0]
		column = coordinates[1]
		
		if line < 0 or column < 0
			return false
		end
		if line > @board.length - 1 or column > @board[0].length - 1
			return false
		end
		true
	end

	def cell_valid_neighbors(cell_line, cell_column)
		neighbors = []
		for line_operator in -1..1 do
			for column_operator in -1..1 do
				next if line_operator == 0 and column_operator == 0
				neighbor = [cell_line + line_operator, cell_column + column_operator]
				if coordinates_valid?(neighbor)
					neighbors << neighbor 	
				end
			end
		end
		neighbors
	end
	
	def fill_bombs(lines, columns, bombs)
		iteration_bombs = bombs
		while iteration_bombs > 0 do
			random_line = rand(lines)
			random_column = rand(columns)

			if @board[random_line][random_column].is_safe?
				@board[random_line][random_column] = Cell.new(true)
				for neighbor in cell_valid_neighbors(random_line, random_column) do
					@board[neighbor[0]][neighbor[1]].increment_safe_value
				end
				iteration_bombs -= 1
			end
		end
	end

	def is_game_finished?
		return [WIN_STATUS, LOSS_STATUS, FINISH_STATUS].include? @status
	end

	def is_game_started?
		@status == START_STATUS
	end

	def is_game_lost?
		@status == LOSS_STATUS
	end

	def play(played_coordinates)
		coordinates = [played_coordinates[0] - 1, played_coordinates[1] - 1]
		
		raise ArgumentError.new("Game is already finished") if is_game_finished?
		raise ArgumentError.new("Invalid coordinates chosen") if !coordinates_valid?(coordinates)
    @status = PLAY_STATUS if is_game_started?
		
		@board[coordinates[0]][coordinates[1]].uncover
		cell = @board[coordinates[0]][coordinates[1]]
		
		if(cell.is_safe?)
			@cells_to_unlock -= 1
			if cell.is_alone?
				for neighbor in cell_valid_neighbors(coordinates[0], coordinates[1])
					expand(neighbor)
				end
			end
		else
			@status = LOSS_STATUS
		end
		
		print_game_board
		auxiliar_method
		
		if @cells_to_unlock == 0
			@status = WIN_STATUS
			anounce_game_won
		end
		if is_game_lost?
			anounce_game_lost
		end
	end

	def expand(coordinates)
		cell = @board[coordinates[0]][coordinates[1]] 
		if(cell.is_safe? and cell.covered)
			@board[coordinates[0]][coordinates[1]].uncover
			@cells_to_unlock -= 1
			if cell.is_alone?
				for neighbor in cell_valid_neighbors(coordinates[0], coordinates[1])
				  expand(neighbor) if @board[neighbor[0]][neighbor[1]].covered
				end
			end
		end
	end

	def uncover_and_recover_neighbors(coordinates)
		@board[coordinates[0]][coordinates[1]].uncover
		@cells_to_unlock -= 1
		cell_valid_neighbors(coordinates[0], coordinates[1])
	end

	def anounce_game_start
		puts "Game started!!!\n\n"
		print_game_board
		auxiliar_method
	end

	def anounce_game_won
		puts "#####################################################"
		puts "#  OHHHHHHHHHHHHHHHHH YEAHHHHHHHHHHHHHH             #"
		puts "#  YYYYYYYYOOOOOOOOUUUUUUU WOOOOOOOOOONNNNNN        #"
		puts "#  \\o\\  \\o/  /o/                                    #"
		puts "#####################################################"
	end

	def anounce_game_lost
		puts "#####################################################"
		puts "# NNNNNNNNOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO   #"
		puts "#    OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!#"
		puts "#      YOU LOST! :(((((( GOOD LUCK NEXT TIME        #"
		puts "#####################################################"
	end
	
	def print_real_board
		for line in @board do
			line_representation = " "
			for cell in line do
				line_representation << cell.get_value + " "
			end
			puts line_representation
		end
	end
	
	def print_game_board
		for line in @board do
			line_representation = " "
			for cell in line do
				line_representation << cell.get_value_for_game + " "
			end
			puts line_representation
		end
	end

	def print_spoiled_board
		for line in @board do
			line_representation = " "
			for cell in line do
				line_representation << cell.get_value_for_spoiler + " "
			end
			puts line_representation
		end
	end
	
	def auxiliar_method
		puts "-------"
		puts "Real board"
		print_real_board
		puts "Cells to unlock: #{@cells_to_unlock}"
	end
end
