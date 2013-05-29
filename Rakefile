require "bundler/gem_tasks"

desc "run all tests"
task :test => [
  :test_esx_bootstrap, 
  :test_ec2_bootstrap,
  :test_local_bootstrap
]

#
# TODO:
# * rewrite as cucumber feature
# * check for apache default page
# * more realistic scenario: e.g. scaffold infra, create Cheffile and node.json on the fly, etc...
#
desc "tests bootstrapping with knife-solo in an esx-like environment"
task :test_esx_bootstrap do

  app = 'sample-app@0.1.0'
  user = 'vagrant'
  host = '33.33.77.10'
  ssh_key = 'W:/home/.vagrant.d/insecure_private_key'

  begin
    # simulate esx-like environment using vagrant and a bare-os basebox
    sh "vagrant destroy esx_like_vm -f"
    sh "vagrant up esx_like_vm" do |ok, res|
      puts "ok: #{ok}\nres: #{res}" # ignore vagrant error for bare-os vm
    end

    # resolve deps and provision node
    run_cmd_esx "rake resolve_deps"
    # bootstrap node with chef
    run_cmd_esx "rake bootstrap[#{host},#{user},#{ssh_key}]"
    # provision node with app
    run_cmd_esx "rake provision[#{app},#{host},#{user},#{ssh_key}]"
    # remove chef-solo traces from node
    run_cmd_esx "rake cleanup[#{host},#{user},#{ssh_key}]"

    # TODO: test if sample app works
  ensure
    # cleanup
    sh "vagrant destroy esx_like_vm -f"
  end
end


desc "tests bootstrapping with mccloud in ec2 (requires ec2 credentials)"
task :test_ec2_bootstrap do

  vm_name = 'sample-app'

  begin
    # resolve deps
    run_cmd_ec2 "rake resolve_deps"
    # bring up ec2 instance, bootstrap with chef and provision
    run_cmd_ec2 "rake up[#{vm_name}]"
    # re-provison ec2 instance
    run_cmd_ec2 "rake provision[#{vm_name}]"
    # show status of ec2 instances
    run_cmd_ec2 "rake status"


    # TODO: test if sample app works
  ensure
    # destroy ec2 instance
    run_cmd_ec2 "rake destroy[#{vm_name}]"
  end
end


desc "tests bootstrapping with local Vagrant VMs"
task :test_local_bootstrap do

  vm_name = 'sample-app'

  begin
    # resolve deps
    run_cmd_local "rake resolve_deps"
    # bring up vagrant vm, bootstrap with chef and provision
    run_cmd_local "rake up[#{vm_name}]"
    # re-provison vagrant vm
    run_cmd_local "rake provision[#{vm_name}]"
    # show status of vagrant vms
    run_cmd_local "rake status"

    # TODO: test if sample app works
  ensure
    # destroy vagrant vm
    run_cmd_local "rake destroy[#{vm_name}]"
  end
end


def run_cmd_esx(command)
  run_cmd command, "test/esx-bootstrap"
end

def run_cmd_ec2(command)
  run_cmd command, "test/ec2-bootstrap"
end

def run_cmd_local(command)
  run_cmd command, "test/local-bootstrap"
end

def run_cmd(command, cwd)
  fail "need #{cwd}/../Gemfile for a clean environment" unless File.exist? "#{cwd}/../Gemfile"
  sh "cd #{cwd} && bundle exec #{command}"
end