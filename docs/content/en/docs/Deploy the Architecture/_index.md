---
title: Deploy the Architecture
weight: 3
description: This guide provides details and instructions to help you deploy the Activate GenAI with Azure Accelerator for your customer.
---
## High-level Architecture

The following diagram shows the high-level architecture of the **Activate GenAI with Azure** Accelerator:

![High-level Architecture](/activate-genai/img/ActivateGenAI-HLD.png)



## Deployment

{{% pageinfo %}}
Work in progress. There are still some manual steps to be automated. Check [here](https://github.com/Azure/activate-genai/blob/main/infra/README.md) for the latest updates.
{{% /pageinfo %}}


Run the following command to deploy the **Activate GenAI with Azure** Accelerator:

```bash
cd infra
terraform init
terraform apply
```