# frozen_string_literal: true

require 'konkit_worklogger'
require 'rspec'

RSpec.describe DayEntry do
  include Utils

  conf = WorkLoggerConfiguration.new('/tmp')

  context('when there is a file with 8 hours of work') do
    before(:each) do
      save_csv_file(conf, 2020, 6, 1)
    end

    after(:all) do
      delete_csv_file(conf, 2020, 6, 1)
    end

    subject { DayEntryLoader.new(conf).load_from_file(2020, 6, 1) }

    it 'returns correct value for a single day file' do
      expect(subject.time_in_minutes).to eq(60 * 8)
      expect(subject.time_today).to eq('8:00')
    end
  end

  context('when there is a file with breaks but the branch is the same') do
    before(:each) do
      CSV.open(get_filename(conf, 2020, 6, 1), 'w') do |csv|
        csv << ['10:00', 'master']
        csv << ['10:01', 'master']
        csv << ['10:02', 'master']
        csv << ['13:00', 'master']
        csv << ['13:01', 'master']
      end
    end

    after(:all) do
      delete_csv_file(conf, 2020, 6, 1)
    end

    subject { DayEntryLoader.new(conf).load_from_file(2020, 6, 1) }

    it 'returns correct value for a single day file' do
      expect(subject.time_in_minutes).to eq(5)
      expect(subject.time_today).to eq('0:05')
      expect(subject.start_time).to eq('10:00')
      expect(subject.end_time).to eq('13:01')
      expect(subject.time_entries).to eq([{ start: '10:00', end: '13:01', branch: 'master' }])
    end
  end

  context('when there is a file with breaks and the branches are different') do
    before(:each) do
      CSV.open(get_filename(conf, 2020, 6, 1), 'w') do |csv|
        csv << ['10:00', 'master']
        csv << ['10:01', 'master']
        csv << ['10:02', 'master']
        csv << ['13:00', 'other']
        csv << ['13:01', 'other']
      end
    end

    after(:all) do
      delete_csv_file(conf, 2020, 6, 1)
    end

    subject { DayEntryLoader.new(conf).load_from_file(2020, 6, 1) }

    it 'returns correct value for a single day file' do
      expect(subject.time_in_minutes).to eq(5)
      expect(subject.time_today).to eq('0:05')
      expect(subject.start_time).to eq('10:00')
      expect(subject.end_time).to eq('13:01')

      expected_time_entries = [
          { start: '10:00', end: '10:02', branch: 'master' },
          { start: '13:00', end: '13:01', branch: 'other' }
      ]
      expect(subject.time_entries).to eq(expected_time_entries)
    end
  end

  context('when there is a file with breaks and the second part is just a single minute with a different branch') do
    before(:each) do
      CSV.open(get_filename(conf, 2020, 6, 1), 'w') do |csv|
        csv << ['10:00', 'master']
        csv << ['10:01', 'master']
        csv << ['10:02', 'master']
        csv << ['13:00', 'other']
      end
    end

    after(:all) do
      delete_csv_file(conf, 2020, 6, 1)
    end

    subject { DayEntryLoader.new(conf).load_from_file(2020, 6, 1) }

    it 'returns correct value for a single day file' do
      expect(subject.time_in_minutes).to eq(4)
      expect(subject.time_today).to eq('0:04')
      expect(subject.start_time).to eq('10:00')
      expect(subject.end_time).to eq('13:00')

      expected_time_entries = [
          { start: '10:00', end: '10:02', branch: 'master' },
          { start: '13:00', end: '13:00', branch: 'other' }
      ]
      expect(subject.time_entries).to eq(expected_time_entries)
    end
  end
end
