describe "Board" do
  before do
    @board = Board.new(12, 22)
  end
  
  describe "A new board" do
    it "is empty" do
      @board.to_s.should == Array.new(22, "[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]").join("\n")
    end
  end
  
  describe "An active board" do
    before do
      # add a couple of full lines
      [20, 21].each do |y|
        (0..11).each do |x|
          @board.set_field(x, y, 1) 
        end
      end
      
      # add a partially populated line
      (0..11).each do |x|
        @board.set_field(x, 19, 1) if (x % 2 == 0)
      end
    end
    
    it "can remove full lines" do
      @board.remove_full_lines
      @board.line(19).to_s.should == "[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]"
      @board.line(20).to_s.should == "[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]"
      @board.line(21).to_s.should == "[1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]"
    end
  end
end