
Cinc-client is a FOSS distribution of Chef Infra&trade; client, licensed under Apache-2.0.

This repo contains all the required pipeline code to output functional builds of of the Chef Infra&trade; codebase under the rebranded name Cinc Client, designed to be compliant with Chef Software's [Policy on Trademarks](https://www.chef.io/trademark-policy/)

## Functioning

We use gitlab-ci. In our [fork of chef/chef](https://gitlab.com/cinc-project/upstream/chef) we maintain a branch named `stable/cinc`. This branch hosts a handful of commits required to rebrand the original code. When the pipeline runs, it clones a fresh copy of the upstream repository, merges in `stable/cinc` and executes the omnibus build.

We run builds for a variety of operating systems:
- Ubuntu 18.04+
- Centos 7+
- Debian 9+
- Opensuse 15
- Windows 2012r2+
- MacOS 10.14+

To build: go to pipelines and launch a pipeline on branch master, add a variable `ORIGIN` with which source you want to use (default to https://github.com/chef/chef on master branch)
To use a specific branch or a PR as source, find the branch and source of the PR and use `-b <branch name> https://github.com/<author>/chef` as value

## Getting started with Cinc

See the [quick start](https://www.cinc.sh/start/) section of our website, or jump directly to [downloads](http://downloads.cinc.sh/files/stable/cinc/).

## Contributing

See the [contributing section of our website](https://www.cinc.sh/contributing/)

# Authors

The Cinc Project

Originally written by [Tensibai Zhaoying](mailto:tensibai@iabis.net)

Contributions by [Lance Albertson](lance@osuosl.org), [Artem Sidorenko](artem@posteo.de) and [Marc Chamberland](chamberland.marc@gmail.com)

## License and copyright

Copyrights Cinc Project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
