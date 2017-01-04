# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "terrame_centos7.2.box"

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = ["./cookbooks", "./site-cookbooks"]
    chef.run_list = %w[
    recipe[mysql]
    recipe[nginx]
    recipe[ruby-env]
    recipe[user]
  ]
  end
end
