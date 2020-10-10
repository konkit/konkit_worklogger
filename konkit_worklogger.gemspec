require_relative 'lib/konkit_worklogger/version'

Gem::Specification.new do |spec|
  spec.name          = 'konkit_worklogger'
  spec.version       = KonkitWorklogger::VERSION
  spec.authors       = ['Łukasz Tenerowicz']
  spec.email         = ['konkit@gmail.com']

  spec.summary       = 'Worklogger'
  spec.description   = 'Log your time of work automatically with a mechanism based on Cron.'
  spec.homepage      = 'https://github.com/konkit/konkit_worklogger'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = ['worklogger']
  spec.require_paths = ['lib']

  spec.add_development_dependency('rake', '~> 12.0')
  spec.add_development_dependency('rspec', '~> 3.0')
  spec.add_dependency('thor', '~> 1.0')
end
