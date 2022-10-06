@echo off

rem Script to mount a BDE test file
rem Requires Windows 7 or later

rem Create a fixed-size VHD image with an AES-XTS 256-bit BDE encrypted volume with a password and recovery password
set imagename=bde_test.vhd

echo select vdisk file=%cd%\%imagename% > MountVHD.diskpart
echo attach vdisk >> MountVHD.diskpart
echo assign letter=x >> MountVHD.diskpart

call :run_diskpart MountVHD.diskpart

exit /b 0

rem Runs diskpart with a script
rem Note that diskpart requires Administrator privileges to run
:run_diskpart
SETLOCAL
set diskpartscript=%1

rem Note that diskpart requires Administrator privileges to run
diskpart /s %diskpartscript%

if %errorlevel% neq 0 (
	echo Failed to run: "diskpart /s %diskpartscript%"

	exit /b 1
)

del /q %diskpartscript%

rem Give the system a bit of time to adjust
timeout /t 1 > nul

ENDLOCAL
exit /b 0

