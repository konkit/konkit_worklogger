

module Utils
  def minutes_to_time(minutes)
    full_hours = minutes / 60
    min_str = (minutes - 60 * full_hours)

    "%d:%02d" % [full_hours, min_str]
  end

  def get_filename(conf, year, month, day)
    "%s/%d-%02d-%02d.csv" % [conf.path_prefix, year, month, day]
  end
end