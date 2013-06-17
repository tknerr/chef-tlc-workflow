
namespace :tlc do
  namespace :deps do

    require 'chef-tlc-workflow/helpers'

    #
    # resolve dependencies using berkshelf
    #
    task :resolve do
      sh "berks install"
    end

    #
    # check if dependencies in metadata.rb and Berksfile are consistent
    #
    task :check do
      errors = []
      metadata_deps = ChefTLCWorkflow::Helpers::read_metadata_deps
      resolved_deps = ChefTLCWorkflow::Helpers::read_berkshelf_deps
      resolved_deps.each do | dep, version |
        if metadata_deps.has_key?(dep)
          metadata_ver = ::Gem::Requirement.new(metadata_deps[dep])
          berkshelf_ver = ::Gem::Requirement.new(version)
          if metadata_ver != berkshelf_ver
            errors << "dependency version for '#{dep}' is inconsistent: '#{metadata_ver}' vs '#{berkshelf_ver}'!"
          end
        else
          errors << "dependency '#{dep}' is missing in metadata.rb!"
        end
      end
      puts errors.empty? ? "everything OK" : errors
    end

    #
    # resolve an application cookbook from `app_cookbooks.yml` with all its dependencies
    #
    task :resolve_app_cookbook, [:app_cookbook] do |t, args|
      name, version = ChefTLCWorkflow::Helpers::parse_name_and_version(args[:app_cookbook])
      app_cookbooks = ChefTLCWorkflow::Helpers::read_app_cookbooks("app_cookbooks.yml", name, version)
      app_cookbooks.each do |app_cookbook|
        resolve_app_cookbook(app_cookbook)
      end
    end

    #
    # resolve an application cookbook with all it's dependenices 
    # whilst honoring the application cookbook's Berksfile:
    #
    # 1. clone (:git,:ref) or copy (:path) the app cookbook to './tmp'
    # 2. resolve dependencies (inlcuding app cookbook itself) as defined in
    #    the app cookbook's Berksfile to './cookbooks/<app-cookbook-name>-<version>'
    #
    #
    def self.resolve_app_cookbook(app_cookbook)
      name = app_cookbook['name']
      version = app_cookbook['version']
      git_loc = app_cookbook['git']
      git_ref = app_cookbook['ref']
      path_loc = app_cookbook['path']
      has_git_loc = git_loc != nil
      has_path_loc = path_loc != nil

      fail "must specify either `git` or `path` location for #{name}" if !has_path_loc && !has_git_loc
      fail "must not specify both `git` and `path` location for #{name}" if has_path_loc && has_git_loc

      target_dir = "cookbooks/#{name}-#{version}"
      tmp_dir = "tmp/tlc/#{name}-#{version}"

      # clone / copy to temp dir
      FileUtils.rm_rf tmp_dir
      FileUtils.mkdir_p tmp_dir
      if has_git_loc
        sh "git clone -b #{git_ref || 'master'} #{git_loc} #{tmp_dir}"
      elsif has_path_loc
        FileUtils.cp_r cookbook_files_to_copy(path_loc), tmp_dir
      end

      # resolve deps from tmp_dir into target_dir
      fail "No Berksfile found in '#{tmp_dir}'" unless File.exist? "#{tmp_dir}/Berksfile"
      FileUtils.rm_rf target_dir
      FileUtils.mkdir_p target_dir
      sh "cd #{tmp_dir} && berks install --path #{File.absolute_path(target_dir)}"
    end

    def self.cookbook_files_to_copy(path)
      Dir.glob("#{path}/*").reject {|p| p.end_with? '/tmp' }
    end
  end
end