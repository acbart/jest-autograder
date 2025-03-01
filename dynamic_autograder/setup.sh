#!/usr/bin/env bash

. /autograder/source/env.sh
. /autograder/source/envVars.sh

mkdir -p /root/.ssh
cp /autograder/source/ssh_config /root/.ssh/config


apt-get install -y python3 python3-pip python3-dev
pip3 install jsonschema
pip3 install pytest


# Make sure to include your private key here

cp /autograder/source/deploy_keys/deploy_key /root/.ssh/deploy_key

chmod 600 /root/.ssh/deploy_key

# To prevent host key verification errors at runtime

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Clone autograder files

mkdir -p ${BASE_DIR}/${REPO_NAME}
git clone ${GIT_REPO} ${BASE_DIR}/${REPO_NAME}

# If there is an setup.sh file in the repo, install what is needed

if [ -f ${BASE_DIR}/${REPO_NAME}/setup.sh ]; then
    echo "Installing Linux requirements from ${GIT_REPO}/setup.sh"
    chmod u+x ${BASE_DIR}/${REPO_NAME}/setup.sh
    ${BASE_DIR}/${REPO_NAME}/setup.sh
else
    echo "No setup.sh found in repo"
fi

# If there is a requirements.txt file in the repo, Install python dependencies

if [ -f ${BASE_DIR}/${REPO_NAME}/requirements.txt ]; then
    echo "Installing Python requirements from ${GIT_REPO}/requirements.txt"
    pip install -r ${BASE_DIR}/${REPO_NAME}/requirements.txt
else
    echo "No requirements.txt found in repo"
fi

# If there is a requirements3.txt file in the repo, install python3 dependencies

if [ -f ${BASE_DIR}/${REPO_NAME}/requirements3.txt ]; then
    echo "Installing Python3 requirements from ${GIT_REPO}/requirements.txt"
    pip3 install -r ${BASE_DIR}/${REPO_NAME}/requirements3.txt
else
    echo "No requirements3.txt found in repo"
fi


