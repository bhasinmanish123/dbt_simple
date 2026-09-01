{% macro generate_schema_name(custom_schema_name, node) -%}

    {#
        Generates schema name based on environment:

        LOCAL DEV (target = dev):
            Uses DBT_USER env var as prefix → DEV_MANISH, DEV_JOHN etc.
            If DBT_USER not set → falls back to default schema from profiles.yml

        CI (target = ci):
            Uses fixed schema CI (shared, for PR validation)

        PROD (target = prod):
            Uses fixed schema PROD (no prefix — production is shared)
    #}

    {%- set default_schema = target.schema -%}

    {%- if target.name == 'dev' -%}

        {#- Get username from env var DBT_USER (set in local shell or CI) -#}
        {%- set dbt_user = env_var('DBT_USER', '') -%}

        {%- if dbt_user != '' -%}
            {#- Personal dev schema: DEV_MANISH, DEV_JOHN etc. -#}
            DEV_{{ dbt_user | upper | replace(' ', '_') }}
        {%- else -%}
            {#- Fallback to whatever schema is in profiles.yml -#}
            {{ default_schema }}
        {%- endif -%}

    {%- elif target.name == 'ci' -%}
        {#- CI is shared — just use CI schema from profiles.yml -#}
        {{ default_schema }}

    {%- elif target.name == 'prod' -%}
        {#- PROD is shared — just use PROD schema from profiles.yml -#}
        {{ default_schema }}

    {%- else -%}
        {#- Any other target — use default -#}
        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}
