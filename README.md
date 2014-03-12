# vagrant-elasticsearch
This Vagrant project will set you up with 1 Elasticsearch node on an Ubuntu Precise64 VM.  You can just edit the number of nodes you want in the Vagrantfile to create more VMs.  It used to default to 4.  They have the IP addresses 192.168.255.10[1-4], their node names are chosen at random, and the cluster is named "es.ycsb.cluster".

### running the project:

    vagrant up
