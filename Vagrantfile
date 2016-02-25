# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install a Cloudant Local cluster

# Ideas liberally stolen from:
# http://nitschinger.at/A-Couchbase-Cluster-in-Minutes-with-Vagrant-and-Puppet/
# https://thornelabs.net/2014/11/13/multi-machine-vagrantfile-with-shorter-cleaner-syntax-using-json-and-loops.html

memory_size = 512
domain_suffix = ".local" # erl needs this for starting with -name

Vagrant.configure(2) do |config|

  # https://github.com/smdahlen/vagrant-hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true

  # db nodes must be first so they show up in lb nodes' /etc/hosts
  envs = [
    {:count => 3,
     :name_prefix => "db",
     :ip_addr_prefix => "192.168.56.1",
     :install_file => "install-db.yml"},
    {:count => 1,
     :name_prefix => "lb",
     :ip_addr_prefix => "192.168.56.2",
     :install_file => "install-lb.yml"}
  ]

  envs.each do |env|
    1.upto(env[:count]) do |num|
      name = env[:name_prefix] + num.to_s
      config.vm.define name.to_sym do |node|
        node.vm.box = "ubuntu/trusty64"
        node.vm.hostname = name + domain_suffix
        node.vm.network :private_network, ip: env[:ip_addr_prefix] + num.to_s
        node.vm.provider "virtualbox" do |v|
          v.name = name
          v.customize ["modifyvm", :id, "--memory", memory_size]
        end
        node.vm.provision "ansible" do |ansible|
          ansible.playbook = "install-common.yml"
        end
        node.vm.provision "ansible" do |ansible|
          ansible.playbook = env[:install_file]
        end
      end
    end
  end
end
