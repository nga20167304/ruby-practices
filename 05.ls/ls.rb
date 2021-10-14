# frozen_string_literal: true

COLUMN = 3
DISTANCE = 20
BALANCE_LINE = 1

path = File.absolute_path('..')

files = Dir.entries(path).filter { |f| !f.start_with? '.' }

line = if (files.size % COLUM).zero?
         files.size / COLUMN
       else
         files.size / COLUMN + BALANCE_LINE
       end

def format_ls(files, line)
  lines = []
  files.each_slice(line) do |x|
    lines << x
  end

  (0..lines.size).each do |i|
    puts lines[0][i].to_s.ljust(DISTANCE) + lines[1][i].to_s.ljust(DISTANCE) + lines[2][i].to_s
  end
end

format_ls(files.sort, line)
