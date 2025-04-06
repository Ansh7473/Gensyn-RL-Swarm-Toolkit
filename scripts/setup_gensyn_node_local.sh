#!/bin/bash

# Detect OS
OS=$(uname)
echo "Detected OS: $OS"

# Install dependencies
if [ "$OS" == "Linux" ]; then
    sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl git nodejs npm
    npm install -g yarn
elif [ "$OS" == "Darwin" ]; then
    brew install python node
    npm install -g yarn
else
    echo "Unsupported OS. Use Linux or Mac."
    exit 1
fi

# Clone and setup
git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate
cd modal-login
yarn install
cd ..

# Run the node
echo "Starting the node..."
./run_rl_swarm.sh
