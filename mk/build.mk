.PHONY: build docker push

CGO_ENABLED := 0
GOOS := linux
GOARCH := amd64

build:
	$(info ==================================================)
	$(info stage: build$(NEWLINE))
	$(info ==================================================)
	# 1.
	go mod tidy
	# 2.
	CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o $(BIN_FILE) $(ENTRY_GO_FILE)
	# 3.
	CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o $(GOTTY_BIN_FILE) $(GOTTY_ENTRY_GO_FILE)

docker:
	$(info ==================================================)
	$(info stage: docker$(NEWLINE))
	$(info NEW_IMAGE: ${IMAGE_NAME}:$(IMAGE_TAG))
	$(info NEW_IMAGE: ${GOTTY_IMAGE_NAME}:$(GOTTY_IMAGE_TAG))
	$(info ==================================================)
	# 1.
	chmod a+x $(BIN_FILE)
	# 2.
	docker build -f $(DOCKER_FILE) -t ${IMAGE_NAME}:$(IMAGE_TAG) .
	# 3.
	chmod a+x $(GOTTY_BIN_FILE)
	# 3.
	docker build -f $(GOTTY_DOCKER_FILE) -t ${GOTTY_IMAGE_NAME}:$(GOTTY_IMAGE_TAG) .


push:
	$(info ==================================================)
	$(info stage: push$(NEWLINE))
	$(info NEW_IMAGE: ${IMAGE_NAME}:$(IMAGE_TAG))r
	$(info NEW_IMAGE: ${GOTTY_IMAGE_NAME}:$(GOTTY_IMAGE_TAG))
	$(info ==================================================)
	# 1.
	docker push ${IMAGE_NAME}:$(IMAGE_TAG)
	# 2.
	docker push ${GOTTY_IMAGE_NAME}:$(GOTTY_IMAGE_TAG)

