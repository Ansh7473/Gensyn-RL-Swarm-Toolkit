#!/bin/bash

echo "Starting Gensyn RL-Swarm Node Setup (Local PC)..."

# Default options
SAVE_PEM="no"
OUTPUT_DIR="$HOME/gensyn_node_data"
USERNAME=""
EMAIL=""

# Parse options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --save-pem) SAVE_PEM="yes"; shift ;;
        --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
        --username) USERNAME="$2"; shift 2 ;;
        --email) EMAIL="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

mkdir -p "$OUTPUT_DIR"

# Install prerequisites (Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget git lsof xdg-utils
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt update && sudo apt install -y nodejs
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install -y yarn
elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install python node && corepack enable && npm install -g yarn
fi

# Verify
echo "Python: $(python3 --version)"
echo "Node: $(node -v) | npm: $(npm -v) | Yarn: $(yarn -v)"

# Clone and setup
[ ! -d "rl-swarm" ] && git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm || exit 1
[ ! -d ".venv" ] && python3 -m venv .venv
source .venv/bin/activate
cd modal-login
yarn install && yarn upgrade && yarn add next@latest viem@latest
cd ..

# Run node
echo "Y" | ./run_rl_swarm.sh &

# Prompt for login
sleep 5
[ -z "$EMAIL" ] && read -p "Enter your email: " EMAIL
xdg-open "http://localhost:3000/" 2>/dev/null || open "http://localhost:3000/" 2>/dev/null || echo "Open http://localhost:3000/ manually."
read -p "Enter OTP from email: " OTP
echo "Please enter OTP in the browser, then press Enter here..."
read -r

# Save files
if [ "$SAVE_PEM" = "yes" ] && [ -f "swarm.pem" ]; then
    cp swarm.pem "$OUTPUT_DIR/swarm.pem" && echo "Saved swarm.pem to $OUTPUT_DIR/swarm.pem"
fi
if [ -n "$USERNAME" ]; then
    echo "Username: $USERNAME" > "$OUTPUT_DIR/node_info.txt"
    echo "Email: $EMAIL" >> "$OUTPUT_DIR/node_info.txt"
    echo "Check terminal for ORG_ID and add manually to $OUTPUT_DIR/node_info.txt"
fi

echo "Setup complete! Check terminal for logs."
