require "konkit_worklogger"
require "rspec"
require 'tempfile'
require_relative 'utils'

RSpec.describe DayEntry do

  conf = WorkLoggerConfiguration.new("/tmp")

  before(:each) do
    save_csv_file(conf, 2020, 6, 1)
  end

  it "returns correct value for a single day file" do
    result = DayEntryLoader.new(conf).load_from_file(2020, 6, 1)
    expect(result.lines_count).to eq(60 * 8)
    expect(result.time_today).to eq("8:00")
  end

  after(:all) do
    delete_csv_file(conf, 2020, 6, 1)
  end
end
