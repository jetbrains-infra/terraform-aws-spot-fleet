## About

Terraform module to create AWS Spot instances for various purposes. 

The module provide the following profiles:

* ECS node
* Common node

### Params

* `name` - project information, used for tags and unique iam role name 
* `subnet_id` - placement subnet
* `security_group_id` - placement security group

### Optional params with default values

* `ssh_key` - default ssh pair id
* `capacity` - amount of nodes (default `1`) 
* `type` - type of launch configuration (default is `common_node`, currently supported values are `common_node` & `ecs_node`)
* `common_node_ami_id` - AMI image used for `common_node` type of launch configuration (default is the most recent Amazon provided AMI) 
* `ecs_node_ami_id` - AMI image used for `ecs_node` type of launch configuration (default is the most recent Amazon provided AMI)
* `iam_instance_profile` - IAM instance profile arn (required for ECS node, default is empty value)
* `ec2_type` - AWS EC2 type (default `t2.small`)
* `userdata` - userdata script body (default is empty value)
* `disk_size_root` - size of instance root partition (default is 8Gb)
* `disk_size_docker` - size of instance docker partition, used for `ecs_node` type (default is 25Gb)
* `valid_until` - the date until spot request is valid (default `2033-01-01T01:00:00Z`)
* `public_ip` - assign public IP on EC2 node (default `false`)
* `internet_access` - allow access to internet (default `true`)

## Usage

Example: One linux box 
```
module "bastion_host" {
    source               = ""
    name                 = "Bastion host"
    subnet_id            = "${aws_subnet.default.id}"
    ssh_key              = "${aws_key_pair.default.id}"
    security_group_ids   = ["${aws_security_group.myecs.id}"]
}
```

Example: Five ECS nodes of __c5.large__ type
```
module "my_ecs_nodes" {
    source               = ""
    name                 = "Example ECS cluster"
    subnet_id            = "${aws_subnet.default.id}"
    security_group_ids   = ["${aws_security_group.myecs.id}"]
    iam_instance_profile = "${aws_iam_instance_profile.ecs_node.id}" // wtf
    capacity             = "5"
    type                 = "ecs_node" // currently supported values are "common_node" & "ecs_node"
    ec2_type             = "c5.large"
    userdata             = <<EOT
#!/bin/bash
echo ECS_CLUSTER="${aws_ecs_cluster.example.name}" >> /etc/ecs/ecs.config

EOT
}
```