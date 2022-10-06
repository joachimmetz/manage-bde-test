@echo off

rem Script to generate a BDE test file
rem Requires Windows 7 or later

rem Create a fixed-size VHD image with an AES-XTS 256-bit BDE encrypted volume with a password and recovery password
set unitsize=4096
set imagename=bde_test.vhd
set imagesize=64

echo create vdisk file=%cd%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password.
rem Note that the password must be at least 8 chararcters.
manage-bde -On x: -DiscoveryVolumeType "[none]" -EncryptionMethod xts_aes256 -Password -RecoveryPassword -Synchronous

echo select vdisk file=%cd%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

exit /b 0

rem Creates test file entries
:create_test_file_entries
SETLOCAL
SET driveletter=%1

rem Create a directory
mkdir %driveletter%:\testdir1

rem Create a file with a resident MFT data attribute
echo My file > %driveletter%:\testdir1\testfile1

ENDLOCAL
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

