#!/bin/bash

# Configuration
IMAGE_NAME="timothybryantjr"
REGISTRY="registry.local.timmybtech.com"
TAG="latest"
PLATFORM="linux/amd64"

# Full image name
FULL_IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$TAG"

echo "Building image for platform $PLATFORM..."
podman build --platform $PLATFORM -t $IMAGE_NAME . --no-cache

echo "Tagging image..."
podman tag $IMAGE_NAME $FULL_IMAGE_NAME

echo "Pushing image to registry..."
podman push $FULL_IMAGE_NAME

echo "Deployment script completed successfully!"
