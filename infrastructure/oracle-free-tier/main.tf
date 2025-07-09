# === DADOS ORACLE CLOUD ===
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "oracle_linux_9" {
  count                    = var.enable_oke ? 1 : 0
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.A1.Flex"
  state                    = "AVAILABLE"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# === MÓDULOS ===
module "network" {
  source           = "../modules/vcn"
  compartment_ocid = var.compartment_ocid
  project_name     = var.project_name
  enable_oke       = var.enable_oke
}

# Módulo OKE (quando enable_oke = true)
module "oke" {
  count  = var.enable_oke ? 1 : 0
  source = "../modules/oke"

  compartment_ocid = var.compartment_ocid
  project_name     = var.project_name
  environment      = "dev"

  # Network
  vcn_id           = module.network.vcn_id
  api_subnet_id    = module.network.oke_api_subnet_id
  lb_subnet_id     = module.network.oke_lb_subnet_id
  worker_subnet_id = module.network.oke_workers_subnet_id

  # Compute
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  image_id            = var.enable_oke ? data.oci_core_images.oracle_linux_9[0].images[0].id : null
  ssh_public_key      = var.ssh_public_key

  # OKE Config
  kubernetes_version = var.kubernetes_version
  cluster_type       = var.cluster_type
  node_pool_size     = var.node_pool_size
  total_ocpu         = var.total_ocpu
  total_memory_gb    = var.total_memory_gb
}

# Módulos compute (quando enable_oke = false)
module "compute_backend" {
  count             = var.enable_oke ? 0 : 1
  source            = "../modules/compute"
  compartment_ocid  = var.compartment_ocid
  subnet_id         = module.network.public_subnet_id
  ssh_public_key    = var.ssh_public_key
  display_name      = "${var.project_name}-backend"
  cpu               = 2
  memory_gb         = 12
  userdata_template = file("${path.module}/scripts/setup-backend.sh") # ✅ ADICIONAR
}

module "compute_frontend" {
  count             = var.enable_oke ? 0 : 1
  source            = "../modules/compute"
  compartment_ocid  = var.compartment_ocid
  subnet_id         = module.network.public_subnet_id
  ssh_public_key    = var.ssh_public_key
  display_name      = "${var.project_name}-frontend"
  cpu               = 2
  memory_gb         = 12
  userdata_template = file("${path.module}/scripts/setup-frontend.sh") # ✅ ADICIONAR
}

# Budget (sempre ativo)
module "finops" {
  source           = "../modules/budget"
  compartment_ocid = var.compartment_ocid
  amount_usd       = 5
  display_name     = "always-free-budget"
  alert_recipients = var.alert_recipients
  create_budget    = true
}

# Cloud Guard (condicional)
resource "oci_cloud_guard_cloud_guard_configuration" "main" {
  count            = var.enable_cloud_guard ? 1 : 0
  compartment_id   = var.compartment_ocid
  reporting_region = var.region
  status           = "ENABLED"
}
