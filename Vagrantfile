# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    required_plugins = %w( vagrant-vbguest vagrant-disksize vagrant-proxyconf )
    _retry = false
    required_plugins.each do |plugin|
        unless Vagrant.has_plugin? plugin
            system "vagrant plugin install #{plugin}"
            _retry=true
        end
    end

    config.vm.box = "ubuntu/xenial64"
    config.vm.hostname = "dockervm"
    config.vm.define "dockervm"
    config.vm.box_check_update = false
#   config.vm.network "forwarded_port", guest: 80, host: 8080
#   config.vm.network "private_network", ip: "192.168.33.12"
    config.vm.provider "virtualbox" do |vb|
        vb.name = "Docker VM"
        vb.memory = "8192"
        vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    end
    config.vm.provision "shell" do |sh|
        sh.path = "setup.sh"
        sh.privileged = false
#       sh.args = ["not used"]
    end  


    if Vagrant.has_plugin?("vagrant-vbguest")
        config.vbguest.auto_update = true
    end

    if Vagrant.has_plugin?("vagrant-disksize")
        config.disksize.size = '20GB'
    end

    if Vagrant.has_plugin?("vagrant-proxyconf")
        config.proxy.http     = "http://192.168.33.1:3128/"
        config.proxy.https    = "http://192.168.33.1:3128/"
        config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
    end
end
