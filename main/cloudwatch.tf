resource "aws_cloudwatch_log_group" "ecs_minecraft" {
  name              = "/ecs/minecraft"
  retention_in_days = 7
}