# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/jira/version'

Gem::Specification.new do |spec|
  spec.name     = 'capistrano-jira'
  spec.version  = Capistrano::Jira::VERSION
  spec.authors  = ['Wojciech Widenka']
  spec.email    = ['wojtek@codegarden.online']

  spec.summary  =
    'Automated JIRA issues transitions after deployment with Capistrano'
  spec.homepage = 'https://github.com/wojw5/capistrano-jira'

  spec.files = `git ls-files -z`
               .split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano'
  spec.add_dependency 'jira-ruby'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
