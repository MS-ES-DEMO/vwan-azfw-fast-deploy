
// TODO: verify the required parameters

// Global Parameters
param location string = resourceGroup().location
param tags object
param vnetInfo object 
param nsgInfo object
param snetsInfo array
param privateDnsZonesInfo array

param deployCustomDns bool = false
param addsDnsNicName string
param addsDnsResourceGroupName string


module vnetResources '../../modules/Microsoft.Network/vnet.bicep' = {
  name: 'vnetResources_Deploy'
  params: {
    location: location
    tags: tags
    vnetInfo: vnetInfo
    deployCustomDns: deployCustomDns
    addsDnsNicName: addsDnsNicName
    addsDnsResourceGroupName: addsDnsResourceGroupName
    snetsInfo: snetsInfo
  }
}


module nsgResources '../../modules/Microsoft.Network/nsg.bicep' = {
  name: 'nsgResources_Deploy'
  params: {
    location: location
    tags: tags
    name: nsgInfo.name
  }
}

module nsgInboundRulesResources '../../modules/Microsoft.Network/nsgRule.bicep' = [ for (ruleInfo, i) in nsgInfo.inboundRules: {
  name: 'nsgInboundRulesResources_Deploy${i}'
  dependsOn: [
    nsgResources 
  ]
  params: {
    name: ruleInfo.name
    rule: ruleInfo.rule
    nsgName: nsgInfo.name
  }
}]

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

