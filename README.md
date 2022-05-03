# frontenr


# Create infrastructure
	docker network create -d bridge kv126
	docker run --network=kv126 -d --name postgres -e POSTGRES_USER=dbuser -e POSTGRES_PASSWORD=dbpass postgres:14  
	docker run --network=kv126 -d --name rabbit -e RABBITMQ_DEFAULT_USER=mquser -e RABBITMQ_DEFAULT_PASS=mqpass -p 15672:15672 rabbitmq:3.9-management
  
# POSTGRES_HOST
	docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres

# Run frontend (port 80)
	git clone --branch 1_frontend_code_refactoring https://github.com/Kv-126-DevOps/frontend.git /opt/frontend
	docker run --network=kv126 -d --name frontend -e RESTAPI_HOST="0.0.0.0" -e RESTAPI_PORT=5000 -v /opt/frontend:/app -p 80:5000 python:3.9-slim sleep infinity
	docker exec frontend pip install -r /app/requirements.txt
	docker exec -d frontend bash -c "cd /app && flask run --host=0.0.0.0"
