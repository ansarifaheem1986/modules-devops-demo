# Azure VNet subnet

Resolves an existing subnet by default. Set `creation` to explicitly create a
subnet owned by one Terraform state. Managed subnets have `prevent_destroy`
enabled so Terraform refuses to destroy them while this lifecycle guard remains
in the configuration.

## Inputs

| Input | Type | Default |
|---|---|---|
| `name` | string | required |
| `resource_group_name` | string | required |
| `virtual_network_name` | string | required |
| `creation` | object with `address_prefixes` list(string), or null | null (lookup only) |

Creation requires one or more non-empty address prefixes. The parent resource
group and virtual network must already exist; this module does not create or
modify either parent resource. The module resolves the virtual network by name
and resource group during planning before it reads or creates a subnet. A
missing VNet therefore fails during planning; create or correct the VNet in the
same resource group before applying.

## Outputs

| Output | Description |
|---|---|
| `id` | Resolved subnet resource ID. |
| `name` | Resolved subnet name; use it in dependent resources to preserve Terraform ordering. |
| `resource_group_name` | Resource group containing the subnet. |
| `address_prefixes` | Prefixes assigned to the subnet. |

## Example: create a subnet

```hcl
module "app_subnet" {
  source = "../../../../modules/azure-vnet-subnet"

  name                 = "project-c-dev-subnet-01"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  creation = {
    address_prefixes = ["10.20.1.0/24"]
  }
}
```

For lookup-only mode, use the same subnet, resource-group, and virtual-network
names but omit `creation` or set it to `null`. Lookup mode never adopts or
changes the subnet.

## Validation

From the repository root:

```bash
terraform fmt -check -recursive modules/azure-vnet-subnet
terraform -chdir=modules/azure-vnet-subnet init -backend=false -input=false
terraform -chdir=modules/azure-vnet-subnet validate -no-color
terraform -chdir=modules/azure-vnet-subnet test -no-color
```
