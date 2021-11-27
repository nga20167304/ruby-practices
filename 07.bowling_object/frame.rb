# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = frame[1] ? Shot.new(frame[1]) : Shot.new('0')
    @third_shot = frame[2] ? Shot.new(frame[2]) : Shot.new('0')
  end

  def subtotal_score
    first_shot.score + second_shot.score + third_shot.score
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    !strike? && @first_shot.score + @second_shot.score == 10
  end
end
