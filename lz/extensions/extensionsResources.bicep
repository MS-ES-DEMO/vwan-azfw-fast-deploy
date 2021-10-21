
// TODO: verify the required parameters

// Global Parameters
param location string = resourceGroup().location
param tags object
param vmName string
@secure()
param vmAdminUsername string
@secure()
param vmAdminPassword string
param addsDnsExtensionName string
param artifactsLocation string = 'https://extensionsawvd.blob.core.windows.net/extensions/'
param domainName string



module addsDnsExtensionResources '../../modules/Microsoft.Compute/addsDnsExtension.bicep' = {
  name: 'addsDnsExtensionResources_Deploy'
  params: {
    location: location
    tags: tags
    name: addsDnsExtensionName
    vmName: vmName
    artifactsLocation: artifactsLocation
    domainName: domainName
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
  }
}


