# frozen_string_literal: true

require 'optparse'
require 'date'

def main
  params = ARGV.getopts('m:', 'y:')

  month = params['m'].to_i
  year = params['y'].to_i

  month = check_month(month)
  year = check_year(year)

  number_of_days = Date.new(year, month, -1).day

  start_day = Date.new(year, month, 1)
  x = start_day.wday

  string = "#{month}月 #{year}年"
  puts string.center(20, ' ')
  puts format_calendar(x, number_of_days)
end

def check_month(month)
  month.zero? ? Date.today.month : month
end

def check_year(year)
  year.zero? ? Date.today.year : year
end

def format_calendar(offset, month_length)
  lines = ['日 月 火 水 木 金 土']
  dates = [nil] * offset + (1..month_length).to_a
  dates.each_slice(7) do |week|
    lines << week.map { |date| date.to_s.rjust(3) }.join('')
  end
  lines.join("\n")
end

main
