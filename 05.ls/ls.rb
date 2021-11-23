# frozen_string_literal: true

require 'date'
require 'etc'

COLUMN_NUM = 3
MARGIN = 10
MARGIN_FOR_L_OPTION = 2
PERMISSIONS = {
  0 => '---',
  1 => '--x',
  2 => '-w-',
  3 => '-wx',
  4 => 'r--',
  5 => 'r-x',
  6 => 'rw-',
  7 => 'rwx'
}.freeze

FTYPE = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's'
}.freeze

def extract_elements
  path = Dir.getwd

  elements = Dir.entries(path).sort

  case ARGV[0]
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

def blocks(file)
  File::Stat.new(file).blocks
end

def ftype(file)
  ftype = File::Stat.new(file).ftype
  FTYPE[ftype]
end

def permissions(file)
  permissions_number = File::Stat.new(file).mode.to_s(8)[-3, 3].chars.map(&:to_i)
  permissions_number.map { |number| PERMISSIONS[number] }.join
end

def nlink(file)
  File::Stat.new(file).nlink.to_s
end

def owner(file)
  Etc.getpwuid(File::Stat.new(file).uid).name
end

def group(file)
  Etc.getgrgid(File::Stat.new(file).gid).name
end

def size(file)
  File::Stat.new(file).size.to_s
end

def time_lapse(file)
  mtime = File::Stat.new(file).mtime
  year = mtime.strftime('%Y')
  if year == Date.today.year.to_s
    mtime.strftime(' %b %e %H:%M ')
  else
    mtime.strftime(' %y %m %e %H:%M ')
  end
end

def max_length_of_nlink(extracted_elements)
  nlink_length = []
  extracted_elements.map { |element| nlink_length.push(File::Stat.new(element).nlink.to_s.length) }
  nlink_length.max
end

def max_length_of_size(extracted_elements)
  size_length = []
  extracted_elements.map { |element| size_length.push(File::Stat.new(element).size.to_s.length) }
  size_length.max
end

def display_with_l_option(extracted_elements)
  blocks = 0
  line = ''
  extracted_elements.each do |element|
    blocks += blocks(element)
    line += ftype(element)
    line += permissions(element)
    line += nlink(element).rjust(max_length_of_nlink(extracted_elements) + MARGIN_FOR_L_OPTION)
    line += owner(element).rjust(owner(element).length + MARGIN_FOR_L_OPTION)
    line += group(element).rjust(group(element).length + MARGIN_FOR_L_OPTION)
    line += size(element).rjust(max_length_of_size(extracted_elements) + MARGIN_FOR_L_OPTION)
    line += time_lapse(element)
    line += element.ljust(MARGIN)
    line += "\n"
  end
  puts "total #{blocks}"
  puts line
end

def main
  if ARGV[0] == '-l'
    display_with_l_option(extract_elements)
  else
    display(extract_elements)
  end
end

main
