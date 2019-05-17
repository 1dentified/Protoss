echo

plink.exe -v -ssh -batch  gadmin@10.102.2.10 -pw globorocks  "top"

wait 30

exit

timeout /t 10 /nobreak