variable "compartment_ocid" {
  description = "OCID do compartimento"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "dev"
}

variable "vcn_id" {
  description = "ID da VCN"
  type        = string
}

variable "api_subnet_id" {
  description = "ID da subnet para API do Kubernetes"
  type        = string
}

variable "lb_subnet_id" {
  description = "ID da subnet para Load Balancer"
  type        = string
}

variable "worker_subnet_id" {
  description = "ID da subnet para worker nodes"
  type        = string
}

variable "availability_domain" {
  description = "Availability Domain"
  type        = string
}

variable "image_id" {
  description = "ID da imagem Oracle Linux 9"
  type        = string
}

variable "ssh_public_key" {
  description = "Chave SSH pública"
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "v1.28.2"
}

variable "cluster_type" {
  description = "Tipo do cluster (BASIC_CLUSTER ou ENHANCED_CLUSTER)"
  type        = string
  default     = "BASIC_CLUSTER"
}

variable "node_pool_size" {
  description = "Tamanho do node pool"
  type        = number
  default     = 3
}

variable "total_ocpu" {
  description = "Total de OCPUs"
  type        = number
  default     = 4
}

variable "total_memory_gb" {
  description = "Total de memória GB"
  type        = number
  default     = 24
}
