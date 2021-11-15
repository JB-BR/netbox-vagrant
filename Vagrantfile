# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2104"
  config.vm.hostname = "Netbox"

  # Enable provisioning with a shell script. 
  config.vm.provision :shell, path: "bootstrap.sh"

  # Vagrant Tips : https://docs.microsoft.com/en-us/virtualization/community/team-blog/2017/20170706-vagrant-and-hyper-v-tips-and-tricks
  config.vm.provider "hyperv" do |h|
    h.enable_virtualization_extensions = true
    h.linked_clone = true
    h.memory = 2048
    h.cpus = 1
  end
end
