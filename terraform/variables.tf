variable "namespace" {
  default = "default"
}

variable "image_repository" {
  default = "kotlin-app"
}

variable "image_tag" {
  default = "latest"
}

variable "image_pull_policy" {
  default = "Never"
}

variable "service_port" {
  default = 8080
}