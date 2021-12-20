targetScope = 'subscription'

// Global Parameters

@description('Azure region where resource would be deployed')
@allowed([
  'northeurope'
  'westeurope'
])
param location string
@description('Deployment prefix for resources')
@allowed([
  'Dev'
  'Test'
  'Pre'
  'Uat'
  'Prod'
  'ProdDr'
])
param env string

// Resource Group Names

@description('Monitoring resource group name')
param monitoringResourceGroupName string
@description('vWAN Hub resource group name')
param hubResourceGroupName string
@description('Shared services resource group name')
param sharedResourceGroupName string
@description('Spoke resource group name')
param spoke1ResourceGroupName string
@description('Security resource group name')
param securityResourceGroupName string
@description('Azure Virtual Desktop resource group name')
param avdResourceGroupName string


// Monitoring resources

@description('Deploy Log Analytics Workspace?')
param deployLogWorkspace bool
@description('Existing Log Analytics Workspace name')
param existingLogWorkspaceName string = ''
@description('Diagnostic storage account name')
param diagnosticsStorageAccountName string


// Security resources


// Active Directory Domain Services resources

@description('Active Directory Domain Services virtual network name and range')
param dnsVnetInfo object = {
    name: 'vnet-addsdns'
    range: '10.0.1.0/24'
}
@description('Active Directory Domain Services virtual network subnet name and range')
param dnsSnetsInfo array = [
  {
  name: 'snet-addsdns'
  range: '10.0.2.0/26'
  }
]
@description('Active Directory Domain Services NSG rules amd name')
param dnsNicNsgInfo object = {
  name: 'nsg-nic-addsdns'
  inboundRules: [
    {
      name: 'rule1'
      rule: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '10.0.2.0/24'
        destinationAddressPrefix: '10.0.2.0/26'
        access: 'Allow'
        priority: 300
        direction: 'Inbound'
      }
    }
    {
      name: 'rule2'
      rule: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '10.0.2.0/24'
        destinationAddressPrefix: '10.0.2.0/24'
        access: 'Allow'
        priority: 301
        direction: 'Inbound'
      }
    }
  ]
}
@description('Name for ADDSDNS nic')
param addsDnsNicName string = 'nic-addsdns'
@description('Name for ADDSDNS vm')
param vmAddsDnsName string = 'vm-addsdns'
@description('Size for ADDSDNS vm')
param vmAddsDnsSize string = 'Standard_DS3_V2'
@description('Admin username for ADDSDNS vm')
@secure()
param vmAddsDnsAdminUsername string
@description('Admin password for ADDSDNS vm')
@secure()
param vmAddsDnsAdminPassword string


// Shared resources

@description('Name and range for shared services vNet')
param sharedVnetInfo object = {
    name: 'vnet-shared'
    range: '10.0.2.0/24'
}
@description('Name and range for shared subnets')
param sharedSnetsInfo array = [
  {
  name: 'snet-jump'
  range: '10.0.2.0/26'
  }
]
@description('Nsg info for Jump Nic')
param jumpNicNsgInfo object = {
  name: 'nsg-nic-jump'
  inboundRules: [
    {
      name: 'rule1'
      rule: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '10.0.1.0/24'
        destinationAddressPrefix: '10.0.1.0/26'
        access: 'Allow'
        priority: 300
        direction: 'Inbound'
      }
    }
    {
      name: 'rule2'
      rule: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '10.0.1.0/24'
        destinationAddressPrefix: '10.0.1.0/24'
        access: 'Allow'
        priority: 301
        direction: 'Inbound'
      }
    }
  ]
}

@description('Deploy Custom DNS on Shared Services vnet?')
param deployCustomDnsOnSharedVnet bool = true


// Spoke resources

@description('Name and range for spoke1 services vNet')
param spoke1VnetInfo object = {
    name: 'vnet-spoke1'
    range: '10.0.3.0/24'
}
@description('Name and range for spoke1 subnets')
param spoke1SnetsInfo array = [
  {
  name: 'snet-app'
  range: '10.0.3.0/26'
  }
  {
  name: 'snet-plinks'
  range: '10.0.3.64/26'
  }
]
@description('Nsg info for spoke1 Nic')
param spoke1NicNsgInfo object = {
  name: 'nsg-nic-spoke1'
  inboundRules: [
    {
      name: 'rule1'
      rule: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '10.0.1.0/24'
        destinationAddressPrefix: '10.0.1.0/26'
        access: 'Allow'
        priority: 300
        direction: 'Inbound'
      }
    }
    {
      name: 'rule2'
      rule: {
        protocol: 'Tcp'
        sourcePortRange: '*'
        destinationPortRange: '*'
        sourceAddressPrefix: '10.0.1.0/24'
        destinationAddressPrefix: '10.0.1.0/24'
        access: 'Allow'
        priority: 301
        direction: 'Inbound'
      }
    }
  ]
}
@description('Name for Spoke1 Nic')
param spoke1NicName string = 'nic-spoke1'
@description('Deploy Custom DNS on spoke1 vnet?')
param deployCustomDnsOnSpoke1Vnet bool = true
@description('Name for spoke1 vm')
param vmSpoke1Name string = 'vm-spoke1'
@description('Size for Spoke1 vm')
param vmSpoke1Size string = 'Standard_DS3_V2'
@description('Admin username for Spoke1 vm')
@secure()
param vmSpoke1AdminUsername string
@description('Admin password for Spoke1 vm')
@secure()
param vmSpoke1AdminPassword string

