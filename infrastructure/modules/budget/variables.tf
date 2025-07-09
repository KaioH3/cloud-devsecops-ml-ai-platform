variable "compartment_ocid" {
  description = "OCID do compartimento"
  type        = string
}

variable "amount_usd" {
  description = "Valor do orçamento em USD"
  type        = number
}

variable "display_name" {
  description = "Nome do budget"
  type        = string
}

variable "alert_recipients" {
  description = "Lista de e-mails para alertas"
  type        = list(string)
}

variable "create_budget" {
  description = "Criar budget? (true/false)"
  type        = bool
  default     = true
}
