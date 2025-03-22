# -*- coding: utf-8 -*-
"""
Common utility functions for ingestion of flat files to GCS
"""
from google.cloud import storage

def upload_to_gcs(bucket_name, source_file, destination_blob_name):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)
    blob.upload_from_file(source_file)