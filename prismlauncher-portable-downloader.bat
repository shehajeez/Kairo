@echo off
setlocal enabledelayedexpansion

:: THIS WHOLE SCRIPT INCLUDES CODE COMMENTS SO YOU KNOW WHAT THE CODE IS DOING.
:: THE DOWNLOADS USE ENCRYPTED-BYTES.COM. SITE IS SECURE AND THE OWNERS CAN NOT LOOK AT YOUR UPLOADED FILES. IT IS FULLY OPEN-SOURCE ASWELL.

:: Created by the GoatBypassers Team

:: Fetch latest version info from API
for /f "delims=" %%i in ('curl -s https://kairo-api.goatbypassers.xyz/api/prismlauncher') do set "API_RESPONSE=%%i"

:: Extract version from API response
for /f "tokens=2 delims=:," %%a in ('echo !API_RESPONSE! ^| find "prismlauncher_version"') do set "PRISMLAUNCHER_VERSION=%%~a"
set "PRISMLAUNCHER_VERSION=!PRISMLAUNCHER_VERSION:"=!"

:: Construct the download URL
set "PRISMLAUNCHER_URL=https://github.com/PrismLauncher/PrismLauncher/releases/download/!PRISMLAUNCHER_VERSION!/PrismLauncher-Windows-MinGW-w64-Portable-!PRISMLAUNCHER_VERSION!.zip"

title PrismLauncher Downloader (v!PRISMLAUNCHER_VERSION!)

:: Define variables
set "JAVA8_URL=https://encrypted-bytes.com/download/34712f1fa0c1d3ee365b6942140e885e82076e48489a363a8525ebb90251e43f/d6f5f002be9c1682acebfaab3ee35667/0ff243e6927f3154b8a36a391d33eb07795d90eb82f006cfab36575e0a428fba8c88b0096ea4718d0b2fe90ec3d8f53ed780b1df291fa9c2ce13b6310ca2f69b66f826e7bc56e0f236d1a2918af29ad2/1bae4cdd14b01d6dc8b1a9b8483e6df4"
set "JAVA17_URL=https://encrypted-bytes.com/download/6ccc7ebf87095daa2d4a973222501107f125792fd87ea3fb4254b53e9e3d5395/c9b18f7dba70c908e0b07ae3e58c67db/962067baca8058a26d256a26d7b1dbea864117b8cd5418f9d2c8f76fd7789bc3a5965dfa20015d8ca86804b3461ac4b9d66436bb08b278861165564cd149f286993f4c1df2fd514d7c6fe8e225388f03/de082bd02b927744293e0452e227f01c"
set "JAVA21_URL=https://encrypted-bytes.com/download/9d3fa79b6ab9656a975d79f4d194c64692e4bb3a4c2c7856dc198eac65a056a1/ad2ecfc27b8600af10ff5d8f066d0f13/41b245d892139c1f9675d59ea7423571b247ba31909369e1e091a0b1de7a18c539ec2f66d50445d5c2fbc884f16e29a477bb7264fad027403b54b284d2059e56a60052591aa49fd4a3740fc52aaab3fd/4ab38d4071ef3a92dc1923ebee7686a9"
set "TEMP_DIR=%TEMP%\PrismLauncherTemp"
set "INSTALL_DIR=%CD%\PrismLauncher"

:: Create necessary directories
mkdir "%TEMP_DIR%" 2>nul
mkdir "%INSTALL_DIR%" 2>nul

:: Display welcome message
echo Welcome to the PrismLauncher Downloader
echo This tool includes Java 8, 17, and 21 without requiring installation.
echo Created by the GoatBypassers Team
echo.
echo Downloading PrismLauncher version !PRISMLAUNCHER_VERSION!
echo.

:: Download and extract PrismLauncher
call :download_and_extract "PrismLauncher" "!PRISMLAUNCHER_URL!" "%TEMP_DIR%\PrismLauncher.zip" "%INSTALL_DIR%"
if errorlevel 1 goto :error

:: Download and extract Java versions
call :download_and_extract "Java 8" "%JAVA8_URL%" "%TEMP_DIR%\Java8.zip" "%INSTALL_DIR%"
if errorlevel 1 goto :error
echo Java 8 zip file: Java8.zip

call :download_and_extract "Java 17" "%JAVA17_URL%" "%TEMP_DIR%\Java17.zip" "%INSTALL_DIR%"
if errorlevel 1 goto :error
echo Java 17 zip file: Java17.zip

call :download_and_extract "Java 21" "%JAVA21_URL%" "%TEMP_DIR%\Java21.zip" "%INSTALL_DIR%"
if errorlevel 1 goto :error
echo Java 21 zip file: Java21.zip

:: Clean up
echo Cleaning up temporary files...
rmdir /s /q "%TEMP_DIR%" 2>nul

echo.
echo PrismLauncher version !PRISMLAUNCHER_VERSION! has been successfully downloaded and set up!
echo Java 8, 17, and 21 have been included.
echo Press any key to exit.
pause >nul
exit /b 0

:download_and_extract
echo Downloading %~1...
curl -s -L -o "%~3" "%~2"
if errorlevel 1 (
    echo Failed to download %~1.
    exit /b 1
)

echo Extracting %~1...
powershell -command "Expand-Archive -Path '%~3' -DestinationPath '%~4' -Force" >nul 2>&1
if errorlevel 1 (
    echo Failed to extract %~1.
    exit /b 1
)

echo %~1 has been successfully downloaded and extracted.
exit /b 0

:error
echo Error occured during download.
echo Please check your internet connection and try again.
pause >nul
exit /b 1
