# ----------------------------------------------------------------------------
# ALB outputs
# ----------------------------------------------------------------------------

output "lb_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.this.id
}

output "lb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

output "lb_arn_suffix" {
  description = "The ARN suffix of the ALB (useful for CloudWatch metrics)"
  value       = aws_lb.this.arn_suffix
}

output "lb_dns_name" {
  description = "The DNS name of the ALB (e.g., my-alb-1234567890.elb.amazonaws.com)"
  value       = aws_lb.this.dns_name
}

output "lb_zone_id" {
  description = "The Route 53 hosted zone ID of the ALB (useful for DNS records)"
  value       = aws_lb.this.zone_id
}

output "lb_security_group_id" {
  description = "The security group ID attached to the ALB"
  value       = one(aws_lb.this.security_groups)
}

output "target_group_id" {
  description = "The ID of the target group"
  value       = aws_lb_target_group.this.id
}

output "target_group_arn" {
  description = "The ARN of the target group (used by ECS service)"
  value       = aws_lb_target_group.this.arn
}

output "target_group_arn_suffix" {
  description = "The ARN suffix of the target group (useful for CloudWatch metrics)"
  value       = aws_lb_target_group.this.arn_suffix
}

output "target_group_name" {
  description = "The name of the target group"
  value       = aws_lb_target_group.this.name
}

output "listener_arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}