variable "project" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Project Region"
  default     = "us-central1"
  type        = string
}

variable "zone" {
  description = "Project Zone"
  default     = "us-central1-a"
  type        = string
}