// Hub resources

@description('Name for VWAN')
param vwanName string = 'vwan-001'
@description('Name and range for Hub')
param hubInfo object = {
    name: 'hub-001'
    range: '10.0.0.0/24'
}
@description('Name and snat ranges for fw policy')
param fwPolicyInfo object = {
  name: 'fwpolicy-001'
  snatRanges: [
    '129.35.65.13'
    '82.132.128.0/17'
    '158.230.0.0/18'
    '158.230.64.0/19'
    '158.230.104.0/21'
    '158.230.112.0/20'
    '158.230.128.0/18'
    '193.35.171.0/24'
    '193.35.173.0/25'
    '193.113.120.0/25'
    '193.113.121.128/25'
    '193.113.160.0/25'
    '193.113.160.128/26'
    '193.113.200.128/25'
    '193.113.228.0/24'
    '193.132.40.0/24'
    '216.239.204.0/26'
    '216.239.204.192/26'
    '216.239.205.192/26'
    '216.239.206.0/25'
    '10.0.0.0/8'
    '172.16.0.0/12'
    '192.168.0.0/16'
    '100.64.0.0/10'
  ]
}
@description('Name for application rule collection group')
param appRuleCollectionGroupName string = 'fwapprulegroup'
@description('Rule Collection Info')
param appRulesInfo object = {
  priority: 300
  ruleCollections: [
    {
      ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
      action: {
        type: 'Allow'
      }
      name: 'AzureMonitorRuleCollection'
      priority: 100
      rules: [
        {
          ruleType: 'ApplicationRule'
          name: 'Allow-AzureMonitor'
          protocols: [
            {
              protocolType: 'Https'
              port: 443
            }
          ]
          fqdnTags: []
          webCategories: []
          targetFqdns: [
            format('*.monitor.{0}', environment().suffixes.storage)
          ]
          targetUrls: []
          terminateTLS: false
          sourceAddresses: [
            '*'
          ]
          destinationAddresses: []
          sourceIpGroups: []
        }
      ]
    }
  ]
}
@description('Name for application rule collection group')
param networkRuleCollectionGroupName string = 'fwnetrulegroup'
@description('Rule Collection Info')
param networkRulesInfo object = {
  priority: 200
  ruleCollections: [
    {
      ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
      name: 'Windows'
      action: {
        type: 'Allow'
      }
      priority: 210
      rules: [
        {
          ruleType: 'NetworkRule'
          sourceAddresses: [
            '*'
          ]
          destinationAddresses: [
            '*'
          ]
          destinationPorts: [
            '*'
          ]
          ipProtocols: [
            'Any'
          ]
          name: 'All-Traffic-Allowed'
          destinationIpGroups: []
          destinationFqdns: []
          sourceIpGroups: []
        }
      ]
    }
  ]
}
@description('Name for dnat rule collection group')
param dnatRuleCollectionGroupName string = 'fwdnatrulegroup'

@description('Name for Azure Firewall public ip')
param fwPublicIpName string = 'pip-fw'
@description('Name for Azure Firewall')
param firewallName string = 'azfw'
@description('Name for hub virtual connections')
param hubVnetConnectionsInfo array = [
  {
    name: 'hub-to-shared'
    remoteVnetName: 'vnet-shared'
    resourceGroup: sharedResourceGroupName
  }
  {
    name: 'hub-to-avd'
    remoteVnetName: 'vnet-avd'
    resourceGroup: avdResourceGroupName
  }
  {
    name: 'hub-to-spoke1'
    remoteVnetName: 'vnet-spoke1'
    resourceGroup: spoke1ResourceGroupName
  }
]
@description('Name for storage account')
param storageAccountName string = 'blob${toLower(env)}spoke1'
@description('Name for blob storage private endpoint')
param blobStorageAccountPrivateEndpointName string = 'plink-blob-spoke1'

// Azure Virtual Desktop resources

@description('Name and range for avd vNet')
param avdVnetInfo object = {
    name: 'vnet-avd'
    range: '10.0.4.0/23'
}
@description('Name and range for Azure Files subnet')
param azureFilesAvdSnetInfo array = [
  {
  name: 'snet-azurefiles'
  range: '10.0.4.0/27'
  }
]
@description('Name and range for new avd subnet')
param newAvdSnetInfo array = [
  {
  name: 'snet-hp-data-pers'
  range: '10.0.4.32/27'
  }
]
@description('Name and range for existing avd subnets')
param existingAvdSnetsInfo array = []


