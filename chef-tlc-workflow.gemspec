# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef-tlc-workflow/version'

Gem::Specification.new do |gem|
  gem.name          = "chef-tlc-workflow"
  gem.version       = ChefTLCWorkflow::VERSION
  gem.authors       = ["Torben Knerr"]
  gem.email         = ["tkn@zuehlke.com"]
  gem.description   = %q{Chef Workflow based on the idea of Top-Level Cookbooks }
  gem.summary       = %q{Chef Workflow based on the idea of Top-Level Cookbooks }
  gem.homepage      = "https://github.com/tknerr/chef-tlc-workflow"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # lock down direct dependencies
  #
  gem.add_dependency 'chef', '11.4.4'
  gem.add_dependency 'berkshelf', '2.0.3'
  gem.add_dependency 'rake'

  #
  # further dependencies that are not `require`d here but we pull in for convenience
  # so that the only dependency one needs in the `Gemfile` is `chef-tlc-workflow`
  #

  # testing related
  gem.add_dependency 'foodcritic', '2.0.1'
  gem.add_dependency 'chefspec', '1.3.1'
  gem.add_dependency 'fauxhai', '1.1.1'

  # others
  gem.add_dependency 'knife-solo_data_bag', '0.4.0'

  # need these on windows only
  if RUBY_PLATFORM =~ /mswin|mingw/
    gem.add_dependency 'ruby-wmi', '0.4.0'
    gem.add_dependency 'win32-service', '0.7.2'
  end

end