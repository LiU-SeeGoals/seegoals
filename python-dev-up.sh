docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -f docker-compose.local-controller-python.yml -p controller-config up --build -d
docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -f docker-compose.local-controller-python.yml -p controller-config exec controller bash
docker compose -f docker-compose.yml -f docker-compose.local-controller.yml -f docker-compose.local-controller-python.yml -p controller-config exec controller-python bash
