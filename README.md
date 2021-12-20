# Fast Deploy: Hub-spoke network topology with Azure Virtual WAN and Azure Firewall

This repository contains an Azure Bicep template to simplify the deployment of a Hub and Spoke topology using Azure Virtual WAN secured with Azure Firewall in test or demo scenarios. This template is used by other scenarios as their networking infrastructure and they are built on top of it (i.e. [Fast Deploy: Azure Virtual Desktop](https://github.com/MS-ES-DEMO/avd-consumption-play)).

The following diagram shows a detailed architecture of the logical and network topology of the resources created by this template. Relevant resources for the specific scenario coverd in this repository are deployed into the following resource groups:

- **rg-prehub**: resources associated with Azure vWAN.
- **rg-pre-security**: resources associated with Azure Firewall integrated with Azure vWAN.
- **rg-pre-montoring**: a storage account and a Log Analytics Workspace to store the diagnostics information.
- **rg-pre-shared**: resoures associated with a spoke that hosts the common services used by other workloads. For example: Active Directory Domain Services and DNS.
- **rg-pre-spoke**: an example spoke to show the deployment of an application with consumption of a Private Endpoint.

The following resource groups are associated with other scenarios using this template as a reference for their networking requirements:

- **rg-pre-avd**: network configuration for provisioning Azure Virtual Desktop with different usage scenarios.

![Logial architecture](/doc/images/logical-network-diagram.png )

## Repository structure

This repository is organized in the following folders:

- **base**: folder containing Bicep file that deploy the evnironment.
- **doc**: contains documents and images related to this scenario.
- **modules**: Bicep modules that integrates the different resources used by the base scripts.
- **utils**: extra files required to deploy this scenario.

## Pre-requisites

Bicep is the language used for defining declaratively the Azure resources required in this template. You would need to configure your development environment with Bicep support to succesffully deploy this scenario.

- [Installing Bicep with Azure CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli)
- [Installing Bicep with Azure PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-powershell)

As alternative, you can use [Azure Shell with PowerShell](https://ms.portal.azure.com/#cloudshell/) that already includes support for Bicep.

After validating Bicep installation, you would need to configure the Azure subscription where the resources would be deployed. You need to make sure that you have at least enoug quota for creating:

- 1 VWAN
- as
- b
- c

## Deployment

1. Customize the parameters.default.json file to adapt their values to your specific environment. You can review the next section to understand the options available.
2. Execute deploy.ps1 script.
3. Wait around 40 minutes.
4. Enjoy

## Parameters

- *location*
  - "type": "string",
  - "allowed": "northeurope", "westeurope"
  - "description": "Allows to configure the Azure region where the resources should be deployed. Only tested at this time on North Europe and West Eurpope."

- *environment*
  - "type": "string",
  - "allowed": "Dev", "Test", "Pre", "Uat", "Prod", "ProdDr"
  - "description": "Allows to configure the prefix used in the resources created and the tags associated with them"

- *xxxxResourceGroupName*
  - "type": "string",
  - "description": "Allows to configure the specific resource group where the resoruces associated with xxxx should be deployed. You can define the same resource group name for all resources in a test environment to simplify management and deletion after finishing with the evaluation."

- *deployLogWorkspace*
  - "type": "bool",
  - "description": "If an existing Log Analytics Workspace should be used you need to configure this parameter to true"

- *existingLogWorkspaceName*
  - "type": "string",
  - "description": "If the previous parameter is configured to true, you need to specific the Log Analytics Workspace name here"
  
- *vmAddsDnsAdminUsername*
  - "type": "string",
  - "description": "User name of the local admin configured for the Active Directory Domain Services and DNS virtual machine"

- *vmSpoke1AdminUsername*
  - "type": "string",
  - "description": "User name of the local admin configured for the virtual machine deployed on the application spoke"

*We don't recommend to adjust the values of the other parameters related with networking address spaces. The main.bicep template has several values hardcoded assocaited with those parameters at this time that would require extra modifications if you want to use them.*
