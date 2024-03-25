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