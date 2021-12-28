
// TODO: verify the required parameters

// Global Parameters
param location string = resourceGroup().location
param tags object
param vnetInfo object 
param snetsInfo array
param nicName string
param vmName string
param vmSize string
@secure()
param vmAdminUsername string
@secure()
param vmAdminPassword string
param diagnosticsStorageAccountName string
param logWorkspaceName string
param monitoringResourceGroupName string
param addsDnsExtensionName string
param artifactsLocation string = 'https://extensionsawvd.blob.core.windows.net/extensions/'
param domainName string


module nicResources '../../../modules/Microsoft.Network/nic.bicep' = {
  name: 'nicResources_Deploy'
  params: {
    tags: tags
    name: nicName
    vnetName: vnetInfo.name
    vnetResourceGroupName: resourceGroup().name
    snetName: snetsInfo[0].name
    nsgName: ''
  }
}

module vmResources '../../../modules/Microsoft.Compute/vm.bicep' = {
  name: 'vmResources_Deploy'
  dependsOn: [
    nicResources
  ]
  params: {
    tags: tags
    name: vmName
    vmSize: vmSize
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    nicName: nicName
  }
}

module daExtensionResources '../../../modules/Microsoft.Compute/daExtension.bicep' = {
  name: 'daExtensionResources_Deploy'
  dependsOn: [
    vmResources
  ]
  params: {
    location: location
    tags: tags
    vmName: vmName
  }
}

module diagnosticsExtensionResources '../../../modules/Microsoft.Compute/diagnosticsExtension.bicep' = {
  name: 'diagnosticsExtensionResources_Deploy'
  dependsOn: [
    vmResources
    daExtensionResources
  ]
  params: {
    location: location
    tags: tags
    vmName: vmName
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    monitoringResourceGroupName: monitoringResourceGroupName
  }
}

module monitoringAgentExtensionResources '../../../modules/Microsoft.Compute/monitoringAgentExtension.bicep' = {
  name: 'monitoringAgentExtensionResources_Deploy'
  dependsOn: [
    vmResources
    diagnosticsExtensionResources
    daExtensionResources
  ]
  params: {
    location: location
    tags: tags
    vmName: vmName
    logWorkspaceName: logWorkspaceName
    monitoringResourceGroupName: monitoringResourceGroupName
  }
}

module addsDnsExtensionResources '../../../modules/Microsoft.Compute/addsDnsExtension.bicep' = {
  name: 'addsDnsExtensionResources_Deploy'
  dependsOn: [
    vmResources
    monitoringAgentExtensionResources
  ]
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






