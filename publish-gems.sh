#!/bin/bash -e
#
# Author:: Lance Albertson <lance@osuosl.org>
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

TOP_DIR="$(pwd)"
export PATH="/opt/omnibus-toolchain/embedded/bin/:${PATH}"

source /home/omnibus/load-omnibus-toolchain.sh
set -x
cd ${TOP_DIR}/chef/chef-utils
gem build chef-utils.gemspec
# chef gem requires chef-utils to build the gems
gem install -N chef-utils-[0-9]*.gem
cd ${TOP_DIR}/chef
gem build chef.gemspec
gem build chef-universal-mingw-ucrt.gemspec
cd ${TOP_DIR}/chef/chef-bin
gem build chef-bin.gemspec
cd ${TOP_DIR}/chef/chef-config
gem build chef-config.gemspec
cd $TOP_DIR/chef
VERSION="$(cat VERSION)"
gem push chef-${VERSION}.gem --host https://rubygems.cinc.sh
gem push chef-${VERSION}-x64-mingw-ucrt.gem --host https://rubygems.cinc.sh
gem push chef-bin/chef-bin-${VERSION}.gem --host https://rubygems.cinc.sh
gem push chef-config/chef-config-${VERSION}.gem --host https://rubygems.cinc.sh
gem push chef-utils/chef-utils-${VERSION}.gem --host https://rubygems.cinc.sh
