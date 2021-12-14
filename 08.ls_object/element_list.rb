# frozen_string_literal: true

require_relative 'element'

COLUMN_NUM = 3
MARGIN = 10
MARGIN_FOR_L_OPTION = 2

class ElementList
  attr_reader :elements

  def initialize(list_file)
    @elements = list_file.map { |file| Element.new(file) }
  end

  def display
    return if @elements.nil?

    columns = split_elements_into_column
    largest_column_elements_count = columns.max_by(&:size)

    (0...largest_column_elements_count.length).each do |i|
      tmp = ''
      (0...columns.length).each do |j|
        tmp += if columns[j][i].nil?
                 ''
               else
                 columns[j][i].file_name.to_s.ljust(longest_element_name_length + MARGIN)
               end
      end
      puts tmp
    end
  end

  def split_elements_into_column
    elements_after_splitted = []
    max_num_of_row = max_num_of_per_column
    return elements_after_splitted if @elements.nil?

    @elements.each_slice(max_num_of_row) { |a| elements_after_splitted << a }

    elements_after_splitted
  end

  def max_num_of_per_column
    num_of_remainder = @elements.length % COLUMN_NUM
    max_num_of_per_column = @elements.length / COLUMN_NUM

    num_of_remainder.zero? ? max_num_of_per_column : max_num_of_per_column + 1
  end

  def longest_element_name_length
    files = []
    @elements.map { |element| files.push(element.file_name) }
    element_has_max_length = files.max_by(&:length)
    return 0 if element_has_max_length.nil?

    element_has_max_length.length
  end

  def max_length_of_nlink
    nlink_length = @elements.map { |element| element.nlink.to_s.length }
    nlink_length.max
  end

  def max_length_of_size
    size_length = @elements.map { |element| element.size.to_s.length }
    size_length.max
  end

  def display_with_option_l
    blocks = 0
    line = ''
    @elements.each do |element|
      blocks += element.blocks
      line += element.ftype
      line += element.permissions
      line += element.ds_store_file
      line += element.nlink.rjust(max_length_of_nlink + MARGIN_FOR_L_OPTION)
      line += element.owner.rjust(element.owner.length + MARGIN_FOR_L_OPTION)
      line += element.group.rjust(element.group.length + MARGIN_FOR_L_OPTION)
      line += element.size.rjust(max_length_of_size + MARGIN_FOR_L_OPTION)
      line += element.time_lapse
      line += element.file_name.ljust(MARGIN)
      line += "\n"
    end
    puts "total #{blocks}"
    puts line
  end
end
