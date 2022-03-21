
// TODO: verify the required parameters

// Global Parameters
param location string = resourceGroup().location
param tags object
param vnetInfo object 
param snetsInfo array
param privateDnsZonesInfo array
param deployCustomDns bool
param addsDnsNicName string
param sharedResourceGroupName string

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
  name: 'avdVnetLinksResources_Deploy${i}'
  scope: resourceGroup(sharedResourceGroupName)
  dependsOn: [
    vnetResources
  ]
  params: {
    tags: tags
    name: '${privateDnsZoneInfo.vnetLinkName}avd'
    vnetName: vnetInfo.name
    privateDnsZoneName: privateDnsZoneInfo.name
    vnetResourceGroupName: resourceGroup().name
  }
}]




