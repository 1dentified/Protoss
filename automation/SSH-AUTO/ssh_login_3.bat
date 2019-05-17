echo

plink.exe -v -ssh -batch  gadmin@10.102.2.10 -pw globorocks  "ifconfig; ping 10.102.2.1"

timeout /t 10 /nobreak