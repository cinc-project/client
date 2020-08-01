#!/bin/sh -ex
wget -q -O /usr/bin/bio https://github.com/biome-sh/biome/releases/download/bio-1.5.75/bio-1.5.75-x86_64-linux
chmod +x /usr/bin/bio
bio origin key download --secret cinc
bio origin key download cinc