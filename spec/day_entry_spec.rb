require "konkit_worklogger"
require "rspec"
require 'tempfile'
require_relative 'utils'

RSpec.describe DayEntry do

  conf = WorkLoggerConfiguration.new("/tmp")

  context("when there is a single file with 8 hours of work") do
    before(:each) do
      save_csv_file(conf, 2020, 6, 1)
    end

    after(:all) do
      delete_csv_file(conf, 2020, 6, 1)
    end

    subject { DayEntryLoader.new(conf).load_from_file(2020, 6, 1) }

    it "returns correct value for a single day file" do
      expect(subject.time_in_minutes).to eq(60 * 8)
      expect(subject.time_today).to eq("8:00")
    end
  end
end
