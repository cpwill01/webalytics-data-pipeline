{{ config(materialized='table') }}

WITH distinct_songs AS (
    SELECT DISTINCT
        artist,
        title,
        duration,
        genre
    FROM
        {{ source(env_var('DBT_BIGQUERY_DATASET'), 'songs_ext') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(["artist", "title", "duration"]) }}
        AS pk_song,
    *
FROM distinct_songs
