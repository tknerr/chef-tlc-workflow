#
# Vagrantfile for testing
#
Vagrant::configure("2") do |config|

  # the Chef version to use
  config.omnibus.chef_version = "11.4.4"

  def configure_vbox_provider(config, name, ip, memory = 384)
    config.vm.provider :virtualbox do |vbox, override| 
      # override box url
      override.vm.box = "opscode_ubuntu-13.04_provisionerless"
      override.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"
      # configure host-only network
      override.vm.hostname = "#{name}.local"
      override.vm.network :private_network, ip: ip
      # enable cachier for local vbox vms
      override.cache.auto_detect = true

      # virtualbox specific configuration
      vbox.customize ["modifyvm", :id, 
        "--memory", memory,
        "--name", name
      ] 
    end
  end

  def configure_aws_provider(config)
    config.vm.provider :aws do |aws, override|
      # use dummy box
      override.vm.box = "aws_dummy_box"
      override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
      # override ssh user and private key
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = "#{ENV['HOME']}/.ssh/mccloud_rsa"

      # aws specific settings
      aws.access_key_id = "AKIAIAOEQFY2D2QGAHQA"
      aws.secret_access_key = "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"
      aws.ami = "ami-524e4726"
      aws.region = "eu-west-1"
      aws.availability_zone = "eu-west-1c"
      aws.instance_type = "m1.small"
      aws.security_groups = [ "mccloud", "http" ]
      aws.keypair_name = "mccloud-key-tlc"
    end
  end

  def configure_managed_provider(config, server)
    config.vm.provider :managed do |managed, override|
      # use dummy box
      override.vm.box = "managed_dummy_box"
      override.vm.box_url = "https://github.com/tknerr/vagrant-managed-servers/raw/master/dummy.box"

      # link with this server
      managed.server = server
    end
  end

#
# define a separate VMs for the 3 providers (vbox, aws, managed) 
# because with Vagrant 1.2.2 you can run a VM with only one provider at once
#
[:aws, :vbox, :esx].each do |provider|
  #
  # Sample VM per provider
  #
  config.vm.define :"sample-app-#{provider}" do | sample_app_config |

    case provider
    when :vbox
      configure_vbox_provider(sample_app_config, "sample-app", "33.33.40.10")
    when :aws
      configure_aws_provider(sample_app_config)
    when :esx    
      configure_managed_provider(sample_app_config, "33.33.77.10")  
    end
    
    sample_app_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = [ './cookbooks/sample-app-0.1.0' ]
      chef.add_recipe "sample-app"
      chef.json = {
        :sample_app => {
          :words_of_wisdom => "Vagrant on #{provider} Rocks!"
        }
      }
    end
  end
end

end

