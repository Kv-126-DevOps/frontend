# Frontend APP
  git clone --branch 1_frontend_code_refactoring https://github.com/Kv-126-DevOps/frontend.git /opt/frontend
  docker run --network=kv126 -d --name frontend -e RESTAPI_HOST=rest-api -e RESTAPI_PORT=5000 -v /opt/frontend:/app -p 80:5000 python:3.9-slim sleep infinity
  docker exec frontend pip install -r /app/requirements.txt
  docker exec -d frontend bash -c "cd /app && flask run --host=0.0.0.0"

  
# Step 1 - Create infrastructure
  docker network create -d bridge kv126
  docker run --network=kv126 -d --name postgres -e POSTGRES_USER=dbuser -e POSTGRES_PASSWORD=dbpass postgres
  docker run --network=kv126 -d --name rabbit -e RABBITMQ_DEFAULT_USER=mquser -e RABBITMQ_DEFAULT_PASS=mqpass -p 15672:15672 rabbitmq:3.9-management

# Step 2 - Run json-filter
  https://github.com/Kv-126-DevOps/json-filter.git

# Step 3 - Run rabbit-to-bd
  git clone --branch 1-rabbit-to-bd-code-refactoring https://github.com/Kv-126-DevOps/rabbit-to-bd.git /opt/rabbit-to-bd
  docker run --network=kv126 -e POSTGRES_HOST=postgres -e POSTGRES_PORT=5432 -e POSTGRES_USER=dbuser -e POSTGRES_PW=dbpass -e POSTGRES_DB=postgres -e RABBIT_HOST=rabbit -e RABBIT_PORT=5672 -e RABBIT_USER=mquser -e RABBIT_PW=mqpass -e RABBIT_QUEUE=restapi -d --name rabbit-to-bd -v /opt/rabbit-to-bd:/app python:3.9-slim sleep infinity
  docker exec rabbit-to-bd pip install -r /app/requirements.txt
  docker exec -d rabbit-to-bd bash -c "cd /app && python ./app.py"

# Step 4 - Run rabbit-to-slack
  https://github.com/Kv-126-DevOps/rabbit_to_slack.git

# Step 5 - POSTGRES_HOST
	docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres

# Step 6- Run rest-api (port 8080)
	git clone --branch 14-rest-api-code-refactoring https://github.com/Kv-126-DevOps/rest-api.git /opt/rest-api
	docker run --network=kv126  -d --name rest-api -e POSTGRES_HOST=0.0.0.0 -e POSTGRES_PORT=5432 -e POSTGRES_USER=dbuser -e POSTGRES_PASS=dbpass -e POSTGRES_DB=postgres -v /opt/rest-api:/app -p 8080:5000 python:3.9-slim sleep infinity
	docker exec rest-api pip install -r /app/requirements.txt
	docker exec -d rest-api bash -c "cd /app && flask run --host=0.0.0.0"

# Step 7 - Run frontend (port 80)
  git clone --branch 1_frontend_code_refactoring https://github.com/Kv-126-DevOps/frontend.git /opt/frontend
  docker run --network=kv126 -d --name frontend -e RESTAPI_HOST=rest-api -e RESTAPI_PORT=5000 -v /opt/frontend:/app -p 80:5000 python:3.9-slim sleep infinity
  docker exec frontend pip install -r /app/requirements.txt
  docker exec -d frontend bash -c "cd /app && flask run --host=0.0.0.0"
