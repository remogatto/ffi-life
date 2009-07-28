require 'rubygame'

class Life
  module Runners
    class Rubygame < Runner
      include ::Rubygame
      def initialize(life)
        super
        @screen = Screen.new [640, 480], 0, [HWSURFACE, DOUBLEBUF]
        @screen.title = "Conway's Game Of Life"
        
        @background = Surface.new(@screen.size)

        @queue = EventQueue.new
        @clock = Clock.new
        @clock.target_framerate = 30

        @box_w = @screen.w.to_f / @life.w.to_f
        @box_h = @screen.h.to_f / @life.h.to_f

        @box_w_2 = @box_w / 2
        @box_h_2 = @box_h / 2
      end
      
      def run
        loop do
          @background.fill([0, 0, 0])
          update
          draw
          @clock.tick
          @life.tick!
          @background.blit(@screen, [0, 0])
          @screen.update
        end
      end
      
      def update
        @queue.each do |ev|
          case ev
          when QuitEvent
            quit
            exit
          end
        end
      end
      
      def draw_cell(x, y)
        scaled_x = x * @box_w
        scaled_y = y * @box_h
        radius = [@box_w, @box_h].min
        @background.draw_circle_s([scaled_x, scaled_y], radius, [0, 255, 0] )
      end

      def draw
        @life.each do |cell|
          draw_cell(cell.x, cell.y) if cell.alive?
        end
      end
    end
  end
end
