# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install a Cloudant Local cluster

# Ideas liberally stolen from:
# http://nitschinger.at/A-Couchbase-Cluster-in-Minutes-with-Vagrant-and-Puppet/
# https://thornelabs.net/2014/11/13/multi-machine-vagrantfile-with-shorter-cleaner-syntax-using-json-and-loops.html

# http://stackoverflow.com/questions/16708917/how-do-i-include-variables-in-my-vagrantfile?rq=1
# http://stackoverflow.com/questions/25094819/how-should-we-externalize-variables-in-a-vagrantfile
require 'yaml'
current_dir = File.dirname(File.expand_path(__FILE__))
conf = YAML.load_file("#{current_dir}/group_vars/all.yml")

re_install = false

db_count = 3
lb_count = 1
memory_size = 1024
box = "ubuntu/#{conf['platform']}64"

Vagrant.configure(2) do |config|

  # https://github.com/smdahlen/vagrant-hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_guest = true
  config.hostmanager.manage_host = true

  # db nodes must be first so they show up in lb nodes' /etc/hosts
  envs = [
    {:count => db_count,
     :name_prefix => conf["db_prefix"],
     :ip_addr_prefix => "192.168.56.1",
     :install_file => "install-db.yml"},
    {:count => lb_count,
     :name_prefix => conf["lb_prefix"],
     :ip_addr_prefix => "192.168.56.2",
     :install_file => "install-lb.yml"}
  ]

  envs.each do |env|
    1.upto(env[:count]) do |num|
      name = env[:name_prefix] + num.to_s
      config.vm.define name.to_sym do |node|
        node.vm.box = box
        node.vm.hostname = name + conf['domain_suffix']
        # _NOTE_ disconnect Cisco AnyConnect VPN for private host-only routes, see:
        # https://www.reddit.com/r/virtualbox/comments/2rqhae
        # https://forums.virtualbox.org/viewtopic.php?f=8&t=55066
        node.vm.network :private_network, ip: env[:ip_addr_prefix] + num.to_s
        node.vm.provider "virtualbox" do |v|
          v.name = name
          v.customize ["modifyvm", :id, "--memory", memory_size]
        end
        if re_install
          node.vm.provision "ansible" do |ansible|
            ansible.playbook = "uninstall.yml"
          end
        end    
        node.vm.provision "ansible" do |ansible|
          ansible.playbook = "install-common.yml"
        end
        node.vm.provision "ansible" do |ansible|
          ansible.playbook = env[:install_file]
        end
        if env[:name_prefix] == conf["db_prefix"] && num == db_count
          node.vm.provision "ansible" do |ansible|
            ansible.playbook = "post-install-db.yml"
          end
        end
      end
    end
  end
end
