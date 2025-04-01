{{ config(materialized='table') }}

SELECT
    country_code,
    {{ standardise_postal_code("postal_code", "country_code") }} AS postal_code,
    city,
    state,
    CAST(state_code AS STRING) AS state_code
FROM
    {{ source('web_events_dataset', 'locations_ext') }}
