class Stone < Board 
  
  attr_accessor :board, :x, :y

	@@stones =
	[
		[
			[0,0,0,0,0],
			[0,0,0,0,0],
			[1,1,1,1,0],
			[0,0,0,0,0],
			[0,0,0,0,0]
		],
		[
			[0,0,0,0,0],
			[0,1,1,0,0],
			[0,1,1,0,0],
			[0,0,0,0,0],
			[0,0,0,0,0]
		],
		[
			[0,0,0,0,0],
			[0,1,1,1,0],
			[0,0,0,1,0],
			[0,0,0,0,0],
			[0,0,0,0,0],
		],
		[
			[0,0,0,0,0],
			[0,0,0,1,0],
			[0,1,1,1,0],
			[0,0,0,0,0],
			[0,0,0,0,0]
		],
		[
			[0,0,0,0,0],
			[0,1,1,0,0],
			[0,0,1,1,0],
			[0,0,0,0,0],
			[0,0,0,0,0]
		],
		[
			[0,0,0,0,0],
			[0,0,1,1,0],
			[0,1,1,0,0],
			[0,0,0,0,0],
			[0,0,0,0,0]
		],
		[
			[0,0,0,0,0],
			[0,0,0,0,0],
			[0,1,1,1,0],
			[0,0,1,0,0],
			[0,0,0,0,0]
		]
	]
	
	def initialize(type = nil)
		super(5,5)
		@new_field = Array.new(5) { Array.new(5, 0) }
		@color = 1
		type.nil? ? set_random_type : set_type(type)
		@x = 0
		@y = 0
	end
	
	def set_type(nr) 
	  board_iterator do |y, x|
		  @field[y][x] = @@stones[nr][y][x] 
	  end
	end
	
	def set_random_type
		set_type(Random.rand(@@stones.length))
	end
	
	def place
		return if (@board==nil)
		board_iterator do |y, x, value|
		  @board.set_field(@x + x, @y + y, @color) if (value != 0) 
	  end
	end
	
	def take
		return if (@board==nil)
		board_iterator do |y, x, value|
		  @board.set_field(@x + x, @y + y, 0) if (value != 0)
	  end
	end

	def can_place_at?(nX, nY)
		return if (@board == nil)
    board_iterator do |y, x, value|
      return false if (value != 0 && @board.get_field(nX + x, nY + y) != 0)
    end
    true		
	end
	
	def rotate
	  board_iterator do |y, x, value|
	    @new_field[4-x][y] = value
	  end
	  
	  board_iterator do |y, x|
	    @field[y][x] = @new_field[y][x]
    end
	end

end
