# Project B Terraform app

This app is a separate Terraform root that reuses the shared
`modules/azure-resource-group` module. Its deployment workflow and state keys
are independent from `devops-demo` and `project-new`.

## Files and responsibilities

| File | Purpose |
|---|---|
| `project-b.json` | Real per-environment subscription, resource-group, location, and tag settings used by the deploy workflow. |
| `project-b.example.json` | Safe starter configuration with a placeholder subscription ID. |
| `infrastructure/tf/main.tf` | Calls the shared resource-group module once for each distinct configured group name. |
| `infrastructure/tf/variables.tf` | Validates supported environments and Project B resource-group naming. |
| `infrastructure/tf/versions.tf` | Pins Terraform/AzureRM and configures the Azure Storage backend. |
| `infrastructure/tf/outputs.tf` | Exposes the default resource-group name, ID, and location. |
| `infrastructure/tf/tests/resource-groups.tftest.hcl` | Tests the Project B default resource-group module integration using a mocked provider. |
| `.github/workflows/terraform-deploy.yml` | Plans, uploads, downloads, applies, or destroys Project B's environment-specific Terraform configuration. |

## Environment configuration

Each environment in `project-b.json` must have a `resource_groups.default`
name and a matching key in `resource_group_settings`. Set `create` to `true`
with an explicit location to let this Terraform state own and create that group.
The deployment workflow rejects a missing or non-creating default group.

| Environment | Resource group | State key |
|---|---|---|
| dev | `IACC-ProjectB-dev-rg-01` | `project-b-dev.tfstate` |
| qa | `IACC-ProjectB-qa-rg-01` | `project-b-qa.tfstate` |
| stage | `IACC-ProjectB-stage-rg-01` | `project-b-stage.tfstate` |
| prod | `IACC-ProjectB-prod-rg-01` | `project-b-prod.tfstate` |

The current configuration reuses the subscription ID from `project-new`. Verify
that it is the intended subscription before deploying. Do not put credentials
or access keys in either JSON file.

## How this app was created

1. **Copied the app skeleton:** copied `apps/project-new/` to `apps/project-b/`
   on the `project-b` branch, without merging the source branch's unrelated commits.
2. **Renamed the JSON configuration:** renamed the files to `project-b.json` and
   `project-b.example.json`.
3. **Updated app and environment metadata:** changed the app prefix, service name,
   project code, and application tag to Project B. Assigned a distinct resource
   group for dev, qa, stage, and prod, with each `resource_groups.default`
   exactly matching its `resource_group_settings` key. The subscription ID and
   `eastus` location were carried over from the source configuration and should
   be confirmed for the target project.
4. **Updated validation:** changed the validation message and naming pattern to
   require `IACC-ProjectB-<environment>-rg-NN`.
5. **Reused the shared module:** kept the module source at
   `../../../../modules/azure-resource-group`, which is correct from this app's
   Terraform root.
6. **Connected deployment to Project B:** pointed the workflow at
   `apps/project-b`, read `project-b.json`, used `project-b-<environment>.tfstate`,
   and updated plan artifact paths. The plan/apply flow uses the Plan workflow
   run ID to retrieve and verify the saved plan.
7. **Added CI coverage:** added Project B formatting, initialization, a mocked
   resource-group integration test, and the Terraform validation matrix entry.
8. **Validated the change:** run the commands below. Inspect and approve the
   real Terraform plan before applying; validation and mock tests do not contact
   Azure or change cloud resources.

## Manual validation and deployment

Run from the repository root:

```bash
jq empty apps/project-b/project-b.json apps/project-b/project-b.example.json
terraform fmt -check -recursive apps/project-b/infrastructure/tf
terraform -chdir=apps/project-b/infrastructure/tf init -backend=false -input=false
terraform -chdir=apps/project-b/infrastructure/tf validate -no-color
terraform -chdir=apps/project-b/infrastructure/tf test -no-color
```

For deployment, select an environment and `plan` in the Terraform Deploy
workflow. Review the plan output and note the workflow run ID from the run
summary. To apply, run the workflow again with the same environment and commit,
select `apply`, and provide that Plan run ID. The workflow downloads the saved
plan and rejects an environment or commit mismatch. Review the plan carefully
before approving an apply, especially before using `prod`.
