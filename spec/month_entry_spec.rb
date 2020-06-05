require "konkit_worklogger"
require "rspec"
require 'tempfile'

RSpec.describe MonthEntry do

  let(:configuration) do
    conf = double("Test Configuration")

    allow(conf).to receive(:path_prefix) do
      "/test"
    end

    conf
  end

  let(:day_entry) do
    DayEntry.new([TimeEntry.new("8:00", "16:00", "master")], 480, "8:00", "16:00")
  end

  let(:day_loader) do
    loader = double("DayLoader")

    allow(loader).to receive(:load_from_file) do |arg|
      day_entry if ["/test/2020-06-01.csv", "/test/2020-06-02.csv", "/test/2020-06-03.csv"].include?(arg)
    end

    loader
  end

  it "returns correct value for 3 days" do
    result = MonthEntryLoader.new(configuration, day_loader).load(2020, 6)
    expect(result.time_in_month).to eq(3 * 8 * 60)
  end
end
