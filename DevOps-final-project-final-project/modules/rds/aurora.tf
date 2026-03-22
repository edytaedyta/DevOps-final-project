resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${local.name}-cluster"

  engine         = var.aurora_engine
  engine_version = var.engine_version

  database_name   = var.db_name
  master_username = var.username
  master_password = var.password
  port            = var.port

  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.db.id]
  db_cluster_parameter_group_name = aws_db_parameter_group.this.name

  skip_final_snapshot = true
  deletion_protection = false

  tags = merge(var.tags, { Name = "${local.name}-cluster", Type = "aurora" })
}

resource "aws_rds_cluster_instance" "writer" {
  count = var.use_aurora ? 1 : 0

  identifier         = "${local.name}-writer-1"
  cluster_identifier = aws_rds_cluster.this[0].id

  instance_class = var.instance_class
  engine         = aws_rds_cluster.this[0].engine
  engine_version = aws_rds_cluster.this[0].engine_version

  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = merge(var.tags, { Name = "${local.name}-writer-1", Role = "writer" })
}
