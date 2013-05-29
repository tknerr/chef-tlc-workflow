# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef-tlc-workflow/version'

Gem::Specification.new do |gem|
  gem.name          = "chef-tlc-workflow"
  gem.version       = ChefTLCWorkflow::VERSION
  gem.authors       = ["Torben Knerr"]
  gem.email         = ["tkn@zuehlke.com"]
  gem.description   = %q{makes our workflow for developing with Chef explict by adding a set of Rake tasks embodying the workflow}
  gem.summary       = %q{makes our workflow for developing with Chef explict by adding a set of Rake tasks embodying the workflow}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # lock down dependencies
  #
  gem.add_dependency 'chef-workflow-tasklib', '0.2.2'
  gem.add_dependency 'chef', '10.18.2'
  gem.add_dependency 'librarian-chef', '0.0.1'

  #
  # further dependencies that are not `require`d here but we pull in for convenience
  # so that the only dependency one needs in the `Gemfile` is `chef-tlc-workflow`
  #

  # for interaction with nodes in local/esx/ec2 environments
  gem.add_dependency 'vagrant', '1.0.5.1'
  gem.add_dependency 'knife-solo', '0.3.0.pre4'
  gem.add_dependency 'mccloud', '0.0.19'
  
  # testing related
  gem.add_dependency 'foodcritic', '1.7.0'
  gem.add_dependency 'chefspec', '0.9.0'
  gem.add_dependency 'fauxhai', '0.1.1'

  # others
  gem.add_dependency 'rake', '0.9.6'
  gem.add_dependency 'sahara', '0.0.13'
  gem.add_dependency 'knife-solo_data_bag', '0.3.1'

  # need these on windows only
  if RUBY_PLATFORM =~ /mswin|mingw/
    gem.add_dependency 'ruby-wmi', '0.4.0'
    gem.add_dependency 'win32-service', '0.7.2'
  end

end