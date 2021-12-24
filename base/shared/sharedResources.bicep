// Global Parameters
param location string = resourceGroup().location
param tags object
param vnetInfo object 

param snetsInfo array
param privateDnsZonesInfo array

param deployCustomDns bool = false
param addsDnsNicName string
param addsDnsResourceGroupName string

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

module addsDnsResources '../addsdns/addsDnsResources.bicep' = {
  name: 'dnsResources_Deploy'
  params: {
    location:location
    tags: tags
    vnetInfo: vnetInfo 
    snetsInfo: snetsInfo
    privateDnsZonesInfo: privateDnsZonesInfo    
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


module vnetUpdateResources '../../modules/Microsoft.Network/vnet.bicep' = {
  name: 'vnetUpdateResources_Deploy'
  dependsOn: [
    addsDnsResources
  ]
  params: {
    location: location
    tags: tags
    vnetInfo: vnetInfo
    deployCustomDns: deployCustomDns
    snetsInfo: snetsInfo
    addsDnsNicName: addsDnsNicName
    addsDnsResourceGroupName: addsDnsResourceGroupName
  }
}

module vnetLinks '../../modules/Microsoft.Network/vnetLink.bicep' = [ for (privateDnsZoneInfo, i) in privateDnsZonesInfo : {
  name: 'sharedVnetLinksResources_Deploy${i}'
  scope: resourceGroup(addsDnsResourceGroupName)
  dependsOn: [
    vnetResources
  ]
  params: {
    tags: tags
    name: '${privateDnsZoneInfo.vnetLinkName}shared'
    vnetName: vnetInfo.name
    privateDnsZoneName: privateDnsZoneInfo.name
    vnetResourceGroupName: resourceGroup().name
  }
}]

