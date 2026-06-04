#!/bin/sh
set -e

ZIP_URL="https://github.com/ErAz7/Ninja/raw/8be84ead24f5a25248a36f6e704f5acd5d0c5052/Ninja-v1.2.1-linux.zip"
ZIP_FILE="/tmp/ninja.zip"
INSTALL_DIR="/root/ninja"

if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y unzip curl
elif command -v yum >/dev/null 2>&1; then
    yum install -y unzip curl
elif command -v dnf >/dev/null 2>&1; then
    dnf install -y unzip curl
elif command -v apk >/dev/null 2>&1; then
    apk add --no-cache unzip curl
else
    echo "Unsupported package manager"
    exit 1
fi

export NVM_DIR="/root/.nvm"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts

npm install -g pm2

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

curl -L "$ZIP_URL" -o "$ZIP_FILE"

unzip -o "$ZIP_FILE" -d "$INSTALL_DIR"

cd "$INSTALL_DIR"

CONFIG_FILE="config/constants.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

HOST_VALUE="${JONIN_HOST:-127.0.0.1}"

sed -i \
    -e 's/"NO_LOG":[[:space:]]*false/"NO_LOG": true/g' \
    -e "s/\"HOST\":[[:space:]]*\"[^\"]*\"/\"HOST\": \"$HOST_VALUE\"/g" \
    "$CONFIG_FILE"

chmod +x ./Ninja-v1.2.1-linux

pm2 delete ninja >/dev/null 2>&1 || true

pm2 start ./Ninja-v1.2.1-linux \
    --name ninja \
    --interpreter none

pm2 save

echo
echo "Ninja installed and started"
pm2 status
