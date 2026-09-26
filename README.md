# Terraform Provider for ClickHouse Cloud 🌩️

![GitHub Release](https://img.shields.io/github/release/Sivakumar1529/terraform-provider-clickhouse.svg) ![GitHub Issues](https://img.shields.io/github/issues/Sivakumar1529/terraform-provider-clickhouse.svg) ![GitHub Pull Requests](https://img.shields.io/github/issues-pr/Sivakumar1529/terraform-provider-clickhouse.svg)

Welcome to the Terraform Provider for ClickHouse Cloud! This repository provides a Terraform provider that allows you to manage ClickHouse Cloud resources with ease. Whether you're setting up databases, tables, or other resources, this provider simplifies the process.

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Resources](#resources)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Introduction

ClickHouse is a fast open-source columnar database management system that is designed for real-time analytics. With the Terraform provider for ClickHouse Cloud, you can easily manage your ClickHouse resources through code. This enables you to maintain consistency and version control over your infrastructure.

## Getting Started

To get started with the Terraform provider for ClickHouse, you will need to have Terraform installed on your machine. You can download Terraform from the [official website](https://www.terraform.io/downloads.html).

### Prerequisites

- Terraform 0.12 or later
- ClickHouse Cloud account

## Installation

You can download the latest release of the Terraform provider from the [Releases section](https://github.com/Sivakumar1529/terraform-provider-clickhouse/releases). After downloading, follow these steps:

1. Extract the downloaded file.
2. Move the provider binary to your Terraform plugins directory, usually located at `~/.terraform.d/plugins/`.
3. Ensure the binary has execute permissions.

## Usage

Here’s a simple example of how to use the Terraform provider for ClickHouse:

```hcl
provider "clickhouse" {
  endpoint = "https://your-clickhouse-cloud-endpoint"
  user     = "your-username"
  password = "your-password"
}

resource "clickhouse_database" "example" {
  name = "example_db"
}

resource "clickhouse_table" "example" {
  database = clickhouse_database.example.name
  name     = "example_table"
  
  column {
    name = "id"
    type = "UInt32"
  }
  
  column {
    name = "name"
    type = "String"
  }
}
```

This configuration creates a new database and a table in ClickHouse Cloud. You can customize the resource definitions according to your needs.

## Resources

The provider supports various resources, including:

- `clickhouse_database`
- `clickhouse_table`
- `clickhouse_user`
- `clickhouse_cluster`

For a complete list of supported resources and their attributes, please refer to the documentation in this repository.

## Contributing

We welcome contributions to improve the Terraform provider for ClickHouse Cloud. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your branch to your fork.
5. Open a pull request to the main repository.

Please ensure that your code follows the existing style and includes tests where applicable.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

For questions or support, please reach out via the Issues section of this repository. We appreciate your feedback and contributions.

## Releases

To check for the latest updates, visit the [Releases section](https://github.com/Sivakumar1529/terraform-provider-clickhouse/releases). Download the latest version and execute it to start managing your ClickHouse resources.

## Conclusion

The Terraform Provider for ClickHouse Cloud offers a straightforward way to manage your ClickHouse resources. By using Terraform, you can achieve better infrastructure management, version control, and automation. We encourage you to explore the capabilities of this provider and contribute to its development.

Happy coding! 🚀