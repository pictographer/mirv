#!/usr/bin/env bash

# TODO: implement --help

# TODO: extract file system constants from here and deploy.bash to a common
# location and allow environment to override.
CONFIG_DIR=~/mirv
HOST=$(hostname)
HOST_DIR=${CONFIG_DIR}/hosts/$HOST
BACKUP_DIR=${CONFIG_DIR}/backups/$HOST

# We need one or more paths to files outside the repo.
# These files are copied to corresponding paths in backups and hosts.
# Attempting to capture a file that is already captured make no changes.
# A file is considered captured if corresponding files exist in both
# places, without regard to file dates or contents.
# Someday, the deploy script will be able to delete host files. Not today.

# Should not overwrite a corresponding file under hosts/.

for host_path in "$@"; do
    repo_path=${HOST_DIR}$host_path
    if [ -r $host_path ]; then
        if [ -e $repo_path ]; then
            echo "$host_path is already captured."
            cmp -s $host_path $repo_path
            if [ $? == 0 ]; then
                echo "Files match."
            else
                if [ $host_path -ot $repo_path ]; then
                    echo "Host file is older than repo file."
                else
                    echo "Repo file is newer than host file."
                fi
            fi
        else
            echo "Copying $host_path to $HOST_DIR." 
            sudo cp -a --parents $host_path $HOST_DIR
        fi
    else
        echo "Unable to read $host_path."
    fi
done
