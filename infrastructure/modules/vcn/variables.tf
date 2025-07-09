variable "compartment_ocid" {
  type = string
}

variable "project_name" {
  type = string
}

variable "enable_oke" {
  description = "Habilitar recursos para OKE"
  type        = bool
  default     = false
}
