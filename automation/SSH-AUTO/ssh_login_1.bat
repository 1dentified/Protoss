echo

plink.exe -v -ssh -batch  gadmin@10.102.2.10 -pw globorocks  "cd /; ls -la"

timeout /t 10 /nobreak