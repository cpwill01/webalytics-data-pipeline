{{ config(
    materialized='incremental',
    unique_key = ['user_id']
) }}

{% if is_incremental() %}
    {%- set max_date =  get_value_from_query("COALESCE(MAX(date), '1900-01-01')", this) -%}
    {%- set max_hour = get_value_from_query("COALESCE(MAX(h), 0)", this) -%}
{% endif %}

SELECT
    {{ dbt_date.from_unixtimestamp("min(ts)", format="milliseconds") }} AS event_datetime,
    MIN(date) AS date,
    MIN(h) AS h,
    userid AS user_id,
    firstname AS first_name,
    lastname AS last_name,
    gender,
    level,
    {{ 
        dbt_date.from_unixtimestamp("registration", format="milliseconds") 
    }} AS registration_datetime
FROM
    {{ source(env_var('DBT_BIGQUERY_DATASET'), 'users_ext') }}
{% if is_incremental() %}

    WHERE date >= "{{ max_date }}"
        AND h >= {{ max_hour }}
        AND {{ dbt_date.from_unixtimestamp("ts", format="milliseconds") }} > (
            SELECT COALESCE(MAX(this_table.event_datetime), "1900-01-01") - INTERVAL 10 MINUTE
            FROM {{ this }} AS this_table
        )

{% endif %}
-- Use groupby to handle cases where source application emits same user data multiple times
GROUP BY 4, 5, 6, 7, 8, 9
