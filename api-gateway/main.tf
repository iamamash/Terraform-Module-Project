resource "aws_api_gateway_rest_api" "nginx_api" {
  name        = var.api_gateway_name
  description = "API Gateway to access NGINX on ALB"
}

resource "aws_api_gateway_resource" "nginx_resource" {
  rest_api_id = aws_api_gateway_rest_api.nginx_api.id
  parent_id   = aws_api_gateway_rest_api.nginx_api.root_resource_id
  path_part   = "nginx"
}

resource "aws_api_gateway_method" "nginx_method" {
  rest_api_id   = aws_api_gateway_rest_api.nginx_api.id
  resource_id   = aws_api_gateway_resource.nginx_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "nginx_integration" {
  rest_api_id             = aws_api_gateway_rest_api.nginx_api.id
  resource_id             = aws_api_gateway_resource.nginx_resource.id
  http_method             = aws_api_gateway_method.nginx_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.dns_name}"
}

resource "aws_api_gateway_deployment" "nginx_deployment" {
  depends_on  = [aws_api_gateway_integration.nginx_integration]
  rest_api_id = aws_api_gateway_rest_api.nginx_api.id
  stage_name  = "prod"
}
