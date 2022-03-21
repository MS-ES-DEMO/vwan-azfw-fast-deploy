
// TODO: verify the required parameters

// Global Parameters
param location string = resourceGroup().location
param tags object
param vnetInfo object 

param snetsInfo array
param privateDnsZonesInfo array
param nicName string
param deployCustomDns bool = true
param addsDnsNicName string
param sharedResourceGroupName string
param vmName string
param vmSize string
@secure()
param vmAdminUsername string
@secure()
param vmAdminPassword string
param diagnosticsStorageAccountName string
param logWorkspaceName string
param monitoringResourceGroupName string
param storageAccountName string
param blobStorageAccountPrivateEndpointName string
param blobPrivateDnsZoneName string


module vnetResources '../../modules/Microsoft.Network/vnet.bicep' = {
  name: 'vnetResources_Deploy'
  params: {
    location: location
    tags: tags
    vnetInfo: vnetInfo
    deployCustomDns: deployCustomDns
    addsDnsNicName: addsDnsNicName
    sharedResourceGroupName: sharedResourceGroupName
    snetsInfo: snetsInfo
  }
}

module vnetLinks '../../modules/Microsoft.Network/vnetLink.bicep' = [ for (privateDnsZoneInfo, i) in privateDnsZonesInfo : {
  name: 'spoke1VnetLinksResources_Deploy${i}'
  scope: resourceGroup(sharedResourceGroupName)
  dependsOn: [
    vnetResources
  ]
  params: {
    tags: tags
    name: '${privateDnsZoneInfo.vnetLinkName}spoke1'
    vnetName: vnetInfo.name
    privateDnsZoneName: privateDnsZoneInfo.name
    vnetResourceGroupName: resourceGroup().name
  }
}]

module nicResources '../../modules/Microsoft.Network/nic.bicep' = {
  name: 'nicResources_Deploy'
  dependsOn: [
    vnetResources
  ]
  params: {
    tags: tags
    name: nicName
    location: location
    vnetName: vnetInfo.name
    vnetResourceGroupName: resourceGroup().name
    snetName: snetsInfo[0].name
    nsgName: ''
  }
}

module vmResources '../../modules/Microsoft.Compute/vm.bicep' = {
  name: 'vmResources_Deploy'
  dependsOn: [
    nicResources
  ]
  params: {
    tags: tags
    name: vmName
    location: location
    vmSize: vmSize
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    nicName: nicName
  }
}

module daExtensionResources '../../modules/Microsoft.Compute/daExtension.bicep' = {
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

module diagnosticsExtensionResources '../../modules/Microsoft.Compute/diagnosticsExtension.bicep' = {
  name: 'diagnosticsExtensionResources_Deploy'
  dependsOn: [
    vmResources
  ]
  params: {
    location: location
    tags: tags
    vmName: vmName
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    monitoringResourceGroupName: monitoringResourceGroupName
  }
}

module monitoringAgentExtensionResources '../../modules/Microsoft.Compute/monitoringAgentExtension.bicep' = {
  name: 'monitoringAgentExtensionResources_Deploy'
  dependsOn: [
    vmResources
  ]
  params: {
    location: location
    tags: tags
    vmName: vmName
    logWorkspaceName: logWorkspaceName
    monitoringResourceGroupName: monitoringResourceGroupName
  }
}

module storageAccountResources '../../modules/Microsoft.Storage/storageAccount.bicep' = {
  name: 'storageAccountResources_Deploy'
  params: {
    location: location
    tags: tags
    name: storageAccountName
  }
}

module blobPrivateEndpointResources '../../modules/Microsoft.Network/storagePrivateEndpoint.bicep' = {
  name: 'blobPrivateEndpointResources_Deploy'
  dependsOn: [
    vnetResources
    storageAccountResources
  ]
  params: {
    location: location
    tags: tags
    name: blobStorageAccountPrivateEndpointName
    vnetName: vnetInfo.name
    snetName: snetsInfo[1].name
    storageAccountName: storageAccountName
    privateDnsZoneName: blobPrivateDnsZoneName
    groupIds: 'blob'
    sharedResourceGroupName: sharedResourceGroupName
  }
}




