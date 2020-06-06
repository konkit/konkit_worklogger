require "csv"
require_relative 'utils'

class DayEntry
  include Utils
  attr_reader :time_entries, :time_in_minutes, :start_time, :end_time

  def initialize(time_entries, time_in_minutes, start_time, end_time)
    @time_entries = time_entries
    @time_in_minutes = time_in_minutes
    @start_time = start_time
    @end_time = end_time
  end

  def time_today
    minutes_to_time(@time_in_minutes)
  end
end

class DayEntryLoader
  def initialize(configuration)
    @configuration = configuration
  end

  def load_from_file(year, month, day)
    filename = "%s/%d-%02d-%02d.csv" % [@configuration.path_prefix, year, month, day]

    lines ||= CSV.readlines(filename)

    lines_count = lines.length

    start_time = lines[0][0]

    current_branch = lines[0][1]
    current_start_time = lines[0][0]
    current_end_time = lines[0][0]

    end_time = lines[lines_count - 1][0]

    time_entries = []

    for line in lines
      if line[1] != current_branch
        time_entries.append({start: current_start_time, end: current_end_time, branch: current_branch})

        current_branch = line[1]
        current_start_time = line[0]
        current_end_time = line[0]
      else
        current_end_time = line[0]
      end
    end

    time_entries.append({start: current_start_time, end: current_end_time, branch: current_branch})

    DayEntry.new(time_entries, lines_count, start_time, end_time)
  end
end
