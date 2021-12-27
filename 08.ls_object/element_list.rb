# frozen_string_literal: true

require_relative 'element'

COLUMN_NUM = 3
MARGIN = 10
MARGIN_FOR_L_OPTION = 2

class ElementList
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

  private

  def split_elements_into_column
    max_num_of_row = max_num_of_per_column
    return elements_after_splitted if @elements.nil?

    @elements.each_slice(max_num_of_row).to_a
  end

  def max_num_of_per_column
    num_of_remainder = @elements.length % COLUMN_NUM
    max_num_of_per_column = @elements.length / COLUMN_NUM

    num_of_remainder.zero? ? max_num_of_per_column : max_num_of_per_column + 1
  end

  def longest_element_name_length
    @elements.map { |element| element.file_name.length }.max || 0
  end

  def max_length_of_nlink
    @elements.map { |element| element.nlink.to_s.length }.max || 0
  end

  def max_length_of_size
    @elements.map { |element| element.size.to_s.length }.max || 0
  end
end
