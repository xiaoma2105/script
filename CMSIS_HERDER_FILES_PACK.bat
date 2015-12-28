@echo off
rem This file is the script to PACK CMSIS header files. Modify PART_NUM ZIP_DIR ROOT_DIR OUTOUT_DIR PACKAGE_NAME_PREFIX as needed

rem PART_NUM              -->MCU PART_NUMBER
rem ZIP_DIR               -->location of 7z.exe
rem ROOT_DIR              -->location of accurev workspace
rem OUTOUT_DIR            -->package location of CMSIS header files 
rem PACKAGE_NAME_PREFIX   -->prefix of package name

rem -----------------------------------------------------------------------------------
set PART_NUM=MKS22F12
set PACKAGE_NAME_PREFIX=Kinetis_120MHz_KS22F12

set ZIP_DIR=C:\Program Files\7-Zip
set ROOT_DIR=E:\Sdk_Repo\apif_repo
set OUTOUT_DIR=E:\TEST_HEADERS_KS22_1215

rem if do not need keep backup files, set no
set KEEP_BACKUP=yes
rem ------------------------------------------------------------------------------------

set PACKAGE_NAME=%PACKAGE_NAME_PREFIX%_%date:~8,2%%date:~0,2%%date:~3,2%
set CMSIS_FILES_DIR=%ROOT_DIR%\Non_PEx_Files\Kinetis\CMSIS\%PART_NUM%
set IOMAP_FILE=%ROOT_DIR%\PEx_Data\lib\Kinetis\iofiles\%PART_NUM%.h
set SVD_FILE=%ROOT_DIR%\Non_PEx_Files\Kinetis\SVD\%PART_NUM%.svd
set SDK_FILE=%ROOT_DIR%\Non_PEx_Files\Kinetis\SDK\platform\devices\%PART_NUM%

set ZIP_COMMAND="%ZIP_DIR%\7z.exe" a -tzip %OUTOUT_DIR%\%PACKAGE_NAME%.zip %OUTOUT_DIR%\CMSIS %OUTOUT_DIR%\IOMaps %OUTOUT_DIR%\SVD %OUTOUT_DIR%\SDK

if not exist %OUTOUT_DIR%\CMSIS\%PART_NUM% (MD %OUTOUT_DIR%\CMSIS\%PART_NUM%)
if not exist %OUTOUT_DIR%\IOMaps (MD %OUTOUT_DIR%\IOMaps)
if not exist %OUTOUT_DIR%\SVD (MD %OUTOUT_DIR%\SVD)
if not exist %OUTOUT_DIR%\SDK (MD %OUTOUT_DIR%\SDK\platform\devices\%PART_NUM%)

xcopy /y /e %CMSIS_FILES_DIR% %OUTOUT_DIR%\CMSIS\%PART_NUM%
copy /y %IOMAP_FILE% %OUTOUT_DIR%\IOMaps
copy /y %SVD_FILE% %OUTOUT_DIR%\SVD
xcopy /y /e %SDK_FILE% %OUTOUT_DIR%\SDK\platform\devices\%PART_NUM%

%ZIP_COMMAND%
if "%KEEP_BACKUP%"=="no" (rd /s /q %OUTOUT_DIR%\CMSIS %OUTOUT_DIR%\IOMaps %OUTOUT_DIR%\SVD %OUTOUT_DIR%\SDK)
pause
rem