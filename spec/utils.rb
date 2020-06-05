def save_csv_file(conf, year, month, day)
  File.open(get_filename(conf, year, month, day), "w") do |f|
    time_it = Time.new(year, month, day, 8, 0)
    begin
      f.write("#{time_it.hour}:#{time_it.min}, master\n")
    end while (time_it += 60) < Time.new(year, month, day, 16, 0)
  end
end

def delete_csv_file(conf, year, month, day)
  File.delete(get_filename(conf, year, month, day))
end

def get_filename(conf, year, month, day)
  "%s/%d-%02d-%02d.csv" % [conf.path_prefix, year, month, day]
end