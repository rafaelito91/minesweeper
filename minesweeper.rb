require_relative 'cell'

class Minesweeper
	
	WIN_STATUS = "WON"
	LOSS_STATUS = "LOST"
	PLAY_STATUS = "PLAYING"
	
	attr_accessor :board
	attr_accessor :status
	attr_accessor :cells_to_unlock
	
	def initialize(lines, columns, bombs)
		total_cells = lines * columns
		raise ArgumentError.new("The informed amount of bombs will cover or exceed the entire board") if bombs >= total_cells
		status = PLAY_STATUS
		@cells_to_unlock = total_cells - bombs
		initialize_board(lines,columns)
		fill_bombs(lines, columns, bombs)
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

	def play(played_coordinates)
		coordinates = [played_coordinates[0] - 1, played_coordinates[1] - 1]
		
		raise ArgumentError.new("Game is already finished") if !still_playing?
		raise ArgumentError.new("Invalid coordinates chosen") if !coordinates_valid?(coordinates)
		
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
		
		if @cells_to_unlock == 0
			@status = WIN_STATUS
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
	
	def flag(played_coordinates)
		coordinates = [played_coordinates[0] - 1, played_coordinates[1] - 1]
		cell = @board[coordinates[0]][coordinates[1]]
		if cell.covered
			@board[coordinates[0]][coordinates[1]].flag
			return cell.is_safe?			
		end
	end
	
	def still_playing?
		return !([WIN_STATUS, LOSS_STATUS].include? @status)
	end

	def victory?
		@status == WIN_STATUS
	end
end
