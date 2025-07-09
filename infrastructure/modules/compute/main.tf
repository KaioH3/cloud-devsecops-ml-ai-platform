data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "oracle_linux9" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.A1.Flex"
  sort_order               = "DESC"
  sort_by                  = "TIMECREATED"
}

resource "oci_core_instance" "this" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = "VM.Standard.A1.Flex"
  display_name        = var.display_name
   
  shape_config {
    ocpus         = var.cpu
    memory_in_gbs = var.memory_gb
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux9.images[0].id
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(var.userdata_template)
  }
}

output "public_ip" {
  value = oci_core_instance.this.public_ip
}

output "private_ip" {
  value = oci_core_instance.this.private_ip
}
