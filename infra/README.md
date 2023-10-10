# Deploying the Solution

## Deploying the infrastructure

Run the following commands to deploy the infrastructure:

```bash
cd infra
terraform init
terraform apply
```

## Manual steps

> This is temporal

Clone the GitHub repository [cmendible/azure-search-openai-demo](https://github.com/cmendible/azure-search-openai-demo) and run the following commands to deploy the Azure Search Index and upload the sample documents:

```bash
git clone https://github.com/cmendible/azure-search-openai-demo.git
cd azure-search-openai-demo
git checkout k8s

export AZURE_PRINCIPAL_ID="<principal id>"
export AZURE_RESOURCE_GROUP="<resource group>" 
export AZURE_SUBSCRIPTION_ID="<subscription id>"
export AZURE_TENANT_ID="<azure tenant id>"
export AZURE_STORAGE_ACCOUNT="<storage account name>"
export AZURE_STORAGE_CONTAINER="content"
export AZURE_SEARCH_SERVICE="<search service name>"
export OPENAI_HOST="azure"
export AZURE_OPENAI_SERVICE="<openai service name>"
export OPENAI_API_KEY=""
export OPENAI_ORGANIZATION=""
export AZURE_OPENAI_EMB_DEPLOYMENT="text-embedding-ada-002"
export AZURE_OPENAI_EMB_MODEL_NAME="text-embedding-ada-002"
export AZURE_SEARCH_INDEX="gptkbindex"
```

Login to Azure:

```bash
azd auth login --client-id <client-id> --client-secret <client-password> --tenant-id <tenant-id>
```

Deploy the Azure Search Index and upload the sample documents:

```bash
./scripts/prepdocs.sh
```