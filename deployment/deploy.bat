@echo off
setlocal

if "%~1"=="" goto usage
if "%~2"=="" goto usage
if "%~3"=="" goto usage

set JONIN_HOST=%~1
set TARGET_USER=%~2
set TARGET_HOST=%~3
set PASSWORD=%~4

set REMOTE_CMD=sed -i 's/\r$//' /root/prep.sh ^&^& chmod +x /root/prep.sh ^&^& export JONIN_HOST=%JONIN_HOST% ^&^& /root/prep.sh

if not exist ".\prep.sh" (
    echo prep.sh not found in current directory
    exit /b 1
)

if "%PASSWORD%"=="" goto auth_key

where sshpass >nul 2>&1
if not errorlevel 1 goto auth_sshpass

where plink >nul 2>&1
if not errorlevel 1 goto auth_plink
where pscp >nul 2>&1
if not errorlevel 1 goto auth_plink

echo Password auth requires sshpass or PuTTY ^(plink/pscp^) on PATH.
echo.
echo Options:
echo   1. Omit PASSWORD and use SSH key authentication
echo   2. Install PuTTY: winget install PuTTY.PuTTY
echo   3. Use Git Bash/WSL and install sshpass there
exit /b 1

:auth_key
echo Uploading prep.sh...
scp -o StrictHostKeyChecking=no .\prep.sh %TARGET_USER%@%TARGET_HOST%:/root/prep.sh
if errorlevel 1 exit /b 1

echo Running prep.sh...
ssh -o StrictHostKeyChecking=no %TARGET_USER%@%TARGET_HOST% "sed -i 's/\r$//' /root/prep.sh && chmod +x /root/prep.sh && export JONIN_HOST=%JONIN_HOST% && /root/prep.sh"
exit /b %ERRORLEVEL%

:auth_sshpass
echo Uploading prep.sh...
sshpass -p "%PASSWORD%" scp -o StrictHostKeyChecking=no .\prep.sh %TARGET_USER%@%TARGET_HOST%:/root/prep.sh
if errorlevel 1 exit /b 1

echo Running prep.sh...
sshpass -p "%PASSWORD%" ssh -o StrictHostKeyChecking=no %TARGET_USER%@%TARGET_HOST% "sed -i 's/\r$//' /root/prep.sh && chmod +x /root/prep.sh && export JONIN_HOST=%JONIN_HOST% && /root/prep.sh"
exit /b %ERRORLEVEL%

:auth_plink
echo Uploading prep.sh...
echo y| plink -ssh -pw "%PASSWORD%" %TARGET_USER%@%TARGET_HOST% exit >nul 2>&1
pscp -batch -pw "%PASSWORD%" .\prep.sh %TARGET_USER%@%TARGET_HOST%:/root/prep.sh
if errorlevel 1 exit /b 1

echo Running prep.sh...
plink -batch -pw "%PASSWORD%" %TARGET_USER%@%TARGET_HOST% "%REMOTE_CMD%"
exit /b %ERRORLEVEL%

:usage
echo Usage:
echo   deploy.bat JONIN_HOST TARGET_USER TARGET_HOST [PASSWORD]
exit /b 1
