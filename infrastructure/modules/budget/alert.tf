resource "oci_budget_alert_rule" "alert" {
  count        = var.create_budget ? 1 : 0
  budget_id    = local.budget_id
  display_name = "alert-80-percent"
  description  = "Alerta quando 80% do orçamento for atingido"
  threshold    = 80
  threshold_type = "PERCENTAGE"
  recipients   = join(",", var.alert_recipients)  # ✅ CORRIGIR: converter lista para string
  type         = "ACTUAL"
}

resource "oci_budget_alert_rule" "thirty_percent" {
  count        = var.create_budget ? 1 : 0
  budget_id    = local.budget_id
  display_name = "alert-30-percent"
  description  = "Alerta quando 30% do orçamento for atingido"
  threshold    = 30
  threshold_type = "PERCENTAGE"
  recipients   = join(",", var.alert_recipients)  # ✅ CORRIGIR: converter lista para string
  type         = "ACTUAL"
}
