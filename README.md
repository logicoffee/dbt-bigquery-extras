# dbt-bigquery-extras

## custom materialization

### load

`LOAD DATA` statement as a model. Model body isn't needed.

```
{{
    config(
        materialized = 'load'
        load_options = {
            'uris': [
                'gs://bucket/dir1/*.parquet',
                'gs://bucket/dir2/*.parquet'
            ],
            'format': 'parquet',
        },
    )
}}
```

### table_snapshot

`CREATE SNAPSHOT TABLE` statement as a model. Model body isn't needed.

The snapshot materialization is already implemented in [here](https://github.com/dbt-labs/dbt-adapters/blob/5de867965ab7bf7609caa624f98a31203998d1d1/dbt-adapters/src/dbt/include/global_project/macros/materializations/snapshots/snapshot.sql). It's used in the `dbt snapshot` command. To prevent duplication, I named it snapshot_table.

```
{{
    config(
        materialized = 'table_snapshot',
        source_table = 'my_schema.source_table'
    )
}}
```
