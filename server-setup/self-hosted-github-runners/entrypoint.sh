#!/bin/bash
set -e

# Check required environment variables
if [ -z "$RUNNER_TOKEN" ] || [ -z "$REPO_URL" ]; then
  echo "Error: REPO_URL and RUNNER_TOKEN must be set"
  exit 1
fi

# Configure the runner if not already configured
if [ ! -f ".runner" ]; then
  ./config.sh --unattended \
    --url "$REPO_URL" \
    --token "$RUNNER_TOKEN" \
    --labels "$RUNNER_LABELS" \
    --work "$RUNNER_WORKDIR" \
    --name "${RUNNER_NAME:-runner}"
  touch .runner
fi

# Start the runner
./run.sh