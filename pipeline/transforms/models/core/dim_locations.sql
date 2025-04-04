{{ config(materialized='table') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(["country_code", "postal_code"]) }} as location_id,
    country_code,
    {{ standardise_postal_code("postal_code", "country_code") }} AS postal_code,
    city,
    state,
    CAST(state_code AS STRING) AS state_code
FROM
    {{ source(env_var('DBT_BIGQUERY_DATASET'), 'locations_ext') }}
