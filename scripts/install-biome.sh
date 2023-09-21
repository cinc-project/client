#!/bin/sh -ex
wget -q -O /tmp/bio.tar.gz https://github.com/biome-sh/biome/releases/download/v1.6.821/bio-1.6.821-x86_64-linux.tar.gz
tar -C /usr/bin -xvf /tmp/bio.tar.gz
rm -f /tmp/bio.tar.gz
chmod +x /usr/bin/bio
bio --version
mkdir -p ~/.hab/cache/keys/
echo ${HAB_PRIVATE_KEY} > ~/.hab/cache/keys/cincproject.sig.key
bio origin key download cincproject
