data "aws_ami" "latest-amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "ec2_server" {
  ami                         = data.aws_ami.latest-amazon-linux.id
  instance_type               = var.ec2_instance_type
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.sn-public-1.id
  vpc_security_group_ids      = [aws_security_group.sg_web_server.id]
  user_data = templatefile("install_web.sh", {
    ami         = data.aws_ami.latest-amazon-linux.id
    db_endpoint = aws_db_instance.default.endpoint
    db_username = var.db_username
  })

  tags = {
    Name = "Web Server"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.sn-private-1.id, aws_subnet.sn-private-2.id]

  tags = {
    Name = "DB Subnet Group"
  }
}

resource "aws_db_instance" "default" {
  identifier             = "postgres-server"
  allocated_storage      = 5
  db_name                = "mydb"
  engine                 = "postgres"
  engine_version         = var.postgres_version
  instance_class         = var.db_instance_class
  db_subnet_group_name   = aws_db_subnet_group.default.name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres15"
  vpc_security_group_ids = ["${aws_security_group.sg_postgres.id}"]
  skip_final_snapshot    = true
  publicly_accessible    = true
}
