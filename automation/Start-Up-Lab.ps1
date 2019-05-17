##############################################################
#                th3m3ch4nic
#            Manages Globo Lab
#
#
#
##############################################################
<#
.SYNOPSIS
Used to manage the globmantics network and security equipment.

.FUNCTIONS
Start-Globolab

Shutdown-Globolab

Start-GloboSOC

Shutdown-GloboSOC
 
.DESCRIPTION

 
.PARAMETER

 
.EXAMPLE

 
.INPUTS

 
.OUTPUTS

 
.NOTES


#>

import-module vmware.powercli




$esxi_creds = get-credential root
#$Vcenter_creds = Get-Credential administrator@localhost.globomantics

#test connection to esxi1
#########################

#while($esxi1_up -eq $true){$esxi1_up = test-connection 10.101.1.149 -quiet;write-host "ESXI one connection is $esxi1_up"}


$esxi1 = connect-viserver 10.101.1.149 -Credential $esxi_creds #esxi that contains vcenter
$esxi2 = connect-viserver 10.101.1.138 -Credential $esxi_creds #esxi that contains endpionts
#remove from maintenancem mdoe
set-vmhost -VMHost "10.101.1.149" -State Connected
set-vmhost -VMHost "10.101.1.138" -State Connected
#delay for maintenance mode
start-sleep 10
$esxihost1 = get-vmhost|?{$_.name -eq "10.101.1.138"}
$esxihost2 = get-vmhost|?{$_.name -eq "10.101.1.149"}
#$vcenter = get-vm Globo-VC-01

#start-vm $vcenter



while($up -eq $false){
 
$up = test-connection 10.101.1.124 -quiet
write-host "VCenter_Up = $up"
}
Write-host "Vcenter is up now testing http connection"

##############Replace with a invoke-webrequest and inspect the return inspect traffic for correct uri
$VChttps = $false
while($VChttps -eq $false){
$Vchttps = test-netconnection -Port 443 -ComputerName 10.101.1.124
$VChttps = $VChttps.TcpTestSucceeded
write-host "Vcenter https connection status is $VChttps"
}
write-host "Vcenter https is up!"

Disconnect-VIServer $esxi1 -confirm

#connect-viserver 10.101.1.124 -Credential $Vcenter_creds

#Put hosts in non-maintenance mode
$esxihost1 | set-vmhost -state Connected
$esxihost2 | set-vmhost -state Connected

Start-sleep 10

##############Start All VM's#########################
#tmep

####Start up required domain services################
#Pfsense Firewall
$fwvm = get-vm -name "Globo-Firewall" -Server $esxi1
start-vm -VM $fwvm
#Domain Controller
$dcvm = get-vm -name "Globo-DC-01"
start-vm -VM $dcvm
#File and Print Server
$mpvm = get-vm -name "Globo-MP-01"
start-vm -VM $mpvm
#Managment Server 
$GTvm = get-vm -name "GloboTech-01"
start-vm -vm $GTvm
#Web Startup
$webVM = get-vm -name "Globo-WEB-01"
start-vm -vm $webVM

while(1 -eq 1){
#Get all HR VM's that are in powered off state and turn them on.
$HRvm = $null
$HRvm = get-vm * | ?{$_.PowerState -eq "PoweredOff" -and $_.name -like "HR-*"}
if($HRvm -eq $null){ write-host "All turned on boss!"}else{
$c = $HRvm.count
Write-Warning -Message "Turning on $c HR client machines."
start-vm -vm $HRvm
}

start-sleep 10

#Get all Exec VM's that are in powered off state and turn them on. 
$Execvm = $null
$Execvm = get-vm * | ?{$_.PowerState -eq "PoweredOff" -and $_.name -like "Exec-*"}
if($Execvm -eq $null){write-host "All turned on boss!"}else{
$c = $Execvm.count
Write-Warning -Message "Turning on $c machines." 
start-vm -vm $Execvm
}
start-sleep 10

#Get all Finance VM's that are in powered off state and turn them on.
$Finvm = $null
$Finvm = get-vm * | ?{$_.PowerState -eq "PoweredOff" -and $_.name -like "Finance-*"}
if($Finvm -eq $null){write-host "All turned on boss!"}else{
$c = $Finvm.count
Write-Warning -Message "Turning on $c machines."
start-vm -vm $Finvm
}
start-sleep 10

#Get all Engineering VM's that are in powered off state and turn them on.
$Engvm = $null
$Engvm = get-vm * | ?{$_.PowerState -eq "PoweredOff" -and $_.name -like "Engineering-*"}
if($Engvm -eq $null){write-host "All turned on boss!"}else{
$c = $Engvm.count
Write-Warning -Message "Turning on $c machines."
start-vm -vm $Engvm -confirm:$false
}
start-sleep 10
}

