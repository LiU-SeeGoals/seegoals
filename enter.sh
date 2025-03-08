#-----------------------------------
# User container enter options
#-----------------------------------

# List all running containers with numbered labels
echo -e "${ORANGE}Select a container to enter:${NC}"
running_containers=($(docker ps --format "{{.Names}}"))
for i in "${!running_containers[@]}"; do
    echo -e "${ORANGE}[$i] ${running_containers[$i]}${NC}"
done

# Prompt the user to select a container
echo -e "${ORANGE}Enter the number of the container you want to access:${NC}"
read -r container_index

# Check if the entered index is valid
if [[ -n "${running_containers[$container_index]}" ]]; then
    selected_container="${running_containers[$container_index]}"
    echo -e "${GREEN}Attaching to container '$selected_container'...${NC}"
    docker exec -it "$selected_container" /bin/bash
else
    echo -e "${RED}Invalid selection. Exiting.${NC}"
fi
