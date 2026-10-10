#!/bin/bash

set -xe
cd "`dirname $(readlink -f ${0})`"

podman build --arch amd64 -t localhost/chiaki-noble . -f Dockerfile.noble
cd ..
podman run --rm \
	--arch amd64 \
	-v "`pwd`:/build/chiaki" \
	-w "/build/chiaki" \
	--device /dev/fuse \
	--cap-add SYS_ADMIN \
	-t localhost/chiaki-noble \
	/bin/bash -c "scripts/build-appimage.sh /build/appdir"

