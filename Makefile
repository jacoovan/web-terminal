include ci/header.mk

# deploy info
HOST := 127.0.0.1
PORT_WEB := 80
PORT_WS := 8081

COMPOSE_PROJECT_NAME := web-terminal

SERVICE_NAME := web-terminal
IMAGE_NAME := jacoovan/$(SERVICE_NAME)
IMAGE_TAG := v0.1.0

DOCKER_FILE := ci/Dockerfile
ENTRY_GO_FILE := main.go
COMPOSE_FILE := ci/docker-compose.yaml
BIN_FILE := web-terminal
ENV_FILE := ci/.env

GIT_COMMIT := $(shell git log -1 | grep commit | awk '{print $$2}' | awk 'match($$0, /[a-z|0-9]{8}/, a) {print a[0]}')

.PHONY: init build docker push pull
init:
	$(info ==================================================)
	$(info stage: init$(NEWLINE))
	$(info ==================================================)
	rm -f $(ENV_FILE)
	echo COMPOSE_PROJECT_NAME=$(COMPOSE_PROJECT_NAME) >> $(ENV_FILE)
	echo IMAGE_NAME=$(IMAGE_NAME) >> $(ENV_FILE)
	echo IMAGE_TAG=$(IMAGE_TAG) >> $(ENV_FILE)
	echo SERVICE_NAME=$(SERVICE_NAME) >> $(ENV_FILE)
	echo HOST=$(HOST) >> $(ENV_FILE)
	echo PORT_WEB=$(PORT_WEB) >> $(ENV_FILE)
	echo PORT_WS=$(PORT_WS) >> $(ENV_FILE) 

build:
	$(info ==================================================)
	$(info stage: build$(NEWLINE))
	$(info ==================================================)
	# 1.
	go mod tidy
	# 2.
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(BIN_FILE) $(ENTRY_GO_FILE)

docker:
	$(info ==================================================)
	$(info stage: docker$(NEWLINE))
	$(info NEW_IMAGE: ${IMAGE_NAME}:$(IMAGE_TAG))
	$(info ==================================================)
	# 1.
	chmod a+x $(BIN_FILE)
	# 2.
	docker build -f $(DOCKER_FILE) -t ${IMAGE_NAME}:$(GIT_COMMIT) .
	# 3.
	docker tag ${IMAGE_NAME}:$(GIT_COMMIT) ${IMAGE_NAME}:$(IMAGE_TAG)

push:
	$(info ==================================================)
	$(info stage: push$(NEWLINE))
	$(info NEW_IMAGE: ${IMAGE_NAME}:$(IMAGE_TAG))
	$(info ==================================================)
	# 1.
	docker push ${IMAGE_NAME}:$(GIT_COMMIT)
	# 2.
	docker push ${IMAGE_NAME}:$(IMAGE_TAG)

pull:
	$(info ==================================================)
	$(info stage: pull$(NEWLINE))
	$(info ==================================================)
	# 1.
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) pull

up:
	$(info ==================================================)
	$(info stage: up$(NEWLINE))
	$(info IMAGE: ${IMAGE_NAME}:$(IMAGE_TAG))
	$(info ==================================================)
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d
	nohup gotty -w -p $(PORT_WS) docker > /dev/null 2>&1 &

down:
	$(info ==================================================)
	$(info stage: down$(NEWLINE))
	$(info IMAGE: ${IMAGE_NAME}:$(IMAGE_TAG))
	$(info ==================================================)
	docker-compose --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down -v
	ps -ef | grep "gotty -w -p $(PORT_WS) docker" | grep -v grep | awk '{print $$2}' | xargs kill -9