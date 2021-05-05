resource "databricks_permissions" "cluster" {
  count = var.deploy_cluster ? 1 : 0

  cluster_id = join("", databricks_cluster.cluster.*.id)
  access_control {
    user_name        = join("", databricks_user.users.*.user_name)
    permission_level = "CAN_RESTART"
  }
  access_control {
    group_name       = databricks_group.spectators.display_name
    permission_level = "CAN_ATTACH_TO"
  }
}

resource "databricks_permissions" "policy" {
  count = var.deploy_cluster ? 1 : 0

  cluster_policy_id = join("", databricks_cluster_policy.this.*.id)
  access_control {
    group_name       = databricks_group.spectators.display_name
    permission_level = "CAN_USE"
  }
}