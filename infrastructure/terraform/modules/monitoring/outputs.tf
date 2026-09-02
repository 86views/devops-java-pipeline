# ----------------------------------------------------------------------------
# CloudWatch Dashboard outputs
# ----------------------------------------------------------------------------

output "dashboard_name" {
  description = "The name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.this.dashboard_name
}

output "dashboard_body" {
  description = "The JSON body of the dashboard (useful for debugging)"
  value       = aws_cloudwatch_dashboard.this.dashboard_body
}