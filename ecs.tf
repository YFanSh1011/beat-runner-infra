resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-cluster"

  tags = local.common_tags
}

resource "aws_iam_policy" "task_execution_role_policy" {
  name        = "${local.prefix}-task-exec-role-policy"
  path        = "/"
  description = "Allow retrieving of images and adding to logs"
  policy      = file("./templates/ecs/task-exec-role.json")
}

# Permission to start container
resource "aws_iam_role" "task_execution_role" {
  name               = "${local.prefix}-task-exec-role"
  assume_role_policy = file("./templates/ecs/assume-role-policy.json")

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
}

# Permission to run task
resource "aws_iam_role" "app_iam_role" {
  name               = "${local.prefix}-api-task"
  assume_role_policy = file("./templates/ecs/assume-role-policy.json")

  tags = local.common_tags
}

# Create log groups and streams
resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name = "${local.prefix}-api"

  tags = local.common_tags
}



resource "aws_ecs_task_definition" "bpm_service" {
  family = "${local.prefix}-bpm-service"

  container_definitions = templatefile("./templates/ecs/tasks/bpm-service-task-definition.json", {
    bpm_service_image = var.bpm_service_image
    db_host           = aws_db_instance.main.address
    db_user           = aws_db_instance.main.username
    db_pass           = aws_db_instance.main.password
    log_group_name    = aws_cloudwatch_log_group.ecs_task_logs.name
    log_group_region  = data.aws_region.current.name
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.app_iam_role.arn

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "user_collection_service" {
  family = "${local.prefix}-user-collection-service"

  container_definitions = templatefile("./templates/ecs/tasks/user-collection-service-task-definition.json", {
    user_collection_service_image = var.user_collection_service_image
    db_host                       = aws_db_instance.main.address
    db_user                       = aws_db_instance.main.username
    db_pass                       = aws_db_instance.main.password
    log_group_name                = aws_cloudwatch_log_group.ecs_task_logs.name
    log_group_region              = data.aws_region.current.name
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.app_iam_role.arn

  tags = local.common_tags
}


resource "aws_ecs_task_definition" "auth_service" {
  family = "${local.prefix}-auth-service"

  container_definitions = templatefile("./templates/ecs/tasks/auth-service-task-definition.json", {
    auth_service_image = var.auth_service_image
    log_group_name     = aws_cloudwatch_log_group.ecs_task_logs.name
    log_group_region   = data.aws_region.current.name
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.app_iam_role.arn

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "music_repository_service" {
  family = "${local.prefix}-music-repository-service"

  container_definitions = templatefile("./templates/ecs/tasks/music-repository-service-task-definition.json", {
    music_repository_service_image = var.music_repository_service_image
    db_host                        = aws_db_instance.main.address
    db_user                        = aws_db_instance.main.username
    db_pass                        = aws_db_instance.main.password
    log_group_name                 = aws_cloudwatch_log_group.ecs_task_logs.name
    log_group_region               = data.aws_region.current.name
  })

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.app_iam_role.arn

  tags = local.common_tags
}