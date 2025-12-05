output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.ecr.repository_url
  
}

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.id
    
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
  
}

output "task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = aws_iam_role.role.arn
  
}