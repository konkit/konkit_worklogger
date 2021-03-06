# frozen_string_literal: true

require_relative 'utils'

class MonthEntry
  attr_reader :time_in_month, :days_worked, :month_balance, :day_entries

  def initialize(time_in_month, days_worked, month_balance, day_entries)
    @time_in_month = time_in_month
    @days_worked = days_worked
    @month_balance = month_balance
    @day_entries = day_entries
  end
end

class MonthEntryLoader
  def initialize(day_loader)
    @day_loader = day_loader
  end

  def load(year, month)
    minutes_of_work = 0
    days_worked = 0
    month_balance = 0

    day_entries = {}

    (1..31).each do |day|
      begin
        day_entry = @day_loader.load_from_file(year, month, day)

        unless day_entry.nil?
          time_in_day = day_entry.time_in_minutes

          day_entries[day] = time_in_day
          minutes_of_work += time_in_day
          days_worked += 1
          month_balance += time_in_day - (8 * 60)
        end
      rescue Errno::ENOENT
      end
    end

    MonthEntry.new(minutes_of_work, days_worked, month_balance, day_entries)
  end

  def calculate_balance(year, month)
    entry = load(year, month)
    balance_in_sec = entry.month_balance

    balance_in_sec
  end

  def balance_with_carry(year, month)
    current_month_entry = load(year, month)
    previous_month_entry = load(year, month - 1)

    if previous_month_entry.days_worked != 0
      current_month_entry.month_balance + balance_with_carry(year, month - 1)
    else
      current_month_entry.month_balance
    end
  end
end
