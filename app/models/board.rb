class Board
  attr_reader :width, :height
  
  def initialize(width, height)
    @width, @height = width, height
    reset
	end

	def line_full?(y)
	  @field[y].all? { |x| x != 0 }
	end
	
	def line_empty?(y)
	  @field[y].all? { |x| x == 0 }
  end

	def copy_line(src_y, dest_y) 
	  @field[dest_y] = @field[src_y]
  end

	def remove_line(y) 
    y.downto(0) do |i|
      copy_line(i - 1, i)
    end
    
    @field[0]= Array.new(@width, 0)
	end

	def remove_full_lines
	  lines = 0
    y = @height - 1
	  while (y > 0) do 
	    if line_full?(y)
	      remove_line(y)
	      lines = lines + 1
	      y = y + 1
      end
      y = y - 1
    end
	    
	  lines
  end

	def reset
		@field = Array.new(@height) { Array.new(@width, 0) }
	end

	def set_field(x, y, color) 
		if (x >= 0 && x < @width && y >= 0 && y < @height)
			@field[y][x] = color
		end
	end

	def get_field(x, y) 
		if (x >= 0 && x < @width && y >= 0 && y < @height) 
			@field[y][x]
		else
			return 1
		end
	end
	
	def to_s
	  @field.map(&:to_s).join("\n")
	end
	
	def line(y)
	  @field[y]
  end
  
  def empty?
    empty = true
    (@height - 1).downto(0) do |y|
      empty = empty && line_empty?(y)
    end
    empty
  end
  
  def clear_board
    board_iterator do |y, x|
		  @field[y][x] = 0 
	  end
  end
  
  def board_iterator(&block)
    (0..@field.length - 1).each do |y|
      (0..@field[y].length - 1).each do |x|
        yield y, x, @field[y][x]
      end
    end
  end
	
end
