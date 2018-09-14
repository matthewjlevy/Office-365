$cred = Get-Credential
Connect-AzureAD -Credential $cred

$invitations = import-csv 'C:\Users\Matt\OneDrive - NBConsult\Documents\Azure AD\LavalampB2Bguests.csv'
$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo
$messageInfo.customizedMessageBody = "Hey there! Check this out. I created an invitation through PowerShell"

$email.name = "MatthewJLevy"
$email.InvitedUserEmailAddress = 'matt.hew.jlevy@gmail.com'

foreach ($email in $invitations) {
Write-Host $email.name, $email.invitedUserEmailAddress
}
{New-AzureADMSInvitation -InvitedUserEmailAddress $email.InvitedUserEmailAddress -InvitedUserDisplayName $email.Name -InviteRedirectUrl https://wingtiptoysonline-dev-ed.my.salesforce.com -InvitedUserMessageInfo $messageInfo -SendInvitationMessage $true}


New-AzureADMSInvitation -InvitedUserEmailAddress $email.InvitedUserEmailAddress -SendInvitationMessage $true -InviteRedirectUrl https://nbconsulting.sharepoint.com -InvitedUserMessageInfo $messageInfo