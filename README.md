# dbt-bigquery-extras

## custom materialization

### load

LOAD DATA statement as a model. Model body isn't needed.

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
