#######################################
# Locally-Available Dynamic Variables #
#######################################

locals {
  sg_prefix = coalesce(var.firewall_prefix, try("${data.aws_vpc.selected.tags["Name"]}-", ""))
}

#########################################################
# Retrieves Information About the Targeted VPC Instance #
#########################################################

data "aws_vpc" "selected" {
  id = var.network_id
}

##########################################################
# Creates AWS Virtual Private Cloud (VPC) Security Group #
##########################################################

resource "aws_security_group" "eks_cluster" {
  description = "Manages All Firewall Rules for EKS Cluster Control Plane"
  name        = "${local.sg_prefix}${var.firewall_name}"
  vpc_id      = var.network_id

  tags = merge({
    Application = "kubernetes"
    Component   = "cluster"
    Name        = "${local.sg_prefix}${var.firewall_name}"
  }, var.resource_tags)
}

###################################################################
# Creates Default VPC Security Group Rule for IPv4 Egress Traffic #
###################################################################

resource "aws_vpc_security_group_egress_rule" "eks_cluster_all_ipv4" {
  cidr_ipv4   = var.firewall_allowed_ipv4_egress_cidrs[count.index]
  count       = length(var.firewall_allowed_ipv4_egress_cidrs)
  description = "Allows Egress via All Ports and Protocols Based on Destination CIDR"
  ip_protocol = "-1"
  security_group_id = aws_security_group.eks_cluster.id

  tags = {
    CIDR = var.firewall_allowed_ipv4_egress_cidrs[count.index]
    Name = "${aws_security_group.eks_cluster.name}-all-all-ipv4"
  }
}

###################################################################
# Creates Default VPC Security Group Rule for IPv6 Egress Traffic #
###################################################################

resource "aws_vpc_security_group_egress_rule" "eks_cluster_all_ipv6" {
  cidr_ipv6   = var.firewall_allowed_ipv6_egress_cidrs[count.index]
  count       = length(var.firewall_allowed_ipv6_egress_cidrs)
  description = "Allows Egress via All Ports and Protocols Based on Destination CIDR"
  ip_protocol = "-1"
  security_group_id = aws_security_group.eks_cluster.id

  tags = {
    CIDR = var.firewall_allowed_ipv6_egress_cidrs[count.index]
    Name = "${aws_security_group.eks_cluster.name}-all-all-ipv6"
  }
}

###############################################################################
# Creates Required VPC Security Group Rule for EKS Clusters (Ingress to Self) #
###############################################################################

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_all_self" {
  description                  = "Allows All Traffic via All Protocols to Self"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_cluster.id
  security_group_id            = aws_security_group.eks_cluster.id

  tags = {
    Name = "${aws_security_group.eks_cluster.name}-all-all-self"
  }
}
