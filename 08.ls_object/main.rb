# frozen_string_literal: true

require_relative 'element_list'
require_relative 'option'

def main
  option = Option.new
  elements = element_with_option(option)
  element_list = ElementList.new(elements)
  if option.option?('l')
    element_list.display_with_option_l
  else
    element_list.display
  end
end

def element_with_option(option)
  path = Dir.getwd

  elements = Dir.entries(path).sort

  elements = elements.filter { |f| !f.start_with? '.' } unless option.option?('a')
  elements = elements.reverse if option.option?('r')
  elements
end

main
