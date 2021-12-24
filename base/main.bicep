targetScope = 'subscription'

// Global Parameters

@description('Azure region where resource would be deployed')
param location string

@description('Environment')
param env string
@description('Tags associated with all resources')
param tags object 

// Resource Group Names

@description('Resource Groups names')
param resourceGroupNames object

var monitoringResourceGroupName = resourceGroupNames.monitoring
var hubResourceGroupName = resourceGroupNames.hub
var sharedResourceGroupName = resourceGroupNames.shared
var spoke1ResourceGroupName = resourceGroupNames.spoke1
var securityResourceGroupName = resourceGroupNames.security
var avdResourceGroupName = resourceGroupNames.avd


// Monitoring resources
@description('Monitoring options')
param monitoringOptions object

var deployLogWorkspace = monitoringOptions.deployLogAnalyticsWorkspace
var existingLogWorkspaceName = monitoringOptions.existingLogAnalyticsWorkspaceName
var diagnosticsStorageAccountName = monitoringOptions.diagnosticsStorageAccountName


// Security resources


// Active Directory Domain Services resources

@description('ADDS VM configuration details')
param vmAdds object 

var vmAddsDnsName = vmAdds.name
var vmAddsDnsSize = vmAdds.sku
var addsDnsNicName  = vmAdds.nicName
var vmAddsDnsAdminUsername = vmAdds.adminUsername


@description('Admin password for ADDSDNS vm')
@secure()
param vmAddsDnsAdminPassword string


// Shared resources

@description('Name and range for shared services vNet')
param sharedVnetInfo object 

var sharedSnetsInfo  = sharedVnetInfo.subnets

var privateDnsZonesInfo = [
  {
    name: format('privatelink.blob.{0}', environment().suffixes.storage)
    vnetLinkName: 'vnet-link-blob-to-'
    vnetName: sharedVnetInfo.name
  }
  {
    name: format('privatelink.file.{0}', environment().suffixes.storage)
    vnetLinkName: 'vnet-link-file-to-'
    vnetName: sharedVnetInfo.name
  }
  {
    name: format('privatelink{0}', environment().suffixes.sqlServerHostname)
    vnetLinkName: 'vnet-link-sqldatabase-to-'
    vnetName: sharedVnetInfo.name
  }
]


// Spoke resources

@description('Name and range for spoke1 services vNet')
param spoke1VnetInfo object 

var spoke1SnetsInfo = spoke1VnetInfo.subnets
var deployCustomDnsOnSpoke1Vnet = sharedVnetInfo.deployCustomDnsOnSharedVnet

@description('Spoke1 VM configuration details')
param vmSpoke1 object 

var vmSpoke1Name = vmSpoke1.name
var vmSpoke1Size = vmSpoke1.sku
var spoke1NicName  = vmSpoke1.nicName
var vmSpoke1AdminUsername = vmSpoke1.adminUsername


@description('Admin password for Spoke1 vm')
@secure()
param vmSpoke1AdminPassword string


param privateEndpoints object

var storageAccountName = privateEndpoints.spoke1StorageAccount.name
var blobStorageAccountPrivateEndpointName  = privateEndpoints.spoke1StorageAccount.privateEndpointName

// Hub resources

@description('Name for VWAN')
param vwanName string
@description('Name and range for Hub')
param hubVnetInfo object 

@description('Azure Firewall configuration parameters')
param firewallConfiguration object

var fwPublicIpName = firewallConfiguration.ipName
var firewallName = firewallConfiguration.name

var fwPolicyInfo = firewallConfiguration.policy
var appRuleCollectionGroupName = firewallConfiguration.appCollectionRules.name
var appRulesInfo = firewallConfiguration.appCollectionRules.rulesInfo

var networkRuleCollectionGroupName = firewallConfiguration.networkCollectionRules.name
var networkRulesInfo = firewallConfiguration.networkCollectionRules.rulesInfo

var dnatRuleCollectionGroupName  = firewallConfiguration.dnatCollectionRules.name

// TODO If moved to parameters.json, self-reference to other parameters is not supported
@description('Name for hub virtual connections')
param hubVnetConnectionsInfo array = [
  {
    name: 'hub-to-shared'
    remoteVnetName: sharedVnetInfo.name
    resourceGroup: resourceGroupNames.shared
  }
  {
    name: 'hub-to-avd'
    remoteVnetName: avdVnetInfo.name
    resourceGroup: resourceGroupNames.avd
  }
  {
    name: 'hub-to-spoke1'
    remoteVnetName: spoke1VnetInfo.name
    resourceGroup: resourceGroupNames.spoke1
  }
]

var privateTrafficPrefix = [
  '0.0.0.0/0'
  '172.16.0.0/12' 
  '192.168.0.0/16'
  '${sharedVnetInfo.range}'
  '${spoke1VnetInfo.range}'
  '${avdVnetInfo.range}'
]


// Azure Virtual Desktop resources

@description('Name and range for avd vNet')
param avdVnetInfo object 
var avdSnetsInfo = avdVnetInfo.subnets


