
# Office 365 Admin Credentials
$credpath = "C:\Users\mlevy\Documents\PhotoUploadSecret.txt"
$global:adminCredential = Import-Clixml -Path $credpath
$photoPath = "\\Network\Share\Photos Folder"

#Import-Module MSOnline

Write-Host -ForegroundColor Green "Connecting to Office 365 ..."
$Office365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $adminCredential -Authentication Basic -AllowRedirection
Import-PSSession $Office365Session -AllowClobber -WarningAction SilentlyContinue -EA SilentlyContinue
#Connect-MSOLService -Credential $adminCredential 

Write-Host -ForegroundColor Green "Collecting photo files in the $($photoPath) directory..."
$photos = gci -Path $photoPath\*.jpg

Write-Host -ForegroundColor Magenta "Found $($photos.count) files to upload to user accounts..."


Foreach ($file in $photos) 
{
        
       $user = $file.name -ireplace (".jpg","")
       if ($Office365Session.state -eq "Broken"){
       Write-Host -ForegroundColor DarkYellow "Reconnecting to Office 365"
       Connect-PSSession $Office365Session
       Write-Host -ForegroundColor Green "Updating photo for $($user)"
       Set-UserPhoto -Identity $user -PictureData ([System.IO.File]::ReadAllBytes($file.FullName)) -Confirm:$false
            }
       Else {
       Write-Host -ForegroundColor Green "Updating photo for $($user)"
       Set-UserPhoto -Identity $user -PictureData ([System.IO.File]::ReadAllBytes($file.FullName)) -Confirm:$false
       }
}

Write-Host -ForegroundColor Green "Disconnecting from Office 365 ..."

Remove-PSSession $Office365Session
