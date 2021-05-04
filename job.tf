#NOTE:
# IF YOU CHANGE FROM EXISTING TO NEW CLUSTER
# DELETE THE WHOLE SETUP AND DEPLOY AGAIN
# IF YOU CANNOT DELETE THE SETUP DELETE THE INSTALL POOL
# ------------------------------------------------
# NEW JOBS CLUSTER
# ------------------------------------------------
resource "databricks_job" "databricks_new_cluster_job" {
  count = (var.deploy_job == true && var.use_existing_cluster == false) ? 1 : 0

  name = "${var.teamid}-${var.prjid} (${data.databricks_current_user.me.alphanumeric})"
  new_cluster {
    num_workers   = var.num_workers
    spark_version = data.databricks_spark_version.latest.id
    node_type_id  = data.databricks_node_type.cluster_node_type.id
  }

  notebook_task {
    notebook_path = databricks_notebook.notebook_file.path
  }

  dynamic "email_notifications" {
    for_each = var.email_notifications
    content {
      on_failure                = email_notifications.value["on_failure"]
      no_alert_for_skipped_runs = email_notifications.value["no_alert_for_skipped_runs"]
      on_success                = email_notifications.value["on_success"]
      on_start                  = email_notifications.value["on_start"]
    }
  }
}

# ------------------------------------------------
# EXISTING CLUSTER
# ------------------------------------------------
resource "databricks_job" "databricks_job" {
  count = (var.deploy_job == true && var.use_existing_cluster == true) ? 1 : 0

  name                = "${var.teamid}-${var.prjid} (${data.databricks_current_user.me.alphanumeric})"
  existing_cluster_id = local.cluster_info

  notebook_task {
    notebook_path = databricks_notebook.notebook_file.path
  }

  dynamic "email_notifications" {
    for_each = var.email_notifications
    content {
      on_failure                = email_notifications.value["on_failure"]
      no_alert_for_skipped_runs = email_notifications.value["no_alert_for_skipped_runs"]
      on_success                = email_notifications.value["on_success"]
      on_start                  = email_notifications.value["on_start"]
    }
  }
}
