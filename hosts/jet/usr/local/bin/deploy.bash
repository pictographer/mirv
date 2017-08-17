#!/usr/bin/env bash

# Copy repository files that are newer than their system counterparts
# to the system, updating each backup before overwriting.

# TODO: implement --help
# TODO: implement dry run mode

CONFIG_DIR=~/mirv
HOST=$(hostname)
HOST_DIR=${CONFIG_DIR}/hosts/$HOST
BACKUP_DIR=${CONFIG_DIR}/backups/$HOST

DEPLOYMENTS=0
if (( $# )); then
    # TODO: Update only the given files.
    echo "TBD: Update only the files named by the arguments."
    # TODO: This would be a good place to support creation of new config
    # files in the repo that don't already exist in the host system.
else
    # No arguments, so deploy all modified files in this directory and below.
    if [[ $PWD =~ ^$HOST_DIR ]]; then
        # Collect all the plain files here and below.
        # Should work for uncommon file names. Not needed here, but
        # good practice.
        while IFS='' read -r -d '' name; do
            REPO_PATH=$(realpath $name)
            HOST_PATH=${REPO_PATH#$HOST_DIR}
            if [ -r $HOST_PATH ]; then
                cmp -s $HOST_PATH $REPO_PATH
                CMP_STATUS=$?
                if (( $CMP_STATUS == 1 )); then
                    # Host file and repo file are different.
                    if [ $REPO_PATH -ot $HOST_PATH ]; then
                        echo "Warning: host file newer than repo file:"
                        echo "  $(stat -c %y $HOST_PATH): $HOST_PATH"
                        echo "vs"
                        echo "  $(stat -c %y $REPO_PATH): $REPO_PATH"
                    else
                        # Repo file is newer, but make a backup of
                        # host file anyway. Only replace host file if
                        # the backup succeeds.

                        # TODO: suppose there is a newer backup?
                        # I.e. something was reverted or restored.
                        # TODO: move mkdir up
                        mkdir -p $BACKUP_DIR
                        sudo cp -a --parents $HOST_PATH $BACKUP_DIR
                        if [ $? == 0 ]; then
                            sudo cp $REPO_PATH $HOST_PATH
                            echo "Deployed: $HOST_PATH"
                            ((++DEPLOYMENTS))
                        else
                            echo "Unable to backup $HOST_PATH to $BACKUP_DIR."
                        fi
                    fi
                elif (( $CMP_STATUS > 1 )); then
                    echo "cmp command failed."
                fi
            else
                # Suppress reporting of Emacs or Vim backup files.
                if [[ ! $HOST_PATH =~ [~#]$ ]]; then
                    echo "Skipped: $HOST_PATH"
                fi
            fi
        done < <(find . -type f -print0)
    else
        echo "Connect to host directory and try again."
    fi
fi
if [ $DEPLOYMENTS != 1 ]; then S="s"; else S=""; fi
echo "$DEPLOYMENTS file$S deployed."
