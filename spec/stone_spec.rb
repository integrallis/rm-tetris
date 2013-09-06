describe "Stone" do
  before do
    @stone = Stone.new(0)
    
    @unrotated = %[[0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0]\n[1, 1, 1, 1, 0]\n[0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0]]
    @rotated_90_1 = %[[0, 0, 0, 0, 0]\n[0, 0, 1, 0, 0]\n[0, 0, 1, 0, 0]\n[0, 0, 1, 0, 0]\n[0, 0, 1, 0, 0]]
    @rotated_90_2 = %[[0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0]\n[0, 1, 1, 1, 1]\n[0, 0, 0, 0, 0]\n[0, 0, 0, 0, 0]]
    @rotated_90_3 = %[[0, 0, 1, 0, 0]\n[0, 0, 1, 0, 0]\n[0, 0, 1, 0, 0]\n[0, 0, 1, 0, 0]\n[0, 0, 0, 0, 0]]
  end
    
  it "can be rotated" do
    @stone.to_s.should == @unrotated
    @stone.rotate
    @stone.to_s.should == @rotated_90_1
    @stone.rotate
    @stone.to_s.should == @rotated_90_2
    @stone.rotate
    @stone.to_s.should == @rotated_90_3
  end
  
  describe "A Stone, in the context of a Board" do
    before do
      @board = Board.new(12, 22)
      @stone.board = @board
    end
    
    it "can be placed on a board" do
      @stone.place
      @board.line(2).to_s.should == "[1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]"
    end
    
    it "can be removed from a board" do
      @stone.take
      @board.should.be.empty
    end
  end
  
end