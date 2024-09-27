resource "aws_lb" "minecraft" {
  name               = "minecraft-nlb"
  load_balancer_type = "network"
  subnets            = [aws_subnet.public.id]

  tags = {
    Name = "minecraft-nlb"
  }
}

resource "aws_lb_target_group" "minecraft" {
  name        = "minecraft-tg"
  port        = 25565
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.minecraft.id

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }

  tags = {
    Name = "minecraft-tg"
  }
}

resource "aws_lb_listener" "minecraft" {
  load_balancer_arn = aws_lb.minecraft.arn
  port              = "25565"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.minecraft.arn
  }
}