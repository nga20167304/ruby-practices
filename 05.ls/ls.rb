# frozen_string_literal: true

COLUMN_NUM = 3
MARGIN = 10

def extract_elements
  path = Dir.getwd
  Dir.entries(path).filter { |f| !f.start_with? '.' }
end

def display(extracted_elements)
  columns = split_elements_into_column(extracted_elements)
  longest_element_name_length = longest_element_name_length(extracted_elements)
  return if longest_element_name_length.zero?

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
  return 0 if elements.empty?

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
  elements = extract_elements.sort
  display(elements)
end

main
