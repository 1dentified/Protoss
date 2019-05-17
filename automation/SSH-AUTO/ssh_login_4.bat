echo

plink.exe -v -ssh -batch  gadmin@10.102.2.10 -pw globorocks  "ifconfig; ping 10.102.2.1; service apache status; cat /var/log/apache/apache*"


timeout /t 10 /nobreak