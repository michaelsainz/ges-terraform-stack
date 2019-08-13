#!/usr/bin/env bash

set -e

while true; do
  case "$1" in
    -i|--init)
      echo "Initializing Terraform working directory"
      cd ./roots/ges-infra/
      terraform init
      shift
    ;;
    -p|--plan)
      export TFPLAN=true
      echo "Planning out Terraform configuration"
      cd ./roots/ges-infra/
      terraform plan -var-file $GES_VAR_PATH
      shift
      ;;
    -a|--apply)
      export TFAPPLY=true
      echo "Applying Terraform configuration"
      cd ./roots/ges-infra/
      terraform apply -auto-approve -var-file $GES_VAR_PATH
      shift
      ;;
    -d|--destroy)
      export TFDESTROY=true
      echo "Destroying Terraform configuration"
      cd ./roots/ges-infra/
      terraform destroy -auto-approve -var-file $GES_VAR_PATH
      shift
      ;;
    -da|--destroyall)
      export TFDESTROYALL=true
      echo "Destroying all Terraform configurations"
      cd ./roots/ges-infra/
      terraform init -backend false
      terraform destroy -auto-approve -var-file $GES_VAR_PATH
      cd ../config-tf-state/
      terraform destroy -auto-approve -var-file $GES_VAR_PATH
      cd ../../
      shift
      ;;
    -r|--rebuild)
      export TFREBUILD=true
      echo "Rebuilding GES infrastructure"
      cd ./roots/ges-infra/
      terraform destroy -var-file $GES_VAR_PATH -target module.vpc -auto-approve
      terraform apply -var-file $GES_VAR_PATH -auto-approve
      shift
      ;;
    *)
      break
      ;;
  esac
done