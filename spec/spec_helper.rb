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

  def save_csv_file(conf, year, month, day, hours_at_work = 8, branch_name = 'master')
    File.open(Utils::get_filename(conf, year, month, day), "w") do |f|
      time_it = Time.new(year, month, day, 8, 0)
      begin
        line_to_write = "%d:%02d" % [time_it.hour, time_it.min]

        unless branch_name.nil? || branch_name.empty?
          line_to_write += ", #{branch_name}"
        end
        f.write("#{line_to_write}\n")
      end while (time_it += 60) < Time.new(year, month, day, 8 + hours_at_work, 0)
    end
  end

  def delete_csv_file(conf, year, month, day)
    File.delete(get_filename(conf, year, month, day))
  end
end
