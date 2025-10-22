variable "CHANNEL" {
  default = "current"
}

variable "VERSION" {}
variable "MAJ" {}
variable "MIN" {}

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
