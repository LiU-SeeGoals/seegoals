#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

PULL_PACKAGES=true
BASESTATION=123

OPTIONS=$(getopt -o sni: --long setup,no-network,base-ip: -- "$@")

eval set -- "$OPTIONS"

while [ "$1" != "" ]; do
    case $1 in
        -s | --setup)
            shift 2
            SETUP=$1
            ;;
        -n | --no-network)
            PULL_PACKAGES=false
            shift
            ;;
        -h | --help)
            echo "lol"
            exit 0
            ;;
    esac
    shift
done

#-----------------------------------------------------------#
#    Function to check if a submodule is initialized        #
#-----------------------------------------------------------#
check_submodule_status() {
  git submodule status | grep -q '^-' && return 1 || return 0
}
if check_submodule_status; then
  echo "All submodules are already initialized."
else
  echo "Submodules are not initialized. Initializing now..."
  # Initialize and update submodules without changing their current state
  git submodule update --init --recursive --no-fetch --remote
  git status --ignore-submodules=all
  echo "Submodules initialized and updated."
fi

echo "removing previous containers" > /dev/null 2>&1
docker remove ssl-viewer > /dev/null 2>&1
docker remove game-controller > /dev/null 2>&1
docker remove vision > /dev/null 2>&1
docker remove ai > /dev/null 2>&1
docker remove viewer > /dev/null 2>&1

#-----------------------------------------------------------#
#    Docker configurations                                  #
#-----------------------------------------------------------#

if [ -z "$SETUP" ]; then
    echo "Select Docker Compose configuration:"
    echo "1. Base configuration (pre built images for both services)"
    echo "2. Local controller"
    echo "3. local game viewer"
    echo "4. Local controller and local game viewer"
    echo "5. Start real SSL vision (only on fetdator)"
    echo "6. Start for competition"
    read -p "Enter your choice (1-6): " choice
else
    choice=$SETUP
fi

echo -e "${CYAN}closing previous containers${NC}"
./stop.sh
echo -e "${CYAN}Website: ${RED}http://localhost:5173/${NC}"
echo -e "${CYAN}Other website: ${RED}http://localhost:8082/${NC}"

case $choice in
  1)
    if [ "$PULL_PACKAGES" = true ]; then
        docker pull ghcr.io/liu-seegoals/game-viewer:latest
        docker pull ghcr.io/liu-seegoals/controller:latest
    fi

    echo "Starting base configuration..."
    docker compose -p base-config up -d
    ;;
  2)
    echo "Starting with local controller and GHCR game viewer..."

    if [ "$PULL_PACKAGES" = true ]; then
        docker pull ghcr.io/liu-seegoals/game-viewer:latest
        docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -p controller-config up --build -d --force-recreate
    else
        docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -p controller-config up
    fi
    echo -e "${CYAN}Entering controller container...${NC}"
    docker compose -p controller-config exec controller sh
    ;;
  3)
    echo "Starting with local game viewer and GHCR controller..."
    if [ "$PULL_PACKAGES" = true ]; then
        docker pull ghcr.io/liu-seegoals/controller:latest
        docker compose -f docker-compose.yml -f docker-compose.local-gameviewer.yml -p gameviewer-config up --build -d --force-recreate
    else
        docker compose -f docker-compose.yml -f docker-compose.local-gameviewer.yml -p gameviewer-config up
    fi
    echo -e "${CYAN}Entering game-viewer container...${NC}"
    docker compose -p gameviewer-config exec game-viewer bash
    ;;
  4)
    echo "Starting with local controller and local game viewer..."
    if [ "$PULL_PACKAGES" = true ]; then
        docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -f docker-compose.local-gameviewer.yml -p dev-config up --build -d --force-recreate
    else
        docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -f docker-compose.local-gameviewer.yml -p dev-config up
    fi
    echo -e "${GREEN}Both controller and game-viewer are local. Not entering any container.${NC}"
    ;;
  5)
    sudo ip addr add 192.168.1.10/24 dev enp4s0

    echo "Starting setup for real cameras"
    if [ "$PULL_PACKAGES" = true ]; then
        docker pull ghcr.io/liu-seegoals/ssl-vision:latest
        docker pull ghcr.io/liu-seegoals/game-viewer:latest

        docker compose -f docker-compose.yml -f docker-compose.real-robots.yml -f docker-compose.local-controller.yml -p gameviewer-config up --build -d --force-recreate
    else
        docker compose -f docker-compose.yml -f docker-compose.real-robots.yml -f docker-compose.local-controller.yml -p gameviewer-config up
    fi
    echo -e "${GREEN}Everything is started. Not entering any container.${NC}"
    ;;
  6)
    echo "Starting setup for real cameras"
    docker compose -f docker-compose.yml -f docker-compose.competition.yml -p gameviewer-config up -d
    echo -e "${GREEN}Everything is started. Not entering any container.${NC}"
    ;;
  *)
    echo "Invalid choice $choice. Exiting..."
    exit 1
    ;;
esac

