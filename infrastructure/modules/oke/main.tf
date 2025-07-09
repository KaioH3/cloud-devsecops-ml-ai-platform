# === OKE CLUSTER ===
resource "oci_containerengine_cluster" "this" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.kubernetes_version
  name              = "${var.project_name}-oke-cluster"
  vcn_id            = var.vcn_id
  type              = var.cluster_type

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id           = var.api_subnet_id
  }

  options {
    service_lb_subnet_ids = [var.lb_subnet_id]

    # Add-ons apenas para enhanced cluster
    dynamic "add_ons" {
      for_each = var.cluster_type == "ENHANCED_CLUSTER" ? [1] : []
      content {
        is_kubernetes_dashboard_enabled = true
        is_tiller_enabled              = false
      }
    }
  }

  freeform_tags = {
    Environment = var.environment
    Project     = var.project_name
    AlwaysFree  = "true"
    ManagedBy   = "terraform"
  }
}

# === NODE POOL ===
resource "oci_containerengine_node_pool" "this" {
  cluster_id         = oci_containerengine_cluster.this.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.kubernetes_version
  name              = "${var.project_name}-oke-nodepool"

  node_config_details {
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id          = var.worker_subnet_id
    }
    size = var.node_pool_size
  }

  node_shape = "VM.Standard.A1.Flex"

  node_shape_config {
    ocpus         = var.total_ocpu / var.node_pool_size
    memory_in_gbs = var.total_memory_gb / var.node_pool_size
  }

  node_source_details {
    image_id                = var.image_id
    source_type            = "IMAGE"
    boot_volume_size_in_gbs = 50
  }

  ssh_public_key = var.ssh_public_key

  freeform_tags = {
    Environment = var.environment
    Project     = var.project_name
    AlwaysFree  = "true"
  }
}
