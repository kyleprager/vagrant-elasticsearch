Vagrant.configure("2") do |config|


  # Number of nodes to provision

  numNodes = 4


  # IP Address Base for private network

  ipAddrPrefix = "192.168.255.10"


  # Define Number of RAM for each node

  config.vm.provider "virtualbox" do |v|

    v.customize ["modifyvm", :id, "--memory", 1024]

  end


  # Provision the server itself with puppet

  config.vm.provision "puppet" do |puppet|
  
    puppet.options = "--verbose --debug"
  
  end


  # Download the initial box from this url

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"


  # Provision Config for each of the nodes

  1.upto(numNodes) do |num|

    nodeName = ("el-node" + num.to_s).to_sym

    config.vm.define nodeName do |node|

      node.vm.box = "precise64"

      ipaddr = ipAddrPrefix + num.to_s

      # setup private network
      node.vm.network :private_network, ip: ipaddr

      # write this computer's IP to disk
      elasticsearchConfigFileLocation = "/home/vagrant/elasticsearch-1.0.1/config/elasticsearch.yml"
      node.vm.provision :shell, inline: 
      "
      cd /home/vagrant

      if [ -a elasticsearch-1.0.1.tar.gz ]
      then echo 'Elasticsearch already downloaded and unzipped.';
      else 
        wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz 2>&1;
        tar xf elasticsearch-1.0.1.tar.gz
      fi

      if grep es.ycsb.cluster $2
      then echo 'Elasticsearch cluster name already set.';
      else echo cluster.name: es.ycsb.cluster >> $2;
      fi

      if grep $1 $2
      then echo 'Elasticsearch network.host property already set.';
      else echo network.host: $1 >> $2;
      fi

      if ps aux | grep elasticsearch | grep -v grep
      then echo 'Elasticsearch already running.';
      else 
        ./elasticsearch-1.0.1/bin/elasticsearch -d;
        echo 'Started elasticsearch.'
      fi
      ", 
      :args => "#{ipaddr} #{elasticsearchConfigFileLocation}"

      node.vm.provider "virtualbox" do |v|

        v.name = "Elasticsearch Node " + num.to_s

      end

    end

  end


end
