# frozen_string_literal: true

require 'optparse'

class Option
  def initialize
    @options = ARGV.getopts('a', 'l', 'r')
  end

  def option?(name)
    @options[name]
  end
end
