#
# locals.tf
#
###############################################################################
#
# ECS Cluster Tags
#
locals {

  # Tags for ECS Cluster
  ecs_cluster_tags = {
    Environment = "Test"
    Team        = "DevOps"
    Project     = "ECS Cluster Setup"
    ManagedBy   = "Terraform"
  }
}
