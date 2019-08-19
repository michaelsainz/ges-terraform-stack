# GitHub Enterprise Server Terraform Stack
Provides Terraform templates for configuring GitHub Enterprise Server ("GHES") across multiple cloud service providers using industry best-practices.

# Motivation
There are plenty of examples of how to setup and configure GHES, both automated and with step-by-step instructions - including [GitHub](https://help.github.com/en/enterprise/2.17/admin/installation)!

What seems to be lacking are examples where best-practices of cloud infrastructure are codified along with the configuration of the appliance. That's the goal of this project - provide a set of templates that can be cloned and modified to use for organizations who want to have a production ready environment of GHES.

# Installation

First rename the example variables file -
`mv ./variables.tfvars.example ./variables.tfvars`

Next fill in the variable values of the `variables.tfvars` file with information specific to your configuration. Also set the path of the variable.tfvars file to the `GES_VAR_PATH` environmential variable -
`export GES_VAR_PATH=~/Documents/variables.tfvars`

Afterwards you need to initialize your Terraform environment -
`./build.sh -i`

And finally you can run the following to see your Terraform Plan -
`./build.sh -p`

To apply said plan, execute the following -
`./build.sh -a`

When you're finished with your infrastructure you can destroy it -
`./build.sh -d`

But if you need to rebuild your infrastructure (destroy & create) you can issue just one command -
`./build.sh -r`

# Features
The list of features currently supported are a bit short but the goals are big -

- AWS Cloud support
- Supports remote state storage
- AWS NLB support
- AWS Route53 Namespace support

# Contribute
Contributions are absolutely appreciative! Feel free to submit a PR.