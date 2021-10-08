require 'optparse'

path = File.absolute_path("..")

opt = OptionParser.new
opt.on('ls')
opt.parse(ARGV)

files = Dir.entries(path).filter {|f| !f.start_with? '.'}

line = files.size / 3 + 1

def format_ls(files, line)
  lines = []
  files.each_slice(line) do |x|
    lines << x
  end
  (0..lines.size).each do |i|
    puts lines[0][i].to_s.ljust(20) + lines[1][i].to_s.ljust(20) + lines[2][i].to_s
  end
end

def check_ls(argv, files, line)
  if argv == 'ls'
    format_ls(files, line)
  end
end

check_ls(ARGV[0], files.sort, line)
