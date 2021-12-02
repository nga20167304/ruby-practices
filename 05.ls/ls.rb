# frozen_string_literal: true

require 'date'
require 'etc'
require 'optparse'

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

OPTIONS = ARGV.getopts('a', 'l', 'r')

def extract_elements
  path = Dir.getwd

  elements = Dir.entries(path).sort

  return elements.reverse!.filter { |f| !f.start_with? '.' } if OPTIONS['r'] && !OPTIONS['a']
  return elements.reverse! if OPTIONS['r']
  return elements if OPTIONS['a']

  elements.filter { |f| !f.start_with? '.' }
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
  nlink = File::Stat.new(file).nlink
  nlink.to_s.rjust(max_length_of_nlink(extract_elements) + MARGIN_FOR_L_OPTION)
end

def owner(file)
  owner = Etc.getpwuid(File::Stat.new(file).uid).name
  owner.rjust(owner.length + MARGIN_FOR_L_OPTION)
end

def group(file)
  group = Etc.getgrgid(File::Stat.new(file).gid).name
  group.rjust(group.length + MARGIN_FOR_L_OPTION)
end

def size(file)
  size = File::Stat.new(file).size
  size.to_s.rjust(max_length_of_size(extract_elements) + MARGIN_FOR_L_OPTION)
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
  nlink_length = extracted_elements.map { |element| File::Stat.new(element).nlink.to_s.length }
  nlink_length.max
end

def max_length_of_size(extracted_elements)
  size_length = extracted_elements.map { |element| File::Stat.new(element).size.to_s.length }
  size_length.max
end

def ds_store_file(extracted_elements)
  if extracted_elements == '.DS_Store'
    '@'
  else
    ' '
  end
end

def display_with_l_option(extracted_elements)
  blocks = 0
  line = ''
  extracted_elements.each do |element|
    blocks += blocks(element)
    line += ftype(element)
    line += permissions(element)
    line += ds_store_file(element)
    line += nlink(element)
    line += owner(element)
    line += group(element)
    line += size(element)
    line += time_lapse(element)
    line += element.ljust(MARGIN)
    line += "\n"
  end
  puts "total #{blocks}"
  puts line
end

def main
  if OPTIONS['l']
    display_with_l_option(extract_elements)
  else
    display(extract_elements)
  end
end

main
