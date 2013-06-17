# Chef "Top-Level Cookbooks" Workflow

`chef-tlc-workflow` supports an opiniated workflow for working with Chef. It is based on the strict distinction of top-level vs. dependent cookbooks (see below) and it's currently focussed on chef-solo only.

It provides a [working sample](https://github.com/tknerr/chef-tlc-workflow/tree/master/test/vagrant-1.x-bootstrap) for deployment to esx, ec2 and local from within single `Vagrantfile`.

Also, it ensures a consistent gem set by declaring all the gems we use in our workflow in its own gemspec, i.e. `chef-tlc-workflow` is the only gem you need to depend on - everything else (like vagrant, mcloud, etc..) comes in as transitive dependencies.


## Terminology

* **infrastructure** is a Chef-Repo like structure which describes the nodes that are part of it and which services are to be installed on these nodes via *top-level cookbooks*
* **top-level cookbooks** are the top-level cookbooks that fully configure a node by combining a set of *dependent cookbooks*, configuring them appropriately and locking them at a specific version.
* **dependent cookbooks** are the finer-grained, reusable and flexible cookbooks that you typically leverage for building high-level services in terms of *top-level cookbooks*


## Installation

Add this line to your application's Gemfile:

    gem 'chef-tlc-workflow'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-tlc-workflow


## Prerequisites

You need Vagrant 1.2.x and the following plugins for the [sample Vagrantfile](https://github.com/tknerr/chef-tlc-workflow/tree/master/test/vagrant-1.x-bootstrap/Vagrantfile) to work:

```
vagrant plugin install vagrant-aws --plugin-version 0.2.2
vagrant plugin install vagrant-managed-servers --plugin-version 0.1.0
vagrant plugin install vagrant-omnibus --plugin-version 1.0.2
vagrant plugin install vagrant-cachier --plugin-version 0.1.0
```

## Usage

### Deployment to VirtualBox, AWS and Managed ESX Servers

Assuming you are in the `test/vagrant-1.x-bootstrap` directory you need to install the bundle first:  
```
$ cd test/vagrant-1.x-bootstrap
$ bundle install
Fetching gem metadata from http://rubygems.org/..
Fetching gem metadata from https://gems.gemfury.com/psBbdHx94zqZrvxpiVmm/..
Using rake (0.9.6)
Using Platform (0.4.0)
Using ansi (1.4.3)
Using archive-tar-minitar (0.5.2)
Using multi_json (1.7.6)
...
```

Then you need to resolve the [sample-app](https://github.com/tknerr/chef-tlc-workflow/tree/master/test/sample-app) top-level cookbook along with all its dependencies into the `./cookbooks` directory:
```
$ rake resolve_sample_app
cd tmp/tlc/sample-app-0.1.0 && berks install --path D:/Repos/_github/chef-tlc-workflow/test/vagrant-1.x-bootstrap/cookbooks/sample-app-0.1.0
Using sample-app (0.1.0) at path: 'D:/Repos/_github/chef-tlc-workflow/test/sample-app'
Installing apache2 (1.5.0)
Installing apt (1.3.2)
```

See, the dependencies are now resolved per top-level cookbook (i.e. `sample-app-0.1.0` in this case) separately:
```
$ ls -la cookbooks/sample-app-0.1.0
total 12
drwxr-xr-x 5 tkn tkn    0 Jun 11 17:44 .
drwxr-xr-x 3 tkn tkn    0 Jun 11 17:44 ..
drwxr-xr-x 7 tkn tkn 4096 Jun 11 17:44 apache2
drwxr-xr-x 6 tkn tkn 4096 Jun 11 17:44 apt
drwxr-xr-x 6 tkn tkn 4096 Jun 11 17:44 sample-app
```

Deploy to VirtualBox:

```
vagrant up sample-app-vbox 
```

Deploy to AWS via [vagrant-aws]:
```
vagrant up sample-app-aws --provider=aws
```

Deploy to a [managed](https://github.com/tknerr/vagrant-managed-servers) ESX Server:
```
vagrant up sample-app-esx --provider=managed
vagrant provision sample-app-esx
```

### Single Gemfile Dependency

It references all gems we need for our Chef workflow, this means that your `Gemfile` basically looks like this:

```ruby
source :rubygems

gem "chef-tlc-workflow", "0.2.0"
```

This brings in all the transitive gem dependencies as defined in the `chef-tlc-workflow.gemspec`, e.g. berkshelf, chef, foodcritic, etc...

While this is not ideal in terms of keeping the LOAD_PATH as small as possible, it's a tradeoff in favor of convenience and consistency.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
