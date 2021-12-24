// Global Parameters
param location string = resourceGroup().location
param tags object
param vnetInfo object 

param snetsInfo array
param privateDnsZonesInfo array

param addsDnsNicName string

param vmAddsDnsName string
param vmAddsDnsSize string
param vmAddsDnsAdminUsername string
param vmAddsDnsAdminPassword string
param diagnosticsStorageAccountName string
param logWorkspaceName string
param monitoringResourceGroupName string

module vnetResources '../../modules/Microsoft.Network/vnet.nodns.bicep' = {
  name: 'vnetResources_Deploy'
  params: {
    location: location
    tags: tags
    vnetInfo: vnetInfo
    snetsInfo: snetsInfo
  }
}

module addsDnsResources '../shared/addsdns/addsDnsResources.bicep' = {
  name: 'dnsResources_Deploy'
  dependsOn: [
    vnetResources
  ]
  params: {
    location:location
    tags: tags
    vnetInfo: vnetInfo 
    snetsInfo: snetsInfo  
    nicName: addsDnsNicName
    vmName: vmAddsDnsName
    vmSize: vmAddsDnsSize
    vmAdminUsername: vmAddsDnsAdminUsername
    vmAdminPassword: vmAddsDnsAdminPassword
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    logWorkspaceName: logWorkspaceName
    monitoringResourceGroupName: monitoringResourceGroupName
  }
}


module privateDnsZones '../../modules/Microsoft.Network/privateDnsZone.bicep' = [ for (privateDnsZoneInfo, i) in privateDnsZonesInfo : {
  name: 'privateDnsZonesResources_Deploy${i}'
  dependsOn: [
    vnetResources
  ]
  params: {
    location: 'global'
    tags: tags
    name: privateDnsZoneInfo.name
  }
}]

module vnetLinks '../../modules/Microsoft.Network/vnetLink.bicep' = [ for (privateDnsZoneInfo, i) in privateDnsZonesInfo : {
  name: 'sharedVnetLinksResources_Deploy${i}'
  dependsOn: [
    vnetResources
    privateDnsZones
  ]
  params: {
    tags: tags
    name: '${privateDnsZoneInfo.vnetLinkName}shared'
    vnetName: vnetInfo.name
    privateDnsZoneName: privateDnsZoneInfo.name
    vnetResourceGroupName: resourceGroup().name
  }
}]

