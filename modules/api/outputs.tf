output "api_base_url" {
  value = aws_api_gateway_stage.contact_stage.invoke_url
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.contact_api.id
}

output "stage_name" {
  value = aws_api_gateway_stage.contact_stage.stage_name
}

output "api_routes" {
  value = {
    contact = "/contact"
  }
}
