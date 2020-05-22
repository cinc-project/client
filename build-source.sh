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
TOP_DIR="$(pwd)"
export CI_PROJECT_DIR=${CI_PROJECT_DIR:-${TOP_DIR}}

set -x

version=$(cat chef/VERSION)
destdir="${CI_PROJECT_DIR}/data/source/$1/${version}"
mkdir -p "${destdir}"

cp README.md $2/README.cinc
cd $2
git archive --prefix=$1-${version}/ HEAD | gzip --no-name - \
	> "${destdir}/$1-${version}.tar.gz"
