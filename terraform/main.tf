terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.21.0"
    }
  }
  cloud { 
    organization = "Personal-Projects-cpwill"
    workspaces { 
      name = "DE_Zoomcamp_Project" 
    } 
  }
}

provider "google" {
  project     = var.project
  region      = var.region
}

resource "google_storage_bucket" "web_events_bucket" {
  name          = "web-events-bucket"
  location      = var.region
  force_destroy = true
  
  # how long to wait for a multipart (chunked) upload
  lifecycle_rule {
    condition {
      age = 1 #in days
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "web_events_dataset" {
  dataset_id    = "web_events_dataset"
  description   = "Dataset for webalytics pipeline project"
  location      = var.region
}
