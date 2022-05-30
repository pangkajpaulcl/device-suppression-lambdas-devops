##################################################################
# Application Load Balancer
##################################################################
module "alb-internal-development" {
  source = "../../modules/alb"

  name = "alb-postbacke-development"

  load_balancer_type = "application"
  internal           = false

  # vpc_id          = data.terraform_remote_state.vpc.outputs.base_outputs.main_vpc.id
  # subnets         = [data.terraform_remote_state.vpc.outputs.base_outputs.private_subnets.us_e_1a.id,
  #                   data.terraform_remote_state.vpc.outputs.base_outputs.private_subnets.us_e_1b.id,
  #                   data.terraform_remote_state.vpc.outputs.base_outputs.private_subnets.us_e_1c.id]

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc3a_id
  subnets = data.terraform_remote_state.vpc.outputs.vpc3a-public-subnets

  security_groups = [data.terraform_remote_state.security_groups.outputs.vpc3a_outside_access_security_group_id]


  tags = module.global.tags

  http_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "forward"
    }
  ]

 

  http_listener_rules = [
    {
      http_listener_index = 0
      priority            = 10 #Increment this value for each new listener rule
      actions = [
        {
          type               = "forward"
          target_group_index = 1 #Increment this value for each new listener rule
        }
      ]

      conditions = [{
        path_patterns = ["/postback"]
      }]
    }
  ]

  target_groups = [
    {
      name                 = "api-staging-int-tg"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
    },
    {
      name                 = "staging-targeting-lambda"
      target_type          = "lambda"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app_status"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200,301,302"
      }
    }
  ]

}

# alb permission added with target group and lambda function
resource "aws_lambda_permission" "with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-1:837630247226:function:development-v1-go-adid_postbacks"
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = module.alb-internal-development.target_group_arns[1]
}

# attach target group and lambda function
resource "aws_lb_target_group_attachment" "postback_lambda" {
  target_group_arn = module.alb-internal-development.target_group_arns[1]
  target_id        = "arn:aws:lambda:us-east-1:837630247226:function:development-v1-go-adid_postbacks"
  depends_on       = [aws_lambda_permission.with_lb]
}