# 🚀 Azure DevOps Self-Hosted Agent Script

This repository provides a fully automated shell script to set up and configure a **self-hosted Azure DevOps agent** on a Linux VM (Amazon Linux or Ubuntu). It handles everything from agent pool creation to service registration using a secure Personal Access Token (PAT).

---

## ✨ Features

✅ Automatically installs required dependencies (.NET SDK 8.0 on Amazon Linux)  
✅ Creates the Azure DevOps Agent Pool if it does not exist  
✅ Downloads and configures the DevOps agent  
✅ Installs the agent as a system service and starts it  
✅ Supports both **Amazon Linux** and **Ubuntu**  

---

## 🔐 Requirements

- 🔗 Azure DevOps Organization URL (e.g., `https://dev.azure.com/your-org-name`)
- 🔑 A **Personal Access Token (PAT)** with at least the following permission:
  - **Agent Pools** → ✅ *Read & manage*

<p align="center">
  <img src="https://github.com/user-attachments/assets/4854037b-8155-4b4b-a2e3-ad67853361c2" alt="PAT Permissions" width="600">
</p>

---

## ⚙️ Usage

### 📁 Step-by-Step Instructions

```bash
# 1️⃣ Clone the repository
git clone https://github.com/yaswanth00369/azure-devops-self-hosted-agent.git
cd azure-devops-self-hosted-agent

# 2️⃣ Edit the script and update the following variables:
#    AGENT_POOL="your-pool-name"
#    AZD_ORG_NAME="your-organization-name"
#    AZD_PAT="your-personal-access-token"
nano azure-devops-self-hosted-agent.sh

# 3️⃣ Run the script
chmod +x azure-devops-self-hosted-agent.sh
./azure-devops-self-hosted-agent.sh



# 🧹 Cleanup (if you want to remove the agent later)
cd ~/.devops-agent
sudo ./svc.sh stop
sudo ./svc.sh uninstall
./config.sh remove --unattended --auth PAT --token "$AZD_PAT"
