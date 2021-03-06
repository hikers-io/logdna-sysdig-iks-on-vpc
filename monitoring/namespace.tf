##############################################################################
# Locally define image pull secrets to copy to ibm-observe namespace 
##############################################################################

locals {
  image_pull_secrets = [
      "all-icr-io"
    ]
} 

##############################################################################


##############################################################################
# Create Namespace
##############################################################################

resource kubernetes_namespace k8s_agent_namespace {
  count = var.create_k8s_namespace ? 1: 0
  metadata {
    name = var.k8s_agent_namespace
  }
}

##############################################################################


##############################################################################
# Default pull secret
##############################################################################

data kubernetes_secret image_pull_secret {
  count = var.create_k8s_namespace ? length(local.image_pull_secrets) : 0
  metadata {
    name = element(local.image_pull_secrets, count.index)
  }
}

##############################################################################


##############################################################################
# Copy image pull secret to ibm-observe
##############################################################################

resource kubernetes_secret copy_image_pull_secret {
  count = var.create_k8s_namespace ? length(local.image_pull_secrets) : 0
  metadata {
    name      = "ibm-observe-${element(local.image_pull_secrets, count.index)}"
    namespace = kubernetes_namespace.k8s_agent_namespace.0.metadata.0.name
  }
  data      = {
    ".dockerconfigjson" = data.kubernetes_secret.image_pull_secret[count.index].data[".dockerconfigjson"]
  }
  type = "kubernetes.io/dockerconfigjson"
}

##############################################################################