param (
  [Parameter(Mandatory = $true)]
  [securestring]
  $adminPassword,
  [string]
  $location = "westeurope",
  [string] 
  $templateFile = ".\base\main.bicep",
  [string]
  $parameterFile = "parameters.default.json",
  [string] 
  $deploymentPrefix='vWAN-Hub-Spoke'
  )

$deploymentName="$deploymentPrefix-$(New-Guid)"

New-AzDeployment -Name $deploymentName `
                -Location $location `
                -TemplateFile $templateFile `
                -TemplateParameterFile  $parameterFile `
                -vmJumpAdminPassword $adminPassword `
                -vmAddsDnsAdminPassword $adminPassword `
                -vmSpoke1AdminPassword $adminPassword `
                -WhatIf

##az deployment sub create -l westeurope -n $deploymentName --template-file '.\base\main.bicep' --parameters '.\parameters.json' --parameters $params