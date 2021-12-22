# Warning: Running this script multiple times will cause the admin
# password for the VMs to be changed. Comment and uncomment properly.

Import-Module Tools #  Comment if you prefer to set up the vm Admin Password parameters manually.

#0..255 | Foreach-Object {"$_ : $([char]$_)"}

# Comment the variables below whether you prefer to set up them manually or are running this script multiple times.
$vmJumpAdminPassword = randomPassword
$vmAddsDnsAdminPassword = randomPassword
$vmSpoke1AdminPassword = randomPassword

$deploymentName="Base-Deployment-$(New-Guid)"

$params = "{ \`"vmJumpAdminPassword\`":{\`"value\`": \`"${vmJumpAdminPassword}\`" }, \`"vmAddsDnsAdminPassword\`":{\`"value\`": \`"${vmAddsDnsAdminPassword}\`" }, \`"vmSpoke1AdminPassword\`":{\`"value\`": \`"${vmSpoke1AdminPassword}\`" }}"

# The deployment is applied at the subscription scope
# Ensure the parameters.json file is up to date
# For production deployments, update the deployment parameter file in the command below.
az deployment sub create -l westeurope -n $deploymentName --template-file '.\base\main.bicep' --parameters '.\parameters.json' --parameters $params