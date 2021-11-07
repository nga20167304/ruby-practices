require_relative 'game'

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  shots << Shot.new(s)
end

puts shots
