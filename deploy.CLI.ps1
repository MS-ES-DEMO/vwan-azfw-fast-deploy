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

$params = "{ \`"adminUsername\`":{\`"value\`": \`"${adminUsername}\`" }}"

az deployment sub create -l $location -n $deploymentName --template-file $templateFile --parameters $parameterFile --parameters $params