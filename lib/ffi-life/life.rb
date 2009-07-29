class Life

  module GridMixin
    attr_reader :w, :h
    def size
      @w * @h
    end
    def each_with_coordinates
      (0..@h - 1).each do |y|
        (0..@w - 1).each do |x|
          yield get(x, y), x, y
        end
      end
    end
  end

  class NativeGrid < FFI::AutoPointer

    module LibC
      extend FFI::Library
      attach_function :malloc, [ :uint ], :pointer
      attach_function :free, [ :pointer ], :void
    end

    extend Inliner
    include GridMixin

    inline do |builder|
      builder.c %q{
      char get(char *cells, int x, int y, int w, int h)
      {
        if(x > 0 && x < w && y > 0 && y < h) 
        {
          int id = y * w + x;
          return cells[id];
        }
        else
        {
          return 0;
        }
      }
    }
      builder.c %q{
      void put(char *cells, int x, int y, int w, int h, char value)
      {
        if(x > 0 && x < w && y > 0 && y < h) 
        {
          int id = y * w + x;
          cells[id] = value;
        }
      }
    }
      builder.c %q{
      int alive_neighbours(char *cells, int x, int y, int w, int h)
      {
        int sum = get(cells, x - 1, y - 1, w, h);
        sum += get(cells, x, y - 1, w, h);
        sum += get(cells, x + 1, y - 1, w, h);
        sum += get(cells, x + 1, y, w, h);
        sum += get(cells, x + 1, y + 1, w, h);
        sum += get(cells, x, y + 1, w, h);
        sum += get(cells, x - 1, y + 1, w, h);
        sum += get(cells, x - 1, y, w, h);
        return sum;
      }
    }
    end
    def self.release(ptr)
      LibC.free(ptr)
    end
    def initialize(array, w)
      super(LibC.malloc(array.size).put_array_of_char(0, array))
      @w, @h = w, array.size / w
    end
    def get(x, y)
      self.class.get(self, x, y, @w, @h)
    end
    def put(x, y, value)
      self.class.put(self, x, y, @w, @h, value)
    end
    def alive_neighbours(x, y)
      self.class.alive_neighbours(self, x, y, @w, @h)
    end
    def to_a
      get_array_of_char(0, size)
    end
  end

  class Grid
    include GridMixin
    def initialize(array, w)
      @w, @h, @cells = w, array.size / w, array
    end
    def get(x, y)
      if x > 0 && x < @w && y > 0 && y < @h
        @cells[y * @w + x]
      else
        0
      end
    end
    def put(x, y, value)
      if x > 0 && x < @w && y > 0 && y < @h
        @cells[y * @w + x] = value
      end
    end
    def alive_neighbours(x, y)
      [[-1, -1], [0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0]].inject(0) do |sum, cell|
        sum += get(x + cell[0], y + cell[1])
      end
    end
    def to_a
      @cells
    end
  end

  class Cell
    attr_reader :x, :y
    [['born', 1], ['die', 0], ['unchanged', '@status']].each do |method, status|
      module_eval(%{def #{method}; @grid[@x, @y] = #{status}; end})
    end
    def initialize(grid, x, y, status)
      @grid = grid
      @x, @y = x, y
      @status = status
    end
    def alive?
      @status == 1
    end
    def alive_neighbours
      @alive_neightbours ||= @grid.alive_neighbours(@x, @y)
    end
    def to_s
      alive? ? "o" : "."
    end
  end

  include Enumerable
  attr_reader :w, :h

  def initialize(seed)
    @w, @h, @cells = seed.w, seed.h, seed
    @nextgen = seed.class.new(Array.new(@w * @h, 0), @w)
  end
  def [](x, y)
    @cells.get(x, y)
  end
  def []=(x, y, value)
    @nextgen.put(x, y, value)
  end
  def alive_neighbours(x, y)
    @cells.alive_neighbours(x, y)
  end
  def each(&blk)
    @cells.each_with_coordinates do |status, x, y|
      yield Cell.new(self, x, y, status)
    end
  end
  def tick!
    each do |cell|
      yield cell if block_given?
      if cell.alive?
        (cell.alive_neighbours < 2 || cell.alive_neighbours > 3) ? cell.die : cell.unchanged
      else
        cell.alive_neighbours == 3 ? cell.born : cell.unchanged
      end
    end
    swap
  end
  def to_s
    inject("") do |result, cell|
      result << cell.to_s << (cell.x == (@w - 1) ? "\n" : "")
    end
  end

  private

  def swap
    temp = @cells
    @cells = @nextgen
    @nextgen = temp
    @cells    
  end
end 
