#!/bin/bash
git clone ${your_repo_address}
cd services
git checkout test

LAST_COMMIT=$(git rev-parse HEAD)

parse_json_file() {
  filename=$1
  jq 'del(.id, .created_at, .updated_at)' "$filename"
}

send_json_body() {
  method=$1
  url=$2
  filename=$3
  parse_json_file "$filename" > temp.json
  curl -X $method -H "Content-Type: application/json" -d "@temp.json" $url
  rm -f temp.json
}

while IFS= read -r line; do
  status=$(echo $line | awk '{print $1}')
  filename=$(echo $line | awk '{print $2}')
  service_name=${filename%/api-content.json}

  if [[ "$status" == "M" && "$filename" == *.json ]]; then
    echo "Updated: $service_name"
    parse_json_file $filename
    send_json_body "PUT" "http://0.0.0.0:8001/services/$service_name" $filename

  elif [[ "$status" == "A" && "$filename" == *.json ]]; then
    echo "Created: ${service_name}"
    parse_json_file $filename
    send_json_body "POST" "http://0.0.0.0:8001/services" $filename

  elif [[ "$status" == "D" && "$filename" == *.json ]]; then
    echo "Deleted: $service_name"
    curl -X DELETE "http://0.0.0.0:8001/services/$service_name"
  fi
done < <(git diff --name-status "$LAST_COMMIT^..$LAST_COMMIT")

rm -rf /var/lib/jenkins/kong/services