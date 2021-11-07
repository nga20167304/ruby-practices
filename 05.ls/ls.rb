# frozen_string_literal: true

class Ls
  COLUMN_NUM = 3
  MARGIN = 10

  def extract_elements
    path = Dir.getwd

    option = value_of_option
    elements = Dir.entries(path).sort

    case option
    when '-a'
      elements
    when '-r'
      elements.reverse.filter { |f| !f.start_with? '.' }
    else
      elements.filter { |f| !f.start_with? '.' }
    end
  end

  def display(extracted_elements)
    return if extracted_elements.empty?

    columns = split_elements_into_column(extracted_elements)
    longest_element_name_length = longest_element_name_length(extracted_elements)
    largest_column_elements_count = columns.max_by(&:size)

    (0...largest_column_elements_count.length).each do |i|
      tmp = ''
      (0...columns.length).each do |j|
        tmp += columns[j][i].to_s.ljust(longest_element_name_length + MARGIN)
      end
      puts tmp
    end
  end

  def split_elements_into_column(columns)
    elements_after_splitted = []
    max_num_of_row = max_num_of_per_column(columns)
    return elements_after_splitted if columns.empty?

    columns.each_slice(max_num_of_row) { |a| elements_after_splitted << a }

    elements_after_splitted
  end

  def max_num_of_per_column(elements)
    num_of_remainder = elements.length % COLUMN_NUM
    max_num_of_per_column = elements.length / COLUMN_NUM

    num_of_remainder.zero? ? max_num_of_per_column : max_num_of_per_column + 1
  end

  def longest_element_name_length(elements)
    element_has_max_length = elements.max_by(&:length)
    return 0 if element_has_max_length.nil?

    element_has_max_length.length
  end

  def main
    elements = extract_elements
    display(elements)
  end

  private

  def value_of_option
    ARGV[0]
  end
end

ls = Ls.new
ls.main
