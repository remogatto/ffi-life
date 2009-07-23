$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../lib')))
require 'ffi-life'

[Life::NativeGrid, Life::Grid].each do |grid|
  
  describe Life, " using #{grid}" do
    before do
      @a = [
            0, 0, 0, 0,
            0, 1, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 0
           ]
      @life = Life.new(grid.new(@a, 4))
    end
    it 'should return the cell at the given coordinates' do
      @life[0, 1].should == 0
      @life[1, 1].should == 1
    end
    it 'should clip the coordinates out of the grid' do
      @life[-1, 0].should == 0
      @life[-3, 1].should == 0
      @life[2, 8].should == 0
    end
    it 'should return a string' do
      @life.tick!
      @life.to_s.should == "....\n....\n.oo.\n....\n....\n"
    end
    it 'should correctly evolve to the next generation' do
      a_0 = [
             0, 0, 0, 0,
             0, 1, 0, 0,
             0, 1, 0, 0,
             0, 0, 1, 0,
             0, 0, 0, 0
            ]
      a_1 = [
             0, 0, 0, 0,
             0, 0, 0, 0,
             0, 1, 1, 0,
             0, 0, 0, 0,
             0, 0, 0, 0
            ]
      a_2 = [
             0, 0, 0, 0,
             0, 0, 0, 0,
             0, 0, 0, 0,
             0, 0, 0, 0,
             0, 0, 0, 0
            ]
      b_0 = [
             0, 0, 0, 0, 0, 0,
             0, 0, 0, 0, 0, 0,
             0, 1, 1, 1, 1, 0,
             0, 0, 0, 0, 0, 0,
             0, 0, 0, 0, 0, 0
            ] 
      b_1 = [
             0, 0, 0, 0, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 0, 0, 0, 0
            ]
      b_2 = [
             0, 0, 0, 0, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 1, 0, 0, 1, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 0, 0, 0, 0
            ]
      c_0 = [
             0, 0, 0, 0, 0, 0,
             0, 0, 1, 0, 0, 0,
             0, 0, 1, 1, 1, 0,
             0, 0, 0, 0, 0, 0,
             0, 0, 0, 0, 0, 0
            ]    
      c_1 = [
             0, 0, 0, 0, 0, 0,
             0, 0, 1, 0, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 0, 1, 0, 0,
             0, 0, 0, 0, 0, 0
            ]    
      c_2 = [
             0, 0, 0, 0, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 0, 0, 0, 0
            ]    
      c_3 = [
             0, 0, 0, 0, 0, 0,
             0, 0, 1, 1, 0, 0,
             0, 1, 0, 0, 1, 0,
             0, 0, 1, 1, 0, 0,
             0, 0, 0, 0, 0, 0
            ]

      Life.new(grid.new(a_0, 4)).tick!.to_a.should == a_1

      life = Life.new(grid.new(a_0, 4))
      life.tick!.to_a.should == a_1
      life.tick!.to_a.should == a_2

      life = Life.new(grid.new(b_0, 6))
      life.tick!.to_a.should == b_1
      life.tick!.to_a.should == b_2

      life = Life.new(grid.new(c_0, 6))
      life.tick!.to_a.should == c_1
      life.tick!.to_a.should == c_2
      life.tick!.to_a.should == c_3
    end
  end

end
