variable "aws_region" {
  description = "Region to place all AWS resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "ec2_instance_type" {
  description = "EC2 instance type/size"
  type        = string
  default     = "t2.micro"
}
variable "ssh_key_name" {
  description = "Name of ssh key pair to assign to EC2 instance"
  type        = string
  default     = ""
}
variable "ssh_key_local_path" {
  description = "Local path to ssh key pair file"
  type        = string
  default     = ""
}

variable "postgres_version" {
  type    = string
  default = "15.2"
}
variable "db_name" {
  type    = string
  default = "mydb"
}
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "db_username" {
  type    = string
  default = "postgres"
}
variable "db_password" {
  description = "DB root user password"
  type        = string
  sensitive   = true
}


