#!/bin/bash

echo "Starting Gensyn RL-Swarm Node Setup (VPS)..."

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

# Install prerequisites
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof ufw
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

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

# Run node in screen
screen -S gensyn -d -m bash -c "echo 'Y' | ./run_rl_swarm.sh; exec bash"

# Set up cloudflared
sudo ufw allow 3000/tcp && sudo ufw enable
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
echo "Starting cloudflared tunnel..."
cloudflared tunnel --url http://localhost:3000 &> "$OUTPUT_DIR/cloudflared.log" &
sleep 5
CLOUDFLARE_URL=$(grep -oP 'https://[a-z0-9-]+\.trycloudflare\.com' "$OUTPUT_DIR/cloudflared.log")
echo "Login at: $CLOUDFLARE_URL"

# Prompt for login
[ -z "$EMAIL" ] && read -p "Enter your email: " EMAIL
echo "Opening $CLOUDFLARE_URL on your local machine is recommended."
read -p "Enter OTP from email: " OTP
echo "Enter OTP at $CLOUDFLARE_URL, then press Enter here..."
read -r

# Save files
if [ "$SAVE_PEM" = "yes" ] && [ -f "swarm.pem" ]; then
    cp swarm.pem "$OUTPUT_DIR/swarm.pem" && echo "Saved swarm.pem to $OUTPUT_DIR/swarm.pem"
    echo "Use 'scp username@your_ip:$OUTPUT_DIR/swarm.pem .' to download it locally."
fi
if [ -n "$USERNAME" ]; then
    echo "Username: $USERNAME" > "$OUTPUT_DIR/node_info.txt"
    echo "Email: $EMAIL" >> "$OUTPUT_DIR/node_info.txt"
    echo "Check 'screen -r gensyn' for ORG_ID and add to $OUTPUT_DIR/node_info.txt"
fi

echo "Setup complete! Reattach with 'screen -r gensyn'."
