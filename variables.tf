variable "prefix" {
  default = "brb" # stands for beat runner backend
  type    = string
}

variable "project" {
  default = "beatrunner"
}

variable "db_username" {
  type        = string
  description = "Username for RDS Postgres"
}

variable "db_password" {
  type        = string
  description = "Password for RDS Postgres"
}

variable "bastion_key_name" {
  default     = "beat-runner-keypair"
  type        = string
  description = "Keypair for bastion host to SSH to instances in private subnets"
}