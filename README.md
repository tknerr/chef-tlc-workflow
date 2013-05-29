# Chef "Top-Level Cookbooks" Workflow

`chef-tlc-workflow` supports an opiniated workflow for working with Chef. It is based on the strict distinction of top-level vs. dependent cookbooks (see below) and it's currently focussed on chef-solo only.

First of all, it provides templates for three different deployment environments (esx, ec2 and local). The templates contain among others a `Rakefile` for interacting with the deployment environment as well as a description of the nodes in these environments.

Other than the templates it provides helper methods to use the dependencies defined in `metadata.rb` from within [librarian](https://github.com/applicationsonline/librarian) `Cheffile`s. This ensures consistency between the dependencies specified in metadata and resolved via librarian. 

Finally, it ensures a consistent gem set by declaring all the gems we use in our workflow in its own gemspec, i.e. `chef-tlc-workflow` is the only gem you need to depend on - everything else (like vagrant, mcloud, etc..) comes in as transitive dependencies.


## Terminology

* **infrastructure** is a Chef-Repo like structure which describes the nodes that are part of it and which services are to be installed on these nodes via *top-level cookbooks*
* **deployment environments** are separate subdirectories within an *infrastructure* which represent the different environments (e.g. cloud, local or managed server) these services are deployed to
* **top-level cookbooks** are the top-level cookbooks that fully configure a node by combining a set of *dependent cookbooks*, configuring them appropriately and locking them at a specific version.
* **dependent cookbooks** are the finer-grained, reusable and flexible cookbooks that you typically leverage for building high-level services in terms of *top-level cookbooks*


## Installation

Add this line to your application's Gemfile:

    gem 'chef-tlc-workflow'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-tlc-workflow


## Usage

### Templates for Deployment Environments

Currently three different deployment environments are supported:

 * `esx` - VMs on our ESX infrastructure where we have ssh access but no control over the VMs (provisioned via [knife-solo](http://matschaffer.github.com/knife-solo/)) 
 * `ec2` - ec2 instances in the amazon cloud (managed and provisioned via [mccloud](https://github.com/jedi4ever/mccloud))
 * `local` - local VirtualBox VMs for development and testing (managed and provisioned via [vagrant](http://vagrantup.com))

This project contains "templates" for each of these deployment environments in the `test/` directory. For now, you have to copy the directories - there is no scaffolding yet. 

Each of the deployment environments in the `test/` directory provides a `Rakefile` with a similar interface (i.e. similar rake tasks) to interact with. See the integration tests in the top level `Rakefile` for an example.

In addition, it provides a place for describing the nodes within that deployment environment. Depending on the environment this might be a `Vagrantfile`, `Mccloudfile` or `<node>.json` file. Again, see the examples in the `test/` directory. 

### Librarian Helper

Since librarian does not support reading the cookbook dependencies from `metadata.rb`, the `ChefTLCWorkflow::Helpers` module adds this functionality.

In the trivial case you can use it in your cookbook project's `Cheffile` like so:

```ruby
require 'chef-tlc-workflow/helpers'

ChefTLCWorkflow::Helpers::from_metadata.each do |cb_name, cb_version|
  cookbook cb_name, cb_version
end
```

If some of the cookbooks defined in metadata.rb are not available from the community site, you can define your overrides like so: 

```ruby
...
@overrides = {
  'tlc-base' => { :git => 'https://github.com/tknerr/cookbook-tlc-base.git', :ref => 'master' },
}

ChefTLCWorkflow::Helpers::from_metadata.each do |cb_name, cb_version|
  cookbook cb_name, cb_version, @overrides[cb_name]
end
```


### Single Gemfile Dependency

It references all gems we need for our Chef workflow, this means that your `Gemfile` basically looks like this:

```ruby
source :rubygems

gem "chef-tlc-workflow", "0.1.3"
```

This brings in all the transitive gem dependencies as defined in the `chef-tlc-workflow.gemspec`, e.g. vagrant, librarian, chef, mccloud etc...

While this is not ideal in terms of keeping the LOAD_PATH as small as possible, it's a tradeoff in favor of convenience and consistency.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
