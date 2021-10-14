# frozen_string_literal: true

COLUMN = 3
DISTANCE = 20

path = File.absolute_path('..')

files = Dir.entries(path).filter { |f| !f.start_with? '.' }

line = files.size / COLUMN + 1

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
