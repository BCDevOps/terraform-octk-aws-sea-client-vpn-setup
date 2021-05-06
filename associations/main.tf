
variable "environment" {
	type = string
	description = "The name of the environment (aka OU within SEA) that this configuration runs in.  Used to discover network resrouces based on naming convention."
}

module "network-info" {
	source = "git::git@github.com:BCDevOps/terraform-octk-aws-sea-network-info?ref=v0.0.2"

	environment = var.environment
}


resource "aws_ec2_client_vpn_network_association" "associations" {
	for_each = toset([for subnet in module.network-info.aws_subnet.data : subnet.id])
	client_vpn_endpoint_id = <ID OF ENDPOINT>
	subnet_id = each.value
	security_groups = [
		module.network-info.aws_security_groups.app.id]
}
