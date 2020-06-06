require "konkit_worklogger"
require "rspec"
require 'tempfile'
require_relative 'utils'

RSpec.describe MonthEntry do

  conf = WorkLoggerConfiguration.new("/tmp")

  context("when there are 3 files from a given month") do
    before(:all) do
      (1..3).each {|day| save_csv_file(conf, 2020, 6, day)}
    end

    after(:all) do
      (1..3).each {|day| delete_csv_file(conf, 2020, 6, day)}
    end

    describe("load") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).load(2020, 6)
      end

      it "should return correct value of minutes worked" do
        expect(subject.time_in_month).to eq(3 * 8 * 60)
      end

      it "should return correct value of days worked" do
        expect(subject.days_worked).to eq(3)
      end

      it "should return correct value of current month's balance" do
        expect(subject.month_balance).to eq(0)
      end
    end

    describe("calculate_balance") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).calculate_balance(2020, 6)
      end

      it "should return correct value of minutes worked" do
        expect(subject).to eq(0)
      end
    end
  end

  context("when there is lack of hours in previous month and there are entries in current month") do
    before(:all) do
      (1..3).each { |day| save_csv_file(conf, 2020, 5, day, 7) }
      (1..3).each { |day| save_csv_file(conf, 2020, 6, day) }
    end

    after(:all) do
      (1..3).each { |day| delete_csv_file(conf, 2020, 5, day) }
      (1..3).each { |day| delete_csv_file(conf, 2020, 6, day) }
    end

    describe("calculate_balance in previous month") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).calculate_balance(2020, 5)
      end

      it "should return the inbalance correctly" do
        expect(subject).to eq(-3 * 60)
      end
    end

    describe("calculate_balance in current month") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).calculate_balance(2020, 6)
      end

      it "should return the balance correctly" do
        expect(subject).to eq(0)
      end
    end

    describe("balance_with_carry") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).balance_with_carry(2020, 6)
      end

      it "should return the inbalance correctly" do
        expect(subject).to eq(-3 * 60)
      end
    end
  end

  context("when there is lack of hours in both previous and current month") do
    before(:all) do
      (1..3).each { |day| save_csv_file(conf, 2020, 5, day, 7) }
      (1..3).each { |day| save_csv_file(conf, 2020, 6, day, 6) }
    end

    after(:all) do
      (1..3).each { |day| delete_csv_file(conf, 2020, 5, day) }
      (1..3).each { |day| delete_csv_file(conf, 2020, 6, day) }
    end

    describe("calculate_balance in previous month") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).calculate_balance(2020, 5)
      end

      it "should return the inbalance correctly" do
        expect(subject).to eq(-3 * 60)
      end
    end

    describe("calculate_balance in current month") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).calculate_balance(2020, 6)
      end

      it "should return the inbalance correctly" do
        expect(subject).to eq(-3 * 2 * 60)
      end
    end

    describe("balance_with_carry") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).balance_with_carry(2020, 6)
      end

      it "should return the inbalance correctly" do
        expect(subject).to eq(-3 * 60 + -3 * 2 * 60)
      end
    end
  end

  context("when there is lack of hours in 2 months ago") do
    before(:all) do
      (1..3).each { |day| save_csv_file(conf, 2020, 4, day, 7) }
      (1..3).each { |day| save_csv_file(conf, 2020, 5, day) }
      (1..3).each { |day| save_csv_file(conf, 2020, 6, day) }
    end

    after(:all) do
      (1..3).each { |day| delete_csv_file(conf, 2020, 4, day) }
      (1..3).each { |day| delete_csv_file(conf, 2020, 5, day) }
      (1..3).each { |day| delete_csv_file(conf, 2020, 6, day) }
    end

    describe("balance_with_carry") do
      subject do
        day_loader = DayEntryLoader.new(conf)
        MonthEntryLoader.new(day_loader).balance_with_carry(2020, 6)
      end

      it "should return the inbalance correctly" do
        expect(subject).to eq(-3 * 60)
      end
    end
  end

end
