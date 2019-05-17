echo

plink.exe -v -ssh -batch  gadmin@10.102.2.10 -pw globorocks  "cat /etc/group |grep admin; cat /etc/passwd"

timeout /t 10 /nobreak