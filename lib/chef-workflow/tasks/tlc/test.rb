
namespace :tlc do
  namespace :test do

  	#
    # destroy the default Vagrant VM, resolve dependencies and converge the default Vagrant VM
    #
    task :converge do
      sh "vagrant destroy -f"
      Rake::Task["tlc:deps:resolve"].invoke
      sh "vagrant up"
    end
  end
end

