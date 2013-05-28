#
# Vagrantfile simulating an ESX-like environment for testing purposes:
#
# * assume ssh root access as the only prerequisite
# * using bare OS baseboxes with no Chef installed
#
Vagrant::Config.run do |config|

  # use bare os baseboxes
  config.vm.box = "ubuntu-12.04-server-amd64-bare-os"
  config.vm.box_url = "http://dl.dropbox.com/u/13494216/ubuntu-12.04-server-amd64-bare-os.box"

  config.vm.define :esx_like_vm do | esx_like_vm_config |
    esx_like_vm_config.vm.customize ["modifyvm", :id,
      "--memory", "1024",
      "--name", "chef-tlc-workflow-esx-like-vm"]
    esx_like_vm_config.vm.host_name = "chef-tlc-workflow-esx-like-vm.local"
    esx_like_vm_config.vm.network :hostonly, "33.33.77.10"
  end

  #
  # dummy vm in the same network, keeping it on so that no additional
  # user elevation dialogs appear for the other VMs
  #
  config.vm.define :dummy do | dummy_vm_config |
    dummy_vm_config.vm.customize ["modifyvm", :id,
      "--memory", "256",
      "--name", "chef-tlc-workflow-dummy-vm"]
    dummy_vm_config.vm.host_name = "chef-tlc-workflow-dummy-vm.local"
    dummy_vm_config.vm.network :hostonly, "33.33.77.2"
  end

end