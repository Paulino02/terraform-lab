resource "aws_sns_topic" "alert_topic" {
  name = "ecs-alerts"
}

resource "aws_sns_topic_subscription" "alert_subscription" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = "tpaulino12000@gmail.com"  # Substitua pelo seu endereço de e-mail
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "ecs-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when CPU utilization exceeds 80%"
  dimensions = {
    ClusterName = "my-cluster"
    ServiceName = "my-service"
  }

  alarm_actions = [aws_sns_topic.alert_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization" {
  alarm_name          = "ecs-memory-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when Memory utilization exceeds 80%"
  dimensions = {
    ClusterName = "my-cluster"
    ServiceName = "my-service"
  }

  alarm_actions = [aws_sns_topic.alert_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "disk_io" {
  alarm_name          = "ecs-disk-io"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskWriteBytes"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10000000"  # Ajuste conforme necessário
  alarm_description   = "Alarm when Disk I/O exceeds 10MB"
  dimensions = {
    ClusterName = "my-cluster"
    ServiceName = "my-service"
  }

  alarm_actions = [aws_sns_topic.alert_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "network_io" {
  alarm_name          = "ecs-network-io"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "NetworkOut"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "5000000"  # Ajuste conforme necessário
  alarm_description   = "Alarm when Network Out exceeds 5MB"
  dimensions = {
    ClusterName = "my-cluster"
    ServiceName = "my-service"
  }

  alarm_actions = [aws_sns_topic.alert_topic.arn]
}