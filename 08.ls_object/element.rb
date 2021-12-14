# frozen_string_literal: true

class Element
  require 'date'
  require 'etc'

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

  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
    @stat = File::Stat.new(file_name)
  end

  def blocks
    @stat.blocks
  end

  def ftype
    ftype = @stat.ftype
    FTYPE[ftype]
  end

  def permissions
    permissions_number = @stat.mode.to_s(8)[-3, 3].chars.map(&:to_i)
    permissions_number.map { |number| PERMISSIONS[number] }.join
  end

  def nlink
    @stat.nlink.to_s
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size.to_s
  end

  def time_lapse
    mtime = @stat.mtime
    year = mtime.strftime('%Y')
    if year == Date.today.year.to_s
      mtime.strftime(' %b %e %H:%M ')
    else
      mtime.strftime(' %y %m %e %H:%M ')
    end
  end

  def ds_store_file
    if @file_name == '.DS_Store'
      '@'
    else
      ' '
    end
  end
end
