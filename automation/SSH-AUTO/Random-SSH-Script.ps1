cd C:\SSH-AUTO

###Randome SSH logins!####

while(1 -eq 1){

$time = get-random -Maximum 500 -Minimum 30
[string]$script = get-random -Maximum 10 -Minimum 1
write-host "running ssh_login_$script.bat now" -backgroundcolor green
start-process "ssh_login_$script.bat"

write-host " It is now $current_time. Running next ssh connection in $time seconds" -backgroundcolor yellow

start-sleep $time

}