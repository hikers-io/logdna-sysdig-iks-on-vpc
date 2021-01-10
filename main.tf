##############################################################################
# Resource Group
##############################################################################

data ibm_resource_group group {
  name = var.resource_group
}

##############################################################################


##############################################################################
# Activity Tracker
##############################################################################

resource ibm_resource_instance activity_tracker {

  count             = var.provision_activity_tracker ? 1 : 0

  name              = var.activity_tracker_name
  service           = "logdnaat"
  plan              = var.logging_plan
  location          = var.ibm_region
  resource_group_id = data.ibm_resource_group.group.id

  parameters = {
    service-endpoints = var.logging_endpoint
  }

}

##############################################################################


##############################################################################
# Cluster Logging Setup
##############################################################################

module logging {
    source             = "./logging"
    resource_group_id  = data.ibm_resource_group.group.id
    use_data           = var.bring_your_own_logging
    ibm_region         = var.ibm_region
    name               = var.logging_instance_name
    logdna_agent_image = var.logging_agent_image
    logdna_endpoint    = var.logging_endpoint
    logging_plan       = var.logging_plan
    tags               = var.tags
    end_points         = var.service_end_points
}

##############################################################################


##############################################################################
# Cluster Monitoring Setup
##############################################################################

module monitor {
    source               = "./monitoring"
    create_k8s_namespace = var.k8s_logging_agent_namespace != var.k8s_monitoring_agent_namespace
    resource_group_id    = data.ibm_resource_group.group.id
    use_data             = var.bring_your_own_monitor
    ibm_region           = var.ibm_region
    name                 = var.monitor_name
    cluster_name         = var.cluster_name
    sysdig_image         = var.monitor_agent_image
    sysdig_endpoint      = var.monitor_endpoint
    monitor_plan         = var.monitor_plan
    tags                 = var.tags
    end_points           = var.service_end_points
}

##############################################################################