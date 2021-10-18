# frozen_string_literal: true

COLUMN = 3
DISTANCE = 20
BALANCE_LINE = 1

path = File.absolute_path('..')

files = Dir.entries(path).filter { |f| !f.start_with? '.' }

line = if (files.size % COLUMN).zero?
         files.size / COLUMN
       else
         files.size / COLUMN + BALANCE_LINE
       end

def format_ls(files, line)
  lines = slice_array(files, line)

  (0..lines.size).each do |i|
    puts lines[0][i].to_s.ljust(DISTANCE) + lines[1][i].to_s.ljust(DISTANCE) + lines[2][i].to_s unless lines[0][i].nil? && lines[1][i].nil? && lines[2][i].nil?
  end
end

def slice_array(files, line)
  left_lines = []
  center_lines = []
  right_lines = []

  files.each_with_index do |_file, index|
    case index / line
    when 0
      left_lines << files[index]
    when 1
      center_lines << files[index]
    else
      right_lines << files[index]
    end
  end

  lines = []
  lines.push(left_lines)
  lines.push(center_lines)
  lines.push(right_lines)
end

format_ls(files.sort, line)
