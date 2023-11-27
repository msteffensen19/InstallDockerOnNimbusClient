param($Step="A")
# -------------------------------------
# Imports
# -------------------------------------
$script = $myInvocation.MyCommand.Definition
$scriptPath = Split-Path -parent $script
. (Join-Path $scriptpath functions.ps1)


Clear-Any-Restart

if (Should-Run-Step "A") 
{
    Write-Host "Installing Windows Containers feature ..."
    Install-WindowsFeature -Name Containers
	
	Write-Host "----------"	
	Write-Host "Updating Path to include C:\Program Files\Docker  ..."
	$old = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path).path
	$new = "$old;C:\Program Files\Docker"
	Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path -Value $new
	Write-Host "----------"	
	Write-Host "The installation script will continue after a reboot."
	Write-Host ""
    read-host "Press ENTER to reboot " 
    Restart-And-Resume $script "B"
}

if (Should-Run-Step "B") 
{
	Write-Host "----------"
	Write-Host "Installing Docker Repository ..."

    Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
	
	Write-Host "----------"
	Write-Host "Installing Docker - this can take a couple of minutes ..."
    # Install-Package -Name docker -ProviderName DockerMsftProvider -Force -RequiredVersion 20.10.6
    # Start-Service Docker
    # Enable-WindowsOptionalFeature -Online -FeatureName Containers
    Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1" -o install-docker-ce.ps1
    .\install-docker-ce.ps1
    
        Write-Host "----------"
	Write-Host "Updating LRE Chrome bookmarks ..."
    xcopy /y C:\Users\demo\InstallDockerOnNimbusClient\Bookmarks "C:\Users\demo\AppData\Local\Google\Chrome\User Data\default\"
    del   C:\Users\demo\InstallDockerOnNimbusClient\Bookmarks
    
    	Write-Host "----------"
	Write-Host "Copying Soft Ether SAP VPN Import file to C:\Tools ..."
    xcopy /y C:\Users\demo\InstallDockerOnNimbusClient\SAP-VPN-Import.vpn "C:\Tools\"
    del   C:\Users\demo\InstallDockerOnNimbusClient\SAP-VPN-Import.vpn
	
	Write-Host "----------"
	Write-Host "Installing docker-compose and docker-app ..."
	cd C:\
 	New-Item -ItemType Directory -Path $Env:ProgramFiles\Docker
    # Old form - curl.exe -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-Windows-x86_64.exe -o "C:\Program Files\Docker\docker-compose.exe"
    Start-BitsTransfer -Source "https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-windows-x86_64.exe" -Destination $Env:ProgramFiles\Docker\docker-compose.exe
    # Doesn't appear to work with newer docker-app v0.8.0
    Start-BitsTransfer -Source "https://github.com/docker/app/releases/download/v0.6.0/docker-app-windows.tar.gz" -Destination $Env:ProgramFiles\Docker\docker-app-windows.tar.gz
    tar xvzf $Env:ProgramFiles\Docker\docker-app-windows.tar.gz -C $Env:ProgramFiles\Docker
    Move-Item -Path $Env:ProgramFiles\Docker\docker-app-windows.exe -Destination $Env:ProgramFiles\Docker\docker-app.exe
    del $Env:ProgramFiles\Docker\docker-app-windows.tar.gz
	
	Write-Host "----------"	
	Write-Host "Installing nimbusapp ..."
	cd C:\
    git clone https://github.com/msteffensen19/InstallNimbusappEverywhere.git
    cd C:\InstallNimbusappEverywhere\Windows
    .\InstallNimbusapp.bat
	
	Write-Host "----------"	
	Write-Host "Installing NimbusAliasesEverywhere ..."
	cd C:\
    git clone https://github.com/msteffensen19/InstallNimbusAliasesEverywhere.git
    cd C:\InstallNimbusAliasesEverywhere\Windows
    .\InstallNimbusAliases.bat 
    
	Write-Host "----------"	
	Write-Host "Installing Admin PowerShell shortcut on Desktop ..."
    copy-item "$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" "C:\users\demo\Desktop"
    Rename-Item -Path "$Home\Desktop\Windows PowerShell.lnk" -NewName "$Home\Desktop\Admin PowerShell.lnk"
    $bytes = [System.IO.File]::ReadAllBytes("$Home\Desktop\Admin PowerShell.lnk")
    $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
    [System.IO.File]::WriteAllBytes("$Home\Desktop\Admin PowerShell.lnk", $bytes)
}
Write-Host "----------"
nimbusapp --version
Write-Host "----------"

Write-Host   "==========================================================================================="
Write-Output "|                                                                                         |"
Write-Output "| To run LoadRunner Enterprise as a container, open an Admin Powershell and type:         |"
Write-Output "| nimbusapp lre:latest up                                                                 |"
Write-Output "|                                                                                         |"
Write-Host   "==========================================================================================="
Write-Host   ""
Write-Host   "This Docker-on-NimbusClient installation script is Complete."
Write-Host   ""
Write-Host   ""
read-host    "Press ENTER to exit the script "
