# TLC Chef Workflow

The `chef-tlc-workflow` aims to make our workflow for developing with Chef more explict.

First of all, it provides templates for three different deployment environments (esx, ec2 and local). The templates contain among others a `Rakefile` for interacting with the deployment environment as well as a description of the nodes in these environments.

Other than the templates it provides helper methods to use the dependencies defined in `metadata.rb` from within [librarian](https://github.com/applicationsonline/librarian) `Cheffile`s. This ensures consistency between the dependencies specified in metadata and resolved via librarian. 

Finally, it ensures a consistent gem set by declaring all the gems we use in our workflow in its own gemspec, i.e. `chef-tlc-workflow` is the only gem you need to depend on - everything else (like vagrant, mcloud, etc..) comes in as transitive dependencies.

## Installation

Add this line to your application's Gemfile:

    gem 'chef-tlc-workflow'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-tlc-workflow


## Usage

See valid usages below.

### Templates for Deployment Environments

As of TLC Project Infrastructure v1 we support three different deployment environments:

 * `esx` - VMs on our ESX infrastructure where we have ssh access but no control over the VMs (provisioned via [knife-solo](http://matschaffer.github.com/knife-solo/)) 
 * `ec2` - ec2 instances in the amazon cloud (managed and provisioned via [mccloud](https://github.com/jedi4ever/mccloud))
 * `local` - local VirtualBox VMs for development and testing (managed and provisioned via [vagrant](http://vagrantup.com))

This project contains "templates" for each of these deployment environments in the `test/` directory. For now, you have to copy the directories - there is no scaffolding yet. 

Each of the deployment environments in the `test/` directory provides a `Rakefile` with a similar interface (i.e. similar rake tasks) to interact with. See the integration tests in the top level `Rakefile` for an example.

In addition, it provides a place for describing the nodes within that deployment environment. Depending on the environment this might be a `Vagrantfile`, `Mccloudfile` or `<node>.json` file. Again, see the examples in the `test/` directory. 

### Librarian Helper

Since librarian does not support reading the cookbook dependencies from `metadata.rb`, the `ChefTLCWorkflow::Helpers` module adds this functionality.

In the trivial case you can use it in your cookbook project's `Cheffile` like so:

    require 'chef-tlc-workflow/helpers'

    ChefTLCWorkflow::Helpers::from_metadata.each do |cb_name, cb_version|
      cookbook cb_name, cb_version
    end

If some of the cookbooks defined in metadata.rb are not available from the community site, you can define your overrides like so: 

    ...
    @overrides = {
      'tlc-base' => { :git => 'https://github.com/tknerr/cookbook-tlc-base.git', :ref => 'master' },
    }

    ChefTLCWorkflow::Helpers::from_metadata.each do |cb_name, cb_version|
      cookbook cb_name, cb_version, @overrides[cb_name]
    end


### Single Gemfile Dependency

It references all gems we need for our Chef workflow, this means that your `Gemfile` basically looks like this:

```
source :rubygems

# additional sources for patched gems
source 'https://gems.gemfury.com/hUe8s8nSyzxs7JMMSZV8/' # vagrant-1.0.5.1
source 'https://gems.gemfury.com/psBbdHx94zqZrvxpiVmm/' # librarian-0.0.26.2

gem "chef-tlc-workflow", "0.1.0",
  :git => 'https://github.com/tknerr/chef-tlc-workflow.git', :ref => 'v0.1.0'
```

This brings in all the transitive gem dependencies as defined in the `chef-tlc-workflow.gemspec`, e.g. vagrant, librarian, chef, mccloud etc...

While this is not ideal in terms of keeping the LOAD_PATH as small as possible, it's a tradeoff in favor of convenience and consistency.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
