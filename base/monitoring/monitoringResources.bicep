// Global Parameters
param location string = resourceGroup().location
param env string
param tags object
param deployLogWorkspace bool
param existingLogWorkspaceName string
param diagnosticsStorageAccountName string

var logWorkspaceName = 'workspace-${toLower(env)}-base'

module logWorkspaceResources '../../modules/Microsoft.OperationalInsights/logWorkspace.bicep' = if (deployLogWorkspace) {
  name: 'logWorkspaceResources_Deploy'
  params: {
    location: location
    tags: tags
    name: logWorkspaceName
  }
}

resource existingLogWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (!deployLogWorkspace) {
  name: existingLogWorkspaceName
}

//Used by the diagnostics extension
module diagnosticsStorageAccount '../../modules/Microsoft.Storage/storageAccount.bicep' = {
  name: 'diagnosticsStorageAccountResources_Deploy'
  params: {
    location: location
    tags: tags
    name: diagnosticsStorageAccountName
  }
}

/* Section: Log Analytics Solutions */
module serviceMapSolution '../../modules/Microsoft.OperationsManagement/solutions.bicep' = {
  name: 'serviceMapSolutionResources_Deploy'
  params: {
    location: location
    tags: tags
    name: 'ServiceMap(${deployLogWorkspace ? logWorkspaceName : existingLogWorkspace.name})'
    workspaceResourceId: deployLogWorkspace ? logWorkspaceResources.outputs.workspaceId : existingLogWorkspace.id
    product: 'OMSGallery/ServiceMap'
    promotionCode: ''
    publisher: 'Microsoft'
  }
}

module vmInsightsSolution '../../modules/Microsoft.OperationsManagement/solutions.bicep' = {
  name: 'vmInsightsSolutionResources_Deploy'
  params: {
    location: location
    tags: tags
    name: 'VMInsights(${deployLogWorkspace ? logWorkspaceName : existingLogWorkspace.name})'
    workspaceResourceId: deployLogWorkspace ? logWorkspaceResources.outputs.workspaceId : existingLogWorkspace.id
    product: 'OMSGallery/VMInsights'
    promotionCode: ''
    publisher: 'Microsoft'
  }
}

module datasources '../../modules/Microsoft.OperationalInsights/datasources.bicep' = {
  name: 'datasources_Deploy'
  dependsOn: [
    logWorkspaceResources
  ]
  params: {
    tags: tags
    logWorkspaceName: deployLogWorkspace ? logWorkspaceName : existingLogWorkspaceName
  }
}

output logWorkspaceName string = deployLogWorkspace ? logWorkspaceResources.outputs.workspaceName : existingLogWorkspaceName
