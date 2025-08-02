#! /bin/bash
set -e
sudo chown root:docker /var/run/docker.sock
/home/dev/actions-runner/run.sh