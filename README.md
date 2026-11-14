# Azure resource group

Resolves one existing group by default. Optional `creation` creates a group owned
by exactly one Terraform state, with explicit location, tags and `prevent_destroy`.
Compatible with Terraform >= 1.13.5. The module accepts AzureRM `>= 2.74.0, < 6.0`;
each app root controls its version: original apps retain 2.74.0 and devops-demo
uses 5.13.0. Broadening this child constraint does not upgrade existing root pins.
Tests require Terraform >= 1.7 for provider mocking.

| Input | Type | Default |
|---|---|---|
| `name` | string | required |
| `creation` | object with `location` string and `tags` map(string), or null | null (lookup only) |

Outputs: `id`, `name`, `location`. Consumers must use the resolved output name to
preserve creation dependencies.

App roots deduplicate `pep_defaults.resource_groups` names and use
`resource_group_settings` to opt into creation. See the [root guide](../../README.md)
for configuration, ownership/import procedures, state migration and rollback.
Lookup mode never adopts or retags a shared group. Removing the module from
configuration removes its lifecycle guard; plan review remains essential.

## Step-by-step module call

1. Add the module source relative to the app root.
2. Supply the exact group name. Omit `creation` (or use null) for an existing group.
3. For a new, single-state-owned group, supply an explicit region and tags.
4. Pass `module.resource_group.name` and `.location` to downstream module inputs,
   rather than repeating raw strings, so Terraform preserves creation ordering.

```hcl
module "resource_group" {
  source = "../../../../modules/azure-resource-group"
  name   = var.resource_group_name
  creation = {
    location = var.location
    tags     = var.tags
  }
}
```

Declare `resource_group_name`, `location` and `tags` in the calling root.
The path above is for `apps/<app>/infrastructure/tf`. For an existing group,
replace the `creation` object with `null`.

The `devops-demo` app uses `for_each` over distinct group names, preserving its
EDAP aliases. It currently manages resource groups only; add a separately
validated AKS module integration before configuring AKS deployment inputs.

For repository-wide design and new module development, see the
[detailed architecture](../../docs/edapautomation-architecture.md) and
[step-by-step module authoring guide](../../docs/creating-terraform-modules.md).
