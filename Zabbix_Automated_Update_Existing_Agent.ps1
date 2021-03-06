#
# THIS SCRIPT IS READY TO USE
#

# Update Zabbix agent on Windows
# Tested on Windows Server 2016, Virtual Machine
# Version 1.01
# Created by Twikki
# Last updated 28/02/2019
# Attempts to install the latest version of Zabbix

### SERVICES
############################################################

# Attempts to stop the Zabbix service on the Windows machine
c:\zabbix\zabbix_agentd.exe --stop

# Attempts to uninstall the Zabbix agent on the Windows machine
c:\zabbix\zabbix_agentd.exe --uninstall

############################################################


### FILE DIRECTORIES
############################################################

# Creates Zabbix backup destination for Zabbix config file
mkdir c:\zabbix_backup

# Backs up the config file
Copy-Item c:\zabbix\*.conf -Destination c:\zabbix_backup

# Deletes the old contents
Remove-Item c:\zabbix -Force -Recurse

# Creates Zabbix folder again
mkdir c:\zabbix

# Downloads version 4.0.4 from Zabbix.com to c:\zabbix
wget "https://www.zabbix.com/downloads/4.0.4/zabbix_agents-4.0.4-win-amd64.zip" -outfile c:\zabbix\zabbix-4.0.4.zip

# Imports ZIP
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# Unzipping file to c:\zabbix
Unzip "c:\zabbix\zabbix-4.0.4.zip" "c:\zabbix"


# Sorts files in c:\zabbix
Move-Item c:\zabbix\bin\zabbix_agentd.exe -Destination c:\zabbix


# Sorts files in c:\zabbix
Move-Item c:\zabbix\conf\zabbix_agentd.win.conf -Destination c:\zabbix

# Copies the old config file back into the c:\zabbix
Copy-Item c:\zabbix_backup\*.conf -Destination c:\zabbix -Force

# Cleans up c:\zabbix_Backup folder
Remove-Item c:\zabbix_backup -Force -Recurse

# Attempts to install the agent with the config in c:\zabbix
c:\zabbix\zabbix_agentd.exe --config c:\zabbix\zabbix_agentd.win.conf --install

# Attempts to start the agent
c:\zabbix\zabbix_agentd.exe --start
