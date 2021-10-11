require 'optparse'
require 'date'
params = ARGV.getopts("m:","y:")

month = params["m"].to_i
year = params["y"].to_i

def check_month(month)
  if month == 0
    return Date.today.month
  else
    return month
  end
end

def check_year(year)
  if year == 0
    return Date.today.year
  else
    return year
  end
end

def days_in_month(month, year)
  if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12
    return 31
  elsif month == 4 || month == 6 || month == 9 || month == 11
    return 30
  elsif Date.leap?(year)
    return 29
    else return 28
  end
end

_month = check_month(month)
_year = check_year(year)

number_of_days = days_in_month(_month, _year)

start_day = Time.new(_year,_month,1)
x = start_day.wday

def format_calendar(offset, month_length)
  lines = [ "日 月 火 水 木 金 土" ]
  dates = [nil] * offset + (1..month_length).to_a
  dates.each_slice(7) do |week|
    lines << week.map { |date| date.to_s.rjust(3) }.join('')
  end
  lines.join("\n")
end

string = _month.to_s + "月" + " "+ _year.to_s + "年"
puts string.center(20, " ")
puts format_calendar(x,number_of_days)
