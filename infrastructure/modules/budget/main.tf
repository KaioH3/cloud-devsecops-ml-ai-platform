resource "oci_budget_budget" "this" {
  count = var.create_budget ? 1 : 0   # deixe create_budget=false ou 0
  compartment_id = var.compartment_ocid
  amount       = var.amount_usd
  display_name = var.display_name
  description  = "Budget para monitorar custos Always Free"
  processing_period_type              = "MONTH"
  reset_period                        = "MONTHLY"
  budget_processing_period_start_offset = 1
  targets      = [var.compartment_ocid]
}

locals {
  budget_id = var.create_budget ? oci_budget_budget.this[0].id : ""
}
