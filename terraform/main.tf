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

resource "google_compute_instance" "eventsim_kafka_instance" {
  name                      = "eventsim-kafka-instance"
  machine_type              = "e2-standard-4"
  zone                      = var.zone
  tags                      = ["kafka", "eventsim"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 25
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Enables access to this instance via ephemeral public IP
    }
  }

  service_account {
    email   = google_service_account.eventsim_kafka_sa.email
    scopes  = ["storage-rw"]
  }
}

#service account for the compute instance
resource "google_service_account" "eventsim_kafka_sa" {
  account_id    = "evensim-kafka"
  display_name  = "Service Account for eventsim kafka compute instance"
}

#grants the service account permissions to create/delete cloud storage objects
resource "google_project_iam_member" "eventsim_kafka_role" {
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.eventsim_kafka_sa.email}"
  project = var.project
}
