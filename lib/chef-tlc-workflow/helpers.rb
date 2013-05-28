module ChefTLCWorkflow

  module Helpers

    #
    # reads the direct dependencies defined in `metadata.rb` and 
    # returns a map of dependency => version, e.g.:
    #
    #   { 'foo' => '1.0.0', 'bar' => '0.1.0' }
    #
    def self.read_metadata_deps
      require 'chef/cookbook/metadata'
      metadata = ::Chef::Cookbook::Metadata.new
      metadata.from_file "metadata.rb"
      metadata.dependencies
    end

    #
    # reads the direct dependencies defined in `Cheffile` and 
    # returns a map of dependency => version, e.g.:
    #
    #   { 'foo' => '1.0.0', 'bar' => '0.1.0' }
    #
    def self.read_cheffile_deps
      require 'librarian/chef/environment'
      env = ::Librarian::Chef::Environment.new
      deps = env.spec.dependencies
      Hash[deps.map { |dep| [dep.name, dep.requirement.to_s] }]
    end

    #
    # resolves the dependencies as specified in `Cheffile` and 
    # returns a map of dependency => version (including the 
    # transitive ones), e.g.:
    #
    #   { 'foo' => '1.0.0', 'bar' => '0.1.0', 'baz_which_depends_on_bar' => '1.5.0' }
    #
    def self.read_and_resolve_cheffile_deps
      require 'librarian/chef/environment'
      env = ::Librarian::Chef::Environment.new
      deps = env.resolver.resolve(env.spec).manifests
      Hash[deps.map { |dep| [dep.name, dep.version.to_s] }]
    end

    #
    # returns the direct dependencies defined in `metadata.rb` as an 
    # array of triples:
    # 
    #   [[<cookbook_name>, <cookbook_version>, <location>], ...]
    #
    # where `<location>` is `nil`, unless the `locations_yml`
    # parameter is given and the specified file contains a location 
    # mapping for `<cookbook_name>`
    # 
    # Example usage in `Cheffile`:
    #   
    #   require 'chef-tlc-workflow/helpers'
    #   
    #   ChefTLCWorkflow::Helpers::from_metadata.each do |cb_name, cb_version, location|
    #     cookbook cb_name, cb_version, location
    #   end
    # 
    def self.from_metadata(locations_yml = nil)
      read_metadata_deps.to_a.map do |cb_name, cb_version|
        if locations_yml
          inferred_location = resolve_location_from_file(locations_yml, cb_name, cb_version)
        else
          inferred_location = nil
        end
        [cb_name, cb_version, inferred_location]
      end
    end

    #
    # reads in the YAML file containing the application cookbooks and
    # returns either all application cookbooks defined there or a specific
    # ones if the `name` and/or `version` parameters are given to filter
    # the selection.
    #
    # Example .yml file:
    #
    #   - name: "sample-app"
    #     version: "0.1.0"
    #     git: "https://github.com/tknerr/sample-app-tlc.git"
    #     ref: "v0.1.0"
    #   - name: "sample-app"
    #     version: "0.2.0"
    #     path: "../sample-app"
    #
    #
    def self.read_app_cookbooks(yml_file, name = nil, version = nil)
      # TODO: validate format
      app_cookbooks = YAML.load_file yml_file
      app_cookbooks.select! { |ac| ac['name'] == name } if name
      app_cookbooks.select! { |ac| ac['version'] == version } if version
      app_cookbooks
    end

    #
    # parse input string "<app-cookbook-name>@<version>" into
    # a `[name, version]` pair by splitting at the '@' character
    #
    def self.parse_name_and_version(string)
      if string == nil
        [nil, nil]
      else
        string.split '@'
      end
    end

    private

      def self.resolve_location_from_file(locations_yml, cb_name, cb_version)
        cookbook_index = YAML.load_file(locations_yml)
        if cookbook_index[cb_name]
          default_opts = Hash.new
          default_opts[:git] = cookbook_index[cb_name][:git] if cookbook_index[cb_name][:git]
          default_opts[:ref] = cookbook_index[cb_name][:ref] if cookbook_index[cb_name][:ref]
          version_specific_opts = cookbook_index[cb_name][cb_version] || {}
          return default_opts.merge version_specific_opts
        else
          return nil
        end
      end
  end
end