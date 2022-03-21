param (
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

az deployment sub create -l $location -n $deploymentName --template-file $templateFile --parameters $parameterFile 