resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "${var.project_name}-vcn"
  dns_label      = "devsecopsmlops"  # 14 caracteres # substr(lower(var.project_name), 0, 15)
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-igw"
}

resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-rt"

  # CORRETO: route_rules como BLOCO, não array
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_subnet" "public" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = "10.0.1.0/24"
  display_name               = "${var.project_name}-public-subnet"
  dns_label                  = "pub"
  route_table_id             = oci_core_route_table.rt.id
  prohibit_public_ip_on_vnic = false
}

# === RECURSOS PARA OKE (apenas quando enable_oke = true) ===
# NAT Gateway para worker nodes privados
resource "oci_core_nat_gateway" "nat" {
  count          = var.enable_oke ? 1 : 0
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-nat"
}

# Service Gateway para serviços Oracle
resource "oci_core_service_gateway" "sg" {
  count          = var.enable_oke ? 1 : 0
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-service-gw"
  
  services {
    service_id = data.oci_core_services.all_services[0].services[0].id
  }
}

data "oci_core_services" "all_services" {
  count = var.enable_oke ? 1 : 0
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

# Route table para subnet privada
resource "oci_core_route_table" "private" {
  count          = var.enable_oke ? 1 : 0
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-private-rt"
  
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat[0].id
  }
  
  route_rules {
    destination       = data.oci_core_services.all_services[0].services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sg[0].id
  }
}

# Subnets específicas para OKE
resource "oci_core_subnet" "oke_api" {
  count                      = var.enable_oke ? 1 : 0
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = "10.0.2.0/24"
  display_name               = "${var.project_name}-oke-api-subnet"
  dns_label                  = "okeapi"
  route_table_id             = oci_core_route_table.rt.id
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "oke_lb" {
  count                      = var.enable_oke ? 1 : 0
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = "10.0.3.0/24"
  display_name               = "${var.project_name}-oke-lb-subnet"
  dns_label                  = "okelb"
  route_table_id             = oci_core_route_table.rt.id
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "oke_workers" {
  count                      = var.enable_oke ? 1 : 0
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = "10.0.10.0/24"
  display_name               = "${var.project_name}-oke-workers-subnet"
  dns_label                  = "okeworkers"
  route_table_id             = var.enable_oke ? oci_core_route_table.private[0].id : oci_core_route_table.rt.id
  prohibit_public_ip_on_vnic = true
}
