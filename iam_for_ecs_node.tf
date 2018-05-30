data "aws_iam_policy_document" "instance-assume-role-policy-for-ecs-node" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ec2" {
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy-for-ecs-node.json}"
  name = "Ecs-Ec2InstanceRole-${element(split("-",uuid()), 0)}"
  lifecycle {
    ignore_changes = ["name"]
  }
}
resource "aws_iam_role_policy_attachment" "instance_role" {
  role = "${aws_iam_role.ec2.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_instance_profile" "instance_profile" {
  role = "${aws_iam_role.ec2.name}"
  name = "Ecs-ec2InstanceProfile-${element(split("-",uuid()), 0)}"

  lifecycle {
    ignore_changes = ["name"]
  }
}