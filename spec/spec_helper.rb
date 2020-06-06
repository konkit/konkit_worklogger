require "bundler/setup"
require "konkit_worklogger"

RSpec.configure do |config|
  include Utils

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def save_csv_file(conf, year, month, day, hours_at_work = 8)
    File.open(Utils::get_filename(conf, year, month, day), "w") do |f|
      time_it = Time.new(year, month, day, 8, 0)
      begin
        f.write("#{time_it.hour}:#{time_it.min}, master\n")
      end while (time_it += 60) < Time.new(year, month, day, 8 + hours_at_work, 0)
    end
  end

  def delete_csv_file(conf, year, month, day)
    File.delete(get_filename(conf, year, month, day))
  end
end
