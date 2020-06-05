

class WorkLoggerConfiguration
  attr_reader :path_prefix

  def initialize(path_prefix)
    @path_prefix = path_prefix
  end
end