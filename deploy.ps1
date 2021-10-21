# Warning: Running this script multiple times will cause the admin
# password for the VMs to be changed.

Import-Module Tools
randomPassword


$vmJumpAdminPassword = randomPassword
$vmAddsDnsAdminPassword = randomPassword
$vmSpoke1AdminPassword = randomPassword

$deploymentName="Lz-Deployment-$(New-Guid)"

$params = "{ \`"vmJumpAdminPassword\`":{\`"value\`": \`"${vmJumpAdminPassword}\`" }, \`"vmAddsDnsAdminPassword\`":{\`"value\`": \`"${vmAddsDnsAdminPassword}\`" }, \`"vmSpoke1AdminPassword\`":{\`"value\`": \`"${vmSpoke1AdminPassword}\`" }}"

# The deployment is applied at the subscription scope
# TODO: Ensure the parameters.json file us up to date
# TODO: For production deployments, update the deployment parameter file in the command below.
az deployment sub create -l westeurope -n $deploymentName --template-file '.\lz\main.bicep' --parameters '.\parameters.json' --parameters $params