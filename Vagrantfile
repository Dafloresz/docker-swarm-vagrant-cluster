Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/jammy64"
  config.vm.provision "shell", path: "install_docker.sh"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 1
  end

  nodes = {
    "master" => "192.168.56.10",
    "node01" => "192.168.56.11",
    "node02" => "192.168.56.12",
    "node03" => "192.168.56.13"
  }

  nodes.each do |name, ip|

    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: ip

      if name == "master"
        node.vm.provision "shell", path: "init_swarm.sh"

      else
        node.vm.provision "shell", path: "join_swarm.sh"
        
      end
    end
  end
end
