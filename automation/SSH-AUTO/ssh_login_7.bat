echo

plink.exe -v -ssh -batch  root@10.102.2.10 -pw globorocks  "help"

timeout /t 5 /nobreak 

plink.exe -v -ssh -batch  root@10.102.2.10 -pw globorocks  

timeout /t 10 /nobreak

plink.exe -v -ssh -batch root@10.102.2.10 -pw globorocks 

timeout /t 10 /nobreak