resource "aws_lb_target_group" "postback" {
  name        = "${var.lb_target_group_names[0]}-${var.development_environment}"
  target_type = var.lb_target_type # "lambda"
}

resource "aws_lb_target_group" "ip-test" {
  name        = "tf-test-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lambda_permission" "with_lb" {
  statement_id  = "AllowExecutionFromlbtoLambda"
  action        = "lambda:InvokeFunction"
  function_name = var.target_ids_arn[0]
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.postback.arn
  # qualifier     = aws_lambda_alias.lambda_alias.name
}


resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.postback.arn
  target_id        = var.target_ids_arn[0] # example: aws_lambda_function.postback.arn
  depends_on       = [aws_lambda_permission.with_lb]
}


resource "aws_lb" "main" {
  name               = "${var.load_balancer_name}-${var.development_environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups #[module.my_vpc.security_group]
  subnets            = var.subnet_ids  #module.my_vpc.subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = var.development_environment
  }


}

resource "aws_lb_listener" "postback" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ip-test.arn
  }

  
}

resource "aws_lb_listener_rule" "postback_url" {
  listener_arn = aws_lb_listener.postback.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.postback.arn
  }

  condition {
    path_pattern {
      values = ["/postback"]
    }
  }

}


# resource "aws_lb_listener_rule" "wrong_path_request_check" {
#   listener_arn = aws_lb_listener.postback.arn

#   action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Route"
#       status_code  = "503"
#     }
#   }

#   condition {
#     query_string {
#       key   = "health"
#       value = "check"
#     }

#     query_string {
#       value = "bar"
#     }
#   }
# }

