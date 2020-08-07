provider "google" {
  credentials = file("credentials.json")
  project = "tf-playground-285720"
  region  = "us-east4"
  zone    = "us-east4-a"
}

terraform {
  backend "gcs" {
    prefix  = "terraform/state"
  }
}
