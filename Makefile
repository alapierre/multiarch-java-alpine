IMAGE_NAME=lapierre/java-alpine
IMAGE_VERSION=8.252.09-r0-a3.12.2

build:
	docker buildx build --push --pull --platform=linux/arm/v7,linux/arm64/v8,linux/amd64 -t lapierre/multiarch-java-alpine:8.252.09-r0-a3.12.2 .
