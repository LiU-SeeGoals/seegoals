#!/bin/bash

# ANSI color codes for eye-popping effect
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

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
  git submodule update --init --recursive --no-fetch
  echo "Submodules initialized and updated."
fi

#-----------------------------------------------------------#
#    Docker configurations                                  #
#-----------------------------------------------------------#

# Prompt the user to choose the configuration
echo "Select Docker Compose configuration:"
echo "1. Base configuration (pre built images for both services)"
echo "2. Local controller"
echo "3. local game viewer"
echo "4. Local controller and local game viewer"
echo "5. Start real SSL vision (only on fetdator)"
read -p "Enter your choice (1-5): " choice

echo -e "${CYAN}closing previous containers${NC}"
docker stop $(docker ps -q) # close all previous running containers 
echo -e "${CYAN}Website: ${RED}http://localhost:5173/${NC}"
echo -e "${CYAN}Other website: ${RED}http://localhost:8082/${NC}"


# Define Docker Compose command based on the user's choice
case $choice in
  1)
    echo "Starting base configuration..."
    docker compose -p base-config up -d
    ;;
  2)
    echo "Starting with local controller and GHCR game viewer..."
    docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -p controller-config up --build -d
    echo -e "${CYAN}Entering controller container...${NC}"
    docker compose -p controller-config exec controller sh
    ;;
  3)
    echo "Starting with local game viewer and GHCR controller..."
    docker compose -f docker-compose.yml -f docker-compose.local-gameviewer.yml -p gameviewer-config up --build -d
    echo -e "${CYAN}Entering game-viewer container...${NC}"
    docker compose -p gameviewer-config exec game-viewer bash
    ;;
  4)
    echo "Starting with local controller and local game viewer..."
    docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -f docker-compose.local-gameviewer.yml -p dev-config up --build -d
    echo -e "${GREEN}Both controller and game-viewer are local. Not entering any container.${NC}"
    ;;
  5)
    echo "Starting setup for real cameras"
    docker compose -f docker-compose.yml -f docker-compose.real-robots.yml -p gameviewer-config up --build -d
    echo -e "${GREEN}Everything is started. Not entering any container.${NC}"
    ;;
  *)
    echo "Invalid choice. Exiting..."
    exit 1
    ;;
esac

