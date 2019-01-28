@echo off



setlocal enabledelayedexpansion
for  %%a in ( exam*.tex ) do (
call makeclear
set jobfile=%%a
set jobname=!jobfile:~0,-4!
echo %%a
echo !jobfile!
echo !jobname!
echo !jobfile! >> makerecord.dat
xelatex.exe --synctex=-1 !jobfile!
xelatex.exe --synctex=-1 !jobfile!
xelatex.exe --synctex=-1 !jobfile!
)
setlocal DISABLEDELAYEDEXPANSION



::call makeclear

::pause
