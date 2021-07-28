# Project variables
PROJECT_NAME ?= todobackend
ORG_NAME ?= shubhamrasal
REPO_NAME ?= todobackend

# Filenames
DEV_COMPOSE_FILE := docker/dev/docker-compose.yml

# Build tag expression - can be used to evaulate a shell expression at runtime
BUILD_TAG_EXPRESSION ?= date -u +%Y%m%d%H%M%S

# Execute shell expression
BUILD_EXPRESSION := $(shell $(BUILD_TAG_EXPRESSION))

# Build tag - defaults to BUILD_EXPRESSION if not defined
BUILD_TAG ?= $(BUILD_EXPRESSION)

# Use these settings to specify a custom Docker registry
DOCKER_REGISTRY ?= registry.postsocially.com
#docker.io

test:
	${INFO} "Creating cache volume..."
	@ docker volume create --name cache
	${INFO} "Pulling latest images..."
	@ docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) pull
	${INFO} "Building images..."
	@ docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) build --pull test
	${INFO} "Starting Database..."
	@ docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) up -d db
	@ sleep 30s
	${INFO} "Running tests..."
	@ docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) up test
	@ docker cp $$(docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) ps -q test):/reports/. reports
	${CHECK} $(PROJECT_NAME) $(DEV_COMPOSE_FILE) test
	${INFO} "Testing complete"

build:
	${INFO} "Creating builder image..."
	@ docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) build builder
	${INFO} "Building application artifacts..."
	@ docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) up builder
	${CHECK} $(PROJECT_NAME) $(DEV_COMPOSE_FILE) builder
	${INFO} "Copying application artifacts..."
	@ docker cp $$(docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) ps -q builder):/wheelhouse/. target
	${INFO} "Build complete"
	${INFO} "Creating release image" 
	${CREATE_IMAGE_NAME}
	@ docker build -t $(READ_IMAGE_NAME) -f docker/release/Dockerfile .	

publish:
	${INFO} "Publishing release image $(READ_IMAGE_NAME) ..."
	@ docker push  $(READ_IMAGE_NAME)
	${INFO} "Publish complete"

deploy:
	${INFO} "Deploying $(READ_IMAGE_NAME) ..."
	@cd ansible && ansible-playbook site.yml -e 'service_image_name=$(shell cat tag.tmp)' --vault-password-file=$$vault_pass_file 

clean:
	${INFO} "Destroying development environment..."
	@ docker-compose -p $(PROJECT_NAME) -f $(DEV_COMPOSE_FILE) down -v
	${INFO} "Removing dangling images..."
	@ docker images -q -f dangling=true  | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Removing release docker images..."
	@ docker rmi $(READ_IMAGE_NAME)  || echo "NO docker image"
	${INFO} "Clean complete"

# Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
  printf $(YELLOW); \
  echo "=> $$1"; \
  printf $(NC)' SOME_VALUE

CREATE_IMAGE_NAME := @bash -c '\
	echo "$(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):$(BUILD_TAG)" > tag.tmp\
  ' SOME_VALUE

READ_IMAGE_NAME := $$(cat tag.tmp)

# Check and Inspect Logic
INSPECT := $$(docker-compose -p $$1 -f $$2 ps -q $$3 | xargs -I ARGS docker inspect -f "{{ .State.ExitCode }}" ARGS)

CHECK := @bash -c '\
  if [[ $(INSPECT) -ne 0 ]]; \
  then exit $(INSPECT); fi' VALUE
