require "konkit_worklogger"
require "rspec"
require 'tempfile'
require_relative 'utils'

RSpec.describe MonthEntry do

  conf = WorkLoggerConfiguration.new("/tmp")

  before(:all) do
    (1..3).each do |day|
      save_csv_file(conf, 2020, 6, day)
    end
  end

  it "returns correct value for 3 days" do
    day_loader = DayEntryLoader.new(conf)

    result = MonthEntryLoader.new(day_loader).load(2020, 6)
    expect(result.time_in_month).to eq(3 * 8 * 60)
  end

  after(:all) do
    (1..3).each do |day|
      delete_csv_file(conf, 2020, 6, day)
    end
  end
end
