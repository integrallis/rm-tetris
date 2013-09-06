class TetrisController < UIViewController
  
  def viewDidLoad
    super
    setup_toolbar
    setup_gesture_recognizers
    initialize_board
  end
  
  def viewDidUnload
    @swipe_left = nil
    @swipe_right = nil
    @swipe_all_left = nil
    @swipe_all_right = nil
    @swipe_down = nil
    @rotate = nil
  end
  
  def initialize_board
    to_subtract = @toolbar.frame.size.height
    
    @board = Board.new(14, 22)
    @stone = Stone.new
    @next_stone = Stone.new
    @stones = 0
    @game_over = false
    @score = 0
    
    tile_size = 16
    tile_spacing = 1
    
    @board_sections = Array.new(@board.height) { Array.new(@board.width, 0) }
    
    if @board != nil
      board_width = @board.width
      board_height = @board.height
      view_width = view.size.width
      view_height = view.size.height - to_subtract
      
      width_offset = (view_width - ((tile_size + (2 * tile_spacing)) * board_width)) / 2
      height_offset = (view_height - ((tile_size + (2 * tile_spacing)) * board_height)) / 2
      
      @board.board_iterator do |y, x, value|
        x_pos = width_offset + ((tile_size + (2 * tile_spacing)) * x)
        y_pos = height_offset + ((tile_size + (2 * tile_spacing)) * y)
        @board_sections[y][x] = UIView.alloc.initWithFrame([[x_pos, y_pos], [tile_size, tile_size]])
        @board_sections[y][x].backgroundColor = (value != 0) ? UIColor.whiteColor : UIColor.orangeColor
        
        view.addSubview @board_sections[y][x]
      end
    end
    
    view.backgroundColor = UIColor.orangeColor
    view.layer.borderColor = UIColor.whiteColor.CGColor
    view.layer.borderWidth = 4.0
    
    font = UIFont.fontWithName("Inconsolata", size:18)

    @score_label = UILabel.new
    @score_label.font = font
    @score_label.text = "00000"
    @score_label.frame = [[265, 0], [320, 30]]
    @score_label.color = UIColor.whiteColor
    @score_label.setBackgroundColor(UIColor.clearColor)

    view.addSubview(@score_label)
    
    @stone_preview = StonePreview.alloc.initWithFrame([[5, 5], [25, 25]])
    
    view.addSubview(@stone_preview)
  end
  
  def start
    @stone = Stone.new
    @next_stone = Stone.new
    @stones = 0
    @game_over = false
    @score = 0
    @board.clear_board
    @timer = NSTimer.scheduledTimerWithTimeInterval(1, 
                                                      target: self, 
                                                      selector: 'animate',
                                                      userInfo: nil,
                                                      repeats: true)
  end
  
  def stop
    if @timer
      @timer.invalidate
      @timer = nil
    end
  end
  
  def animate
    if !@game_over
      width = @board.width
      height = @board.height
      
      move_down
		
  		(0..height - 1).each do |y|
        (0..width - 1).each do |x|    
          @board_sections[y][x].backgroundColor = (@board.get_field(x, y) != 0) ? UIColor.whiteColor : UIColor.orangeColor
        end
      end
    end
		
  end
  
  def create_stone
    @stones = @stones + 1
    
		@stone = @next_stone
		@stone.board = @board
		@stone.x = 3
		@stone.y = -1

		@next_stone = Stone.new
		@stone_preview.set_stone(@next_stone)

		if @stone.can_place_at?(@stone.x, @stone.y)
			@stone.place
			true
		else
			false
		end
  end
  
  def move_down
    unless @timer.nil?
      @stone.take
  		can_place = @stone.can_place_at?(@stone.x, @stone.y + 1)
  		if can_place
  			@stone.y = @stone.y + 1
  		end
  		@stone.place
  		if !can_place
  			linesRemoved = @board.remove_full_lines
  			@score = @score + (1000 * linesRemoved)
  			display_score
  			if !create_stone 
  			  @game_over = true
  			  stop
  			end
  		end
  		can_place
	  end
  end
  
  def rotate  
    unless @timer.nil?
  		@stone.take
  		@stone.rotate
  		if !@stone.can_place_at?(@stone.x, @stone.y)
  			@stone.rotate
  			@stone.rotate
  			@stone.rotate
  		end
  		@stone.place
	  end
	end
	
	def move_left
	  unless @timer.nil?
  		@stone.take
  		if @stone.can_place_at?(@stone.x - 1, @stone.y)	
  			@stone.x = @stone.x - 1
  		end
  		@stone.place
	  end
	end
	
	def move_all_left
	  unless @timer.nil?
      @stone.take
		
  		begin
  		  can_place = @stone.can_place_at?(@stone.x - 1, @stone.y)
  		  if can_place
    			@stone.x = @stone.x - 1
    		end
  	  end while can_place
	  
  	  @stone.place
  	end	  
	end
	
	def move_right
	  unless @timer.nil?
  		@stone.take
  		if @stone.can_place_at?(@stone.x + 1, @stone.y)			
  			@stone.x = @stone.x + 1
  		end
  		@stone.place
	  end
	end
	
	def move_all_right
	  unless @timer.nil?
      @stone.take
		
  		begin
  		  can_place = @stone.can_place_at?(@stone.x + 1, @stone.y)
  		  if can_place
    			@stone.x = @stone.x + 1
    		end
  	  end while can_place
	  
  	  @stone.place
  	end	  
	end
	
	def drop
	  unless @timer.nil?
      @stone.take
		
  		begin
  		  can_place = @stone.can_place_at?(@stone.x, @stone.y + 1)
  		  if can_place
    			@stone.y = @stone.y + 1
    		end
  	  end while can_place
	  
  	  @stone.place
	  
  		if !can_place
  			linesRemoved = @board.remove_full_lines
  			@score = @score + (1000 * linesRemoved)
  			display_score
  			if !create_stone 
  			  @game_over = true
  			  stop
  			end
  		end
  	end
  end
  
  def display_score
    @score_label.text = "%05d" % @score
  end
  
  def setup_gesture_recognizers
    @swipe_left = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"swipe_left:")
    @swipe_left.direction = UISwipeGestureRecognizerDirectionLeft
    @swipe_left.numberOfTouchesRequired = 1
  
    view.addGestureRecognizer(@swipe_left)
    
    @swipe_right = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"swipe_right:")
    @swipe_right.direction = UISwipeGestureRecognizerDirectionRight
    @swipe_right.numberOfTouchesRequired = 1
  
    view.addGestureRecognizer(@swipe_right)
    
    @swipe_all_left = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"swipe_all_left:")
    @swipe_all_left.direction = UISwipeGestureRecognizerDirectionLeft
    @swipe_all_left.numberOfTouchesRequired = 2
  
    view.addGestureRecognizer(@swipe_all_left)
    
    @swipe_all_right = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"swipe_all_right:")
    @swipe_all_right.direction = UISwipeGestureRecognizerDirectionRight
    @swipe_all_right.numberOfTouchesRequired = 2
  
    view.addGestureRecognizer(@swipe_all_right)
    
    @swipe_down = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:"swipe_down:")
    @swipe_down.direction = UISwipeGestureRecognizerDirectionDown
    @swipe_down.numberOfTouchesRequired = 1
  
    view.addGestureRecognizer(@swipe_down)
    
    @rotate = UIRotationGestureRecognizer.alloc.initWithTarget(self, action:"rotate_gesture:")
    view.addGestureRecognizer(@rotate)
  end
  
  def setup_toolbar
    # set up transparent toolbar
    @toolbar = UIToolbar.alloc.initWithFrame [[0, UIScreen.mainScreen.bounds.size.height - 88], 
                                              [UIScreen.mainScreen.bounds.size.width, 88]]
    @toolbar.tintColor = UIColor.clearColor
    @toolbar.translucent = false
    @toolbar.barStyle = -1
    
    color_mask = [222, 255, 222, 255, 222, 255]
    img = UIImage.alloc.init
    masked_image = UIImage.imageWithCGImage(img.CGImage, color_mask)
    @toolbar.setBackgroundImage(masked_image, forToolbarPosition:UIToolbarPositionAny, 
                                              barMetrics:UIBarMetricsDefault)
    
    self.view.addSubview(@toolbar)
    
    # spacer for toolbar buttons
    spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace,
      target: nil,
      action: nil
    )
        
    # toolbar buttons    
    toolbar_buttons = [
      spacer,
      UIBarButtonItem.alloc.initWithImage(
        UIImage.imageNamed("start.png"), 
        style: UIBarButtonItemStylePlain,
        target: self,
        action: 'start'
      ),
      spacer,
      UIBarButtonItem.alloc.initWithImage(
        UIImage.imageNamed("push_left.png"), 
        style: UIBarButtonItemStylePlain,
        target: self,
        action: 'move_left'
      ),
      spacer,
      UIBarButtonItem.alloc.initWithImage(
        UIImage.imageNamed("push_right.png"), 
        style: UIBarButtonItemStylePlain,
        target: self,
        action: 'move_right'
      ),
      spacer,
      UIBarButtonItem.alloc.initWithImage(
        UIImage.imageNamed("rotate.png"), 
        style: UIBarButtonItemStylePlain,
        target: self,
        action: 'rotate'
      ),
      spacer,
      UIBarButtonItem.alloc.initWithImage(
        UIImage.imageNamed("drop.png"), 
        style: UIBarButtonItemStylePlain,
        target: self,
        action: 'drop'
      ),
      spacer
    ]

    @toolbar.items = toolbar_buttons
  end
	
	# shake 
	
  def viewWillAppear(animated)
    super
    becomeFirstResponder
  end

  def viewDidDisappear(animated)
    super
    resignFirstResponder
  end

  def canBecomeFirstResponder
    true
  end
  
  def motionEnded(motion, withEvent:event)
    if event.subtype == UIEventSubtypeMotionShake
      rotate
    end
    super
  end
  
  # swipe
  
  def swipe_left(sender)
    move_left
  end
  
  def swipe_all_left(sender)
    move_all_left
  end
  
  def swipe_right(sender)
    move_right
  end
  
  def swipe_all_right(sender)
    move_all_right
  end
  
  def swipe_down(sender)
    drop
  end
  
  # rotations
  
  def rotate_gesture(sender)
    if(sender.state == UIGestureRecognizerStateEnded)
      rotate
    end
  end

end