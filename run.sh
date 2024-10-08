#!/usr/bin/env bash
SCRIPT_PATH=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
USER_SCRIPT_DIR=$(realpath "$1")
PIPELINE_NAME="$(basename $USER_SCRIPT_DIR)"

if [ -z "$1" ]; then
    echo "[ERROR] Argument needed to specify algorithm directory"
    exit 1
fi

if [ ! -d $USER_SCRIPT_DIR ]; then
    echo "[ERROR] Algorithm directory '$USER_SCRIPT_DIR' not found!"
    exit 1
fi
echo "[INFO] TESTING ALGORITHM '${PIPELINE_NAME}'"

# Determine the Docker image from the user script
IMAGE=$(grep '^#DOCKER_IMAGE=' "$USER_SCRIPT_DIR/main.sh" | cut -d= -f2)
if [ -z "$IMAGE" ]; then
    IMAGE="ubuntu:latest"
fi

# Check if the container is running
echo "[INFO] Preparing required Docker image $IMAGE with container name '${PIPELINE_NAME}'"
if [ "$(docker ps -q -f name=^/${PIPELINE_NAME}$)" ]; then
    echo "[INFO] Container named '${PIPELINE_NAME}' exists and is running. Stopping..."
    docker stop "$PIPELINE_NAME"
    sleep 5
fi

# Check if the container exists (whether stopped or running previously)
if docker inspect "$PIPELINE_NAME" &>/dev/null; then
    echo "[INFO] Container named '${PIPELINE_NAME}' exists. Removing..."
    docker rm -f "$PIPELINE_NAME"
fi

echo "[INFO] Setting up testing directories..."
OUTPUT_DIR="$SCRIPT_DIR/output/${PIPELINE_NAME}"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

UUID=$(uuidgen)
rm -rf /tmp/$UUID
mkdir -p /tmp/$UUID
trap "rm -rf '/tmp/$UUID'" EXIT
cp -r bids /tmp/$UUID/bids
cp -r $USER_SCRIPT_DIR/* /tmp/$UUID/
cp -r $USER_SCRIPT_DIR/.* /tmp/$UUID/

echo "[INFO] Creating and starting the container '$PIPELINE_NAME' with image $IMAGE..."
docker run --rm --name "$PIPELINE_NAME" -d \
    -v "/tmp/$UUID:/seg_ci" \
    -v "$OUTPUT_DIR:/seg_ci/output" \
    --shm-size 8G \
    --user root \
    "$IMAGE" tail -f /dev/null

echo "[INFO] Running $USER_SCRIPT_DIR/main.sh in container..."

docker exec "$PIPELINE_NAME" bash -c "chmod +x /seg_ci/main.sh"
docker exec "$PIPELINE_NAME" bash -c "cd /seg_ci && ./main.sh"


