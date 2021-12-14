# frozen_string_literal: true

class Option
  require 'optparse'

  def initialize
    @options = ARGV.getopts('a', 'l', 'r')
  end

  def option?(name)
    @options[name]
  end
end
