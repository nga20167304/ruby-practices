# frozen_string_literal: true

require 'optparse'

OPTIONS = ARGV.getopts('l')
MARGIN = 8

def count_line_word_size(file)
  line = file.lines.count
  word = file.split.size
  bytesize = file.bytesize

  return [line] if OPTIONS['l']

  [line, word, bytesize]
end

def print_wc(result, file_name = nil)
  puts "#{result.map { |number| number.to_s.rjust(MARGIN) }.join} #{file_name}"
end

def main
  if ARGV.empty?
    print_wc(count_line_word_size($stdin.read))
  else
    print_wc(count_line_word_size(File.read(ARGV[0])), ARGV[0])
  end
end

main
