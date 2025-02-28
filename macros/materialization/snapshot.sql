{% materialization snapshot_table, adapter='bigquery', supported_languages=['sql'] -%}
  {%- set language = model['language'] -%}
  {%- set identifier = model['alias'] -%}
  {%- set old_relation = adapter.get_relation(database=database, schema=schema, identifier=identifier) -%}
  {%- set target_relation = api.Relation.create(database=database, schema=schema, identifier=identifier, type='table') -%}

  -- grab current tables grants config for comparision later on
  {%- set grant_config = config.get('grants') -%}

  {{ run_hooks(pre_hooks) }}

  {% if old_relation is not none %}
  {{ adapter.drop_relation(old_relation) }}
  {% endif %}

  {%- call statement('main', language=language) -%}
    create snapshot table {{ target_relation }}
    clone {{ config.get('source_table') }}

    {%- set system_time = config.get('system_time') %}
    {% if system_time is not none %}
    for system_time as of {{ system_time }}
    {% endif %}

    {{ bigquery_table_options(config, model, False) }}
  {%- endcall -%}

  {{ run_hooks(post_hooks) }}

  {% set should_revoke = should_revoke(old_relation, full_refresh_mode=True) %}
  {% do apply_grants(target_relation, grant_config, should_revoke) %}

  {% do persist_docs(target_relation, model) %}

  {{ return({'relations': [target_relation]}) }}

{% endmaterialization %}
