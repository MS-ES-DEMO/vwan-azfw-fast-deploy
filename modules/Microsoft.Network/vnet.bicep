
param location string = resourceGroup().location
param tags object
param vnetInfo object 
param addsDnsNicName string
param sharedResourceGroupName string
param deployCustomDns bool
param snetsInfo array

resource dnsNic 'Microsoft.Network/networkInterfaces@2021-02-01' existing = if (deployCustomDns) {
  name: addsDnsNicName
  scope: resourceGroup(sharedResourceGroupName)
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetInfo.name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetInfo.range
      ]
    }
    dhcpOptions: {
      dnsServers: (deployCustomDns) ? [
        dnsNic.properties.ipConfigurations[0].properties.privateIPAddress
        '168.63.129.16'
      ] : json('null')
    }
    subnets: [ for snetInfo in snetsInfo : {
      name: '${snetInfo.name}'
      properties: {
        addressPrefix: '${snetInfo.range}'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
      }
    }]
  }
}
