#!/bin/bash

# ────────────────────────────────────────────────
# Docker Admin CLI Tool
# Author: Archit Awasthi
# Purpose: Interactive script to manage Docker containers
# ────────────────────────────────────────────────

# ────────────────────────────────────────────────
# Check if Docker is installed
# ────────────────────────────────────────────────
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed. Please install Docker and try again."
        exit 1
    fi

    if ! sudo docker info &> /dev/null; then
        echo "❌ Docker daemon is not running or you don't have permissions."
        exit 1
    fi
}

# ────────────────────────────────────────────────
# View running containers
# ────────────────────────────────────────────────
view_running() {
    echo "🔍 Running Containers:"
    docker ps

    if [ $? -ne 0 ]; then
        echo "⚠️ Unable to fetch container list."
    fi

    read -p "Press Enter to return to menu..."
}

# ────────────────────────────────────────────────
# Stop a container by ID or name
# ────────────────────────────────────────────────
stop_container() {
    echo "🛑 Running Containers:"
    docker ps

    read -p "Enter the container ID or name to stop: " container_id

    if [ -z "$container_id" ]; then
        echo "⚠️ No input provided."
    else
        docker stop "$container_id"
        if [ $? -eq 0 ]; then
            echo "✅ Container $container_id stopped."
        else
            echo "❌ Failed to stop container."
        fi
    fi

    read -p "Press Enter to return to menu..."
}

# ────────────────────────────────────────────────
# Remove all exited containers
# ────────────────────────────────────────────────
remove_exited() {
    echo "🧹 Exited Containers:"
    docker ps -a --filter "status=exited"

    read -p "Do you want to remove all exited containers? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        docker container prune -f
        echo "✅ All exited containers removed."
    else
        echo "❌ Cleanup canceled."
    fi

    read -p "Press Enter to return to menu..."
}

# ────────────────────────────────────────────────
# Prune dangling images
# ────────────────────────────────────────────────
prune_images() {
    echo "🧽 Dangling Images:"
    docker images -f "dangling=true"

    read -p "Do you want to remove dangling images? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        docker image prune -f
        echo "✅ Dangling images removed."
    else
        echo "❌ Prune canceled."
    fi

    read -p "Press Enter to return to menu..."
}

# ────────────────────────────────────────────────
# Start a new container
# ────────────────────────────────────────────────
start_container() {
    read -p "Enter Docker image name (e.g., nginx): " image
    read -p "Optional: Enter container name (or leave blank): " name
    read -p "Run in detached mode? (y/n): " detached
    read -p "Port mapping (e.g., 8080:80) or leave blank: " port

    cmd="docker run"

    [[ "$detached" == "y" || "$detached" == "Y" ]] && cmd+=" -d"
    [ -n "$name" ] && cmd+=" --name $name"
    [ -n "$port" ] && cmd+=" -p $port"

    cmd+=" $image"

    echo "🚀 Running: $cmd"
    eval "$cmd"

    if [ $? -eq 0 ]; then
        echo "✅ Container launched."
    else
        echo "❌ Failed to launch container."
    fi

    read -p "Press Enter to return to menu..."
}

# ────────────────────────────────────────────────
# Exit gracefully
# ────────────────────────────────────────────────
exit_script() {
    echo "👋 Exiting Docker Admin Tool. Goodbye!"
    exit 0
}

# ────────────────────────────────────────────────
# Show menu
# ────────────────────────────────────────────────
show_menu() {
    clear
    echo "╔══════════════════════════════════════╗"
    echo "║      🐳 Docker Admin CLI Tool        ║"
    echo "╠══════════════════════════════════════╣"
    echo "║ 1. View running containers           ║"
    echo "║ 2. Stop a container                  ║"
    echo "║ 3. Remove all exited containers      ║"
    echo "║ 4. Prune dangling images             ║"
    echo "║ 5. Start a new container             ║"
    echo "║ 6. Exit                              ║"
    echo "╚══════════════════════════════════════╝"
}

# ────────────────────────────────────────────────
# Main Execution
# ────────────────────────────────────────────────
check_docker

while true; do
    show_menu
    read -p "Enter your choice [1-6]: " choice

    case $choice in
        1) view_running ;;
        2) stop_container ;;
        3) remove_exited ;;
        4) prune_images ;;
        5) start_container ;;
        6) exit_script ;;
        *) echo "❌ Invalid option. Try again."
           sleep 1
           ;;
    esac
done

