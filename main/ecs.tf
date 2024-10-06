# ECS Cluster
resource "aws_ecs_cluster" "minecraft" {
  name = var.cluster_name
}

# Task Definition
resource "aws_ecs_task_definition" "minecraft" {
  family                   = "minecraft-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024" # 1 vCPU
  memory                   = "2048" # 2GB RAM
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "minecraft"
      image     = "itzg/minecraft-server"
      essential = true
      stop_timeout = 120
      portMappings = [
        {
          containerPort = 25565
          hostPort      = 25565
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "minecraft_data"
          containerPath = "/data"
          readOnly      = false
        }
      ]
      environment = [
        {
          name  = "EULA"
          value = "TRUE"
        },
        {
          name  = "SKIP_OWNERSHIP_FIX"
          value = "true"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/minecraft"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name = "minecraft_data"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.minecraft.id
      transit_encryption      = "ENABLED"
      root_directory          = "/"
      authorization_config {
        access_point_id = aws_efs_access_point.minecraft.id
        iam             = "ENABLED"
      }
    }
  }
}

# ECS Service
resource "aws_ecs_service" "minecraft" {
  name            = "minecraft-service"
  cluster         = aws_ecs_cluster.minecraft.id
  task_definition = aws_ecs_task_definition.minecraft.arn
  desired_count   = 1
  platform_version = "LATEST"
  enable_execute_command = true

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  network_configuration {
    subnets         = [aws_subnet.public.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.minecraft.arn
    container_name   = "minecraft"
    container_port   = 25565
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  depends_on = [aws_lb_listener.minecraft]
}