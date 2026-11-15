# Azure VNet subnet

Resolves an existing VNet and subnet by default. Set
`virtual_network_creation` to create the parent VNet and `creation` to create a
subnet in it. The subnet depends on the managed VNet, so Terraform creates the
VNet first. Managed subnets have `prevent_destroy` enabled so Terraform refuses
to destroy them while this lifecycle guard remains in the configuration.

## Inputs

| Input | Type | Default |
|---|---|---|
| `name` | string | required |
| `resource_group_name` | string | required |
| `virtual_network_name` | string | required |
| `virtual_network_creation` | object with `location`, `address_space` list(string), and `tags` map(string), or null | null (lookup only) |
| `creation` | object with `address_prefixes` list(string), or null | null (lookup only) |

Creating a VNet requires a location and one or more non-empty address spaces.
Creating a subnet requires one or more non-empty address prefixes. The resource
group must already exist. When `virtual_network_creation` is omitted, the
module looks up the existing VNet by name and resource group during planning.

## Outputs

| Output | Description |
|---|---|
| `id` | Resolved subnet resource ID. |
| `name` | Resolved subnet name; use it in dependent resources to preserve Terraform ordering. |
| `resource_group_name` | Resource group containing the subnet. |
| `address_prefixes` | Prefixes assigned to the subnet. |
| `virtual_network_id` | ID of the existing or managed parent VNet. |
| `virtual_network_name` | Name of the existing or managed parent VNet. |
| `virtual_network_address_space` | Address spaces configured on the parent VNet. |

## Example: create a VNet and subnet

```hcl
module "app_subnet" {
  source = "../../../../modules/azure-vnet-subnet"

  name                 = "project-c-dev-subnet-01"
  resource_group_name  = module.resource_group.name
  virtual_network_name = "project-c-dev-vnet-01"
  virtual_network_creation = {
    location      = module.resource_group.location
    address_space = ["10.0.0.0/8"]
    tags          = {}
  }
  creation = {
    address_prefixes = ["10.0.0.0/16"]
  }
}
```

For lookup-only mode, omit `virtual_network_creation` and `creation`, or set
them to `null`. Existing resources are looked up and never adopted or changed.
If identical address spaces are used in separate VNets, keep those VNets
isolated; overlapping ranges prevent normal peering and routing between them.

## Validation

From the repository root:

```bash
terraform fmt -check -recursive modules/azure-vnet-subnet
terraform -chdir=modules/azure-vnet-subnet init -backend=false -input=false
terraform -chdir=modules/azure-vnet-subnet validate -no-color
terraform -chdir=modules/azure-vnet-subnet test -no-color
```
