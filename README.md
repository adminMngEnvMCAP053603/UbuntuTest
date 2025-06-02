# 🚀 Azure DevOps Self-Hosted Agent Script

This repository provides a fully automated shell script to set up and configure a **self-hosted Azure DevOps agent** on a Linux VM (Amazon Linux or Ubuntu). It handles everything from agent pool creation to service registration using a secure Personal Access Token (PAT).

---

## ✨ Features

✅ Automatically update the system and install required dependencies  
✅ Creates the Azure DevOps Agent Pool if it does not exist  
✅ Downloads and configures the Azure DevOps Self-Hosted Linux Agent  
✅ Installs the agent as a system service and starts it  
✅ Supported Operating Systems  
  🟢 **Amazon Linux, RHEL, CentOS, and Fedora**  
  🟢 **Ubuntu & Debian**  

---

## 🔐 Requirements

- 🔗 Azure DevOps Organization URL (e.g., `https://dev.azure.com/your-org-name`)
- 🔑 A **Personal Access Token (PAT)** with at least the following permission:
  - **Agent Pools** → ✅ *Read & manage*

<p align="center">
  <img src="https://github.com/user-attachments/assets/4854037b-8155-4b4b-a2e3-ad67853361c2" alt="PAT Permissions" width="600">
</p>

---

## 🚀 Usage

### 1. Clone the Repository

```
git clone https://github.com/yaswanth00369/azure-devops-self-hosted-agent.git
cd azure-devops-self-hosted-agent
```
<p align="center"> <img src="https://github.com/user-attachments/assets/9bbe5714-5e5e-46cb-ba78-1d818ff1549a" alt="Cloning Repository" width="600"> </p>

### 2. Edit the Script and Update the Following Variables

```
sudo vi azure-devops-self-hosted-agent.sh
```
Update the variables as shown below:

```
AGENT_POOL="your-pool-name"
AZD_ORG_NAME="your-organization-name"
AZD_PAT="your-personal-access-token"
```
<p align="center"> <img src="https://github.com/user-attachments/assets/69197378-dedc-47db-8384-32e1c2420b14" alt="Edit Script Variables" width="600"> </p>

### 3. Run the Script

```
chmod +x azure-devops-self-hosted-agent.sh
./azure-devops-self-hosted-agent.sh
```
<p align="center"> <img src="https://github.com/user-attachments/assets/ba7002be-3308-485a-9406-3758ec78a779" alt="Run Script Screenshot 1" width="600"> </p> 
<p align="center"> <img src="https://github.com/user-attachments/assets/e998b079-ba60-411f-a417-40e7d4ff72a0" alt="Run Script Screenshot 2" width="600"> </p>
<p align="center"> <img src="https://github.com/user-attachments/assets/68115e1c-4265-44ae-8cb2-348a306b67e8" alt="Run Script Screenshot 3" width="600"> </p> 
<p align="center"> <img src="https://github.com/user-attachments/assets/0c8d9028-cc28-4ac2-a9f9-6ef4f3332a3e" alt="Run Script Screenshot 4" width="600"> </p> 
<p align="center"> <img src="https://github.com/user-attachments/assets/ace0fc14-0275-48e7-980c-13ca6010029f" alt="Run Script Screenshot 5" width="600"> </p>



---

## 🧹 Cleanup (if you want to remove the agent later)

```
cd ~/.devops-agent
sudo ./svc.sh stop
sudo ./svc.sh uninstall
./config.sh remove --unattended --auth PAT --token "$AZD_PAT"

```
