locals {
  name = "${var.project_name}-db"

  is_postgres = var.use_aurora ? (var.aurora_engine == "aurora-postgresql") : (var.engine == "postgres")
  parameter_group_family = (
    var.use_aurora
    ? (var.aurora_engine == "aurora-postgresql" ? "aurora-postgresql15" : "aurora-mysql8.0")
    : (var.engine == "postgres" ? "postgres15" : "mysql8.0")
  )

  base_parameters = local.is_postgres ? {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4MB"
  } : {
    max_connections  = "200"
    general_log      = "0"
    sort_buffer_size = "262144"
  }

  merged_parameters = merge(local.base_parameters, var.parameter_overrides)
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name}-subnets"
  subnet_ids = var.subnet_ids
  tags = merge(var.tags, { Name = "${local.name}-subnets" })
}

resource "aws_security_group" "db" {
  name        = "${local.name}-sg"
  description = "DB access security group"
  vpc_id      = var.vpc_id
  tags = merge(var.tags, { Name = "${local.name}-sg" })
}

resource "aws_security_group_rule" "ingress" {
  count             = length(var.allowed_cidrs) > 0 ? 1 : 0
  type              = "ingress"
  security_group_id = aws_security_group.db.id
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidrs
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.db.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_parameter_group" "this" {
  name   = "${local.name}-params"
  family = local.parameter_group_family

  dynamic "parameter" {
    for_each = local.merged_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  tags = merge(var.tags, { Name = "${local.name}-params" })
}
