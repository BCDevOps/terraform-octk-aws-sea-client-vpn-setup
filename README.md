
# License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](./LICENSE)

# OCTK Client VPN

This repo provides a module to automate enablement of AWS' Client VPN service within an account in an SEA environment, including integration with a KeyCloak SSO service.

When applied, the module will create a SAML identity provider, VPN endpoint, and default network association and auth rule.  

## Project Status
- [x] Development
- [ ] Production/Maintenance

## Getting Started

This has been used as an overlay "layer", but should also be usable as a standalone module, provided that required variables are provided. 

> Note: the `main.tf` in the root folder is an artifact of how this repo is consumed by the overlay machinery in order to apply resources to multiple accounts "at once" and would not be used if applying to a single account.  When applying to a single account, the `module` folder should be used directly and the root fodler contents can be ignored.

### Usage

This module should not be used as a root module unless you are forking/copying the repo, as an aws provider is required and is expected to defined/injected by your root/calling module.

```hcl
provider "aws" {
	region = "..."
}

module "client-vpn" {
	source = "path to this repo"

	client_vpn_endpoint_name        = "some name"
	vpn_users_group_name = "another name"
	environment = "<environment name>" # used by network info module to discover network elements in account 
	kc_base_url = "keycloak url"
	kc_realm = "keycloak realm"
	server_cert_private_key_pem = "<contents of private key pem>"
	server_cert_body_pem = "<contents of cert body pem>"
	ca_chain_pem =  "<content of cert chain pem>"
}
```

## Getting Help or Reporting an Issue
To report bugs/issues/feature requests, please file an [issue](../../issues).


## How to Contribute
<!--- Example below, modify accordingly --->
If you would like to contribute, please see our [CONTRIBUTING](./CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of Conduct](./CODE_OF_CONDUCT.md). 
By participating in this project you agree to abide by its terms.


## License

    Copyright 2021 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
