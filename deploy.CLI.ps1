param (
  [Parameter(Mandatory = $true)]
  [string]
  $adminPassword,
  [Parameter(Mandatory = $true)]
  [string]
  $domainAdminPassword,
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

$params = "{ \`"domainAdminPassword\`":{\`"value\`": \`"${domainAdminPassword}\`" }, \`"vmAddsDnsAdminPassword\`":{\`"value\`": \`"${adminPassword}\`" }, \`"vmSpoke1AdminPassword\`":{\`"value\`": \`"${adminPassword}\`" }}"


az deployment sub create -l $location -n $deploymentName --template-file $templateFile --parameters $parameterFile --parameters $params