#!/bin/bash
# Get the script's directory path and navigate to it
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "$SCRIPTPATH"

# Extract the project name from the current directory
PROJECT_NAME=$(basename $(dirname $PWD))
echo "project_name: $PROJECT_NAME"

# Initialize the USER_TEXT variable
USER_TEXT=""

# Prompt the user for their username and password
read -p "Enter your username: " username
read -s -p "Enter your password: " password
echo

# Define the path to the commit file
COMMIT_FILE=/tmp/.riaradh.commit

# Request the user's comment from an API
user_comment=$(curl -s -X POST \
    -H 'Content-Type: application/json' \
    -u $username:$password \
    https://coding.riaradh.com/api/commit_user_comment)

# Check if the user is unauthorized
if [[ $user_comment == *'"error":'* ]]; then
    echo "Unauthorized"
else
    # Extract the 'text' field from the JSON response
    user_comment=$(echo "$user_comment" | jq -r '.text')

    # Save the user's comment to the COMMIT_FILE
    echo "$user_comment" > $COMMIT_FILE

    # Open the COMMIT_FILE with the Vim text editor
    vim $COMMIT_FILE

    # Remove comment lines starting with '#' from the COMMIT_FILE
    sed -e '/^#/d' $COMMIT_FILE > $COMMIT_FILE.1

    # Read the modified content from COMMIT_FILE.1 into USER_TEXT
    USER_TEXT=$(cat $COMMIT_FILE.1)

    # Remove temporary files
    rm $COMMIT_FILE
    rm $COMMIT_FILE.1

    # Create JSON text for the API request
    json_text=$(jq -n --arg text "$USER_TEXT" '{"text": $text}')

    # Send the JSON text to the API for formatting
    response=$(curl -s -X POST \
        -H 'Content-Type: application/json' \
        -u $username:$password \
        -d "$json_text" \
        https://coding.riaradh.com/api/commit_format)

    # Extract the 'response' field from the JSON response
    response_field=$(echo "$response" | jq -r '.response')

    # Display the proposed commit message
    echo -e "Proposed commit message:\n\n$response_field\n\n"
    read -p "Do you like this commit message? (Yes/No): " response

    # Perform the commit if the user approves it
    if [ "$response" == "Yes" ] || [ "$response" == "yes" ]; then
        git commit -m "$response_field"
        echo "Commit successful."
    else
        echo "The commit was not performed."
    fi
fi