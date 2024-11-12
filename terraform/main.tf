# main.tf

provider "aws" {
  region = "us-east-1"
}

module "ecs_service" {
  source          = "./modules/ecs_service"
  region          = "us-east-1"
  cluster_name    = "fastapi-cluster"
  repository_name = "fastapi-repo-v2"
  task_family     = "fastapi-task"
  task_cpu        = "256"
  task_memory     = "512"
  vpc_id          = "vpc-0eb6c32c3c0c8c507"
  subnet_ids      = ["subnet-0bfd390eabc57e9ef", "subnet-04bfb1b82a4ba8608"]
  desired_count   = 1
}
