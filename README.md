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

## 🚀 Usage

### 1. Clone the Repository

```bash
git clone https://github.com/yaswanth00369/azure-devops-self-hosted-agent.git
cd azure-devops-self-hosted-agent
