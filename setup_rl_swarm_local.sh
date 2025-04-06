#!/bin/bash

# Install dependencies
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl git nodejs npm
npm install -g yarn

# Clone and setup
git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm
python3 -m venv .venv
source .venv/bin/activate
cd modal-login
yarn install
yarn upgrade viem@latest @account-kit/react@latest next@latest
cd ..

# Run the node
echo "Starting the node..."
echo "NOTE: Open the forwarded URL for port 3000 (e.g., https://<your-codespace-name>-3000.app.github.dev) in your browser to log in."
./run_rl_swarm.sh
