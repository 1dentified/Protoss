#User Activity Simulation
#make password file 
read-host -assecurestring | convertfrom-securestring | out-file C:\logins-auto\cred.txt
#set up globals
$users = get-aduser -SearchBase "OU=GloboUsers,DC=globomantics,DC=local" -SearchScope OneLevel -filter {name -like "*"}
$computers = get-adcomputer -SearchBase "OU=GloboComps,DC=globomantics,DC=local" -SearchScope Subtree  -filter {name -like "*"}

$password = get-content C:\Logins-Auto\cred.txt |ConvertTo-SecureString



#start loop here

while(1)
{

    #select user
    $user_max = $users.count - 1
    $uc = get-random -Minimum 0 -Maximum $user_max
    $user = $users[$uc].samaccountname
    $user = "globomantics\$user"
    #create credential
    $credential = new-object -typename System.Management.Automation.PSCredential -ArgumentList $user,$password

    #select computer
    $comp_max = $computers.count - 1
    $rc = get-random -Minimum 0 -Maximum $comp_max
    $comp1 = $computers[$rc].name
    #computer 2 for actions that require it
    $rc2 = get-random -Minimum 0 -Maximum $comp_max
    $comp2 = $computers[$rc2].name
    #select and run action
    $action = get-random -Minimum 0 -Maximum 1
    $action
    



    switch ($action)
    {
    

        #Open a file
        0 { invoke-command -ComputerName $comp1 -Credential $credential -scriptblock {start-process notepad.exe} -AsJob }
        # remote ps session to another computer
        1 { invoke-command -ComputerName $comp1 -Credential $credential -argumentlist $comp2,$credential -ScriptBlock {new-pssession -Credential $args[1] -name woop -ComputerName $args[0]; start-sleep 10; remove-pssession -name woop; } -asjob }
        


    }

    write-host  "Ran action now waiting!"
    start-sleep 10
}
#
