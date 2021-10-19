
// TODO: verify the required parameters

// Global Parameters
param location string = resourceGroup().location
param tags object
param vmName string
@secure()
param vmAdminUsername string
@secure()
param vmAdminPassword string
param addsAndDnsExtensionName string
param artifactsLocation string = 'https://extensionsawvd.blob.core.windows.net/extensions/'
param domainName string



module addsAndDnsExtensionResources '../../modules/Microsoft.Compute/addsAndDnsExtension.bicep' = {
  name: 'addsAndDnsExtensionResources_Deploy'
  params: {
    location: location
    tags: tags
    name: addsAndDnsExtensionName
    vmName: vmName
    artifactsLocation: artifactsLocation
    domainName: domainName
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
  }
}


