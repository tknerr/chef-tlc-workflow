## Application vs Library vs Forked Cookbooks

[Application cookbooks](http://devopsanywhere.blogspot.ch/2012/11/how-to-write-reusable-chef-cookbooks.html) contain everything required for setting up a machine (1:1 relation) with the desired application/service. They are based on library cookbooks but add the "glue" to make the installation as simple as including just the application cookbook in the node's run_list. 

Why application cookbooks? Because:

 * they can be properly versioned and dependency managed (in contrast to roles)
 * they lock down dependency versions in their `metadata.rb` thus make the installation robust and reliable
 * they hide all the glue code (and configuration inderdependencies) when assembling multiple cookbooks 
 * they set sensible configuration defaults and expose only the minimum necessary configuration to the user
 * they document how to use/administer the application in their README 

Sometimes there is no suitable [community cookbook](http://community.opscode.com/cookbooks) available or an available cookbook suffers from a bug or a missing feature we urgently need. In this case we resort to either writing our own (maybe internally hosted) library cookbook or to fork the community cookbook and fix the bugs or provide outstanding features.

This is how we handle forked community cookbooks:

 * host them internally on our Gitlab
 * `master` branch is the master from the upstream version
 * all our changes are done in the `zuehlke_master` branch
 * bug fixes / useful features should be contributed back to the community via pull requests