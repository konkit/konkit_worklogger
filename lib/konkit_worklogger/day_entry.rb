require "csv"

class DayEntry
  attr_reader :time_entries, :lines_count

  def initialize(time_entries, lines_count)
    @time_entries = time_entries
    @lines_count = lines_count
  end

  def time_today
    full_hours = @lines_count / 60
    min_str = (@lines_count - 60 * full_hours)
    "%d:%02d" % [full_hours, min_str]
  end
end


class TimeEntry
  def initialize(time_start, time_end, current_branch)
    @start = time_start
    @end = time_end
    @current_branch = current_branch
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

    DayEntry.new(time_entries, lines_count)
  end
end
