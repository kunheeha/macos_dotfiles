#!/bin/bash

gcloud container images list-tags gcr.io/kubeflow-platform/spotify-kubeflow --format="get(tags)" | grep -E '[0-9]+\.[0-9]+-py38-gpu'
