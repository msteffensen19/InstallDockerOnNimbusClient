# InstallDockerOnNimbusClient
Install Docker on NimbusClient machine.

This Powershell script will install Docker on a NimbusClient VM.
This is done to allow running LoadRunner Enterprise as a container.
Just clone this repo into any folder and then double-click the
InstallDockerOnNimbusClient.ps1 file. This will start a Powershell
command window which will first install a Docker repository and then
install Docker on Windows. It will then reboot the machine and
continue installing other utilities. After everything installs, it
will run the h"nimbusapp --version" command to verify that docker
and nimbusapp are working properly.

After the installation you should update your browser shortcuts for
LRE LoadTest and LRE Admin to replace NimbusWindows.aos.com with
NimbusClient.aos.com.

Other utilities installed include:
* docker-compose and docker-app
* nimbusapp 1.5.0 (modified for Windows and LRE)
* InstallNimbusAliasesEverywhere - this installs common aliases
* Updates the Path env variable to include C:\Program Files\Docker

