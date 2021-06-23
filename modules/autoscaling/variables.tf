variable "tags" { type = map(string) }

variable "instance_type" { type = string }

variable "subnet_ids_list" { type = list(string) }

variable "ssh_key" {
  type = string
}

variable "vpc_id" {}

variable "target_group_arns" {
  type = set(string)
}

variable "max" {
  type = string
}

variable "min" {
  type = string
}