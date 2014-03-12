cd /home/vagrant

if [ -a elasticsearch-1.0.1.tar.gz ]
then echo 'Elasticsearch already downloaded and unzipped.';
else 
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz 2>&1;
  tar xf elasticsearch-1.0.1.tar.gz
fi

if grep es.ycsb.cluster $2 > /dev/null
then echo 'Elasticsearch cluster name already set.';
else echo cluster.name: es.ycsb.cluster >> $2;
fi

if grep $1 $2 > /dev/null
then echo 'Elasticsearch network.host property already set.';
else echo network.host: $1 >> $2;
fi

if ps aux | grep elasticsearch | grep -v grep > /dev/null
then echo 'Elasticsearch already running.';
else 
  ./elasticsearch-1.0.1/bin/elasticsearch -d;
  echo 'Started elasticsearch.'
fi

# install head plugin
/home/vagrant/elasticsearch-1.0.1/bin/plugin -install mobz/elasticsearch-head