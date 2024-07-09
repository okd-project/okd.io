#!/bin/bash
set -ex

docker build --no-cache --progress=plain -t okd_io .
docker run --rm -it -p 8080:80 okd_io
