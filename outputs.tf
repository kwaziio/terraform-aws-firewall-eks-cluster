########################################################################
# Provides Information About Firewall Resources Created by this Module #
########################################################################

output "arn" {
  description = "Amazon Resource Name (ARN) of the VPC Security Group"
  value       = aws_security_group.eks_cluster.arn
}

output "egress_rules" {
  description = "List of Egress Rule IDs Associated w/ this Firewall (by this Module)"
  
  value = concat([
    aws_vpc_security_group_egress_rule.eks_cluster_all_ipv4.*.id,
    aws_vpc_security_group_egress_rule.eks_cluster_all_ipv6.*.id,
  ])
}

output "id" {
  description = "Unique ID Assigned to the VPC Security Group"
  value       = aws_security_group.eks_cluster.id
}

output "ingress_rules" {
  description = "List of Ingress Rule IDs Associated w/ this Firewall (by this Module)"
  
  value = concat([
    [aws_vpc_security_group_ingress_rule.eks_cluster_all_self.id],
  ])
}

output "network_id" {
  description = "VPC ID of the VPC Associated w/ this VPC Security Group"
  value       = aws_security_group.eks_cluster.vpc_id
}
