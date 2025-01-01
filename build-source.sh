#!/bin/sh

# Author:: Antonio Terceiro <terceiro@debian.org>
# Copyright:: Copyright 2020-2025, Cinc Project
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eu

# Positional parameters:
# $1 = cinc product short name [cinc|cinc-auditor|cinc-workstation]
# $2 = $1's upstream counterpart repository name on disk [chef|inspec|chef-workstation]
product=$1
upstream_product=$2

TOP_DIR="$(pwd)"
export CI_PROJECT_DIR=${CI_PROJECT_DIR:-${TOP_DIR}}

set -x

version=$(cat chef/VERSION)
destdir="${CI_PROJECT_DIR}/source/"
tarball="${product}-${version}.tar.xz"
mkdir -p "${destdir}"

cp README.md ${upstream_product}/README.cinc
cd $upstream_product
git archive --prefix=${product}-${version}/ HEAD | xz > ${destdir}/${tarball}
cd $destdir
sha256sum $tarball > $tarball.sha256sum
sha512sum $tarball > $tarball.sha512sum
