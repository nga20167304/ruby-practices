# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frame

  def initialize(first_mark, second_mark, third_mark = nil)
    @frame = Frame.new(first_mark, second_mark, third_mark)
  end

  def score
    frame.score
  end
end
