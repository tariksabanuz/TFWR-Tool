@echo off
setlocal enabledelayedexpansion
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

REM Select a save
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

REM Copy builtins.py and save.json to the save folder
set "BUILTINS=%~dp0py+json\__builtins__.py"
set "SAVEJSON=%~dp0py+json\save.json"
set "F1=%~dp0py+json\f1.py"
set "MAIN2=%~dp0py+json\Main2.0.py"

if exist "%BUILTINS%" (
    copy /Y "%BUILTINS%" "%SAVEPATH%\__builtins__.py" >nul
    echo [OK] __builtins__.py copied to save
) else (
    echo [ERROR] __builtins__.py not found!
    pause
    exit /b 1
)

if exist "%SAVEJSON%" (
    copy /Y "%SAVEJSON%" "%SAVEPATH%\save.json" >nul
    echo [OK] save.json copied to save
) else (
    echo [ERROR] save.json not found!
    pause
    exit /b 1
)

if exist "%F1%" (
    copy /Y "%F1%" "%SAVEPATH%\f1.py" >nul
    echo [OK] f1.py copied to save
) else (
    echo [ERROR] f1.py not found!
    pause
    exit /b 1
)

if exist "%MAIN2%" (
    copy /Y "%MAIN2%" "%SAVEPATH%\Main2.0.py" >nul
    echo [OK] Main2.0.py copied to save
) else (
    echo [ERROR] Main2.0.py not found!
    pause
    exit /b 1
)

echo.
echo.
echo NEXT STEPS:
echo 1. Open The Farmer Was Replaced
echo 2. Load the selected save
echo 3. Go to the CODE tab
echo 4. f1.py run it
echo 5. Now goodluck!
echo.
echo.

pause
exit /b 0