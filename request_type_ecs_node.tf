data "aws_ami" "ecs_ami" {
  most_recent      = true
  owners      = ["amazon"]
  
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

resource "aws_spot_fleet_request" "ecs_nodes" {
  count = "${var.type == "ecs_node" ? 1 : 0}"
  iam_fleet_role      = "${aws_iam_role.spot-fleet-tagging-role.arn}"
  allocation_strategy = "diversified"
  target_capacity     = "${var.capacity}"
  valid_until         = "${var.valid_until}"

  launch_specification {
    instance_type            = "${var.ec2_type}"
    ami                      = "${var.ecs_node_ami_id == "" ? data.aws_ami.ecs_ami.id : var.ecs_node_ami_id}"
    iam_instance_profile_arn = "${var.iam_instance_profile_arn == "" ? aws_iam_instance_profile.instance_profile.arn : var.iam_instance_profile_arn}"
    key_name                 = "${var.ssh_key}"
    availability_zone        = "${local.az}"
    subnet_id                = "${var.subnet_id}"
    vpc_security_group_ids   = ["${local.security_groups}"]
    associate_public_ip_address = "${var.public_ip}"

    // root partition
    root_block_device {
      volume_size = "${var.disk_size_root}"
      volume_type = "gp2"
    }
    // docker partition
    ebs_block_device {
      device_name = "/dev/xvdcz"
      // Disk naming is important!
      volume_size = "${var.disk_size_docker}"
      volume_type = "gp2"
    }

    user_data = "${var.userdata}"

    tags {
      Name = "${var.name} node"
    }
  }
}