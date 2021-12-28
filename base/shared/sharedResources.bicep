// Global Parameters
param location string = resourceGroup().location
param tags object
param vnetInfo object 

param snetsInfo array
param privateDnsZonesInfo array

param addsDnsNicName string
param addsDnsDataDiskName string
param addsDnsDataDiskSize int

param vmAddsDnsName string
param vmAddsDnsSize string
param vmAddsDnsAdminUsername string
@secure()
param vmAddsDnsAdminPassword string
@secure()
param domainAdminPassword string
param diagnosticsStorageAccountName string
param logWorkspaceName string
param monitoringResourceGroupName string

param addsDnsExtensionName string
param artifactsLocation string
param domainName string

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
    dataDiskName: addsDnsDataDiskName
    dataDiskSize: addsDnsDataDiskSize
    vmName: vmAddsDnsName
    vmSize: vmAddsDnsSize
    vmAdminUsername: vmAddsDnsAdminUsername
    vmAdminPassword: vmAddsDnsAdminPassword
    domainAdminPassword: domainAdminPassword
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    logWorkspaceName: logWorkspaceName
    monitoringResourceGroupName: monitoringResourceGroupName
    addsDnsExtensionName: addsDnsExtensionName
    artifactsLocation: artifactsLocation
    domainName: domainName
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

