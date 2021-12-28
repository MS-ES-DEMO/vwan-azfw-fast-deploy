param (
  [Parameter(Mandatory = $true)]
  [string]
  $adminUsername,
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
                -vmAddsDnsAdminUsername $adminUsername `
                -Verbose

