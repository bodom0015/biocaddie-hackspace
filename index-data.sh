#!/bin/bash

passwd="${1:-biocaddie}"
index_name='biocaddie'
index_type='external'

# Create an index for the biocaddie data
curl -XPUT -u elastic:$passwd "localhost:8000/${index_name}?pretty&pretty"

# Add all documents from /data/bioCaddie to the index
for i in $(seq 1 794992); do
        echo "Indexing $i to localhost:8000/${index_name}/${index_type}/${i}?pretty&pretty"
        curl -XPUT -u elastic:$passwd "localhost:8000/${index_name}/${index_type}/${i}?pretty&pretty" -H 'Content-Type: application/json' -d "@/data/bioCaddie/update_json_folder/${i}.json"
done
