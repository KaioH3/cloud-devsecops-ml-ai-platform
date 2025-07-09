variable "compartment_ocid" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "display_name" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory_gb" {
  type = number
}

variable "userdata_template" {
  description = "Script cloud-init"
  type        = string
  default     = ""
}
