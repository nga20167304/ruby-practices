# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' # strike
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end
p shots

frames = []
shots.each_slice(2) do |s|
  frames << s
end
p frames

point = 0
frames.each do |frame|
  point += if frame[0] == 10 # strike
             30
           elsif frame.sum == 10 # spare
             frame[0] + 10
           else
             frame.sum
           end
end
puts point
