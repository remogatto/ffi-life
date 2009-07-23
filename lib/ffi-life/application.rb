require 'getoptlong'

class Life
  class Application
    OPTIONS =  [
                [ "--help", "-u", GetoptLong::NO_ARGUMENT,
                  "Display help information." ],
                [ "--version", "-v", GetoptLong::NO_ARGUMENT,
                  "Display the version number and quit." ],
                [ "--pure-ruby", "-R", GetoptLong::NO_ARGUMENT,
                  "Disable ffi-inliner." ],
               ]

    USAGE_PREAMBLE = <<-EOU
Usage: ffi-life [options] [width] [height] [num_of_ticks]

[width] is the width of the grid
[height] is the height of the grid
[num_of_ticks] is the max number of generations

EOU
    class << self
      def run(w, h, max_ticks)
        process_args
        seed = Array.new(w * h).map { rand(2) }
        grid = @pure_ruby ? Grid.new(seed, w) : NativeGrid.new(seed, w)
        life = Life.new(grid)
        max_ticks.times do |gen_id|
          life.tick!
          puts "#" * w
          print life
          puts "#" * w
          puts "Generation n.#{gen_id + 1}"
        end
      end
      private
      def do_option(option, value = nil)
        case option
        when '--help'
          help
          exit
        when '--pure-ruby'
          @pure_ruby = true
        when '--version'
          puts "ffi-life, version #{Life::VERSION}\n"
          exit
        end
      end
      def command_line_options
        OPTIONS.collect { |lst| lst[0..-2] }
      end
      def process_args
        opts = GetoptLong.new(*command_line_options)
        opts.each { |opt, value| do_option(opt, value) }
      end
      def help
        puts
        puts USAGE_PREAMBLE
        puts "Recognized options are:"
        puts
        OPTIONS.sort.each do |long, short, mode, desc|
          if mode == GetoptLong::REQUIRED_ARGUMENT
            if desc =~ /\b([A-Z]{2,})\b/
              long = long + "=#{$1}"
            end
          end
          printf "  %-20s (%s)\n", long, short
          printf "      %s\n", desc
          puts
        end
      end
    end
  end
end

