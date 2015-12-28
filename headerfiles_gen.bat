@echo off
rem This file is the script to run gbat to generate header files.
rem Modify ROOTDIR to point to <path to accurev workspace>\APIF\Batches 
rem Modify COMMAND according to different part number

set ROOTDIR=E:\Sdk_Repo\apif_repo\APIF\Batches

set CMSIS_HEADER_DIR=%ROOTDIR%\Other\CMSIS\Kinetis
set CMSIS_LINKER_DIR=%ROOTDIR%\Other\CMSIS\Kinetis\Linkers
set IOMAP_HEADER_DIR=%ROOTDIR%\MemoryMap\Kinetis
set SVD_FILE_DIR=%ROOTDIR%\Other\SVD\Kinetis
set FEATURE_FILE_DIR=%ROOTDIR%\KinetisSDK\Features
set SDK_LINKER_DIR=%ROOTDIR%\KinetisSDK\Linkers
set SDK_MMAP_DIR=%ROOTDIR%\KinetisSDK\MemoryMaps
set REQ_MAP_DIR=%ROOTDIR%\KinetisSDK\Mappings

set COMMAND=agen MKS22F12.gbat
start cmd /s /k "cd /d %CMSIS_HEADER_DIR%&&%COMMAND%"
start cmd /s /k "cd /d %CMSIS_LINKER_DIR%&&%COMMAND%"
start cmd /s /k "cd /d %IOMAP_HEADER_DIR%&&%COMMAND%"
start cmd /s /k "cd /d %SVD_FILE_DIR%&&%COMMAND%"
start cmd /s /k "cd /d %FEATURE_FILE_DIR%&&%COMMAND%"
start cmd /s /k "cd /d %SDK_LINKER_DIR%&&%COMMAND%"
start cmd /s /k "cd /d %SDK_MMAP_DIR%&&%COMMAND%"
REM start cmd /s /k "cd /d %REQ_MAP_DIR%&&agen64 fsl_dma_request_mapping.gbat"
rem
