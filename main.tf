locals {
	project_config   = jsondecode(var.project_config)
	project_accounts = { for account in local.project_config.accounts : account.environment => account }
}
