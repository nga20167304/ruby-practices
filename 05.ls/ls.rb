# frozen_string_literal: true

COLUMN_NUM = 3
BLANK_NUM = 10

def extract_elements
  path = Dir.getwd
  Dir.entries(path).filter { |f| !f.start_with? '.' }
end

def format(display_num_of_col, display_arr)
  slice_arr = handle_split_col(display_num_of_col, display_arr)
  length_string_max = string_length_max(display_arr)
  arr_has_max_elements = slice_arr.max_by(&:size)

  (0...arr_has_max_elements.length).each do |i|
    tmp = ''
    (0...slice_arr.length).each do |j|
      tmp += slice_arr[j][i].to_s.ljust(length_string_max + BLANK_NUM)
    end
    puts tmp
  end
end

def handle_split_col(col_num, arr)
  array_result = []

  max_num_of_row = num_of_row_max(col_num, arr)

  arr.each_slice(max_num_of_row) { |a| array_result << a }

  array_result
end

def num_of_row_max(col_num, arr)
  return 0 if arr.empty?

  number_of_col_more = arr.length % col_num
  min_num_of_row = arr.length / col_num

  number_of_col_more.zero? ? min_num_of_row : min_num_of_row + 1
end

def string_length_max(arr)
  string_max = arr.max_by(&:length)
  string_max.length
end

def main
  elements = extract_elements.sort
  format(COLUMN_NUM, elements)
end

main
