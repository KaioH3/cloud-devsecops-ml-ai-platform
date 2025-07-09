variable "tenancy_ocid" {
  description = "OCID da tenancy Oracle Cloud"
  type        = string
}

variable "user_ocid" {
  description = "OCID do usuário Oracle Cloud"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint da chave API"
  type        = string
}

variable "private_key_path" {
  description = "Caminho para a chave privada OCI"
  type        = string
}

variable "compartment_ocid" {
  description = "OCID do compartimento"
  type        = string
}

variable "region" {
  description = "Região Oracle Cloud"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso às VMs"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "ml-credit-risk"
}

variable "alert_recipients" {
  description = "Lista de e-mails para alertas de orçamento"
  type        = list(string)
}

# === CONFIGURAÇÃO OKE ===
variable "enable_oke" {
  description = "Habilitar OKE ao invés de VMs simples"
  type        = bool
  default     = false
}

variable "enable_cloud_guard" {
  description = "Ativar Oracle Cloud Guard"
  type        = bool
  default     = true
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "v1.28.2"
}

variable "cluster_type" {
  description = "Tipo do cluster OKE"
  type        = string
  default     = "BASIC_CLUSTER"
  validation {
    condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], var.cluster_type)
    error_message = "Cluster type deve ser BASIC_CLUSTER ou ENHANCED_CLUSTER."
  }
}

variable "node_pool_size" {
  description = "Número de worker nodes"
  type        = number
  default     = 3
  validation {
    condition     = var.node_pool_size >= 1 && var.node_pool_size <= 4
    error_message = "Node pool size deve estar entre 1 e 4 para Always Free."
  }
}

variable "total_ocpu" {
  description = "Total de OCPUs ARM"
  type        = number
  default     = 4
  validation {
    condition     = var.total_ocpu <= 4
    error_message = "Always Free tier permite máximo 4 OCPUs ARM."
  }
}

variable "total_memory_gb" {
  description = "Total de memória GB"
  type        = number
  default     = 24
  validation {
    condition     = var.total_memory_gb <= 24
    error_message = "Always Free tier permite máximo 24 GB RAM."
  }
}

variable "environment" {
  description = "Ambiente de deployment (dev, staging, prod)"
  type        = string
  default     = "dev"
}
