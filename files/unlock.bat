@echo off
setlocal
chcp 65001 >nul

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

call "%~dp0saves.bat"
if errorlevel 1 (
    pause
    exit /b 1
)

set "SELFILE=%TEMP%\tfwr_selected_save.txt"
if not exist "%SELFILE%" (
    echo No save selected.
    pause
    exit /b 1
)

set /p SAVEPATH=<"%SELFILE%"

set "JSONFILE="
for %%F in ("%SAVEPATH%\*.json") do (
    if not defined JSONFILE set "JSONFILE=%%F"
)

if not defined JSONFILE (
    echo No .json file found in this save.
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ps1\unlock.ps1" -JsonPath "%JSONFILE%"

echo.
pause
exit /b 0