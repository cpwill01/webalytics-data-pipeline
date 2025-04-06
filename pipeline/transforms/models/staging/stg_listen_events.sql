{{ config(
    materialized='incremental',
    unique_key = ['event_datetime', 'user_id'],
    partition_by={
      "field": "event_datetime",
      "data_type": "timestamp",
      "granularity": "day"
    }
) }}
{% if is_incremental() %}
    {%- set max_date =  get_value_from_query("COALESCE(MAX(date),'1900-01-01')", this) -%}
    {%- set max_hour = get_value_from_query("COALESCE(MAX(h),0)", this) -%}
{% endif %}

SELECT
    {{ dbt_date.from_unixtimestamp("ts", format="milliseconds") }} AS event_datetime,
    date,
    h,
    userid AS user_id,
    zip as postal_code,
    COALESCE(city, "NO CITY") AS city,
    COALESCE(state, "NO STATE") AS state,
    auth,
    level,
    song,
    artist,
    duration
FROM
    {{ source(env_var('DBT_BIGQUERY_DATASET'), 'listen_events_ext') }}
{% if is_incremental() %}

WHERE date >= "{{ max_date }}"
    AND h >= {{ max_hour }}
    AND {{ dbt_date.from_unixtimestamp("ts", format="milliseconds") }} > (
        SELECT COALESCE(MAX(event_datetime),'1900-01-01') - INTERVAL 10 MINUTE FROM {{ this }} 
        )

{% endif %}