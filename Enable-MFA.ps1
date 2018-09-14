$Credential = (Get-Credential -Message "Supply credentials for O365")
Connect-MsolService -Credential $Credential

#Complete the full path to your exceptions file below
$exceptions = Import-Csv 'C:\users\Matt\OneDrive - NBConsult\Documents\Powershell Scripts\Office 365\MFAExceptions.csv'

$auth = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement

$auth.RelyingParty = "*"
$auth.State = "Enforced"
$auth.RememberDevicesNotIssuedBefore = (Get-Date)

$users = Get-MsolUser -All | select UserPrincipalName,StrongAuthenticationRequirements

$usernoMFA = $users | Where-Object {$_.StrongAuthenticationRequirements.state -ne "Enforced"}
$usernoMFA = $usernoMFA |Where-Object {$exceptions.Userprincipalname -notcontains $_.userprincipalname}

Foreach ($user in $usernoMFA)
{Set-MsolUser -UserPrincipalName $user.UserPrincipalName -StrongAuthenticationRequirements $auth}

