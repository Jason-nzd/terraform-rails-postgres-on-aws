
# EC2 running amazon linux 2023 AMI, with shell script to install ruby on rails
resource "aws_instance" "ec2_server" {
  ami                         = data.aws_ami.latest-amazon-linux.id
  instance_type               = var.ec2_instance_type
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.web_server.id]

  user_data = templatefile("install_web.sh", {
    ami         = data.aws_ami.latest-amazon-linux.id
    db_endpoint = aws_db_instance.postgres.endpoint
    db_username = var.db_username
    db_password = var.db_password
    db_name     = "postgres"
  })

  tags = {
    Name = "${var.project_name}-web-server"
  }
}

# RDS Postgres
resource "aws_db_instance" "postgres" {
  identifier        = "${var.project_name}-postgres"
  allocated_storage = 5
  db_name           = "postgres"
  engine            = "postgres"
  engine_version    = var.postgres_version
  instance_class    = var.db_instance_class
  # storage_type           = "gp3"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres15"
  vpc_security_group_ids = ["${aws_security_group.postgres.id}"]
  skip_final_snapshot    = true
  publicly_accessible    = true # Change later
}

# RDS DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}
