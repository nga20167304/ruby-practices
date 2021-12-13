# frozen_string_literal: true

require 'optparse'

OPTIONS = ARGV.getopts('l')
MARGIN = 8
INIT_TOTAL = Array.new(OPTIONS['l'] ? 1 : 3).fill(0)

def count_line_word_size(file)
  line = file.lines.count
  word = file.split.size
  size = file.size

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
    counters = ARGV.map { |file_name| count_line_word_size(File.read(file_name)) }
    if counters.size > 1
      total = counters.each_with_index.reduce(INIT_TOTAL) do |accumulator, (count, i)|
        print_wc(count, ARGV[i])
        accumulator.each.with_index.map { |sum, j| sum + count[j] }
      end
      print_wc(total, 'total')
    end
  end
end

main
