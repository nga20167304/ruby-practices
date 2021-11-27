# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @shots = marks.split(',')
    frames_shots = shots_into_frames
    @frames = frames_shots.map { |frame_shot| Frame.new(frame_shot) }
  end

  def score
    @frames.each_with_index.sum { |frame, index| bonus_point(index).nil? ? frame.subtotal_score : frame.subtotal_score + bonus_point(index) }
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
      %i[first_shot second_shot].map { |attr| @frames[index_of_frame + 1].send(attr) }.map(&:score).sum
    end
  end

  def bonus_of_spare(index_of_frame)
    @frames[index_of_frame + 1].first_shot.score
  end

  def bonus_point(index_of_frame)
    return unless index_of_frame < 9

    if @frames[index_of_frame].strike?
      bonus_of_strike(index_of_frame)
    elsif @frames[index_of_frame].spare?
      bonus_of_spare(index_of_frame)
    end
  end
end

marks = ARGV[0]
game = Game.new(marks)
puts game.score
