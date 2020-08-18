#!/bin/sh

# Author:: Antonio Terceiro <terceiro@debian.org>
# Copyright:: Copyright 2020, Cinc Project
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
chef_full="${product}-full-${version}"
tarball="${product}-${version}.tar.xz"
tarball_omnibus="omnibus-software.tar.xz"
tarball_full="${chef_full}.tar.xz"
mkdir -p "${destdir}"

cp README.md ${upstream_product}/README.cinc
cd $upstream_product
git archive --prefix=${product}-${version}/ HEAD | xz > ${destdir}/${tarball}
cd $TOP_DIR/omnibus-software
git archive --prefix=omnibus-software/ HEAD | xz > ${destdir}/${tarball_omnibus}
cd $destdir
mkdir $chef_full
cd $chef_full
tar -Jxf ../${tarball}
tar -Jxf ../${tarball_omnibus}
cd $destdir
tar -Jcf $tarball_full $chef_full
rm -rf $tarball_omnibus $chef_full
sha256sum $tarball > $tarball.sha256sum
sha512sum $tarball > $tarball.sha512sum
sha256sum $tarball_full > $tarball_full.sha256sum
sha512sum $tarball_full > $tarball_full.sha512sum
