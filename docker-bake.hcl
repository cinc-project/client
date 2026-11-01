variable "CHANNEL" {
  default = "current"
}

variable "VERSION" {}
variable "MAJ" {}
variable "MIN" {}

variable "BUILD_ITERATION" {
  default = "1"
}

target "default" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]

  args = {
    VERSION = VERSION
    CHANNEL = CHANNEL
    BUILD_ITERATION = BUILD_ITERATION
  }

  tags = CHANNEL == "current" ? [
    "cincproject/cinc:${VERSION}",
    "cincproject/cinc:current"
    ] : [
    "cincproject/cinc:${VERSION}",
    "cincproject/cinc:latest",
    "cincproject/cinc:${MAJ}.${MIN}",
    "cincproject/cinc:${MAJ}"
  ]
}
