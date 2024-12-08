
## tree struct 
```
.
├── AKS_EIT
│   ├── dev.tfvars
│   ├── main.tf
│   ├── production.tfvars
│   ├── terraform.tfvars
│   └── variables.tf
├── README.MD
└── module
```

## Authenticating to Remote state
```bash
$ az login
$ az account set --subscription 1bde07cf-02b6-4c27-9431-1ab1f2f2306d
```

## List workspace
```bash

$ terraform workspace list

```

## Deploy Dev environment

```bash
$ cd AKS_EIT
$ terraform init # first time
$ terraform workspace select dev
$ terraform plan -var-file dev.tfvars
$ terraform apply -var-file dev.tfvars
```

## Deploy Prod environment

```bash
$ cd AKS_EIT
$ terraform init # first time
$ terraform workspace select production
$ terraform plan -var-file production.tfvars
$ terraform apply -var-file production.tfvars
```
