class Life
  module Runners
    class Console < Runner
      def run(max_ticks = 2000)
        max_ticks.times do |gen_id|
          @life.tick!
          puts "#" * @life.w
          print @life
          puts "#" * @life.w
          puts "Generation n.#{gen_id + 1}"
        end
      end

    end
  end
end
