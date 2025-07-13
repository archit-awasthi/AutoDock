# 🐳 Docker Admin CLI Tool

A **Linux-based system administration project** that provides an interactive **command-line interface (CLI)** to manage Docker containers efficiently. Built using **pure Bash scripting**, this tool helps developers, sysadmins, and learners handle Docker workloads without needing to memorize long commands.

---

## ✨ Features

- 📋 View all running Docker containers
- 🛑 Stop a container by ID or name
- 🧹 Clean up all exited containers
- 🧽 Remove dangling (unused) images
- 🚀 Launch new containers interactively with custom options
- 📦 Designed to be modular, clean, and easily extensible

---

## 🔧 How to Run

### ✅ Requirements

- Docker installed and running  
- Bash shell (Linux or WSL recommended)

### 🚀 Steps to Use

```bash
# Clone the repo
git clone https://github.com/yourusername/docker-admin.git
cd docker-admin

# Make script executable
chmod +x docker-manager.sh

# Run the script
./docker-manager.sh
