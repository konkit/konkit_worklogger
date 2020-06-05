

class MonthEntry
  attr_reader :time_in_month

  def initialize(time_in_month)
    @time_in_month = time_in_month
  end
end


class MonthEntryLoader
  def initialize(day_loader)
    @day_loader = day_loader
  end

  def load(year, month)
    time_in_month = 0

    for day in 1..31
      begin
        filename = "%d-%02d-%02d.csv" % [year, month, day]
        time_in_day = @day_loader.load_from_file(filename).lines_count

        time_in_month += time_in_day

      rescue StandardError => e
        puts "Error occured - #{e}"
      end
    end

    MonthEntry.new(time_in_month)
  end
end