/* 
  Monitoring resources deployment 
*/
// Checked

resource monitoringResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: monitoringResourceGroupName
  location: location
}

module monitoringResources 'monitoring/monitoringResources.bicep' = {
  scope: monitoringResourceGroup
  name: 'monitoringResources_Deploy'
  params: {
    location:location
    env: env
    tags: tags
    deployLogWorkspace: deployLogWorkspace
    existingLogWorkspaceName: existingLogWorkspaceName
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
  }
}

/* 
  Shared resources deployment 
    - Active Directory Domain Services
    - Domain Name Service
*/
// Checked

resource sharedResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: sharedResourceGroupName
  location: location
}

module sharedResources 'shared/sharedResources.bicep' = {
  scope: sharedResourceGroup
  name: 'sharedResources_Deploy'
  dependsOn: [
    monitoringResources
  ]
  params: {
    location:location
    tags: tags
    vnetInfo: sharedVnetInfo 
    snetsInfo: sharedSnetsInfo
    privateDnsZonesInfo: privateDnsZonesInfo 
    addsDnsNicName: addsDnsNicName
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    monitoringResourceGroupName: monitoringResourceGroupName
    logWorkspaceName: monitoringResources.outputs.logWorkspaceName
    vmAddsDnsAdminPassword: vmAddsDnsAdminPassword
    vmAddsDnsAdminUsername: vmAddsDnsAdminUsername
    vmAddsDnsName: vmAddsDnsName
    vmAddsDnsSize: vmAddsDnsSize
  }
}


/*
  Spoke 1 resources
*/
//Checked

resource spoke1ResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: spoke1ResourceGroupName
  location: location
}

module spoke1Resources 'spokes/spoke1Resources.bicep' = {
  scope: spoke1ResourceGroup
  name: 'spoke1Resources_Deploy'
  dependsOn: [
    sharedResources
  ]
  params: {
    location:location
    tags: tags
    vnetInfo: spoke1VnetInfo 
    snetsInfo: spoke1SnetsInfo
    privateDnsZonesInfo: privateDnsZonesInfo 
    nicName: spoke1NicName
    deployCustomDns: deployCustomDnsOnSpoke1Vnet
    addsDnsNicName: addsDnsNicName
    sharedResourceGroupName: sharedResourceGroupName
    vmName: vmSpoke1Name
    vmSize: vmSpoke1Size
    vmAdminUsername: vmSpoke1AdminUsername
    vmAdminPassword: vmSpoke1AdminPassword
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    logWorkspaceName: monitoringResources.outputs.logWorkspaceName
    monitoringResourceGroupName: monitoringResourceGroupName
    storageAccountName: storageAccountName
    blobStorageAccountPrivateEndpointName: blobStorageAccountPrivateEndpointName
    blobPrivateDnsZoneName: privateDnsZonesInfo[0].name
  }
}

/* 
  Azure Virtual Desktop Network resources
*/
// Checked

resource avdResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: avdResourceGroupName
  location: location
}

module avdResources 'avd/avdResources.bicep' = {
  scope: avdResourceGroup
  name: 'avdResources_Deploy'
  dependsOn: [
    sharedResources
    spoke1Resources
  ]
  params: {
    location:location
    tags: tags
    vnetInfo: avdVnetInfo 
    snetsInfo: avdSnetsInfo
    privateDnsZonesInfo: privateDnsZonesInfo 
    deployCustomDns: deployCustomDnsOnSpoke1Vnet
    addsDnsNicName: addsDnsNicName
    sharedResourceGroupName: sharedResourceGroupName
  }
}

/*
  Network connectivity and security
*/
// Checked

resource securityResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: securityResourceGroupName
  location: location
}

resource hubResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: hubResourceGroupName
  location: location
}

module hubResources 'hub/hubResources.bicep' = {
  scope: hubResourceGroup
  name: 'hubResources_Deploy1'
  dependsOn: [
    securityResourceGroup
    sharedResources
    avdResources
  ]
  params: {
    location:location
    tags: tags
    securityResourceGroupName: securityResourceGroupName
    vwanName: vwanName
    hubInfo: hubVnetInfo
    monitoringResourceGroupName: monitoringResourceGroupName
    logWorkspaceName: monitoringResources.outputs.logWorkspaceName
    hubResourceGroupName: hubResourceGroupName
    fwPolicyInfo: fwPolicyInfo
    appRuleCollectionGroupName: appRuleCollectionGroupName
    appRulesInfo: appRulesInfo
    networkRuleCollectionGroupName: networkRuleCollectionGroupName
    networkRulesInfo: networkRulesInfo 
    dnatRuleCollectionGroupName: dnatRuleCollectionGroupName
    fwPublicIpName: fwPublicIpName
    firewallName:firewallName
    destinationAddresses: privateTrafficPrefix
    hubVnetConnectionsInfo: hubVnetConnectionsInfo
  }
}


/*
  Outputs
*/

output logWorkspaceName string = monitoringResources.outputs.logWorkspaceName

