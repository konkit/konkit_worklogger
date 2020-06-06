require "konkit_worklogger"
require "rspec"
require "csv"
# require_relative 'utils'

RSpec.describe Updater do
  include Utils

  conf = WorkLoggerConfiguration.new("/tmp")

  context("Create and write to file if it doesnt exist") do
    let(:time_now) { Time.new(2020, 6, 6, 12, 0) }

    subject { Updater.new(conf).write(time_now) }

    after(:each) { delete_csv_file(conf, 2020, 6, 6) }

    it "returns correct value for a single day file" do
      subject

      lines = CSV.readlines(get_filename(conf, 2020, 6, 6))

      expect(lines).to eq([["12:00", "master"] ])
    end
  end

  context("Create and write to file if it did exist before exist") do
    let(:time_now) { Time.new(2020, 6, 6, 12, 0) }

    subject { Updater.new(conf).write(time_now) }

    before(:each) do
      CSV.open(get_filename(conf, 2020, 6, 6), "w") do |csv|
        csv << ["11:59", "master"]
      end
    end

    after(:each) { delete_csv_file(conf, 2020, 6, 6) }

    it "returns correct value for a single day file" do
      subject

      lines = CSV.readlines(get_filename(conf, 2020, 6, 6))

      expect(lines).to eq([["11:59", "master"], ["12:00", "master"] ])
    end
  end
end
