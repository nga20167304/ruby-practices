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

  (0...num_of_row_max(display_num_of_col, display_arr)).each do |i|
    tmp = ''
    (0...slice_arr.length).each do |j|
      tmp += slice_arr[j][i].to_s.ljust(length_string_max + BLANK_NUM)
    end
    puts tmp
  end
end

def handle_split_col(col_num, arr)
  return [] if col_num.zero?

  min_num_of_row = (arr.length - (arr.length % col_num)) / col_num
  min_num_of_row = 1 if min_num_of_row.zero?

  array_result = []
  current_pointer_of_arr = 0

  (0...col_num).each do |i|
    break if arr.length <= i

    number_of_col_more = (arr.length % col_num).zero? ? 0 : arr.length - 1

    if i < number_of_col_more
      array_result[i] = arr.slice(current_pointer_of_arr, min_num_of_row + 1)
      current_pointer_of_arr = current_pointer_of_arr + min_num_of_row + 1
    else
      array_result[i] = arr.slice(current_pointer_of_arr, min_num_of_row)
      current_pointer_of_arr += min_num_of_row
    end
  end

  array_result
end

def num_of_row_max(col_num, arr)
  return 0 if arr == []

  number_of_col_more = arr.length % col_num
  min_num_of_row = (arr.length - number_of_col_more) / col_num

  number_of_col_more.zero? ? min_num_of_row : min_num_of_row + 1
end

def string_length_max(arr)
  string_max = arr.max_by { |x| x.length }
  string_max.length
end

def main(display_num_of_col)
  elements = extract_elements.sort
  format(display_num_of_col, elements)
end

main(COLUMN_NUM)
