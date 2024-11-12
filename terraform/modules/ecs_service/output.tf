output "ecs_service_url" {
  value       = aws_lb.ecs_alb.dns_name
  description = "The URL of the FastAPI ECS service through the ALB"
}
