# frozen_string_literal: true

COLUMN_NUM = 3
MARGIN = 10

def extract_elements
  path = Dir.getwd
  Dir.entries(path).filter { |f| !f.start_with? '.' }
end

def display(extracted_elements)
  columns = handle_split_elements_into_column(extracted_elements)
  max_length_of_element_name = max_length_of_element_name(extracted_elements)
  num_of_elements_of_longest_columns = columns.max_by(&:size)

  (0...num_of_elements_of_longest_columns.length).each do |i|
    tmp = ''
    (0...columns.length).each do |j|
      tmp += columns[j][i].to_s.ljust(max_length_of_element_name + MARGIN)
    end
    puts tmp
  end
end

def handle_split_elements_into_column(arr)
  array_after_splitted = []
  max_num_of_row = max_num_of_per_column(arr)
  arr.each_slice(max_num_of_row) { |a| array_after_splitted << a }

  array_after_splitted
end

def max_num_of_per_column(arr)
  return 0 if arr.empty?

  num_of_remainder = arr.length % COLUMN_NUM
  max_num_of_per_column = arr.length / COLUMN_NUM

  num_of_remainder.zero? ? max_num_of_per_column : max_num_of_per_column + 1
end

def max_length_of_element_name(arr)
  element_has_max_length = arr.max_by(&:length)
  element_has_max_length.length
end

def main
  elements = extract_elements.sort
  display(elements)
end

main
