@echo off
cls
if "%1" equ "" (
cls
@echo -----------------------
@echo Please specify 32 or 64
@echo -----------------------
@echo,
pause
exit
)

set root=%cd%
@echo .OPTION EXPLICIT>"%root%\za.ddf"
@echo .Set CabinetNameTemplate=zau_%1.cab>>"%root%\za.ddf"
@echo .Set Cabinet=on>>"%root%\za.ddf"
@echo .Set Compress=on>>"%root%\za.ddf"
@echo "zabbix_agentd.exe">>"%root%\za.ddf"
@echo "zabbix_get.exe">>"%root%\za.ddf"
@echo "zabbix_sender.exe">>"%root%\za.ddf"
@echo .Set DestinationDir=dev>>"%root%\za.ddf"
@echo "dev\zabbix_sender.dll">>"%root%\za.ddf"
@echo "dev\zabbix_sender.h">>"%root%\za.ddf"
@echo "dev\zabbix_sender.lib">>"%root%\za.ddf"

cd %root%\win%1
makecab /F "%root%\za.ddf"
move /y "%root%\win%1\disk1\zau_%1.cab" "%root%"
cd ..
del /S /F /Q *.ddf *.inf *.rpt
rd /S /Q "%root%\win%1\disk1"

pause
