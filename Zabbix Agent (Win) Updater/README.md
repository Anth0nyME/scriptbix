�������� ������������������ ��������� ����������������� ���������� ������� Zabbix ��� ��������� Windows (x86_64).  


**������:** 0.3  

**����������:**

* � ���������� ������ ������ ���� **���������** �������� ���������� ������
* ���������� c Windows 2008R2 (2008 �� �����������) �� Windows 2016 (��� ������������ ����������������� ��, ��������� ������������ ������� **POSH** ����� ������).
* ��������������� ��������, ����� ������ ����������� ���������, � 15:00 (��. **�.3.1**, ���������� � **�.4.3.3** /st, Start Time)
* ������ ������ MSCAB ��� ������ � ���� ��� ��������������� ��� ���� ������ Windows
* ���������� (�� �� �����������) ������������ ��������� ������ ��� ������ Windows
* ����� �������� � ��������� ��������� ������ ��� ��������� ���������, � ��� ��� ����� � ����� ����������
* ������ 32bit ����� ����� �������� ������������� � ��� ������, ���� � ��� � ����� ���� ������ � Windows 2008 � �� ��� ���������� **POSH**. � ������������ ����������� ��������, ��� ��� � ��� ���� � POSH ��� �����

**��� ��� ��������**

����� �������� **agent.version** ������������ � ������������ ��������� 1-7,13:00-18:00, ����� ������� �������� � ������ ��� ����� (���� 5-10 �����). ������ ���������� ������ � Task Scheduler ��������� � 15:00. �.�. ���� ����� �������� ������� (��� �������� ������) ������, �� �������� � 13:05-13:10 ����� ���������� ������� ����� ������������� � ��������� �������� � ���������� Action. �������� ����� 10 ����� ����� ��������� ������ � Task Scheduler. ��� �������� 13:15-13:20. ��������� ������ ���������� **������** ����������� ��� **%time:\~0,8%** (������� �����), ������ ������ ������ ����� ������������� �������� (�� ��������� �����) � �������� ����� ������ ������ ������. � ��������� ������ ���������� ���������� � 13:15 **�** ��� ������ � �������� = 60 ����� **�** ���������� ������ ��������� �� 15:00, �� ��������� ����������� ����� 14:15. � ��. ������, ��� ��������� ��������� ����� ������� ������ ��� 15:15, � ��� **���** �� ��������� ���������, ������������� ���������� /ET 15:00.

**������������������ ��������:**

*������ ������ ������ -> ������� �������� ������� ������ ������ -> ����������� ������� �������� ������ -> ����������� Action (������ ���� 5 �����): ����������� ����� (2-2), ����������� ������ � Tasks Scheduler (3-3) -> ����������� ������ �� ����������, ������������ ���������� ������ -> ������� �������� ������� ������ ������ -> ������� �� ������������ (������������� ������ ��������� � ���������)*

**��������:**

* Windows 2008 (� R2) �� ��������� �������� **/RI 0** (���������� ��������� ������� �������), ������� ��� ��������������� ���������� �� ���� �� 2008-2016 �������� ����������� � ����� ����. ������, ��������� ������ ������ ������� ������� �������� �� ������, �� � ����� �� ������������ (������������ ����� ��� �������� ������)
* �� ��������� ������������ Windows 2008R2 ��������� �������� ������: schtasks �� ��������� ������� �����, ��� �������� ������ ������

**ToDo:**

1. �������� ������ ��� ����������� ������� ����� ������ ������ �� ����� zabbix.com, ����������, ����������, ����������� ��������������� ������� Zabbix ��� Windows � ���������� CAB-������ � ������������ �� �� web-������ (�� ������� ��������� ������ ��������� �������, ����� �� ��������� �� ������� (�) �/� "�����").

**���������:**

