{% materialization load, adapter='bigquery', supported_languages=['sql'] -%}

  {%- set language = model['language'] -%}
  {%- set identifier = model['alias'] -%}
  {%- set old_relation = adapter.get_relation(database=database, schema=schema, identifier=identifier) -%}
  {%- set exists_not_as_table = (old_relation is not none and not old_relation.is_table) -%}
  {%- set target_relation = api.Relation.create(database=database, schema=schema, identifier=identifier, type='table') -%}

  -- grab current tables grants config for comparision later on
  {%- set grant_config = config.get('grants') -%}

  {{ run_hooks(pre_hooks) }}

  {#
      We only need to drop this thing if it is not a table.
      If it _is_ already a table, then we can overwrite it without downtime
      Unlike table -> view, no need for `--full-refresh`: dropping a view is no big deal
  #}
  {%- if exists_not_as_table -%}
      {{ adapter.drop_relation(old_relation) }}
  {%- endif -%}

  -- build model
  {%- set raw_partition_by = config.get('partition_by', none) -%}
  {%- set partition_config = adapter.parse_partition_by(raw_partition_by) -%}

  {%- set raw_cluster_by = config.get('cluster_by', none) -%}
  {% if not adapter.is_replaceable(old_relation, partition_by, cluster_by) %}
    {% do log("Hard refreshing " ~ old_relation ~ " because it is not replaceable") %}
    {% do adapter.drop_relation(old_relation) %}
  {% endif %}

  {%- call statement('main', language=language) -%}
    {{ sql_header if sql_header is not none }}

    load data overwrite {{ target_relation }}

    {%- if config.get('contract').enforced -%}
      {{ get_table_columns_and_constraints() }}
    {% endif %}

    {{ partition_by(partition_config) }}
    {{ cluster_by(raw_cluster_by) }}
    {{ bigquery_table_options(config, model, False) }}

    from files (
      {{ dbt_bigquery_extras.build_load_options(config.get('load_options')) }}
    )

    {%- if 'connection_name' in config %}
    with connection "{{ config.get('connection_name') }}"
    {%- endif %}
  {%- endcall -%}

  {{ run_hooks(post_hooks) }}

  {% set should_revoke = should_revoke(old_relation, full_refresh_mode=True) %}
  {% do apply_grants(target_relation, grant_config, should_revoke) %}

  {% do persist_docs(target_relation, model) %}

  {{ return({'relations': [target_relation]}) }}

{% endmaterialization %}
