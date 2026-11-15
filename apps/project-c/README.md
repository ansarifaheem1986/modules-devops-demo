# Project C Terraform app

Project C manages one Azure resource group per environment by reusing the shared
`modules/azure-resource-group` module. Deployable environments are **dev**,
**stage**, and **prod**. QA is intentionally not configured.

## Files and responsibilities

| File | Purpose |
|---|---|
| `project-c.json` | Per-environment subscription, resource-group, location, and tag settings used by the deploy workflow. |
| `project-c.example.json` | Starter configuration with a placeholder subscription ID. |
| `infrastructure/tf/main.tf` | Calls the shared resource-group module for each distinct configured group name. |
| `infrastructure/tf/variables.tf` | Restricts environments to dev/stage/prod and validates Project C resource-group naming. |
| `infrastructure/tf/versions.tf` | Pins Terraform/AzureRM and configures the Azure Storage backend. |
| `infrastructure/tf/.terraform.lock.hcl` | Locks the selected AzureRM provider version and checksums. |
| `infrastructure/tf/outputs.tf` | Exposes the default resource-group name, ID, and location. |
| `infrastructure/tf/tests/resource-groups.tftest.hcl` | Tests the Project C resource-group integration with a mocked provider. |
| `.github/workflows/terraform-deploy.yml` | Plans, uploads/downloads a saved plan, applies it, or destroys Project C's selected environment. |
| `.github/workflows/terraform-ci.yml` | Formats, initializes, tests, and validates Project C. |

## Environment and state configuration

Every environment's `resource_groups.default` must have a matching key in
`resource_group_settings`, with `create: true` and an explicit location. The
deploy workflow fails early if that mapping is missing.

| Environment | Resource group | Terraform state key |
|---|---|---|
| dev | `IACC-ProjectC-dev-rg-01` | `project-c-dev.tfstate` |
| stage | `IACC-ProjectC-stage-rg-01` | `project-c-stage.tfstate` |
| prod | `IACC-ProjectC-prod-rg-01` | `project-c-prod.tfstate` |

The configuration carries forward the subscription ID and `eastus` region from
the Project B template. Confirm these are correct for Project C before running
a real plan. Never store service-principal credentials or storage keys in the
JSON files.

## Recorded implementation steps

1. **Created the app folder:** used the Project B Terraform layout under
   `apps/project-c/`.
2. **Renamed configuration files:** use `project-c.json` and
   `project-c.example.json`.
3. **Set Project C metadata and environments:** configured Project C tags and
   separate dev, stage, and prod groups. Each default group name exactly matches
   its creation-settings map key.
4. **Updated input validation:** only dev, stage, and prod are allowed; group
   names must follow `IACC-ProjectC-<environment>-rg-NN`.
5. **Reused the shared module:** the source remains
   `../../../../modules/azure-resource-group`, valid from this Terraform root.
6. **Connected deployment:** the workflow reads Project C's JSON, runs from
   Project C's Terraform root, uses `project-c-<environment>.tfstate`, and
   stores/downloads plan artifacts from Project C's directory.
7. **Added CI coverage:** formatting, initialization, a mocked Terraform test,
   and the app-validation matrix include Project C.
8. **Validated locally:** formatting, JSON checks, backend-free initialization,
   Terraform validation, and the mocked test are run as described below. A real
   cloud plan was not run as part of this implementation.

## Local checks

Run these commands from the repository root:

```bash
jq empty apps/project-c/project-c.json apps/project-c/project-c.example.json
terraform fmt -check -recursive apps/project-c/infrastructure/tf
terraform -chdir=apps/project-c/infrastructure/tf init -backend=false -input=false
terraform -chdir=apps/project-c/infrastructure/tf validate -no-color
terraform -chdir=apps/project-c/infrastructure/tf test -no-color
```

## Deployment

In the **Terraform Deploy** workflow, select dev, stage, or prod and run the
`plan` action first. Review the real plan carefully and record the Plan workflow
run ID shown in its summary. To apply that exact plan, rerun the workflow for
the same environment and commit with action `apply`, then provide the Plan run
ID. The plan artifact is checked against its environment and commit before it
is applied. Do not apply until the plan is reviewed and approved, especially
for prod. The Terraform test uses a mock provider and does not create Azure
resources.
