resource "aws_cloudwatch_log_group" "cloodwatch" {
    name              = "/ecs/${var.project_name}"
    retention_in_days = 14
    tags = {
        Name = "${var.project_name}-cloudwatch"
        project = var.project_name
    }
  
}