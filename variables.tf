###########################################################################
# AWS Virtual Private Cloud (VPC) Security Group [Firewall] Configuration #
###########################################################################

variable "firewall_allowed_ipv4_egress_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "List of IPv4 CIDRs to Permit All Egress Traffic via All Protocols and Ports"
  type        = list(string)
}

variable "firewall_allowed_ipv6_egress_cidrs" {
  default     = ["::/0"]
  description = "List of IPv6 CIDRs to Permit All Egress Traffic via All Protocols and Ports"
  type        = list(string)
}

variable "firewall_name" {
  default     = "eks-cluster"
  description = "Name Tag and Value to Assign to VPC Security Group"
  type        = string
}

variable "firewall_prefix" {
  default     = null
  description = "Prefix to Append to VPC Security Group Name (Overrides VPC Name)"
  type        = string
}

###########################################################
# AWS Virtual Private Cloud (VPC) [Network] Configuration #
###########################################################

variable "network_id" {
  description = "VPC ID to Associated w/ Created VPC Security Group"
  type        = string
}

##################################
# Created Resource Configuration #
##################################

variable "resource_tags" {
  default     = {}
  description = "Map of AWS Resource Tags to Assign to All Created Resources"
  type        = map(string)
}
