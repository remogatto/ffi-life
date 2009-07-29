require 'rubygame'

class Life
  module Runners
    class Rubygame < Runner
      include ::Rubygame

      class Cell
        include ::Rubygame::Sprites::Sprite
        def initialize(cell, scale)
          @cell = cell
          @scale = scale
          @radius = @scale / 2
          @x = @cell.x * @scale
          @y = @cell.y * @scale
          @rect = ::Rubygame::Rect.new(@x - @radius, @y - @radius, @scale, @scale)
          @image = ::Rubygame::Surface.new([@scale, @scale]).draw_circle_s([@radius, @radius], @radius, [0, 255, 0] )
        end
      end

      def initialize(life)
        super
        @screen = Screen.new [640, 480], 0, [HWSURFACE, DOUBLEBUF]
        @screen.title = "Conway's Game Of Life"
        @screen.show_cursor = false

        @queue = EventQueue.new
        @clock = Clock.new
        @clock.target_framerate = 30

        @a_x = @screen.w.to_f / @life.w.to_f
        @a_y = @screen.h.to_f / @life.h.to_f
        @scale = [@a_x, @a_y].max
      end
      
      def run
        catch(:rubygame_quit) do
          loop do
            update
            draw
            @clock.tick
          end
        end
      end
      
      def update
        @queue.each do |ev|
          case ev
          when KeyDownEvent
            case ev.key
            when K_ESCAPE
              throw :rubygame_quit
            when K_Q
              throw :rubygame_quit              
            end
          when QuitEvent
            throw :rubygame_quit
          end
        end
      end
      
      def draw
        @screen.fill([0, 0, 0])
        @life.tick! do |cell|
          Cell.new(cell, @scale).draw(@screen) if cell.alive?
        end
        @screen.flip
      end
    end
  end
end
