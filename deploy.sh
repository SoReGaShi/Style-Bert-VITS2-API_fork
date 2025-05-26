#!/bin/bash
USER="xxxx"
APP_NAME="runpod-style-bert-vits2-api"
VERSION=1.0.0

# VERSIONを目視で確認するのでy/Nで確認
echo "バージョンは ${VERSION} でよろしいですか？"
read -p "y/N: " yn
case "$yn" in [yY]*) ;; *) echo "中止します" ; exit ;; esac

# buildコマンド（元のコード）
#sudo DOCKER_BUILDKIT=1 docker build --progress=plain . -f Dockerfile.runpod -t $USER/$APP_NAME:$VERSION

# pushコマンド（元のコード）
#sudo docker push $USER/$APP_NAME:$VERSION

# buildxビルダー準備（修正コード）
BUILDER_NAME="tts-builder"

if ! sudo docker buildx inspect $BUILDER_NAME >/dev/null 2>&1; then
    echo "Creating buildx builder: $BUILDER_NAME"
    sudo docker buildx create --name $BUILDER_NAME --use
else
    echo "Using existing builder: $BUILDER_NAME"
    sudo docker buildx use $BUILDER_NAME
fi

# build & push（修正コード）
sudo docker buildx build \
  --platform=linux/amd64 \
  --progress=plain \
  -f Dockerfile.runpod \
  -t $USER/$APP_NAME:$VERSION \
  --push .
