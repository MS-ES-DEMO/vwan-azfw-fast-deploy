# Warning: Running this script multiple times will cause the admin
# password for the VMs to be changed. Comment and uncomment properly.

Import-Module Tools

#0..255 | Foreach-Object {"$_ : $([char]$_)"}
#$vmJumpAdminPassword = randomPassword
#$vmAddsDnsAdminPassword = randomPassword
#$vmSpoke1AdminPassword = randomPassword

$vmJumpAdminPassword = 'HMAK9Ig3cHIlZTxxguaGK1o3TC'
$vmAddsDnsAdminPassword = 'XgXqIlT6LYBydGnhvKd\cue/9q5k'
$vmSpoke1AdminPassword = '9M/fzsAfo59lm_Mzah32nMnE_\yACMqzo'

$deploymentName="Base-Deployment-$(New-Guid)"

$params = "{ \`"vmJumpAdminPassword\`":{\`"value\`": \`"${vmJumpAdminPassword}\`" }, \`"vmAddsDnsAdminPassword\`":{\`"value\`": \`"${vmAddsDnsAdminPassword}\`" }, \`"vmSpoke1AdminPassword\`":{\`"value\`": \`"${vmSpoke1AdminPassword}\`" }}"

# The deployment is applied at the subscription scope
# Ensure the parameters.json file is up to date
# For production deployments, update the deployment parameter file in the command below.
az deployment sub create -l westeurope -n $deploymentName --template-file '.\base\main.bicep' --parameters '.\parameters.json' --parameters $params