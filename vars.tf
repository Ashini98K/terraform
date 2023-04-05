variable "AWS_ACCESS_KEY_ID" {
  default = "AKIAXKBBMQDHV6FWA5XK"
}
variable "AWS_SECRET_ACCESS_KEY" {
  default = "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"
}
variable "myvar" {
  type    = string
  default = "Hello Terraform"
}
variable "mymap" {
  type = map(string)
  default = {
    "mapkey" = "map value"
  }
}
variable "mylist" {
  type    = list(any)
  default = ["red", "Blue"]
}
