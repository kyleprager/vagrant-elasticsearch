
# update apt-get to pull latest list of ubuntu packages
exec { "apt-update":

	command => "/usr/bin/sudo /usr/bin/apt-get update",

	unless => "/usr/bin/which java && /usr/bin/java -version 2>&1 | grep 1.7"

}

# install Open JDK 7 JRE
package { "openjdk-7-jre":
	
	ensure => installed,

	require => Exec["apt-update"]

}

# download elasticsearch 1.0.1
exec { "elasticsearch-download": 

  command => "/usr/bin/wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz",

  cwd => "/home/vagrant/",

  creates => "/home/vagrant/elasticsearch-1.0.1.tar.gz",

  require => Package["openjdk-7-jre"]

}

# untar elasticsearch 1.0.1
exec { "untar-elasticsearch":

  command => "/bin/tar xf elasticsearch-1.0.1.tar.gz",

  cwd => "/home/vagrant/",

  creates => "/home/vagrant/elasticsearch-1.0.1",

  require => Exec["elasticsearch-download"]

}

# set the clustername so the VMs all join the same cluster
exec { "set-clustername-elasticsearch":

  command => "/bin/echo 'cluster.name: es.ycsb.cluster' >> elasticsearch-1.0.1/config/elasticsearch.yml",

  cwd => "/home/vagrant/",

  unless => "/bin/grep es.ycsb.cluster elasticsearch-1.0.1/config/elasticsearch.yml",

  require => Exec["untar-elasticsearch"]

}

# set the network.host setting in elasticsearch.yaml config file.  If this is not done the VM loads with eth0's IP.
# we need it to load with eth1's IP which looks like 192.168.255.10[0-9]
exec { "set-network-host-elasticsearch":

  command => "ifconfig eth1 | grep inet | grep -v inet6 | grep -o 192.168.255.10[0-9] | sed -e 's/\(.*\)/network.host: \1/'  >> elasticsearch-1.0.1/config/elasticsearch.yml",

  path => "/sbin:/bin:/usr/bin",

  cwd => "/home/vagrant/",

  unless => "/bin/grep -E '^network.host' elasticsearch-1.0.1/config/elasticsearch.yml",

  require => Exec["set-clustername-elasticsearch"]

}

# start elasticsearch in the background
exec { "run-elasticsearch":

  command => "/usr/bin/sudo ./elasticsearch-1.0.1/bin/elasticsearch -d",

  cwd => "/home/vagrant/",

  unless => "/bin/ps aux | grep elasticsearch | grep -v grep",

  require => Exec["set-network-host-elasticsearch"]

}
