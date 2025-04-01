{{ config(materialized='table') }}

SELECT
    CAST(track_id AS STRING) AS track_id,
    artist,
    title,
    ROUND(duration, 2) AS duration
FROM
    {{ source('web_events_dataset', 'songs_ext') }}
