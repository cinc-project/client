# cinc experiment

With the recent announcement that Chef is opensourcing all it's software the community has started this effort to create a distribution that's built in collaboration with Chef and in compliance with the Chef Trademarks Policy.

This repo contains all the required pipeline code to output functional builds of Chef with alternate names. This is not production ready, and compliance with Chef's policy on trademarks is still under evaluation, as such this code should _not_ be used for other purposes that development and experimentation.

## Functioning

This repo currently runs on gitlab and builds:

- the `chef-client` bin as `cinc-client`

In the following formats:

- .deb
- .rpm
- .msi

More support will be added over time.

To build: go to pipelines and launch a pipeline on branch master, add a variable `ORIGIN` with which source you want to use (default to https://github.com/chef/chef on master branch)
To use a specific branch or a PR as source, find the branch and source of the PR and use `-b <branch name> https://github.com/<author>/chef` as value

## Contributing

See https://gitlab.com/cc-build/organization-subjects/wikis/Home/Proposal\_A/contributing for more information about the process of making chef/chef (and other relevant repos) easily distributable under alternate names.

## Related community efforts

https://gitlab.com/cc-build/outspec for the build code for the Community Edition of Inspec (please note the name "outspec" is a placeholder)

https://github.com/biome-sh/biome for the Community fork of Chef Habitat (likely to be replaced in time with a dist.rb strategy + build pipeline)

Our existing builds can be found here: http://downloads.cc-build.org Please note these should only be used for experimentation purposes at this time, using them for other purposes could put you in violation of Chef's Policy on trademark and expose you to legal actions.

## TODO

- Add support for other ecosystem tools where appropriate
- Evaluate compliance of resulting binaries
- Hook pipeline into Chef's Expeditor to trigger builds whenever they release
- MacOS builds?
- Windows build pipeline
- Yum/Deb repository generation
- Omnitruck / mixlib-install integration
- Make a final decisions on project names

# Authors

Originally written by Tensibai Zhaoying tensibai@iabis.net

Contributions by Lance Albertson lance@osuosl.org, Artem Sidorenko artem@posteo.de and Marc Chamberland chamberland.marc@gmail.com

## License and copyright

Copyrights pending, but we fully intend to use a copyleft approach.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
