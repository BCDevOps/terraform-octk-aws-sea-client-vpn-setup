variable "kc_realm" {
	description = "KeyCloak realm where terraform client has been created and where users/groups to be created/manipulated exist."
	type        = string
}

variable "kc_base_url" {
	description = "Base URL of KeyCloak instance to interact with."
	type = string
}

variable "project_config" {
	description = "project.json config."
}


