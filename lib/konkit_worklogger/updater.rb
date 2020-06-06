

class Updater
  include Utils

  def initialize(configuration)
    @configuration = configuration
  end

  def write(time)
    file_path = get_filename(@configuration, time.year, time.month, time.day)

    CSV.open(file_path, "a+") do |csv|
      csv << ["%d:%02d" % [time.hour, time.min], "master"]
    end
  end
end