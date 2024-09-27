resource "aws_efs_file_system" "minecraft" {
  creation_token = var.efs_name
  tags = {
    Name = var.efs_name
  }
}

resource "aws_efs_mount_target" "minecraft" {
  file_system_id = aws_efs_file_system.minecraft.id
  subnet_id      = aws_subnet.public.id
  security_groups = [
    aws_security_group.efs.id
  ]
}

resource "aws_efs_access_point" "minecraft" {
  file_system_id = aws_efs_file_system.minecraft.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/minecraft_data"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }
}