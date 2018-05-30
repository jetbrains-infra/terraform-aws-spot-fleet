variable "name" {}

variable "subnet_id" {}
data "aws_subnet" "default" {
  id = "${var.subnet_id}"
}
locals {
  az = "${data.aws_subnet.default.availability_zone}"
}

variable "ssh_key" {}
variable "security_group_ids" {}

variable "iam_instance_profile_arn" {
  default = ""
}
variable "capacity" {
  default = 1
}
variable "type" {
  default = "common_node"
}
variable "common_node_ami_id" {
  default = ""
}
variable "ecs_node_ami_id" {
  default = ""
}
variable "ec2_type" {
  default = "t2.small"
}
variable "userdata" {
  default = ""
}
variable "disk_size_root" {
  default = 8
}
variable "disk_size_docker" {
  default = 25
}
variable "valid_until" {
  default = "2033-01-01T01:00:00Z"
}
variable "public_ip" {
  default = false
}