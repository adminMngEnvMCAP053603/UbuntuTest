#!/bin/bash
set -e

# Required environment variables:
#   AZP_URL           e.g. https://dev.azure.com/<org>
#   AZP_TOKEN         PAT with Agent Pools (read, manage)
#   AZP_POOL          Agent pool name
#   AZP_AGENT_NAME    Agent name

# Optional environment variables:
#   AZP_WORK          default: _work
#   AZP_AGENT_VERSION e.g. 3.240.1
#   AZP_AGENT_DIR     default: /opt/azp/agent
#   AZP_AGENT_DOWNLOAD_URL direct URL to agent package

echo "STEP: Azure DevOps agent - validate required environment"
if [ -z "${AZP_URL:-}" ] || [ -z "${AZP_TOKEN:-}" ] || [ -z "${AZP_POOL:-}" ] || [ -z "${AZP_AGENT_NAME:-}" ]; then
  echo "ERROR: AZP_URL, AZP_TOKEN, AZP_POOL and AZP_AGENT_NAME must be set." >&2
  exit 1
fi

AZP_AGENT_DIR="${AZP_AGENT_DIR:-/opt/azp/agent}"
AZP_WORK="${AZP_WORK:-_work}"

echo "STEP: Installing Azure DevOps agent for organization at ${AZP_URL}"

# Create service user
echo "STEP: Creating local user 'azdevops'"
useradd -m -d /home/azdevops -s /bin/bash azdevops || true

mkdir -p "${AZP_AGENT_DIR}"
chown -R azdevops:azdevops "${AZP_AGENT_DIR}"

# Resolve agent version or use override URL
AGENT_TGZ=""
AGENT_URL="${AZP_AGENT_DOWNLOAD_URL:-}"

if [ -z "${AGENT_URL}" ]; then
  AGENT_VERSION="${AZP_AGENT_VERSION:-}"
  if [ -z "${AGENT_VERSION}" ]; then
    echo "STEP: Resolving latest agent version from GitHub"
    AGENT_VERSION=$(curl -fsSL https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest | jq -r .tag_name | sed 's/^v//' || true)
    if [ -z "${AGENT_VERSION}" ] || [ "${AGENT_VERSION}" = "null" ]; then
      echo "ERROR: Unable to resolve agent version." >&2
      exit 1
    fi
  fi
  AGENT_TGZ="vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz"
  AGENT_URL="https://download.agent.dev.azure.com/agent/${AGENT_VERSION}/${AGENT_TGZ}"
else
  AGENT_TGZ="$(basename "${AGENT_URL}")"
fi

echo "STEP: Downloading agent package ${AGENT_TGZ}"
pushd "${AZP_AGENT_DIR}" >/dev/null
curl -fSL "${AGENT_URL}" -o "${AGENT_TGZ}"
tar -zxf "${AGENT_TGZ}"
rm -f "${AGENT_TGZ}"

echo "STEP: Installing agent dependencies"
./bin/installdependencies.sh || true

chown -R azdevops:azdevops "${AZP_AGENT_DIR}"

if [ -f "${AZP_AGENT_DIR}/.agent" ]; then
  echo "ERROR: Preconfigured agent detected."
  exit 1
fi

echo "STEP: Configuring agent (unattended)"
set +x
sudo -u azdevops bash -lc "./config.sh \
  --unattended \
  --url '${AZP_URL}' \
  --auth pat \
  --token '${AZP_TOKEN}' \
  --pool '${AZP_POOL}' \
  --agent '${AZP_AGENT_NAME}' \
  --work '${AZP_WORK}' \
  --replace \
  --acceptTeeEula"
set -x

unset AZP_TOKEN

echo "STEP: Installing and starting agent service"
./svc.sh install azdevops
./svc.sh start

popd >/dev/null
