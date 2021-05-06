variable "kc_realm" {
	description = "KeyCloak realm where terraform client has been created and where users/groups to be created/manipulated exist."
	type        = string
}

variable "kc_base_url" {
	description = "Base URL of KeyCloak instance to interact with."
	type = string
}

variable aws_saml_idp_name {
	type = string
	description = "Name for Keycloak IDP that will be created in AWS account for use by client VPN authentication elements."
	default     = "BCGovKeyCloak-ClientVPN"
}

variable vpn_users_group_name {
	type = string
	description = "Name to use for VPN access group and corresponding to role in KeyCloak."
}

variable "environment" {
	type = string
	description = "The name of the environment (aka OU within SEA) that this configuration runs in.  Used to discover network resrouces based on naming convention."
}

variable "client_cidr_block" {
	type = string
	default = "192.168.0.0/22"
	description = "CIDR block indicating IP range from which VPN client will assign IPs to VPN users."
}

variable "client_vpn_endpoint_name" {
	type = string
	description = "Name for the Client VPN endpoint."
}

variable "ca_chain_pem" {
	type = string
	description = "PEM-formatted Certificate Authority certificate chain."
}

variable "server_cert_private_key_pem" {
	type = string
	description = "PEM-formatted private key for server certificate."
	sensitive = true
}

variable "server_cert_body_pem" {
	type = string
	description = "PEM-formatted body of server certificate."
}


