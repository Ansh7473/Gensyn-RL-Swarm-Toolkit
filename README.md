
# Gensyn RL-Swarm Toolkit

A comprehensive toolkit for setting up and running a Gensyn RL-Swarm node on either a Local PC (Linux/Mac) or a VPS (Linux). This README includes detailed guides and instructions for both setups, along with automation scripts.

## Features
- Guides for Local PC (Linux/Mac) and VPS (Linux) users.
- Automation scripts to install dependencies and start the node.
- Options to save `swarm.pem`, set usernames, and more.

## Repository Structure

Gensyn-RL-Swarm-Toolkit/
├── scripts/
│   ├── setup_gensyn_node_local.sh  # Script for Local PC
│   └── setup_gensyn_node_vps.sh    # Script for VPS
├── README.md                       # This file with guides
├── LICENSE                         # License information
└── .gitignore                      # Ignored files




## Getting Started

### Prerequisites
- **Local PC**: Linux (e.g., Ubuntu) or macOS with 4+ core CPU, 8GB+ RAM, stable internet.
- **VPS**: Linux VPS (e.g., Ubuntu) with similar specs and SSH access.
- Git installed (`sudo apt install git` or `brew install git`).

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Ansh7473/Gensyn-RL-Swarm-Toolkit.git
   cd Gensyn-RL-Swarm-Toolkit

2. Choose your setup below and follow the guide or run the corresponding script.
Guide for Local PC Users (Linux/Mac)
Device/System Requirements
Minimum Specs: 4+ core CPU, 8GB+ RAM, stable internet.
Supported OS: Ubuntu (or similar), macOS.
Warning: Low-spec devices may crash.
Pre-Requirements

Pre-Requirements
 1 Install Python and Tools:
Linux:

sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget git lsof xdg-utils  



Mac:
bash


brew install python
Verify: python3 --version
Install Node.js, npm, and Yarn:
Linux:
bash


curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn
Mac:
bash


brew install node && corepack enable && npm install -g yarn
Verify: node -v && npm -v && yarn -v
Start the Node
Clone the Repository:
bash


git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm
Set Up Virtual Environment:
bash


python3 -m venv .venv
source .venv/bin/activate
Install Dependencies:
bash


cd modal-login
yarn install
yarn upgrade && yarn add next@latest && yarn add viem@latest
cd ..
Run the Node:
bash


./run_rl_swarm.sh
Answer Y to Would you like to connect to the Testnet? [Y/n].
Log in at http://localhost:3000/ with your email and OTP.
Save the ORG_ID from the terminal.
Answer N to Push models to Hugging Face Hub? [y/N].
Save swarm.pem:
bash


mkdir -p ~/gensyn_node_data
cp swarm.pem ~/gensyn_node_data/swarm.pem
Automation Script
Run the provided script to automate the setup:

bash


chmod +x scripts/setup_gensyn_node_local.sh
./scripts/setup_gensyn_node_local.sh --save-pem --username "myuser"
Troubleshooting
OOM Errors (Mac):
bash


echo "export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0" >> ~/.zshrc
echo "export PYTORCH_ENABLE_MPS_FALLBACK=1" >> ~/.zshrc
source ~/.zshrc
Restart Next Day:
bash


cd rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh
Guide for VPS Users (Linux)
Device/System Requirements
Minimum Specs: 4+ core CPU, 8GB+ RAM, stable internet (e.g., AWS t2.medium).
Supported OS: Ubuntu (or similar).
Warning: Low-spec VPS instances may crash.
Pre-Requirements
Access Your VPS:
bash


ssh username@ip
Install Python and Tools:
bash


sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof ufw
Install Node.js, npm, and Yarn:
bash


curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn
Verify: node -v && npm -v && yarn -v
Start the Node
Clone the Repository:
bash


git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm
Create a Screen Session:
bash


screen -S gensyn
Set Up Virtual Environment:
bash


python3 -m venv .venv
source .venv/bin/activate
Install Dependencies:
bash


cd modal-login
yarn install
yarn upgrade && yarn add next@latest && yarn add viem@latest
cd ..
Run the Node:
bash


./run_rl_swarm.sh
Answer Y to Would you like to connect to the Testnet? [Y/n].
Set up remote access (below).
Answer N to Push models to Hugging Face Hub? [y/N].
Set Up Remote Access:
Allow port 3000:
bash


sudo ufw allow 3000/tcp
sudo ufw enable
Install cloudflared:
bash


wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
cloudflared --version
Start tunnel:
bash


cloudflared tunnel --url http://localhost:3000
Log in using the provided URL, then return to the terminal.
Detach Screen: Press Ctrl + A, then D.
Save swarm.pem:
bash

scp username@your_ip:~/rl-swarm/swarm.pem ~/gensyn_node_data/swarm.pem
Automation Script
Run the provided script to automate the setup:

bash


chmod +x scripts/setup_gensyn_node_vps.sh
./scripts/setup_gensyn_node_vps.sh --save-pem --username "myuser" --email "my@email.com"
Troubleshooting
Reattach to Screen:
bash


screen -r gensyn
Restart Next Day:
bash


screen -r gensyn
# If not running:
cd rl-swarm
source .venv/bin/activate
./run_rl_swarm.sh

   
