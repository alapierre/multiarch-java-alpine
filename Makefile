IMAGE_NAME=lapierre/multiarch-java-alpine
IMAGE_VERSION=8

build:
	docker buildx build --push --pull --platform=linux/arm/v7,linux/arm64/v8,linux/amd64 -t $(IMAGE_NAME):$(IMAGE_VERSION) .
