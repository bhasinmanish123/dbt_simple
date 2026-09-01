{% macro generate_schema_name(custom_schema_name, node) -%}

    {#
        Generates schema name based on environment:

        CI (target = ci):
            Uses GITHUB_ACTOR env var → DEV_MANISH, DEV_JOHN etc.
            Each developer gets their own schema automatically.
            Schema is created on the fly — no pre-creation needed.
            If GITHUB_ACTOR not set → falls back to CI (safety net)

        PROD (target = prod):
            Uses fixed schema PROD — shared, no prefix.

        DEV (target = dev):
            Same as CI logic — uses GITHUB_ACTOR prefix.
            Kept for flexibility if needed later.
    #}

    {%- set default_schema = target.schema -%}

    {%- if target.name == 'ci' -%}

        {#- Get GitHub username from env var set in the workflow -#}
        {%- set github_actor = env_var('GITHUB_ACTOR', '') -%}

        {%- if github_actor != '' -%}
            {#- Personal CI schema: DEV_MANISH, DEV_JOHN etc. -#}
            DEV_{{ github_actor | upper | replace('-', '_') | replace('.', '_') }}
        {%- else -%}
            {#- Fallback — shared CI schema -#}
            {{ default_schema }}
        {%- endif -%}

    {%- elif target.name == 'dev' -%}

        {#- Same logic as CI — developer personal schema -#}
        {%- set github_actor = env_var('GITHUB_ACTOR', '') -%}

        {%- if github_actor != '' -%}
            DEV_{{ github_actor | upper | replace('-', '_') | replace('.', '_') }}
        {%- else -%}
            {{ default_schema }}
        {%- endif -%}

    {%- elif target.name == 'prod' -%}
        {#- PROD is always shared — no prefix -#}
        {{ default_schema }}

    {%- else -%}
        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}
