@echo off
setlocal enabledelayedexpansion
title Windows Junk Cleaner
:: Check out the code comments to see what this code is doing, thanks!

:: Check for administrator privileges
NET SESSION >nul 2>&1
if %errorLevel% neq 0 (
    echo Warning: This script is not running with administrator privileges.
    echo It may not be able to clean some folders due to insufficient permissions.
    echo.
)

echo Windows Junk Cleaner
echo ====================

:: Clean C:\Users\%USERNAME%\AppData\Local\Temp
set "folder=C:\Users\%USERNAME%\AppData\Local\Temp"
call :CleanFolder

:: Clean C:\Windows\Temp
set "folder=C:\Windows\Temp"
call :CleanFolder

:: Clean C:\Windows\Prefetch
set "folder=C:\Windows\Prefetch"
call :CleanFolder

echo.
echo Cleaning complete.
pause>nul
exit /B

:CleanFolder
echo.
echo Cleaning %folder%...

set /a files=0
set /a folders=0

for /d %%D in ("%folder%\*") do (
    rd /s /q "%%D" 2>nul
    if not errorlevel 1 set /a folders+=1
)

for %%F in ("%folder%\*") do (
    del /f /q "%%F" 2>nul
    if not errorlevel 1 set /a files+=1
)

echo Deleted %files% files, %folders% folders.
goto :completedstageidk
