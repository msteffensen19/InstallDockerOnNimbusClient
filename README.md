# InstallDockerOnNimbusClient
Install Docker on NimbusClient machines running Windows Server Standard 2019.

This PowerShell script will install Docker on a NimbusClient VM.
This is done to allow running LoadRunner Enterprise as a container
on NimbusClient machines instead of on NimbusWindows VMs.

To install this, just clone this repo into any folder and then 
select the InstallDockerOnNimbusClient.ps1 file and right click
the file and select Run with PowerShell. This will start a PowerShell
command window which will first install a Docker repository and then
install Docker on Windows. It will then ask to reboot the machine and
continue installing other utilities. After everything installs, it
will run the "nimbusapp --version" command to verify that docker
and nimbusapp are installed and working properly.

As part of the installation, a modified version of nimbusapp is
installed which kills the LR Agent (magentproc.exe) when a "nimbusapp 
lre start" command is run (or up) since the agent conflicts with an LRE process,
and it also starts the LRE Agent when a "nimbusapp lre stop" (or down) command is run.

Other tasks include:
* Installs docker-compose and docker-app
* Installs nimbusapp 1.6.0-ms (modified for Windows and LRE)
* Installs InstallNimbusAliasesEverywhere - this installs common Nimbus aliases (dps, dpsa, di, de) on Windows CMD and PowerShell
* Updates the Path env variable to include C:\Program Files\Docker
* Installs Passwords.txt on the desktop for common container passwords
* Installs an updated set of Chrome bookmarks for LRE to run on NimbusClient

