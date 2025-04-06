#!/bin/bash

# Install dependencies
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl git nodejs npm screen
npm install -g yarn

# Clone and setup
git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm
screen -S gensyn
python3 -m venv .venv
source .venv/bin/activate
cd modal-login
yarn install
cd ..

# Run the node
echo "Starting the node..."
./run_rl_swarm.sh
