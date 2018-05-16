class Cell
	BOMB_CELL_CHARACTER = "B"
	COVERED_CELL_CHARACTER = "X"

	attr_accessor :covered
	attr_accessor :flagged
	attr_accessor :bomb
	attr_accessor :safe_value
	
	def initialize(is_bomb)
		@covered = true
		@flagged = false
		@bomb = is_bomb
		@safe_value = 0
	end
	
	def is_covered_and_safe?
		@covered == true and @bomb == false
	end
	
	def is_safe?
		@bomb == false
	end

	def is_alone?
		@safe_value == 0
	end

	def uncover
		@covered = false
	end
	
	def increment_safe_value
		@safe_value += 1
	end

	def get_value
		if is_safe?
			return @safe_value.to_s
		else
			return BOMB_CELL_CHARACTER
		end
	end

	def get_value_for_game
		if @covered
			return COVERED_CELL_CHARACTER
		else
			return get_value
		end
	end
	
	def get_value_for_spoiler
		if @covered
			if @bomb
				return BOMB_CELL_CHARACTER
			else
				return COVERED_CELL_CHARACTER
			end
		else
			return get_value
		end
	end
	
end