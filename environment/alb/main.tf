resource "aws_alb" "this_alb" {
  name = "${var.name}-alb"
  subnets = var.public_subnet_ids
  security_groups = var.security_group_ids

  tags = {
    Name = "${var.name}_alb"
    Terraform = true
    Project = var.name
  }
}

//resource "aws_alb_listener" "this_https_listener" {
//  load_balancer_arn = aws_alb.this_alb.id
//  port = "443"
//  protocol = "HTTPS"
//  certificate_arn = var.acm_cert_arn
//  ssl_policy = "ELBSecurityPolicy-2016-08"
//
//  default_action {
//    type = "fixed-response"
//
//    fixed_response {
//      content_type = "application/json"
//      message_body = "{\"error\": \"Wrong domain\"}"
//      status_code = "400"
//    }
//  }
//}

resource "aws_alb_listener" "this_http_listener" {
  load_balancer_arn = aws_alb.this_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



//data "aws_acm_certificate" "certificate" {
//  domain   = var.domain_name
//  statuses = ["ISSUED"]
//}

