
# [0.3.0] from 06/18/2013

 * update to Chef 11 and yank chef-workflow-tasklib (GH-2)
 * replace librarian-chef with [berkshelf](http://berkshelf.com/) (GH-3)
  * update `test/sample-app`: add `Berksfile`, add `Vagrantfile` with [vagrant-berkshelf](https://github.com/riotgames/vagrant-berkshelf) plugin 
  * code cleanup, lots of code not needed anymore

# [0.2.0] from 06/11/2013

 * update to Vagrant from 1.0 to 1.2 (GH-1)
  * replace mccloud and knife-solo with [vagrant-aws](https://github.com/mitchellh/vagrant-aws) and [vagrant-managed-servers](https://github.com/tknerr/vagrant-managed-servers) providers
  * update `Vagrantfile`s in `test/` directory for Vagrant 1.2

# [0.1.3] from 05/30/2013

 * relax version constraint on vagrant gem so that both 1.0.5 and 1.0.5.1 ([windows fixes](https://github.com/mitchellh/vagrant/issues/247)) can be used 

# [0.1.2] from 05/29/2013

 * added this CHANGELOG.md :-)
 * updated `test/ec2-bootstrap` for [compatibility](https://github.com/matschaffer/knife-solo/wiki/Upgrading-to-0.3.0) with latest knife-solo
 * gemspec updates:
  * updated to renamed librarian-chef 0.0.1
  * updated knife-solo to 0.3.0.pre4

# [0.1.1] from 05/29/2013

 * fix path to Gemfile so that `rake test` is working again
 * gemspec updates:
  * update to mccloud 0.0.19

# [0.1.0] from 05/28/2013

 * initial version
