resource "aws_lb" "alb" {
    name = "${var.project_name}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.asg.id]
    subnets = aws_subnet.public[*].id 

    tags = {
        Name = "${var.project_name}-alb"
        project = var.project_name
    }
  
}

resource "aws_lb_target_group" "tg" {
    name     = "${var.project_name}-tg"
    port     = var.container_port
    protocol = "HTTP"
    vpc_id   = aws_vpc.main.id
    target_type = "ip"
    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200-399"
    }
    tags = {
        Name = "${var.project_name}-tg"
        project = var.project_name
    }
  
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn
    port              = 80
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }
    tags = {
        Name = "${var.project_name}-listener"
        project = var.project_name
    }
  
}