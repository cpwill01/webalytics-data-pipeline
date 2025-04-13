# Custom Queries on Looker Studio

This is meant as a short example of using custom queries on Looker Studio so that you can create your own dashboards
based on BigQuery data.
Note that Looker Studio itself is free, but querying from BigQuery will have the usual costs.

1. Go to Looker Studio at https://lookerstudio.google.com/ and create a new report
2. Connect to BigQuery and click `Custom Query`.
3. Click your project and you'll see a text box where you can enter your query.
   1. You can check the `Enable date range parameters` box to dynamically change date values used in the custom query.
   Once enables, you can access `STRING` variables `@DS_START_DATE` and `@DS_END_DATE` in your query.
   2. For example, to create the music charts dashboard, I used this query to get song and location details of each
      listen event:
   ```shell
   SELECT
      listens.event_datetime,
      songs.title,
      songs.artist,
      songs.genre,
      locations.state
   FROM
      `decamp-450109.web_events_dataset.fact_listen_events` AS listens
   INNER JOIN
      `decamp-450109.web_events_dataset.dim_songs` AS songs
      ON listens.pk_song = songs.pk_song
   INNER JOIN
      `decamp-450109.web_events_dataset.dim_locations` AS locations
      ON listens.pk_location = locations.pk_location
   WHERE
      listens.event_datetime BETWEEN PARSE_TIMESTAMP('%E4Y%m%d', @DS_START_DATE) AND PARSE_TIMESTAMP('%E4Y%m%d', @DS_END_DATE)
   ```
   3. You can then use the appropriate dimensions in your charts, e.g. to get the `Top Artists` tile in my dashboard,
      choose the bar chart under `Add a chart`, then drag the `artist` column to Dimension and use `Record Count` as the
      metric.
   
> [!TIP]
> You might want to rename your custom query so that you don't get confused later on. You can do this by clicking
> `Resource` > `Manage added data sources` > 