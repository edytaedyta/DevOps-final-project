resource "aws_ecr_repository" "this" {
  name = "${var.project_name}-django-app"
  image_scanning_configuration { scan_on_push = true }
  tags = var.tags
}
