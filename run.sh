#!/usr/bin/env bash

set -e
set -o pipefail

function usage() {
	echo "Usage: [DOCKER_PLATFORM=os/arch] $0"
	echo "Starts a Docker build environment."
	echo "DOCKER_PLATFORM can optionally be set."
	exit 1
}

if [ "$1"  == "-h" ] || [ "$1" == "--help"  ] ; then
	usage
fi

DOCKER_PLATFORM="linux/amd64"

GID="$(id -g)"
GROUP="$(getent group $(getent passwd $USER | cut -d: -f4) | cut -d: -f1)"

echo "Building Docker image..."
DOCKER_IMAGE="$(docker build \
	--platform ${DOCKER_PLATFORM} \
	--build-arg USER="$USER" \
	--build-arg UID="$UID" \
	--build-arg GROUP="$GROUP" \
	--build-arg GID="$GID" \
	--build-arg HOME="$HOME" \
	--quiet \
	.
)"

NAME="flatcam-$$"

function kill_container() {
	docker kill --signal SIGKILL "${NAME}" &>/dev/null || true
}

trap kill_container EXIT

GIT_ROOT="$(cd $(dirname $0) && git rev-parse --show-toplevel)"

docker run \
	--name "${NAME}" \
	--platform ${DOCKER_PLATFORM} \
	--rm \
	--tty \
	--interactive \
	--net=host \
	--volume ${HOME}:${HOME} \
    --env HOME=$HOME \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --env DISPLAY=$DISPLAY \
	${DOCKER_IMAGE} python3 "$GIT_ROOT/FlatCAM.py"