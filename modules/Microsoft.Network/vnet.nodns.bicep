
param location string = resourceGroup().location
param tags object
param vnetInfo object


param snetsInfo array


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
