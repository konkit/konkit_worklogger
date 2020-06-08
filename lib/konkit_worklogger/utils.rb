

module Utils
  def minutes_to_time(minutes)
    full_hours = minutes / 60
    min_str = (minutes - 60 * full_hours)

    "%d:%02d" % [full_hours, min_str]
  end

  def get_filename(conf, year, month, day)
    folder_path = "%s/%d-%02d" % [conf.worklogger_path, year.to_i, month.to_i]
    FileUtils.mkdir_p(folder_path) unless File.directory?(folder_path)
    "%s/%02d.csv" % [folder_path, day.to_i]
  end
end