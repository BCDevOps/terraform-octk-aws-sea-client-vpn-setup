terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~>3.36.0"
		}
		external = {
			source = "hashicorp/external"
			version = "~>2.0.0"
		}
		keycloak = {
			source = "mrparkers/keycloak"
			version = "~>3.0.0"
		}
	}
}

// more-or-less drop-in replacement for (broken-in-0.14) http provider
data "external" "saml_idp_descriptor" {
	program = [
		"${path.module}/bin/http_get.sh"]

	query = {
		url = "${var.kc_base_url}/auth/realms/${var.kc_realm}/protocol/saml/descriptor"
	}
}

resource "aws_iam_saml_provider" "client_vpn_saml_provider" {
	name = var.aws_saml_idp_name
	// string replacement hackery because KC metadata doc only show default realm-level WantAuthn... value rather than based on client value.
	saml_metadata_document = replace(tostring(data.external.saml_idp_descriptor.result.data), "WantAuthnRequestsSigned=\"true\"", "WantAuthnRequestsSigned=\"false\"")
}

resource "aws_acm_certificate" "server_cert" {
	private_key = var.server_cert_private_key_pem
	certificate_body = var.server_cert_body_pem
	certificate_chain = var.ca_chain_pem
}

resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
	description = var.client_vpn_endpoint_name
	server_certificate_arn = aws_acm_certificate.server_cert.arn
	client_cidr_block = var.client_cidr_block

	split_tunnel = true

	authentication_options {
		type = "federated-authentication"
		saml_provider_arn = aws_iam_saml_provider.client_vpn_saml_provider.arn
	}
	connection_log_options {
		enabled = false
	}
}

module "network-info" {
	source = "git::git@github.com:BCDevOps/terraform-octk-aws-sea-network-info?ref=v0.0.2"

	environment = var.environment
}


// todo network association and auth rule should be refactored so they can be created based on project configuration and/or not creat at all but overlay, and delgated to tenant teams

resource "aws_ec2_client_vpn_network_association" "associations" {
	for_each = toset([for subnet in module.network-info.aws_subnet.data : subnet.id])
	client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
	subnet_id = each.value
	security_groups = [
		module.network-info.aws_security_groups.app.id]
}

resource "aws_ec2_client_vpn_authorization_rule" "auth_data_subnets" {
	for_each = toset([for subnet in module.network-info.aws_subnet.data : subnet.cidr_block])
	client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
	target_network_cidr = each.value
	//	todo convention for creating roles in KC to allow for different access level
	access_group_id = var.vpn_users_group_name
}

