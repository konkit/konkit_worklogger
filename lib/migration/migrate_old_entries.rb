# frozen_string_literal: true

require_relative '../konkit_worklogger/utils'
require_relative '../konkit_worklogger/configuration'
require 'fileutils'

class Migration
  include Utils

  def transform_file(old_fname)
    config = WorkLoggerConfiguration.load

    old_file_match = old_fname.match(/(?<year>\d\d\d\d)-(?<month>\d\d)-(?<day>\d\d).txt/)

    unless old_file_match.nil?
      year = old_file_match[:year]
      month = old_file_match[:month]
      day = old_file_match[:day]

      new_fname = get_filename(config, year, month, day)

      old_file = File.open(old_fname, 'r')
      new_file = File.open(new_fname, 'w')

      old_file.each_line do |line|
        match = line.match(/(\d\d?:\d\d).+/)&.captures

        new_file.write("#{match[0]}\n") unless match.nil? || match.empty?
      end

      old_file.close
      new_file.close
    end
  end
end

Dir['*'].select { |f| f =~ /\d\d\d\d\-\d\d\-\d\d\.txt/ }.each do |old_fname|
  Migration.new.transform_file(old_fname)
end
