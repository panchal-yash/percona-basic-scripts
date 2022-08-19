#!/bin/bash


sudo apt update -y
sudo apt install curl -y
curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo apt install gnupg2 lsb-release ./percona-release_latest.generic_all.deb -y
sudo apt update -y
