# tf-playground
Little playground app for doing some terraform stuff

# Objective

We'll do a small practical dive into Terraform with Google Cloud Platform (GCP) since it has a very safe free tier.

# Prerequisites

## Installing stuff

1. Download Terraform 0.12.29 https://www.terraform.io/downloads.html (If you are on a mac, I recommend using Brew: https://formulae.brew.sh/formula/terraform)
1. Download the `gcloud` SDK: https://cloud.google.com/sdk/docs/quickstarts

## Making an account and project

1. Make a new gmail account so you can safely make new stuff in isolation
1. Visit https://cloud.google.com/
1. Make a new project (e.g. "Terraform-playground"

## Make a bucket in the GCP console

1. Visit GCS (Google Cloud Storage): TODO link
1. Enable billing (don't worry, GCP won't bill you after the 12 months expire)
1. Make a bucket for storing your terraform state

Don't worry if you get stuck doing this, we'll go through it together anyway. This guide is also useful: https://www.terraform.io/docs/providers/google/guides/getting_started.html

## Add bash helpers

If you're on mac or linux, copy/paste the helpers in [tf_helpers.sh](tf_helpers.sh) into your `~/.bash_profile`

# Initialize Terraform

## Generate a skeleton

You can use the bash helper to correctly generate your `/terraform` directory:

```
tfgenerator tf-playground-285720 jamsupreme-tf-bucket
```

## Make service account credentials

1. See instructions at https://cloud.google.com/docs/authentication/production#create_service_account for making a service account
1. Copy the `.json` file into the `/terraform` directory and rename it to `credentials.json` so git ignores it

## Authenticate with gcloud

1. Run `gcloud auth application-default login` and you'll be able to login
1. Set the project: `gcloud config set project tf-playground-285720` _(You must use the ID, not name)_

_(If you don't log into the application-default, terraform doesn't correctly initialize)_

## Initialize!

Run the following to initialize your Terraform:

```
cd terraform
# shorthand: tfinit dev
terraform init -backend-config=config/backend-dev.conf
```

# Build something basic

Let's make another bucket, but this time do it with Terraform:
```
resource "google_storage_bucket" "sample-bucket" {
  name          = "jamsupreme-another-bucket-vcool"
  force_destroy = true
}
```

Now let's run:
```
# shorthand: tfapply dev
terraform apply -var-file="config/dev.tfvars"
```