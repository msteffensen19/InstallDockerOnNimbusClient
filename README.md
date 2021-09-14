# InstallDockerOnNimbusClient
Install Docker on NimbusClient machines.

This Powershell script will install Docker on a NimbusClient VM.
This is done to allow running LoadRunner Enterprise as a container.
Just clone this repo into any folder and then double-click the
InstallDockerOnNimbusClient.ps1 file. This will start a Powershell
command window which will first install a Docker repository and then
install Docker on Windows. It will then reboot the machine and
continue installing other utilities. After everything installs, it
will run the "nimbusapp --version" command to verify that docker
and nimbusapp are working properly.

As part of the installation, a modified version of nimbusapp is
installed which kills LR Agent (magentproc.exe) when a "nimbusapp 
lre start" command is run (since the agent conflicts with an LRE process)
and it also starts the LRE agent when a "nimbusapp lre stop" command is run.

After the installation you should update your browser shortcuts for
LRE LoadTest and LRE Admin to replace NimbusWindows.aos.com with
NimbusClient.aos.com.

Other utilities installed include:
* docker-compose and docker-app
* nimbusapp 1.5.0 (modified for Windows and LRE)
* InstallNimbusAliasesEverywhere - this installs common Nimbus aliases
* Updates the Path env variable to include C:\Program Files\Docker

