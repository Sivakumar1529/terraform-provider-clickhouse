# Development

Quick start guide for contributors.

## Preparation

Create a new file called .terraformrc in your home directory (~), then add the dev_overrides block below. Change the `<PATH>` to the full path of the `tmp` directory in this repo. For example:

```t
provider_installation {

  dev_overrides {
      "ClickHouse/clickhouse" = "<PATH example /home/user/workdir/terraform-provider-clickhouse/tmp>"
  }

  # For all other providers, install them directly from their origin provider
  # registries as normal. If you omit this, Terraform will _only_ use
  # the dev_overrides block, and so no other providers will be available.
  direct {}
}
```

Ensure you have [`air`](https://github.com/air-verse/air) or install it with:

```bash
go install github.com/air-verse/air@latest
```

Run `air` to automatically build the plugin binary every time you make changes to the code:

```bash
$ air
```

You can now run `terraform` and you'll be using the locally built binary. Please note that the `dev_overrides` make it so that you have to skip `terraform init`).
For example, go to the `examples/full/basic/aws` directory and :

```bash
terraform apply -var-file="variables.tfvars"
╷
│ Warning: Provider development overrides are in effect
│
│ The following provider development overrides are set in the CLI configuration:
│  - ClickHouse/clickhouse in /home/user/workdir/terraform-provider-clickhouse/tmp
│
│ The behavior may therefore not match any released version of the provider and applying changes may
│ cause the state to become incompatible with published releases.
╵

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # clickhouse_service.service will be created
  + resource "clickhouse_service" "service" {
      ...
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```


Make sure to change the organization id, token key, and token secret to valid values.

## Git hooks

We suggest to add git hooks to your local repo, by running:

```bash
make enable_git_hooks
```

Code will be formatted and docs generated before each commit.

## Docs

If you made any changes to the provider's interface, please run `make docs` to update documentation as well.

NOTE: this is done automatically by git hooks.

## Release

NOTE: Release process is only possible for ClickHouse employees.

To make a new public release:

- ensure the `main` branch contains all the changes you want to release
- Run the [`Release`](https://github.com/smugantechamb/terraform-provider-clickhouse/actions/workflows/release.yaml) workflow against the main branch (enter the desired release version in semver format without leading `v`, example: "1.2.3")
- Release will be automatically created if end to end tests will be successful.
