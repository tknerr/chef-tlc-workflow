
## Librarian Helpers

Since librarian does not support reading the cookbook dependencies from `metadata.rb`,
the `ChefTLCWorkflow::Helpers` module adds this functionality.

In the trivial case you can use it in your cookbook project's `Cheffile` like so:

    require 'chef-tlc-workflow/helpers'

    ChefTLCWorkflow::Helpers::from_metadata.each do |cb_name, cb_version|
      cookbook cb_name, cb_version
    end

If some of the cookbooks defined in metadata.rb are not available from the community site, 
you can provide a .yml file with custom location mappings and pass it to the helper method: 

    ...
    ChefTLCWorkflow::Helpers::from_metadata('../../locations.yml').each do |cb_name, cb_version, location|
      cookbook cb_name, cb_version, location
    end
