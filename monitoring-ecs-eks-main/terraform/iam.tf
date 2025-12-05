resource "aws_iam_role" "role" {
    name = "${var.project_name}-ecs-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "ecs-tasks.amazonaws.com"
            }
        }
        ]
    })
    tags = {
        Name = "${var.project_name}-ecs-role"
        project = var.project_name
    }
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
    role       = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project_name}-ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })

  tags = { Project = var.project_name }
}