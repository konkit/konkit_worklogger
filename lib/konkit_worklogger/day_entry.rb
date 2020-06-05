require "csv"
require_relative 'utils'

class DaySummaryPrinter
  def initialize(configuration)
    @configuration = configuration
  end

  def print(year, month, day)
    filename = "%s/%d-%02d-%02d.csv" % [@configuration.path_prefix, year, month, day]

    entry = DayEntryLoader.new.load_from_file filename

    for time_entry in entry.time_entries
      puts "%s - %s\t%s" % [time_entry.start, time_entry.end, time_entry.branch]
    end

    date_string = "%d-%02d-%02d" % [year, month, day]
    puts "%s: %s - %s (%s)" % [date_string, entry.start_time, entry.end_time, entry.time_today]
  end
end

class DayEntry
  include Utils
  attr_reader :time_entries, :lines_count, :start_time, :end_time

  def initialize(time_entries, lines_count, start_time, end_time)
    @time_entries = time_entries
    @lines_count = lines_count
    @start_time = start_time
    @end_time = end_time
  end

  def time_today
    minutes_to_time(@lines_count)
  end
end


class TimeEntry
  attr_reader :start, :end, :branch

  def initialize(time_start, time_end, current_branch)
    @start = time_start
    @end = time_end
    @branch = current_branch
  end
end


class DayEntryLoader
  def load_from_file(path)
    lines ||= CSV.readlines(path)

    lines_count = lines.length

    start_time = lines[0][0]

    current_branch = lines[0][1]
    current_start_time = lines[0][0]
    current_end_time = lines[0][0]

    end_time = lines[lines_count - 1][0]

    time_entries = []

    for line in lines
      if line[1] != current_branch
        time_entries.append(TimeEntry.new(current_start_time, current_end_time, current_branch))

        current_branch = line[1]
        current_start_time = line[0]
      else
        current_end_time = line[0]
      end
    end

    time_entries.append(TimeEntry.new(current_start_time, current_end_time, current_branch))

    DayEntry.new(time_entries, lines_count, start_time, end_time)
  end
end
