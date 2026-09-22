@echo off
setlocal enabledelayedexpansion

set "SAVES_DIR=%USERPROFILE%\AppData\LocalLow\TheFarmerWasReplaced\TheFarmerWasReplaced\Saves"

if not exist "%SAVES_DIR%" (
    echo Could not find saves folder at:
    echo %SAVES_DIR%
    exit /b 1
)

echo.
echo Found saves at:
echo %SAVES_DIR%
echo.

set /a count=0

for /d %%D in ("%SAVES_DIR%\*") do (
    if exist "%%D\*.json" (
        set /a count+=1
        set "save!count!=%%D"
        echo !count! ^| %%~nD
    )
)

if %count%==0 (
    echo No saves with .json files found.
    exit /b 1
)

echo.
set /p savechoice="Which save do you want to modify (number): "

set "selected="
if defined save%savechoice% (
    for %%N in (%savechoice%) do set "selected=!save%%N!"
)

if "!selected!"=="" (
    echo Invalid choice.
    exit /b 1
)

>"%TEMP%\tfwr_selected_save.txt" echo !selected!

exit /b 0