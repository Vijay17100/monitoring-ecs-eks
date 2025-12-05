resource "aws_ecs_cluster" "ecs_cluster" {
    name = "${var.project_name}-ecs-cluster"
    tags = {
        Name = "${var.project_name}-ecs-cluster"
        project = var.project_name
    }
  
}