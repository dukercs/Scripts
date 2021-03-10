@echo off && SETLOCAL ENABLEDELAYEDEXPANSION

:: Script para copia do backup do SQL 
:: Nome: CopiaSQLSRV01.bat
:: Autor: Rodolpho Costa Stach
:: Função: Executa a copia do compartilhamento \\SERVER-REMOTO\CompletoFull com robocopy para disco H:\SQL_SRV01 e cria LOG em H:\Log 
::o log sera  SERVER-REMOTO_<diadasemana>.log 
:: Opções: /MIR e /LOG:H:\Log\SERVER-REMOTO_<diadasemana>.log 

:: Variaveis globais
:: Pega o dia da semana como número (0 = Domingo, 1 = Segunda, 2 = Terça, 3 = Quarta, 4 = Quinta, 5 = Sexta, 6 = Sabado) e atriui a variavel SEMANA
for /F "tokens=2 skip=2 delims=," %%D in ('WMIC Path Win32_LocalTime Get DayOfWeek /Format:csv') do set SEMANA=%%D
set HOST=SERVER-REMOTO
set OPTS=/MIR /LOG:C:\SCRIPTS\LOGS\%HOST%.%SEMANA%.log
set UNC=\\SERVER-REMOTO\CompletoFull
set LOCAL=H:\SQL_SRV01


:: Comando de copia

robocopy %UNC% %LOCAL% %OPTS%
