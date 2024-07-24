#!/bin/bash   
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH

PROJECT_NAME=$(basename $(dirname $PWD))
echo "project_name: $PROJECT_NAME"

default_enviroment="local"
ENV="${ENV:-$default_enviroment}"

echo "run_env: ${ENV}"

# Load project metadata
source ../../metadata.env

read -p "Username: " username

read -s -p "Password: " password
echo 

response=$(curl -s -X POST \
    -H 'Content-Type: application/json' \
    -u $username:$password \
    -d "{\"org\": \"$PROJECT_ORG\", \"env\": \"$ENV\", \"project\": \"$PROJECT_ID\"}" \
    https://secrets.riaradh.com/api/secrets)

if [ $? -ne 0 ]; then
  echo $response
  echo "La solicitud cURL no se completó correctamente"
  exit 1
fi

mkdir ../secrets
echo $response | jq -r 'to_entries[] | "\(.key)=\(.value)"' > ../../secrets/envs.${ENV}.sh
echo "secrets/envs.${ENV}.sh created"