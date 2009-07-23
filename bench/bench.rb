require 'benchmark'

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))
require 'ffi-life'

@seed_100 = Array.new(100 * 100).map { rand(2) }
@seed_60 = Array.new(60 * 60).map { rand(2) }

@grid_100 = Life.new(Life::NativeGrid.new(@seed_100, 100))
@grid_60 = Life.new(Life::NativeGrid.new(@seed_60, 60))

Benchmark.bm do |b|
  b.report('[ffi-inliner] w: 100 h: 100 ticks: 10') { 10.times { @grid_100.tick! } }
  b.report('[ffi-inliner[ w: 60 h: 60 ticks: 10') { 10.times { @grid_60.tick! } }
end

@grid_100 = Life.new(Life::Grid.new(@seed_100, 100))
@grid_60 = Life.new(Life::Grid.new(@seed_60, 60))

Benchmark.bm do |b|
  b.report('[ruby] w: 100 h: 100 ticks: 10') { 10.times { @grid_100.tick! } }
  b.report('[ruby] w: 60 h: 60 ticks: 10') { 10.times { @grid_60.tick! } }
end

