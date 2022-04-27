resource "aws_autoscaling_policy" "ec2_policy_up" {
    name = "ec2_policy_up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.pat-asg.name
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm_up" {
  alarm_name = "ec2_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    "AutoScalingGroupName" = "aws_autoscaling_group.pat-asg.name"
  }

  alarm_description = "This Metric Monitors EC2 Instance CPU Utilization"
  alarm_actions = [aws_autoscaling_policy.ec2_policy_up.arn]
}

resource "aws_autoscaling_policy" "ec2_policy_down" {
    name = "ec2_policy_down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.pat-asg.name
}

# CloudWatch Alarm for Scale In Policy
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm_down" {
  alarm_name = "ec2_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    "AutoScalingGroupName" = "aws_autoscaling_group.pat-asg.name"
  }

  alarm_description = "This Metric Monitors EC2 Instance CPU Utilization"
  alarm_actions = [aws_autoscaling_policy.ec2_policy_down.arn]
}