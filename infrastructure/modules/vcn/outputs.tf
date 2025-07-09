output "vcn_id" {
  description = "ID da VCN"
  value       = oci_core_vcn.this.id
}

output "public_subnet_id" {
  description = "ID da subnet pública"  
  value       = oci_core_subnet.public.id
}

# Outputs para OKE
output "oke_api_subnet_id" {
  description = "ID da subnet API OKE"
  value       = var.enable_oke ? oci_core_subnet.oke_api[0].id : null
}

output "oke_lb_subnet_id" {
  description = "ID da subnet Load Balancer OKE"
  value       = var.enable_oke ? oci_core_subnet.oke_lb[0].id : null
}

output "oke_workers_subnet_id" {
  description = "ID da subnet Workers OKE"
  value       = var.enable_oke ? oci_core_subnet.oke_workers[0].id : null
}
