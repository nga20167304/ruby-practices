# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @shots = marks.split(',')
    frames_shots = shots_into_frames
    @frames = frames_shots.map { |frame_shot| Frame.new(frame_shot) }
  end

  def score
    score = 0

    @frames.each_with_index.sum do |frame, index_of_frame|
      if index_of_frame < 9
        if frame.strike?
          score += bonus_of_strike(index_of_frame)
        elsif frame.spare?
          score += bonus_of_spare(index_of_frame)
        end
      end
      score += frame.subtotal_score
    end

    score
  end

  def shots_into_frames
    frames = []
    frame = []

    @shots.each do |shot|
      frame << shot

      if frames.size < 10
        if frame.size == 2 || shot == 'X'
          frames << frame.dup
          frame.clear
        end
      else
        frames.last << shot
      end
    end

    frames
  end

  def bonus_of_strike(index_of_frame)
    if index_of_frame < 8 && @frames[index_of_frame + 1].strike?
      10 + @frames[index_of_frame + 2].first_shot.score
    else
      # @frames[index_of_frame + 1].first_shot.score + @frames[index_of_frame + 1].second_shot.score
      [:first_shot, :second_shot].map { |attr| @frames[index_of_frame + 1].send(attr) }.map(&:score).sum
    end
  end

  def bonus_of_spare(index_of_frame)
    @frames[index_of_frame + 1].first_shot.score
  end
end

marks = ARGV[0]
game = Game.new(marks)
puts game.score
