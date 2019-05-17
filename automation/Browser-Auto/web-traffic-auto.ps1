#awesome

import-module activedirectory

$users = get-aduser -filter *

$users[0]

$Exec_computers = Get-ADComputer -filter {name -like "Exec*"}

$HR_computers = Get-ADComputer -filter {name -like "HR*"}

$Eng_computers = Get-ADComputer -filter {name -like "Eng*"}

$Fin_computers = Get-ADComputer -filter {name -like "Finance*"}

$All_Clients = $Exec_computers + $HR_computers + $Eng_computers + $Fin_computers


#users selection by appropriate group for later add on.
###for now just random selection of users


#copy files to all machines
function Copy_all($source, $dest){

$source = "C:\autobrowser"
$Max = $All_Clients.count - 1
$b = 0
while($b -lt $Max){


$dest = $All_Clients[$b]
$dest = "\\" + $dest.name + "\c$\"

Copy-Item -Path $source -Destination $dest -Recurse -Force
$b++


}



#start auto browser on all client computers
$comps = $All_Clients.name

Foreach($comp in $comps){


invoke-command -computername $comp -Scriptblock {powershell.exe -file C:\autobrowser\autobrowse.ps1} -asjob -JobName "WebSesh+$comp"

}