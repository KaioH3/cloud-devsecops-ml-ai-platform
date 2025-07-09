output "cluster_id" {
  description = "ID do cluster OKE"
  value       = oci_containerengine_cluster.this.id
}

output "cluster_name" {
  description = "Nome do cluster OKE"
  value       = oci_containerengine_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint da API Kubernetes"
  value       = oci_containerengine_cluster.this.endpoints[0].public_endpoint
}

output "kubernetes_version" {
  description = "Versão do Kubernetes"
  value       = oci_containerengine_cluster.this.kubernetes_version
}

output "node_pool_id" {
  description = "ID do node pool"
  value       = oci_containerengine_node_pool.this.id
}
