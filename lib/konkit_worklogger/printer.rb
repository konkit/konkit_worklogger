

class DaySummaryPrinter
  def initialize(configuration)
    @configuration = configuration
  end

  def print(year, month, day)
    entry = DayEntryLoader.new(@configuration).load_from_file(year, month, day)

    for time_entry in entry.time_entries
      puts "%s - %s\t%s" % [time_entry[:start], time_entry[:end], time_entry[:branch]]
    end

    date_string = "%d-%02d-%02d" % [year, month, day]
    puts "%s: %s - %s (%s)" % [date_string, entry.start_time, entry.end_time, entry.time_today]
  end
end

class MonthSummaryPrinter
  include Utils

  def initialize(configuration)
    @configuration = configuration
  end

  def print(year, month)
    day_loader = DayEntryLoader.new(@configuration)
    month_loader = MonthEntryLoader.new(day_loader)
    entry = month_loader.load(year, month)
    balance_with_carry = month_loader.balance_with_carry(year, month)

    puts "Days worked this month: %d" % entry.days_worked
    puts "Total count of work hours: %s" % minutes_to_time(entry.time_in_month)
    puts "Balance in current month: %s " % minutes_to_time(entry.month_balance)
    puts "Balance with carry in current month: %s " % minutes_to_time(balance_with_carry)
  end
end