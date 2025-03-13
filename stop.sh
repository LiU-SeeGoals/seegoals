STOP=$(docker ps --format "{{.Names}}" | sort)
COUNT=$(echo "$STOP" | wc -l)

if [ -z "$STOP" ]; then
    echo "No running containers to stop..."
else
    echo "Stopping $COUNT containers:"
    while IFS= read -r container; do
        echo -e "\tStopping $container..."
        docker stop "$container" > /dev/null 2>&1
    done <<< "$STOP"
fi
