# frozen_string_literal: true

COLUMN_NUM = 3
MARGIN = 10

def extract_elements
  path = Dir.getwd
  Dir.entries(path).filter { |f| !f.start_with? '.' }
end

def format(extracted_elements)
  columns = handle_split_columns(extracted_elements)
  max_num_of_character = max_num_of_character(extracted_elements)
  num_of_elements_of_longest_columns = columns.max_by(&:size)

  (0...num_of_elements_of_longest_columns.length).each do |i|
    tmp = ''
    (0...columns.length).each do |j|
      tmp += columns[j][i].to_s.ljust(max_num_of_character + MARGIN)
    end
    puts tmp
  end
end

def handle_split_columns(arr)
  array_result = []

  max_num_of_row = max_num_of_per_column(arr)

  arr.each_slice(max_num_of_row) { |a| array_result << a }

  array_result
end

def max_num_of_per_column(arr)
  return 0 if arr.empty?

  num_of_remainder = arr.length % COLUMN_NUM
  max_num_of_per_column = arr.length / COLUMN_NUM

  num_of_remainder.zero? ? max_num_of_per_column : max_num_of_per_column + 1
end

def max_num_of_character(arr)
  string_max = arr.max_by(&:length)
  string_max.length
end

def main
  elements = extract_elements.sort
  format(elements)
end

main
