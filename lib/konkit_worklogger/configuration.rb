# frozen_string_literal: true

require 'yaml'
require 'fileutils'

class WorkLoggerConfiguration
  attr_reader :worklogger_path

  def initialize(worklogger_path)
    @worklogger_path = worklogger_path
  end

  def self.load
    config_path = '%s/.konkit_worklogger/config.yml' % Dir.home

    conf = if File.file?(config_path)
             config_file_content = IO.read(config_path)
             config = YAML.safe_load(config_file_content)

             worklogger_path = config['path']

             WorkLoggerConfiguration.new(worklogger_path)
           else
             default_entries_path = '%s/.konkit_worklogger/timeentries' % Dir.home

             unless File.directory?('%s/.konkit_worklogger/' % Dir.home)
               FileUtils.mkdir_p('%s/.konkit_worklogger/' % Dir.home)
             end

             File.open(config_path, 'w') {|file| file.write({'path' => default_entries_path}.to_yaml)}
             WorkLoggerConfiguration.new(default_entries_path)
           end

    FileUtils.mkdir_p(conf.worklogger_path) unless File.directory?(conf.worklogger_path)

    conf
  end
end
