# Install Zabbix agent on Windows
# Tested on Windows Server 2016, 2019
# Version 1.05
# Created by Twikki
# Last updated 14/08/2019
# Installs Zabbix Agent 4.2.5


#Gets the server host name
$ServerHostname = "$ENV:COMPUTERNAME"


# Asks the user for the IP address of their Zabbix server
$ServerIP = Read-Host -Prompt 'What is your Zabbix server/proxy IP?'


# Creates Zabbix DIR
mkdir c:\zabbix


# Downloads version 4.2.5 from Zabbix.com
wget "https://www.zabbix.com/downloads/4.2.5/zabbix_agents-4.2.5-win-amd64.zip" -outfile c:\zabbix\zabbix-4.2.5.zip

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

# Unzipping file to c:\zabbix
Unzip "c:\Zabbix\zabbix-4.2.5.zip" "c:\zabbix"      


# Sorts files in c:\zabbix
Move-Item c:\zabbix\bin\zabbix_agentd.exe -Destination c:\zabbix


# Sorts files in c:\zabbix
Move-Item c:\zabbix\conf\zabbix_agentd.conf -Destination c:\zabbix

# Replaces 127.0.0.1 with your Zabbix server IP in the config file
(Get-Content -Path c:\zabbix\zabbix_agentd.conf) | ForEach-Object {$_ -Replace '127.0.0.1', "$ServerIP"} | Set-Content -Path c:\zabbix\zabbix_agentd.conf

# Replaces hostname in the config file
(Get-Content -Path c:\zabbix\zabbix_agentd.conf) | ForEach-Object {$_ -Replace 'Windows host', "$ServerHostname"} | Set-Content -Path c:\zabbix\zabbix_agentd.conf

# Attempts to install the agent with the config in c:\zabbix
c:\zabbix\zabbix_agentd.exe --config c:\zabbix\zabbix_agentd.conf --install

# Attempts to start the agent
c:\zabbix\zabbix_agentd.exe --start

# Creates a firewall rule for the Zabbix server
New-NetFirewallRule -DisplayName "Allow Zabbix communication" -Direction Inbound -Program "c:\zabbix\zabbix_agentd.exe" -RemoteAddress LocalSubnet -Action Allow
