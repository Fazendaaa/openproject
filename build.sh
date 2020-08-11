#!/usr/bin/sh
docker buildx build --platform linux/arm64/v8,linux/amd64 --push --tag fazenda/openproject .
