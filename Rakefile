require "bundler/gem_tasks"

desc "run all tests"
task :test => [
  :test_vagrant_esx_bootstrap,
  :test_vagrant_aws_bootstrap,
  :test_vagrant_vbox_bootstrap
]

#
# TODO:
# * rewrite as cucumber feature
# * check for apache default page
# * more realistic scenario: e.g. scaffold infrastructure and app cookbook
#
desc "tests bootstrapping in an esx-like environment via vagrant-managed-servers provider"
task :test_vagrant_esx_bootstrap do

  begin
    # simulate esx-like environment using vagrant and a bare-os basebox
    run_cmd_esx "vagrant destroy esx_like_vm -f"
    run_cmd_esx "vagrant up esx_like_vm" do |ok, res|
      puts "ok: #{ok}\nres: #{res}" # ignore vagrant error for bare-os vm
    end

    test_vagrant_commands(:esx)
  ensure
    # cleanup
    run_cmd_esx "vagrant destroy esx_like_vm -f"
  end
end


desc "tests bootstrapping in AWS via vagrant-aws provider"
task :test_vagrant_aws_bootstrap do
  test_vagrant_commands(:aws)
end


desc "tests bootstrapping with local Vagrant VMs via default virtualbox provider"
task :test_vagrant_vbox_bootstrap do
  test_vagrant_commands(:vbox)
end


def test_vagrant_commands(suffix)
  begin
    # resolve deps and provision node
    bundle_exec "rake resolve_deps"
    # create VM
    run_cmd "vagrant up sample-app-#{suffix} --provider=#{provider(suffix)}"
    # provision node with app
    run_cmd "vagrant provision sample-app-#{suffix}"
    # check ssh
    run_cmd "vagrant ssh sample-app-#{suffix} -c 'ohai ipaddress'"
    # check status
    run_cmd "vagrant status sample-app-#{suffix}"
    
    # TODO: test if sample app works
  ensure
    # destroy
    run_cmd "vagrant destroy sample-app-#{suffix} -f"
  end
end

def provider(suffix)
  providers = { 
    :aws => "aws",
    :esx => "managed",
    :vbox => "virtualbox"
  }
  providers[suffix]
end


def bundle_exec(command, cwd = "test/vagrant-1.x-bootstrap")
  fail "need #{cwd}/Gemfile for a clean environment" unless File.exist? "#{cwd}/Gemfile"
  sh "cd #{cwd} && bundle exec #{command}"
end

def run_cmd(command, cwd = "test/vagrant-1.x-bootstrap")
  sh "cd #{cwd} && #{command}"
end

def run_cmd_esx(command)
  run_cmd command, "test/esx_fake"
end
