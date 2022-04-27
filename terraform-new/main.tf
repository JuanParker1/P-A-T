 provider "aws" {
     region = "ap-south-1"
 }

//  resource "aws_instance" "my_first_machine" {
//      ami = "ami-0851b76e8b1bce90b"
//      instance_type = "t2.micro"
//      count         = var.instance_data.count  
//      security_groups = ["sg-07243c3762e88e437"]
//      subnet_id = "subnet-0bee8832e401ccc6b"
//      associate_public_ip_address = true
//      key_name = "jenkins-pipelines"
//      tags = {
//         Name = "my-machine-${count.index}"
//      }
//  } 

// resource "aws_instance" "vinod_server )" {
//   # Creates four identical aws ec2 instances
//   count = 4     
  
//   # All four instances will have the same ami and instance_type
//   ami = var.ec2_ami 
//   instance_type = var.instance_type
//   security_groups = ["sg-07243c3762e88e437"]
//   key_name = "jenkins-pipelines"
//   tags = {
//     # The count.index allows you to launch a resource 
//     # starting with the distinct index number 0 and corresponding to this instance.
//     Name = "my-machine-${count.index}"
//   }
// }

// resource "aws_instance" "ec2" {
//     ami = var.ec2-ami
//     instance_type = var.instance_type
//     key_name = var.ec2_keypair
//     count = var.ec2_count
//     security_groups = var.vpc_security_group
//     subnet_id = element(var.subnets, count.index)
//     tags = {
//         Name = "${var.environment}.${var.product}-${count.index}"
//     }
// }

resource "aws_lb_target_group" "my_target_group" {
    health_check {
        interval =              10
        path =                  "/"
        protocol =              "HTTP"
        timeout =               5
        healthy_threshold =     5
        unhealthy_threshold =   2
    }
    name     = "tf-example-lb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}

resource  "aws_lb" "my-aws-alb" {
  name =            "My-terraform-alb"
  internal =        false
  security_groups = var.vpc_security_group
  subnets =        ["subnet-0bee8832e401ccc6b","subnet-01d1fa65065bf0797"]
}

resource "aws_lb_listener" "aws_lb_listener_test" {
  load_balancer_arn = aws_lb.my-aws-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
}
}

resource "aws_launch_configuration" "pat-lc" {
  name = "pat-launch-config"
  image_id = var.ec2-ami
  instance_type = var.instance_type
  key_name = var.ec2_keypair
  security_groups = var.vpc_security_group
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}
data "aws_subnet_ids" "example" {
  vpc_id = var.vpc_id
}

resource "aws_autoscaling_group" "pat-asg"{
  name = "pat-asg"
  launch_configuration = "${aws_launch_configuration.pat-lc.id}"
  #availability_zones = "${data.aws_availability_zones.all.names}"
  min_size = 1
  desired_capacity = 1
  max_size = 2
  health_check_type = "EC2"
  target_group_arns = [ "${aws_lb_target_group.my_target_group.arn}" ]
  vpc_zone_identifier = "${data.aws_subnet_ids.example.ids}"
  #vpc_zone_identifier = [ "${aws_subnet.public_subnet-1.id}","${aws_subnet.public_subnet-2.id}" ]
  tag {
    key = "Name"
    value = "terraform-pat-asg"
    propagate_at_launch = true
  }
}

output "alb_dns_name" {
  value = "aws_lb.my-aws-alb.dns_name"
}