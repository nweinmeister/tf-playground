# Some terraform helpers (based on convention)
tfinit(){
  if [ -z "$1" ]; then
    echo 'Arg $1 should be environment!'
    return
  fi
  terraform init -backend-config=config/backend-$1.conf
}
tfplan(){
  if [ -z "$1" ]; then
    echo 'Arg $1 should be environment!'
    return
  fi
  terraform plan -var-file="config/$1.tfvars"
}
tfapply(){
  if [ -z "$1" ]; then
    echo 'Arg $1 should be environment!'
    return
  fi
  echo "Apply started at $(date)"
  terraform apply -var-file="config/$1.tfvars"
  echo "Apply completed at $(date)"
}

# Generates a convention-based /terraform directory for you
# 1: Your project ID
# 2: Your terraform state bucket
tfgenerator(){
  if [ -z "$1" ]; then
    cat << 'EOF'
usage: tfgenerator [project-id] [bucket-name]

$1 - Your project ID (not name)
$2 - Your bucket for storing TF state
EOF
    return
  fi
  
  echo "Wiping existing terraform directory..."
  rm -rf terraform

  mkdir terraform
  pushd terraform
  cat << EOF > configuration.tf
provider "google" {
  project = "$1"
  region  = "us-east4"
  zone    = "us-east4-a"
}

terraform {
  backend "gcs" {
    prefix  = "terraform/state"
  }
}
EOF

  cat << EOF > input_variables.tf
variable "deploy_env" {
  type        = string
  description = "Deploy environment (dev, prod, test)"
}
EOF

  mkdir config
  pushd config 
  cat << EOF > backend-dev.conf
bucket = "$2"
EOF
  cat << EOF > dev.tfvars
deploy_env = "dev"
EOF
  # go back to terraform dir
  popd

  # go back to root
  popd
}