.PHONY: default \
	build \
	terraform

# Starts all the containers in the background
build:
	docker-compose up --build -d

# Connects to the terraform runner
terraform: build
	docker-compose run --entrypoint "/bin/sh -l" terraform
