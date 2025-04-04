{#
    This macro returns the postal code as a string in the standard format of the specified country.
#}

{% macro get_value_from_query(selection_arg, table) -%}
    
    {% set sql_statement %}
        select {{ selection_arg }} from {{ table }}
    {% endset %}

    {{ return(dbt_utils.get_single_value(sql_statement)) }}

{%- endmacro %}