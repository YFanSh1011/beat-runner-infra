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

variable "bpm_service_image" {
  description = "ECR image for bpm service"
  default     = "339522008742.dkr.ecr.ap-southeast-2.amazonaws.com/beat-runner-backend/bpm-service:latest"
}

variable "auth_service_image" {
  description = "ECR image for auth service"
  default     = "339522008742.dkr.ecr.ap-southeast-2.amazonaws.com/beat-runner-backend/auth-service:latest"
}

variable "user_collection_service_image" {
  description = "ECR image for user collection service"
  default     = "339522008742.dkr.ecr.ap-southeast-2.amazonaws.com/beat-runner-backend/user-collection-service:latest"
}

variable "music_repository_service_image" {
  description = "ECR image for music repository service"
  default     = "339522008742.dkr.ecr.ap-southeast-2.amazonaws.com/beat-runner-backend/music-repository-service:latest"
}