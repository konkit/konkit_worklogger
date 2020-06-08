require "csv"
require_relative 'utils'

class DayEntry
  include Utils
  attr_reader :time_in_minutes, :start_time, :end_time

  def initialize(time_in_minutes, start_time, end_time)
    @time_in_minutes = time_in_minutes
    @start_time = start_time
    @end_time = end_time
  end

  def time_today
    minutes_to_time(@time_in_minutes)
  end
end

class DayEntryLoader
  include Utils

  def initialize(configuration)
    @configuration = configuration
  end

  def load_from_file(year, month, day)
    filename = get_filename(@configuration, year, month, day)

    lines ||= CSV.readlines(filename)

    lines_count = lines.length

    start_time = lines[0][0]

    end_time = lines[lines_count - 1][0]

    DayEntry.new(lines_count, start_time, end_time)
  end
end
