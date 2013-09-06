class StonePreview < UIView
  def initWithFrame(frame)
    super
    @stone = Stone.new
    @stone_sections = Array.new(@stone.height) { Array.new(@stone.width, 0) }
    
    tile_size = 3
    tile_spacing = 1
    
    if @stone != nil
      
      @stone.board_iterator do |y, x, value|
        x_pos = (tile_size + (2 * tile_spacing)) * x
        y_pos = (tile_size + (2 * tile_spacing)) * y
        @stone_sections[y][x] = UIView.alloc.initWithFrame([[x_pos, y_pos], [tile_size, tile_size]])
        @stone_sections[y][x].backgroundColor = (value != 0) ? UIColor.whiteColor : UIColor.clearColor
        
        self.addSubview @stone_sections[y][x]
      end
    end
    
    self
  end
  
  def set_stone(stone)
    @stone = stone
    @stone.board_iterator do |y, x, value|
      @stone_sections[y][x].backgroundColor = (value != 0) ? UIColor.whiteColor : UIColor.clearColor
    end    
  end
    
end