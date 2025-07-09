# === OUTPUTS VMs (quando enable_oke = false) ===
output "backend_public_ip" {
  description = "IP público da VM backend"
  value       = var.enable_oke ? null : (length(module.compute_backend) > 0 ? module.compute_backend[0].public_ip : null)
}

output "frontend_public_ip" {
  description = "IP público da VM frontend"
  value       = var.enable_oke ? null : (length(module.compute_frontend) > 0 ? module.compute_frontend[0].public_ip : null)
}

output "backend_private_ip" {
  description = "IP privado da VM backend"
  value       = var.enable_oke ? null : (length(module.compute_backend) > 0 ? module.compute_backend[0].private_ip : null)
}

output "frontend_private_ip" {
  description = "IP privado da VM frontend"
  value       = var.enable_oke ? null : (length(module.compute_frontend) > 0 ? module.compute_frontend[0].private_ip : null)
}

output "application_urls" {
  description = "URLs das aplicações"
  value = var.enable_oke ? null : (
    length(module.compute_backend) > 0 && length(module.compute_frontend) > 0 ? {
      backend_api  = "<http://${module.compute_backend > [0].public_ip}:8000"
      backend_docs = "<http://${module.compute_backend > [0].public_ip}:8000/docs"
      frontend     = "<http://${module.compute_frontend > [0].public_ip}:5000"
    } : null
  )
}

output "ssh_commands" {
  description = "Comandos SSH para as VMs"
  value = var.enable_oke ? null : (
    length(module.compute_backend) > 0 && length(module.compute_frontend) > 0 ? {
      backend  = "ssh opc@${module.compute_backend[0].public_ip}"
      frontend = "ssh opc@${module.compute_frontend[0].public_ip}"
    } : null
  )
}

# === OUTPUTS OKE (quando enable_oke = true) ===
output "oke_cluster_id" {
  description = "ID do cluster OKE"
  value       = var.enable_oke ? (length(module.oke) > 0 ? module.oke[0].cluster_id : null) : null
}

output "oke_cluster_name" {
  description = "Nome do cluster OKE"
  value       = var.enable_oke ? (length(module.oke) > 0 ? module.oke[0].cluster_name : null) : null
}

output "oke_cluster_endpoint" {
  description = "Endpoint da API Kubernetes"
  value       = var.enable_oke ? (length(module.oke) > 0 ? module.oke[0].cluster_endpoint : null) : null
}

output "deployment_type" {
  description = "Tipo de deployment"
  value       = var.enable_oke ? "Oracle Kubernetes Engine (OKE)" : "Compute Instances"
}

output "oke_connection_commands" {
  description = "Comandos para conectar no cluster OKE"
  value = var.enable_oke ? (length(module.oke) > 0 ? {
    configure_kubectl = "oci ce cluster create-kubeconfig --cluster-id ${module.oke[0].cluster_id} --file ~/.kube/config --region ${var.region} --token-version 2.0.0"
    test_connection   = "kubectl get nodes"
  } : null) : null
}

output "estimated_monthly_cost" {
  description = "Custo mensal estimado"
  value       = var.enable_oke ? (var.cluster_type == "BASIC_CLUSTER" ? "USD $0.00 (Always Free)" : "USD $74.40 (Enhanced Cluster)") : "USD $0.00 (Always Free)"
}
