output "aws_lb" {
  description = "HTTP address of LoadBalancer"
  value       = module.load_balancer.lb_name
}