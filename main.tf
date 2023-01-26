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
