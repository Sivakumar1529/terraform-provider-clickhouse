Use the *clickhouse_database* resource to create a database in a ClickHouse cloud *service*.

Attention: in order to use the `clickhouse_database` resource you need to set the `query_api_endpoint` attribute in the `clickhouse_service`.
Please check [full example](https://github.com/smugantechamb/terraform-provider-clickhouse/blob/main/examples/database/main.tf).

Known limitations:

- Changing the comment on a `database` resource is unsupported and will cause the database to be destroyed and recreated. WARNING: you will lose any content of the database if you do so!

