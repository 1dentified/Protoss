echo

plink.exe -v -ssh -batch  globoadmin@10.102.2.10 -pw globorocks  "help"

timeout /t 5 /nobreak 

plink.exe -v -ssh -batch  ganalyst@10.102.2.10 -pw globorock  "cd /; ls -la"

timeout /t 5 /nobreak

plink.exe -v -ssh -batch ganalyst@10.102.2.10 -pw globorocks "service * status; history |more"

timeout /t 10 /nobreak