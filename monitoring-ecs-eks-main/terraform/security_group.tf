resource "aws_security_group" "asg" {
    name        = "${var.project_name}-asg"
    description = "Security group for ${var.project_name}"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        description = "Allow HTTP inbound traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.project_name}-asg-sg"
        project = var.project_name
    }
  
}

resource "aws_security_group" "ecs_sg" {
    name        = "${var.project_name}-ecs-sg"
    description = "Security group for ECS tasks"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        description = "Allow inbound traffic from ALB"
        from_port   = var.container_port
        to_port     = var.container_port
        protocol    = "tcp"
        security_groups = [aws_security_group.asg.id]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.project_name}-ecs-sg"
        project = var.project_name
    }
  
}