#!/bin/bash

isCleanup=${1:-false}

# This is supposed to push the credentials into the build host
awsaccesssecret="$AWS_SECRET_ACCESS_KEY"
awsaccesskeyid="$AWS_ACCESS_KEY_ID"
homeDir="$HOME/.aws"
credentialfileName="credentials"
credentialfilebackup="credentials_bckp"
credentialfile="$homeDir/$credentialfileName"
credentialbckpfile="$homeDir/$credentialfilebackup"

if [ "$isCleanup" = true ]; then
    if [ -f "$credentialbckpfile" ]; then
        rm -f "$credentialfile"
        mv "$credentialbckpfile" "$credentialfileName"
    fi
else
    if [ -f "$credentialfile" ]; then
        if [ -d "$credentialfilebackup" ]; then
            rm -rf "$credentialfilebackup"
        fi
        mv "$credentialfile" "$credentialfilebackup"
    fi

    if [ ! -d "$homeDir" ]; then
        mkdir -p "$homeDir"
    fi

    touch "$credentialfile"

    credentialfilecontent="[$TF_VAR_profilename]\naws_access_key_id = $awsaccesskeyid\naws_secret_access_key = $awsaccesssecret"

    echo -e "$credentialfilecontent" > "$credentialfile"
fi