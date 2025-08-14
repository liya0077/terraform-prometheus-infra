locals {
  project_name = "prometheus"
  # Use this EXACT format for Name tags everywhere:
  name_tag_prefix = "prometheus - "

  # Global tags applied to all resources
  common_tags = {
    Project   = local.project_name
    ManagedBy = "terraform"
  }
}
