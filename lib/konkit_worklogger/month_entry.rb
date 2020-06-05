require_relative 'utils'

class MonthSummaryPrinter
  include Utils

  def initialize(configuration)
    @configuration = configuration
  end

  def print(year, month)
    day_loader = DayEntryLoader.new
    entry = MonthEntryLoader.new(@configuration, day_loader).load(year, month)

    puts "Days worked this month: %d" % entry.days_worked
    puts "Total count of work hours: %s" % minutes_to_time(entry.time_in_month)
    puts "Balance in current month: %s " % minutes_to_time(entry.month_balance)
  end
end

class MonthEntry
  attr_reader :time_in_month, :days_worked, :month_balance

  def initialize(time_in_month, days_worked, month_balance)
    @time_in_month = time_in_month
    @days_worked = days_worked
    @month_balance = month_balance
  end
end


class MonthEntryLoader
  def initialize(configuration, day_loader)
    @configuration = configuration
    @day_loader = day_loader
  end

  def load(year, month)
    path_prefix = @configuration.path_prefix

    minutes_of_work = 0
    days_worked = 0
    month_balance = 0

    for day in 1..31
      begin
        filename = "%s/%d-%02d-%02d.csv" % [path_prefix, year, month, day]
        day_entry = @day_loader.load_from_file(filename)

        if !day_entry.nil?
          time_in_day = day_entry.lines_count
          minutes_of_work += time_in_day
          days_worked += 1
          month_balance += time_in_day - (8 * 60)
        end


      rescue Errno::ENOENT
      end
    end

    MonthEntry.new(minutes_of_work, days_worked, month_balance)
  end
end