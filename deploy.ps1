# Warning: Running this script multiple times will cause the admin
# password for the VMs to be changed.

Import-Module Tools

#0..255 | Foreach-Object {"$_ : $([char]$_)"}
#$vmJumpAdminPassword = randomPassword
$vmJumpAdminPassword = 'xj48TCd3ErvxzCCqNktELCp4OK2JSqxW9Q'
#$vmAddsDnsAdminPassword = randomPassword
$vmAddsDnsAdminPassword = 'G6vOWZ1DrmUZaAP0maOgWJhDMAAkS5z'
#$vmSpoke1AdminPassword = randomPassword
$vmSpoke1AdminPassword = 'dILgegRUB/VL/4dR1kGd/CV0ikZXs'

$deploymentName="Lz-Deployment-$(New-Guid)"

$params = "{ \`"vmJumpAdminPassword\`":{\`"value\`": \`"${vmJumpAdminPassword}\`" }, \`"vmAddsDnsAdminPassword\`":{\`"value\`": \`"${vmAddsDnsAdminPassword}\`" }, \`"vmSpoke1AdminPassword\`":{\`"value\`": \`"${vmSpoke1AdminPassword}\`" }}"

# The deployment is applied at the subscription scope
# TODO: Ensure the parameters.json file us up to date
# TODO: For production deployments, update the deployment parameter file in the command below.
az deployment sub create -l westeurope -n $deploymentName --template-file '.\base\main.bicep' --parameters '.\parameters.json' --parameters $params