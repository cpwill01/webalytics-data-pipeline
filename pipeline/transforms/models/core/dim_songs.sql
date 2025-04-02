{{ config(materialized='table') }}

SELECT
    CAST(track_id AS STRING) AS track_id,
    artist,
    title,
    ROUND(duration, 2) AS duration
FROM
    {{ source(env_var('DBT_BIGQUERY_DATASET'), 'songs_ext') }}
