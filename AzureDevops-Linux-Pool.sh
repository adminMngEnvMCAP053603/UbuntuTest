#!/bin/bash
set -e

# --- User Configurable Variables ---
AGENT_POOL="Linux-House"          # Replace with your Azure DevOps Pool name
AZD_ORG_NAME="yaswanth00369"      # Replace with your Azure DevOps org name
AZD_PAT="m5T1mm8J2d1Nv0Yq7XCy2qCqyLv2U1ndn4p9mVuvceacFofxS28wJQQJ99BFACAAAAAAAAAAAAASAZDO4AkC"   # Replace with your secure PAT
INSTALL_PATH="$HOME/.devops-agent"
AGENT_URL="https://dev.azure.com/$AZD_ORG_NAME"
AGENT_DOWNLOAD_URL='https://download.agent.dev.azure.com/agent/4.255.0/vsts-agent-linux-x64-4.255.0.tar.gz'
AGENT_NAME="$(grep '^NAME' /etc/os-release | cut -d= -f2 | tr -d '\"' | tr ' ' '-')-$(hostname -I | awk '{print $1}')"


# --- System Update & .NET Install (only for Amazon Linux) ---
if grep -qi "amazon" /etc/os-release; then
  echo "Amazon Linux detected. Updating system and installing .NET SDK 8.0..."
  sudo dnf upgrade -y
  sudo dnf install -y dotnet-sdk-8.0
else
  echo "Non-Amazon Linux system detected. Skipping .NET installation."
fi


# --- Create Agent Pool if it doesn't exist ---
echo "Checking if agent pool '$AGENT_POOL' exists in Azure DevOps..."

POOL_EXISTS=$(curl -s -u ":$AZD_PAT" \
  "$AGENT_URL/_apis/distributedtask/pools?api-version=7.1-preview.1" | \
  jq -r --arg POOL "$AGENT_POOL" '.value[] | select(.name==$POOL) | .id')

if [ -z "$POOL_EXISTS" ]; then
  echo "Agent pool '$AGENT_POOL' not found. Creating it..."
  curl -s -u ":$AZD_PAT" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"$AGENT_POOL\"}" \
    "$AGENT_URL/_apis/distributedtask/pools?api-version=7.1-preview.1" \
    | jq
  echo "✅ Agent pool '$AGENT_POOL' created."
else
  echo "✅ Agent pool '$AGENT_POOL' already exists (Pool ID: $POOL_EXISTS)"
fi

# --- Setup DevOps Agent ---
mkdir -p "$INSTALL_PATH"

echo "Downloading Azure DevOps agent..."
curl -O "$AGENT_DOWNLOAD_URL"
FILENAME="$(readlink -f "$(basename "$AGENT_DOWNLOAD_URL")")"

echo "Extracting agent..."
tar -xzf "$FILENAME" -C "$INSTALL_PATH"

echo "Configuring agent..."
bash $INSTALL_PATH/config.sh \
  --unattended \
  --agent "$AGENT_NAME" \
  --pool "$AGENT_POOL" \
  --url "$AGENT_URL" \
  --auth PAT \
  --token "$AZD_PAT"

echo "Installing and starting agent service..."
cd "$INSTALL_PATH"
sudo ./svc.sh install
sudo ./svc.sh start

echo "✅ Azure DevOps agent '$AGENT_NAME' successfully configured and running in pool '$AGENT_POOL'."