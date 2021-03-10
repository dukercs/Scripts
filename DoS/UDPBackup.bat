
@echo on && SETLOCAL ENABLEDELAYEDEXPANSION
:: Script para backup do banco do UDP
:: Autor: Rodolpho Costa Stach
:: Função: Criar um backup com o comando nativo ConsoleMigration.exe, compactar e enviar para o servidor de arquivos, apagar após para poder criar novo

:: Pegar dia da semana e coloca na variavel SEMANA
for /F "tokens=2 skip=2 delims=," %%D in ('WMIC Path Win32_LocalTime Get DayOfWeek /Format:csv') do set SEMANA=%%D

:: Variaveis do script
set CAMINHOEXE="%ProgramFiles%\Arcserve\Unified Data Protection\management\BIN\Appliance"
set BKP="%ProgramFiles%\Arcserve\Unified Data Protection\management\BIN\Appliance\DB_Migration"
set UNC="\\SERVER-REMOTO\GERAL\SISTEMA\BaseUDP"
set ZIPNAME=bkp-%SEMANA%.zip
set ZIPDIR=D:\BACKUP\UDP

:: Acessa o caminho do executavel
cd /d %CAMINHOEXE%


:: Remove a pasta gerada de backup padrão é a DB_Migration 
:: Necessario pois ao tentar rodar o comando se a pasta existis ele pergunta se deve sobreescrever e nao tem como forçar a resposta 'y'
IF EXIST %BKP% (
	rmdir /q/s C:\Temp\DB_Migration >nul
	move /Y %BKP% C:\Temp\
)

%CAMINHOEXE%\ConsoleMigration.exe -BackupDB

IF EXIST %ZIPDIR%\%ZIPNAME% (
	del %ZIPDIR%\%ZIPNAME%
)

7z a -tzip %ZIPDIR%\%ZIPNAME% %BKP% >nul

robocopy %ZIPDIR% %UNC% %ZIPNAME%
