#!/bin/bash

option="$1"

usage() {
  echo "Usage: $0 [option]"
  echo "Options:"
  echo "  -release : api release from kong to repository"
  echo "  -deploy  : api deploy from repository to kong"
  exit 1
}

folder_exists() {
  local dir_name="$1"
  for n in "${names[@]}"; do
    if [ "$dir_name" == "$n" ]; then
      return 0
    fi
  done
  return 1
}

handle_api_release() {
  response=$(curl -s -X GET "http://0.0.0.0:8001/services")
  names=($(echo "$response" | jq -r '.data[].name'))

  for dir in */; do
    dir_name="${dir%/}"
    if ! folder_exists "$dir_name"; then
      rm -rf "$dir_name"
      echo "Deleted API \"$dir_name\"."
    fi
  done

  for name in "${names[@]}"; do
    if [ -d "$name" ]; then
      json_data=$(echo "$response" | jq -r --arg n "$name" '.data[] | select(.name == $n)')
      echo "$json_data" > "$name/api-content.json"
      echo "API Content \"$name\" updated."
    else
      mkdir -p "$name"
      json_data=$(echo "$response" | jq -r --arg n "$name" '.data[] | select(.name == $n)')
      echo "$json_data" > "$name/api-content.json"
      echo "API Folder \"$name\" created."
    fi
  done
}

handle_api_deploy() {
  ./var/lib/jenkins/kong/kong-api-deployment.sh
}

main() {
  if [ -z "$option" ]; then
    usage
  elif [ "$option" = "-release" ]; then
    handle_api_release
  elif [ "$option" = "-deploy" ]; then
    handle_api_deploy
  else
    usage
  fi
}

main