terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~>4.0.0"
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