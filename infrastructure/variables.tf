variable "key_pair_name" {
  type    = string
  default = "astroneer_server"
}

variable "public_key_path" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}
