{{ config(
    materialized='incremental',
    unique_key = ['event_datetime', 'user_id'])
 }}
{% if is_incremental() %}
    {%- set max_date =  get_value_from_query("COALESCE(MAX(date),'1900-01-01')", this) -%}
    {%- set max_hour = get_value_from_query("COALESCE(MAX(h),0)", this) -%}
{% endif %}

SELECT
    {{ dbt_date.from_unixtimestamp("ts", format="milliseconds") }} AS event_datetime,
    date,
    h,
    userid AS user_id,
    LOWER(level) AS prev_level
FROM
    {{ source(env_var('DBT_BIGQUERY_DATASET'), 'status_change_events_ext') }}
{% if is_incremental() %}

WHERE date >= "{{ max_date }}"
    AND h >= {{ max_hour }}
    AND {{ dbt_date.from_unixtimestamp("ts", format="milliseconds") }} > (
        SELECT COALESCE(MAX(event_datetime),'1900-01-01') FROM {{ this }} 
        )

{% endif %}