resource "aws_ecr_repository" "minecraft" {
  name                 = "minecraft-for-fargate_spot"
  image_scanning_configuration {
    scan_on_push = true
  }
  image_tag_mutability = "MUTABLE"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.minecraft.repository_url
}