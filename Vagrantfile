# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise32-server"
  config.vm.box_url = "http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-i386-disk1.box"
  config.vm.network :private_network, ip: "192.168.88.88"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "playbooks/all.yml"
    ansible.inventory_path = "hosts"
    ansible.limit = "192.168.88.88"
  end
end
