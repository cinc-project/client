# cinc experiment

With the recent announcement that Chef is opensourcing all it's software the community has started this effort to create a distribution that's built in collaboration with Chef and in compliance with the Chef Trademarks Policy.

This repo contains the initial proof of concept for modifying the name of the binaries associated with Chef to achieve compliance.

## Functioning

This repo currently runs on gitlab and builds:

- the `chef-client` bin as `cinc-client`

In the following formats:

- .deb

More support will be added over time.

## Contributing

Guidelines TBD, come see us on Chef's Community Slack in #community-distros to talk about how you can help!

## Related community efforts

See https://docs.google.com/document/d/1JhgQ1vM2uLMgZc02RouU5hh7iXfSyOi4H9ipcl7YMJo for information on the community's effort to make Chef's source code easier to distribute in compliance with the Chef Trademark Policy

## TODO

- rpm package
- add support for other ecosystem tools where appropriate
