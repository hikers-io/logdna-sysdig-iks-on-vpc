terraform {
  required_version = ">= 0.13"

  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.16.0"
    }
  
  
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }
  }

}