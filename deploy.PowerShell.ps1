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
                -vmAddsDnsAdminPassword $adminPassword `
                -vmSpoke1AdminPassword $adminPassword `
                -Verbose

