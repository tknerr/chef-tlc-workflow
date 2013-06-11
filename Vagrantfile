#
# Vagrantfile simulating an ESX-like environment for testing purposes:
#
# * assume ssh root access as the only prerequisite
# * using bare OS baseboxes with no Chef installed
#
Vagrant::configure("2") do |config|

  # use provionerless baseboxes
  config.vm.box = "opscode_ubuntu-13.04_provisionerless"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"

  config.vm.define :esx_like_vm do | esx_like_vm_config |
    
    esx_like_vm_config.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id,
        "--memory", "1024",
        "--name", "chef-tlc-workflow-esx-like-vm"]
    end
    esx_like_vm_config.vm.hostname = "chef-tlc-workflow-esx-like-vm.local"
    esx_like_vm_config.vm.network :private_network, ip: "33.33.77.10"
  end

  #
  # dummy vm in the same network, keeping it on so that no additional
  # user elevation dialogs appear for the other VMs
  #
  config.vm.define :dummy do | dummy_vm_config |

    dummy_vm_config.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id,
        "--memory", "256",
        "--name", "chef-tlc-workflow-dummy-vm"]
    end
    dummy_vm_config.vm.hostname = "chef-tlc-workflow-dummy-vm.local"
    dummy_vm_config.vm.network :private_network, ip: "33.33.77.2"
  end

end