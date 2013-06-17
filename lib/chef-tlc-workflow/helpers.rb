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
    # returns the resolved dependencies as specified in `Berksfile` as a
    # map of dependency => version (including the transitive ones), e.g.:
    #
    #   { 'foo' => '1.0.0', 'bar' => '0.1.0', 'baz_which_depends_on_bar' => '1.5.0' }
    #
    def self.read_berkshelf_deps
      require 'json'
      deps = JSON.parse(`berks list --format=json`)
      fail "error resolving cookbooks: #{deps['errors']}" unless deps['errors'].empty?
      Hash[deps['cookbooks'].map { |cb| [cb['name'], cb['version']] }]
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

  end
end