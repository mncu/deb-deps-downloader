#!/usr/bin/env bash

UBT_VER=$1; shift;
PACKAGE=$1; shift;
ARCHIVE_DIR="/var/cache/apt/archives"
TAR_PATH="archive.tar"

echo "start to build docker image"
docker build -t tmp_deb_img --build-arg ubuntu_version=${UBT_VER} .

echo "start to download deb packages and then put them into a tar file"
docker run --rm -v tmp_deb:${ARCHIVE_DIR} -v $(pwd):/__tmp__ tmp_deb_img /bin/bash -c "apt-get install -y --download-only ${PACKAGE}; tar cvf /__tmp__/${TAR_PATH} ${ARCHIVE_DIR}"

echo "deleting temp docker volume"
docker volume rm tmp_deb

echo "deleting temp docker image"
docker rmi tmp_deb_img