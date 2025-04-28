#!/bin/bash

IMAGE_NAME="timothybryantjr"
REGISTRY="registry.local.timmybtech.com"
TAG="latest"
PLATFORM="linux/amd64"
ARGOCD_APP_NAME="timothybryantjr"
ARGOCD_SERVER="argocd.local.timmybtech.com"
DEPLOYMENT_NAME="timothybryantjr"
NAMESPACE="timothybryantjr"

FULL_IMAGE_NAME="$REGISTRY/$IMAGE_NAME:$TAG"

echo "Checking for uncommitted changes..."
if [[ -n $(git status --porcelain) ]]; then
    echo "Uncommitted changes detected. Please commit or stash them before deploying."
    exit 1
fi

echo "Checking if on main branch..."
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" != "main" ]]; then
    echo "You must be on the main branch to deploy (current: $BRANCH)."
    exit 1
fi

echo "Building image for platform $PLATFORM..."
podman build --platform $PLATFORM -t $IMAGE_NAME . --no-cache

echo "Tagging image..."
podman tag $IMAGE_NAME $FULL_IMAGE_NAME

echo "Pushing image to registry..."
podman push $FULL_IMAGE_NAME

if command -v argocd >/dev/null 2>&1; then
    echo "ArgoCD CLI detected, attempting to refresh application..."
    argocd login $ARGOCD_SERVER --grpc-web
    if argocd app get "$ARGOCD_APP_NAME" --grpc-web >/dev/null 2>&1; then
        argocd app get "$ARGOCD_APP_NAME" --hard-refresh --grpc-web
        echo "ArgoCD application refresh triggered successfully!"
    else
        echo "Warning: ArgoCD application '$ARGOCD_APP_NAME' not found. Please verify the application name and your ArgoCD login status."
        echo "You may need to refresh the application manually via the ArgoCD UI."
    fi
else
    echo "Note: ArgoCD CLI not found. To update the deployment, please refresh the application in the ArgoCD UI."
fi

if command -v kubectl >/dev/null 2>&1; then
    echo "Kubectl detected, restarting deployment..."
    kubectl rollout restart deployment/$DEPLOYMENT_NAME -n $NAMESPACE
    echo "Deployment restarted successfully!"
else
    echo "Note: Kubectl not found. To restart the deployment, please run 'kubectl rollout restart deployment/$DEPLOYMENT_NAME' manually."
fi

echo "Deployment script completed successfully!"