var avdSnetsInfo = union(azureFilesAvdSnetInfo, newAvdSnetInfo, existingAvdSnetsInfo) 


var privateDnsZonesInfo = [
  {
    name: format('privatelink.blob.{0}', environment().suffixes.storage)
    vnetLinkName: 'vnet-link-blob-to-'
    vnetName: 'vnet-addsdns'
  }
  {
    name: format('privatelink.file.{0}', environment().suffixes.storage)
    vnetLinkName: 'vnet-link-file-to-'
    vnetName: 'vnet-addsdns'
  }
  {
    name: format('privatelink{0}', environment().suffixes.sqlServerHostname)
    vnetLinkName: 'vnet-link-sqldatabase-to-'
    vnetName: 'vnet-addsdns'
  }
]

var tags = {
  ProjectName: 'WVD' // defined at resource level
  EnvironmentType: env // <Dev><Test><Uat><Prod><ProdDr>
  Location: 'AzureWestEurope' // <CSP><AzureRegion>
}

var privateTrafficPrefix = [
    '0.0.0.0/0'
    '172.16.0.0/12' 
    '192.168.0.0/16'
    '${sharedVnetInfo.range}'
    '${dnsVnetInfo.range}'
    '${spoke1VnetInfo.range}'
    '${avdVnetInfo.range}'
]


resource monitoringResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: monitoringResourceGroupName
  location: location
}

resource securityResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: securityResourceGroupName
  location: location
}

resource sharedResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: sharedResourceGroupName
  location: location
}

resource spoke1ResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: spoke1ResourceGroupName
  location: location
}

resource avdResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: avdResourceGroupName
  location: location
}

resource hubResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: hubResourceGroupName
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

module addsDnsResources 'addsdns/addsDnsResources.bicep' = {
  scope: sharedResourceGroup
  name: 'dnsResources_Deploy'
  dependsOn: [
    monitoringResources
    sharedResources
  ]
  params: {
    location:location
    tags: tags
    vnetInfo: sharedVnetInfo 
    nsgInfo: dnsNicNsgInfo
    snetsInfo: dnsSnetsInfo
    privateDnsZonesInfo: privateDnsZonesInfo    
    nicName: addsDnsNicName
    vmName: vmAddsDnsName
    vmSize: vmAddsDnsSize
    vmAdminUsername: vmAddsDnsAdminUsername
    vmAdminPassword: vmAddsDnsAdminPassword
    diagnosticsStorageAccountName: diagnosticsStorageAccountName
    logWorkspaceName: monitoringResources.outputs.logWorkspaceName
    monitoringResourceGroupName: monitoringResourceGroupName
  }
}

module sharedResources 'shared/sharedResources.bicep' = {
  scope: sharedResourceGroup
  name: 'sharedResources_Deploy'
  params: {
    location:location
    tags: tags
    vnetInfo: sharedVnetInfo 
    nsgInfo: jumpNicNsgInfo
    snetsInfo: sharedSnetsInfo
    privateDnsZonesInfo: privateDnsZonesInfo 
    deployCustomDns: deployCustomDnsOnSharedVnet
    addsDnsNicName: addsDnsNicName
    addsDnsResourceGroupName: sharedResourceGroupName
  }
}

module spoke1Resources 'spokes/spoke1Resources.bicep' = {
  scope: spoke1ResourceGroup
  name: 'spoke1Resources_Deploy'
  dependsOn: [
    sharedResources
    addsDnsResources
  ]
  params: {
    location:location
    tags: tags
    vnetInfo: spoke1VnetInfo 
    nsgInfo: spoke1NicNsgInfo
    snetsInfo: spoke1SnetsInfo
    privateDnsZonesInfo: privateDnsZonesInfo 
    nicName: spoke1NicName
    deployCustomDns: deployCustomDnsOnSpoke1Vnet
    addsDnsNicName: addsDnsNicName
    addsDnsResourceGroupName: sharedResourceGroupName
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

module avdResources 'avd/avdResources.bicep' = {
  scope: avdResourceGroup
  name: 'avdResources_Deploy'
  dependsOn: [
    addsDnsResources
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
    addsDnsResourceGroupName: sharedResourceGroupName
  }
}

module hubResources 'hub/hubResources.bicep' = {
  scope: hubResourceGroup
  name: 'hubResources_Deploy1'
  dependsOn: [
    securityResourceGroup
    addsDnsResources
    sharedResources
    avdResources
  ]
  params: {
    location:location
    tags: tags
    securityResourceGroupName: securityResourceGroupName
    vwanName: vwanName
    hubInfo: hubInfo
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

output logWorkspaceName string = monitoringResources.outputs.logWorkspaceName

