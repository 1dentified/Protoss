$domains = import-csv "C:\autobrowser\top500.domains.05.18.csv"

$domains = $domains |select url

while(1 -eq 1){

$dnum = get-random -min 0 -max 499

$http = "https://" +$domains[$dnum].url

write-host "starting process and browsing to " + $http
start-process iexplore  $http

$tnum = get-random -min 1 -max 300
start-sleep $tnum

stop-process -Name iexplore

}   
   