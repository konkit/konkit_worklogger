require "konkit_worklogger"
require "rspec"
require 'tempfile'

RSpec.describe DayEntry do

  let(:test_in_file) do
    Tempfile.new('csv').tap do |f|
      time_it = Time.new(2020, 6, 1, 8, 0)
      begin
        f << "#{time_it.hour}:#{time_it.min}, master\r"
      end while (time_it += 60) < Time.new(2020, 6, 1, 16, 0)
 
      f.close
    end
  end

  it "returns correct value for a single day file" do
    result = DayEntryLoader.new.load_from_file(test_in_file.path)
    expect(result.lines_count).to eq(60*8)
    expect(result.time_today).to eq("8:00")
  end
end
