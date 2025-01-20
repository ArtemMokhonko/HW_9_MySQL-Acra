#!/bin/sh

# Ubuntu install themis
wget -qO - https://pkgs-ce.cossacklabs.com/gpg | sudo apt-key add -

sudo apt install apt-transport-https

echo "deb https://pkgs-ce.cossacklabs.com/stable/ubuntu noble main" | \
  sudo tee /etc/apt/sources.list.d/cossacklabs.list

sudo apt update

sudo apt install libthemis-dev

pip install pythemis
