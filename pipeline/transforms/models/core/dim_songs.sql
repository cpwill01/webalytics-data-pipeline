{{ config(materialized='table') }}

WITH distinct_songs AS (
    SELECT DISTINCT
        artist,
        REGEXP_REPLACE(title, r'([^\p{ASCII}]+)|(")', '') AS title,
        ROUND(duration, 2) AS duration,
        genre
    FROM
        {{ source(env_var('DBT_BIGQUERY_DATASET'), 'songs_ext') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(["artist", "title", "duration"]) }}
        AS pk_song,
    *
FROM distinct_songs
