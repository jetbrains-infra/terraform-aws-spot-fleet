resource "aws_security_group" "access_to_internet" {
  count = "${var.internet_access ? 1 : 0}"
  name = "Access to internet"
  vpc_id = "${data.aws_subnet.default.vpc_id}"

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}