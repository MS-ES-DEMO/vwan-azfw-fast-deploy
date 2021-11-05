
param location string = resourceGroup().location
param tags object
param name string 



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2021-06-01' = {
  parent: storageAccount
  name: 'default'
}
