
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timesheet_nags/version'

Gem::Specification.new do |spec|
  spec.name          = 'timesheet_nags'
  spec.version       = TimesheetNags::VERSION
  spec.authors       = ['Daniel J. Pritchett']
  spec.email         = ['dpritchett@gmail.com']

  spec.summary       = 'Nag yourself via growl to update harvest timesheets. OSX only.'
  spec.description   = 'Nag yourself via growl to update harvest timesheets. OSX only.'
  spec.homepage      = 'https://github.com/dpritchett/timesheet_nags'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['timesheet_nag']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
