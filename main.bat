@echo off
title The Farmer Was Replaced
chcp 65001 >nul
goto banner

:banner
cls
echo.
echo.
echo				████████╗███████╗██╗    ██╗██████╗     ████████╗ ██████╗  ██████╗ ██╗     
echo				╚══██╔══╝██╔════╝██║    ██║██╔══██╗    ╚══██╔══╝██╔═══██╗██╔═══██╗██║     
echo				   ██║   █████╗  ██║ █╗ ██║██████╔╝       ██║   ██║   ██║██║   ██║██║     
echo				   ██║   ██╔══╝  ██║███╗██║██╔══██╗       ██║   ██║   ██║██║   ██║██║     
echo				   ██║   ██║     ╚███╔███╔╝██║  ██║       ██║   ╚██████╔╝╚██████╔╝███████╗
echo				   ╚═╝   ╚═╝      ╚══╝╚══╝ ╚═╝  ╚═╝       ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝                                                                      
echo 						Made by tariksabanuz
echo.
echo.

:menu
echo 1 = Edit a save
echo 2 = Unlock everything in a save
echo 3 = Leaderboard run
echo.
set /p keuze="Your choice: "

if "%keuze%"=="1" (
    cls
    goto edit_flow
)

if "%keuze%"=="2" (
    cls
    goto unlock_flow
)

if "%keuze%"=="3" (
    cls
    goto leaderboard_flow
)

echo Invalid choice.
pause
goto banner

:edit_flow
echo.
echo.
echo				████████╗███████╗██╗    ██╗██████╗     ████████╗ ██████╗  ██████╗ ██╗     
echo				╚══██╔══╝██╔════╝██║    ██║██╔══██╗    ╚══██╔══╝██╔═══██╗██╔═══██╗██║     
echo				   ██║   █████╗  ██║ █╗ ██║██████╔╝       ██║   ██║   ██║██║   ██║██║     
echo				   ██║   ██╔══╝  ██║███╗██║██╔══██╗       ██║   ██║   ██║██║   ██║██║     
echo				   ██║   ██║     ╚███╔███╔╝██║  ██║       ██║   ╚██████╔╝╚██████╔╝███████╗
echo				   ╚═╝   ╚═╝      ╚══╝╚══╝ ╚═╝  ╚═╝       ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝                                                                      
echo 						Made by tariksabanuz
echo.
echo.

call "%~dp0files\saves.bat"
if errorlevel 1 (
    pause
    goto banner
)

REM Selected save folder is stored in this temporary file
set "SELFILE=%TEMP%\tfwr_selected_save.txt"
if not exist "%SELFILE%" (
    echo No save selected.
    pause
    goto banner
)

set /p SAVEPATH=<"%SELFILE%"

set "JSONFILE="
for %%F in ("%SAVEPATH%\*.json") do (
    if not defined JSONFILE set "JSONFILE=%%F"
)

if not defined JSONFILE (
    echo No .json file found in this save.
    pause
    goto banner
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0files\ps1\edit.ps1" -JsonPath "%JSONFILE%"

echo.
pause
goto banner

:unlock_flow
call "%~dp0files\unlock.bat"
goto banner

:leaderboard_flow
call "%~dp0files\leaderboard.bat"
goto banner