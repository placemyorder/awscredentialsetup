#!/bin/bash

# Ensure that mandatory parameters are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <awsaccesssecret> <awsaccesskeyid> <profilename> [isCleanup]"
    exit 1
fi

awsaccesssecret="$1"
awsaccesskeyid="$2"
profilename="$3"
isCleanup=${4:-false}

# This is supposed to push the credentials into the build host
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

    credentialfilecontent="[$profilename]\naws_access_key_id = $awsaccesskeyid\naws_secret_access_key = $awsaccesssecret"

    echo -e "$credentialfilecontent" > "$credentialfile"
fi
