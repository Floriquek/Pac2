variable "private_key_path" {
  # add path to private ssh keys 
  # example: "/root/.ssh/id_rsa"

  default = "/root/.ssh/id_rsa"
}

variable "public_key_path" {
  # add path to public ssh keys
  # example: /root/.ssh/id_rsa.pub

  default = "/root/.ssh/id_rsa.pub"
}
