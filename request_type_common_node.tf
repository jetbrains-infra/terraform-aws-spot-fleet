data "aws_ami" "common_ami" {
  most_recent      = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_spot_fleet_request" "common_nodes" {
  count = "${var.type == "common_node" ? 1 : 0}"
  iam_fleet_role      = "${aws_iam_role.spot-fleet-tagging-role.arn}"
  allocation_strategy = "diversified"
  target_capacity     = "${var.capacity}"
  valid_until         = "${var.valid_until}"

  launch_specification {
    instance_type          = "${var.ec2_type}"
    ami                    = "${var.common_node_ami_id == "" ? data.aws_ami.common_ami.id : var.common_node_ami_id}"
    key_name               = "${var.ssh_key}"
    availability_zone      = "${local.az}"
    subnet_id              = "${var.subnet_id}"
    vpc_security_group_ids = ["${split(",", var.security_group_ids)}"]
    associate_public_ip_address = "${var.public_ip}"

    // root partition
    root_block_device {
      volume_size = "${var.disk_size_root}"
      volume_type = "gp2"
    }

    user_data = "${var.userdata}"

    tags {
      Name = "${var.name} node"
    }
  }
}