1. ������������� ����� ������ � ������� CAB  
    1.1 ������� �� ���� ������-��������� CAB-������ (������� **CAB**)  
    1.2 ������� � ����� zabbix.com ������ ���� Zabbix, �� ������� "Zabbix Sources"  
    1.3 ����������� �����, �� �������� bin �����������\��������� � ������ �������-���������� 2 ����������� ��������� ������� (win32 � win64), ����������� ������  
    1.4 ��������� make_zcab.cmd � ������������ ���������� �������� (��� ��������� - �������)  

	*� ����� ������� �������� cab-����� � ������� ������ Zabbix ��������������� ������� ��������.*
	*����� �������� ��� ����� ������, ����� ����� ������������ (��� ������ ����������).*

    1.5 ���������� ����� ���������� �� ������� Zabbix, � ����� ������� �����, ��������� ����� HTTP(S) (�������� /var/www/html/agents/, https://zabbix.domain.com/agents/)  

2. ������� (���� �����������) ���������� ������ "{$ZABBIX_AGENT_VERSION}", ��������� ��� ����� ������ ����� ������ (��������, **3.4.4**)  

3. � ������� ����������� ������ Windows (��������, "Template_Zabbix_Agent_Win")  

    3.1 ������� ���������� ������ �������� agent.version ��������� � 0, �������� Flexible-����������: Period = 1-7,13:00-18:00, Interval = 15 �����  
    3.2 ��������������� (��� �������, ���� �����������) **�����������** ������� ����������� ������ ������: ��������, "{Template_Zabbix_Agent_Win:agent.version.str({$ZABBIX_AGENT_VERSION})}=0"  

4. ������� Action "���������� ������ Zabbix (Windows)" (��� - �� ���� ����������)  

	*Default operation step duration = 5m*  
	*Type of calculation = A and B (� ���������� �������� ����� ���� ������)*  

    4.1 � �������� ������� ������ ������, ��� ������� ����� ����������� ����� ��������������� ���������� (��������, "Host group = ��� ������� Windows")  
    4.2 � �������� ������� �� ������� "Template_Zabbix_Agent_Win" ����� ��������� ������� �����������: "Trigger = Template_Zabbix_Agent_Win: ������ ������ Zabbix ��������"  

    4.3 � �������� �������� Remote command:  
        4.3.1 **Steps 1-1** (������� ����������������): *cmd /c "@echo %DATE%,%TIME% Outdated Zabbix Agent detected: {ITEM.LASTVALUE}. Replace with {$ZABBIX_AGENT_VERSION}.>>%windir%\temp\zabbix_updater.log"*  
        4.3.2 **Steps 2-2** (���������� ������): *if "%PROCESSOR_ARCHITECTURE%" equ "AMD64" powershell -ExecutionPolicy Bypass -Command "& {(New-Object Net.WebClient).DownloadFile('https://zbx.domain.com/agents/zau_64.cab', '%windir%\temp\zau_64.cab')}"*  
        4.3.3 **Steps 3-3** (��������� ����������): *schtasks /create /TN "ZAU-{$ZABBIX_AGENT_VERSION}" /SC once /ST %time:\~0,8% /ET 15:00:00 /RI 60 /RU SYSTEM /RL HIGHEST /Z /TR "cmd /c taskkill /f /im zabbix_agentd.exe & extrac32 /e %windir%\temp\zau_64.cab /l \"%ProgramFiles%\Zabbix Agent\\\" /y & net start \"zabbix agent\""*  

	***����������:*** ���� ����� ���������� � ������ ������� - �������� ���� ����������. ���� ��������� ��� �� ��������� ������ 32bit, ��������� ������� ������ �������� ����� 4.3.2 (�������� ������� ������� �������� �� � �������� �������� ������) � 4.3.3 (�������� �������� ������). ������������� ���� ����� ����������� �����������.

**�����:**

������� ������ ������ (����� 2) � ���� ����������, �������. �����, ��� �� 2 ���� �� /ET (����� 4.3.3) � �� ����� ������� ����� ������ ������ ��� **������**!  

��� Task Scheduler ������������ ���� � /ST %time:~0,8%, ������� ��������� ��������� ������ **����������** ���� � ��� ������, ���� � ����� ���� ������ �������� /RI (������ ������ ������ ��������� ����� � ������ �������� ������).
�� ��� ����������� ����������� �����������: ������� �� ������ ������ (������� �� ������ 3.1) ����������� ������ ��������� **�� �����, ��� �� 2 ����** �� �������, ���������� � /ET.
���� �� ������ ������������ ���� 3-3 (����� 4.3.3), ������������ ������ � Task Scheduler, ������� ����� ������� �������� ����� (�������� /ST) � �������� ����������� ������ (�������� /ET) ����� **������ 1 ����** (������ ���� ������) - ���� ������ **�� ���������** � ����������!