#####TURN IT ALL OFF!!!!!!#######
##################################

#Get all HR VM's that are in powered off state and turn them on.
$HRvm = get-vm * | ?{$_.PowerState -eq "PoweredOn" -and $_.name -like "HR-*"}
$c = $HRvm.count
Write-Warning -Message "Turning off $c HR client machines."
Shutdown-VMGuest -VM $HRvm -confirm:$false



start-sleep 10

#Get all Exec VM's that are in powered off state and turn them on. 
$Execvm = get-vm * | ?{$_.PowerState -eq "PoweredOn" -and $_.name -like "Exec-*"}
$c = $Execvm.count
Write-Warning -Message "Turning off $c machines." 
Shutdown-VMGuest -VM $Execvm -confirm:$false

start-sleep 10

#Get all Finance VM's that are in powered off state and turn them on.
$Finvm = get-vm * | ?{$_.PowerState -eq "PoweredOn" -and $_.name -like "Finance-*"}
$c = $Finvm.count
Write-Warning -Message "Turning off $c machines."
Shutdown-VMGuest -VM $Finvm -confirm:$false

start-sleep 10

#Get all Engineering VM's that are in powered off state and turn them on.
$Engvm = get-vm * | ?{$_.PowerState -eq "PoweredOn" -and $_.name -like "Engineering-*"}
$c = $Engvm.count
Write-Warning -Message "Turning off $c machines."
Shutdown-VMGuest -VM $Engvm -confirm:$false

####Shut down domain services################


#Domain Controller
$dcvm = get-vm -name "Globo-DC-01"
Shutdown-VMGuest -VM $dcvm -confirm:$false
#File and Print Server
$mpvm = get-vm -name "Globo-MP-01"
Shutdown-VMGuest -VM $mpvm -confirm:$false
#Managment Server 
$GTvm = get-vm -name "GloboTech-01"
Shutdown-VMGuest -vm $GTvm -confirm:$false
#Pfsense Firewall 
$fwvm = get-vm -name "Globo-Firewall"
Stop-VM -VM $fwvm -confirm:$false

start-sleep 30
###check all are off on exsi2 

####maintenance mode esxi2

Set-VMHost -VMHost "10.101.1.149" -state Maintenance -confirm:$false

##turn off vmhost
Stop-VMHost -VMHost "10.101.1.149" -confirm:$false

###shutdown vcenter
#get-vm -name "Globo-VC-01" |Shutdown-VMGuest -confirm:$false

###disconnect vi server vcenter
#Disconnect-VIServer -Server 10.101.1.124 -confirm:$false

###connect to last esxi server
#Connect-viserver -Server 10.101.1.149 -Credential $esxi_creds
get-vm *|?{($_.PowerState) -eq "Poweredon"} | Shutdown-VMGuest
get-vm *|?{($_.PowerState) -eq "Poweredon"} | stop-vm
###check to see if vcenter is off
$vcvm = get-vm -name "Globo-VC-01"

$vcvm = $vcvm.PowerState

While($vcvm -eq "PoweredOn"){

write-host "Waiting for Vcenter to shutdown"

start-sleep 10
}
write-host "Vcenter is off, proceding to esxi shutdown procedures ESXI"




###set vmhost to maintenacnem mode
Set-VMHost -VMHost 10.101.1.149 -state Maintenance -confirm:$false
Set-VMHost -VMHost 10.101.1.138 -state Maintenance -confirm:$false
###turn vmhost off

Stop-VMHost -VMHost 10.101.1.149 -confirm:$false
Stop-VMHost -VMHost 10.101.1.138 -confirm:$false

######turn off L3 Switch




###shutdown vcenter###
####


######################################################################




#join new machines to domain controller

#install software on all clients


###Initiate user protocol 1 #### SMB Logon-off


###Initiate user protocol 2 #### Http/s Random Traffic


###Initiate admin protocol 3 ### Diagnostic checks simulation


###File 

 
 ####################
#change new machines names
$localcred = get-credential -UserName tstark -Message "For pepper!"
$computername = read-host "Input computer IP to test."
test-netconnection -CommonTCPPort WINRM -ComputerName $computername 
Get-WmiObject -Class Win32_computersystem -ComputerName 10.102.5.5 # -Credential $localcred
invoke-command -ComputerName $computername -Credential $localcred -Authentication Credssp -ScriptBlock {getmac}
invoke-command -ComputerName $computername
 ########domain joined machines##########
 $domain_cred = globomantics\administrator
 
 get-aduser -Credential $domain_cred -Server 10.102.2.130






