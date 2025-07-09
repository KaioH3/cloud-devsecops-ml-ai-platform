resource "oci_identity_policy" "cloud_guard" {
  name           = "AllowCloudGuardService"
  compartment_id = var.tenancy_ocid  # ← CORREÇÃO: usar tenancy_ocid
  description    = "Permite ao Cloud Guard gerenciar recursos"

  statements = [
    "Allow service cloudguard to read tenancies in tenancy",
    "Allow service cloudguard to manage cloud-guard-configuration-family in tenancy"
  ]
}
