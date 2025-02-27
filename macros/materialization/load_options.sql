{%- macro build_load_options(load_options) -%}

{%- if 'allow_jagged_rows' in load_options %}
  allow_jagged_rows = {{ load_options['allow_jagged_rows'] }},
{%- endif %}
{%- if 'allow_quoted_newlines' in load_options %}
  allow_quoted_newlines = {{ load_options['allow_quoted_newlines'] }},
{%- endif %}
{%- if 'column_name_character_map' in load_options %}
  column_name_character_map = "{{ load_options['column_name_character_map'] }}",
{%- endif %}
{%- if 'compression' in load_options %}
  compression = "{{ load_options['compression'] }}",
{%- endif %}
{%- if 'decimal_target_types' in load_options %}
  decimal_target_types = [
    {%- for target_type in load_options['decimal_target_types'] %}
      "{{ target_type }}"
      {%- if not loop.last -%},{%- endif %}
    {%- endfor %}
  ],
{%- endif %}
{%- if 'enable_list_inference' in load_options %}
  enable_list_inference = {{ load_options['enable_list_inference'] }},
{%- endif %}
{%- if 'enable_logical_types' in load_options %}
  enable_logical_types = {{ load_options['enable_logical_types'] }},
{%- endif %}
{%- if 'encoding' in load_options %}
  encoding = "{{ load_options['encoding'] }}",
{%- endif %}
{%- if 'enum_as_string' in load_options %}
  enum_as_string = {{ load_options['enum_as_string'] }},
{%- endif %}
{%- if 'field_delimiter' in load_options %}
  field_delimiter = "{{ load_options['field_delimiter'] }}",
{%- endif %}
{%- if 'ignore_unknown_values' in load_options %}
  ignore_unknown_values = "{{ load_options['ignore_unknown_values'] }}",
{%- endif %}
{%- if 'json_extension' in load_options %}
  json_extension = "{{ load_options['json_extension'] }}",
{%- endif %}
{%- if 'max_bad_records' in load_options %}
  max_bad_records = {{ load_options['max_bad_records'] }},
{%- endif %}
{%- if 'null_marker' in load_options %}
  null_marker = "{{ load_options['null_marker'] }}",
{%- endif %}
{%- if 'preserve_ascii_control_characters' in load_options %}
  preserve_ascii_control_characters = {{ load_options['preserve_ascii_control_characters'] }},
{%- endif %}
{%- if 'quote' in load_options %}
  {% if load_options['quote'] == '"' %}
    quote = '"',
  {% else %}
    quote = "{{ load_options['quote'] }}",
  {% endif %}
{%- endif %}
{%- if 'skip_leading_rows' in load_options -%}
  skip_leading_rows = {{ load_options['skip_leading_rows'] }},
{%- endif %}

  uris = [
    {%- for uri in load_options['uris'] %}
      "{{ uri }}"
      {%- if not loop.last -%},{%- endif %}
    {%- endfor %}
  ],
  format = "{{ load_options['format'] }}"

{%- endmacro %}
