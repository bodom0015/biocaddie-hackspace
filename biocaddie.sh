#!/bin/bash
# Usage: ./biocaddie.sh [password]

default_passwd='changeme'
index_name='biocaddie'

# Start ElasticSearch
echo "Starting ElasticSearch..."
docker run -it -d --name=lambert8-es -p 8000:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.3.0

# Wait for ElasticSearch to start up
until $(curl --output /dev/null --silent --head --fail http://localhost:8000); do   
  $ECHO 'Trying again in 5 seconds...'
  sleep 5s # wait for 5s before checking again
done

# If $1 is given, use it as password ("biocaddie" will be used if no password is specified)
passwd="${1:-biocaddie}"
curl -XPUT -u elastic:$default_passwd 'localhost:8000/_xpack/security/user/kibana/_password' -H "Content-Type: application/json" -d \'{ "password" : "$passwd" }\'
curl -XPUT -u elastic:$default_passwd 'localhost:8000/_xpack/security/user/logstash_system/_password' -H "Content-Type: application/json" -d \'{ "password" : "$passwd" }\'
curl -XPUT -u elastic:$default_passwd 'localhost:8000/_xpack/security/user/elastic/_password' -H "Content-Type: application/json" -d \'{ "password" : "$passwd" }\'

# Create an index for the biocaddie data
./index-data.sh
