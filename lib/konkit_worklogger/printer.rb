class DaySummaryPrinter
  def initialize(configuration)
    @configuration = configuration
  end

  def print(year, month, day)
    entry = DayEntryLoader.new(@configuration).load_from_file(year, month, day)

    date_string = format('%d-%02d-%02d', year, month, day)
    puts format('%s: %s - %s (%s)', date_string, entry.start_time, entry.end_time, entry.time_today)
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

    entry.day_entries.each do |day, minutes|
      day_of_week_abbr = day_of_week(year, month, day)
      puts format('%s %s - %s', day_of_week_abbr, day, minutes_to_time(minutes))
    end

    puts 'Days worked this month: %d' % entry.days_worked
    puts format('Total count of work hours: %s/%s', minutes_to_time(entry.time_in_month), minutes_to_time(entry.days_worked * 8 * 60))
    puts 'Balance in current month: %s ' % minutes_to_time(entry.month_balance)
    puts 'Balance with carry in current month: %s ' % minutes_to_time(balance_with_carry)
  end

  def day_of_week(year, month, day)
    Date.new(year, month, day).strftime('%A')[0..2]
  end
end
