
// TODO: verify the required parameters

// Global Parameters
param location string = resourceGroup().location
param tags object
param vnetInfo object 
param nsgInfo object
param snetsInfo array
param privateDnsZonesInfo array
param nicName string
param deployCustomDns bool = false
param dnsResourceGroupName string
param vmName string
param vmSize string
@secure()
param vmAdminUsername string
@secure()
param vmAdminPassword string
param addsAndDnsExtensionName string
param artifactsLocation string
param domainName string



module vnetResources '../../modules/Microsoft.Network/vnet.bicep' = {
  name: 'vnetResources_Deploy'
  dependsOn: [
    nsgResources
    nsgInboundRulesResources
  ]
  params: {
    location: location
    tags: tags
    vnetInfo: vnetInfo
    deployCustomDns: deployCustomDns
    dnsNicName: ''
    dnsResourceGroupName: dnsResourceGroupName
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
  name: 'dnsVnetLinksResources_Deploy${i}'
  dependsOn: [
    vnetResources
    privateDnsZones
  ]
  params: {
    tags: tags
    name: '${privateDnsZoneInfo.vnetLinkName}dns'
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
    vnetName: vnetInfo.name
    vnetResourceGroupName: resourceGroup().name
    snetName: snetsInfo[0].name
    nsgName: nsgInfo.name
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
    vmSize: vmSize
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    nicName: nicName
  }
}

module addsAndDnsExtensionResources '../../modules/Microsoft.Compute/addsAndDnsExtension.bicep' = {
  name: 'addsAndDnsExtensionResources_Deploy'
  dependsOn: [
    nicResources
  ]
  params: {
    tags: tags
    name: addsAndDnsExtensionName
    vmName: vmName
    artifactsLocation: artifactsLocation
    domainName: domainName
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
  }
}


