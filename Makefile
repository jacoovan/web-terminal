include mk/header.mk

# deploy info
HOST := 127.0.0.1
PORT_WEB := 9001
PORT_WS := 9002

# project
COMPOSE_PROJECT_NAME := web-terminal
SERVICE_NAME := web-terminal
IMAGE_NAME := jacoovan/$(SERVICE_NAME)
IMAGE_TAG := v0.1.0

GOTTY_SERVICE_NAME := gotty
GOTTY_IMAGE_NAME := jacoovan/$(GOTTY_SERVICE_NAME)
GOTTY_IMAGE_TAG := v0.1.0

# entry
ENTRY_GO_FILE := cmd/main.go
BIN_FILE := web-terminal

GOTTY_ENTRY_GO_FILE := cmd/gotty/main.go
GOTTY_BIN_FILE := gotty

# build
DOCKER_FILE := build/docker/Dockerfile

GOTTY_DOCKER_FILE := build/docker/Dockerfile_gotty

# deploy
COMPOSE_FILE := deploy/docker-compose/docker-compose.yaml
ENV_FILE := deploy/docker-compose/.env

# GIT_COMMIT - 8byte
GIT_COMMIT := $(shell git log -1 | grep commit | awk '{print $$2}' | awk 'match($$0, /[a-z|0-9]{8}/, a) {print a[0]}')

include mk/build.mk
include mk/deploy.mk
