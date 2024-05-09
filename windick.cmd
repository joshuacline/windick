::Windows Deployment Image Customization Kit v 1158 (C) Joshua Cline - All rights reserved
::Build, administrate and backup your Windows in a native WinPE recovery environment.
@ECHO OFF&&SETLOCAL ENABLEDELAYEDEXPANSION&&CHCP 437>NUL&&SET "VER_GET=%0"&&CALL:VER_GET&&SET "ORIG_CD=%CD%"&&CD /D "%~DP0"
Reg.exe query "HKU\S-1-5-19\Environment">NUL
IF NOT "%ERRORLEVEL%" EQU "0" ECHO Right-Click ^& Run As Administrator&&PAUSE&&GOTO:CLEAN_EXIT
FOR /F "TOKENS=*" %%a in ('ECHO %CD%') DO (SET "PROG_FOLDER=%%a")
SET "CAPS_SET=PROG_FOLDER"&&SET "CAPS_VAR=%PROG_FOLDER%"&&CALL:CAPS_SET
SET "CHAR_STR=%PROG_FOLDER%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK&&CALL:SID_GET
IF DEFINED CHAR_FLG ECHO Remove the space from the path\folder name, then launch again&&PAUSE&&GOTO:CLEAN_EXIT
FOR %%1 in (1 2 3 4 5 6 7 8 9) DO (CALL SET "ARG%%1=%%%%1%%")
FOR %%1 in (1 2 3 4 5 6 7 8 9) DO (IF DEFINED ARG%%1 SET "ARGZ=%%1"&&CALL SET "ARGX=%%ARG%%1%%"&&CALL:ARGUE)
IF DEFINED ARG1 FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
FOR %%1 in (1 2 3 4 5 6 7 8 9) DO (IF DEFINED ARG%%1 CALL SET "ARG%%1=%%ARG%%1:%%G=%%G%%"))
CALL:MOUNT_NONE&&IF DEFINED ARG1 SET "PROG_MODE=COMMAND"&&GOTO:COMMAND_MODE
FOR /F "TOKENS=1 DELIMS=: " %%a IN ('DISM') DO (IF "%%a"=="Examples" SET "LANG_PASS=1")
IF NOT DEFINED LANG_PASS ECHO Non-english host language/locale. Untested, proceed with caution.&&PAUSE
IF NOT "%PROG_FOLDER%"=="X:\$" SET "PROG_MODE=PORTABLE"&&CALL:TITLECARD&&CALL:SETS_HANDLER&&GOTO:MAIN_MENU
IF "%PROG_FOLDER%"=="X:\$" IF NOT "%SystemDrive%"=="X:" ECHO ERROR: USE OTHER PATH THAN X:\$.&&GOTO:CLEAN_EXIT
IF "%PROG_FOLDER%"=="X:\$" IF "%SystemDrive%"=="X:" SET "PROG_MODE=RAMDISK"&&COLOR 0B&&CALL:TITLECARD
IF EXIST "%PROG_FOLDER%\RECOVERY_LOCK" CALL:RECOVERY_LOCK
IF DEFINED LOCKOUT GOTO:CLEAN_EXIT
CALL:HOST_AUTO&&CALL:SETS_HANDLER
REG.EXE DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\MiniNT" /f>NUL 2>&1
IF "%AUTOBOOT%"=="ENABLED" SET "BOOT_TARGET=VHDX"&&CALL:BOOT_TOGGLE&&CALL:AUTOBOOT_COUNT
IF "%AUTOBOOT%"=="ENABLED" GOTO:CLEAN_EXIT
::#########################################################################
:MAIN_MENU
::#########################################################################
@ECHO OFF&&CLS&&SET "MOUNT="&&IF "%PROG_MODE%"=="RAMDISK" IF "%PROG_SOURCE%"=="X:\$" CALL:HOST_AUTO
IF "%PROG_MODE%"=="RAMDISK" IF "%BASIC_MODE%"=="ENABLED" GOTO:BASIC_MODE
IF "%PROG_MODE%"=="PORTABLE" IF "%BASIC_MODE%"=="ENABLED" GOTO:BASIC_CREATOR
CLS&&CALL:SETS_HANDLER&&CALL:TITLE_X&&CALL:CLEAN&&CALL:FREE_CALC&&CALL:PAD_LINE&&ECHO               Windows Deployment Image Customization Kit&&CALL:PAD_LINE
ECHO.&&ECHO  (%##%1%#$%) Image Processor&&ECHO  (%##%2%#$%) Image Management&&ECHO  (%##%3%#$%) Package Creator&&ECHO  (%##%4%#$%) File Management&&ECHO  (%##%5%#$%) Disk Management&&ECHO  (%##%6%#$%) Tasks&&ECHO  (%##%7%#$%) Settings&&IF "%PROG_MODE%"=="RAMDISK" ECHO  (%##%.%#$%) Modify Boot Menu
ECHO.&&CALL:PAD_LINE
IF DEFINED HOST_TARGET IF "%PROG_SOURCE%"=="%PROG_FOLDER%" ECHO   %XLR2%Disk Error%#$%   ID %#@%%HOST_TARGET%%#$%&&CALL:PAD_LINE
IF DEFINED HOST_TARGET IF "%HOST_MOUNT%"=="YES" IF "%PROG_SOURCE%"=="S:\$" ECHO   Disk %#@%%HOST_NUMBER%%#$%   ID %#@%%HOST_TARGET%%#$%&&CALL:PAD_LINE
IF "%PROG_MODE%"=="PORTABLE" ECHO  (%##%Q%#$%)uit (%##%*%#$%)Basic Mode (%##%?%#$%)                                  %#@%%FREE%GB%#$% Free&&CALL:PAD_LINE
IF "%PROG_MODE%"=="RAMDISK" ECHO  (%##%Q%#$%)uit (%##%*%#$%)Basic Mode (%##%U%#$%)pdate (%##%?%#$%)                         %#@%%FREE%GB%#$% Free&&CALL:PAD_LINE
IF "%SHORTCUTS%"=="ENABLED" ECHO  (%##%%HOTKEY_1%%#$%) (%##%%HOTKEY_2%%#$%) (%##%%HOTKEY_3%%#$%) (%##%%HOTKEY_4%%#$%) (%##%%HOTKEY_5%%#$%)&&CALL:PAD_LINE
CALL:MENU_SELECT
IF "%SELECT%"=="Q" GOTO:QUIT
IF DEFINED HOST_TARGET IF "%PROG_SOURCE%"=="%PROG_FOLDER%" GOTO:MAIN_MENU
IF "%SELECT%"=="1" GOTO:IMAGE_PROCESSOR
IF "%SELECT%"=="2" GOTO:IMAGE_MANAGER
IF "%SELECT%"=="3" GOTO:PACKAGE_CREATOR
IF "%SELECT%"=="4" GOTO:FILE_MANAGER
IF "%SELECT%"=="5" IF NOT DEFINED DISCLAIMER CALL:DISCLAIMER
IF "%SELECT%"=="5" IF DEFINED DISCLAIMER GOTO:DISK_MANAGER
IF "%SELECT%"=="6" CALL:TASK_MENU
IF "%SELECT%"=="7" GOTO:SETTINGS_MENU
IF "%SELECT%"=="?" CALL:MAIN_MENU_HELP
IF "%SELECT%"=="~" SET&&CALL:PAUSED
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="PORTABLE" SET "BASIC_MODE=ENABLED"&&GOTO:BASIC_CREATOR
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="RAMDISK" SET "BASIC_MODE=ENABLED"&&GOTO:BASIC_MODE
IF "%SELECT%"=="U" IF "%PROG_MODE%"=="RAMDISK" GOTO:UPDATE_RECOVERY
IF "%SELECT%"=="." IF "%PROG_MODE%"=="RAMDISK" CALL:BCD_MENU
IF "%SHORTCUTS%"=="ENABLED" CALL:SHORTCUT_RUN
GOTO:MAIN_MENU
:PAD_LINE
IF NOT DEFINED PAD_SIZE SET "PAD_SIZE=7"
IF NOT DEFINED PAD_TYPE SET "PAD_TYPE=1"
IF NOT DEFINED COLOR_ACC SET "COLOR_ACC=6"
IF NOT DEFINED COLOR_BTN SET "COLOR_BTN=7"
IF NOT DEFINED COLOR_TXT SET "COLOR_TXT=0"
IF NOT DEFINED COLOR_SIZ SET "COLOR_SIZ=LARGE"
IF NOT DEFINED COLOR_LAY SET "COLOR_LAY=CHESS"
IF NOT DEFINED COLOR_SEQ (SET "RND_SET=XLRX"&&CALL:RANDOM
IF "%XLRX%"=="0" SET "COLOR_SEQ=11111%XLRX%%XLRX%%XLRX%%XLRX%%XLRX%"
IF NOT "%XLRX%"=="0" SET "COLOR_SEQ=%XLRX%%XLRX%%XLRX%%XLRX%%XLRX%00000")
IF NOT DEFINED CHCP_OLD FOR /F "TOKENS=2 DELIMS=:" %%a IN ('CHCP') DO SET "CHCP_OLD=%%a"
FOR %%a in (1 2 3 4) DO (IF "%PAD_TYPE%"=="%%a" CHCP 65001 >NUL)
IF "%PAD_TYPE%"=="1" SET "PADX=□"
IF "%PAD_TYPE%"=="2" SET "PADX=■"
IF "%PAD_TYPE%"=="3" SET "PADX=▒"
IF "%PAD_TYPE%"=="4" SET "PADX=▓"
IF "%PAD_TYPE%"=="5" SET "PADX=~"
IF "%PAD_TYPE%"=="6" SET "PADX=="
IF "%PAD_TYPE%"=="7" SET "PADX=#"
IF "%COLOR_SIZ%"=="LARGE" SET "PAD_BLK=%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%#$%"
IF "%COLOR_SIZ%"=="SMALL" SET "PAD_BLK=%#0%%PADX%%#1%%PADX%%#2%%PADX%%#3%%PADX%%#4%%PADX%%#5%%PADX%%#6%%PADX%%#7%%PADX%%#8%%PADX%%#9%%PADX%%#$%"
SET "COLOR_SEQX=%COLOR_SEQ%"&&IF NOT "%COLOR_SEQ%X"=="%COLOR_SEQX%X" SET "XNTX=0"&&SET "XLRX="&&FOR /F "DELIMS=" %%G IN ('CMD.EXE /D /U /C ECHO %COLOR_SEQ%^| FIND /V ""') do (CALL SET "XLRX=%%G"&&CALL:COLOR_ASSIGN&&CALL SET /A XNTX+=1)
SET "XLRX=%COLOR_TXT%"&&SET "#Z=%#$%"&&SET "XNTX=$"&&CALL:COLOR_ASSIGN
SET "XLRX=%COLOR_BTN%"&&SET "XLRZ=%#$%"&&SET "XNTX=#"&&CALL:COLOR_ASSIGN
SET "XLRX=%COLOR_ACC%"&&SET "XLRZ=%#$%"&&SET "XNTX=@"&&CALL:COLOR_ASSIGN
IF "%COLOR_SIZ%"=="LARGE" (IF "%PAD_SIZE%"=="2" ECHO;%#0%%PAD_BLK%%#1%%PAD_BLK%
IF "%PAD_SIZE%"=="3" ECHO;%#0%%PAD_BLK%%#1%%PAD_BLK%%#2%%PAD_BLK%
IF "%PAD_SIZE%"=="4" ECHO;%#0%%PAD_BLK%%#1%%PAD_BLK%%#2%%PAD_BLK%%#3%%PAD_BLK%
IF "%PAD_SIZE%"=="7" ECHO;%#0%%PAD_BLK%%#1%%PAD_BLK%%#2%%PAD_BLK%%#3%%PAD_BLK%%#4%%PAD_BLK%%#5%%PAD_BLK%%#6%%PAD_BLK%
IF "%PAD_SIZE%"=="10" ECHO;%#0%%PAD_BLK%%#1%%PAD_BLK%%#2%%PAD_BLK%%#3%%PAD_BLK%%#4%%PAD_BLK%%#5%%PAD_BLK%%#6%%PAD_BLK%%#7%%PAD_BLK%%#8%%PAD_BLK%%#9%%PAD_BLK%)
IF "%COLOR_SIZ%"=="SMALL" (IF "%PAD_SIZE%"=="2" ECHO;%PAD_BLK%%PAD_BLK%
IF "%PAD_SIZE%"=="3" ECHO;%PAD_BLK%%PAD_BLK%%PAD_BLK%
IF "%PAD_SIZE%"=="4" ECHO;%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%
IF "%PAD_SIZE%"=="7" ECHO;%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%
IF "%PAD_SIZE%"=="10" ECHO;%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%)
IF "%COLOR_LAY%"=="CHESS" SET "#0=%#1%"&SET "#1=%#2%"&SET "#2=%#3%"&SET "#3=%#4%"&SET "#4=%#5%"&SET "#5=%#6%"&SET "#6=%#7%"&SET "#7=%#8%"&SET "#8=%#9%"&SET "#9=%#0%"
SET "PAD_BLK="&&SET "PAD_SIZE="&&SET "PADX="&&FOR %%a in (1 2 3 4) DO (IF "%PAD_TYPE%"=="%%a" CHCP %CHCP_OLD% >NUL)
EXIT /B
:BOX
IF NOT DEFINED CHCP_OLD FOR /F "TOKENS=2 DELIMS=:" %%a IN ('CHCP') DO SET "CHCP_OLD=%%a"
CHCP 65001 >NUL
IF NOT DEFINED BOX SET "BOX=*"
IF "%BOX%"=="*" SET "BOX1=►"&&SET "BOX2=◄"
IF "%BOX%"=="T1" SET "BOX1=╭"&&SET "BOX2=╮"
IF "%BOX%"=="B1" SET "BOX1=╰"&&SET "BOX2=╯"
IF "%BOX%"=="T2" SET "BOX1=┌"&&SET "BOX2=┐"
IF "%BOX%"=="B2" SET "BOX1=└"&&SET "BOX2=┘"
ECHO;%##%%BOX1%%#$%                                                                    %##%%BOX2%%#$%
SET "BOX="&&SET "BOX1="&&SET "BOX2="&&CHCP %CHCP_OLD% >NUL
EXIT /B
:ARGUE
CALL SET "ARG%ARGZ%=%ARGX:"=%"
EXIT /B
:COLOR_ASSIGN
IF DEFINED XNTX CALL SET "#%XNTX%=%%XLR%XLRX%%%"
EXIT /B
:FREE_CALC
SET "FREE="&&FOR /F "TOKENS=1-5 DELIMS= " %%a IN ('DIR "%PROG_SOURCE%\*."') DO (IF "%%d %%e"=="bytes free" SET "FREE_Z=%%c")
IF NOT DEFINED FREE_Z SET "FREE=ERROR"&&EXIT /B
SET "FREE_Z=%FREE_Z:,=%"
FOR /F "DELIMS=" %%G in ('CMD.EXE /D /U /C ECHO %FREE_Z%^| FIND /V ""') do (SET "FREE_X=%%G"&&SET /A "FREE_XNT+=1"&&CALL:FREE_XNT)
IF %FREE_XNT% LSS 10 SET "FREE=0"
IF "%FREE_XNT%"=="10" SET "FREE=%FREE1%"
IF "%FREE_XNT%"=="11" SET "FREE=%FREE1%%FREE2%"
IF "%FREE_XNT%"=="12" SET "FREE=%FREE1%%FREE2%%FREE3%"
IF "%FREE_XNT%"=="13" SET "FREE=%FREE1%%FREE2%%FREE3%%FREE4%"
IF "%FREE_XNT%"=="14" SET "FREE=%FREE1%%FREE2%%FREE3%%FREE4%%FREE5%"
FOR %%a in (0 1 2 3 4 5 _XNT _X _Z) DO (SET "FREE%%a=")
EXIT /B
:FREE_XNT
IF %FREE_XNT% GTR 5 EXIT /B
SET "FREE%FREE_XNT%=%FREE_X%"
EXIT /B
:SID_GET
FOR /F "TOKENS=2* SKIP=1 DELIMS=:\. " %%a in ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUser 2^>NUL') do (IF "%%a"=="REG_SZ" SET "CUR_USR=%%b")
FOR /F "TOKENS=2* SKIP=1 DELIMS=:\. " %%a in ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUserSID 2^>NUL') do (IF "%%a"=="REG_SZ" SET "CUR_SID=%%b")
SET "ERRORLEVEL=0"&&EXIT /B
::#########################################################################
:BASIC_MODE
::#########################################################################
SET "MOUNT="&&IF "%PROG_MODE%"=="RAMDISK" IF "%PROG_SOURCE%"=="X:\$" CALL:HOST_AUTO
@ECHO OFF&&CLS&&CALL:SETS_HANDLER&&CALL:TITLE_X&&CALL:CLEAN&&CALL:FREE_CALC&&CALL:PAD_LINE&&ECHO               Windows Deployment Image Customization Kit&&CALL:PAD_LINE
ECHO.&&ECHO. (%##%1%#$%) Backup&&ECHO. (%##%2%#$%) Restore&&ECHO. (%##%3%#$%) Boot Creator&&ECHO. (%##%4%#$%) File Operation&&ECHO. (%##%.%#$%) Modify Boot Menu&&ECHO.&&CALL:PAD_LINE
IF DEFINED HOST_TARGET IF "%PROG_SOURCE%"=="%PROG_FOLDER%" ECHO   %XLR2%Disk Error%#$%   ID %#@%%HOST_TARGET%%#$%&&CALL:PAD_LINE
ECHO  (%##%Q%#$%)uit (%##%*%#$%)Advanced Mode                                   %#@%%FREE%GB%#$% Free&&CALL:PAD_LINE
CALL:MENU_SELECT
IF "%SELECT%"=="Q" GOTO:QUIT
IF DEFINED HOST_TARGET IF "%PROG_SOURCE%"=="%PROG_FOLDER%" GOTO:BASIC_MODE
IF "%SELECT%"=="." CALL:BCD_MENU&&SET "SELECT="
IF "%SELECT%"=="1" CALL:BASIC_BACKUP&&SET "SELECT="
IF "%SELECT%"=="2" CALL:BASIC_RESTORE&&SET "SELECT="
IF "%SELECT%"=="3" GOTO:BASIC_CREATOR&&SET "SELECT="
IF "%SELECT%"=="4" CALL:BASIC_FILE&&SET "SELECT="
IF "%SELECT%"=="*" SET "BASIC_MODE=DISABLED"&&GOTO:MAIN_MENU
GOTO:BASIC_MODE
:BASIC_CREATOR
@ECHO OFF&&SET "MOUNT="&&CLS&&CALL:SETS_HANDLER&&CALL:TITLE_X&&CALL:CLEAN&&CALL:FREE_CALC&&SET "SOURCE_LOCATION="&&FOR %%a in (A B C D E F G H I J K L N O P Q R S T U W Y Z) DO (IF EXIST "%%a:\sources\install.wim" SET "SOURCE_LOCATION=%%a:\sources")
CALL:PAD_LINE&&ECHO                      Image Processor / Boot Creator&&CALL:PAD_LINE
IF DEFINED SOURCE_LOCATION ECHO   (%##%-%#$%)Import Boot  %##%Windows Installation Media Detected%#$%  Import WIM(%##%+%#$%)&&CALL:PAD_LINE
IF EXIST "%IMAGE_FOLDER%\*.WIM" ECHO   %#@%AVAILABLE WIM'S:%#$%&&SET "BLIST=WIM"&&CALL:FILE_LIST&&CALL:PAD_LINE&&ECHO. [%#@%IMAGE PROCESSOR%#$%]             (%##%C%#$%)onvert&&CALL:PAD_LINE
IF NOT EXIST "%IMAGE_FOLDER%\*.WIM" SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO         %#@%Insert a Windows Disc/ISO to import installation media%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&IF EXIST "%IMAGE_FOLDER%\*.VHDX" ECHO. [%#@%IMAGE PROCESSOR%#$%]             (%##%C%#$%)onvert&&CALL:PAD_LINE
IF EXIST "%BOOT_FOLDER%\boot.sav" IF EXIST "%IMAGE_FOLDER%\*.VHDX" ECHO   %#@%AVAILABLE VHDX'S:%#$%&&SET "BLIST=VHDX"&&CALL:FILE_LIST&&CALL:PAD_LINE&&ECHO  [%#@%BOOT CREATOR%#$%]                  (%##%G%#$%)o^^!&&CALL:PAD_LINE
IF NOT EXIST "%BOOT_FOLDER%\boot.sav" SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO             %#@%Insert a Windows Disc/ISO to import boot media%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&IF "%PROG_MODE%"=="RAMDISK" ECHO  [%#@%BOOT CREATOR%#$%]                  (%##%G%#$%)o^^!&&CALL:PAD_LINE
IF "%PROG_MODE%"=="PORTABLE" ECHO  (%##%Q%#$%)uit (%##%*%#$%)Advanced Mode (%##%F%#$%)ile Operation                  %#@%%FREE%GB%#$% Free&&CALL:PAD_LINE
IF "%PROG_MODE%"=="RAMDISK" CALL:PAD_PREV
CALL:MENU_SELECT
IF NOT DEFINED SELECT IF "%PROG_MODE%"=="RAMDISK" GOTO:BASIC_MODE
IF "%SELECT%"=="Q" GOTO:QUIT
IF "%SELECT%"=="C" CALL:CONVERT_PROMPT&&SET "SELECT="
IF "%SELECT%"=="F" IF "%PROG_MODE%"=="PORTABLE" CALL:BASIC_FILE&&SET "SELECT="
IF "%SELECT%"=="+" IF DEFINED SOURCE_LOCATION CALL:SOURCE_IMPORT&&SET "SELECT="
IF "%SELECT%"=="-" IF DEFINED SOURCE_LOCATION CALL:BOOT_IMPORT&&SET "SELECT="
IF "%SELECT%"=="*" SET "BASIC_MODE=DISABLED"&&GOTO:MAIN_MENU
IF "%SELECT%"=="G" IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%BOOT_FOLDER%\boot.sav" CALL:BOOT_FETCH
IF "%SELECT%"=="G" IF EXIST "%BOOT_FOLDER%\boot.sav" CALL:BASIC_CREATOR_PROMPT
GOTO:BASIC_CREATOR
:BASIC_CREATOR_PROMPT
CLS&&CALL:PAD_LINE&&ECHO                              Boot Creator&&SET "NOCLS=1"&&SET "$VHDX=X"&&CALL:VHDX_CHECK
IF DEFINED VHDX_SLOTX IF EXIST "%IMAGE_FOLDER%\%VHDX_SLOTX%" CALL:BOOT_CREATOR_PROMPT
EXIT /B
:CONVERT_PROMPT
CLS&&CALL:PAD_LINE&&ECHO                            Image Processing&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO. (%##%1%#$%) WIM to VHDX&&ECHO. (%##%2%#$%) VHDX to WIM&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF "%SELECT%"=="1" CALL:BASIC_RESTORE&&SET "SELECT="
IF "%SELECT%"=="2" CALL:BASIC_BACKUP&&SET "SELECT="
EXIT /B
:BASIC_BACKUP
SET "PICK=VHDX"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
SET "VHDX_SOURCE=%FILE_BODY%%FILE_EXT%"
SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"&&CALL:IMAGEPROC_PROMPT
IF NOT DEFINED WIM_TARGET EXIT /B
IF EXIST "%IMAGE_FOLDER%\%WIM_TARGET%" SET "ERROR=1"&&ECHO.&&ECHO ERROR&&EXIT /B
IF DEFINED ERROR EXIT /B
SET "WIM_INDEX=1"&&CALL:IMAGEPROC_START
IF NOT DEFINED ERR_MSG ECHO  %#@%%VHDX_SOURCE%%#$% converted to %#@%%WIM_TARGET%%#$%.&&CALL:PAD_LINE
CALL:PAUSED
EXIT /B
:BASIC_RESTORE
SET "PICK=WIM"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
SET "WIM_SOURCE=%FILE_BODY%%FILE_EXT%"
CALL:WIM_INDEX_MENU
IF DEFINED ERROR EXIT /B
SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"&&CALL:IMAGEPROC_PROMPT
IF NOT DEFINED VHDX_TARGET EXIT /B
IF EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" SET "ERROR=1"&&ECHO.&&ECHO ERROR&&EXIT /B
IF DEFINED ERROR EXIT /B
CALL:IMAGEPROC_VSIZE
IF DEFINED ERROR EXIT /B
CALL:IMAGEPROC_START
IF NOT DEFINED ERR_MSG ECHO  %#@%%WIM_SOURCE%%#$% converted to %#@%%VHDX_TARGET%%#$%.&&CALL:PAD_LINE
CALL:PAUSED
EXIT /B
:BASIC_FILE
CLS&&IF NOT DEFINED FILE_OPER CALL:FILE_OPER
IF NOT DEFINED FILE_OPER GOTO:BASIC_ERROR
IF "%FILE_OPER%"=="MoveVHDX" CALL:IMAGE_VIEW&&GOTO:BASIC_ERROR
IF NOT DEFINED FILE_TYPE CLS&&CALL:FILE_TYPE
IF "%FILE_TYPE%"=="MAIN" SET "PICK=MAIN"&&CALL:FILE_PICK
IF "%FILE_TYPE%"=="VHDX" SET "PICK=VHDX"&&CALL:FILE_PICK
IF "%FILE_TYPE%"=="WIM" SET "PICK=WIM"&&CALL:FILE_PICK
IF "%FILE_OPER%"=="Rename" CALL:FILE_NAME&&CALL:FILE_RENAME
IF "%FILE_OPER%"=="Delete" CALL:FILE_DELETE
:BASIC_ERROR
SET "FILE_OPER="&&SET "FILE_TYPE="&&SET "FILE_NAME="
EXIT /B
:FILE_OPER
IF DEFINED ERROR EXIT /B
SET "FILE_OPER="&&CALL:PAD_LINE&&ECHO                          File Operation Menu&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO. (%##%1%#$%) Rename&&ECHO. (%##%2%#$%) Delete&&IF "%FOLDER_MODE%"=="ISOLATED" IF "%FILE_TYPE%"=="VHDX" ECHO. (%##%3%#$%) Move
IF "%FOLDER_MODE%"=="ISOLATED" IF "%FILE_TYPE%"=="MAIN" ECHO. (%##%3%#$%) Move
ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=FILE_PROMPT"&&CALL:PROMPT_SET
IF "%FILE_PROMPT%"=="1" SET "FILE_OPER=Rename"
IF "%FILE_PROMPT%"=="2" SET "FILE_OPER=Delete"
IF "%FILE_PROMPT%"=="3" SET "FILE_OPER=MoveVHDX"
IF NOT DEFINED FILE_OPER SET "ERROR=1"
EXIT /B
:FILE_TYPE
IF DEFINED ERROR EXIT /B
SET "FILE_TYPE="&&CALL:PAD_LINE&&ECHO                         %FILE_OPER% Which File Type?&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.
ECHO. (%##%1%#$%) VHDX&&ECHO. (%##%2%#$%) WIM&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "PROMPT_SET=FILE_PROMPT"&&CALL:PROMPT_SET
IF "%FILE_PROMPT%"=="1" SET "FILE_TYPE=VHDX"
IF "%FILE_PROMPT%"=="2" SET "FILE_TYPE=WIM"
IF NOT DEFINED FILE_TYPE SET "ERROR=1"
EXIT /B
:FILE_NAME
IF DEFINED ERROR EXIT /B
SET "FILE_NAME="&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                          Enter new name of %FILE_EXT%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "PROMPT_SET=FILE_PROMPT"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF DEFINED FILE_PROMPT SET "FILE_NAME=%FILE_PROMPT%"
IF NOT DEFINED FILE_NAME SET "ERROR=1"
EXIT /B
:FILE_RENAME
IF DEFINED ERROR EXIT /B
IF EXIST "%FILE_PATH%\%FILE_NAME%%FILE_EXT%" SET "ERROR=1"&&ECHO.&&ECHO ERROR&&EXIT /B
SET "CASE=LOWER"&&SET "CAPS_SET=FILE_EXT"&&SET "CAPS_VAR=%FILE_EXT%"&&CALL:CAPS_SET
REN "%FILE_PATH%\%FILE_BODY%%FILE_EXT%" "%FILE_NAME%%FILE_EXT%">NUL 2>&1
IF NOT EXIST "%FILE_PATH%\%FILE_NAME%%FILE_EXT%" SET "ERROR=1"&&ECHO.&&ECHO ERROR
EXIT /B
:FILE_DELETE
IF DEFINED ERROR EXIT /B
DEL /Q /F "%FILE_PATH%\%FILE_BODY%%FILE_EXT%">NUL 2>&1
IF EXIST "%FILE_PATH%\%FILE_BODY%%FILE_EXT%" SET "ERROR=1"&&ECHO.&&ECHO ERROR
EXIT /B
:WIM_INDEX_MENU
CLS&&CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX&&ECHO   %#@%AVAILABLE INDEXES:%#$%&&ECHO.&&SET "INDEX_TMP="&&SET "NAME_TMP="&&FOR /F "TOKENS=1-9 DELIMS=: " %%a in ('DISM /ENGLISH /Get-ImageInfo /ImageFile:"%IMAGE_FOLDER%\%WIM_SOURCE%"') DO (
IF "%%a"=="Index" CALL SET "INDEX_TMP=%%b"
IF "%%a"=="Name" CALL SET "NAME_TMP=%%b %%c %%d %%e %%f %%g %%h %%i"&&CALL:WIM_INDEX_LIST)
IF NOT DEFINED INDEX_TMP ECHO ERROR&&SET "ERROR=1"&&EXIT /B
SET "INDEX_TMP="&&SET "NAME_TMP="&&SET "BOX=B1"&&ECHO.&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT SET "ERROR=1"&&EXIT /B
SET "WIM_INDEX=%SELECT%"&&CALL:WIM_INDEX_QUERY
IF "%WIM_DESC%"=="NULL" ECHO.&&ECHO ERROR&&SET "ERROR=1"
EXIT /B
:WIM_INDEX_LIST
ECHO  (%##%%INDEX_TMP%%#$%) %NAME_TMP%
EXIT /B
:WIM_INDEX_QUERY
SET "WIM_DESC="&&FOR /F "TOKENS=1-5 DELIMS=<> " %%a in ('DISM /ENGLISH /Get-ImageInfo /ImageFile:"%IMAGE_FOLDER%\%WIM_SOURCE%" /Index:%WIM_INDEX%') DO (IF "%%a"=="Edition" SET "WIM_DESC=%%c"
IF "%%a"=="Languages" IF NOT "%%c"=="" SET "WIM_SOURCE=SELECT")
IF NOT DEFINED WIM_DESC SET "WIM_INDEX=1"&&SET "WIM_DESC=NULL"
IF EXIST "$DISM" DEL /Q /F "$DISM">NUL
EXIT /B
:BCD_MENU
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&ECHO                            Boot Menu Editor&&CALL:PAD_LINE&&ECHO.
IF NOT DEFINED BOOT_TIMEOUT SET "BOOT_TIMEOUT=5"
SET "MENUX="&&ECHO  Time (%##%T%#$%^) [%#@%%BOOT_TIMEOUT%%#$%] seconds
FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (CALL ECHO  Slot ^(%##%%%G%#$%^) [%#@%%%VHDX_SLOT%%G%%%#$%])
ECHO.&&CALL:PAD_LINE&&ECHO        Press (%##%X%#$%) to apply boot menu settings   (%##%F%#$%)ile Operation&&CALL:PAD_LINE
CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (IF "%SELECT%"=="%%G" SET "$VHDX=%%G"&&CALL:VHDX_CHECK)
IF "%SELECT%"=="T" SET "MENUX=1"&&CALL:PAD_LINE&&ECHO                   Enter boot menu timeout in seconds&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT&&SET "CHECK=NUM"&&CALL:CHECK
IF "%MENUX%"=="1" IF NOT DEFINED ERROR SET "BOOT_TIMEOUT=%SELECT%"&&SET "MENUX="
IF "%MENUX%"=="1" IF DEFINED ERROR SET "BOOT_TIMEOUT="&&SET "MENUX="
IF "%SELECT%"=="F" SET "FILE_TYPE=MAIN"&&CALL:BASIC_FILE
IF "%SELECT%"=="X" CALL:BCD_REBUILD
GOTO:BCD_MENU
:IMAGE_VIEW
IF NOT "%FOLDER_MODE%"=="ISOLATED" EXIT /B
CLS&&CALL:PAD_LINE&&ECHO                        Move VHDX between folders&&CALL:PAD_LINE&&ECHO   IMAGE FOLDER VHDX'S:&&SET "BLIST=VHDX"&&CALL:FILE_LIST&&CALL:PAD_LINE&&ECHO                              (%##%-%#$%) MOVE (%##%+%#$%)&&CALL:PAD_LINE&&ECHO   MAIN FOLDER VHDX'S:&&SET "BLIST=MAIN"&&CALL:FILE_LIST&&CALL:PAD_LINE
CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
IF "%SELECT%"=="-" SET "FILEZ=MOVE"&&CALL:IMAGE_MOVE
IF "%SELECT%"=="+" SET "FILEZ=MOVE"&&CALL:IMAGE_MOVE
GOTO:IMAGE_VIEW
:IMAGE_MOVE
SET "MENUX="
IF "%SELECT%"=="+" SET "MENUX=I2M"&&SET "PICK=VHDX"&&CALL:FILE_PICK
IF "%SELECT%"=="-" SET "MENUX=M2I"&&SET "PICK=MAIN"&&CALL:FILE_PICK
IF "%MENUX%"=="I2M" IF DEFINED $PICK IF EXIST "%PROG_SOURCE%\%$ELECT$%" CALL:PAD_LINE&&ECHO  File already exists in MAIN folder. Press (%##%X%#$%) to overwrite %#@%%$ELECT$%%#$%.&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF "%MENUX%"=="I2M" IF DEFINED $PICK IF EXIST "%PROG_SOURCE%\%$ELECT$%" IF NOT "%CONFIRM%"=="X" EXIT /B
IF "%MENUX%"=="M2I" IF DEFINED $PICK IF EXIST "%IMAGE_FOLDER%\%$ELECT$%" CALL:PAD_LINE&&ECHO  File already exists in IMAGE folder. Press (%##%X%#$%) to overwrite %#@%%$ELECT$%%#$%.&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF "%MENUX%"=="M2I" IF DEFINED $PICK IF EXIST "%IMAGE_FOLDER%\%$ELECT$%" IF NOT "%CONFIRM%"=="X" EXIT /B
IF "%MENUX%"=="I2M" IF DEFINED $PICK SET "MENUX="&&%FILEZ% /Y "%$PICK%" "%PROG_SOURCE%\">NUL
IF "%MENUX%"=="M2I" IF DEFINED $PICK SET "MENUX="&&%FILEZ% /Y "%$PICK%" "%IMAGE_FOLDER%\">NUL
EXIT /B
::#########################################################################
:COMMAND_MODE
::#########################################################################
SET "ERROR="&&SET "BRUTE_FORCE="&&SET "PROG_SOURCE=%PROG_FOLDER%"&&CALL:FOLDER_LOCATE&&SET "EXIT_FLAG="&&CALL:COMMAND_ERROR&&CALL:PAD_LINE>NUL
IF "%EXIT_FLAG%"=="1" GOTO:CLEAN_EXIT
IF "%ARG1%"=="-HELP" CALL:COMMAND_HELP
IF "%ARG1%"=="-FILEMGR" IF "%ARG2%"=="-GRANT" IF DEFINED ARG3 IF EXIST "%ARG3%" SET "$PICK=%ARG3%"&&SET "NO_PAUSE=1"&&CALL:FMGR_OWN
IF "%ARG1%"=="-NEXTBOOT" FOR %%a in (VHDX RECOVERY) DO (IF "%ARG2%"=="-%%a" SET "BOOT_TARGET=%%a"&&CALL:BOOT_TOGGLE)
IF "%ARG1%"=="-NEXTBOOT" IF DEFINED NEXT_BOOT CALL ECHO Next boot is [%NEXT_BOOT%]
IF "%ARG1%"=="-NEXTBOOT" IF NOT DEFINED NEXT_BOOT CALL ECHO Error: The boot environment is not installed on this disk.
IF "%ARG1%"=="-BOOTMAKER" IF DEFINED ARG2 IF "%ARG3%"=="-DISKID" IF DEFINED ARG4 SET "DISK_TARGET=%ARG4%"&&CALL:DISK_QUERY>NUL
IF "%ARG1%"=="-BOOTMAKER" IF DEFINED ARG2 IF "%ARG3%"=="-DISKID" IF DEFINED ARG4 SET "ARG3=-DISK"&&SET "ARG4=%DISK_NUMBER%"
IF "%ARG1%"=="-BOOTMAKER" IF DEFINED ARG2 IF "%ARG3%"=="-DISK" IF "%DISK_TARGET%"=="00000000" SET "ARG1="&&ECHO Convert to GPT first.
IF "%ARG1%"=="-DISKMGR" IF DEFINED ARG2 IF "%ARG3%"=="-DISKID" IF DEFINED ARG4 SET "DISK_TARGET=%ARG4%"&&CALL:DISK_QUERY>NUL
IF "%ARG1%"=="-DISKMGR" IF DEFINED ARG2 IF "%ARG3%"=="-DISKID" IF DEFINED ARG4 SET "ARG3=-DISK"&&SET "ARG4=%DISK_NUMBER%"
IF "%ARG1%"=="-DISKMGR" IF DEFINED ARG2 IF "%ARG3%"=="-DISK" IF "%DISK_TARGET%"=="00000000" SET "ARG1="&&ECHO Convert to GPT first.
IF "%ARG1%"=="-AUTOBOOT" IF "%ARG2%"=="-REMOVE" SET "BOOTSVC=REMOVE"&&CALL:AUTOBOOT_SVC&ECHO AutoBoot switcher is removed
IF "%ARG1%"=="-AUTOBOOT" IF "%ARG2%"=="-INSTALL" SET "BOOTSVC=INSTALL"&&CALL:AUTOBOOT_SVC&ECHO AutoBoot switcher is installed
IF "%ARG1%"=="-IMAGEPROC" IF "%ARG2%"=="-WIM" IF DEFINED ARG3 IF EXIST "%IMAGE_FOLDER%\%ARG3%" IF "%ARG4%"=="-INDEX" IF DEFINED ARG5 IF "%ARG6%"=="-VHDX" IF DEFINED ARG7 IF "%ARG8%"=="-SIZE" IF DEFINED ARG9 SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"&&SET "WIM_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "VHDX_TARGET=%ARG7%"&&SET "VHDX_SIZE=%ARG9%"&&CALL:IMAGEPROC_START
IF "%ARG1%"=="-IMAGEPROC" IF "%ARG2%"=="-WIM" IF DEFINED ARG3 IF EXIST "%IMAGE_FOLDER%\%ARG3%" IF "%ARG4%"=="-INDEX" IF DEFINED ARG5 IF "%ARG6%"=="-WIM" IF DEFINED ARG7 IF "%ARG8%"=="-XLVL" IF DEFINED ARG9 SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=WIM"&&SET "WIM_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "WIM_TARGET=%ARG7%"&&SET "WIM_XLVL=%ARG9%"&&CALL:IMAGEPROC_START
IF "%ARG1%"=="-IMAGEPROC" IF "%ARG2%"=="-VHDX" IF DEFINED ARG3 IF EXIST "%IMAGE_FOLDER%\%ARG3%" IF "%ARG4%"=="-INDEX" IF DEFINED ARG5 IF "%ARG6%"=="-WIM" IF DEFINED ARG7 IF "%ARG8%"=="-XLVL" IF DEFINED ARG9 SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"&&SET "VHDX_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "WIM_TARGET=%ARG7%"&&SET "WIM_XLVL=%ARG9%"&&CALL:IMAGEPROC_START
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LST" IF DEFINED ARG4 IF EXIST "%LIST_FOLDER%\%ARG4%" SET "$LST1=%LIST_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-LIVE" SET "LIVE_APPLY=1"&&CALL:IMAGEMGR_RUN_LIST
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LST" IF DEFINED ARG4 IF EXIST "%LIST_FOLDER%\%ARG4%" SET "$LST1=%LIST_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG6 IF EXIST "%IMAGE_FOLDER%\%ARG6%" SET "VDISK=%IMAGE_FOLDER%\%ARG6%"&&CALL:IMAGEMGR_RUN_LIST
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUNBRUTE" IF "%ARG3%"=="-LST" IF DEFINED ARG4 IF EXIST "%LIST_FOLDER%\%ARG4%" SET "$LST1=%LIST_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-LIVE" SET "LIVE_APPLY=1"&&SET "BRUTE_FORCE=ENABLED"&&CALL:IMAGEMGR_RUN_LIST
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUNBRUTE" IF "%ARG3%"=="-LST" IF DEFINED ARG4 IF EXIST "%LIST_FOLDER%\%ARG4%" SET "$LST1=%LIST_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG6 IF EXIST "%IMAGE_FOLDER%\%ARG6%" SET "VDISK=%IMAGE_FOLDER%\%ARG6%"&&SET "BRUTE_FORCE=ENABLED"&&CALL:IMAGEMGR_RUN_LIST
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-PKX" IF DEFINED ARG4 IF EXIST "%PACK_FOLDER%\%ARG4%" SET "PKX_PACK=%PACK_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-LIVE" SET "LIVE_APPLY=1"&&CALL:AIO_PARSE
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-PKX" IF DEFINED ARG4 IF EXIST "%PACK_FOLDER%\%ARG4%" SET "PKX_PACK=%PACK_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG6 IF EXIST "%IMAGE_FOLDER%\%ARG6%" SET "VDISK=%IMAGE_FOLDER%\%ARG6%"&&CALL:AIO_PARSE
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUNBRUTE" IF "%ARG3%"=="-PKX" IF DEFINED ARG4 IF EXIST "%PACK_FOLDER%\%ARG4%" SET "PKX_PACK=%PACK_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-LIVE" SET "LIVE_APPLY=1"&&SET "BRUTE_FORCE=ENABLED"&&CALL:AIO_PARSE
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUNBRUTE" IF "%ARG3%"=="-PKX" IF DEFINED ARG4 IF EXIST "%PACK_FOLDER%\%ARG4%" SET "PKX_PACK=%PACK_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG6 IF EXIST "%IMAGE_FOLDER%\%ARG6%" SET "VDISK=%IMAGE_FOLDER%\%ARG6%"&&SET "BRUTE_FORCE=ENABLED"&&CALL:AIO_PARSE
IF "%ARG1%"=="-BOOTMAKER" IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 IF EXIST "%BOOT_FOLDER%\BOOT.SAV" SET "DISK_NUMBER=%ARG4%"&&CALL:DISK_QUERY>NUL 2>&1
IF "%ARG1%"=="-BOOTMAKER" IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 IF EXIST "%BOOT_FOLDER%\BOOT.SAV" SET "DISK_NUMBER=%ARG4%"&&FOR %%a in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15) DO (IF "%ARG4%"=="%%a" CALL SET "DISK_TARGET=%%DISKID_%%a%%"&&CALL ECHO.%%DISKID_%%a%%>"%TEMP%\DISK_TARGET")
IF "%ARG1%"=="-BOOTMAKER" IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 IF EXIST "%BOOT_FOLDER%\BOOT.SAV" IF "%ARG7%"=="-SIZE" IF DEFINED ARG8 SET "HOST_SIZE=%ARG8%"&&SET "SELECT=%ARG8%"&&SET "CHECK=NUM"&&CALL:CHECK
IF "%ARG1%"=="-BOOTMAKER" IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 IF EXIST "%BOOT_FOLDER%\BOOT.SAV" IF "%ARG7%"=="-SIZE" IF DEFINED ARG8 IF DEFINED ERROR SET "HOST_SIZE=DISABLED"
IF "%ARG1%"=="-BOOTMAKER" IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 IF EXIST "%BOOT_FOLDER%\BOOT.SAV" SET "VHDX_SLOTX=%ARG6%"&&CALL:BOOT_CREATOR_START
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-LIST" CALL:DISK_QUERY
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-INSPECT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&CALL:DISKMGR_INSPECT
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-GETDISK" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&CALL:DISK_QUERY>NUL
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-GETDISK" IF "%ARG3%"=="-DISK" IF DEFINED DISKID_%DISK_NUMBER% CALL ECHO [DISK[%DISK_NUMBER%] [DISK ID[%%DISKID_%DISK_NUMBER%%%]
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-GETDISK" IF "%ARG3%"=="-DISK" IF NOT DEFINED DISKID_%DISK_NUMBER% CALL ECHO DISK #/ID DOES NOT EXIST
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-ERASE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 CALL:DISK_QUERY>NUL
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-ERASE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&FOR %%a in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15) DO (IF "%ARG4%"=="%%a" CALL SET "DISK_TARGET=%%DISKID_%%a%%"&&CALL:DISKMGR_ERASE)
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-CHANGEID" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&SET "GET_DISK_ID=%ARG5%"&&CALL:DISKMGR_CHANGEID
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-SIZE"  IF DEFINED ARG6 SET "PART_SIZE=%ARG6%"&&CALL:DISKMGR_CREATE
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-FORMAT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&CALL:DISKMGR_FORMAT
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-DELETE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&CALL:DISKMGR_DELETE
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&IF "%ARG7%"=="-LETTER" IF DEFINED ARG8 SET "DISK_LETTER=%ARG8%"&&CALL:DISKMGR_MOUNT
IF "%ARG1%"=="-DISKMGR" IF "%ARG2%"=="-UNMOUNT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&IF "%ARG7%"=="-LETTER" IF DEFINED ARG8 SET "DISK_LETTER=%ARG8%"&&CALL:DISKMGR_UNMOUNT
CALL:SCRATCH_PACK_DELETE&&CALL:SCRATCH_DELETE&&IF EXIST "%TEMP%\DISK_TARGET" DEL /Q /F "%TEMP%\DISK_TARGET">NUL 2>&1
GOTO:CLEAN_EXIT
:COMMAND_ERROR
ECHO.&&IF DEFINED ARG1 IF NOT "%ARG1%"=="/?" IF NOT "%ARG1%"=="-HELP" IF NOT "%ARG1%"=="-AUTOBOOT" IF NOT "%ARG1%"=="-NEXTBOOT" IF NOT "%ARG1%"=="-BOOTMAKER" IF NOT "%ARG1%"=="-DISKMGR" IF NOT "%ARG1%"=="-FILEMGR" IF NOT "%ARG1%"=="-IMAGEPROC" IF NOT "%ARG1%"=="-IMAGEMGR" ECHO Type windick.cmd -help for more options.&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="/?" SET "ARG1=-HELP"
IF "%ARG1%"=="-FILEMGR" IF NOT "%ARG2%"=="-GRANT" ECHO Valid options are -grant&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-FILEMGR" IF "%ARG2%"=="-GRANT" IF NOT EXIST "%ARG3%" ECHO %ARG3%  doesn't exist&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-NEXTBOOT" IF NOT "%ARG2%"=="-RECOVERY" IF NOT "%ARG2%"=="-VHDX" ECHO Valid options are -recovery and -vhdx&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-AUTOBOOT" IF NOT "%ARG2%"=="-INSTALL" IF NOT "%ARG2%"=="-REMOVE" ECHO Valid options are -install and -remove&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-BOOTMAKER" IF "%ARG2%"=="-CREATE" IF DEFINED ARG6 IF NOT EXIST "%BOOT_FOLDER%\BOOT.SAV" ECHO BOOT MEDIA %BOOT_FOLDER%\BOOT.SAV doesn't exist&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-IMAGEPROC" IF "%ARG2%"=="-WIM" IF DEFINED ARG3 IF NOT EXIST "%IMAGE_FOLDER%\%ARG3%" ECHO WIM %IMAGE_FOLDER%\%ARG3% doesn't exist&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-IMAGEPROC" IF "%ARG2%"=="-VHDX" IF DEFINED ARG3 IF NOT EXIST "%IMAGE_FOLDER%\%ARG3%" ECHO VHDX %IMAGE_FOLDER%\%ARG3% doesn't exist&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-ISO" IF DEFINED ARG4 IF NOT EXIST "%IMAGE_FOLDER%\%ARG4%" ECHO ISO %IMAGE_FOLDER%\%ARG4% doesn't exist&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LST" IF DEFINED ARG4 IF NOT EXIST "%LIST_FOLDER%\%ARG4%" ECHO List %LIST_FOLDER%\%ARG4% doesn't exist&&SET "EXIT_FLAG=1"
IF "%ARG1%"=="-IMAGEMGR" IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-VHDX" IF DEFINED ARG6 IF NOT EXIST "%IMAGE_FOLDER%\%ARG6%" ECHO VHDX %IMAGE_FOLDER%\%ARG6% doesn't exist&&SET "EXIT_FLAG=1"
EXIT /B
:COMMAND_HELP
ECHO  Command Line Parameters:
ECHO.&&ECHO          [MISC]
ECHO    -help                                                          (This menu)
ECHO    -nextboot -vhdx                                                (Schedule next boot to vhdx)
ECHO    -nextboot -recovery                                            (Schedule next boot to recovery)
ECHO    -autoboot -install                                             (Install reboot to recovery switcher service)
ECHO    -autoboot -remove                                              (Remove reboot to recovery switcher service)
ECHO.&&ECHO          [BOOT CREATOR]
ECHO    -bootmaker -create -disk (#) -vhdx (vhdx)                      (Create Boot-Media on specified disk)
ECHO    -bootmaker -create -diskid (id) -vhdx (vhdx) -size (size)      (Create Boot-Media + custom host partition size)
ECHO  Examples:
ECHO    -bootmaker -create -disk 0 -vhdx z.vhdx                        (Default is entire disk when size not specified)
ECHO    -bootmaker -create -diskid 12345678-1234-1234-1234-123456781234 -vhdx z.vhdx -size 100000
ECHO.&&ECHO          [IMAGE PROCESSOR]
ECHO    -imageproc -wim (wim) -index (#) -wim (wim) -xlvl (fast/max)   (WIM index isolation)
ECHO    -imageproc -wim (wim) -index (#) -vhdx (vhdx) -size (MB)       (WIM to VHDX Conversion)
ECHO    -imageproc -vhdx (vhdx) -index (#) -wim (wim) -xlvl (fast/max) (VHDX to WIM Conversion)
ECHO  Examples:
ECHO    -imageproc -wim x.wim -index 1 -vhdx z.vhdx -size 25600
ECHO    -imageproc -wim x.wim -index 1 -wim z.wim -xlvl fast
ECHO    -imageproc -vhdx z.vhdx -index 1 -wim x.wim -xlvl fast
ECHO.&&ECHO          [IMAGE MANAGEMENT]
ECHO    -imagemgr -run -lst (x.lst) -live /or/ -vhdx (z.vhdx)          (Run list)
ECHO    -imagemgr -run -pkx (x.pkx) -live /or/ -vhdx (z.vhdx)          (Run AIO Package w/integrated list)
ECHO    -imagemgr -runbrute -lst (x.lst) -live /or/ -vhdx (z.vhdx)     (Run list with brute force enabled)
ECHO  Examples:
ECHO    -imagemgr -run -lst "x y z.lst" -live
ECHO    -imagemgr -run -pkx x.pkx -vhdx z.vhdx
ECHO    -imagemgr -runbrute -lst x.lst -vhdx z.vhdx
ECHO.&&ECHO          [FILE MANAGEMENT]
ECHO    -filemgr -grant (file/folder)                                  (Take ownership + Grant Permissions)
ECHO  Examples:
ECHO    -filemgr -grant c:\x.txt
ECHO.&&ECHO          [DISK MANAGEMENT]
ECHO    -diskmgr -list                                                 (Condensed list of disks)
ECHO    -diskmgr -getdisk -disk (#) /or/ -diskid (id)                  (Query disk # / disk id)
ECHO    -diskmgr -inspect -disk (#) /or/ -diskid (id)                  (DiskPart inquiry on specified disk)
ECHO    -diskmgr -erase -disk (#) /or/ -diskid (id)                    (Delete ALL partitions on specified disk)
ECHO    -diskmgr -changeid -disk (#) /or/ -diskid (id) (new id)        (Change disk id of specified disk)
ECHO    -diskmgr -create -disk (#) /or/ -diskid (id) -size (MB)        (Create NTFS partition on specified disk)
ECHO    -diskmgr -format -disk (#) /or/ -diskid (id) -part (#)         (Format partition w/NTFS on specified disk)
ECHO    -diskmgr -delete -disk (#) /or/ -diskid (id) -part (#)         (Delete partition on specified disk)
ECHO    -diskmgr -mount -disk (#) /or/ -diskid (id) -part (#) -letter (letter)        (Assign drive letter)
ECHO    -diskmgr -unmount -disk (#) /or/ -diskid (id) -part (#) -letter (letter)      (Remove drive letter)
ECHO  Examples:
ECHO    -diskmgr -create -disk 0 -size 25600
ECHO    -diskmgr -mount -disk 0 -part 1 -letter e
ECHO    -diskmgr -unmount -diskid 12345678-1234-1234-1234-123456781234 -part 1 -letter e
ECHO.&&ECHO Specified images, lists, or boot media must be in their respective folders or the operation will fail.
ECHO Note when using command-mode: in some instances there cannot be a space in the file name.
EXIT /B
:DISCLAIMER
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.
ECHO    -------------------------- %XLR2%DISCLAIMER%#$% --------------------------
ECHO     IT'S RECOMMENDED TO BACKUP YOUR DATA BEFORE MAKING ANY CHANGES
ECHO      TO THE LIVE OPERATING SYSTEM OR PERFORMING DISK PARTITIONING
ECHO    ----------------------------------------------------------------
ECHO  The user assumes liability for loss relating to the use of this tool.     
ECHO.&&ECHO                           Do You Agree? (%##%Y%#$%/%##%N%#$%)
ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&SET "PROMPT_SET=ACCEPTX"&&CALL:PROMPT_SET
IF "%ACCEPTX%"=="Y" SET "DISCLAIMER=ACCEPTED"
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO      The ( %##%@%#$% ) %##%Current-Environment%#$% option ^& disk management area
ECHO          are the 'caution zones' and can be avoided if unsure.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:TITLECARD
SET "RND_SET=TITX"&&CALL:RANDOM
IF "%TITX%"=="1" SET "TITLE_X= When finished, backup by converting to WIM."
IF "%TITX%"=="2" SET "TITLE_X= Boot media can be imported in Image Processor using (-)."
IF "%TITX%"=="3" SET "TITLE_X= Modify the boot menu while booted into recovery mode."
IF "%TITX%"=="4" SET "TITLE_X= Export/import all current drivers, combine into a driver-pack."
IF "%TITX%"=="5" SET "TITLE_X= Generate a base-list (Appx/Comp/Feat/Serv/Task) in image management."
IF "%TITX%"=="6" SET "TITLE_X= Try basic mode for a simple and streamlined recovery experience."
IF "%TITX%"=="7" SET "TITLE_X= Difference base-lists to compare editions or to match the configuration."
IF "%TITX%"=="8" SET "TITLE_X= Update the EFI files, program, or boot media while booted into recovery."
IF "%TITX%"=="9" SET "TITLE_X= SetupComplete/RunOnce items apply to Current-Environment (Live), but are simply delayed."
IF "%TITX%"=="0" SET "TITLE_X= Build, administrate and backup your Windows in a native WinPE recovery environment."
IF "%BASIC_MODE%"=="ENABLED" SET "TITLE_X=Windows Deployment Image Customization Kit v%VER_CUR% (%PROG_FOLDER%)."
SET "TITX="&&CALL:TITLE_X
EXIT /B
:TITLE_X
IF NOT DEFINED TITLE_X SET "TITLE_X=Windows Deployment Image Customization Kit v%VER_CUR% (%PROG_SOURCE%)"
TITLE %TITLE_X%&&SET "TITLE_X="
EXIT /B
:MAIN_MENU_HELP
CLS&&CALL:PAD_LINE&&ECHO                              Main Menu Help  &&CALL:PAD_LINE&&ECHO.&&ECHO   (%##%1%#$%)Image Processor       %#@%Convert/isolate WIM/VHDX images%#$%&&ECHO   (%##%2%#$%)Image Management      %#@%Perform image related tasks%#$%&&ECHO   (%##%3%#$%)Package Creator       %#@%Create driver/scripted packages%#$%&&ECHO   (%##%4%#$%)File Management       %#@%Simple file manager, file-picker%#$%&&ECHO   (%##%5%#$%)Disk Management       %#@%Basic disk partitioning%#$%&&ECHO     (%##%B%#$%)oot                 %#@%Create bootable deployment environment%#$%&&ECHO   (%##%6%#$%)Tasks                 %#@%Miscellaneous tasks%#$%&&ECHO   (%##%7%#$%)Settings              %#@%Settings%#$%&&ECHO # (%##%.%#$%)Modify Boot Menu      %#@%Configure VHDX Slots%#$%&&ECHO # (%##%U%#$%)pdate                 %#@%Push various updates to EFI%#$%&&ECHO   (%##%*%#$%)Basic Mode            %#@%Reduced functionality mode%#$%&&ECHO.&&ECHO                 # Appears only when booted into recovery&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PROMPT_SET
IF NOT DEFINED PROMPT_SET SET "PROMPT_SET=SELECT"
SET "PROMPT_VAR="&&SET /P "PROMPT_VAR=$>>"
SET "CAPS_SET=%PROMPT_SET%"&&SET "CAPS_VAR=%PROMPT_VAR%"
IF DEFINED PROMPT_ANY CALL SET "%CAPS_SET%=%CAPS_VAR%"
IF NOT DEFINED PROMPT_ANY CALL:CAPS_SET
SET "PROMPT_ANY="&&SET "PROMPT_SET="&&SET "PROMPT_VAR="
EXIT /B
:MENU_SELECT
SET "SELECT="&&SET /P "SELECT=$>>"
IF DEFINED SELECT SET "CAPS_SET=SELECT"&&SET "CAPS_VAR=%SELECT%"&&CALL:CAPS_SET
CALL SET "$ELECTMP=%%$ITEM%SELECT%%%"&&IF DEFINED SELECT CALL SET "$ELECT=%SELECT%"
IF DEFINED SELECT IF DEFINED $ELECTMP CALL SET "$ELECT$=%$ELECTMP%"
EXIT /B
:CAPS_SET
IF NOT DEFINED CASE SET "CASE=UPPER"
IF "%CASE%"=="LOWER" FOR %%G in (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO (CALL SET "CAPS_VAR=%%CAPS_VAR:%%G=%%G%%")
IF "%CASE%"=="UPPER" FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "CAPS_VAR=%%CAPS_VAR:%%G=%%G%%")
CALL SET "%CAPS_SET%=%CAPS_VAR%"&&SET "CAPS_SET="&&SET "CAPS_VAR="&&SET "CASE="
EXIT /B
:CHAR_CHK
FOR %%a in (CHAR_STR CHAR_CHK) DO (IF NOT DEFINED %%a EXIT /B)
SET "CHAR_FLG="&&FOR /F "DELIMS=" %%$ in ('CMD.EXE /D /U /C ECHO %CHAR_STR%^| FIND /V ""') do (IF "%%$"=="%CHAR_CHK%" SET "ERROR=1"&&SET "CHAR_FLG=1")
EXIT /B
:PAD_PREV
ECHO                Press (%##%Enter%#$%) to return to previous menu
EXIT /B
:PAUSED
SET /P "PAUSED=.                      Press (%##%Enter%#$%) to continue..."
EXIT /B
:RECOVERY_LOCK
SET "LOCKOUT="&&ECHO Enter password
SET /P RECOVERY_LOCK=<"%PROG_FOLDER%\RECOVERY_LOCK"
SET "PROMPT_SET=RECOVERY_PROMPT"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT "%RECOVERY_PROMPT%"=="%RECOVERY_LOCK%" SET "LOCKOUT=1"
SET "RECOVERY_PROMPT="&&SET "RECOVERY_LOCK="
EXIT /B
:RANDOM
IF NOT DEFINED RND_TYPE SET RND_TYPE=1
CALL:RND%RND_TYPE% >NUL 2>&1
IF NOT DEFINED RND1 GOTO:RANDOM
IF "%RND2%"=="%RND1%" GOTO:RANDOM
SET "RND2=%RND1%"&&CALL SET "%RND_SET%=%RND1%"&&SET "RND_TYPE="&&SET "RND_SET="&&SET "RND1="
EXIT /B
:RND1
FOR /F "TOKENS=1-9 DELIMS=:." %%a in ("%TIME%") DO (FOR /F "DELIMS=" %%G IN ('CMD.EXE /D /U /C CALL ECHO %%d') DO (CALL SET "RND1=%%G"))
EXIT /B
:RND2
SET "RND1=%RANDOM%%RANDOM%"&&SET "RND1=!RND1:~5,5!"&&SET "RND1=!RND1:~1,1!"
EXIT /B
:CLEAN
FOR %%G in (XS HZ REG TMP LST DSK PAK DRVR DISM) DO (IF EXIST "$%%G*" DEL /Q /F "$%%G*">NUL)
IF EXIST "%TEMP%\DISK_TARGET" DEL /Q /F "%TEMP%\DISK_TARGET">NUL 2>&1
EXIT /B
:CHECK
SET "ERROR="&&IF NOT DEFINED SELECT SET "ERROR=1"
IF NOT DEFINED ERROR SET "CHAR_CHK= "&&SET "CHAR_STR=%SELECT%"&&CALL:CHAR_CHK
IF NOT DEFINED ERROR IF "%CHECK%"=="NUM" IF "%SELECT%" LSS "0" SET "ERROR=1"
IF NOT DEFINED ERROR IF "%CHECK%"=="NUM" IF "%SELECT%" GTR "9999999" SET "ERROR=1"
IF NOT DEFINED ERROR IF "%CHECK%"=="NUM" SET "CAPS_SET=SELECT"&&SET "CAPS_VAR=%SELECT%"&&CALL:CAPS_SET
IF NOT DEFINED ERROR IF "%CHECK%"=="NUM" FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (SET "CHAR_CHK=%%G"&&SET "CHAR_STR=%SELECT%"&&CALL:CHAR_CHK)
IF NOT DEFINED ERROR IF "%CHECK%"=="LTR" SET "CAPS_SET=SELECT"&&SET "CAPS_VAR=%SELECT%"&&CALL:CAPS_SET
IF NOT DEFINED ERROR IF "%CHECK%"=="LTR" FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (SET "CHAR_CHK=%%G"&&SET "CHAR_STR=%SELECT%"&&CALL:CHAR_CHK)
SET "CHECK="
EXIT /B
:VER_GET
IF NOT DEFINED VER_TMP SET "VER_TMP=VER_CUR"
IF EXIST "%VER_GET%" SET /P VER_CHK=<"%VER_GET%"
FOR /F "TOKENS=1-9 DELIMS= " %%A IN ("%VER_CHK%") DO (SET "%VER_TMP%=%%G")
SET "VER_CHK="&&SET "VER_GET="&&SET "VER_TMP="
EXIT /B
:SETS_LIST
SET SETS_LIST=PAD_TYPE COLOR_TXT COLOR_ACC COLOR_BTN COLOR_SIZ COLOR_LAY COLOR_SEQ SOURCE_TYPE WIM_SOURCE VHDX_SOURCE PATH_SOURCE TARGET_TYPE WIM_TARGET VHDX_TARGET WIM_XLVL VHDX_XLVL VHDX_SIZE WIM_INDEX PACK_XLVL BRUTE_FORCE SAFE_EXCLUDE SVC_SKIP COMP_SKIP BASIC_MODE HOST_HIDE HOST_SIZE BOOT_TIMEOUT VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5 VHDX_SLOT6 VHDX_SLOT7 VHDX_SLOT8 VHDX_SLOT9 SHORTCUTS HOTKEY_1 SHORT_1 HOTKEY_2 SHORT_2 HOTKEY_3 SHORT_3 HOTKEY_4 SHORT_4 HOTKEY_5 SHORT_5 DISCLAIMER
EXIT /B
:SETS_LOAD
IF EXIST "settings.ini" FOR /F "eol=- TOKENS=1-2 DELIMS==" %%a in (settings.ini) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
EXIT /B
:SETS_SAVE
CALL:SETS_LIST&&ECHO.Windows Deployment Image Customization Kit v %VER_CUR% Settings>"settings.ini"
FOR %%a in (%SETS_LIST%) DO (CALL ECHO %%a=%%%%a%%>>"settings.ini")
IF "%PROG_MODE%"=="RAMDISK" IF EXIST "S:\$" COPY /Y "settings.ini" "S:\$">NUL
SET "SETS_LIST="&&EXIT /B
:SETS_CLEAR
CALL:SETS_LIST
FOR %%a in (%SETS_LIST%) DO (SET %%a=)
SET "SETS_LIST="&&EXIT /B
:SETS_HANDLER
IF NOT EXIST "%PROG_SOURCE%" SET "PROG_SOURCE=%PROG_FOLDER%"
CD /D "%PROG_FOLDER%"&&IF EXIST "settings.ini" IF NOT DEFINED $ETS SET "$ETS=1"&&CALL:SETS_LOAD
FOR %%a in (PACK_XLVL WIM_XLVL) DO (IF NOT DEFINED %%a SET "%%a=FAST")
FOR %%a in (MAKER_SLOT SHORT_SLOT IMAGEPROC_SLOT) DO (IF NOT DEFINED %%a SET "%%a=1")
FOR %%a in (SAFE_EXCLUDE) DO (IF NOT DEFINED %%a SET "%%a=ENABLED")
FOR %%a in (BRUTE_FORCE SHORTCUTS VHDX_XLVL FMGR_DUAL HOST_HIDE HOST_SIZE BASIC_MODE) DO (IF NOT DEFINED %%a SET "%%a=DISABLED")
IF NOT DEFINED SVC_SKIP SET "SVC_SKIP=EDGEUPDATE EDGEUPDATEM WDNISSVC WINDEFEND WMPNETWORKSVC"
IF NOT DEFINED SOURCE_TYPE SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"
IF NOT DEFINED NEXT_BOOT SET "NEXT_BOOT=NULL"
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25600"
IF NOT DEFINED COLOR_SEQ SET "COLOR_SEQ=6666600000"
IF NOT DEFINED HOTKEY_1 SET "HOTKEY_1=CMD"&&SET "SHORT_1=START CMD.EXE"
IF NOT DEFINED HOTKEY_2 SET "HOTKEY_2=NOTE"&&SET "SHORT_2=START NOTEPAD.EXE"
IF NOT DEFINED HOTKEY_3 SET "HOTKEY_3=REG"&&SET "SHORT_3=START REGEDIT.EXE"
CALL:SETS_SAVE
:FOLDER_LOCATE
SET "MAKER_FOLDER=%PROG_SOURCE%\Project%MAKER_SLOT%"
IF EXIST "%PROG_SOURCE%\AutoBoot.cmd" (SET "AUTOBOOT=ENABLED") ELSE (SET "AUTOBOOT=DISABLED")
SET "FOLDER_MODE=UNIFIED"&&IF EXIST "%PROG_SOURCE%\CACHE" IF EXIST "%PROG_SOURCE%\IMAGE" IF EXIST "%PROG_SOURCE%\PACK" IF EXIST "%PROG_SOURCE%\LIST" IF EXIST "%PROG_SOURCE%\BOOT" SET "FOLDER_MODE=ISOLATED"
IF "%FOLDER_MODE%"=="ISOLATED" FOR %%a in (CACHE IMAGE PACK LIST BOOT) DO (SET "%%a_FOLDER=%PROG_SOURCE%\%%a")
IF "%FOLDER_MODE%"=="UNIFIED" FOR %%a in (CACHE IMAGE PACK LIST BOOT) DO (SET "%%a_FOLDER=%PROG_SOURCE%")
IF NOT DEFINED XLR0 SET "XLR0=[97m"&&SET "XLR1=[31m"&&SET "XLR2=[91m"&&SET "XLR3=[33m"&&SET "XLR4=[93m"&&SET "XLR5=[92m"&&SET "XLR6=[96m"&&SET "XLR7=[94m"&&SET "XLR8=[34m"&&SET "XLR9=[95m"&&CALL:PAD_LINE>NUL 2>&1
FOR %%a in (APPLYDIR CAPTUREDIR $VHDX ERROR) DO (SET "%%a=")
IF "%PROG_MODE%"=="COMMAND" EXIT /B
IF "%PROG_MODE%"=="RAMDISK" FOR %%a in (VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5 VHDX_SLOT6 VHDX_SLOT7 VHDX_SLOT8 VHDX_SLOT9) DO (SET "OBJ_FLD=%PROG_SOURCE%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
IF NOT EXIST "%PATH_SOURCE%\*" SET "PATH_SOURCE=SELECT"
FOR %%a in (VHDX_SLOTX WIM_SOURCE VHDX_SOURCE) DO (SET "OBJ_FLD=%IMAGE_FOLDER%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (WIM_SOURCE VHDX_SOURCE WIM_TARGET VHDX_TARGET VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5 VHDX_SLOT6 VHDX_SLOT7 VHDX_SLOT8 VHDX_SLOT9) DO (IF NOT DEFINED %%a SET "%%a=SELECT")
SET "OBJ_FLD="&&SET "OBJ_CHK="&&SET "OBJ_CHKX="&&IF "%WIM_SOURCE%"=="SELECT" SET "WIM_INDEX=1"
EXIT /B
:OBJ_CLEAR
CALL SET "OBJ_CHKX=%%%OBJ_CHK%%%"
IF NOT EXIST "%OBJ_FLD%\%OBJ_CHKX%" CALL SET "%OBJ_CHK%=SELECT"
EXIT /B
:FOLDER_MODE
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO.       The folder structure will be regenerated. If a file is &&ECHO.     open/mounted and cannot be moved it's possible to lose data.&&ECHO.&&ECHO.                         Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT "%SELECT%"=="X" EXIT /B
IF "%FOLDER_MODE%"=="UNIFIED" SET "FOLDER_MODE=ISOLATED"&&GOTO:FOLDER_ISOLATED
IF "%FOLDER_MODE%"=="ISOLATED" SET "FOLDER_MODE=UNIFIED"&&GOTO:FOLDER_UNIFIED
:FOLDER_UNIFIED
FOR %%a in (CACHE IMAGE PACK LIST BOOT) DO (IF EXIST "%PROG_SOURCE%\%%a" MOVE /Y "%PROG_SOURCE%\%%a\*.*" "%PROG_SOURCE%">NUL 2>&1)
FOR %%a in (CACHE IMAGE PACK LIST BOOT) DO (IF EXIST "%PROG_SOURCE%\%%a" XCOPY /S /C /Y "%PROG_SOURCE%\%%a" "%PROG_SOURCE%">NUL 2>&1)
FOR %%a in (CACHE IMAGE PACK LIST BOOT) DO (IF EXIST "%PROG_SOURCE%\%%a" RD /Q /S "\\?\%PROG_SOURCE%\%%a">NUL 2>&1)
EXIT /B
:FOLDER_ISOLATED
FOR %%a in (CACHE IMAGE PACK LIST BOOT) DO (IF NOT EXIST "%PROG_SOURCE%\%%a" MD "%PROG_SOURCE%\%%a">NUL 2>&1)
FOR %%a in (UNATTEND.XML WALLPAPER.JPG) DO (IF EXIST "%PROG_SOURCE%\%%a" MOVE /Y "%PROG_SOURCE%\%%a" "%PROG_SOURCE%\CACHE">NUL 2>&1)
FOR %%a in (EFI SDI SAV) DO (IF EXIST "%PROG_SOURCE%\*.%%a" MOVE /Y "%PROG_SOURCE%\*.%%a" "%PROG_SOURCE%\BOOT">NUL 2>&1)
FOR %%a in (LST MST) DO (IF EXIST "%PROG_SOURCE%\*.%%a" MOVE /Y "%PROG_SOURCE%\*.%%a" "%PROG_SOURCE%\LIST">NUL 2>&1)
FOR %%a in (ISO VHDX WIM) DO (IF EXIST "%PROG_SOURCE%\*.%%a" MOVE /Y "%PROG_SOURCE%\*.%%a" "%PROG_SOURCE%\IMAGE">NUL 2>&1)
FOR %%a in (PKG PKX CAB MSU APPX APPXBUNDLE MSIXBUNDLE) DO (IF EXIST "%PROG_SOURCE%\*.%%a" MOVE /Y "%PROG_SOURCE%\*.%%a" "%PROG_SOURCE%\PACK">NUL 2>&1)
EXIT /B
:FILE_PICK
IF NOT DEFINED PICK GOTO:PICK_ERROR
IF NOT DEFINED NOCLS CLS
CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX
IF "%PICK%"=="MAIN" (SET "PICKX=MAIN FOLDER VHDX") ELSE (SET "PICKX=%PICK%")
ECHO   %#@%AVAILABLE %PICKX%'S:%#$%&&SET "PICKX="&&IF "%PICK%"=="LST" SET "NOECHO1=1"&&ECHO.&&ECHO  ( %##%0%#$% ) %##%Create New List%#$%
SET "NLIST=%PICK%"&&CALL:FILE_LIST&&SET "BOX=B1"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV
FOR %%a in (ERROR SELECT LIST_NAME $MAKE $PICK $ELECT $ELECT$ $HEAD FILE_PATH FILE_NAME FILE_EXT) DO (SET "%%a=")
SET /P "SELECT=$>>"&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "SELECT=%%SELECT:%%G=%%G%%")
IF "%SELECT%"=="@" IF "%PICK%"=="VHDX" SET "LIVE_APPLY=1"&&GOTO:PICK_ERROR
IF "%SELECT%"=="0" IF NOT "%PICK%"=="LST" SET "ERROR=1"
IF "%SELECT%" GTR "9999999" SET "ERROR=1"
IF "%SELECT%" LSS "0" SET "ERROR=1"
IF DEFINED ERROR GOTO:PICK_ERROR
IF "%SELECT%"=="0" IF "%PICK%"=="LST" SET "$MAKE=1"
CALL SET "$ELECT=%SELECT%"&&CALL SET "$ELECT$=%%$ITEM%SELECT%%%"
IF NOT "%SELECT%"=="0" IF NOT DEFINED $ELECT$ SET "ERROR=1"&&GOTO:PICK_ERROR
SET "$FOLD="&&FOR %%a in (ISO VHDX WIM) DO (IF "%PICK%"=="%%a" SET "$FOLD=%IMAGE_FOLDER%")
FOR %%a in (APPX APPXBUNDLE MSIXBUNDLE PKG PKX CAB MSU) DO (IF "%PICK%"=="%%a" SET "$FOLD=%PACK_FOLDER%")
FOR %%a in (LST MST) DO (IF "%PICK%"=="%%a" SET "$FOLD=%LIST_FOLDER%")
IF "%PICK%"=="MAIN" SET "$FOLD=%PROG_SOURCE%"
IF "%PICK%"=="FMGS" SET "$FOLD=%FMGR_SOURCE%"
IF NOT DEFINED $FOLD SET "ERROR=1"&&GOTO:PICK_ERROR
IF NOT EXIST "%$FOLD%\%$ELECT$%" SET "ERROR=1"&&GOTO:PICK_ERROR
IF DEFINED $MAKE CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                          Enter new name of list&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV
IF DEFINED $MAKE SET /P "LIST_NAME=$>>"
IF DEFINED $MAKE IF NOT DEFINED LIST_NAME SET "ERROR=1"&&GOTO:PICK_ERROR
IF DEFINED $MAKE SET "$ELECT$=%LIST_NAME%.lst"&&ECHO EXEC-LIST>"%$FOLD%\%LIST_NAME%.lst"
IF EXIST "%$FOLD%\%$ELECT$%" SET "$PICK=%$FOLD%\%$ELECT$%"
FOR %%a in (LST MST) DO (IF "%PICK%"=="%%a" SET /P $HEAD=<"%$PICK%")
IF "%PICK%"=="LST" IF NOT "%$HEAD%"=="EXEC-LIST" SET "ERROR=1"
IF "%PICK%"=="MST" IF NOT "%$HEAD%"=="BASE-LIST" IF NOT "%$HEAD%"=="BASE-GROUP" SET "ERROR=1"
IF DEFINED ERROR CALL:PAD_LINE&&ECHO                       Bad file-header, check file&&CALL:PAD_LINE&&CALL:PAUSED
:PICK_ERROR
IF NOT DEFINED ERROR FOR %%G in ("%$PICK%") DO (SET "FILE_PATH=%%~dG%%~pG"&&SET "FILE_BODY=%%~nG"&&SET "FILE_EXT=%%~xG")
IF NOT DEFINED ERROR FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "FILE_PATH=%%FILE_PATH:%%G=%%G%%"&&CALL SET "FILE_BODY=%%FILE_BODY:%%G=%%G%%"&&CALL SET "FILE_EXT=%%FILE_EXT:%%G=%%G%%")
SET "PICK="&&IF DEFINED ERROR SET "$PICK="
EXIT /B
:FILE_LIST
SET "$FOLD="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30) DO (IF DEFINED $ITEM%%a SET "$ITEM%%a=")
IF NOT DEFINED BLIST IF NOT DEFINED NLIST GOTO:FILE_ERROR
IF DEFINED BLIST SET "$MENU=BAS"&&SET "EXT=%BLIST%"
IF DEFINED NLIST SET "$MENU=NUM"&&SET "EXT=%NLIST%"
FOR %%a in (ISO VHDX WIM) DO (IF "%EXT%"=="%%a" SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.%EXT%"&&SET "$LABEL=IMAGE")
FOR %%a in (APPX APPXBUNDLE MSIXBUNDLE PKG PKX CAB MSU) DO (IF "%EXT%"=="%%a" SET "$FOLD=%PACK_FOLDER%"&&SET "$FILT=*.%EXT%"&&SET "$LABEL=PACK")
FOR %%a in (LST MST) DO (IF "%EXT%"=="%%a" SET "$FOLD=%LIST_FOLDER%"&&SET "$FILT=*.%EXT%"&&SET "$LABEL=LIST")
IF "%EXT%"=="MAIN" SET "$FOLD=%PROG_SOURCE%"&&SET "$FILT=*.VHDX"&&SET "$LABEL=MAIN"
IF "%EXT%"=="FMGS" SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$LABEL=FMGS"
IF "%EXT%"=="FMGT" SET "$FOLD=%FMGR_TARGET%"&&SET "$FILT=*.*"&&SET "$LABEL=FMGT"
IF "%EXT%"=="MAK" SET "$FOLD=%MAKER_FOLDER%"&&SET "$FILT=*.*"&&SET "$LABEL=Project%MAKER_SLOT%"
IF "%EXT%"=="SRC" SET "$FOLD=%PROG_SOURCE%"&&SET "$FILT=*.*"&&SET "$LABEL=MAIN"
IF NOT DEFINED $FOLD GOTO:FILE_ERROR
IF NOT DEFINED CRICKETS SET "CRICKETS= EMPTY.."
IF NOT DEFINED NOECHO1 IF NOT DEFINED MENU_INSERTA ECHO.
IF DEFINED MENU_INSERTA ECHO.&&ECHO.%MENU_INSERTA%
IF NOT EXIST "%$FOLD%\%$FILT%" ECHO   %CRICKETS%
IF EXIST "%$FOLD%\%$FILT%" SET "$XNT="&&FOR /F "TOKENS=*" %%a in ('DIR "%$FOLD%\%$FILT%" /A: /B /O:GN') DO (CALL SET /A "$XNT+=1"&&CALL SET "$CLM$=%%a"&&CALL:FILE_LISTX)
IF NOT DEFINED NOECHO2 ECHO.
IF EXIST "$HZ" DEL /F "$HZ">NUL 2>&1
:FILE_ERROR
FOR %%a in ($MENU $FOLD $LABEL $XNT EXT BLIST NLIST CRICKETS NOECHO1 NOECHO2 MENU_INSERTA NOCLS) DO (SET "%%a=")
EXIT /B
:FILE_LISTX
CALL SET "$ITEM%$XNT%=%$CLM$%"
IF EXIST "%$FOLD%\%$CLM$%\*" (SET "LIST_1=%#@%"&&SET "LIST_2=%#$%") ELSE (SET "LIST_1="&&SET "LIST_2=")
IF "%$MENU%"=="NUM" ECHO  ( %##%%$XNT%%#$% ) %LIST_1%%$CLM$%%LIST_2%
IF "%$MENU%"=="BAS" ECHO    %LIST_1%%$CLM$%%LIST_2%
EXIT /B
:LIST_FILE
SET "ERROR="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30) DO (IF DEFINED $ITEM%%a SET "$ITEM%%a=")
IF NOT DEFINED BLIST IF NOT DEFINED NLIST GOTO:LIST_ERROR
IF NOT EXIST "%$LIST%" GOTO:LIST_ERROR
IF DEFINED BLIST SET "$MENU=BAS"&&SET "EXT=%BLIST%"
IF DEFINED NLIST SET "$MENU=NUM"&&SET "EXT=%NLIST%"
SET "$HEAD="&&FOR %%a in (LST MST) DO (IF "%EXT%"=="%%a" SET /P $HEAD=<"%$LIST%")
IF "%EXT%"=="LST" IF NOT "%$HEAD%"=="EXEC-LIST" SET "ERROR=1"
IF "%EXT%"=="MST" IF NOT "%$HEAD%"=="BASE-LIST" IF NOT "%$HEAD%"=="BASE-GROUP" SET "ERROR=1"
IF DEFINED ERROR CALL:PAD_LINE&&ECHO                       Bad file-header, check file&&CALL:PAD_LINE&&CALL:PAUSED&&GOTO:LIST_ERROR
COPY /Y "%$LIST%" "$HZ">NUL
IF NOT DEFINED NOECHO1 ECHO.
SET "$CLM1_LST="&&SET "$CLM2_LST="&&SET "$CLM3_LST="
IF "%EXT%"=="MST" SET "$XNT="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=[]" %%1 in ($HZ) DO (IF NOT "%%1"=="" CALL SET "$CLM1=%%1"&&CALL SET "$CLM2=%%2"&&CALL SET "$CLM3=%%3"&&CALL:LIST_FILEX)
IF NOT DEFINED NOECHO2 ECHO.
IF EXIST "$HZ" DEL /F "$HZ">NUL 2>&1
:LIST_ERROR
FOR %%a in ($LIST $CLM1 $CLM2 $CLM3 $CLM1_LST $CLM2_LST $CLM3_LST $XNT EXT BLIST NLIST ONLY1 ONLY2 ONLY3 $MENU) DO (SET "%%a=")
EXIT /B
:LIST_FILEX
IF DEFINED ONLY1 IF NOT "%$CLM1%"=="%ONLY1%" EXIT /B
IF DEFINED ONLY2 IF NOT "%$CLM2%"=="%ONLY2%" EXIT /B
IF DEFINED ONLY3 IF NOT "%$CLM3%"=="%ONLY3%" EXIT /B
IF "%$HEAD%"=="BASE-GROUP" IF DEFINED ONLY1 IF NOT DEFINED ONLY2 IF "%$CLM2%"=="%$CLM2_LST%" EXIT /B
IF "%$HEAD%"=="BASE-GROUP" SET "$CLM1_LST=%$CLM1%"&&SET "$CLM2_LST=%$CLM2%"&&SET "$CLM3_LST=%$CLM3%"
CALL SET /A "$XNT+=1"
CALL SET "$ITEM%$XNT%=[%$CLM1%][%$CLM2%][%$CLM3%]"
IF DEFINED ONLY1 IF DEFINED ONLY2 ECHO  ( %##%%$XNT%%#$% ) %$CLM3%&&EXIT /B
IF "%$MENU%"=="NUM" ECHO  ( %##%%$XNT%%#$% ) %$CLM2%
IF "%$MENU%"=="BAS" ECHO    %#@%%$CLM1%%#$% %$CLM2%
EXIT /B
::#########################################################################
:SETTINGS_MENU
::#########################################################################
CLS&&CALL:SETS_HANDLER&&CALL:PAD_LINE&&ECHO                         Settings Configuration&&CALL:PAD_LINE&&ECHO.
ECHO  (%##%1%#$%) Padding Style     %#@%PAD %PAD_TYPE%%#$%&&ECHO  (%##%2%#$%) Color Text        %#@%COLOR %COLOR_TXT%%#$%&&ECHO  (%##%3%#$%) Color Accent      %#@%COLOR %COLOR_ACC%%#$%&&ECHO  (%##%4%#$%) Color Button      %#@%COLOR %COLOR_BTN%%#$%&&ECHO  (%##%5%#$%) Color Size        %#@%%COLOR_SIZ%%#$%&&ECHO  (%##%6%#$%) Color Layout      %#@%%COLOR_LAY%%#$%&&ECHO  (%##%7%#$%) Color Sequence    %#@%%COLOR_SEQ%%#$%&&ECHO  (%##%8%#$%) Folder Layout     %#@%%FOLDER_MODE%%#$%&&ECHO.&&CALL:PAD_LINE
ECHO  [%#@%Settings%#$%]  (%##%S%#$%)hortcuts                          (%##%#%#$%) Clear Settings&&CALL:PAD_LINE
IF "%SHORTCUTS%"=="ENABLED" CALL ECHO  [%#@%Shortcut%#$%]  (%##%X%#$%)Slot %#@%%SHORT_SLOT%%#$%   (%##%A%#$%)ssign %#@%%%SHORT_%SHORT_SLOT%%%%#$%   (%##%H%#$%)otKey %#@%%%HOTKEY_%SHORT_SLOT%%%%#$%&&CALL:PAD_LINE
CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="#" CALL:SETS_CLEAR&&SET "SELECT="
IF "%SELECT%"=="8" CALL:FOLDER_MODE&&SET "SELECT="
IF "%SELECT%"=="A" IF "%SHORTCUTS%"=="ENABLED" CALL:SHORTCUTS
IF "%SELECT%"=="H" IF "%SHORTCUTS%"=="ENABLED" CALL:SHORTCUTS
IF "%SELECT%"=="S" IF "%SHORTCUTS%"=="DISABLED" SET "SHORTCUTS=ENABLED"&&SET "SELECT="
IF "%SELECT%"=="S" IF "%SHORTCUTS%"=="ENABLED" SET "SHORTCUTS=DISABLED"&&SET "SELECT="
IF "%SELECT%"=="X" SET /A "SHORT_SLOT+=1"&&IF "%SHORT_SLOT%"=="5" SET "SHORT_SLOT=1"&&SET "SELECT="
FOR %%a in (- 1 2 3 4 5 6 7) DO (IF "%SELECT%"=="%%a" CALL:VISUAL_OPTIONS)
GOTO:SETTINGS_MENU
:VISUAL_OPTIONS
IF "%SELECT%"=="1" SET /A "PAD_TYPE+=1"&&IF "%PAD_TYPE%"=="7" SET "PAD_TYPE=1"&&SET "SELECT="
IF "%SELECT%"=="2" SET /A "COLOR_TXT+=1"&&IF "%COLOR_TXT%"=="9" SET "COLOR_TXT=0"&&SET "SELECT="
IF "%SELECT%"=="3" SET /A "COLOR_ACC+=1"&&IF "%COLOR_ACC%"=="9" SET "COLOR_ACC=0"&&SET "SELECT="
IF "%SELECT%"=="4" SET /A "COLOR_BTN+=1"&&IF "%COLOR_BTN%"=="9" SET "COLOR_BTN=0"&&SET "SELECT="
IF "%SELECT%"=="5" IF "%COLOR_SIZ%"=="LARGE" SET "COLOR_SIZ=SMALL"&&SET "SELECT="
IF "%SELECT%"=="5" IF "%COLOR_SIZ%"=="SMALL" SET "COLOR_SIZ=LARGE"&&SET "SELECT="
IF "%SELECT%"=="6" IF "%COLOR_LAY%"=="STATIC" SET "COLOR_LAY=CHESS"&&SET "SELECT="
IF "%SELECT%"=="6" IF "%COLOR_LAY%"=="CHESS" SET "COLOR_LAY=STATIC"&&SET "SELECT="
IF "%SELECT%"=="7" CALL:PAD_LINE&&ECHO     Type 10 digit color sequence [ %XLR0%0%XLR1%1%XLR2%2%XLR3%3%XLR4%4%XLR5%5%XLR6%6%XLR7%7%XLR8%8%XLR9%9%#$% ] or (%##%-%#$%) for default&&CALL:PAD_LINE&&SET "PROMPT_SET=COLOR_XXX"&&CALL:PROMPT_SET
IF "%SELECT%"=="7" IF "%COLOR_XXX%"=="-" SET "COLOR_SEQ="&&SET "SELECT="
IF "%SELECT%"=="7" SET "XNTX="&&FOR /F "DELIMS=" %%G IN ('CMD.EXE /D /U /C ECHO %COLOR_XXX%^| FIND /V ""') do (CALL SET /A XNTX+=1)
IF "%SELECT%"=="7" IF "%XNTX%"=="10" SET "COLOR_SEQ=%COLOR_XXX%"
EXIT /B
:SHORTCUTS
IF "%SELECT%"=="A" SET "PROMPT_SET=SHORT_%SHORT_SLOT%"&&CALL:PAD_LINE&&ECHO                              Type Command&&CALL:PAD_LINE&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF "%SELECT%"=="H" CALL:PAD_LINE&&ECHO                          Type 2+ Digit Hotkey&&CALL:PAD_LINE&&SET "PROMPT_SET=HOTKEY_%SHORT_SLOT%"&&CALL:PROMPT_SET
EXIT /B
:AUTOBOOT_COUNT
IF EXIST "S:\$\ERR.TXT" SET "AUTOBOOT=DISABLED"&&DEL "S:\$\ERR.TXT"&&MOVE /Y "S:\$\AutoBoot.cmd" "S:\$\AutoBoot.txt">NUL&EXIT /B
ECHO;@ECHO OFF>X:\COUNT.CMD
ECHO;FOR %%%%a in (20 19 18 17 16 15 14 13 13 12 11 10 9 8 7 6 5 4 3 2 1 0) DO (CLS^&^&ECHO AutoBoot starts in %%%%a seconds...^&^&PING -n 2 127.0.0.1^>NUL)>>X:\COUNT.CMD
ECHO;CD /D S:\$>>X:\COUNT.CMD
ECHO;CALL S:\$\AutoBoot.cmd>>X:\COUNT.CMD
ECHO;ECHO AutoBoot Finished. Restarting in 5 Seconds>>X:\COUNT.CMD
ECHO;PING -n 6 127.0.0.1^>NUL >>X:\COUNT.CMD
ECHO;DEL /Q /F S:\$\ERR.TXT>>X:\COUNT.CMD
ECHO;EXIT^&^&EXIT>>X:\COUNT.CMD	
CALL:PAD_LINE&&ECHO              To cancel AutoBoot close countdown window.
ECHO    Press (N) to return to recovery. Press (Y) for command prompt.&&CALL:PAD_LINE
ECHO AUTOBOOT>S:\$\ERR.TXT
START /WAIT X:\COUNT.CMD
IF EXIST "S:\$\ERR.TXT" SET "AUTOBOOT=DISABLED"&&DEL "S:\$\ERR.TXT"&&MOVE /Y "S:\$\AutoBoot.cmd" "S:\$\AutoBoot.txt">NUL
EXIT /B
:SHORTCUT_RUN
SET "SHORT_RUN="&&CALL:CHECK
IF DEFINED ERROR EXIT /B
IF "%SELECT%"=="%HOTKEY_1%" SET "SHORT_RUN=%SHORT_1%"
IF "%SELECT%"=="%HOTKEY_2%" SET "SHORT_RUN=%SHORT_2%"
IF "%SELECT%"=="%HOTKEY_3%" SET "SHORT_RUN=%SHORT_3%"
IF "%SELECT%"=="%HOTKEY_4%" SET "SHORT_RUN=%SHORT_4%"
IF "%SELECT%"=="%HOTKEY_5%" SET "SHORT_RUN=%SHORT_5%"
IF NOT DEFINED SHORT_RUN EXIT /B
ECHO;@ECHO OFF >OUTER.BAT
ECHO;SET CRASHED=>>OUTER.BAT
ECHO;CMD /C INNER.BAT >>OUTER.BAT
ECHO;IF EXIST INNER.BAT SET CRASHED=1 >>OUTER.BAT
ECHO;IF EXIST INNER.BAT WINDICK.CMD >>OUTER.BAT
ECHO;@ECHO OFF >INNER.BAT
ECHO;%SHORT_RUN% >>INNER.BAT
ECHO;DEL /Q /F %%0 >>INNER.BAT
CMD /C OUTER.BAT>NUL 2>&1
DEL /Q /F OUTER.BAT>NUL 2>&1
EXIT /B
::#########################################################################
:IMAGE_PROCESSOR
::#########################################################################
@ECHO OFF&&CLS&&CALL:SETS_HANDLER&&CALL:TITLE_X&&CALL:CLEAN&&SET "SOURCE_LOCATION="&&FOR %%a in (A B C D E F G H I J K L N O P Q R S T U W Y Z) DO (IF EXIST "%%a:\sources\install.wim" SET "SOURCE_LOCATION=%%a:\sources")
CALL:PAD_LINE&&ECHO                            Image Processing&&CALL:PAD_LINE
IF DEFINED SOURCE_LOCATION ECHO   (%##%-%#$%)Import Boot  %##%Windows Installation Media Detected%#$%  Import WIM(%##%+%#$%)&&CALL:PAD_LINE
IF NOT DEFINED SOURCE_LOCATION IF NOT EXIST "%IMAGE_FOLDER%\*.WIM" ECHO    Insert a Windows Disc/ISO/USB to Import Installation/Boot Media&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="WIM" IF "%WIM_SOURCE%"=="SELECT" SET "WIM_DESC=NULL"
IF "%SOURCE_TYPE%"=="WIM" IF NOT "%WIM_SOURCE%"=="SELECT" CALL:WIM_INDEX_QUERY
ECHO                              %#@%%SOURCE_TYPE%%#$% (%##%X%#$%) %#@%%TARGET_TYPE%%#$%&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="PATH" ECHO   %#@%AVAILABLE DRIVES:%#$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\*" ECHO    %%G:\)
IF "%SOURCE_TYPE%"=="PATH" ECHO.&&CALL:PAD_LINE&&ECHO. (%##%S%#$%)ource PATH  %#@%%PATH_SOURCE%%#$%  %XLR1%Use caution with this option%#$%&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="VHDX" ECHO   %#@%AVAILABLE VHDX'S:%#$%&&SET "BLIST=VHDX"&&CALL:FILE_LIST&&CALL:PAD_LINE&&ECHO. (%##%S%#$%)ource VHDX  %#@%%VHDX_SOURCE%%#$%&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="WIM" ECHO   %#@%AVAILABLE WIM'S:%#$%&&SET "BLIST=WIM"&&CALL:FILE_LIST&&CALL:PAD_LINE&&ECHO. (%##%S%#$%)ource WIM  %#@%%WIM_SOURCE%%#$%   (%##%I%#$%)ndex %#@%%WIM_INDEX%%#$%   Edition: %#@%%WIM_DESC%%#$%&&CALL:PAD_LINE
IF "%TARGET_TYPE%"=="VHDX" ECHO   %#@%EXISTING VHDX'S:%#$%&&SET "BLIST=VHDX"&&CALL:FILE_LIST&&CALL:PAD_LINE&&ECHO. (%##%T%#$%)arget VHDX  %#@%%VHDX_TARGET%%#$%        (%##%G%#$%)o^^!  (%##%V%#$%)Size %#@%%VHDX_SIZE%MB%#$%  (%##%Z%#$%) %#@%%VHDX_XLVL%%#$%&&CALL:PAD_LINE
IF "%TARGET_TYPE%"=="WIM" ECHO   %#@%EXISTING WIM'S:%#$%&&SET "BLIST=WIM"&&CALL:FILE_LIST&&CALL:PAD_LINE&&ECHO. (%##%T%#$%)arget WIM  %#@%%WIM_TARGET%%#$%        (%##%G%#$%)o^^!     (%##%Z%#$%) X-Lvl %#@%%WIM_XLVL%%#$%&&CALL:PAD_LINE
CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="G" CALL:IMAGEPROC_START
IF "%SELECT%"=="X" CALL:IMAGEPROC_SLOT
IF "%SELECT%"=="T" CALL:IMAGEPROC_PROMPT
IF "%SELECT%"=="Z" CALL:IMAGEPROC_XLVL
IF "%SELECT%"=="S" CALL:IMAGEPROC_PICK&&SET "SELECT="
IF "%SELECT%"=="V" IF "%TARGET_TYPE%"=="VHDX" CALL:IMAGEPROC_VSIZE&&SET "SELECT="
IF "%SELECT%"=="I" IF "%SOURCE_TYPE%"=="WIM" IF NOT "%WIM_SOURCE%"=="SELECT" CALL:WIM_INDEX
IF "%SELECT%"=="+" IF DEFINED SOURCE_LOCATION CALL:SOURCE_IMPORT&&SET "SELECT="
IF "%SELECT%"=="-" IF DEFINED SOURCE_LOCATION CALL:BOOT_IMPORT&&SET "SELECT="
GOTO:IMAGE_PROCESSOR
:IMAGEPROC_START
CALL:PAD_LINE&&ECHO                         Image Processing Start&&CALL:PAD_LINE&&SET "ERR_MSG="&&SET "APPLYDIR_MASTER=V:"&&SET "CAPTUREDIR_MASTER=V:"&&SET "VHDX_MB=%VHDX_SIZE%"
IF EXIST "V:\" SET "ERR_MSG=%##%Drive letter V:\ can NOT be in use. Unmount the Vdisk in use.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%SOURCE_TYPE%"=="PATH" IF "%PATH_SOURCE%"=="SELECT" SET "ERR_MSG=%##%Source %SOURCE_TYPE% not set.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%SOURCE_TYPE%"=="WIM" IF "%WIM_SOURCE%"=="SELECT" SET "ERR_MSG=%##%Source %SOURCE_TYPE% not set.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%TARGET_TYPE%"=="WIM" IF "%WIM_TARGET%"=="SELECT" SET "ERR_MSG=%##%Target %TARGET_TYPE% not set.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%TARGET_TYPE%"=="WIM" IF EXIST "%IMAGE_FOLDER%\%WIM_TARGET%" SET "ERR_MSG=%##%Target %WIM_TARGET% exists. Try another name or delete the existing file.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%SOURCE_TYPE%"=="PATH" IF NOT EXIST "%PATH_SOURCE%\*" SET "ERR_MSG=%##%Source %SOURCE_TYPE% doesn't exist.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%SOURCE_TYPE%"=="VHDX" IF "%VHDX_SOURCE%"=="SELECT" SET "ERR_MSG=%##%Source %SOURCE_TYPE% not set.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%TARGET_TYPE%"=="VHDX" IF "%VHDX_TARGET%"=="SELECT" SET "ERR_MSG=%##%Target %TARGET_TYPE% not set.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                     File %#@%%VHDX_TARGET%%#$% already exists.&&ECHO   %XLR2%Note:%#$% Updating may cause errors. Try a new vhdx if having issues.&&ECHO.&&ECHO.                        Press (%##%X%#$%) to overwrite.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" IF NOT "%CONFIRM%"=="X" SET "ERR_MSG=%##%Aborted.%#$%"&&GOTO:IMAGEPROC_CLEANUP
IF "%VHDX_XLVL%"=="COMPACT" (SET "COMPACTX= /COMPACT") ELSE (SET "COMPACTX=")
IF NOT DEFINED WIM_INDEX SET "WIM_INDEX=1"
IF NOT DEFINED WIM_XLVL SET "WIM_XLVL=FAST"
CALL:VDISK_DETACH&&CALL:SCRATCH_CREATE
IF "%SOURCE_TYPE%"=="PATH" SET "APPLYDIR_MASTER=%PATH_SOURCE%"&&SET "CAPTUREDIR_MASTER=%PATH_SOURCE%"
IF "%SOURCE_TYPE%"=="VHDX" SET "VDISK=%IMAGE_FOLDER%\%VHDX_SOURCE%"
IF "%TARGET_TYPE%"=="VHDX" SET "VDISK=%IMAGE_FOLDER%\%VHDX_TARGET%"
IF "%SOURCE_TYPE%"=="WIM" SET "IMAGE_SRC=%IMAGE_FOLDER%\%WIM_SOURCE%"
IF "%TARGET_TYPE%"=="WIM" SET "IMAGE_TGT=%IMAGE_FOLDER%\%WIM_TARGET%"
IF "%SOURCE_TYPE%"=="VHDX" IF "%TARGET_TYPE%"=="WIM" CALL:VDISK_ATTACH
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" CALL:VDISK_ATTACH
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="VHDX" IF NOT EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" CALL:VDISK_CREATE
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="WIM" SET "VDISK=%SCRATCHDIR%\SCRATCH.VHDX"&&SET "VHDX_MB=250000"&&CALL:VDISK_CREATE
IF NOT "%SOURCE_TYPE%"=="PATH" IF NOT EXIST "V:\" SET "ERR_MSG=%##%Virtual Disk Error. If VHDX refuses mounting, try another.%#$%"&&CALL:VDISK_DETACH&&GOTO:IMAGEPROC_CLEANUP
CALL:TITLECARD&&IF NOT DEFINED WIM_DESC SET "WIM_DESC=WINDICK"
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="VHDX" DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%IMAGE_SRC%" /INDEX:%WIM_INDEX% /APPLYDIR:"%APPLYDIR_MASTER%"%COMPACTX%
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="WIM" DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%IMAGE_SRC%" /INDEX:%WIM_INDEX% /APPLYDIR:"%APPLYDIR_MASTER%"
IF "%TARGET_TYPE%"=="WIM" IF EXIST "%APPLYDIR_MASTER%\*" DISM /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%CAPTUREDIR_MASTER%" /IMAGEFILE:"%IMAGE_TGT%" /COMPRESS:%WIM_XLVL% /NAME:%WIM_DESC%
IF NOT EXIST "%APPLYDIR_MASTER%\*" SET "ERR_MSG=%##%Source Extraction Error. If WIM refuses to extract, try another.%#$%"
CALL:VDISK_DETACH
:IMAGEPROC_CLEANUP
ECHO.&&IF DEFINED ERR_MSG ECHO %ERR_MSG%&&ECHO.
CALL:SCRATCH_DELETE&&CALL:PAD_LINE&&ECHO                        Image Processing Complete&&CALL:PAD_LINE
EXIT /B
:IMAGEPROC_XLVL
IF "%TARGET_TYPE%"=="WIM" IF "%WIM_XLVL%"=="FAST" SET "WIM_XLVL=MAX"&&EXIT /B
IF "%TARGET_TYPE%"=="WIM" IF "%WIM_XLVL%"=="MAX" SET "WIM_XLVL=NONE"&&EXIT /B
IF "%TARGET_TYPE%"=="WIM" IF "%WIM_XLVL%"=="NONE" SET "WIM_XLVL=FAST"&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" IF "%VHDX_XLVL%"=="COMPACT" SET "VHDX_XLVL=DISABLED"&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" IF "%VHDX_XLVL%"=="DISABLED" SET "VHDX_XLVL=COMPACT"&&EXIT /B
EXIT /B
:IMAGEPROC_VSIZE
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                          New VHDX size in MB?&&ECHO                 Note: 25000 or greater is recommended&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=VHDX_SIZE"&&CALL:PROMPT_SET
SET "SELECT=%VHDX_SIZE%"&&SET "CHECK=NUM"&&CALL:CHECK
IF DEFINED ERROR SET "VHDX_SIZE=25600"
EXIT /B
:IMAGEPROC_PROMPT
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                          Enter new name of .%TARGET_TYPE%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV
IF "%TARGET_TYPE%"=="WIM" SET "PROMPT_SET=WIM_TARGET"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF "%TARGET_TYPE%"=="WIM" IF DEFINED WIM_TARGET SET "WIM_TARGET=%WIM_TARGET%.wim"
IF "%TARGET_TYPE%"=="WIM" IF NOT DEFINED WIM_TARGET SET "ERROR=1"
IF "%TARGET_TYPE%"=="VHDX" SET "PROMPT_SET=VHDX_TARGET"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF "%TARGET_TYPE%"=="VHDX" IF DEFINED VHDX_TARGET SET "VHDX_TARGET=%VHDX_TARGET%.vhdx"
IF "%TARGET_TYPE%"=="VHDX" IF NOT DEFINED VHDX_TARGET SET "ERROR=1"
EXIT /B
:IMAGEPROC_PICK
IF "%SOURCE_TYPE%"=="WIM" SET "PICK=WIM"&&CALL:FILE_PICK
IF "%SOURCE_TYPE%"=="VHDX" SET "PICK=VHDX"&&CALL:FILE_PICK
IF NOT "%SOURCE_TYPE%"=="PATH" CALL SET "%SOURCE_TYPE%_SOURCE=%$ELECT$%"
IF "%SOURCE_TYPE%"=="PATH" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO.                    Enter the source drive letter&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=PATH_LETTER"&&CALL:PROMPT_SET
IF "%SOURCE_TYPE%"=="PATH" SET "PATH_SOURCE=%PATH_LETTER%:"
EXIT /B
:IMAGEPROC_SLOT
SET /A "IMAGEPROC_SLOT+=1"
IF "%IMAGEPROC_SLOT%" GTR "4" SET "IMAGEPROC_SLOT=1"
IF "%IMAGEPROC_SLOT%"=="1" SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"
IF "%IMAGEPROC_SLOT%"=="2" SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"
IF "%IMAGEPROC_SLOT%"=="3" SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=WIM"
IF "%IMAGEPROC_SLOT%"=="4" SET "SOURCE_TYPE=PATH"&&SET "TARGET_TYPE=WIM"
EXIT /B
:WIM_INDEX
SET /A "WIM_INDEX+=1"
IF "%WIM_INDEX%"=="20" SET "WIM_INDEX=1"
CALL:WIM_INDEX_QUERY
EXIT /B
::#########################################################################
:IMAGE_MANAGER
::#########################################################################
@ECHO OFF&&CLS&&SET "LIVE_APPLY="&&CALL:SETS_HANDLER&&CALL:TITLE_X&&CALL:CLEAN&&CALL:PAD_LINE&&ECHO                            Image Management&&CALL:PAD_LINE
ECHO   %#@%AVAILABLE VHDX'S%#$%:&&SET "BLIST=VHDX"&&CALL:FILE_LIST&&CALL:PAD_LINE
ECHO  [%#@%VHDX%#$%]    (%##%I%#$%)nspect      (%##%M%#$%)ount / Unmount&&CALL:PAD_LINE
IF EXIST "%PACK_FOLDER%\*.PKX" ECHO   %#@%AVAILABLE ALL-IN-ONES:%#$%&&SET "BLIST=PKX"&&CALL:FILE_LIST&&CALL:PAD_LINE
IF EXIST "%LIST_FOLDER%\*.LST" ECHO   %#@%AVAILABLE EXEC LISTS:%#$%&&SET "BLIST=LST"&&CALL:FILE_LIST&&CALL:PAD_LINE
IF NOT EXIST "%PACK_FOLDER%\*.PKX" IF NOT EXIST "%LIST_FOLDER%\*.LST" ECHO   %#@%AVAILABLE EXEC LISTS/ALL-IN-ONES:%#$%&&SET "BLIST=LST"&&CALL:FILE_LIST&&CALL:PAD_LINE
ECHO  [%#@%LIST%#$%]    (%##%N%#$%)ew      (%##%E%#$%)dit     (%##%G%#$%)o^^!                    (%##%O%#$%)ptions&&CALL:PAD_LINE
IF DEFINED ADV_IMGM ECHO  (%##%B%#$%)rute Force Mode %#@%%BRUTE_FORCE%%#$%   (%##%X%#$%)Mount ISO   (%##%S%#$%)afe Exclude %#@%%SAFE_EXCLUDE%%#$%&&CALL:PAD_LINE
CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="G" CALL:IMAGEMGR_CHOICE&&SET "SELECT="
IF "%SELECT%"=="I" CALL:IMAGEMGR_INSPECT&&SET "SELECT="
IF "%SELECT%"=="N" CALL:IMAGEMGR_LIST_MAIN&&SET "SELECT="
IF "%SELECT%"=="O" IF DEFINED ADV_IMGM SET "ADV_IMGM="&&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_IMGM SET "ADV_IMGM=1"&&SET "SELECT="
IF "%SELECT%"=="E" SET "PICK=LST"&&CALL:FILE_PICK&&CALL:LIST_EDIT&&SET "SELECT="
IF "%SELECT%"=="X" SET "PICK=ISO"&&CALL:FILE_PICK&&CALL:ISO_MOUNT&&SET "SELECT="
IF "%SELECT%"=="B" IF "%BRUTE_FORCE%"=="ENABLED" SET "BRUTE_FORCE=DISABLED"&&SET "SELECT="
IF "%SELECT%"=="B" IF "%BRUTE_FORCE%"=="DISABLED" SET "BRUTE_FORCE=ENABLED"&&SET "SELECT="
IF "%SELECT%"=="S" IF "%SAFE_EXCLUDE%"=="DISABLED" SET "SAFE_EXCLUDE=ENABLED"&&SET "SELECT="
IF "%SELECT%"=="S" IF "%SAFE_EXCLUDE%"=="ENABLED" SET "SAFE_EXCLUDE=DISABLED"&&SET "SELECT="
IF "%SELECT%"=="M" IF NOT EXIST "V:\" SET "PICK=VHDX"&&CALL:FILE_PICK&&CALL:VHDX_MOUNT&&SET "SELECT="
IF "%SELECT%"=="M" IF EXIST "V:\" CALL:VDISK_BRUTE&&SET "SELECT="
GOTO:IMAGE_MANAGER
:IMAGEMGR_CHOICE
CLS&&IF EXIST "%LIST_FOLDER%\*.LST" IF NOT EXIST "%PACK_FOLDER%\*.PKX" SET "IMAGEMGR_CHOICE=1"&&GOTO:IMAGEMGR_CHOICE_SKIP
IF EXIST "%PACK_FOLDER%\*.PKX" IF NOT EXIST "%LIST_FOLDER%\*.LST" SET "IMAGEMGR_CHOICE=2"&&GOTO:IMAGEMGR_CHOICE_SKIP
CALL:PAD_LINE&&ECHO                              Run which type&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%1%#$%) Exec-List    %#@%LST%#$%&&ECHO  (%##%2%#$%) AIO Package  %#@%PKX%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&SET "PROMPT_SET=IMAGEMGR_CHOICE"&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:PROMPT_SET
IF NOT "%IMAGEMGR_CHOICE%"=="1" IF NOT "%IMAGEMGR_CHOICE%"=="2" EXIT /B
:IMAGEMGR_CHOICE_SKIP
IF "%IMAGEMGR_CHOICE%"=="1" SET "PICK=LST"&&CALL:FILE_PICK
IF "%IMAGEMGR_CHOICE%"=="2" SET "PICK=PKX"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
IF "%IMAGEMGR_CHOICE%"=="1" SET "$LST1=%$PICK%"
IF "%IMAGEMGR_CHOICE%"=="2" SET "PKX_PACK=%$PICK%"
SET "MENU_INSERTA= ( %##%@%#$% ) %##%Current-Environment%#$%"&&SET "PICK=VHDX"&&CALL:FILE_PICK
IF "%LIVE_APPLY%"=="1" IF NOT DEFINED DISCLAIMER CALL:DISCLAIMER&EXIT /B
IF NOT "%LIVE_APPLY%"=="1" IF NOT DEFINED $PICK EXIT /B
SET "VDISK=%$PICK%"
IF "%IMAGEMGR_CHOICE%"=="1" CALL:IMAGEMGR_RUN_LIST
IF "%IMAGEMGR_CHOICE%"=="2" CALL:AIO_PARSE
EXIT /B
:AIO_PARSE
SET "SCRATCH_AIO=%PROG_SOURCE%\ScratchAIO"&&CALL:AIO_DELETE&&MD "%PROG_SOURCE%\ScratchAIO">NUL 2>&1
FOR %%a in (PackName PackType PackDesc PackTag) DO (CALL SET "%%a=")
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%PKX_PACK%" /INDEX:2 /APPLYDIR:"%SCRATCH_AIO%" >NUL 2>&1
COPY /Y "%SCRATCH_AIO%\PACKAGE.MAN" "$PAK">NUL&&FOR /F "eol=- TOKENS=1-2 DELIMS==" %%a in ($PAK) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
IF NOT "%PackType%"=="AIOPACK" ECHO Error&&CALL:AIO_DELETE&&EXIT /B
SET "$LST1=%PROG_SOURCE%\ScratchAIO\PACKAGE.LST"&&CALL:PAD_LINE&&ECHO Extracting %#@%%PKX_PACK%%#$%..
SET "LIST_FOLDERX=%LIST_FOLDER%"&&SET "PACK_FOLDERX=%PACK_FOLDER%"&&DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%PKX_PACK%" /INDEX:1 /APPLYDIR:"%SCRATCH_AIO%">NUL 2>&1
SET "LIST_FOLDER=%SCRATCH_AIO%"&&SET "PACK_FOLDER=%SCRATCH_AIO%"&&CALL:IMAGEMGR_RUN_LIST
SET "LIST_FOLDER=%LIST_FOLDERX%"&&SET "PACK_FOLDER=%PACK_FOLDERX%"
SET "LIST_FOLDERX="&&SET "PACK_FOLDERX="
EXIT /B
:LIST_EDIT
IF NOT DEFINED $PICK EXIT /B
START NOTEPAD "%$PICK%"
EXIT /B
:ISO_MOUNT
IF NOT DEFINED $PICK EXIT /B
"%$PICK%"
EXIT /B
:ISO_UNMOUNT
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                    Remove which ISO Drive Letter?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=ISO_LETTER"&&CALL:PROMPT_SET
IF NOT DEFINED ISO_LETTER EXIT /B
(ECHO.select VOLUME %ISO_LETTER%&&ECHO.Remove letter=%ISO_LETTER% noerr&&ECHO.Exit)>"$DSK"&&CALL:PAD_LINE&&DISKPART /s "$DSK"&&ECHO Drive letter %ISO_LETTER% removed&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:VHDX_MOUNT
IF NOT DEFINED $PICK EXIT /B
SET "VDISK=%$PICK%"&&CALL:PAD_LINE&&ECHO  Attaching %$PICK%&&CALL:PAD_LINE&&CALL:VDISK_ATTACH
IF NOT EXIST "V:\" ECHO  Error mounting %$PICK%&&CALL:PAD_LINE&&CALL:VDISK_DETACH
EXIT /B
:VDISK_CREATE
IF NOT DEFINED VDISK EXIT /B
CALL:VDISK_DETACH>NUL 2>&1
IF NOT DEFINED VHDX_MB SET "VHDX_MB=25600"
IF EXIST "%VDISK%" DEL /Q /F "%VDISK%">NUL 2>&1
(ECHO.create vdisk file="%VDISK%" maximum=%VHDX_MB% type=expandable&&ECHO.Select vdisk file="%VDISK%"&&ECHO.Attach vdisk&&ECHO.create partition primary&&ECHO.select partition 1&&ECHO.format fs=ntfs quick&&ECHO.Assign letter=V noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "VHDX_MB="&&DEL /F "$DSK">NUL 2>&1
EXIT /B
:VDISK_ATTACH
SET "VDISK_SYS="&&CALL:VDISK_DETACH>NUL 2>&1
(ECHO.Select vdisk file="%VDISK%"&&ECHO.Attach vdisk&&ECHO.select partition 1&&ECHO.Assign letter=V noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
IF EXIST "V:\WINDOWS" SET "VDISK_SYS=1"
DEL /F "$DSK">NUL 2>&1
EXIT /B
:VDISK_DETACH
(ECHO.Select vdisk file="%VDISK%"&&ECHO.Detach vdisk&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
IF EXIST "V:\" CALL:VDISK_BRUTE
DEL /F "$DSK">NUL 2>&1
EXIT /B
:VDISK_BRUTE
(ECHO.List Volume&&ECHO.Exit)>"$DSK1"&&DISKPART /s "$DSK1">"$DSK2"
SET "DISK_TMP="&&FOR /F "TOKENS=1-9 DELIMS= " %%a IN ($DSK2) DO (IF "%%c"=="V" CALL SET "DISK_TMP=%%b")
(ECHO.Select Volume %DISK_TMP%&&ECHO.Detail Volume&&ECHO.Exit)>"$DSK1"&&DISKPART /s "$DSK1">"$DSK2"
SET "DISK_TMP="&&FOR /F "TOKENS=1-9 DELIMS= " %%a IN ($DSK2) DO (
IF "%%a"=="Disk" IF NOT "%%b"=="###" SET "DISK_TMP=%%b"
IF "%%a"=="*" IF "%%b"=="Disk" SET "DISK_TMP=%%c")
(ECHO.List Vdisk&&ECHO.Exit)>"$DSK1"&&DISKPART /s "$DSK1">"$DSK2"
SET "VDISK_TMP="&&FOR /F "TOKENS=1-9* DELIMS= " %%a IN ($DSK2) DO (IF "%%a"=="VDisk" IF "%%d"=="%DISK_TMP%" IF EXIST "%%i" SET "VDISK_TMP=%%i")
CALL:PAD_LINE&&CALL ECHO  Detaching %VDISK_TMP%&&CALL:PAD_LINE
(ECHO.Select vdisk file="%VDISK_TMP%"&&ECHO.Detach vdisk&&ECHO.Exit)>"$DSK1"&&DISKPART /s "$DSK1" >NUL 2>&1
DEL /F "$DSK*">NUL 2>&1
EXIT /B
:VDISK_COMPACT
(ECHO.Select vdisk file="%$PICK%"&&ECHO.Attach vdisk readonly&&ECHO.compact vdisk&&ECHO.detach vdisk&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK"&&DEL "$DSK">NUL 2>&1
EXIT /B
::#########################################################################
:IMAGEMGR_LIST_MAIN
::#########################################################################
SET "ERROR="&&SET "LIST_X="&&SET "LIST_ACTN="&&SET "LIST_ITEM="&&SET "NLIST="&&SET "$HEAD="&&SET "EXXT="
CLS&&CALL:CLEAN&&CALL:PAD_LINE&&ECHO                              List Creator&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX
ECHO.&&ECHO  ( %##%U%#$% ) Unattended Install&&ECHO  ( %##%P%#$% ) External Package&&ECHO  ( %##%M%#$% ) Miscellaneous&&ECHO.&&ECHO  ( %##%*%#$% ) Create Source Base List&&ECHO  ( %##%-%#$% ) Difference Base List&&ECHO  ( %##%+%#$% ) Combine Exec List&&ECHO  ( %##%.%#$% ) Create Group Base List&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE
IF EXIST "%LIST_FOLDER%\*.MST" SET "BOX=T1"&&CALL:BOX&&ECHO   %#@%AVAILABLE BASE LISTS:%#$%&&SET "NLIST=MST"&&CALL:FILE_LIST&&SET "BOX=B1"&&CALL:BOX&&CALL:PAD_LINE
IF NOT EXIST "%LIST_FOLDER%\*.MST" SET "BOX=T1"&&CALL:BOX&&ECHO   %#@%NO BASE LISTS EXIST:%#$% Create from vhdx or current environment ( %##%*%#$% ) &&SET "BOX=B1"&&CALL:BOX&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$ELECT$="&&CALL:MENU_SELECT
IF "%SELECT%"=="U" SET "LIST_X=1"&&CALL:LIST_UNATTEND_CREATE
IF "%SELECT%"=="." SET "LIST_X=1"&&CALL:LIST_GROUP_CONVERT
IF "%SELECT%"=="P" SET "LIST_X=1"&&CALL:IMAGEMGR_LIST_PACK
IF "%SELECT%"=="*" SET "LIST_X=1"&&CALL:LIST_BASE_CREATE
IF "%SELECT%"=="+" SET "LIST_X=1"&&CALL:LIST_COMBINATOR
IF "%SELECT%"=="-" SET "LIST_X=1"&&CALL:LIST_DIFFERENCER
IF "%SELECT%"=="M" SET "LIST_X=1"&&CALL:LIST_MISCELLANEOUS
IF DEFINED LIST_X EXIT /B
IF NOT DEFINED $ELECT$ EXIT /B
IF "%SELECT%" GEQ "99" EXIT /B
IF NOT "%SELECT%" GEQ "1" EXIT /B
SET /P $HEAD=<"%LIST_FOLDER%\%$ELECT$%"
IF NOT "%$HEAD%"=="BASE-LIST" IF NOT "%$HEAD%"=="BASE-GROUP" CALL:PAD_LINE&&ECHO                       Bad file-header, check file&&CALL:PAD_LINE&&CALL:PAUSED
IF "%$HEAD%"=="BASE-LIST" CALL:LIST_BASE_VIEW
IF "%$HEAD%"=="BASE-GROUP" CALL:LIST_GROUP_VIEW
EXIT /B
:LIST_BASE_VIEW
CLS&&SET "LIST_ACTN="&&SET "LIST_ITEM="&&SET "LIST_TIME="&&CALL:PAD_LINE&&ECHO                            Select an option&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%1%#$%) AppX&&ECHO  (%##%2%#$%) Component&&ECHO  (%##%3%#$%) Feature&&ECHO  (%##%4%#$%) Service&&ECHO  (%##%5%#$%) Task&&ECHO  (%##%6%#$%) Driver&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTX"&&CALL:PROMPT_SET
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" IF NOT "%SELECTX%"=="3" IF NOT "%SELECTX%"=="4" IF NOT "%SELECTX%"=="5" IF NOT "%SELECTX%"=="6" EXIT /B
CLS&&CALL:PAD_LINE&&ECHO                             Type of Action?&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.
IF "%SELECTX%"=="1" SET "LIST_ITEM=APPX"&&ECHO  (%##%1%#$%) Delete&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTY"&&CALL:PROMPT_SET
IF "%SELECTX%"=="2" SET "LIST_ITEM=COMPONENT"&&ECHO  (%##%1%#$%) Delete&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTY"&&CALL:PROMPT_SET
IF "%SELECTX%"=="3" SET "LIST_ITEM=FEATURE"&&ECHO  (%##%1%#$%) Disable&&ECHO  (%##%2%#$%) Enable&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTY"&&CALL:PROMPT_SET
IF "%SELECTX%"=="4" SET "LIST_ITEM=SERVICE"&&ECHO  (%##%1%#$%) Delete&&ECHO  (%##%2%#$%) Automatic&&ECHO  (%##%3%#$%) Manual&&ECHO  (%##%4%#$%) Disable&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTY"&&CALL:PROMPT_SET
IF "%SELECTX%"=="5" SET "LIST_ITEM=TASK"&&ECHO  (%##%1%#$%) Delete&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTY"&&CALL:PROMPT_SET
IF "%SELECTX%"=="6" SET "LIST_ITEM=DRIVER"&&ECHO  (%##%1%#$%) Delete&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTY"&&CALL:PROMPT_SET
IF "%LIST_ITEM%"=="APPX" IF "%SELECTY%"=="1" SET "LIST_ACTN=DELETE"
IF "%LIST_ITEM%"=="COMPONENT" IF "%SELECTY%"=="1" SET "LIST_ACTN=DELETE"
IF "%LIST_ITEM%"=="FEATURE" IF "%SELECTY%"=="1" SET "LIST_ACTN=DISABLE"
IF "%LIST_ITEM%"=="FEATURE" IF "%SELECTY%"=="2" SET "LIST_ACTN=ENABLE"
IF "%LIST_ITEM%"=="SERVICE" IF "%SELECTY%"=="1" SET "LIST_ACTN=DELETE"
IF "%LIST_ITEM%"=="SERVICE" IF "%SELECTY%"=="2" SET "LIST_ACTN=AUTO"
IF "%LIST_ITEM%"=="SERVICE" IF "%SELECTY%"=="3" SET "LIST_ACTN=MANUAL"
IF "%LIST_ITEM%"=="SERVICE" IF "%SELECTY%"=="4" SET "LIST_ACTN=DISABLE"
IF "%LIST_ITEM%"=="TASK" IF "%SELECTY%"=="1" SET "LIST_ACTN=DELETE"
IF "%LIST_ITEM%"=="DRIVER" IF "%SELECTY%"=="1" SET "LIST_ACTN=DELETE"
IF NOT DEFINED LIST_ACTN EXIT /B
CLS&&CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX&&ECHO   %#@%GETTING %LIST_ITEM% LISTING%#$%...&&SET "$LIST=%LIST_FOLDER%\%$ELECT$%"&&SET "ONLY1=%LIST_ITEM%"&&SET "NLIST=MST"&&CALL:LIST_FILE&&SET "BOX=B1"&&CALL:BOX
IF DEFINED ERROR EXIT /B
CALL:PAD_MULT&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
CALL:LIST_TIME
IF NOT DEFINED LIST_TIME EXIT /B
CALL:LIST_WRITE&&SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&SET "$LST1=%$PICK%"&&CALL:LIST_COMBINE
CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_GROUP_VIEW
CLS&&SET "LIST_ACTN="&&SET "LIST_TIME="&&SET "LIST_ITEM=GROUP"&&CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX&&ECHO   %#@%GETTING GROUP LISTING%#$%...&&SET "$LIST=%LIST_FOLDER%\%$ELECT$%"&&SET "$LISTX=%LIST_FOLDER%\%$ELECT$%"&&SET "ONLY1=GROUP"&&SET "NLIST=MST"&&CALL:LIST_FILE&&SET "BOX=B1"&&CALL:BOX
IF DEFINED ERROR EXIT /B
CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
CALL SET "ITEM_SELECT=%%$ITEM%SELECT%%%"
FOR /F "TOKENS=1-9 DELIMS=[]" %%1 IN ("%ITEM_SELECT%") DO (SET "GROUP_TARGET=%%2")
CLS&&SET "LIST_ACTN="&&SET "LIST_TIME="&&SET "LIST_ITEM=GROUP"&&CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX&&ECHO   %#@%GETTING SUBGROUP LISTING%#$%...&&SET "$LIST=%$LISTX%"&&SET "ONLY1=GROUP"&&SET "ONLY2=%GROUP_TARGET%"&&SET "NLIST=MST"&&CALL:LIST_FILE&&SET "BOX=B1"&&CALL:BOX
IF DEFINED ERROR EXIT /B
CALL:PAD_MULT&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
COPY /Y "%$LISTX%" "$HZ">NUL
FOR %%a in (%$ELECT%) DO (IF NOT "%%a"=="" CALL SET "FULL_TARGET=%%$ITEM%%a%%"&&CALL:GROUP_POPULATE)
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&SET "$LST1=%$PICK%"&&CALL:LIST_COMBINE
CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:GROUP_POPULATE
SET "SUB_TARGET="&&FOR /F "TOKENS=1-9 DELIMS=[]" %%1 in ("%FULL_TARGET%") DO (SET "SUB_TARGET=%%3")
CALL:PIPE_CLEAR&&CALL:MOUNT_CLEAR
SET "WRITEX="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=[]" %%1 in ($HZ) DO (
IF "%%1"=="GROUP" IF "%%2"=="%GROUP_TARGET%" IF "%%3"=="%SUB_TARGET%" SET "WRITEX=1"
IF "%%1"=="GROUP" IF "%%2"=="%GROUP_TARGET%" IF NOT "%%3"=="%SUB_TARGET%" SET "WRITEX="
IF "%%1"=="GROUP" IF NOT "%%2"=="%GROUP_TARGET%" IF NOT "%%3"=="%SUB_TARGET%" SET "WRITEX="
IF NOT "%%1"=="" CALL SET "$CLM1=%%1"&&CALL SET "$CLM2=%%2"&&CALL SET "$CLM3=%%3"&&CALL SET "$CLM4=%%4"&&CALL:GROUP_WRITE)
CALL:MOUNT_REST
EXIT /B
:MOUNT_CLEAR
SET "DRVTAR_X=%DRVTAR%"&&SET "HIVE_SOFTWARE_X=%HIVE_SOFTWARE%"&&SET "HIVE_SYSTEM_X=%HIVE_SYSTEM%"&&SET "HIVE_USER_X=%HIVE_USER%"&&SET "DRVTAR=%%DRVTAR%%"&&SET "HIVE_SOFTWARE=%%HIVE_SOFTWARE%%"&&SET "HIVE_SYSTEM=%%HIVE_SYSTEM%%"&&SET "HIVE_USER=%%HIVE_USER%%"
EXIT /B
:MOUNT_REST
SET "DRVTAR=%DRVTAR_X%"&&SET "HIVE_SOFTWARE=%HIVE_SOFTWARE_X%"&&SET "HIVE_SYSTEM=%HIVE_SYSTEM_X%"&&SET "HIVE_USER=%HIVE_USER_X%"&&SET "DRVTAR_X="&&SET "HIVE_SOFTWARE_X="&&SET "HIVE_SYSTEM_X="&&SET "HIVE_USER_X="
EXIT /B
:GROUP_WRITE
IF NOT DEFINED WRITEX EXIT /B
=FOR %%A in (0 1 2 3 4 5 6 7 8 9) DO (IF "%$CLM1%"=="$%%A" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO.%$CLM2%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&SET "PROMPT_ANY=1"&&SET "PROMPT_SET=$CLM3"&&CALL:PROMPT_SET)
=FOR %%A in (0 1 2 3 4 5 6 7 8 9) DO (IF "%$CLM1%"=="$%%A" ECHO [%$CLM1%][%$CLM2%][%$CLM3%]>>"$LST2")
IF "%$CLM1%"=="#" ECHO [%$CLM1%][%$CLM2%][%$CLM3%]>>"$LST2"
IF "%$CLM1%"=="GROUP" ECHO [%$CLM1%][%$CLM2%][%$CLM3%]>>"$LST2"
IF NOT "%$CLM1%"=="GROUP" IF NOT "%$CLM1%"=="#" IF NOT "%$CLM1%"=="$0" IF NOT "%$CLM1%"=="$1" IF NOT "%$CLM1%"=="$2" IF NOT "%$CLM1%"=="$3" IF NOT "%$CLM1%"=="$4" IF NOT "%$CLM1%"=="$5" IF NOT "%$CLM1%"=="$6" IF NOT "%$CLM1%"=="$7" IF NOT "%$CLM1%"=="$8" IF NOT "%$CLM1%"=="$9" ECHO [%$CLM1%][%$CLM2%][%$CLM3%][%$CLM4%]>>"$LST2"
EXIT /B
:LIST_MISCELLANEOUS
CLS&&CALL:PAD_LINE&&ECHO                              List Creator&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX
ECHO.&&ECHO  ( %##%1%#$% ) Registry Operation&&ECHO  ( %##%2%#$% ) File Operation&&ECHO  ( %##%3%#$% ) Command Operation&&ECHO  ( %##%4%#$% ) DISM Operation&&ECHO  ( %##%5%#$% ) Group Seperator&&ECHO  ( %##%6%#$% ) Comment Entry&&ECHO  ( %##%7%#$% ) Prompt Entry&&ECHO  ( %##%8%#$% ) Wallpaper Import&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$ELECT$="&&CALL:MENU_SELECT
IF "%SELECT%"=="1" SET "LIST_X=1"&&CALL:LIST_REGISTRY_CREATE
IF "%SELECT%"=="2" SET "LIST_X=1"&&CALL:LIST_FILE_CREATE
IF "%SELECT%"=="3" SET "LIST_X=1"&&CALL:LIST_COMMAND_CREATE
IF "%SELECT%"=="4" SET "LIST_X=1"&&CALL:LIST_DISM_CREATE
IF "%SELECT%"=="5" SET "LIST_X=1"&&CALL:LIST_GROUP_BOUNDRY
IF "%SELECT%"=="6" SET "LIST_X=1"&&CALL:LIST_COMMENT_CREATE
IF "%SELECT%"=="7" SET "LIST_X=1"&&CALL:LIST_PROMPT_CREATE
IF "%SELECT%"=="8" SET "LIST_X=1"&&CALL:LIST_WALLPAPER_CREATE
EXIT /B
:LIST_WALLPAPER_CREATE
IF NOT EXIST "%CACHE_FOLDER%\wallpaper.jpg" CALL:T9X
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&ECHO.&&ECHO  %#@%WALLPAPER%#$% wallpaper.jpg %#@%EXECUTE%#$% %##%IMAGE-APPLY%#$% &&ECHO [WALLPAPER][wallpaper.jpg][EXECUTE][IMAGE-APPLY]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_COMMAND_CREATE
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                             %#@%Enter Command:%#$%&&ECHO       %XLR2%Important:%#$% Do not use any of these symbols [%XLR2% ^< ^> [ ] ^& ^^ %#$%].&&ECHO  These can cause the program to crash when ever the list is accessed.&&ECHO      If complex commands are required, create a scripted package.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=COMMANDX"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED COMMANDX EXIT /B
CALL:LIST_TIME
IF NOT DEFINED LIST_TIME EXIT /B
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&ECHO.&&ECHO  %#@%COMMAND%#$% %COMMANDX% %#@%EXECUTE%#$% %##%%LIST_TIME%%#$% &&ECHO [COMMAND][%COMMANDX%][EXECUTE][%LIST_TIME%]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_UNATTEND_CREATE
IF NOT EXIST "%CACHE_FOLDER%\unattend.xml" CALL:T8X
IF NOT EXIST "%CACHE_FOLDER%\unattend.xml" EXIT /B
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&ECHO.&&ECHO  %#@%UNATTEND%#$% unattend.xml %#@%EXECUTE%#$% %##%IMAGE-APPLY%#$% &&ECHO [UNATTEND][unattend.xml][EXECUTE][IMAGE-APPLY]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_GROUP_BOUNDRY
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                          Enter new group name&&ECHO          Note: %#@%Place this entry at the start of the group%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=GRP_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED GRP_NAME EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                          Enter subgroup name&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=GRP_SUB"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED GRP_SUB EXIT /B
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&ECHO.&&ECHO  %#@%GROUP%#$% %GRP_NAME% %GRP_SUB%&&ECHO [GROUP][%GRP_NAME%][%GRP_SUB%]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_GROUP_CONVERT
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
COPY /Y "%$PICK%" "$LST">NUL
SET "ISGROUP="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=[]" %%1 in ($LST) DO (IF "%%1"=="GROUP" SET "ISGROUP=1")
IF NOT DEFINED ISGROUP CALL:PAD_LINE&&ECHO  List does not contain any groups. Aborted.&&CALL:PAD_LINE&&CALL:PAUSED&EXIT /B
SET "$LST2=%$PICK%"&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                    Enter name of new group base list&&ECHO.&&ECHO  Note: This converts an execution list (.lst) into a base list (.mst)&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEW_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED NEW_NAME EXIT /B
SET "$LST1=%LIST_FOLDER%\%NEW_NAME%.mst"
CALL:PAD_ADD&&SET "GROUPX=1"&&CALL:LIST_COMBINE&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:LIST_COMMENT_CREATE
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO            Enter the message for the comment: [ %#@%A-Z 0-9%#$% ]&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_ANY=1"&&SET "PROMPT_SET=PROMPT_XYZ"&&CALL:PROMPT_SET
IF NOT DEFINED PROMPT_XYZ EXIT /B
CALL:PAD_LINE&&ECHO           Choose a color: [ %XLR0%0%XLR1%1%XLR2%2%XLR3%3%XLR4%4%XLR5%5%XLR6%6%XLR7%7%XLR8%8%XLR9%9%#$% ]&&SET "PROMPT_SET=COLOR_XYZ"&&CALL:PROMPT_SET
IF NOT DEFINED COLOR_XYZ EXIT /B
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&ECHO.&&CALL ECHO %#@%#%#$% %PROMPT_XYZ% %%XLR%COLOR_XYZ%%%COLOR %COLOR_XYZ% %#$%&&ECHO [#][%PROMPT_XYZ%][%COLOR_XYZ%]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_PROMPT_CREATE
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO             Enter the message for the prompt: [ %#@%A-Z 0-9%#$% ]&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_ANY=1"&&SET "PROMPT_SET=PROMPT_XYZ"&&CALL:PROMPT_SET
IF NOT DEFINED PROMPT_XYZ EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                     Select a pipe number: [ %#@%0-9%#$% ]&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_ANY=1"&&SET "PROMPT_SET=PIPE_XYZ"&&CALL:PROMPT_SET
IF NOT DEFINED PIPE_XYZ EXIT /B
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
SET "PASS="&&FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (IF "%PIPE_XYZ%"=="%%a" SET "PASS=1")
CALL:PAD_ADD&&ECHO.&&IF NOT "%PASS%"=="1" ECHO %XLR2%ERROR:%#$% Input not [ %#@%0-9%#$% ].
IF "%PASS%"=="1" ECHO %#@%$%PIPE_XYZ%%#$% %PROMPT_XYZ% PIPE%PIPE_XYZ%&&ECHO [$%PIPE_XYZ%][%PROMPT_XYZ%][PIPE%PIPE_XYZ%]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_FILE_CREATE
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO              Enter the folder path + file name to delete&&ECHO          %XLR2%Drive letter:\ omitted. Cannot contain quotes (^",^')%#$%&&ECHO                       Example: %#@%Windows\example.bmp%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_ANY=1"&&SET "PROMPT_SET=FOLDFILE"&&CALL:PROMPT_SET
IF NOT DEFINED FOLDFILE EXIT /B
CALL:LIST_TIME
IF NOT DEFINED LIST_TIME EXIT /B
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&ECHO.&&SET "FILE_TGT=%%DRVTAR%%"
ECHO %#@%FILEOPER%#$% %#@%DELETE%#$% "%FILE_TGT%\%FOLDFILE%" %##%%LIST_TIME%%#$%&&ECHO [FILEOPER]["%FILE_TGT%\%FOLDFILE%"][DELETE][%LIST_TIME%]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_TIME
SET "LIST_TIME="&&CLS&&CALL:PAD_LINE&&ECHO                             Time of Action?&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%I%#$%)mage-Apply&&ECHO  (%##%S%#$%)etupComplete&&ECHO  (%##%R%#$%)unOnce&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTX"&&CALL:PROMPT_SET
IF "%SELECTX%"=="I" SET "LIST_TIME=IMAGE-APPLY"
IF "%SELECTX%"=="S" SET "LIST_TIME=SETUP-COMPLETE"
IF "%SELECTX%"=="R" SET "LIST_TIME=RUN-ONCE"
EXIT /B
:LIST_REGISTRY_CREATE
SET "REG_OPER="&&SET "REG_HIVE="&&SET "REG_KEY="&&SET "REG_VAL="&&SET "REG_DATA="&&SET "REG_TYPE="&&CLS&&CALL:CLEAN&&CALL:PAD_LINE&&ECHO                          Select operation type&&CALL:PAD_LINE
SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  ( %##%1%#$% ) Registry Add&&ECHO  ( %##%2%#$% ) Registry Delete&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTX"&&CALL:PROMPT_SET
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" EXIT /B
IF "%SELECTX%"=="1" SET "REG_OPER=ADD"
IF "%SELECTX%"=="2" SET "REG_OPER=DELETE"
CLS&&CALL:PAD_LINE&&ECHO                          Select registry hive&&CALL:PAD_LINE
SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  ( %##%1%#$% ) HKLM\Software&&ECHO  ( %##%2%#$% ) HKLM\System&&ECHO  ( %##%3%#$% ) HKCU or DefaultUser&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTX"&&CALL:PROMPT_SET
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" IF NOT "%SELECTX%"=="3" EXIT /B
IF "%SELECTX%"=="1" SET "REG_HIVE=%%HIVE_SOFTWARE%%"
IF "%SELECTX%"=="2" SET "REG_HIVE=%%HIVE_SYSTEM%%"
IF "%SELECTX%"=="3" SET "REG_HIVE=%%HIVE_USER%%"
CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX&&ECHO.&&ECHO                          Enter the registry key&&ECHO %XLR2%HKCU/HKLM/USER,Software/System are omitted. Cannot contain quotes (^",^')%#$%&&ECHO.
ECHO                          Example: %#@%key\name%#$%
ECHO.&&SET "BOX=B1"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=REG_KEY"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED REG_KEY EXIT /B
CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX&&ECHO.&&ECHO              Enter the value name or press (%##%-%#$%) for key only&&ECHO                        %XLR2%Cannot contain quotes (^",^')%#$%&&ECHO.
ECHO                          Example: %#@%value name%#$%
ECHO.&&SET "BOX=B1"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=REG_VAL"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED REG_VAL EXIT /B
IF "%REG_VAL%"=="-" GOTO:REG_SKIP
IF "%REG_OPER%"=="DELETE" GOTO:REG_SKIP
CLS&&CALL:PAD_LINE&&ECHO                          Select value type&&CALL:PAD_LINE
SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  ( %##%1%#$% ) REG_SZ&&ECHO  ( %##%2%#$% ) REG_DWORD&&ECHO  ( %##%3%#$% ) REG_BINARY&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTX"&&CALL:PROMPT_SET
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" IF NOT "%SELECTX%"=="3" EXIT /B
IF "%SELECTX%"=="1" SET "REG_TYPE=REG_SZ"
IF "%SELECTX%"=="2" SET "REG_TYPE=REG_DWORD"
IF "%SELECTX%"=="3" SET "REG_TYPE=REG_BINARY"
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" IF NOT "%SELECTX%"=="3" EXIT /B
CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX&&ECHO.&&ECHO                          Enter the value data&&ECHO                       %XLR2%Cannot contain quotes (^",^')%#$%&&ECHO.
ECHO                          Example: %#@%0%#$%
ECHO.&&SET "BOX=B1"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=REG_DATA"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED REG_DATA EXIT /B
:REG_SKIP
CALL:LIST_TIME
IF NOT DEFINED LIST_TIME EXIT /B
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&ECHO.
IF "%REG_OPER%"=="ADD" IF "%REG_VAL%"=="-" ECHO %#@%REGISTRY%#$% %#@%%REG_OPER%%#$% "%REG_HIVE%\%REG_KEY%" /f %##%%LIST_TIME%%#$%&&ECHO [REGISTRY]["%REG_HIVE%\%REG_KEY%" /f][%REG_OPER%][%LIST_TIME%]>>"%$PICK%"
IF "%REG_OPER%"=="ADD" IF NOT "%REG_VAL%"=="-" ECHO %#@%REGISTRY%#$% %#@%%REG_OPER%%#$% "%REG_HIVE%\%REG_KEY%" /v "%REG_VAL%" /t %REG_TYPE% /d "%REG_DATA%" /f %##%%LIST_TIME%%#$%&&ECHO [REGISTRY]["%REG_HIVE%\%REG_KEY%" /v "%REG_VAL%" /t %REG_TYPE% /d "%REG_DATA%" /f][%REG_OPER%][%LIST_TIME%]>>"%$PICK%"
IF "%REG_OPER%"=="DELETE" IF "%REG_VAL%"=="-" ECHO %#@%REGISTRY%#$% %#@%%REG_OPER%%#$% "%REG_HIVE%\%REG_KEY%" /f %##%%LIST_TIME%%#$%&&ECHO [REGISTRY]["%REG_HIVE%\%REG_KEY%" /f][%REG_OPER%][%LIST_TIME%]>>"%$PICK%"
IF "%REG_OPER%"=="DELETE" IF NOT "%REG_VAL%"=="-" ECHO %#@%REGISTRY%#$% %#@%%REG_OPER%%#$% "%REG_HIVE%\%REG_KEY%" /v "%REG_VAL%" /f %##%%LIST_TIME%%#$%&&ECHO [REGISTRY]["%REG_HIVE%\%REG_KEY%" /v "%REG_VAL%" /f][%REG_OPER%][%LIST_TIME%]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:IMAGEMGR_LIST_PACK
SET "LIST_ITEM=EXTPACKAGE"&&SET "LIST_ACTN=INSTALL"&&CLS&&CALL:CLEAN&&CALL:PAD_LINE&&ECHO                           Select package type&&CALL:PAD_LINE
SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  ( %##%1%#$% ) %#@%PKG%#$% Package&&ECHO  ( %##%2%#$% ) %#@%CAB%#$% Package&&ECHO  ( %##%3%#$% ) %#@%MSU%#$% Package&&ECHO  ( %##%4%#$% ) %#@%APPX%#$% Package&&ECHO  ( %##%5%#$% ) %#@%APPXBUNDLE%#$% Package&&ECHO  ( %##%6%#$% ) %#@%MSIXBUNDLE%#$% Package&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=SELECTX"&&CALL:PROMPT_SET
IF "%SELECTX%"=="1" SET "EXXT=PKG"&&CALL:LIST_PACK_CREATE
IF "%SELECTX%"=="2" SET "EXXT=CAB"&&CALL:LIST_PACK_CREATE
IF "%SELECTX%"=="3" SET "EXXT=MSU"&&CALL:LIST_PACK_CREATE
IF "%SELECTX%"=="4" SET "EXXT=APPX"&&CALL:LIST_PACK_CREATE
IF "%SELECTX%"=="5" SET "EXXT=APPXBUNDLE"&&CALL:LIST_PACK_CREATE
IF "%SELECTX%"=="6" SET "EXXT=MSIXBUNDLE"&&CALL:LIST_PACK_CREATE
EXIT /B
:LIST_PACK_CREATE
CLS&&CALL:PAD_LINE&&SET "BOX=T1"&&CALL:BOX&&ECHO   %#@%AVAILABLE %EXXT%'S:%#$%&&SET "NLIST=%EXXT%"&&CALL:FILE_LIST&&SET "BOX=B1"&&CALL:BOX
CALL:PAD_MULT&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
CALL:LIST_TIME
IF NOT DEFINED LIST_TIME EXIT /B
CALL:LIST_WRITE&&SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&SET "$LST1=%$PICK%"&&CALL:LIST_COMBINE
CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_DISM_CREATE
CLS&&SET "DISM_OPER="&&SET "LIST_ITEM=DISM"&&SET "LIST_ACTN=EXECUTE"&&CALL:PAD_LINE
ECHO                        DISM Image Maintainence&&CALL:PAD_LINE&&CALL:DISM_CHOICE
IF NOT DEFINED DISM_OPER EXIT /B
CALL:LIST_TIME
IF NOT DEFINED LIST_TIME EXIT /B
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_ADD&&ECHO.&&ECHO  %#@%DISM%#$% %DISM_OPER% %#@%EXECUTE%#$% %##%%LIST_TIME%%#$% &&ECHO [DISM][%DISM_OPER%][EXECUTE][%LIST_TIME%]>>"%$PICK%"
ECHO.&&CALL:PAD_END&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:LIST_COMBINATOR
SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
SET "$LST1=%$PICK%"&&SET "PICK=LST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
SET "$LST2=%$PICK%"&&CALL:PAD_SAME
IF "%$LST1%"=="%$LST2%" EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                            Name of new list?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEW_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED NEW_NAME EXIT /B
COPY /Y "%$LST1%" "$HZ">NUL
CALL:PAD_ADD&&ECHO.&&ECHO  LIST 1&&ECHO.&&FOR /F "TOKENS=1-9 DELIMS=[]" %%a in ($HZ) DO (IF NOT "%%a"=="" IF NOT "%%a"=="BASE-LIST" IF NOT "%%a"=="EXEC-LIST" IF NOT "%%a"=="VERSION" CALL ECHO   %#@%%%a%#$% %%b %#@%%%c%#$% %##%%%d%#$%)
ECHO.&&ECHO  LIST 2&&SET "$LST1=$HZ"&&CALL:LIST_COMBINE
MOVE /Y "$HZ" "%LIST_FOLDER%\%NEW_NAME%.lst">NUL
CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:LIST_DIFFERENCER
SET "PICK=MST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
IF "%$HEAD%"=="BASE-GROUP" CALL:PAD_LINE&&ECHO  Incompatible: Base list is a group base. Aborted.&&CALL:PAD_LINE&&CALL:PAUSED&EXIT /B
SET "$LST1=%$PICK%"&&SET "PICK=MST"&&CALL:FILE_PICK
IF NOT DEFINED $PICK EXIT /B
IF "%$HEAD%"=="BASE-GROUP" CALL:PAD_LINE&&ECHO  Incompatible: Base list is a group base. Aborted.&&CALL:PAD_LINE&&CALL:PAUSED&EXIT /B
SET "$LST2=%$PICK%"&&CALL:PAD_SAME
IF "%$LST1%"=="%$LST2%" EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                            Name of new list?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEW_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED NEW_NAME EXIT /B
CALL:PAD_LINE&&ECHO Differencing [%$LST1%] and [%$LST2%]...&&CALL:PAD_LINE
COPY /Y "%$LST1%" "$LST2">NUL
COPY /Y "%$LST2%" "$LST1">NUL
ECHO EXEC-LIST>"%LIST_FOLDER%\%NEW_NAME%.lst"
FOR /F "TOKENS=1-9 SKIP=1 DELIMS=[]" %%a in ($LST1) DO (SET "$X0$="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=[]" %%1 in ($LST2) DO (IF "[%%1:%%2]"=="[%%a:%%b]" SET "$X0$=1")
IF "%%a"=="APPX" IF NOT DEFINED $X0$ CALL ECHO.[%%a][%%b][DELETE][IMAGE-APPLY]>>"%LIST_FOLDER%\%NEW_NAME%.lst"
IF "%%a"=="COMPONENT" IF NOT DEFINED $X0$ CALL ECHO.[%%a][%%b][DELETE][IMAGE-APPLY]>>"%LIST_FOLDER%\%NEW_NAME%.lst"
IF "%%a"=="FEATURE" IF DEFINED $X0$ CALL ECHO.[%%a][%%b][DISABLE][IMAGE-APPLY]>>"%LIST_FOLDER%\%NEW_NAME%.lst"
IF "%%a"=="FEATURE" IF NOT DEFINED $X0$ CALL ECHO.[%%a][%%b][ABSENT]>>"%LIST_FOLDER%\%NEW_NAME%.lst"
IF "%%a"=="SERVICE" IF DEFINED $X0$ CALL ECHO.[%%a][%%b][%%c][IMAGE-APPLY]>>"%LIST_FOLDER%\%NEW_NAME%.lst"
IF "%%a"=="SERVICE" IF NOT DEFINED $X0$ CALL ECHO.[%%a][%%b][DELETE][IMAGE-APPLY]>>"%LIST_FOLDER%\%NEW_NAME%.lst"
IF "%%a"=="TASK" IF NOT DEFINED $X0$ CALL ECHO.[%%a][%%b][DELETE][IMAGE-APPLY]>>"%LIST_FOLDER%\%NEW_NAME%.lst")
IF EXIST "$LST*" DEL /F $LST*>NUL
CALL:PAUSED
EXIT /B
:LIST_BASE_CREATE
SET "ERR_MSG="&&SET "MENU_INSERTA= ( %##%@%#$% ) %##%Current-Environment%#$%"&&SET "PICK=VHDX"&&CALL:FILE_PICK
IF "%LIVE_APPLY%"=="1" IF NOT DEFINED DISCLAIMER CALL:DISCLAIMER&EXIT /B
IF NOT "%LIVE_APPLY%"=="1" IF NOT DEFINED $PICK EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                       New name of the Base-List?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&SET "PROMPT_SET=NEW_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED NEW_NAME EXIT /B
IF "%LIVE_APPLY%"=="1" GOTO:LIVE_APPLY_BASE_SKIP
IF EXIST "V:\" SET "ERR_MSG=%##%Drive letter V:\ can NOT be in use. Unmount the Vdisk in use.%#$%"&&GOTO:LIST_BASE_CLEANUP
SET "VDISK=%$PICK%"&&CALL:VDISK_ATTACH
IF NOT "%VDISK_SYS%"=="1" SET "ERR_MSG=             %##%Vdisk error or Windows not installed on Vdisk.%#$%"&&CALL:VDISK_DETACH&&GOTO:LIST_BASE_CLEANUP
:LIVE_APPLY_BASE_SKIP
CLS&&CALL:PAD_LINE&&ECHO                            Base List Creation&&CALL:PAD_LINE
IF EXIST "%LIST_FOLDER%\%NEW_NAME%.MST" DEL /F "%LIST_FOLDER%\%NEW_NAME%.MST">NUL
CALL:IF_LIVE_MIX
SET "BASEPRE="&&SET "BASEPRELST="&&ECHO BASE-LIST>"%LIST_FOLDER%\%NEW_NAME%.mst"
DISM /ENGLISH /%APPLY_TARGET% /GET-CURRENTEDITION>"$DISM"
SET "INFO_E="&&SET "INFO_V="&&FOR /F "TOKENS=1-9 DELIMS=: " %%a in ($DISM) DO (IF "%%a %%b"=="Image Version" CALL SET "INFO_V=%%c"
IF "%%a %%b"=="Current Edition" IF NOT "%%c"=="is" CALL SET "INFO_E=%%c")
ECHO Version[%INFO_V%] Edition[%INFO_E%]&&ECHO [%INFO_E%][%INFO_V%]>>"%LIST_FOLDER%\%NEW_NAME%.MST"
CALL:PAD_LINE&&ECHO.&&ECHO  %#@%GETTING APPX LISTING%#$%..&&ECHO.&&IF EXIST "$DISM" DEL /F "$DISM">NUL 2>&1
SET "LIST_ITEM=APPX"&&SET "LIST_ACTN=PRESENT"&&CALL:IF_LIVE_EXT
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications">$REG1 2>&1
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications">$REG2 2>&1
SET "LIST_ACTN=STANDARD"&&FOR /F "TOKENS=9* DELIMS=\" %%a in ($REG1) DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (CALL SET "BASECAP=%%1"&&CALL:BASECAP))
SET "LIST_ACTN=INBOXED"&&FOR /F "TOKENS=9* DELIMS=\" %%a in ($REG2) DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (CALL SET "BASECAP=%%1"&&CALL:BASECAP))
CALL:IF_LIVE_MIX
ECHO.&&CALL:PAD_LINE&&ECHO.&&ECHO  %#@%GETTING FEATURE LISTING%#$%..&&ECHO.&&SET "LIST_ITEM=FEATURE"&&DISM /ENGLISH /%APPLY_TARGET% /GET-FEATURES>"$LST"
SET "LIST_ACTN=PRESENT"&&FOR /F "TOKENS=1-9 DELIMS=: " %%a in ($LST) DO (IF "%%a %%b"=="Feature Name" CALL SET "BASECAP=%%c%%d%%e%%f%%g%%h%%i"&&CALL:BASECAP)
CALL:IF_LIVE_EXT
ECHO.&&CALL:PAD_LINE&&ECHO.&&ECHO  %#@%GETTING SERVICE LISTING%#$%..&&ECHO.&&SET "LIST_ITEM=SERVICE"&&REG QUERY "%HIVE_SYSTEM%\ControlSet001\Services">$LST 2>&1
FOR /F "TOKENS=1-4* DELIMS=\" %%a in ($LST) DO (FOR /F "TOKENS=1-9 DELIMS= " %%1 in ('REG QUERY "%HIVE_SYSTEM%\ControlSet001\Services\%%e"') DO (CALL SET "BASECAP=%%e"
IF "%%1"=="Start" IF "%%3"=="0x2" CALL SET "LIST_ACTN=AUTO"
IF "%%1"=="Start" IF "%%3"=="0x3" CALL SET "LIST_ACTN=MANUAL"
IF "%%1"=="Start" IF "%%3"=="0x4" CALL SET "LIST_ACTN=DISABLED"
IF "%%1"=="Type" IF "%%3"=="0x10" CALL:BASECAP
IF "%%1"=="Type" IF "%%3"=="0x20" CALL:BASECAP
IF "%%1"=="Type" IF "%%3"=="0x60" CALL:BASECAP))
ECHO.&&CALL:PAD_LINE&&ECHO.&&ECHO  %#@%GETTING TASK LISTING%#$%..&&ECHO.&&REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks" /f Path /c /e /s>$LST 2>&1
SET "LIST_ITEM=TASK"&&SET "LIST_ACTN=PRESENT"&&FOR /F "TOKENS=1* DELIMS=\" %%a in ($LST) DO (IF "%%a"=="    Path    REG_SZ    " CALL SET "BASECAP=%%b"&&CALL:BASECAP)
ECHO.&&CALL:PAD_LINE&&ECHO.&&ECHO  %#@%GETTING COMPONENT LISTING%#$%....&&ECHO.&&REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages">$LST 2>&1
SET "LIST_ITEM=COMPONENT"&&SET "LIST_ACTN=PRESENT"&&FOR /F "TOKENS=8* DELIMS=\" %%a in ($LST) DO (FOR /F "TOKENS=1-1* DELIMS=~" %%1 in ("%%a") DO (CALL SET "BASEPRE=%%1"&&CALL SET "BASECAP=%%1"&&CALL:BASECAP))
CALL:IF_LIVE_MIX
ECHO.&&CALL:PAD_LINE&&ECHO.&&ECHO  %#@%GETTING DRIVER LISTING%#$%..&&ECHO.&&DISM /ENGLISH /%APPLY_TARGET% /GET-DRIVERS>"$LST"
SET "LIST_ITEM=DRIVER"&&SET "LIST_ACTN=PRESENT"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=: " %%a in ($LST) DO (
IF "%%a %%b"=="Published Name" CALL SET "DRIVER_INF=%%c"&&DISM /ENGLISH /%APPLY_TARGET% /GET-DRIVERINFO /DRIVER:"%%c">"$DISM"
IF "%%a %%b %%c"=="Original File Name" CALL SET "DRIVER_NAME=%%d"&&CALL SET "BASEPRE=%%d"&&CALL SET "BASECAP=%%d"
IF "%%a %%b"=="Class Name" CALL SET "DRIVER_CLS=%%c"
IF "%%a"=="Version" CALL SET "DRIVER_VER=%%b"&&CALL:BASECAP)
CALL:MOUNT_NONE
CALL:VDISK_DETACH&&CALL:TITLECARD
:LIST_BASE_CLEANUP
IF DEFINED ERR_MSG CALL:PAD_LINE&&ECHO %ERR_MSG%
CALL:SCRATCH_DELETE&&CALL:PAD_LINE&&ECHO                        End of Base List Creation&&CALL:PAD_LINE&&CALL:CLEAN&&CALL:TITLECARD&&CALL:PAUSED
EXIT /B
:BASECAP
IF DEFINED BASEPRE IF DEFINED BASEPRELST IF "%BASEPRELST%"=="%BASEPRE%" EXIT /B
CALL SET "BASEPRELST=%BASEPRE%"&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "BASECAP=%%BASECAP:%%G=%%G%%")
CALL ECHO  %#@%%LIST_ITEM%%#$% %BASECAP% %#@%%LIST_ACTN%%#$%&&CALL ECHO [%LIST_ITEM%][%BASECAP%][%LIST_ACTN%]>>"%LIST_FOLDER%\%NEW_NAME%.MST"
EXIT /B
:DRIVER_BASECAP
IF "%LIST_ITEM%"=="DRIVER" FOR /F "TOKENS=1-9 SKIP=6 DELIMS=: " %%1 in ($DISM) DO (IF "%%1 %%2 %%3"=="Drivers for architecture" SET "DRIVER_ARC=%%4")
IF "%LIST_ITEM%"=="DRIVER" FOR %%G in (ARC CLS) DO (IF NOT DEFINED DRIVER_%%G SET "DRIVER_%%G=%%G")
EXIT /B
:LIST_COMBINE
IF DEFINED $LST1 COPY /Y "%$LST1%" "$LST1">NUL
IF DEFINED $LST2 COPY /Y "%$LST2%" "$LST2">NUL
IF NOT DEFINED GROUPX ECHO EXEC-LIST>"$LST3"
IF DEFINED GROUPX SET "GROUPX="&&ECHO BASE-GROUP>"$LST3"
CALL:PIPE_CLEAR&&CALL:MOUNT_CLEAR
IF EXIST "$LST1" FOR /F "TOKENS=1-9 DELIMS=[]" %%a in ($LST1) DO (FOR %%1 in (APPX COMPONENT DISM DRIVER FEATURE EXTPACKAGE SERVICE TASK REGISTRY FILEOPER UNATTEND COMMAND) DO (IF "%%1"=="%%a" CALL ECHO [%%a][%%b][%%c][%%d]>>"$LST3")
FOR %%1 in (# $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 GROUP) DO (IF "%%1"=="%%a" CALL ECHO [%%a][%%b][%%c]>>"$LST3"))
IF EXIST "$LST2" ECHO.&&FOR /F "TOKENS=1-9 DELIMS=[]" %%a in ($LST2) DO (FOR %%1 in (APPX COMPONENT DISM DRIVER FEATURE EXTPACKAGE SERVICE TASK REGISTRY FILEOPER UNATTEND COMMAND) DO (IF "%%1"=="%%a" CALL ECHO   %#@%%%a%#$% %%b %#@%%%c%#$% %##%%%d%#$%&&CALL ECHO [%%a][%%b][%%c][%%d]>>"$LST3")
FOR %%1 in (# $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 GROUP) DO (IF "%%1"=="%%a" CALL ECHO [%%a][%%b][%%c]>>"$LST3")
IF "%%a"=="GROUP" CALL ECHO   %#@%%%a%#$% %%b %#@%%%c%#$%)
IF EXIST "$LST2" ECHO.
COPY /Y "$LST3" "%$LST1%">NUL
CALL:MOUNT_REST&&SET "$LST1="&&SET "$LST2="&&SET "$LST3="&&IF EXIST "$LST*" DEL /F "$LST*">NUL
EXIT /B
:PIPE_CLEAR
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (SET "PIPE%%a=")
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (SET "PIPE%%a=%%PIPE%%a%%")
EXIT /B
:LIST_WRITE
IF NOT DEFINED $ELECT EXIT /B
IF EXIST "$LST*" DEL /F "$LST*">NUL
FOR %%a in (%$ELECT%) DO (IF NOT "%%a"=="" CALL SET "LIST_WRITE=[%%$ITEM%%a%%]"&&CALL:LIST_WRITEX)
EXIT /B
:LIST_WRITEX
IF NOT "%LIST_ITEM%"=="EXTPACKAGE" FOR /F "TOKENS=1-9 DELIMS=[]" %%1 IN ("%LIST_WRITE%") DO (IF "%%1"=="%LIST_ITEM%" CALL ECHO [%%1][%%2][%LIST_ACTN%][%LIST_TIME%]>>"$LST2")
IF "%LIST_ITEM%"=="EXTPACKAGE" FOR /F "TOKENS=1-9 DELIMS=[]" %%1 IN ("%LIST_WRITE%") DO (CALL ECHO [EXTPACKAGE][%%1][%LIST_ACTN%][%LIST_TIME%]>>"$LST2")
EXIT /B
:PAD_SAME
IF "%$LST1%"=="%$PICK%" CALL:PAD_LINE&&ECHO %#@%%$LST1%%#$% and %#@%%$PICK%%#$% are the same...&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PAD_MULT
CALL:PAD_LINE&&ECHO                          Multiples OK ( %##%1 2 3%#$% )&&CALL:PAD_LINE
EXIT /B
:PAD_ADD
CLS&&CALL:PAD_LINE&&ECHO                 The Following Items Were Added/Combined:&&CALL:PAD_LINE
EXIT /B
:PAD_END
CALL:PAD_LINE&&ECHO                           End of List Creation&&CALL:PAD_LINE
EXIT /B
:NULL
EXIT /B
:IF_LIVE_EXT
IF DEFINED LIVE_APPLY CALL:MOUNT_NONE
IF DEFINED LIVE_APPLY IF NOT DEFINED CUR_SID IF "%PROG_MODE%"=="COMMAND" CALL:MOUNT_USR
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
EXIT /B
:IF_LIVE_MIX
IF DEFINED LIVE_APPLY CALL:MOUNT_NONE
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_MIX
EXIT /B
::#########################################################################
:IMAGEMGR_RUN_LIST
::#########################################################################
SET "ERR_MSG="&&IF "%LIVE_APPLY%"=="1" GOTO:THE_ACTION
IF EXIST "V:\" SET "ERR_MSG=%##%Drive letter V:\ can NOT be in use. Unmount the Vdisk in use.%#$%"&&GOTO:THE_ACTION_CLEANUP
CALL:VDISK_ATTACH
IF NOT "%VDISK_SYS%"=="1" SET "ERR_MSG=             %##%Vdisk error or Windows not installed on Vdisk.%#$%"&&CALL:VDISK_DETACH&&GOTO:THE_ACTION_CLEANUP
:THE_ACTION
CALL:UNIFIED_LIST_RUN
CALL:MOUNT_NONE
IF NOT DEFINED LIVE_APPLY CALL:VDISK_DETACH
:THE_ACTION_CLEANUP
IF DEFINED ERR_MSG ECHO.&&ECHO %ERR_MSG%
CALL:SCRATCH_DELETE&&CALL:AIO_DELETE&&CALL:TITLECARD&&IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:UNIFIED_LIST_RUN
IF NOT DEFINED $LST1 EXIT /B
IF "%BRUTE_FORCE%"=="ENABLED" IF "%PROG_MODE%"=="RAMDISK" SET "BRUTE_FORCE="&&SET "BRUTE_FLG=1"
IF "%BRUTE_FORCE%"=="ENABLED" SC DELETE $BRUTE>NUL 2>&1
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO             %#@%EXEC-LIST START:%#$%  %DATE%  %TIME%&&ECHO.&&COPY /Y "%$LST1%" "$LST">NUL 2>&1
IF "%BRUTE_FORCE%"=="ENABLED" SC CREATE $BRUTE BINPATH="CMD /C START "%PROG_SOURCE%\$BRUTE.CMD"" START=DEMAND>NUL 2>&1
CALL:PIPE_CLEAR&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=[]" %%a in ($LST) DO (IF "%%a"=="FILEOPER" SET "MOUNT="&&SET "DRVTAR=%%DRVTAR%%"
IF "%%a"=="REGISTRY" SET "MOUNT="&&SET "HIVE_SOFTWARE=%%HIVE_SOFTWARE%%"&&SET "HIVE_SYSTEM=%%HIVE_SYSTEM%%"&&SET "HIVE_USER=%%HIVE_USER%%"
FOR %%1 in (# $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 APPX COMPONENT DISM DRIVER FEATURE EXTPACKAGE SERVICE TASK REGISTRY FILEOPER UNATTEND COMMAND) DO (IF "%%1"=="%%a" CALL SET "LIST_ITEM=%%a"&&CALL SET "BASE_MEAT=%%b"&&CALL SET "LIST_ACTN=%%c"&&CALL SET "LIST_TIME=%%d"&&CALL:UNIFIED_PARSE))
:UNIFIED_LIST_RUN_END
IF "%BRUTE_FORCE%"=="ENABLED" SC DELETE $BRUTE>NUL 2>&1
IF DEFINED BRUTE_FLG SET "BRUTE_FLG="&&SET "BRUTE_FORCE=ENABLED"
CALL:SCRATCH_PACK_DELETE&&ECHO.&&ECHO              %#@%EXEC-LIST END:%#$%  %DATE%  %TIME%&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE
SET "$LST1="&&SET "LIST_ITEM="&&SET "LIST_LAST="&&SET "DRIVER_QRY="&&SET "SC_PREPARE="&&SET "RO_PREPARE="
CALL:CLEAN&&IF EXIST "%PROG_SOURCE%\$BRUTE.CMD" DEL /Q /F "%PROG_SOURCE%\$BRUTE.CMD">NUL 2>&1
IF EXIST "$QRY" DEL /Q /F "$QRY">NUL 2>&1
EXIT /B
:UNIFIED_PARSE
CALL:CLEAN&&SET "NORESTART="&&SET "ENDQ=End of search"&&IF DEFINED LIVE_APPLY SET "NORESTART=/NORESTART "
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (IF "%LIST_ITEM%"=="$%%a" SET "PIPE%%a=%LIST_ACTN%"&&EXIT /B)
IF DEFINED LIST_LAST IF NOT "%LIST_ITEM%"=="$0" IF NOT "%LIST_ITEM%"=="$1" IF NOT "%LIST_ITEM%"=="$2" IF NOT "%LIST_ITEM%"=="$3" IF NOT "%LIST_ITEM%"=="$4" IF NOT "%LIST_ITEM%"=="$5" IF NOT "%LIST_ITEM%"=="$6" IF NOT "%LIST_ITEM%"=="$7" IF NOT "%LIST_ITEM%"=="$8" IF NOT "%LIST_ITEM%"=="$9" IF NOT "%LIST_LAST%"=="%LIST_ITEM%" ECHO.
IF "%LIST_TIME%"=="RUN-ONCE" CALL:RO_CREATE
IF "%LIST_TIME%"=="SETUP-COMPLETE" CALL:SC_CREATE
IF "%LIST_ITEM%:%LIST_TIME%"=="DRIVER:IMAGE-APPLY" CALL:DRVR_HUNT
IF "%LIST_ITEM%:%LIST_TIME%"=="FEATURE:IMAGE-APPLY" CALL:FEAT_HUNT
IF "%LIST_ITEM%:%LIST_TIME%"=="SERVICE:IMAGE-APPLY" CALL:SVC_HUNT
IF "%LIST_ITEM%:%LIST_TIME%"=="REGISTRY:IMAGE-APPLY" CALL:REG_HUNT
IF "%LIST_ITEM%:%LIST_TIME%"=="FILEOPER:IMAGE-APPLY" CALL:FILE_HUNT
IF "%LIST_ITEM%:%LIST_TIME%"=="UNATTEND:IMAGE-APPLY" CALL:UNATTEND_XML
IF "%LIST_ITEM%:%LIST_TIME%"=="COMMAND:IMAGE-APPLY" CALL:COMMAND_EXEC
IF "%LIST_ITEM%:%LIST_TIME%"=="WALLPAPER:IMAGE-APPLY" CALL:WALLPAPER_IMPORT
IF "%LIST_ITEM%:%LIST_ACTN%:%LIST_TIME%"=="APPX:DELETE:IMAGE-APPLY" CALL:APPX_HUNT
IF "%LIST_ITEM%:%LIST_ACTN%:%LIST_TIME%"=="TASK:DELETE:IMAGE-APPLY" CALL:TASK_HUNT
IF "%LIST_ITEM%:%LIST_ACTN%:%LIST_TIME%"=="COMPONENT:DELETE:IMAGE-APPLY" CALL:COMP_HUNT
IF "%LIST_ITEM%"=="#" FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (IF "%%a"=="%LIST_ACTN%" CALL ECHO.%%XLR%%a%%%BASE_MEAT%%#$%)
IF "%LIST_ITEM%:%LIST_TIME%"=="DISM:IMAGE-APPLY" IF NOT "%BASE_MEAT%"=="" IF NOT "%LIST_ACTN%"=="" SET "DISM_OPER=%BASE_MEAT%"&&CALL:IMAGEMGR_DISM_OPER
IF "%LIST_ITEM%:%LIST_TIME%"=="EXTPACKAGE:IMAGE-APPLY" CALL SET "IMAGE_PACK=%PACK_FOLDER%\%BASE_MEAT%"&&CALL:PACK_INSTALL
SET "LIST_LAST=%LIST_ITEM%"&&CALL:CLEAN
EXIT /B
:WALLPAPER_IMPORT
IF NOT EXIST "%CACHE_FOLDER%\wallpaper.jpg" ECHO  %XLR2%Error: wallpaper.jpg does not exist in folder.%#$%&&EXIT /B
CALL:IF_LIVE_MIX
TAKEOWN /F "%WINTAR%\web\wallpaper\Windows\img0.jpg">NUL 2>&1
ICACLS "%WINTAR%\web\wallpaper\Windows\img0.jpg" /grant %USERNAME%:F>NUL 2>&1
COPY /Y "%CACHE_FOLDER%\wallpaper.jpg" "%WINTAR%\web\wallpaper\Windows\img0.jpg">NUL 2>&1
IF EXIST "%WINTAR%\web\wallpaper\Windows\img0.jpg" ECHO  Wallpaper.jpg was successfully added.
EXIT /B
:UNATTEND_XML
IF NOT EXIST "%CACHE_FOLDER%\unattend.xml" ECHO  %XLR2%Error: unattend.xml does not exist in folder.%#$%&&EXIT /B
CALL:IF_LIVE_MIX
MD "%WINTAR%\PANTHER">NUL 2>&1
IF EXIST "%WINTAR%\PANTHER\unattend.xml" TAKEOWN /F "%WINTAR%\PANTHER\unattend.xml">NUL 2>&1
IF EXIST "%WINTAR%\PANTHER\unattend.xml" ICACLS "%WINTAR%\PANTHER\unattend.xml" /grant %USERNAME%:F>NUL 2>&1
COPY /Y "%CACHE_FOLDER%\unattend.xml" "%WINTAR%\PANTHER">NUL 2>&1
IF EXIST "%WINTAR%\PANTHER\unattend.xml" ECHO  Unattend.xml was successfully added.
IF NOT EXIST "%WINTAR%\PANTHER\unattend.xml" ECHO  %XLR2%Adding unattend.xml was unsuccessful.%#$%
EXIT /B
:COMMAND_EXEC
CALL:IF_LIVE_MIX
%BASE_MEAT%
EXIT /B
:FILE_HUNT
CALL:IF_LIVE_MIX
CALL SET "BASE_MEAT=%BASE_MEAT:"=%"
IF NOT EXIST "%BASE_MEAT%" ECHO  File/folder %#@%"%BASE_MEAT%"%#$% does not exist.&&EXIT /B
IF EXIST "%BASE_MEAT%\*" TAKEOWN /F "%BASE_MEAT%" /R /D Y >NUL 2>&1
IF EXIST "%BASE_MEAT%\*" ICACLS "%BASE_MEAT%\*" /grant %USERNAME%:F /T >NUL 2>&1
IF NOT EXIST "%BASE_MEAT%\*" TAKEOWN /F "%BASE_MEAT%" >NUL 2>&1
IF NOT EXIST "%BASE_MEAT%\*" ICACLS "%BASE_MEAT%" /grant %USERNAME%:F >NUL 2>&1
IF NOT EXIST "%BASE_MEAT%\*" DEL /Q /F "\\?\%BASE_MEAT%" >NUL 2>&1
IF EXIST "%BASE_MEAT%\*" RD /S /Q "\\?\%BASE_MEAT%" >NUL 2>&1
IF EXIST "%BASE_MEAT%" ECHO  Could not delete %#@%"%BASE_MEAT%"%#$%.
IF NOT EXIST "%BASE_MEAT%\*" IF NOT EXIST "%BASE_MEAT%" ECHO  File/folder %#@%"%BASE_MEAT%"%#$% was successfully deleted.
SET "BASE_MEAT="
EXIT /B
:REG_HUNT
IF NOT "%LIST_ACTN%"=="ADD" IF NOT "%LIST_ACTN%"=="DELETE" ECHO ERROR: List action is not add or delete.&&EXIT /B
CALL:IF_LIVE_EXT
IF "%LIST_ACTN%"=="ADD" CALL ECHO Adding registry %#@%%BASE_MEAT%%#$%
IF "%LIST_ACTN%"=="DELETE" CALL ECHO Deleting registry %#@%%BASE_MEAT%%#$%
IF NOT "%BRUTE_FORCE%"=="ENABLED" CALL Reg.exe %LIST_ACTN% %BASE_MEAT% >NUL 2>&1
IF "%BRUTE_FORCE%"=="ENABLED" CALL ECHO Reg.exe %LIST_ACTN% %BASE_MEAT% >"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" ECHO EXIT>>"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" SC START $BRUTE>NUL 2>&1
SET "BASE_MEAT="
EXIT /B
:DRVR_HUNT
IF NOT "%LIST_ACTN%"=="DELETE" ECHO ERROR: List action is not delete.&&EXIT /B
CALL:IF_LIVE_MIX
IF NOT DEFINED DRIVER_QRY SET "DRIVER_QRY=1"&&ECHO Getting driver listing..&&DISM /ENGLISH /%APPLY_TARGET% /GET-DRIVERS /FORMAT:TABLE>"$QRY"
ECHO Removing driver %#@%%BASE_MEAT%%#$%&&SET "CAPS_SET=BASE_MEAT"&&SET "CAPS_VAR=%BASE_MEAT%"&&CALL:CAPS_SET
FOR /F "TOKENS=1-9 SKIP=6 DELIMS=| " %%a in ($QRY) DO (SET "DISMSG="&&SET "X1=%%a"&&SET "CAPS_SET=X2"&&SET "CAPS_VAR=%%b"&&CALL:CAPS_SET&&CALL:DRVR_REMOVE)
IF NOT EXIST "$DRVR" ECHO Driver %##%%BASE_MEAT%%#$% doesn't exist.
EXIT /B
:DRVR_REMOVE
IF NOT "%X2%"=="%BASE_MEAT%" EXIT /B
ECHO Uninstalling INF %#@%%X1%%#$%
IF DEFINED LIVE_APPLY PNPUTIL.EXE /DELETE-DRIVER "%X1%" /UNINSTALL /FORCE>"$DRVR"
IF NOT DEFINED LIVE_APPLY DISM /ENGLISH /%APPLY_TARGET% /REMOVE-DRIVER /DRIVER:"%X1%">"$DRVR"
IF EXIST "$DRVR" FOR /F "TOKENS=1 DELIMS=." %%1 in ($DRVR) DO (IF "%%1"=="The operation completed successfully" SET "DISMSG=%%1"
IF "%%1"=="Driver package deleted successfully" SET "DISMSG=The operation completed successfully")
IF EXIST "$DRVR" IF NOT DEFINED DISMSG ECHO Driver %##%%BASE_MEAT%%#$% unable to remove.
IF DEFINED DISMSG ECHO                  %#@%%DISMSG%%#$%
EXIT /B
:SVC_HUNT
CALL:IF_LIVE_EXT
IF "%LIST_ITEM%:%LIST_ACTN%"=="SERVICE:DELETE" ECHO Removing Service %#@%%BASE_MEAT%%#$%...
IF NOT "%LIST_ITEM%:%LIST_ACTN%"=="SERVICE:DELETE" ECHO Changing start to %#@%%LIST_ACTN%%#$% for Service %#@%%BASE_MEAT%%#$%...
REG QUERY "%HIVE_SYSTEM%\ControlSet001\Services\%BASE_MEAT%" /F ImagePath /c /e /s>$REG1 2>&1
SET "SVC_GO="&&SET "SVC_XNT="&&FOR /F "TOKENS=1-9* DELIMS=: " %%a IN ($REG1) DO (IF "%%a"=="ImagePath" IF NOT "%%c"=="NUL" CALL SET "SVC_GO=1")
IF NOT DEFINED SVC_GO SET "REGMSG=Service %##%%BASE_MEAT%%#$% doesn't exist"&&GOTO:SVC_SKIP
IF "%LIST_ITEM%:%LIST_ACTN%"=="SERVICE:AUTO" REG ADD "%HIVE_SYSTEM%\ControlSet001\Services\%BASE_MEAT%" /V "Start" /T REG_DWORD /D "2" /F>NUL&&ECHO                  %#@%The operation completed successfully%#$%&&EXIT /B
IF "%LIST_ITEM%:%LIST_ACTN%"=="SERVICE:MANUAL" REG ADD "%HIVE_SYSTEM%\ControlSet001\Services\%BASE_MEAT%" /V "Start" /T REG_DWORD /D "3" /F>NUL&&ECHO                  %#@%The operation completed successfully%#$%&&EXIT /B
IF "%LIST_ITEM%:%LIST_ACTN%"=="SERVICE:DISABLE" REG ADD "%HIVE_SYSTEM%\ControlSet001\Services\%BASE_MEAT%" /V "Start" /T REG_DWORD /D "4" /F>NUL&&ECHO                  %#@%The operation completed successfully%#$%&&EXIT /B
FOR %%1 in (%SVC_SKIP%) DO (IF "%BASE_MEAT%"=="%%1" CALL ECHO Deleting Service %#@%%BASE_MEAT%%#$%...&&CALL ECHO              %##%The operation did NOT complete successfully%#$%&&EXIT /B)
SET "SVC_XNT="&&CALL SET "X0Z="&&FOR /F "TOKENS=1-9* DELIMS={}:" %%a IN ($REG1) DO (IF NOT "%%a"=="" CALL SET /A "SVC_XNT+=1"&&CALL SET "X1=%%a"&&CALL SET "X2=%%b"&&CALL:SVCBBQ&&CALL:NULL)
REG QUERY "%HIVE_SYSTEM%\ControlSet001\Services\%BASE_MEAT%" /F ImagePath /c /e /s>$REG2 2>&1
SET "REGMSG="&&FOR /F "TOKENS=1-9 DELIMS= " %%a IN ($REG2) DO (IF "%%a"=="ImagePath" IF NOT "%%c"=="NUL" CALL SET "REGMSG=             %##%The operation did NOT complete successfully%#$%")
:SVC_SKIP
IF NOT DEFINED REGMSG ECHO                  %#@%The operation completed successfully%#$%
IF DEFINED REGMSG ECHO %REGMSG%
EXIT /B
:SVCBBQ
IF "%X1%"=="%ENDQ%" EXIT /B
IF "%BASE_MEAT%"=="%X0Z%" EXIT /B
SET "X0Z=%BASE_MEAT%"&&SET "REGMSG="
IF "%SVC_XNT%"=="1" IF "%X1%"=="ERROR" SET "REGMSG=Service %##%%BASE_MEAT%%#$% doesn't exist"
IF "%SVC_XNT%"=="1" IF "%X1%"=="%ENDQ%" SET "REGMSG=Service %##%%BASE_MEAT%%#$% doesn't exist"
IF DEFINED REGMSG EXIT /B
SET SVC_CMD1=REG DELETE "%X1%" /F&&SET SVC_CMD2=REG ADD "%X1%" /V "ImagePath" /T REG_EXPAND_SZ /D "NUL" /F
IF NOT "%BRUTE_FORCE%"=="ENABLED" %SVC_CMD1%>NUL 2>&1
IF NOT "%BRUTE_FORCE%"=="ENABLED" %SVC_CMD2%>NUL 2>&1
IF "%BRUTE_FORCE%"=="ENABLED" ECHO %SVC_CMD1%>"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" ECHO %SVC_CMD2%>>"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" ECHO EXIT>>"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" SC START $BRUTE>NUL 2>&1
IF EXIST "$REG1" DEL /F "$REG1">NUL
EXIT /B
:TASK_HUNT
ECHO Removing Task %#@%%BASE_MEAT%%#$%...&&CALL:IF_LIVE_EXT
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%BASE_MEAT%" /F Id /c /e /s>$REG1 2>&1
SET "TASK_GO="&&SET "TASK_XNT="&&FOR /F "TOKENS=1-9* DELIMS={}:" %%a IN ($REG1) DO (IF "%%a"=="    Id    REG_SZ    " SET "TASK_GO=1")
IF NOT DEFINED TASK_GO SET "REGMSG=Task [%##%%BASE_MEAT%%#$%] doesn't exist"&&GOTO:TASK_SKIP
SET "TASK_XNT="&&CALL SET "X0Z="&&FOR /F "TOKENS=1-9* DELIMS={}:" %%a IN ($REG1) DO (IF NOT "%%a"=="" CALL SET /A "TASK_XNT+=1"&&CALL SET "X1=%%a"&&CALL SET "X2=%%b"&&CALL:TASKBBQ&&CALL:TASK_CHK)
:TASK_SKIP
IF NOT DEFINED REGMSG ECHO                  %#@%The operation completed successfully%#$%
IF DEFINED REGMSG ECHO %REGMSG%
EXIT /B
:TASK_CHK
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%BASE_MEAT%" /F Id /c /e /s>$REG2 2>&1
SET "REGMSG="&&SET "TASK_XNT="&&FOR /F "TOKENS=1-9* DELIMS={}:" %%a IN ($REG2) DO (IF "%%a"=="    Id    REG_SZ    " CALL SET "REGMSG=             %##%The operation did NOT complete successfully%#$%")
EXIT /B
:TASKBBQ
IF "%X1%"=="%ENDQ%" EXIT /B
IF "%BASE_MEAT%"=="%X0Z%" EXIT /B
SET "REGMSG="&&IF NOT "%BASE_MEAT%"=="%X0Z%" SET "X0Z=%BASE_MEAT%"
IF "%TASK_XNT%"=="1" IF "%X1%"=="ERROR" SET "REGMSG=Task %##%%BASE_MEAT%%#$% doesn't exist"
IF "%TASK_XNT%"=="1" IF "%X1%"=="%ENDQ%" SET "REGMSG=Task %##%%BASE_MEAT%%#$% doesn't exist"
IF DEFINED REGMSG EXIT /B
SET TASK_CMD1=REG DELETE "%X1%" /F&&SET TASK_CMD2=REG DELETE "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{%X2%}" /F
IF NOT "%BRUTE_FORCE%"=="ENABLED" IF NOT "%X1%"=="    Id    REG_SZ    " %TASK_CMD1%>NUL 2>&1
IF NOT "%BRUTE_FORCE%"=="ENABLED" IF "%X1%"=="    Id    REG_SZ    " %TASK_CMD2%>NUL 2>&1
IF NOT "%BRUTE_FORCE%"=="ENABLED" DEL /F "%WINTAR%\System32\Tasks\%BASE_MEAT%">NUL 2>&1
IF "%BRUTE_FORCE%"=="ENABLED" IF NOT "%X1%"=="    Id    REG_SZ    " ECHO %TASK_CMD1%>"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" IF "%X1%"=="    Id    REG_SZ    " ECHO %TASK_CMD2%>>"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" ECHO DEL /F "%WINTAR%\System32\Tasks\%BASE_MEAT%">>"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" ECHO EXIT>>"%PROG_SOURCE%\$BRUTE.CMD"
IF "%BRUTE_FORCE%"=="ENABLED" SC START $BRUTE>NUL 2>&1
IF EXIST "$REG1" DEL /F "$REG1">NUL
EXIT /B
:APPX_HUNT
SET "APPX_SKIP="&&SET "APPX_DONE="&&SET "APPX_ERR="&&SET "APPX_ABT="&&SET "DISMSG="&&CALL:IF_LIVE_EXT
ECHO Removing AppX %#@%%BASE_MEAT%%#$%...
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" /F "%BASE_MEAT%">"$REG1"
SET "APPX_XNT="&&FOR /F "TOKENS=3* DELIMS=_" %%a IN ($REG1) DO (IF NOT "%%a"=="" CALL SET /A "APPX_XNT+=1"&&CALL SET "TX1=%%a"&&CALL SET "TX2=%%b"&&CALL:APPX_IBX)
IF NOT DEFINED APPX_SKIP REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" /F "%BASE_MEAT%">"$REG1"
IF NOT DEFINED APPX_SKIP SET "APPX_XNT="&&FOR /F "TOKENS=3* DELIMS=_" %%a IN ($REG1) DO (IF NOT "%%a"=="" CALL SET /A "APPX_XNT+=1"&&CALL SET "TX1=%%a"&&CALL SET "TX2=%%b"&&CALL:APPX_NML)
IF DEFINED APPX_ERR ECHO AppX %##%%BASE_MEAT%%#$% is a stub or unable to remove.
IF NOT DEFINED APPX_DONE IF NOT DEFINED APPX_ERR ECHO AppX %##%%BASE_MEAT%%#$% doesn't exist.
IF DEFINED APPX_DONE ECHO                  %#@%%DISMSG%%#$%
EXIT /B
:APPX_IBX
IF "%TX1%"=="%ENDQ%" EXIT /B
CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-9* DELIMS={}:" %%a IN ($REG1) DO (IF NOT "%%a"=="" IF "%%a"=="ERROR" SET "APPX_ABT=1")
IF DEFINED APPX_ABT EXIT /B
REG DELETE "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications\%BASE_MEAT%_%TX2%" /F>NUL 2>&1
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" /F "%BASE_MEAT%">"$REG3"
FOR /F "TOKENS=1-9* DELIMS=: " %%a IN ($REG3) DO (IF NOT "%%a"=="" IF "%%d"=="0" SET "APPX_SKIP=1"&&SET "APPX_DONE=1"&&SET "DISMSG=The operation completed successfully")
IF DEFINED APPX_DONE REG ADD "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%BASE_MEAT%_%TX2%">NUL 2>&1
IF NOT DEFINED APPX_DONE SET "APPX_SKIP=1"&&SET "APPX_ERR=1"
IF EXIST "$REG3" DEL /F "$REG3">NUL
EXIT /B
:APPX_NML
IF "%TX1%"=="%ENDQ%" EXIT /B
CALL:IF_LIVE_MIX
DISM /ENGLISH /%APPLY_TARGET% /REMOVE-Provisionedappxpackage /PACKAGENAME:"%BASE_MEAT%_%TX2%" >"$DISM1"
FOR /F "TOKENS=1 DELIMS=." %%1 in ($DISM1) DO (SET "DISMSG="&&IF "%%1"=="The operation completed successfully" CALL SET "DISMSG=%%1")
IF NOT DEFINED DISMSG SET "APPX_ERR=1"
IF DEFINED DISMSG SET "APPX_DONE=1"
IF EXIST "$DISM1" DEL /F "$DISM1">NUL
CALL:IF_LIVE_EXT
IF DEFINED APPX_DONE REG ADD "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%BASE_MEAT%_%TX2%">NUL 2>&1
EXIT /B
:COMP_HUNT
ECHO Removing Component %#@%%BASE_MEAT%%#$%...&&CALL:IF_LIVE_EXT
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /F "%BASE_MEAT%">"$REG1"
SET "X0Z="&&SET "COMP_XNT="&&SET "FNL_XNT="&&FOR /F "TOKENS=1* DELIMS=:~" %%a IN ($REG1) DO (IF NOT "%%a"=="" CALL SET /A "COMP_XNT+=1"&&CALL SET /A "FNL_XNT+=1"&&CALL SET "TX1=%%a"&&CALL SET "TX2=%%b"&&CALL:COMP_HUNT2)
EXIT /B
:COMP_HUNT2
IF "%X0Z%"=="%TX1%" EXIT /B
IF "%COMP_XNT%" GTR "1" EXIT /B
IF "%TX1%"=="%ENDQ%" ECHO Component %##%%BASE_MEAT%%#$% doesn't exist.&&EXIT /B
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
FOR %%a in (1 2 3 4 5 6 7 8 9) DO (CALL SET "COMP_Z%%a=")
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /F "%BASE_MEAT%">"$REG2"
SET "X0Z="&&SET "SUB_XNT="&&SET "COMP_FLAG="&&FOR /F "TOKENS=1* DELIMS=:~" %%1 IN ($REG2) DO (IF NOT "%%1"=="" CALL SET /A "SUB_XNT+=1"&&CALL SET "X1=%%1"&&CALL SET "X2=%%2"&&CALL:COMPBBQ)
IF EXIST "$REG2" DEL /F "$REG2">NUL
EXIT /B
:COMP_AVOID
IF "%BASE_MEAT%~%X2%"=="%COMPX%" SET "COMP_AVD=1"
EXIT /B
:COMPBBQ
IF "%X1%"=="%ENDQ%" EXIT /B
IF "%FNL_XNT%" GTR "9" EXIT /B
IF "%SUB_XNT%" GTR "9" EXIT /B
IF "%X0Z%"=="%BASE_MEAT%~%X2%" EXIT /B
SET "COMP_AVD="&&FOR %%a in (1 2 3 4 5 6 7 8 9) DO (CALL SET "COMPX=%%COMP_Z%%a%%"&&CALL:COMP_AVOID)
IF DEFINED COMP_AVD EXIT /B
SET "COMP_ABT=X"&&SET "COMP_ABT1="&&IF "%SAFE_EXCLUDE%"=="ENABLED" FOR /F "TOKENS=1-9 DELIMS=-" %%1 IN ("%BASE_MEAT%") DO (IF "%%4"=="FEATURES" SET "COMP_ABT1=1")
SET "COMP_ABT2="&&IF "%SAFE_EXCLUDE%"=="ENABLED" FOR /F "TOKENS=1-9 DELIMS=-" %%1 IN ("%BASE_MEAT%") DO (IF "%%5"=="REQUIRED" SET "COMP_ABT2=1")
SET "COMP_Z%FNL_XNT%=%BASE_MEAT%~%X2%"&&SET "COMP_ABT3="&&FOR %%1 in (%COMP_SKIP%) DO (IF "%BASE_MEAT%"=="%%1" SET "COMP_ABT3=1")
IF NOT DEFINED COMP_ABT1 IF NOT DEFINED COMP_ABT2 IF NOT DEFINED COMP_ABT3 SET "COMP_ABT="
SET /A "FNL_XNT+=1"&&SET "X0Z=%BASE_MEAT%~%X2%"&&IF NOT DEFINED COMP_FLAG ECHO Removing Subcomp %#@%%BASE_MEAT%~%X2%%#$%...
IF DEFINED COMP_ABT IF "%FNL_XNT%"=="2" SET "COMP_FLAG=1"&&ECHO Component %##%%BASE_MEAT%%#$% is required or unable to remove.
IF DEFINED COMP_ABT EXIT /B
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
REG ADD "%X1%~%X2%" /V "Visibility" /T REG_DWORD /D "1" /F>NUL 2>&1
REG DELETE "%X1%~%X2%\Owners" /F>NUL 2>&1
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_MIX
DISM /ENGLISH /%APPLY_TARGET% %NORESTART%/REMOVE-PACKAGE /PACKAGENAME:"%BASE_MEAT%~%X2%" >"$DISM1"
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ($DISM1) DO (SET "DISMSG="&&IF "%%1"=="The operation completed successfully" CALL SET "DISMSG=%%1")
IF NOT DEFINED DISMSG ECHO Component %##%%BASE_MEAT%%#$% is a stub or unable to remove.
IF DEFINED DISMSG ECHO                  %#@%%DISMSG%%#$%
IF EXIST "$DISM1" DEL /F "$DISM1">NUL
EXIT /B
:FEAT_HUNT
CALL:IF_LIVE_MIX
IF "%LIST_ITEM%:%LIST_ACTN%"=="FEATURE:ENABLE" ECHO Enabling Feature %#@%%BASE_MEAT%%#$%...&&DISM /ENGLISH /%APPLY_TARGET% %NORESTART%/ENABLE-FEATURE /FEATURENAME:"%BASE_MEAT%" /ALL>"$DISM1"
IF "%LIST_ITEM%:%LIST_ACTN%"=="FEATURE:ENABLE" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%a in ($DISM1) DO (SET "DISMSG="&&IF "%%a"=="The operation completed successfully" CALL SET "DISMSG=%%a"&&CALL ECHO                  %#@%%%a%#$%)
IF "%LIST_ITEM%:%LIST_ACTN%"=="FEATURE:DISABLE" ECHO Disabling Feature %#@%%BASE_MEAT%%#$%...&&DISM /ENGLISH /%APPLY_TARGET% %NORESTART%/DISABLE-FEATURE /FEATURENAME:"%BASE_MEAT%" /REMOVE>"$DISM1"
IF "%LIST_ITEM%:%LIST_ACTN%"=="FEATURE:DISABLE" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%a in ($DISM1) DO (SET "DISMSG="&&IF "%%a"=="The operation completed successfully" CALL SET "DISMSG=%%a"&&CALL ECHO                  %#@%%%a%#$%)
IF "%LIST_ITEM%:%LIST_ACTN%"=="FEATURE:ENABLE" IF NOT DEFINED DISMSG CALL ECHO Feature %##%%BASE_MEAT%%#$% is a stub or unable to remove.
IF "%LIST_ITEM%:%LIST_ACTN%"=="FEATURE:DISABLE" IF NOT DEFINED DISMSG CALL ECHO Feature %##%%BASE_MEAT%%#$% is a stub or unable to remove.
EXIT /B
:SC_CREATE
SET "SCRO=SetupComplete"&&CALL:IF_LIVE_EXT
IF NOT DEFINED SC_PREPARE SET "SPC3="&&SET "SC_PREPARE=1"&&CALL:SC_RO_PREPARE
IF NOT DEFINED BASE_MEAT EXIT /B
CALL:SC_RO_COPY
EXIT /B
:RO_CREATE
SET "SCRO=RunOnce"&&CALL:IF_LIVE_EXT
IF NOT DEFINED RO_PREPARE SET "SPC3=   "&&SET "RO_PREPARE=1"&&CALL:SC_RO_PREPARE
IF NOT DEFINED BASE_MEAT EXIT /B
CALL:SC_RO_COPY
EXIT /B
:SC_RO_COPY
IF "%LIST_ITEM%"=="EXTPACKAGE" ECHO Copying Package %BASE_MEAT% for %##%%LIST_TIME%%#$%...
IF "%LIST_ITEM%"=="EXTPACKAGE" IF NOT EXIST "%PACK_FOLDER%\%BASE_MEAT%" ECHO %PACK_FOLDER%\%BASE_MEAT% doesn't exist.
IF "%LIST_ITEM%"=="EXTPACKAGE" IF EXIST "%PACK_FOLDER%\%BASE_MEAT%" COPY /Y "%PACK_FOLDER%\%BASE_MEAT%" "%APPLYDIR_MASTER%\$">NUL
IF "%LIST_ITEM%"=="EXTPACKAGE" IF EXIST "%PACK_FOLDER%\%BASE_MEAT%" ECHO [EXTPACKAGE][%BASE_MEAT%][INSTALL][IMAGE-APPLY]>>"%APPLYDIR_MASTER%\$\%SCRO%.lst"
IF NOT "%LIST_ITEM%"=="EXTPACKAGE" CALL:MOUNT_CLEAR
IF NOT "%LIST_ITEM%"=="EXTPACKAGE" ECHO Scheduling %#@%%LIST_ITEM%%#$% %BASE_MEAT% %#@%%LIST_ACTN%%#$% for %##%%LIST_TIME%%#$%...&&ECHO [%LIST_ITEM%][%BASE_MEAT%][%LIST_ACTN%][IMAGE-APPLY]>>"%APPLYDIR_MASTER%\$\%SCRO%.lst"
SET "BASE_MEAT="&&CALL:MOUNT_REST
EXIT /B
:SC_RO_PREPARE
IF NOT EXIST "%APPLYDIR_MASTER%\$" MD "%APPLYDIR_MASTER%\$">NUL 2>&1
COPY /Y "%PROG_FOLDER%\windick.cmd" "%APPLYDIR_MASTER%\$">NUL 2>&1
IF NOT EXIST "%APPLYDIR_MASTER%\$\%SCRO%.LST" ECHO EXEC-LIST>"%APPLYDIR_MASTER%\$\%SCRO%.lst"
IF "%SCRO%"=="RunOnce" Reg.exe add "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\RunOnce" /v "Runonce" /t REG_EXPAND_SZ /d "%%WINDIR%%\Setup\Scripts\RunOnce.cmd" /f>NUL 2>&1
IF NOT EXIST "%WINTAR%\Setup\Scripts" MD "%WINTAR%\Setup\Scripts">NUL 2>&1
ECHO;%%SYSTEMDRIVE%%\$\windick.cmd -imagemgr -runbrute -lst %SCRO%.lst -live>"%WINTAR%\Setup\Scripts\%SCRO%.cmd"
ECHO;EXIT 0 >>"%WINTAR%\Setup\Scripts\%SCRO%.cmd"
EXIT /B
::#########################################################################
:PACK_INSTALL
::#########################################################################
IF NOT EXIST "%IMAGE_PACK%" ECHO %##%%IMAGE_PACK%%#$% doesn't exist.&&GOTO:PACK_INSTALL_FINISH
SET "PACK_GOOD=The operation completed successfully"&&SET "PACK_BAD=The operation did NOT complete successfully"&&CALL:SCRATCH_PACK_CREATE
FOR %%a in (PackName PackType PackDesc PackTag) DO (CALL SET "%%a=")
FOR %%G in ("%IMAGE_PACK%") DO SET "PackExt=%%~xG"
FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "PackExt=%%PackExt:%%G=%%G%%")
FOR %%G in (APPX APPXBUNDLE MSIXBUNDLE CAB MSU) DO (IF "%PackExt%"==".%%G" SET "PackType=DRIVER"&&SET "PackName=%IMAGE_PACK%")
IF NOT "%PackExt%"==".PKG" GOTO:PACK_JUMP
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%IMAGE_PACK%" /INDEX:2 /APPLYDIR:"%SCRATCH_PACK%" >NUL 2>&1
COPY /Y "%SCRATCH_PACK%\PACKAGE.MAN" "$PAK">NUL&&FOR /F "eol=- TOKENS=1-2 DELIMS==" %%a in ($PAK) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
ECHO Extracting %#@%%IMAGE_PACK%%#$%..
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%IMAGE_PACK%" /INDEX:1 /APPLYDIR:"%SCRATCH_PACK%">NUL
:PACK_JUMP
IF "%PackType%"=="DRIVER" CALL:IF_LIVE_MIX
IF "%PackType%"=="SCRIPTED" IF "%PackTag%"=="MOUNT" CALL:IF_LIVE_EXT
IF "%PackType%"=="SCRIPTED" IF "%PackTag%"=="UNMOUNT" CALL:IF_LIVE_MIX
IF "%PackType%"=="SCRIPTED" IF NOT "%PackTag%"=="MOUNT" IF NOT "%PackTag%"=="UNMOUNT" ECHO Package outdated. Missing mount option.&&GOTO:PACK_INSTALL_FINISH
ECHO Running %#@%%PackName%%#$% %#@%%PackExt%%#$% DESC: %#@%%PackDesc%%#$%
FOR %%G in (APPXBUNDLE MSIXBUNDLE) DO (IF "%PackExt%"==".%%G" SET "PackExt=.APPX")
IF "%PackExt%"==".APPX" DISM /ENGLISH /%APPLY_TARGET% /ADD-PROVISIONEDAPPXPACKAGE /PACKAGEPATH:"%IMAGE_PACK%" >"$DRVR"
IF "%PackExt%"==".APPX" CALL:PACK_CHECK
IF "%PackExt%"==".APPX" IF NOT DEFINED DISMSG DISM /ENGLISH /%APPLY_TARGET% /ADD-PROVISIONEDAPPXPACKAGE /PACKAGEPATH:"%IMAGE_PACK%" /SKIPLICENSE>"$DRVR"
IF "%PackExt%"==".APPX" IF NOT DEFINED DISMSG CALL:PACK_CHECK
IF "%PackExt%"==".APPX" IF DEFINED DISMSG CALL ECHO                  %#@%%PACK_GOOD%%#$%
IF "%PackExt%"==".APPX" IF NOT DEFINED DISMSG CALL ECHO               %##%%PACK_BAD%%#$%
IF "%PackExt%"==".APPX" GOTO:PACK_INSTALL_FINISH
IF "%PackExt%"==".CAB" DISM /ENGLISH /%APPLY_TARGET% /ADD-PACKAGE /PACKAGEPATH:"%IMAGE_PACK%" >"$DRVR"
IF "%PackExt%"==".CAB" CALL:PACK_CHECK
IF "%PackExt%"==".CAB" IF DEFINED DISMSG CALL ECHO                  %#@%%PACK_GOOD%%#$%&&GOTO:PACK_INSTALL_FINISH
IF "%PackExt%"==".CAB" IF NOT DEFINED DISMSG EXPAND "%IMAGE_PACK%" -F:* "%SCRATCH_PACK%" >NUL 2>&1
IF "%PackExt%"==".MSU" DISM /ENGLISH /%APPLY_TARGET% /ADD-PACKAGE /PACKAGEPATH:"%IMAGE_PACK%" >"$DRVR"
IF "%PackExt%"==".MSU" CALL:PACK_CHECK
IF "%PackExt%"==".MSU" IF DEFINED DISMSG CALL ECHO                  %#@%%PACK_GOOD%%#$%
IF "%PackExt%"==".MSU" IF NOT DEFINED DISMSG CALL ECHO               %##%%PACK_BAD%%#$%
IF "%PackExt%"==".MSU" GOTO:PACK_INSTALL_FINISH
IF "%PackType%"=="SCRIPTED" CD /D "%SCRATCH_PACK%"&&CMD /C "%SCRATCH_PACK%\PACKAGE.CMD"
IF "%PackType%"=="SCRIPTED" CD /D "%PROG_FOLDER%"&&ECHO.
IF "%PackType%"=="DRIVER" FOR /F "TOKENS=*" %%a in ('DIR/S/B "%SCRATCH_PACK%\*.INF"') DO (
IF NOT EXIST "%%a\*" CALL:TITLECARD&&CALL ECHO Installing INF %#@%%%a%#$%
IF NOT EXIST "%%a\*" IF NOT DEFINED LIVE_APPLY DISM /ENGLISH /%APPLY_TARGET% /ADD-DRIVER /DRIVER:"%%a" /ForceUnsigned>"$DRVR"
IF NOT EXIST "%%a\*" IF DEFINED LIVE_APPLY pnputil.exe /add-driver "%%a" /install>"$DRVR"
IF NOT EXIST "%%a\*" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ($DRVR) DO (
IF "%%1"=="Driver package added successfully" CALL SET "DISMSG=1"
IF "%%1"=="%PACK_GOOD%" CALL SET "DISMSG=1")
IF NOT EXIST "%%a\*" IF DEFINED DISMSG CALL ECHO                  %#@%%PACK_GOOD%%#$%
IF NOT EXIST "%%a\*" IF NOT DEFINED DISMSG CALL ECHO               %##%%PACK_BAD%%#$%)
:PACK_INSTALL_FINISH
FOR %%a in (DRVR PAK) DO (IF EXIST "$%%a" DEL /F "$%%a">NUL)
CALL:SCRATCH_PACK_DELETE&&CALL:MOUNT_NONE
EXIT /B
:PACK_CHECK
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ($DRVR) DO (IF "%%1"=="%PACK_GOOD%" CALL SET "DISMSG=1")
EXIT /B
:DISM_CHOICE
SET "DISM_OPER="&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%1%#$%) RestoreHealth&&ECHO  (%##%2%#$%) Cleanup&&ECHO  (%##%3%#$%) ResetBase&&ECHO  (%##%4%#$%) SPSuperseded&&ECHO  (%##%5%#$%) CheckHealth
ECHO  (%##%6%#$%) AnalyzeComponentStore&&ECHO  (%##%7%#$%) WinRE Remove&&ECHO  (%##%8%#$%) WinSxS Remove&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=DISM_MENU"&&CALL:PROMPT_SET
IF "%DISM_MENU%"=="1" SET "DISM_OPER=RESTOREHEALTH"
IF "%DISM_MENU%"=="2" SET "DISM_OPER=CLEANUP"
IF "%DISM_MENU%"=="3" SET "DISM_OPER=RESETBASE"
IF "%DISM_MENU%"=="4" SET "DISM_OPER=SPSUPERSEDED"
IF "%DISM_MENU%"=="5" SET "DISM_OPER=CHECKHEALTH"
IF "%DISM_MENU%"=="6" SET "DISM_OPER=ANALYZE"
IF "%DISM_MENU%"=="7" SET "DISM_OPER=WINRE"
IF "%DISM_MENU%"=="8" SET "DISM_OPER=WINSXS"
EXIT /B
:IMAGEMGR_DISM_OPER
CALL:IF_LIVE_MIX
IF "%DISM_OPER%"=="RESTOREHEALTH" ECHO                      Executing DISM Restorehealth...&&DISM /ENGLISH /%APPLY_TARGET% /CLEANUP-IMAGE /Restorehealth
IF "%DISM_OPER%"=="CLEANUP" ECHO                  Executing DISM StartComponentCleanup.....&&DISM /ENGLISH /%APPLY_TARGET% /CLEANUP-IMAGE /StartComponentCleanup
IF "%DISM_OPER%"=="RESETBASE" ECHO                       Executing DISM ResetBase....&&DISM /ENGLISH /%APPLY_TARGET% /CLEANUP-IMAGE /StartComponentCleanup /ResetBase
IF "%DISM_OPER%"=="SPSUPERSEDED" ECHO                      Executing DISM SPSuperseded...&&DISM /ENGLISH /%APPLY_TARGET% /CLEANUP-IMAGE /SPSuperseded
IF "%DISM_OPER%"=="CHECKHEALTH" ECHO                      Executing DISM CheckHealth...&&DISM /ENGLISH /%APPLY_TARGET% /CLEANUP-IMAGE /CHECKHEALTH
IF "%DISM_OPER%"=="ANALYZE" ECHO                  Executing DISM AnalyzeComponentStore...&&DISM /ENGLISH /%APPLY_TARGET% /CLEANUP-IMAGE /AnalyzeComponentStore
IF "%DISM_OPER%"=="WINRE" ECHO                    Executing WindowsRecovery Remove...&&CALL:WINRE_REMOVE
IF "%DISM_OPER%"=="WINSXS" ECHO                        Executing WinSxS Remove...&&CALL:WINSXS_REMOVE
EXIT /B
:WINRE_REMOVE
ECHO.&&IF NOT EXIST "%WINTAR%\SYSTEM32\Recovery" ECHO %#@%Recovery%#$% folder doesn't exist...
IF EXIST "%WINTAR%\SYSTEM32\Recovery" ECHO Deleting %#@%Recovery%#$% folder...&&RD /Q /S "\\?\%WINTAR%\SYSTEM32\Recovery">NUL 2>&1
EXIT /B
:WINSXS_REMOVE
SET "WinSxS=WinSxS"&&SET "STRINGX=amd64_microsoft-windows-s..cingstack.resources amd64_microsoft-windows-servicingstack amd64_microsoft.vc80.crt amd64_microsoft.vc90.crt amd64_microsoft.windows.c..-controls.resources amd64_microsoft.windows.common-controls amd64_microsoft.windows.gdiplus x86_microsoft.vc80.crt x86_microsoft.vc90.crt x86_microsoft.windows.c..-controls.resources x86_microsoft.windows.common-controls x86_microsoft.windows.gdiplus"
ECHO.&&ECHO Removing %#@%WinSxS%#$% folder...&&DIR "%WINTAR%\%WinSxS%" /A: /B /O:GN>"$XS"&&SET "SUBZ="&&SET "SUBXNT="&&FOR /F "TOKENS=1-2* DELIMS=_" %%a IN ($XS) DO (IF NOT "%%a"=="" SET "QUERYX=%%a_%%b"&&SET "SUBX=%%c"&&SET /A "SUBXNT+=1"&&CALL:LATERS_WINSXS)
FOR %%$ in (NULL) DO (TAKEOWN /F "%WINTAR%\%WinSxS%\%%$" /R /D Y>NUL 2>&1
ICACLS "%WINTAR%\%WinSxS%\%%$" /grant %USERNAME%:F /T>NUL 2>&1
RD /Q /S "\\?\%WINTAR%\%WinSxS%\%%$">NUL 2>&1)
SET "WinSxS="&&DEL /F "$XS">NUL
EXIT /B
:LATERS_WINSXS
IF "%QUERYX%_%SUBX%"=="%SUBZ%" EXIT /B
FOR %%1 in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) DO (IF %SUBXNT% EQU %%1500 CALL ECHO WinSxS folder queue item %##%%%1500%#$%...
IF "%SUBXNT%"=="%%1000" CALL ECHO WinSxS folder queue item %##%%%1000%#$%...)
SET "DNTX="&&FOR %%a in (%STRINGX%) DO (IF "%QUERYX%"=="%%a" SET "DNTX=1")
SET "SUBZ=%QUERYX%_%SUBX%"&&SET "DNTX="&&FOR %%a in (%STRINGX%) DO (IF "%QUERYX%"=="%%a" SET "DNTX=1")
IF NOT DEFINED DNTX (TAKEOWN /F "%WINTAR%\%WinSxS%\%QUERYX%_%SUBX%" /R /D Y>NUL 2>&1
ICACLS "%WINTAR%\%WinSxS%\%QUERYX%_%SUBX%" /grant %USERNAME%:F /T>NUL 2>&1
RD /Q /S "\\?\%WINTAR%\%WinSxS%\%QUERYX%_%SUBX%" >NUL 2>&1) ELSE (ECHO Keeping %#@%%QUERYX%_%SUBX%%#$%)
EXIT /B
:IMAGEMGR_INSPECT
SET "ERR_MSG="&&SET "REPORT_IMAGE="&&SET "MENU_INSERTA= ( %##%@%#$% ) %##%Current-Environment%#$%"&&SET "NOECHO1=1"&&SET "PICK=VHDX"&&CALL:FILE_PICK
IF NOT "%LIVE_APPLY%"=="1" IF NOT DEFINED $PICK EXIT /B
IF "%LIVE_APPLY%"=="1" IF NOT DEFINED DISCLAIMER CALL:DISCLAIMER&EXIT /B
IF "%LIVE_APPLY%"=="1" SET "REPORT_IMAGE=LIVE"&&GOTO:INSPECT_JUMP_LIVE
IF EXIST "V:\" SET "ERR_MSG=%##%Drive letter V:\ can NOT be in use. Unmount the Vdisk in use.%#$%"&&CALL:PAD_LINE&&ECHO.&&GOTO:INSPECT_CLEANUP
SET "REPORT_IMAGE=%$ELECT$%"&&CALL:SCRATCH_CREATE&&SET "VDISK=%IMAGE_FOLDER%\%$ELECT$%"&&CALL:VDISK_ATTACH&&CALL:MOUNT_EXT
IF NOT "%VDISK_SYS%"=="1" SET "ERR_MSG=             %##%Vdisk error or Windows not installed on Vdisk.%#$%"&&CALL:VDISK_DETACH&&GOTO:INSPECT_CLEANUP
:INSPECT_JUMP_LIVE
CALL:PAD_LINE&&ECHO                             Performing scan...&&CALL:TITLECARD&&CALL:IF_LIVE_EXT
CALL:PAD_WRITE>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
ECHO STARTUP ITEMS REPORT>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
CALL:PAD_WRITE>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
IF EXIST "%APPLYDIR_MASTER%\WINDOWS\Setup\Scripts\SETUPCOMPLETE.CMD" ECHO.SetupComplete.cmd located in \WINDOWS\Setup\Scripts>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
IF NOT EXIST "%APPLYDIR_MASTER%\WINDOWS\Setup\Scripts\SETUPCOMPLETE.CMD" ECHO.No SetupComplete.cmd exists in image>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
IF EXIST "%APPLYDIR_MASTER%\WINDOWS\PANTHER\UNATTEND.XML" ECHO.Unattend.xml located in \WINDOWS\PANTHER>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
IF NOT EXIST "%APPLYDIR_MASTER%\WINDOWS\PANTHER\UNATTEND.XML" ECHO.No Unattend.xml exists in image>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
CALL:PAD_WRITE>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
ECHO Searching: %HIVE_USER%\SOFTWARE\Microsoft\Windows\CurrentVersion\Run>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
REG QUERY "%HIVE_USER%\Software\Microsoft\Windows\CurrentVersion\Run">>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT" 2>&1
ECHO Searching: %HIVE_USER%\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
REG QUERY "%HIVE_USER%\Software\Microsoft\Windows\CurrentVersion\RunOnce">>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT" 2>&1
ECHO Searching: %HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Run>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Run">>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT" 2>&1
ECHO Searching: %HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\RunOnce>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\RunOnce">>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT" 2>&1
ECHO Searching: %HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\RunOnceEx>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\RunOnceEx">>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT" 2>&1
ECHO Searching: %HIVE_SOFTWARE%\Wow6432Node\Microsoft\Windows\CurrentVersion\Run>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
REG QUERY "%HIVE_SOFTWARE%\Wow6432Node\Microsoft\Windows\CurrentVersion\Run">>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT" 2>&1
ECHO Searching: %HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Winlogon>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
REG QUERY "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Winlogon" /f Userinit /c /e /s>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT" 2>&1
CALL:MOUNT_NONE
IF NOT DEFINED LIVE_APPLY CALL:VDISK_DETACH
CALL:PAD_WRITE>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
ECHO  Inspection Complete [%REPORT_IMAGE%] %DATE% %TIME% >>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
CALL:PAD_WRITE>>"%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
START NOTEPAD.EXE "%PROG_SOURCE%\%REPORT_IMAGE%_REPORT.TXT"
:INSPECT_CLEANUP
IF DEFINED ERR_MSG CALL:PAD_LINE&&ECHO %ERR_MSG%
CALL:SCRATCH_DELETE&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PAD_WRITE
IF NOT DEFINED CHCP_TMP FOR /F "TOKENS=2 DELIMS=:" %%a IN ('CHCP') DO SET "CHCP_TMP=%%a"
CHCP 65001 >NUL&&ECHO;■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■&&CHCP %CHCP_TMP% >NUL
EXIT /B
:SCRATCH_CREATE
IF NOT DEFINED SCRATCHDIR SET "SCRATCHDIR=%PROG_SOURCE%\Scratch"
IF EXIST "%SCRATCHDIR%" SET "SCRATCHDIRX=%SCRATCHDIR%"&&CALL:SCRATCH_DELETE
IF DEFINED SCRATCHDIRX SET "SCRATCHDIR=%SCRATCHDIRX%"
IF NOT EXIST "%SCRATCHDIR%" MD "%SCRATCHDIR%">NUL 2>&1
SET "SCRATCHDIRX="
EXIT /B
:SCRATCH_DELETE
IF NOT DEFINED SCRATCHDIR SET "SCRATCHDIR=%PROG_SOURCE%\Scratch"
IF EXIST "%SCRATCHDIR%" DISM /cleanup-MountPoints>NUL 2>&1
IF EXIST "%SCRATCHDIR%" ATTRIB -R -S -H "%SCRATCHDIR%" /S /D /L>NUL 2>&1
IF EXIST "%SCRATCHDIR%" RD /S /Q "%SCRATCHDIR%">NUL 2>&1
SET "SCRATCHDIR="
EXIT /B
:AIO_DELETE
IF EXIST "%PROG_SOURCE%\ScratchAIO" DISM /cleanup-MountPoints>NUL 2>&1
IF EXIST "%PROG_SOURCE%\ScratchAIO" ATTRIB -R -S -H "%PROG_SOURCE%\ScratchAIO" /S /D /L>NUL 2>&1
IF EXIST "%PROG_SOURCE%\ScratchAIO" RD /S /Q "\\?\%PROG_SOURCE%\ScratchAIO">NUL 2>&1
EXIT /B
:BOOT_IMPORT
IF EXIST "%BOOT_FOLDER%\boot.sav" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO          File boot.sav already exists. Press (%##%X%#$%) to overwrite.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF EXIST "%BOOT_FOLDER%\boot.sav" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%SOURCE_LOCATION%\boot.wim" ECHO Importing %#@%boot.wim%#$% to boot.sav...&&COPY /Y "%SOURCE_LOCATION%\boot.wim" "%BOOT_FOLDER%\boot.sav"
EXIT /B
:SOURCE_IMPORT
IF EXIST "%SOURCE_LOCATION%\install.wim" ECHO.&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                          Enter new name of .WIM&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEW_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED NEW_NAME EXIT /B
IF EXIST "%IMAGE_FOLDER%\%NEW_NAME%.wim" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO          File %NEW_NAME%.wim already exists. Press (%##%X%#$%) to overwrite.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF EXIST "%IMAGE_FOLDER%\%NEW_NAME%.wim" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED NEW_NAME ECHO Copying install.wim to %#@%%NEW_NAME%.wim%#$%...&&COPY /Y "%SOURCE_LOCATION%\install.wim" "%IMAGE_FOLDER%\%NEW_NAME%.wim"&&SET "NEW_NAME="
EXIT /B
:MOUNT_NONE
IF "%MOUNT%"=="NONE" EXIT /B
SET "HIVE_USER=HKCU"&&REG UNLOAD HKU\$ALLUSER>NUL 2>&1
SET "HIVE_SOFTWARE=HKLM\SOFTWARE"&&REG UNLOAD HKLM\$SOFTWARE>NUL 2>&1
SET "HIVE_SYSTEM=HKLM\SYSTEM"&&REG UNLOAD HKLM\$SYSTEM>NUL 2>&1
SET "MOUNT=NONE"&&SET "APPLYDIR_MASTER=%SYSTEMDRIVE%"&&SET "CAPTUREDIR_MASTER=%SYSTEMDRIVE%"
SET "APPLY_TARGET=ONLINE"&&SET "DRVTAR=%SYSTEMDRIVE%"&&SET "WINTAR=%WINDIR%"&&SET "USRTAR=%USERPROFILE%"
IF DEFINED CUR_SID SET "HIVE_USER=HKU\%CUR_SID%"
EXIT /B
:MOUNT_USR
IF "%MOUNT%"=="USR" EXIT /B
SET "MOUNT=USR"&&SET "HIVE_USER=HKU\$ALLUSER"&&REG UNLOAD HKU\$ALLUSER>NUL 2>&1
SET "USRTAR=%SYSTEMDRIVE%\Users\Default"&&REG LOAD HKU\$ALLUSER "%SYSTEMDRIVE%\Users\Default\Ntuser.dat">NUL 2>&1
EXIT /B
:MOUNT_EXT
IF "%MOUNT%"=="EXT" EXIT /B
SET "MOUNT=EXT"&&REG UNLOAD HKU\$ALLUSER>NUL 2>&1
SET "APPLYDIR_MASTER=V:"&&REG UNLOAD HKLM\$SOFTWARE>NUL 2>&1
SET "CAPTUREDIR_MASTER=V:"&&REG UNLOAD HKLM\$SYSTEM>NUL 2>&1
SET "APPLY_TARGET=IMAGE:V:"&&SET "DRVTAR=V:"&&SET "WINTAR=V:\Windows"&&SET "USRTAR=V:\Users\Default"
SET "HIVE_USER=HKU\$ALLUSER"&&REG LOAD HKU\$ALLUSER "V:\Users\Default\Ntuser.dat">NUL 2>&1
SET "HIVE_SOFTWARE=HKLM\$SOFTWARE"&&REG LOAD HKLM\$SOFTWARE "V:\WINDOWS\SYSTEM32\Config\SOFTWARE">NUL 2>&1
SET "HIVE_SYSTEM=HKLM\$SYSTEM"&&REG LOAD HKLM\$SYSTEM "V:\WINDOWS\SYSTEM32\Config\SYSTEM">NUL 2>&1
EXIT /B
:MOUNT_MIX
IF "%MOUNT%"=="MIX" EXIT /B
SET "HIVE_USER=HKCU"&&REG UNLOAD HKU\$ALLUSER>NUL 2>&1
SET "HIVE_SOFTWARE=HKLM\SOFTWARE"&&REG UNLOAD HKLM\$SOFTWARE>NUL 2>&1
SET "HIVE_SYSTEM=HKLM\SYSTEM"&&REG UNLOAD HKLM\$SYSTEM>NUL 2>&1
SET "MOUNT=MIX"&&SET "APPLYDIR_MASTER=V:"&&SET "CAPTUREDIR_MASTER=V:"
SET "APPLY_TARGET=IMAGE:V:"&&SET "DRVTAR=V:"&&SET "WINTAR=V:\Windows"&&SET "USRTAR=V:\Users\Default"
EXIT /B
::#########################################################################
:FILE_MANAGER
::#########################################################################
@ECHO OFF&&CLS&&CALL:TITLE_X&&CALL:PAD_LINE
IF NOT DEFINED FMGR_SOURCE SET "FMGR_SOURCE=%PROG_SOURCE%"&&SET "FMGR_TARGET=%PROG_SOURCE%"
IF NOT EXIST "%FMGR_SOURCE%\*" SET "FMGR_SOURCE=%PROG_SOURCE%"&&SET "FMGR_TARGET=%PROG_SOURCE%"
ECHO                             File Management&&CALL:PAD_LINE&&ECHO                               %#@%SRC%#$% (%##%X%#$%) %#@%TGT%#$%&&CALL:PAD_LINE
IF "%FMGR_DUAL%"=="ENABLED" ECHO   %#@%TARGET FOLDER:%#$% %FMGR_TARGET%&&SET "BLIST=FMGT"&&CALL:FILE_LIST&&CALL:PAD_LINE
ECHO   %#@%SOURCE FOLDER:%#$% %FMGR_SOURCE%&&SET "MENU_INSERTA=  (%##%..%#$%)"&&SET "BLIST=FMGS"&&CALL:FILE_LIST&&CALL:PAD_LINE
ECHO  (%##%E%#$%)xplore (%##%N%#$%)ew (%##%O%#$%)pen (%##%C%#$%)opy (%##%M%#$%)ove (%##%R%#$%)ename (%##%D%#$%)elete (%##%#%#$%)Own (%##%V%#$%)iew&&CALL:PAD_LINE
CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="X" CALL:FMGR_SWAP
IF "%SELECT%"=="N" CALL:FMGR_NEW&&SET "SELECT="
IF "%SELECT%"=="E" CALL:FMGR_EXPLORE&&SET "SELECT="
IF "%SELECT%"=="C" SET "PICK=FMGS"&&CALL:FILE_PICK&&CALL:FMGR_COPY&&SET "SELECT="
IF "%SELECT%"=="O" SET "PICK=FMGS"&&CALL:FILE_PICK&&CALL:FMGR_OPEN&&SET "SELECT="
IF "%SELECT%"=="M" SET "PICK=FMGS"&&CALL:FILE_PICK&&CALL:FMGR_MOVE&&SET "SELECT="
IF "%SELECT%"=="R" SET "PICK=FMGS"&&CALL:FILE_PICK&&CALL:FMGR_REN&&SET "SELECT="
IF "%SELECT%"=="#" SET "PICK=FMGS"&&CALL:FILE_PICK&&CALL:FMGR_OWN&&SET "SELECT="
IF "%SELECT%"=="D" SET "PICK=FMGS"&&CALL:FILE_PICK&&CALL:FMGR_DEL&&SET "SELECT="
IF "%SELECT%"=="V" IF "%FMGR_DUAL%"=="DISABLED" SET "FMGR_DUAL=ENABLED"&&SET "SELECT="
IF "%SELECT%"=="V" IF "%FMGR_DUAL%"=="ENABLED" SET "FMGR_DUAL=DISABLED"&&SET "SELECT="
IF "%SELECT%"==".." CALL SET "FMGR_SOURCE=%%FMGR_SOURCE_%FMS#%%%"&&CALL SET /A "FMS#-=1"
GOTO:FILE_MANAGER
:FMGR_NEW
CLS&&CALL:PAD_LINE&&ECHO.                          Create which type?&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%1%#$%) Folder&&ECHO  (%##%2%#$%) File&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEW_TYPE"&&CALL:PROMPT_SET
IF NOT "%NEW_TYPE%"=="1" IF NOT "%NEW_TYPE%"=="2" EXIT /B
IF "%NEW_TYPE%"=="1" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO.                           New Folder Name?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEW_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF "%NEW_TYPE%"=="1" IF NOT DEFINED NEW_NAME EXIT /B
IF "%NEW_TYPE%"=="1" SET "NEW_TYPE="&&MD "%FMGR_SOURCE%\%NEW_NAME%">NUL 2>&1
IF "%NEW_TYPE%"=="2" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO.                            New File Name?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEW_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF "%NEW_TYPE%"=="2" IF NOT DEFINED NEW_NAME EXIT /B
IF "%NEW_TYPE%"=="2" SET "NEW_TYPE="&&ECHO.>"%FMGR_SOURCE%\%NEW_NAME%"
EXIT /B
:FMGR_REN
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO.                               New name?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEW_NAME"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED NEW_NAME EXIT /B
CALL:PAD_LINE&&REN "%$PICK%" "%NEW_NAME%"
IF NOT EXIST "%FMGR_SOURCE%\%NEW_NAME%\*" ECHO  Renaming %#@%%$PICK%%#$% to %#@%%FMGR_SOURCE%\%NEW_NAME%%#$%.
IF EXIST "%FMGR_SOURCE%\%NEW_NAME%\*" ECHO  Renaming %#@%%$PICK%%#$% to %#@%%FMGR_SOURCE%\%NEW_NAME%%#$%.
CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:FMGR_DEL
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_LINE&&IF NOT EXIST "%$PICK%\*" DEL /Q /F "\\?\%$PICK%"
IF EXIST "%$PICK%\*" RD /S /Q "\\?\%$PICK%"
IF NOT EXIST "%$PICK%\*" IF NOT EXIST "%$PICK%" ECHO  Deleting %#@%%$PICK%%#$%.
CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:FMGR_OPEN
IF NOT DEFINED $PICK EXIT /B
IF NOT EXIST "%$PICK%\*" "%$PICK%"&EXIT /B
IF EXIST "%$PICK%\*" CALL SET /A "FMS#+=1"
CALL SET "FMGR_SOURCE_%FMS#%=%FMGR_SOURCE%"&&CALL SET "FMGR_SOURCE=%$PICK%"
EXIT /B
:FMGR_COPY
IF NOT DEFINED $PICK EXIT /B
IF "%FMGR_SOURCE%"=="%FMGR_TARGET%" CALL:FMGR_SAME&EXIT /B
CALL:PAD_LINE&&IF NOT EXIST "%$PICK%\*" ECHO Copying %#@%%$PICK%%#$% to %#@%%FMGR_TARGET%%#$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%\" /C /Y>NUL 2>&1
IF EXIST "%$PICK%\*" ECHO Copying %#@%%$PICK%%#$% to %#@%%FMGR_TARGET%%#$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%\%$ELECT$%\" /E /C /I /Y>NUL 2>&1
CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:FMGR_SYM
IF NOT DEFINED $PICK EXIT /B
IF "%FMGR_SOURCE%"=="%FMGR_TARGET%" CALL:FMGR_SAME&EXIT /B
CALL:PAD_LINE&&IF EXIST "%$PICK%\*" MKLINK /J "%FMGR_TARGET%\%$ELECT$%" "%$PICK%"
IF NOT EXIST "%$PICK%\*" MKLINK "%FMGR_TARGET%\%$ELECT$%" "%$PICK%"
CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:FMGR_MOVE
IF NOT DEFINED $PICK EXIT /B
IF "%FMGR_SOURCE%"=="%FMGR_TARGET%" CALL:FMGR_SAME&EXIT /B
CALL:PAD_LINE&&IF NOT EXIST "%$PICK%\*" ECHO Moving %#@%%$PICK%%#$% to %#@%%FMGR_TARGET%%#$%...&&MOVE /Y "%$PICK%" "%FMGR_TARGET%\">NUL 2>&1
IF EXIST "%$PICK%\*" ECHO Moving %#@%%$PICK%%#$% to %#@%%FMGR_TARGET%%#$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%\%$ELECT$%\" /E /C /I /Y>NUL 2>&1
IF EXIST "%$PICK%\*" RD /S /Q "\\?\%$PICK%">NUL 2>&1
CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:FMGR_OWN
IF NOT DEFINED $PICK EXIT /B
IF NOT DEFINED NO_PAUSE CALL:PAD_LINE
IF EXIST "%$PICK%\*" TAKEOWN /F "%$PICK%" /R /D Y
IF EXIST "%$PICK%\*" ICACLS "%$PICK%\*" /grant %USERNAME%:F /T >NUL 2>&1
IF NOT EXIST "%$PICK%\*" TAKEOWN /F "%$PICK%"
IF NOT EXIST "%$PICK%\*" ICACLS "%$PICK%" /grant %USERNAME%:F >NUL 2>&1
ECHO.&&IF NOT DEFINED NO_PAUSE CALL:PAD_LINE&&CALL:PAUSED
SET "NO_PAUSE="
EXIT /B
:FMGR_EXPLORE
CALL:PAD_LINE&&ECHO.                             Enter a path&&CALL:PAD_LINE&&ECHO   %#@%AVAILABLE DRIVES:%#$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO  %%G:\)
ECHO.&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
SET "SLASHER="&&IF DEFINED SELECT FOR /F "DELIMS=" %%G in ('CMD.EXE /D /U /C ECHO %SELECT%^| FIND /V ""') do (SET "SLASHX=%%G"&&CALL:REMOVE_SLASH)
IF NOT "%SLASHX%"=="\" IF EXIST "%SELECT%\*" SET "FMGR_SOURCE=%SELECT%"
IF "%SLASHX%"=="\" IF EXIST "%SELECT%*" SET "FMGR_SOURCE=%SLASHZ%"
EXIT /B
:REMOVE_SLASH
SET "SLASHZ=%SLASHER%"&&SET "SLASHER=%SLASHER%%SLASHX%"
EXIT /B
:FMGR_SAME
CALL:PAD_LINE&&ECHO                        Source/Target are the same..&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:FMGR_SWAP
IF NOT EXIST "%FMGR_SOURCE%" EXIT /B
IF NOT EXIST "%FMGR_TARGET%" EXIT /B
SET "FMGR_SOURCE=%FMGR_TARGET%"&&SET "FMGR_TARGET=%FMGR_SOURCE%"
EXIT /B
::#########################################################################
:DISK_MANAGER
::#########################################################################
@ECHO OFF&&CLS&&CALL:SETS_HANDLER&&CALL:TITLE_X&&CALL:CLEAN&&SET "DISK_LETTER="&&SET "DISK_MSG="&&SET "MENUX="&&SET "ERROR="
CALL:PAD_LINE&&ECHO                             Disk Management&&CALL:PAD_LINE&&SET "NOBOX=1"&&CALL:DISK_QUERY&&CALL:PAD_LINE
ECHO  [%#@%DISK%#$%] (%##%B%#$%)oot       (%##%I%#$%)nspect       (%##%E%#$%)rase       (%##%*%#$%)NextBoot %#@%%NEXT_BOOT%%#$%&&CALL:PAD_LINE
IF NOT "%PROG_MODE%"=="RAMDISK" ECHO  [%#@%PART%#$%] (%##%C%#$%)reate     (%##%D%#$%)elete     (%##%F%#$%)ormat     (%##%M%#$%)ount     (%##%U%#$%)nmount 
IF "%PROG_MODE%"=="RAMDISK" ECHO  [%#@%PART%#$%] (%##%C%#$%)reate (%##%D%#$%)elete (%##%F%#$%)ormat (%##%M%#$%)ount (%##%U%#$%)nmount (%##%H%#$%)ide Host %#@%%HOST_HIDE%%#$%
CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="*" CALL:NEXT_BOOT
IF "%SELECT%"=="B" IF EXIST "%BOOT_FOLDER%\boot.sav" GOTO:BOOT_CREATOR
IF "%SELECT%"=="UID" CALL:DISK_MENU&&CALL:DISK_UID_PROMPT&&CALL:DISK_PART_END&&SET "SELECT="
IF "%SELECT%"=="E" CALL:DISK_ERASE_PROMPT&&CALL:DISK_PART_END&&SET "SELECT="
IF "%SELECT%"=="I" CLS&&CALL:PAD_LINE&&ECHO                         Select a disk to inspect&&CALL:PAD_LINE&&CALL:DISK_MENU&&CALL:DISKMGR_INSPECT&&CALL:DISK_PART_END&&SET "SELECT="
IF "%SELECT%"=="C" CLS&&CALL:PAD_LINE&&ECHO                    Select a disk to create partition&&CALL:PAD_LINE&&CALL:DISK_MENU&&CALL:PART_CREATE_PROMPT&&CALL:DISK_PART_END&&SET "SELECT="
IF "%SELECT%"=="F" CLS&&CALL:PAD_LINE&&ECHO                    Select a disk to format partition&&CALL:PAD_LINE&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:CONFIRM&&CALL:DISKMGR_FORMAT&&CALL:DISK_PART_END&&SET "SELECT="
IF "%SELECT%"=="D" CLS&&CALL:PAD_LINE&&ECHO                    Select a disk to delete partition&&CALL:PAD_LINE&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:CONFIRM&&CALL:DISKMGR_DELETE&&CALL:DISK_PART_END&&SET "SELECT="
IF "%SELECT%"=="M" CLS&&CALL:PAD_LINE&&ECHO                    Select a disk to mount partition&&CALL:PAD_LINE&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:LETTER_GET&&CALL:CONFIRM&&CALL:DISKMGR_MOUNT&SET "SELECT="
IF "%SELECT%"=="U" CLS&&CALL:PAD_LINE&&ECHO                    Select a disk to unmount partition&&CALL:PAD_LINE&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:LETTER_GET&&CALL:CONFIRM&&CALL:DISKMGR_UNMOUNT&SET "SELECT="
IF "%SELECT%"=="B" IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%BOOT_FOLDER%\boot.sav" CALL:BOOT_FETCH
IF "%SELECT%"=="B" IF "%PROG_MODE%"=="PORTABLE" IF NOT EXIST "%BOOT_FOLDER%\boot.sav" CALL:PAD_LINE&&ECHO    Import boot media from within image processor before proceeding.&&CALL:PAD_LINE&&CALL:PAUSED
IF "%SELECT%"=="H" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="DISABLED" SET "HOST_HIDE=ENABLED"&&SET "SELECT="&&CALL:PAD_LINE&&ECHO VHDX host partition will be hidden upon exit. Boot into recovery to revert.&&CALL:PAD_LINE&&CALL:PAUSED
IF "%SELECT%"=="H" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="ENABLED" SET "HOST_HIDE=DISABLED"&&SET "SELECT="
GOTO:DISK_MANAGER
:DISK_UID
FOR %%a in (DISK_X UID_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.uniqueid disk id=%UID_X%&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK"
SET "DISK_X="&&SET "UID_X="&&CALL:DEL_DSK&&EXIT /B
:PART_ASSIGN
FOR %%a in (DISK_X PART_X LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.assign letter=%LETT_X% noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:VOL_REMOVE
FOR %%a in (LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select VOLUME %LETT_X%&&ECHO.Remove letter=%LETT_X% noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_REMOVE
FOR %%a in (DISK_X PART_X LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.Remove letter=%LETT_X% noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_DELETE
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.delete partition override&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK"
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_FORMAT
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.format quick fs=ntfs override&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK"
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_4000
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.gpt attributes=0x4000000000000001&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_8000
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.gpt attributes=0x0000000000000000&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_EFIX
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.set id=c12a7328-f81f-11d2-ba4b-00a0c93ec93b override&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_BAS
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.set id=ebd0a0a2-b9e5-4433-87c0-68b6b72699c7 override&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_PRIMARY
FOR %%a in (DISK_X) DO (IF NOT DEFINED %%a EXIT /B)
IF DEFINED SIZE_X SET "SIZE_X= size=%SIZE_X%"
(ECHO.select disk %DISK_X%&&ECHO.create partition primary%SIZE_X%&&ECHO.format quick fs=ntfs&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_EFI1
FOR %%a in (DISK_X) DO (IF NOT DEFINED %%a EXIT /B)
IF NOT DEFINED SIZE_X SET "SIZE_X=1024"
(ECHO.select disk %DISK_X%&&ECHO.create partition EFI size=%SIZE_X%&&ECHO.format quick fs=fat32 label="ESP"&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "PART_X=1"&&SET "LETT_X=U"&&CALL:PART_ASSIGN
IF NOT EXIST "U:\" SET "EFI=2"
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:PART_EFI2
FOR %%a in (DISK_X) DO (IF NOT DEFINED %%a EXIT /B)
IF NOT DEFINED SIZE_X SET "SIZE_X=1024"
(ECHO.select disk %DISK_X%&&ECHO.create partition primary size=%SIZE_X%&&ECHO.format quick fs=fat32 label="ESP"&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "PART_X=1"&&SET "LETT_X=U"&&CALL:PART_ASSIGN
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:DISK_CLEAN
FOR %%a in (DISK_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.clean&&ECHO.convert gpt&&ECHO.select partition 1&&ECHO.delete partition override&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DSK&&EXIT /B
:DEL_DSK
IF EXIST "$DSK" DEL /Q /F "$DSK">NUL
EXIT /B
:PART_CREATE
SET "PART_ERR="&&SET "SIZE_X="&&IF NOT DEFINED EFI SET "EFI=1"
IF NOT DEFINED HOST_SIZE SET "HOST_SIZE=DISABLED"
IF "%EFI%"=="1" CALL:DISKMGR_ERASE&&SET "DISK_X=%DISK_NUMBER%"&&CALL:PART_EFI1
IF "%EFI%"=="2" CALL:DISKMGR_ERASE&&SET "DISK_X=%DISK_NUMBER%"&&CALL:PART_EFI2
IF EXIST "U:\" (IF NOT "%HOST_SIZE%"=="DISABLED" SET "SIZE_X=%HOST_SIZE%"
SET "DISK_X=%DISK_NUMBER%"&&CALL:PART_PRIMARY
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=2"&&SET "LETT_X=S"&&CALL:PART_ASSIGN
IF NOT "%HOST_SIZE%"=="DISABLED" IF EXIST "S:\" SET "DISK_X=%DISK_NUMBER%"&&CALL:PART_PRIMARY
IF NOT "%HOST_SIZE%"=="DISABLED" IF EXIST "S:\" SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=3"&&SET "LETT_X=T"&&CALL:PART_ASSIGN)
IF EXIST "U:\" IF EXIST "S:\" SET "EFI="&&EXIT /B
IF NOT DEFINED RETRY_PART SET "RETRY_PART=1"&&SET "EFI="&&GOTO:PART_CREATE
SET "PART_ERR=1"&&SET "EFI="&&SET "RETRY_PART="&&ECHO.&&ECHO                      The drive is currently in use.&&ECHO  Malfunctioning disks or those of poor quality also raise this error.&&ECHO     Unplug the USB disk and/or reboot if this continues to occur.&&ECHO.
EXIT /B
:BOOT_FETCH
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO      File boot.sav doesn't exist. Press (%##%X%#$%) to copy from recovery&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF NOT "%CONFIRM%"=="X" EXIT /B
CALL:EFI_MOUNT&&CALL:PAD_LINE&&ECHO  Copying %#@%boot.sav%#$%...&&COPY /Y "U:\$.WIM" "%BOOT_FOLDER%\boot.sav">NUL 2>&1
CALL:EFI_UNMOUNT
EXIT /B
:NEXT_BOOT
IF "%NEXT_BOOT%"=="NULL" SET "BOOT_TARGET=GET"&&CALL:BOOT_TOGGLE&EXIT /B
IF "%NEXT_BOOT%"=="RECOVERY" SET "BOOT_TARGET=VHDX"&&CALL:BOOT_TOGGLE&EXIT /B
IF "%NEXT_BOOT%"=="VHDX" SET "BOOT_TARGET=RECOVERY"&&CALL:BOOT_TOGGLE&EXIT /B
EXIT /B
:CONFIRM
IF DEFINED ERROR SET "NO_TOP="&&EXIT /B
IF NOT DEFINED NO_TOP CALL:PAD_LINE
SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                   %XLR2%Are your sure?%#$% Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
SET "NO_TOP="&&IF NOT "%CONFIRM%"=="X" SET "ERROR=1"
EXIT /B
:LETTER_GET
IF DEFINED ERROR EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                           Which Drive Letter?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT&&SET "CHECK=LTR"&&CALL:CHECK
IF NOT DEFINED ERROR SET "DISK_LETTER=%SELECT%"
EXIT /B
:PART_GET
IF DEFINED ERROR EXIT /B
SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                           Which Partition? (%##%#%#$%)&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT&&SET "CHECK=NUM"&&CALL:CHECK
IF NOT DEFINED ERROR SET "PART_NUMBER=%SELECT%"
EXIT /B
:DISK_PART_END
IF DEFINED ERROR EXIT /B
IF DEFINED DISK_MSG ECHO.&&CALL:PAD_LINE&&ECHO %DISK_MSG%
ECHO.&&CALL:PAD_LINE&&ECHO	                      End of Disk-Part Operation&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PART_CREATE_PROMPT
IF DEFINED ERROR EXIT /B
IF NOT DEFINED DISK_NUMBER EXIT /B
SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO             Enter a partition size. (%##%0%#$%) Remainder of space &&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT&&SET "CHECK=NUM"&&CALL:CHECK
IF NOT DEFINED ERROR SET "PART_SIZE=%SELECT%"&&CALL:CONFIRM&&CALL:DISKMGR_CREATE
EXIT /B
:DISKMGR_CREATE
IF DEFINED ERROR EXIT /B
IF "%PART_SIZE%"=="0" SET "PART_SIZE="
SET "DISK_X=%DISK_NUMBER%"&&SET "SIZE_X=%PART_SIZE%"&&CALL:PART_PRIMARY
EXIT /B
:DISKMGR_DELETE
IF DEFINED ERROR EXIT /B
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&CALL:PART_DELETE
EXIT /B
:DISKMGR_FORMAT
IF DEFINED ERROR EXIT /B
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&CALL:PART_FORMAT
EXIT /B
:DISKMGR_INSPECT
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_NUMBER%&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK"
EXIT /B
:DISKMGR_MOUNT
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER DISK_LETTER PART_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAD_LINE&&ECHO  MOUNTING %DISK_LETTER%:\&&CALL:PAD_LINE
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&SET "LETT_X=%DISK_LETTER%"&&CALL:PART_ASSIGN
IF NOT EXIST "%DISK_LETTER%:\" SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&SET "LETT_X=%DISK_LETTER%"&&CALL:PART_ASSIGN
IF EXIST "%DISK_LETTER%:\" SET "DISK_MSG=Partition %PART_NUMBER% on Disk %DISK_NUMBER% has been assigned letter %DISK_LETTER%."
IF NOT EXIST "%DISK_LETTER%:\" SET "DISK_MSG=ERROR: Partition %PART_NUMBER% on Disk %DISK_NUMBER% was not assigned letter %DISK_LETTER%."
EXIT /B
:DISKMGR_UNMOUNT
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER DISK_LETTER PART_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAD_LINE&&ECHO  UNMOUNTING %DISK_LETTER%:\&&CALL:PAD_LINE
SET "LETT_X=%DISK_LETTER%"&&CALL:VOL_REMOVE&&SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&SET "LETT_X=%DISK_LETTER%"&&CALL:PART_REMOVE
EXIT /B
:DISK_ERASE_PROMPT
CLS&&CALL:PAD_LINE&&ECHO                          Select a disk to erase&&CALL:PAD_LINE&&CALL:DISK_QUERY&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
SET "CHECK=NUM"&&CALL:CHECK
IF DEFINED HOST_NUMBER IF "%SELECT%"=="%HOST_NUMBER%" SET "ERROR=1"
IF NOT DEFINED ERROR SET "DISK_NUMBER=%SELECT%"&&CALL:CONFIRM&&CALL:DISKMGR_ERASE
EXIT /B
:DISKMGR_ERASE
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
FOR %%a in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15) DO (IF "%DISK_NUMBER%"=="%%a" CALL SET "GET_DISK_ID=%%DISKID_%%a%%")
SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_CLEAN&&SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&SET "LETT_X=T"&&CALL:PART_ASSIGN
IF EXIST "T:\" SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_CLEAN
CALL:DISKMGR_CHANGEID>NUL 2>&1
IF NOT EXIST "T:\" SET "DISK_MSG=All partitions on Disk %DISK_NUMBER% have been erased."
IF EXIST "T:\" SET "DISK_MSG=%##%Disk %DISK_NUMBER% is currently in use - unplug disk - reboot into Windows - replug and try again.%#$%"
IF EXIST "T:\" SET "LETT_X=T"&&CALL:VOL_REMOVE
IF EXIST "T:\" SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&SET "LETT_X=T"&&CALL:PART_REMOVE
EXIT /B
:DISK_UID_PROMPT
ECHO                        Enter a new disk-UID (%##%#%#$%) &&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT SET "ERROR=1"&&EXIT /B
IF NOT DEFINED ERROR SET "GET_DISK_ID=%SELECT%"&&CALL:CONFIRM&&CALL:DISKMGR_CHANGEID
EXIT /B
:DISKMGR_CHANGEID
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER GET_DISK_ID) DO (IF NOT DEFINED %%a EXIT /B)
SET "UID_XNT="&&FOR /F "DELIMS=" %%G in ('CMD.EXE /D /U /C ECHO %GET_DISK_ID%^| FIND /V ""') do (CALL SET /A "UID_XNT+=1")
IF NOT "%UID_XNT%"=="36" SET "GET_DISK_ID=00000000-0000-0000-0000-000000000000"
SET "UID_X=%GET_DISK_ID%"&&SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_UID
EXIT /B
:HOST_HIDE
CALL:PAD_LINE&&ECHO Hiding VHDX host partition...&&CALL:PAD_LINE&&SET /P DISK_TARGET=<"%PROG_FOLDER%\DISK_TARGET"&&CALL:DISK_QUERY>NUL 2>&1
IF NOT DEFINED DISK_NUMBER EXIT /B
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=2"&&SET "LETT_X=S"&&CALL:PART_REMOVE&&SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=2"&&CALL:PART_4000
EXIT /B
:HOST_AUTO
SET "HOST_MOUNT="&&CLS&&ECHO Querying disks...&&IF EXIST "S:\" CALL:HOST_REASSIGN
SET /P DISK_TARGET=<"%PROG_FOLDER%\DISK_TARGET"
SET "HOST_TARGET=%DISK_TARGET%"&&CALL:DISK_QUERY>NUL 2>&1
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=2"&&CALL:PART_8000&&SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=2"&&SET "LETT_X=S"&&CALL:PART_ASSIGN
IF EXIST "S:\" IF NOT EXIST "S:\$" MD "S:\$">NUL 2>&1
IF EXIST "S:\$" IF NOT EXIST "S:\$\windick.cmd" IF EXIST "X:\$\windick.cmd" COPY "X:\$\windick.cmd" "S:\$">NUL 2>&1
IF EXIST "S:\$\settings.ini" COPY /Y "S:\$\settings.ini" "%PROG_FOLDER%">NUL
IF NOT EXIST "S:\$" IF NOT DEFINED ARBIT_FLAG SET "ARBIT_FLAG=1"&&GOTO:HOST_AUTO
IF EXIST "S:\$" SET "PROG_SOURCE=S:\$"&&SET "HOST_MOUNT=YES"&&SET "ARBIT_FLAG="&&SET "HOST_NUMBER=%DISK_NUMBER%"
EXIT /B
:HOST_REASSIGN
CALL:DISK_QUERY>NUL 2>&1
IF DEFINED SET_LETTER SET "HOST_LETTER=%SET_LETTER%"
IF NOT DEFINED SET_LETTER FOR %%G in (P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" SET "HOST_LETTER=%%G")
(ECHO.select VOLUME S&&ECHO.Remove letter=S noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
(ECHO.select VOLUME %HOST_VOLUME%&&ECHO.assign letter=%HOST_LETTER% noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "SET_LETTER="&&CALL:DEL_DSK
EXIT /B
:XTRA_REASSIGN
CALL:DISK_QUERY>NUL 2>&1
IF DEFINED SET_LETTER SET "XTRA_LETTER=%SET_LETTER%"
IF NOT DEFINED SET_LETTER FOR %%G in (P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" SET "XTRA_LETTER=%%G")
(ECHO.select VOLUME T&&ECHO.Remove letter=T noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
(ECHO.select VOLUME %XTRA_VOLUME%&&ECHO.assign letter=%XTRA_LETTER% noerr&&ECHO.Exit)>"$DSK"&&DISKPART /s "$DSK">NUL 2>&1
SET "SET_LETTER="&&CALL:DEL_DSK
EXIT /B
:EFI_MOUNT
IF NOT DEFINED DISK_TARGET EXIT /B
IF NOT DEFINED EFI_LTR SET "EFI_LTR=U"
IF EXIST "%EFI_LTR%:\" SET "ERROR=                   Drive letter %EFI_LTR%:\ cannot be in use."&&SET "EFI_LTR="&&EXIT /B
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&CALL:PART_BAS
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&SET "LETT_X=%EFI_LTR%"&&CALL:PART_ASSIGN
IF NOT EXIST "%EFI_LTR%:\" SET "ERROR=                   EFI letter %EFI_LTR%:\ could not be found."
SET "EFI_LTR="
EXIT /B
:EFI_UNMOUNT
IF NOT DEFINED DISK_TARGET EXIT /B
IF NOT DEFINED EFI_LTR SET "EFI_LTR=U"
IF NOT EXIST "%EFI_LTR%:\" EXIT /B
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&SET "LETT_X=%EFI_LTR%"&&CALL:PART_REMOVE
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&CALL:PART_EFIX
IF EXIST "%EFI_LTR%:\" SET "ERROR=                  Drive letter %EFI_LTR%:\ could not dismount."
SET "EFI_LTR="
EXIT /B
:BOOT_QUERY
SET "BOOT_OK="&&SET "GUID_TMP="&&SET "GUID_CUR="&&FOR /F "TOKENS=1-5 DELIMS= " %%a in ('BCDEDIT.EXE /V') do (
IF "%%a"=="displayorder" SET "GUID_CUR=%%b"
IF "%%a"=="identifier" SET "GUID_TMP=%%b"
IF "%%a"=="description" IF "%%b"=="WINDICK" SET "BOOT_OK=1"&&GOTO:BOOT_QUERYX)
:BOOT_QUERYX
IF "%GUID_TMP%"=="%GUID_CUR%" SET "NEXT_BOOT=RECOVERY"
IF NOT "%GUID_TMP%"=="%GUID_CUR%" SET "NEXT_BOOT=VHDX"
EXIT /B
:BOOT_TOGGLE
CALL:BOOT_QUERY
IF NOT DEFINED BOOT_OK EXIT /B
IF NOT "%BOOT_TARGET%"=="VHDX" IF NOT "%BOOT_TARGET%"=="RECOVERY" EXIT /B
IF "%BOOT_TARGET%"=="VHDX" SET "NEXT_BOOT=VHDX"&&BCDEDIT.EXE /displayorder %GUID_TMP% /addlast>NUL 2>&1
IF "%BOOT_TARGET%"=="RECOVERY" SET "NEXT_BOOT=RECOVERY"&&BCDEDIT.EXE /displayorder %GUID_TMP% /addfirst>NUL 2>&1
CALL:BOOT_QUERY&&SET "BOOT_TARGET="
EXIT /B
:DISK_MENU
IF EXIST "%TEMP%\DISK_TARGET" DEL /F "%TEMP%\DISK_TARGET">NUL
SET "ERROR="&&SET "DISK_CONFLICT="&&SET "DISK_NUMBER="&&SET "DISK_TARGET="&&CALL:DISK_QUERY
CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
SET "CHECK=NUM"&&CALL:CHECK&&IF NOT DEFINED DISK_%SELECT% SET "ERROR=1"
IF DEFINED ERROR EXIT /B
CALL SET "DISK_TARGET=%%DISKID_%SELECT%%%"&&CALL:DISK_QUERY>NUL
FOR %%G in (DISK_NUMBER DISK_TARGET) DO (IF NOT DEFINED %%G SET "ERROR=1"&&EXIT /B)
IF "%DISK_TARGET%"=="00000000" SET "ERROR=1"&&SET "DISK_CONFLICT=1"&&CALL:PAD_LINE&&ECHO                   Generic disk UID detected %XLR2%00000000%#$%.&&CALL:PAD_LINE
IF DEFINED HOST_TARGET IF "%HOST_TARGET%"=="%DISK_TARGET%" SET "ERROR=1"
IF NOT DEFINED ERROR CALL:PAD_LINE&&ECHO  DISK %#@%%DISK_NUMBER%%#$% UID %#@%%DISK_TARGET%%#$% is the target disk&&CALL:PAD_LINE&&ECHO.%DISK_TARGET%>"%TEMP%\DISK_TARGET"
EXIT /B
:DISK_QUERY
IF NOT DEFINED NOBOX SET "BOX=T1"&&CALL:BOX
FOR %%a in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) DO (IF DEFINED DISK_%%a SET "DISK_%%a="&&SET "DISKID_%%a=")
(ECHO.LIST DISK&&ECHO.Exit)>"$DSK"&&FOR /F "TOKENS=1,2,4 SKIP=8 DELIMS= " %%a in ('DISKPART /s "$DSK"') DO (
IF "%%a"=="Disk" IF NOT "%%b"=="###" SET "DISK_%%b="&&SET "DISKVND="&&(ECHO.select disk %%b&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DSK"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS={}: " %%1 in ('DISKPART /s "$DSK"') DO (
IF "%%1 %%2"=="Disk %%b" SET "DISK_%%b=%%b"&&ECHO.&&ECHO    %#@%Disk%#$% ^(%##%%%b%#$%^)
IF NOT "%%1 %%2"=="Disk %%b" IF NOT DEFINED DISKVND SET "DISKVND=$"&&ECHO   %#@%Vendor%#$% = %%1 %%2 %%3
IF "%%1"=="Type" ECHO    %#@%Type%#$%  = %%2
IF "%%1 %%2"=="Disk ID" SET "DISKID_%%b=%%3"&&ECHO    %#@%UID%#$%   = %%3&&IF "%%3"=="%DISK_TARGET%" SET "DISK_NUMBER=%%b"
IF "%%1 %%2 %%3"=="Pagefile Disk Yes" SET "DISK_%%b="&&ECHO  %XLR2% Active Pagefile%#$%
IF "%%1"=="Partition" IF NOT "%%2"=="###" ECHO  %#@%P%%2 Size%#$% = %%4 %%5
IF "%%2 %%3 %%4"=="File Backed Virtual" SET "DISK_%%b="&&ECHO    %XLR2%Virtual Disk%#$%
IF "%%1 %%3"=="Volume S" SET "HOST_VOLUME=%%2"
IF "%%1 %%3"=="Volume T" SET "XTRA_VOLUME=%%2"))
ECHO.&&IF NOT DEFINED NOBOX SET "BOX=B1"&&CALL:BOX
SET "NOBOX="&&DEL /Q /F "$DSK*">NUL 2>&1
EXIT /B
::#########################################################################
:BOOT_CREATOR
::#########################################################################
CLS&&CALL:SETS_HANDLER&&CALL:TITLE_X&&CALL:CLEAN&&CALL:PAD_LINE&&ECHO                              Boot Creator&&CALL:PAD_LINE
IF "%HOST_SIZE%"=="DISABLED" (SET "EMBEE=") ELSE (SET "EMBEE=MB")
ECHO   %#@%AVAILABLE VHDX'S:%#$%&&SET "BLIST=VHDX"&&CALL:FILE_LIST&&CALL:PAD_LINE&&ECHO  (%##%O%#$%)ptions                       (%##%G%#$%)o^^!        (%##%V%#$%)HDX %#@%%VHDX_SLOTX%%#$%&&CALL:PAD_LINE
IF DEFINED ADV_BOOT ECHO  [%#@%Options%#$%]  (%##%E%#$%)xport EFI Files   (%##%H%#$%)ost Size %#@%%HOST_SIZE%%EMBEE%%#$%&&CALL:PAD_LINE
CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT GOTO:DISK_MANAGER
IF "%SELECT%"=="E" CALL:EFI_FETCH
IF "%SELECT%"=="H" CALL:HOST_SIZE
IF "%SELECT%"=="V" SET "$VHDX=X"&&CALL:VHDX_CHECK
IF "%SELECT%"=="O" IF DEFINED ADV_BOOT SET "ADV_BOOT="&&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_BOOT SET "ADV_BOOT=1"&&SET "SELECT="
IF "%SELECT%"=="G" CALL:BOOT_CREATOR_PROMPT
GOTO:BOOT_CREATOR
:HOST_SIZE
IF "%HOST_SIZE%"=="DISABLED" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO   Creates 3 partition disk, remaining space allocated to partition 3.&&ECHO     One benefit is having an additional drive letter when used in &&ECHO   conjunction with the hide host partition option in Disk Management.&&ECHO  Should be larger than the combined maximum filled size of all VHDX's.&&ECHO.&&SET "BOX=B2"&&CALL:BOX
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                     VHDX host partition size in MB?&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=HOST_SIZE"&&CALL:PROMPT_SET
SET "SELECT=%HOST_SIZE%"&&SET "CHECK=NUM"&&CALL:CHECK
IF DEFINED ERROR SET "HOST_SIZE=DISABLED"
EXIT /B
:VHDX_CHECK
IF "%$VHDX%"=="X" SET "PICK=VHDX"&&CALL:FILE_PICK
IF NOT "%$VHDX%"=="X" SET "PICK=MAIN"&&CALL:FILE_PICK
IF NOT DEFINED $PICK SET "VHDX_SLOT%$VHDX%="&&SET "$VHDX="&&EXIT /B
SET "CHAR_STR=%$ELECT$%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK
IF DEFINED CHAR_FLG CALL:PAD_LINE&&ECHO  Remove the space from the VHDX name, then try again.&&CALL:PAD_LINE&&SET "VHDX_SLOT%$VHDX%="&&CALL:PAUSED
IF NOT DEFINED CHAR_FLG SET "VHDX_SLOT%$VHDX%=%$ELECT$%"
SET "$VHDX="
EXIT /B
:APPLY_IMAGE
IF NOT DEFINED IMAGEFILE EXIT /B
IF NOT DEFINED APPLYDIR SET "APPLYDIR=V:"
IF NOT DEFINED IMAGEINDEX SET "IMAGEINDEX=1"
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%IMAGEFILE%" /INDEX:%IMAGEINDEX% /APPLYDIR:"%APPLYDIR%"&ECHO.&SET "IMAGEFILE="
EXIT /B
:CAPTURE_IMAGE
IF NOT DEFINED IMAGEFILE EXIT /B
IF NOT DEFINED CAPTUREDIR SET "CAPTUREDIR=V:"
DISM /ENGLISH /CAPTURE-IMAGE /IMAGEFILE:"%IMAGEFILE%" /CAPTUREDIR:"%CAPTUREDIR%" /NAME:NAME /CheckIntegrity /Verify /Bootable&ECHO.&SET "IMAGEFILE="
EXIT /B
:FIND_INDEX
IF NOT DEFINED IMAGEFILE EXIT /B
SET "IMAGEINDEX="&&CALL SET /A "INDEX_TMP+=1"
DISM /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"%IMAGEFILE%" /INDEX:%INDEX_TMP%>$DISM
FOR /F "TOKENS=5 SKIP=5 DELIMS=<> " %%a in ($DISM) DO (IF "%%a"=="%INDEX_WORD%" SET "IMAGEINDEX=%INDEX_TMP%"&&GOTO:FIND_INDEX_BREAK)
IF NOT DEFINED IMAGEINDEX IF NOT "%INDEX_TMP%" EQU "20" GOTO:FIND_INDEX
:FIND_INDEX_BREAK
SET "IMAGEFILE="&&SET "INDEX_TMP="&&SET "INDEX_WORD="&&DEL /Q /F "$DISM">NUL 2>&1
EXIT /B
:EFI_FETCH
IF EXIST "%BOOT_FOLDER%\boot.sdi" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO          File boot.sdi already exists. Press (%##%X%#$%) to overwrite.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF EXIST "%BOOT_FOLDER%\boot.sdi" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%BOOT_FOLDER%\bootmgfw.efi" CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO        File bootmgfw.efi already exists. Press (%##%X%#$%) to overwrite.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF EXIST "%BOOT_FOLDER%\bootmgfw.efi" IF NOT "%CONFIRM%"=="X" EXIT /B
CALL:PAD_LINE&&ECHO        Extracting boot-media. Using boot.sav located in folder...&&CALL:PAD_LINE&&CALL:VTEMP_CREATE
SET "IMAGEFILE=%BOOT_FOLDER%\boot.sav"&&SET "INDEX_WORD=Setup"&&CALL:FIND_INDEX&&SET "IMAGEFILE=%BOOT_FOLDER%\boot.sav"&&CALL:APPLY_IMAGE
IF EXIST "%APPLYDIR%\Windows\Boot\DVD\EFI\boot.sdi" CALL:PAD_LINE&&ECHO               File boot.sdi was found. Copying to folder.&&COPY /Y "%APPLYDIR%\Windows\Boot\DVD\EFI\boot.sdi" "%BOOT_FOLDER%">NUL 2>&1
IF EXIST "%APPLYDIR%\Windows\Boot\EFI\bootmgfw.efi" CALL:PAD_LINE&&ECHO              File bootmgfw.efi was found. Copying to folder.&&COPY /Y "%APPLYDIR%\Windows\Boot\EFI\bootmgfw.efi" "%BOOT_FOLDER%">NUL 2>&1
CALL:PAD_LINE&&CALL:VTEMP_DELETE
EXIT /B
:BOOT_CREATOR_PROMPT
CLS&&CALL:PAD_LINE&&ECHO                          Select a disk to erase&&CALL:PAD_LINE&&CALL:DISK_MENU
IF DEFINED DISK_CONFLICT SET "ERROR="
IF NOT DEFINED ERROR SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                   %XLR2%Are your sure?%#$% Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF NOT "%CONFIRM%"=="X" SET "ERROR=1"
IF DEFINED ERROR EXIT /B
IF DEFINED DISK_CONFLICT CALL:PAD_LINE&&ECHO                           Converting to GPT..&&SET "DISK_NUMBER=%SELECT%"&&CALL:DISKMGR_ERASE&&CALL:DISK_QUERY>NUL 2>&1
IF DEFINED DISK_CONFLICT SET "DISK_CONFLICT="&&FOR %%a in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15) DO (IF "%SELECT%"=="%%a" CALL SET "DISK_TARGET=%%DISKID_%%a%%"&&CALL:PAD_LINE&&CALL ECHO             New UID: %#@%%%DISKID_%%a%%%#$%&&CALL ECHO.%%DISKID_%%a%%>"%TEMP%\DISK_TARGET")
IF EXIST "%TEMP%\DISK_TARGET" CALL:BOOT_CREATOR_START&CALL:PAUSED
EXIT /B
::#########################################################################
:BOOT_CREATOR_START
::#########################################################################
IF EXIST "%BOOT_FOLDER%\boot.sav" (SET "BOOT_IMAGE=%BOOT_FOLDER%\boot.sav") ELSE (SET "BOOT_IMAGE=")
SET "BOOT_MSG="&&SET "DISK_MSG="&&SET "PART_XNT="&&SET "PART_ERR="&&SET "BOOT_ABT="&&DISM /cleanup-MountPoints>NUL 2>&1
IF NOT "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "S:\" IF NOT EXIST "T:\" IF NOT EXIST "U:\" IF NOT EXIST "V:\" SET "BOOT_GO=1"
IF NOT "%PROG_MODE%"=="RAMDISK" IF NOT DEFINED BOOT_GO SET "BOOT_MSG=%##%Drive letters S:\,T:\,U:\,V:\ can NOT be in use. Reassign/Unmount the letter in use.%#$%"&&GOTO:BOOT_ABT
SET "CHAR_STR=%VHDX_SLOTX%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK
IF DEFINED CHAR_FLG SET "BOOT_MSG=%##%Remove the space from the VHDX name, then try again.%#$%"&&GOTO:BOOT_ABT
CALL:PAD_LINE&&ECHO                           Boot Creator Start&&CALL:PAD_LINE
IF "%PROG_MODE%"=="RAMDISK" SET "BOOT_IMAGE="&&SET /P DISK_TARGET=<"%PROG_FOLDER%\DISK_TARGET"&&CALL:DISK_QUERY>NUL 2>&1
IF "%PROG_MODE%"=="RAMDISK" SET "EFI_LTR=Q"&&CALL:EFI_MOUNT&&SET "SET_LETTER=R"&&CALL:HOST_REASSIGN
IF "%PROG_MODE%"=="RAMDISK" IF EXIST "R:\$\BOOT.SAV" SET "BOOT_IMAGE=R:\$\BOOT.SAV"&&SET "BOOT_FOLDER=R:\$"
IF "%PROG_MODE%"=="RAMDISK" IF EXIST "R:\$\BOOT\BOOT.SAV" SET "BOOT_IMAGE=R:\$\BOOT\BOOT.SAV"&&SET "BOOT_FOLDER=R:\$\BOOT"
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%BOOT_IMAGE%" SET "BOOT_MSG=%##%No boot-media detected.%#$%"&&GOTO:BOOT_CLEANUP
ECHO                           Creating partitions...&&CALL:PAD_LINE
SET /P DISK_TARGET=<"%TEMP%\DISK_TARGET"&&CALL:DISK_QUERY>NUL 2>&1
IF DEFINED DISK_NUMBER CALL:PART_CREATE
IF DEFINED UID_FAIL SET "DISK_TARGET=%GET_DISK_ID%"&&CALL:DISK_QUERY>NUL 2>&1
SET "BOOT_MSG0=%##%Disk is currently in use - unplug disk and/or reboot, then try again.%#$%"
IF DEFINED PART_ERR SET "BOOT_MSG=%BOOT_MSG0%"&&SET "BOOT_ABT=1"&&GOTO:BOOT_CLEANUP
FOR %%a in (S U) DO (IF NOT EXIST "%%a:\" SET "BOOT_MSG=%BOOT_MSG0%"&&SET "BOOT_ABT=1"&&GOTO:BOOT_CLEANUP)
SET "SCRATCHDIR=S:\$\Scratch"&&CALL:SCRATCH_CREATE
SET "VDISK=%SCRATCHDIR%\Scratch.vhdx"&&CALL:VDISK_CREATE
IF EXIST "%BOOT_FOLDER%\BOOT.SAV" ECHO        Extracting boot-media. Using boot.sav located in folder...&&CALL:PAD_LINE&&COPY /Y "%BOOT_FOLDER%\boot.sav" "S:\$\boot.wim">NUL 2>&1
SET "IMAGEFILE=S:\$\boot.wim"&&SET "INDEX_WORD=Setup"&&CALL:FIND_INDEX&&CALL:TITLECARD
MOVE /Y "S:\$\boot.wim" "S:\$\boot.sav">NUL 2>&1
SET "IMAGEFILE=S:\$\boot.sav"&&CALL:APPLY_IMAGE&&CALL:PAD_LINE
IF NOT EXIST "V:\Windows" SET "BOOT_MSG=%##%Mount failure, Index %IMAGEINDEX%%#$%" &&GOTO:BOOT_CLEANUP
MD "%APPLYDIR%\$">NUL 2>&1
COPY /Y "%TEMP%\DISK_TARGET" "%APPLYDIR%\$">NUL
IF "%PROG_MODE%"=="RAMDISK" COPY /Y "R:\$\windick.cmd" "%APPLYDIR%\$">NUL&COPY /Y "R:\$\windick.cmd" "S:\$">NUL&COPY /Y "R:\$\settings.ini" "S:\$">NUL
IF NOT "%PROG_MODE%"=="RAMDISK" COPY /Y "%PROG_SOURCE%\windick.cmd" "%APPLYDIR%\$">NUL&COPY /Y "%PROG_SOURCE%\windick.cmd" "S:\$">NUL&COPY /Y "%PROG_SOURCE%\settings.ini" "S:\$">NUL
FOR %%a in (Boot EFI\Boot EFI\Microsoft\Boot) DO (MD U:\%%a>NUL 2>&1)
IF EXIST "%BOOT_FOLDER%\boot.sdi" ECHO                    Using boot.sdi located in folder.&&CALL:PAD_LINE&&COPY /Y "%BOOT_FOLDER%\boot.sdi" "U:\Boot">NUL&&COPY /Y "%BOOT_FOLDER%\boot.sdi" "S:\$">NUL
IF NOT EXIST "%BOOT_FOLDER%\boot.sdi" COPY /Y "%APPLYDIR%\Windows\Boot\DVD\EFI\boot.sdi" "U:\Boot">NUL 2>&1
IF NOT EXIST "U:\Boot\boot.sdi" SET "BOOT_MSG=%##%boot.sdi missing%#$%"&&GOTO:BOOT_CLEANUP
IF EXIST "%BOOT_FOLDER%\bootmgfw.efi" ECHO                  Using bootmgfw.efi located in folder.&&CALL:PAD_LINE&&COPY /Y "%BOOT_FOLDER%\bootmgfw.efi" "U:\EFI\Boot\bootx64.efi">NUL&&COPY /Y "%BOOT_FOLDER%\bootmgfw.efi" "S:\$">NUL
IF NOT EXIST "%BOOT_FOLDER%\bootmgfw.efi" COPY /Y "%APPLYDIR%\Windows\Boot\EFI\bootmgfw.efi" "U:\EFI\Boot\bootx64.efi">NUL 2>&1
IF NOT EXIST "U:\EFI\Boot\bootx64.efi" SET "BOOT_MSG=%##%bootmgfw.efi missing%#$%"&&GOTO:BOOT_CLEANUP
IF EXIST "%APPLYDIR%\setup.exe" DEL /Q /F "\\?\%APPLYDIR%\setup.exe">NUL 2>&1
IF EXIST "%APPLYDIR%\$\RECOVERY_LOCK" DEL /Q /F "\\?\%APPLYDIR%\$\RECOVERY_LOCK">NUL 2>&1
COPY /Y "%APPLYDIR%\Windows\System32\config\ELAM" "%TEMP%\BCD">NUL 2>&1
::ECHO "%%SYSTEMDRIVE%%\$\WINDICK.CMD">"%APPLYDIR%\WINDOWS\SYSTEM32\STARTNET.CMD"
(ECHO.[LaunchApp]&&ECHO.AppPath=X:\$\windick.cmd)>"%APPLYDIR%\Windows\System32\winpeshl.ini"
SET "VHDX_SLOTZ=%VHDX_SLOT0%"
SET "VHDX_SLOT0=%VHDX_SLOTX%"&&CALL:BCD_CREATE>NUL 2>&1
SET "VHDX_SLOT0=%VHDX_SLOTZ%"
SET "VHDX_SLOTZ="&&IF NOT EXIST "U:\EFI\Microsoft\Boot\BCD" SET "BOOT_MSG=%##%BCD missing%#$%"&&GOTO:BOOT_CLEANUP
REM DISM /IMAGE:"%APPLYDIR%" /SET-SCRATCHSPACE:512 >NUL 2>&1
ECHO                            Saving boot-media...&&CALL:PAD_LINE&&CALL:TITLECARD
SET "IMAGEFILE=U:\$.WIM"&&CALL:CAPTURE_IMAGE
:BOOT_CLEANUP
CALL:PAD_LINE&&ECHO                             Unmounting EFI...&&CALL:PAD_LINE&&CALL:TITLECARD
SET "VDISK=%SCRATCHDIR%\SCRATCH.VHDX"&&CALL:VDISK_DETACH&&CALL:SCRATCH_DELETE&&CALL:EFI_UNMOUNT
IF EXIST "U:\" ECHO %#@%EFI partition [U] still mounted, unplug disk to dismount EFI partition.%#$%&&CALL:PAD_LINE
IF NOT "%PROG_MODE%"=="RAMDISK" SET "PATH_TEMP=%IMAGE_FOLDER%"
IF "%PROG_MODE%"=="RAMDISK" FOR %%G in ("%IMAGE_FOLDER%") DO (SET "PATH_TEMP=R:%%~pG%%~nG")
IF EXIST "%PATH_TEMP%\%VHDX_SLOTX%" IF EXIST "S:\$" ECHO  Copying %#@%%VHDX_SLOTX%%#$%...&&COPY /Y "%PATH_TEMP%\%VHDX_SLOTX%" "S:\$">NUL 2>&1
IF NOT EXIST "%PATH_TEMP%\%VHDX_SLOTX%" ECHO  No VHDX was selected. You can modify the boot menu while booted into recovery.
IF EXIST "S:\" CALL:HOST_REASSIGN>NUL 2>&1
IF NOT "%HOST_SIZE%"=="DISABLED" CALL:XTRA_REASSIGN>NUL 2>&1
:BOOT_ABT
IF "%PROG_MODE%"=="RAMDISK" CALL:HOST_AUTO>NUL 2>&1
IF "%PROG_MODE%"=="RAMDISK" SET "EFI_LTR=Q"&&CALL:EFI_UNMOUNT
IF "%PROG_MODE%"=="RAMDISK" IF EXIST "Q:\" ECHO %#@%EFI partition [Q] still mounted, unplug disk to dismount EFI partition.%#$%&&CALL:PAD_LINE
SET "PATH_TEMP="&&IF EXIST "%TEMP%\DISK_TARGET" DEL /Q /F "%TEMP%\DISK_TARGET">NUL 2>&1
SET "BOOT_GO="&&SET "BOOT_MSG0="&&IF DEFINED BOOT_MSG ECHO  %BOOT_MSG%&&SET "BOOT_MSG="
CALL:DEL_DSK&&CALL:PAD_LINE&&ECHO                           Boot Creator Finish&&CALL:PAD_LINE
EXIT /B
:BCD_CREATE
SET "BCD_KEY=BCD00000001"&&SET "BCD_FILE=%TEMP%\0020"&&IF EXIST "%TEMP%\BCD1" DEL /F "%TEMP%\BCD1">NUL
IF EXIST "%BCD_FILE%" DEL /Q /F "%BCD_FILE%">NUL 2>&1
IF NOT DEFINED BOOT_TIMEOUT SET "BOOT_TIMEOUT=5"
BCDEDIT.EXE /createstore "%BCD_FILE%"
BCDEDIT.EXE /STORE "%BCD_FILE%" /create {bootmgr}
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET {bootmgr} description "Boot Manager"
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET {bootmgr} device boot
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET {bootmgr} timeout %BOOT_TIMEOUT%
FOR /f "TOKENS=2 DELIMS={}" %%a in ('BCDEDIT.EXE /STORE "%BCD_FILE%" /create /device') do SET "RAMDISK={%%a}"
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %RAMDISK% ramdisksdidevice boot
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %RAMDISK% ramdisksdipath \boot\boot.sdi
FOR /f "TOKENS=2 DELIMS={}" %%a in ('BCDEDIT.EXE /STORE "%BCD_FILE%" /create /application osloader') do SET "BCD_GUID={%%a}"
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% systemroot \Windows
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% detecthal Yes
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% winpe Yes
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% osdevice ramdisk=[boot]\$.WIM,%RAMDISK%
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% device ramdisk=[boot]\$.WIM,%RAMDISK%
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% path \windows\system32\winload.efi
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% description "WINDICK"
BCDEDIT.EXE /STORE "%BCD_FILE%" /displayorder %BCD_GUID% /addlast
FOR %%a in (9 8 7 6 5 4 3 2 1 0) DO (CALL SET "BCD_NAME=%%VHDX_SLOT%%a%%"&&CALL:BCD_VHDX)
REG UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
REG LOAD HKLM\%BCD_KEY% "%BCD_FILE%">NUL 2>&1
REG EXPORT HKLM\%BCD_KEY% "%TEMP%\BCD1"
REG UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
SET "BCD_FILE=%TEMP%\BCD"&&IF NOT EXIST "%TEMP%\BCD" COPY /Y "%WINDIR%\System32\config\ELAM" "%TEMP%\BCD">NUL 2>&1
REG LOAD HKLM\%BCD_KEY% "%BCD_FILE%">NUL 2>&1
REG IMPORT "%TEMP%\BCD1" >NUL 2>&1
REG.exe add "HKLM\%BCD_KEY%\Description" /v "KeyName" /t REG_SZ /d "%BCD_KEY%" /f>NUL 2>&1
REG.exe add "HKLM\%BCD_KEY%\Description" /v "System" /t REG_DWORD /d "1" /f>NUL 2>&1
REG.exe add "HKLM\%BCD_KEY%\Description" /v "TreatAsSystem" /t REG_DWORD /d "1" /f>NUL 2>&1
REG.exe delete "HKLM\%BCD_KEY%" /v "FirmwareModified" /f>NUL 2>&1
REG UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
COPY /Y "%BCD_FILE%" "U:\EFI\Microsoft\Boot\BCD">NUL 2>&1
DEL /Q /F "%TEMP%\BCD1"&&DEL /Q /F "%TEMP%\0020"&&DEL /Q /F "%BCD_FILE%"
SET "BCD_GUID="&&SET "BCD_FILE="&&SET "BCD_KEY="&&SET "BCD_NAME="&&EXIT /B
:BCD_VHDX
IF NOT DEFINED BCD_NAME EXIT /B
IF "%BCD_NAME%"=="SELECT" EXIT /B
FOR /f "TOKENS=3" %%a in ('BCDEDIT.EXE /STORE "%BCD_FILE%" /create /application osloader') do SET "BCD_GUID=%%a"
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% device vhd=[locate]\$\%BCD_NAME%
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% path \Windows\SYSTEM32\winload.efi
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% osdevice vhd=[locate]\$\%BCD_NAME%
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% systemroot \Windows
BCDEDIT.EXE /STORE "%BCD_FILE%" /SET %BCD_GUID% description "%BCD_NAME%"
BCDEDIT.EXE /STORE "%BCD_FILE%" /displayorder %BCD_GUID% /addfirst
EXIT /B
:BCD_REBUILD
CALL:PAD_LINE&&ECHO  Saving Boot Menu...&&CALL:PAD_LINE&&CALL:EFI_MOUNT&&CALL:BCD_CREATE>NUL 2>&1
CALL:EFI_UNMOUNT&&ECHO  Done.&&CALL:PAD_LINE
EXIT /B
:UPDATE_RECOVERY
SET "ERROR="&&CALL:HOST_AUTO&&CLS&&CALL:PAD_LINE&&ECHO                            Recovery Update&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%1%#$%) Program&&ECHO  (%##%2%#$%) Recovery Password&&ECHO  (%##%3%#$%) Boot Media&&ECHO  (%##%4%#$%) EFI Files&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE
ECHO                         Select a (%##%#%#$%) to update&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="1" CALL:CONFIRMX&&CALL:UPDATE_PROG
IF "%SELECT%"=="2" CALL:CONFIRMX&&CALL:UPDATE_PASS
IF "%SELECT%"=="3" CALL:CONFIRMX&&CALL:UPDATE_BOOT
IF "%SELECT%"=="4" CALL:CONFIRMX&&CALL:UPDATE_EFI
IF EXIST "%PROG_FOLDER%\$TMP" DEL /F "%PROG_FOLDER%\$TMP">NUL 2>&1
IF EXIST "%BOOT_FOLDER%\$TMP.WIM" DEL /F "%BOOT_FOLDER%\$TMP.WIM">NUL 2>&1
GOTO:UPDATE_RECOVERY
:UPDATE_PROG
IF DEFINED ERROR EXIT /B
IF NOT EXIST "%PROG_SOURCE%\windick.cmd" CALL:PAD_LINE&&ECHO File windick.cmd is not located in folder, aborting.&&CALL:PAD_LINE&&CALL:PAUSED&EXIT /B
CALL:PAD_LINE&&CALL:WARNING_1&&CALL:VTEMP_CREATE
IF DEFINED ERROR ECHO %ERROR%&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:PAUSED&EXIT /B
ECHO                          Extracting boot-media...&&CALL:PAD_LINE&&CALL:EFI_MOUNT
IF NOT EXIST "U:\EFI" ECHO ERROR: EFI MOUNT&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:EFI_UNMOUNT&&CALL:PAUSED&EXIT /B
COPY /Y "U:\$.WIM" "%BOOT_FOLDER%\$TMP.WIM">NUL 2>&1
SET "IMAGEFILE=%BOOT_FOLDER%\$TMP.WIM"&&CALL:APPLY_IMAGE&&CALL:PAD_LINE
IF NOT EXIST "%APPLYDIR%\Windows" ECHO ERROR: BOOT MEDIA&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:EFI_UNMOUNT&&CALL:PAUSED&EXIT /B
ECHO                   Using windick.cmd located in folder.&&CALL:PAD_LINE
COPY /Y "%PROG_SOURCE%\windick.cmd" "%APPLYDIR%\$">NUL&&COPY /Y "%PROG_SOURCE%\windick.cmd" "%PROG_FOLDER%\update.cmd">NUL
ECHO                            Saving boot-media...&&CALL:PAD_LINE&&DEL /Q /F "U:\$.WIM">NUL 2>&1
SET "IMAGEFILE=U:\$.WIM"&&CALL:CAPTURE_IMAGE&&CALL:PAD_LINE
ECHO                             Unmounting EFI...&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:EFI_UNMOUNT&&CALL:PAUSED
EXIT /B
:UPDATE_PASS
IF DEFINED ERROR EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO       %XLR2%Important:%#$% Do not use any of these symbols [%XLR2% ^< ^> %% ^^! ^& ^^^^ %#$%].&&ECHO     These can break the password login to the recovery environment.&&ECHO.&&ECHO        Enter new recovery password or press (%##%Enter%#$%) to remove.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&SET "PROMPT_SET=RECOVERY_LOCK"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
CALL:PAD_LINE&&CALL:WARNING_1&&CALL:VTEMP_CREATE
IF DEFINED ERROR SET "RECOVERY_LOCK="&&ECHO %ERROR%&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:PAUSED&EXIT /B
ECHO                          Extracting boot-media...&&CALL:PAD_LINE&&CALL:EFI_MOUNT
IF NOT EXIST "U:\EFI" SET "RECOVERY_LOCK="&&ECHO ERROR: EFI MOUNT&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:EFI_UNMOUNT&&CALL:PAUSED&EXIT /B
COPY /Y "U:\$.WIM" "%BOOT_FOLDER%\$TMP.WIM">NUL 2>&1
SET "IMAGEFILE=%BOOT_FOLDER%\$TMP.WIM"&&CALL:APPLY_IMAGE&&CALL:PAD_LINE
IF NOT EXIST "%APPLYDIR%\Windows" SET "RECOVERY_LOCK="&&ECHO ERROR: BOOT MEDIA&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:EFI_UNMOUNT&&CALL:PAUSED&EXIT /B
IF DEFINED RECOVERY_LOCK ECHO.%RECOVERY_LOCK%>"%PROG_FOLDER%\$TMP"
IF DEFINED RECOVERY_LOCK SET /P RECOVERY_LOCK=<"%PROG_FOLDER%\$TMP"
IF DEFINED RECOVERY_LOCK ECHO. Password changed to [%#@%%RECOVERY_LOCK%%#$%].&&CALL:PAD_LINE
IF NOT DEFINED RECOVERY_LOCK ECHO.                  Recovery password has been removed.&&CALL:PAD_LINE
IF DEFINED RECOVERY_LOCK ECHO.%RECOVERY_LOCK%>"%APPLYDIR%\$\RECOVERY_LOCK"
IF DEFINED RECOVERY_LOCK ECHO.%RECOVERY_LOCK%>"%PROG_FOLDER%\RECOVERY_LOCK"
IF NOT DEFINED RECOVERY_LOCK DEL /Q /F "\\?\%APPLYDIR%\$\RECOVERY_LOCK">NUL 2>&1
IF NOT DEFINED RECOVERY_LOCK DEL /Q /F "\\?\%PROG_FOLDER%\RECOVERY_LOCK">NUL 2>&1
ECHO                            Saving boot-media...&&CALL:PAD_LINE&&DEL /Q /F "U:\$.WIM">NUL 2>&1
SET "IMAGEFILE=U:\$.WIM"&&CALL:CAPTURE_IMAGE&&CALL:PAD_LINE
SET "RECOVERY_LOCK="&&ECHO                             Unmounting EFI...&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:EFI_UNMOUNT&&CALL:PAUSED
EXIT /B
:UPDATE_BOOT
IF DEFINED ERROR EXIT /B
IF NOT EXIST "%BOOT_FOLDER%\boot.sav" CALL:BOOT_FETCH&EXIT /B
IF NOT EXIST "%BOOT_FOLDER%\boot.sav" CALL:PAD_LINE&&ECHO File boot.sav is not located in folder, aborting.&&CALL:PAD_LINE&&CALL:PAUSED&EXIT /B
CALL:PAD_LINE&&CALL:WARNING_1&&CALL:VTEMP_CREATE
IF DEFINED ERROR ECHO %ERROR%&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:PAUSED&EXIT /B
ECHO                          Extracting boot-media...&&CALL:PAD_LINE&&COPY /Y "%BOOT_FOLDER%\boot.sav" "%BOOT_FOLDER%\$TMP.WIM">NUL 2>&1
ECHO                     Using boot.sav located in folder.&&CALL:PAD_LINE
SET "INDEX_WORD=Setup"&&SET "IMAGEFILE=%BOOT_FOLDER%\$TMP.WIM"&&CALL:FIND_INDEX
SET "IMAGEFILE=%BOOT_FOLDER%\$TMP.WIM"&&CALL:APPLY_IMAGE&&CALL:PAD_LINE
IF NOT EXIST "%APPLYDIR%\Windows" ECHO ERROR: BOOT MEDIA&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:PAUSED&EXIT /B
MD "%APPLYDIR%\$">NUL 2>&1
COPY /Y "%PROG_FOLDER%\DISK_TARGET" "%APPLYDIR%\$">NUL&&COPY /Y "%PROG_FOLDER%\windick.cmd" "%APPLYDIR%\$">NUL
IF EXIST "%PROG_FOLDER%\update.cmd" COPY /Y "%PROG_FOLDER%\update.cmd" "%APPLYDIR%\$\windick.cmd">NUL
IF EXIST "%PROG_FOLDER%\RECOVERY_LOCK" COPY /Y "%PROG_FOLDER%\RECOVERY_LOCK" "%APPLYDIR%\$">NUL
IF NOT EXIST "%PROG_FOLDER%\RECOVERY_LOCK" DEL /Q /F "\\?\%APPLYDIR%\$\RECOVERY_LOCK">NUL 2>&1
IF EXIST "%APPLYDIR%\setup.exe" DEL /Q /F "\\?\%APPLYDIR%\setup.exe">NUL 2>&1
(ECHO.[LaunchApp]&&ECHO.AppPath=X:\$\windick.cmd)>"%APPLYDIR%\Windows\System32\winpeshl.ini"
CALL:EFI_MOUNT
IF NOT EXIST "U:\EFI" ECHO ERROR: EFI MOUNT&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:EFI_UNMOUNT&&CALL:PAUSED&EXIT /B
ECHO                            Saving boot-media...&&CALL:PAD_LINE&&DEL /Q /F "U:\$.WIM">NUL 2>&1
SET "IMAGEFILE=U:\$.WIM"&&CALL:CAPTURE_IMAGE
CALL:PAD_LINE&&ECHO                             Unmounting EFI...&&CALL:PAD_LINE&&CALL:VTEMP_DELETE&&CALL:EFI_UNMOUNT&&CALL:PAUSED
EXIT /B
:UPDATE_EFI
IF DEFINED ERROR EXIT /B
IF NOT EXIST "%BOOT_FOLDER%\boot.sdi" IF NOT EXIST "%BOOT_FOLDER%\bootmgfw.efi" CALL:PAD_LINE&&ECHO Files boot.sdi and bootmgfw.efi are not located in folder, aborting.&&CALL:PAD_LINE&&CALL:PAUSED&EXIT /B
CALL:PAD_LINE&&CALL:WARNING_1&&CALL:EFI_MOUNT
IF NOT EXIST "U:\EFI" ECHO ERROR: EFI MOUNT&&CALL:PAD_LINE&&CALL:EFI_UNMOUNT&&CALL:PAUSED&EXIT /B
IF EXIST "%BOOT_FOLDER%\boot.sdi" ECHO                     Using boot.sdi located in folder.&&CALL:PAD_LINE&&COPY /Y "%BOOT_FOLDER%\boot.sdi" "U:\Boot">NUL
IF EXIST "%BOOT_FOLDER%\bootmgfw.efi" ECHO                   Using bootmgfw.efi located in folder.&&CALL:PAD_LINE&&COPY /Y "%BOOT_FOLDER%\bootmgfw.efi" "U:\EFI\Boot\bootx64.efi">NUL
IF NOT EXIST "%BOOT_FOLDER%\boot.sdi" ECHO            File boot.sdi is not located in folder, skipping.&&CALL:PAD_LINE
IF NOT EXIST "%BOOT_FOLDER%\bootmgfw.efi" ECHO          File bootmgfw.efi is not located in folder, skipping.&&CALL:PAD_LINE
ECHO                             Unmounting EFI...&&CALL:PAD_LINE&&CALL:EFI_UNMOUNT&&CALL:PAUSED
EXIT /B
:WARNING_1
ECHO   %XLR2%Caution:%#$% Interrupting this process can render the disk unbootable.&&CALL:PAD_LINE
EXIT /B
:CONFIRMX
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                   Are your sure? Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF NOT "%CONFIRM%"=="X" SET "ERROR=1"
EXIT /B
:VTEMP_CREATE
IF DEFINED ERROR EXIT /B
IF EXIST "V:\" SET "ERROR=                   Drive letter V:\ cannot be in use."&&EXIT /B
CALL:SCRATCH_CREATE
SET "VDISK=%SCRATCHDIR%\SCRATCH.VHDX"&&CALL:VDISK_CREATE
IF NOT EXIST "V:\" SET "ERROR=                  Drive letter V:\ could not be found."
IF DEFINED ERROR CALL:VTEMP_DELETE
EXIT /B
:VTEMP_DELETE
SET "VDISK=%SCRATCHDIR%\SCRATCH.VHDX"&&CALL:VDISK_DETACH
CALL:SCRATCH_DELETE
EXIT /B
::#########################################################################
:PACKAGE_CREATOR
::#########################################################################
@ECHO OFF&&CLS&&CALL:SETS_HANDLER&&CALL:TITLE_X&&CALL:SCRATCH_PACK_DELETE&&CALL:PAD_LINE&&ECHO                             Package Creator&&CALL:PAD_LINE
FOR %%a in (PackName PackType PackTag PackDesc) DO (CALL SET "%%a=NULL")
IF EXIST "%MAKER_FOLDER%\PACKAGE.MAN" COPY /Y "%MAKER_FOLDER%\PACKAGE.MAN" "$PAK">NUL&&FOR /F "eol=- TOKENS=1-2 DELIMS==" %%a in ($PAK) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
IF EXIST "$PAK" DEL /F "$PAK">NUL
ECHO  Name: %#@%%PackName%%#$%  Type: %#@%%PackType%%#$%  Tag: %#@%%PackTag%%#$%  x-Lvl: %#@%%PACK_XLVL%%#$%&&CALL:PAD_LINE&&ECHO  Desc: %#@%%PackDesc%%#$%&&CALL:PAD_LINE&&ECHO   %#@%PACKAGE CONTENTS:%#$%&&SET "BLIST=MAK"&&CALL:FILE_LIST&&CALL:PAD_LINE
IF "%PackType%"=="NULL" ECHO  (%##%X%#$%)Project %#@%%MAKER_SLOT%%#$%  (%##%N%#$%)ew  (%##%R%#$%)estore  (%##%I%#$%)nspect System  (%##%D%#$%)river Export&&CALL:PAD_LINE
IF "%PackType%"=="DRIVER" ECHO  (%##%X%#$%)Project %#@%%MAKER_SLOT%%#$% (%##%N%#$%)ew (%##%C%#$%)reate (%##%R%#$%)estore (%##%E%#$%)dit (%##%Z%#$%)x-Lvl (%##%D%#$%)river Export&&CALL:PAD_LINE
IF "%PackType%"=="SCRIPTED" ECHO  (%##%X%#$%)Project %#@%%MAKER_SLOT%%#$%   (%##%N%#$%)ew   (%##%C%#$%)reate   (%##%R%#$%)estore   (%##%E%#$%)dit   (%##%Z%#$%)x-Lvl&&CALL:PAD_LINE
IF "%PackType%"=="AIOPACK" ECHO  (%##%X%#$%)Project %#@%%MAKER_SLOT%%#$%   (%##%N%#$%)ew   (%##%C%#$%)reate   (%##%R%#$%)estore   (%##%E%#$%)dit   (%##%Z%#$%)x-Lvl&&CALL:PAD_LINE
IF NOT "%PackType%"=="NULL" IF NOT "%PackType%"=="DRIVER" IF NOT "%PackType%"=="SCRIPTED" IF NOT "%PackType%"=="AIOPACK" ECHO  (%##%X%#$%)Project %MAKER_SLOT%    %XLR2%PackType error%#$%   (%##%N%#$%)ew   (%##%R%#$%)estore   (%##%E%#$%)dit&&CALL:PAD_LINE
CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="Z" CALL:PACK_XLVL&&SET "SELECT="
IF "%SELECT%"=="N" CALL:PACK_MENU&&SET "SELECT="
IF "%SELECT%"=="R" CALL:PACKAGE_RESTORE_CHOICE&&SET "SELECT="
IF "%SELECT%"=="C" IF NOT "%PackType%"=="NULL" CALL:PACKAGE_CREATE&&SET "SELECT="
IF "%SELECT%"=="D" IF NOT "%PackType%"=="SCRIPTED" IF NOT "%PackType%"=="AIOPACK" CALL:DRIVER_EXPORT&&SET "SELECT="
IF "%SELECT%"=="I" IF NOT "%PackType%"=="SCRIPTED" IF NOT "%PackType%"=="AIOPACK" CALL:PACKAGE_INSPECT&&SET "SELECT="
IF "%SELECT%"=="E" SET "EDIT_SETUP=1"&&SET "EDIT_MANIFEST=1"&&SET "EDIT_README=1"&&SET "EDIT_LIST=1"&&SET "EDIT_CUSTOM="&&CALL:PACKAGE_EDITOR
IF "%SELECT%"=="X" SET /A "MAKER_SLOT+=1"&&IF "%MAKER_SLOT%" GEQ "5" SET "MAKER_SLOT=1"
IF "%SELECT%"=="X" SET "MAKER_FOLDER=%PROG_SOURCE%\Project%MAKER_SLOT%"
GOTO:PACKAGE_CREATOR
:DRIVER_EXPORT
SET "PackType=DRIVER"&&IF "%PackName%"=="NULL" SET "PackName=DRIVER_%RANDOM%"
IF NOT EXIST "%MAKER_FOLDER%" MD "%MAKER_FOLDER%">NUL 2>&1
CALL:PAD_LINE&&ECHO                        Exporting System Drivers&&CALL:PAD_LINE&&DISM /ENGLISH /ONLINE /EXPORT-DRIVER /destination:"%MAKER_FOLDER%"&&CALL:PACK_MANIFEST
CALL:PAD_LINE&&ECHO                            Driver Export End&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PACKAGE_INSPECT
CALL:PAD_LINE&&ECHO                          Driver Inspect Start&&CALL:PAD_LINE&&DISM /ENGLISH /ONLINE /GET-DRIVERS&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PACKAGE_RESTORE_CHOICE
CLS&&IF EXIST "%PACK_FOLDER%\*.PKG" IF NOT EXIST "%PACK_FOLDER%\*.PKX" SET "MAKER_RESTORE=1"&&GOTO:PACKAGE_RESTORE_SKIP
IF EXIST "%PACK_FOLDER%\*.PKX" IF NOT EXIST "%PACK_FOLDER%\*.PKG" SET "MAKER_RESTORE=2"&&GOTO:PACKAGE_RESTORE_SKIP
CLS&&CALL:PAD_LINE&&ECHO                           Restore which type&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%1%#$%) PKG %#@%Driver/Scripted%#$%&&ECHO  (%##%2%#$%) PKX %#@%AIO Package%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&SET "PROMPT_SET=MAKER_RESTORE"&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:PROMPT_SET
:PACKAGE_RESTORE_SKIP
IF "%MAKER_RESTORE%"=="1" SET "PICK=PKG"
IF "%MAKER_RESTORE%"=="2" SET "PICK=PKX"
IF NOT "%MAKER_RESTORE%"=="1" IF NOT "%MAKER_RESTORE%"=="2" EXIT /B
CALL:FILE_PICK&&CALL:PACKAGE_RESTORE
EXIT /B
:PACKAGE_RESTORE
IF NOT DEFINED $PICK EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                    Project %#@%%MAKER_SLOT%%#$% folder will be cleared&&ECHO.&&ECHO.                         Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF NOT "%CONFIRM%"=="X" EXIT /B
CALL:PAD_LINE&&ECHO.                          Package Restore Start&&CALL:PAD_LINE&&ECHO.                            Restoring Package
CALL:SCRATCH_PACK_CREATE&&DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%$PICK%" /INDEX:2 /APPLYDIR:"%PROG_SOURCE%\ScratchPack">NUL 2>&1
FOR %%a in (PackName PackType PackDesc PackTag) DO (CALL SET "%%a=NULL")
IF EXIST "%PROG_SOURCE%\ScratchPack\PACKAGE.MAN" COPY /Y "%PROG_SOURCE%\ScratchPack\PACKAGE.MAN" "$PAK">NUL&&FOR /F "eol=- TOKENS=1-2 DELIMS==" %%a in ($PAK) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
FOR %%a in (PackName PackType PackDesc PackTag) DO (IF NOT DEFINED %%a CALL SET "%%a=NULL")
IF EXIST "$PAK" DEL /F "$PAK">NUL
IF NOT EXIST "%PROG_SOURCE%\ScratchPack\PACKAGE.MAN" CALL:PAD_LINE&&ECHO Package %##%%PackName%%#$% is defunct.&&CALL:PAD_LINE&&SET "PACK_DEFUNCT=1"&&CALL:PAUSED
IF EXIST "%MAKER_FOLDER%" RD /S /Q "%MAKER_FOLDER%">NUL 2>&1
IF NOT EXIST "%MAKER_FOLDER%" MD "%MAKER_FOLDER%">NUL 2>&1
MOVE /Y "%PROG_SOURCE%\ScratchPack\PACKAGE.MAN" "%MAKER_FOLDER%">NUL 2>&1
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%$PICK%" /INDEX:1 /APPLYDIR:"%MAKER_FOLDER%"
ECHO.&&CALL:PAD_LINE&&ECHO.                          Package Restore End&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PACKAGE_CREATE
SET "PACK_FAIL="&&CALL:PAD_LINE&&ECHO.                         Package Create Start&&CALL:PAD_LINE&&ECHO.                           Creating Package&&CALL:SCRATCH_PACK_DELETE
IF NOT EXIST "%MAKER_FOLDER%\*.*" SET "PACK_FAIL=1"&&CALL:PAD_LINE&&ECHO.%#@%Project%MAKER_SLOT% is empty%#$%&&CALL:PAD_LINE&&CALL:PAUSED
IF NOT DEFINED PackName SET "PACK_FAIL=1"&&CALL:PAD_LINE&&ECHO.PackName is Empty&&CALL:PAD_LINE&&CALL:PAUSED
IF NOT DEFINED PackType SET "PACK_FAIL=1"&&CALL:PAD_LINE&&ECHO.PackType is Empty&&CALL:PAD_LINE&&CALL:PAUSED
IF DEFINED PACK_FAIL EXIT /B
CALL:SCRATCH_PACK_CREATE&&MOVE /Y "%MAKER_FOLDER%\PACKAGE.MAN" "%PROG_SOURCE%\ScratchPack">NUL 2>&1
IF "%PackType%"=="AIOPACK" (SET "GX=x") ELSE (SET "GX=g")
DISM /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%MAKER_FOLDER%" /IMAGEFILE:"%PACK_FOLDER%\%PackName%.pk%GX%" /COMPRESS:%PACK_XLVL% /NAME:"%PackName%" /CheckIntegrity /Verify
DISM /ENGLISH /APPEND-IMAGE /IMAGEFILE:"%PACK_FOLDER%\%PackName%.pk%GX%" /CAPTUREDIR:"%PROG_SOURCE%\ScratchPack" /NAME:"%PackName%" /Description:WINDICK /CheckIntegrity /Verify>NUL 2>&1
MOVE /Y "%PROG_SOURCE%\ScratchPack\PACKAGE.MAN" "%MAKER_FOLDER%">NUL 2>&1
CALL:SCRATCH_PACK_DELETE&&ECHO.&&CALL:PAD_LINE&&ECHO.                           Package Create End&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PACKAGE_EDITOR
IF DEFINED EDIT_MANIFEST IF EXIST "%MAKER_FOLDER%\PACKAGE.MAN" START NOTEPAD.EXE "%MAKER_FOLDER%\PACKAGE.MAN"
IF DEFINED EDIT_LIST IF EXIST "%MAKER_FOLDER%\PACKAGE.LST" START NOTEPAD.EXE "%MAKER_FOLDER%\PACKAGE.LST"
IF DEFINED EDIT_SETUP IF EXIST "%MAKER_FOLDER%\PACKAGE.CMD" START NOTEPAD.EXE "%MAKER_FOLDER%\PACKAGE.CMD"
IF DEFINED EDIT_README IF EXIST "%MAKER_FOLDER%\README.TXT" START NOTEPAD.EXE "%MAKER_FOLDER%\README.TXT"
IF DEFINED EDIT_CUSTOM IF EXIST "%MAKER_FOLDER%\%EDIT_CUSTOM%" START NOTEPAD.EXE "%MAKER_FOLDER%\%EDIT_CUSTOM%"
SET "EDIT_SETUP="&&SET "EDIT_MANIFEST="&&SET "EDIT_README="&&SET "EDIT_CUSTOM="&&SET "EDIT_LIST="
EXIT /B
:PACK_XLVL
IF "%PACK_XLVL%"=="FAST" SET "PACK_XLVL=MAX"&&EXIT /B
IF "%PACK_XLVL%"=="MAX" SET "PACK_XLVL=NONE"&&EXIT /B
IF "%PACK_XLVL%"=="NONE" SET "PACK_XLVL=FAST"&&EXIT /B
EXIT /B
:PAK_LOAD
FOR %%a in (PackName PackType PackDesc PackTag) DO (CALL SET "%%a=NULL")
IF EXIST "%MAKER_FOLDER%\PACKAGE.MAN" COPY /Y "%MAKER_FOLDER%\PACKAGE.MAN" "$PAK">NUL&&FOR /F "eol=- TOKENS=1-2 DELIMS==" %%a in ($PAK) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
DEL /Q /F "$PAK">NUL 2>&1
EXIT /B
:PACK_SAVE
MOVE /Y "%MAKER_FOLDER%\PACKAGE.MAN" "$PAK">NUL&&FOR /F "eol=- TOKENS=1-2 DELIMS==" %%a in ($PAK) DO (CALL ECHO %%a=%%%%a%%>>"%MAKER_FOLDER%\PACKAGE.MAN")
DEL /Q /F "$PAK">NUL 2>&1
EXIT /B
:PACK_MANIFEST
FOR %%a in (PackName PackType PackDesc PackTag) DO (IF NOT DEFINED %%a CALL SET "%%a=NULL")
(ECHO ----------[Package Manifest]---------=&&ECHO.PackName=%PackName%&&ECHO.PackType=%PackType%&&ECHO.PackDesc=%PackDesc%&&ECHO.PackTag=%PackTag%&&ECHO.Created=%date% %time%&&ECHO ------------[END OF FILE]------------=)>"%MAKER_FOLDER%\PACKAGE.MAN"
EXIT /B
:PACK_STRT
(ECHO.::================================================&&ECHO.::These variables are built in and can help&&ECHO.::keep a script consistant throughout the entire&&ECHO.::process, whether applying to a vhdx or live.&&ECHO.::================================================&&ECHO.::Windows folder :    %%WINTAR%%&&ECHO.::Drive root :        %%DRVTAR%%&&ECHO.::User or defuser :   %%USRTAR%%&&ECHO.::HKLM\SOFTWARE :     %%HIVE_SOFTWARE%%&&ECHO.::HKLM\SYSTEM :       %%HIVE_SYSTEM%%&&ECHO.::HKCU or defuser :   %%HIVE_USER%%&&ECHO.::================================================&&ECHO.::==================START OF PACK=================&&ECHO.)>"%NEW_PACK%"
EXIT /B
:PACK_END
(ECHO.&&ECHO.::===================END OF PACK==================&&ECHO.::================================================)>>"%NEW_PACK%"
EXIT /B
:PACK_CONFIG
SET "PACK_ENT="&&FOR /F "DELIMS=" %%G in ('CMD.EXE /D /U /C ECHO %PACK_CONFIG%^| FIND /V ""') do (CALL SET /A "PACK_ENT+=1"&&SET "PACK_CFG=%%G"&&CALL:PACK_CONFIG_XNT)
EXIT /B
:PACK_CONFIG_XNT
SET "PACK_ENT_%PACK_ENT%=%PACK_CFG%"
EXIT /B
::#########################################################################
:PACK_MENU
::#########################################################################
@ECHO OFF&&CLS&&CALL:TITLE_X&&CALL:PAD_LINE&&ECHO                          New Package Template&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%N01%#$%) New Driver Package                                  [%#@%DRIVER%#$%]&&ECHO  (%##%N02%#$%) New Scripted Package                                [%#@%SCRIPTED%#$%]&&ECHO  (%##%N03%#$%) New AIO Package                                     [%#@%AIOPACK%#$%]&&CALL:PAD_LINE&&ECHO                      Time: SetupComplete/RunOnce&&CALL:PAD_LINE&&ECHO  (%##%N10%#$%) Firewall Rules Import                               [%#@%SCRIPTED%#$%]&&ECHO  (%##%N11%#$%) AutoBoot Service install                            [%#@%SCRIPTED%#$%]&&ECHO  (%##%N12%#$%) MSI Installer Example                               [%#@%SCRIPTED%#$%]&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
SET "EXAMPLE=%SELECT%"&&SET "PASS="&&FOR %%a in (N01 N02 N03 N10 N11 N12) DO (IF "%%a"=="%SELECT%" SET "PASS=1")
IF NOT "%PASS%"=="1" EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                    Project %#@%%MAKER_SLOT%%#$% folder will be cleared&&ECHO.&&ECHO.                         Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%MAKER_FOLDER%" RD /S /Q "\\?\%MAKER_FOLDER%">NUL 2>&1
IF NOT EXIST "%MAKER_FOLDER%" MD "%MAKER_FOLDER%">NUL 2>&1
SET "NEW_PACK=%MAKER_FOLDER%\PACKAGE.CMD"&&CALL:SCRATCH_PACK_DELETE&&CALL:MOUNT_NONE
FOR %%a in (PackName PackType PackDesc PackTag) DO (CALL SET "%%a=NULL")
SET "ERROR="&&CALL:%EXAMPLE%
IF DEFINED ERROR GOTO:PACKEX_END
CALL:PACK_MANIFEST>NUL 2>&1
IF "%PackType%"=="SCRIPTED" CALL:PACK_END
CALL:PACKAGE_EDITOR
FOR %%a in (AIOPACK DRIVER) DO (IF "%PackType%"=="%%a" IF EXIST "%NEW_PACK%" DEL /F "%NEW_PACK%">NUL 2>&1)
:PACKEX_END
SET "SELECT="&&CALL:SCRATCH_PACK_DELETE
EXIT /B
:SCRATCH_PACK_DELETE
SET "SCRATCH_PACK=%PROG_SOURCE%\ScratchPack"&&IF EXIST "%PROG_SOURCE%\ScratchPack" DISM /cleanup-MountPoints>NUL 2>&1
IF EXIST "%PROG_SOURCE%\ScratchPack" ATTRIB -R -S -H "%PROG_SOURCE%\ScratchPack" /S /D /L>NUL 2>&1
IF EXIST "%PROG_SOURCE%\ScratchPack" RD /S /Q "\\?\%PROG_SOURCE%\ScratchPack">NUL 2>&1
EXIT /B
:SCRATCH_PACK_CREATE
SET "SCRATCH_PACK=%PROG_SOURCE%\ScratchPack"&&IF EXIST "%PROG_SOURCE%\ScratchPack" CALL:SCRATCH_PACK_DELETE 
IF NOT EXIST "%PROG_SOURCE%\ScratchPack" MD "%PROG_SOURCE%\ScratchPack">NUL 2>&1
EXIT /B
:N01
SET "PackType=DRIVER"&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                       New Driver Pack (PKG) name&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&SET "PROMPT_SET=PackName"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED PackName SET PackName=Driver_%RANDOM%
EXIT /B
:N02
CALL:PACK_STRT&&SET "PackType=SCRIPTED"&&SET "EDIT_MANIFEST=1"&&SET "EDIT_SETUP=1"&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                      New Scripted Pack (PKG) name&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&SET "PROMPT_SET=PackName"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED PackName SET PackName=Scripted_%RANDOM%
CLS&&CALL:PAD_LINE&&ECHO                            Select an option&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO. (%##%1%#$%) Keep registry hives mounted for duration of the package&&ECHO. (%##%2%#$%) %XLR2%Keep registry hives unmounted for duration of the package%#$%&&ECHO.&&ECHO    Note: DISM operations are incompatible if the hives are mounted.&&ECHO  When unmounted, registry %%HIVE_VARS%% always point to the live system.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF "%SELECT%"=="1" SET "PackTag=MOUNT"
IF "%SELECT%"=="2" SET "PackTag=UNMOUNT"
IF NOT "%SELECT%"=="1" IF NOT "%SELECT%"=="2" SET "ERROR=1"
EXIT /B
:N03
SET "PackType=AIOPACK"&&SET "EDIT_MANIFEST=1"&&SET "EDIT_SETUP=1"&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                          New AIO Pack (PKX) name &&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&SET "PROMPT_SET=PackName"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED PackName SET PackName=AIOPACK_%RANDOM%
ECHO EXEC-LIST>"%MAKER_FOLDER%\PACKAGE.LST"
ECHO Manually add/copy/paste items or replace the PACKAGE.LST with an existing list.>>"%MAKER_FOLDER%\PACKAGE.LST"
ECHO Copy all listed packages (APPX/CAB/MSU/PKG) into the project folder before package creation.>>"%MAKER_FOLDER%\PACKAGE.LST"
EXIT /B
:N10
CALL:PACK_STRT&&SET "PackTag=UNMOUNT"&&SET "PackType=SCRIPTED"&&SET "PackName=Firewall_Import"&&SET "PackDesc=Import Windows Firewall.XML"&&SET "EDIT_MANIFEST=1"&&SET "EDIT_SETUP=1"
ECHO;::Live Command: Needs to be applied during SetupComplete or RunOnce>>"%NEW_PACK%"
NETSH advfirewall EXPORT "%MAKER_FOLDER%\FirewallRules.wfw"
ECHO;NETSH advfirewall IMPORT "FirewallRules.wfw">>"%NEW_PACK%"
EXIT /B
:N11
CALL:PACK_STRT&&SET "PackTag=UNMOUNT"&&SET "PackType=SCRIPTED"&&SET "PackName=AUTOBOOT_ENABLE"&&SET "PackDesc=Commands to enable AutoBoot and boot into recovery"&&SET "EDIT_MANIFEST=1"&&SET "EDIT_SETUP=1"
ECHO;::Live Command: Needs to be applied during SetupComplete or RunOnce>>"%NEW_PACK%"
ECHO;::Needs AutoBoot.cmd in package folder>>"%NEW_PACK%"
ECHO;COPY /Y AutoBoot.cmd "%%~DP0.." >>"%NEW_PACK%"
ECHO;START CMD /C "%%~DP0..\windick.cmd" -autoboot -install>>"%NEW_PACK%"
ECHO;START CMD /C "%%~DP0..\windick.cmd" -nextboot -recovery>>"%NEW_PACK%"
EXIT /B
:N12
CALL:PACK_STRT&&SET "PackTag=UNMOUNT"&&SET "PackType=SCRIPTED"&&SET "PackName=MSI_INSTALLER_EXAMPLE"&&SET "PackDesc=Scripted Pack MSI Installer Example"&&SET "EDIT_MANIFEST=1"&&SET "EDIT_SETUP=1"
ECHO;::Live Command: Needs to be applied during SetupComplete or RunOnce>>"%NEW_PACK%"
ECHO;::Put MSI in pack folder.>>%NEW_PACK%"
ECHO;"EXAMPLE.msi" /qn>>"%NEW_PACK%"
EXIT /B
:TASK_MENU
@ECHO OFF&&CLS&&CALL:TITLE_X
CALL:PAD_LINE&&ECHO                                  Tasks&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO  (%##%1%#$%) Sysprep Menu&&ECHO  (%##%2%#$%) Create Local User-Account&&ECHO  (%##%3%#$%) Create Local Admin-Account&&ECHO  (%##%4%#$%) End Task&&ECHO  (%##%5%#$%) Start/Stop Service&&ECHO  (%##%6%#$%) List Accounts&&ECHO  (%##%7%#$%) SFC /Scannow&&ECHO  (%##%8%#$%) Generate unattend.xml&&ECHO  (%##%9%#$%) Export Stock Wallpaper&&ECHO  (%##%10%#$%) AutoBoot&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
FOR %%a in (1 2 3 4 5 6 7 8 9 10) DO (IF "%%a"=="%SELECT%" SET "ERROR="&&CALL:T%SELECT%X)
GOTO:TASK_MENU
:T1X
@ECHO OFF&&CLS&&CALL:TITLE_X&&CALL:PAD_LINE&&ECHO                              Sysprep Menu&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO. (%##%1%#$%) Audit Mode&&ECHO. (%##%2%#$%) Generalize&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF "%SELECT%"=="1" CALL:SYSPREP_AUD&&SET "SELECT="
IF "%SELECT%"=="2" CALL:SYSPREP_GEN&&SET "SELECT="
EXIT /B
:SYSPREP_AUD
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                 %XLR2%System will reboot to enter audit mode%#$%&&ECHO.&&ECHO.                         Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF NOT "%CONFIRM%"=="X" EXIT /B
"%WINDIR%\SYSTEM32\SYSPREP\SYSPREP.EXE" /AUDIT
EXIT /B
:SYSPREP_GEN
CLS&&SET "SYSPREP_DONE="&&SET "SYSPREP_OOBE="&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO         %XLR2%This will generalize your current Windows installation%#$%&&ECHO.&&ECHO.                         Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF NOT "%CONFIRM%"=="X" EXIT /B
CLS&&CALL:PAD_LINE&&ECHO                            Enable OOBE Mode&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO. (%##%1%#$%) Yes&&ECHO. (%##%2%#$%) No&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF "%SELECT%"=="1" SET "SYSPREP_OOBE=/OOBE"
IF "%SELECT%"=="2" SET "SYSPREP_OOBE="
IF NOT "%SELECT%"=="1" IF NOT "%SELECT%"=="2" EXIT /B
CLS&&CALL:PAD_LINE&&ECHO                            When Finished Do&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO. (%##%1%#$%) Reboot&&ECHO. (%##%2%#$%) Shutdown&&ECHO. (%##%3%#$%) Quit&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF "%SELECT%"=="1" SET "SYSPREP_DONE=/REBOOT"
IF "%SELECT%"=="2" SET "SYSPREP_DONE=/SHUTDOWN"
IF "%SELECT%"=="3" SET "SYSPREP_DONE=/QUIT"
IF NOT "%SELECT%"=="1" IF NOT "%SELECT%"=="2" IF NOT "%SELECT%"=="3" EXIT /B
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                      %XLR2%This may take several minutes.%#$%&&ECHO.&&ECHO        Use package creator to create unattended.xml if needed.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE
"%WINDIR%\SYSTEM32\SYSPREP\SYSPREP.EXE" /GENERALIZE %SYSPREP_DONE% %SYSPREP_OOBE%
EXIT /B
:T2X
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                  Enter Username: %XLR2%0-9 A-Z - No Spaces%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEWUSER"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
SET "CHAR_STR=%NEWUSER%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK
IF DEFINED CHAR_FLG SET "NEWUSER="
IF NOT DEFINED NEWUSER EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.
Net User %NEWUSER% /add
Net User %NEWUSER% /passwordreq:No
Net User %NEWUSER% /passwordchg:No
Net Accounts /maxpwage:unlimited
WMIC USERACCOUNT WHERE Name="%NEWUSER%" SET PasswordExpires=FALSE
IF DEFINED NEW_ADMIN Net localgroup Administrators %NEWUSER% /add
ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:PAUSED
EXIT /B
:T3X
SET "NEW_ADMIN=1"&&CALL:T2X
SET "NEW_ADMIN="
EXIT /B
:T4X
CLS&&ECHO.&&CALL:PAD_LINE&&ECHO                            The Task Reaper&&CALL:PAD_LINE&&TASKLIST /FO LIST>"$TSK"
SET "TSK_XNT="&&FOR /F "TOKENS=1-9 DELIMS=: " %%a in ($TSK) DO (
IF "%%a"=="Image" CALL SET "TSK_NAME=%%c%%d%%e%%f%%g"
IF "%%a"=="PID" CALL SET "TSK_PID=%%b"
IF "%%a"=="Mem" CALL SET "TSK_MEM=%%c"&&CALL:TASK_QUERY)
IF EXIST "$TSK" DEL "$TSK">NUL
CALL:PAD_LINE&&ECHO                            End Which Task(%##%#%#$%)?&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
SET "CHECK=NUM"&&CALL:CHECK
IF DEFINED ERROR EXIT /B
CALL TASKKILL /F /IM "%%TSK_XNT_%SELECT%%%"
CALL:PAD_LINE&&CALL:PAUSED
GOTO:PACKEX_TASKMGR_APP
:TASK_QUERY
CALL SET /A "TSK_XNT+=1"
CALL ECHO  [ %##%%TSK_XNT%%#$% ]  	[PID[%#@%%TSK_PID%%#$%] 	[%#@%%TSK_NAME%%#$%]   	[MEM[%#@%%TSK_MEM%%#$%] KB&&CALL SET "TSK_XNT_%TSK_XNT%=%TSK_NAME%"
EXIT /B
:T5X
CLS&&ECHO.&&CALL:PAD_LINE&&ECHO                           The Service Reaper&&CALL:PAD_LINE
SET "SVC_MODE="&&REG QUERY "%HIVE_SYSTEM%\ControlSet001\Services" /f Type /c /e /s>"$SVC"
SET "SVC_XNT="&&FOR /F "TOKENS=1-9 DELIMS=\ " %%a in ($SVC) DO (
IF "%%a"=="HKEY_LOCAL_MACHINE" IF NOT "%%e"=="" CALL SET "SVC_NAME=%%e%%f%%g%%h%%i"
IF "%%a"=="Type" IF "%%c"=="0x10" CALL:SVC_QUERY
IF "%%a"=="Type" IF "%%c"=="0x20" CALL:SVC_QUERY)
IF EXIST "$SVC" DEL "$SVC">NUL
CALL:PAD_LINE&&ECHO                     (%##%1%#$%)Start Service (%##%2%#$%)Stop Service&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT "%SELECT%"=="1" IF NOT "%SELECT%"=="2"  EXIT /B
IF "%SELECT%"=="1" SET "SVC_MODE=START"
IF "%SELECT%"=="2" SET "SVC_MODE=STOP"
CALL:PAD_LINE&&ECHO                            %SVC_MODE% Which SVC(%##%#%#$%)?&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
SET "CHECK=NUM"&&CALL:CHECK
IF DEFINED ERROR EXIT /B
IF "%SVC_MODE%"=="START" CALL SC START %%SVC_XNT_%SELECT%%%
IF "%SVC_MODE%"=="STOP" CALL SC STOP %%SVC_XNT_%SELECT%%%
SET "SVC_MODE="&&CALL:PAD_LINE&&CALL:PAUSED
GOTO:PACKEX_SVCMGR_APP
:SVC_QUERY
CALL SET /A "SVC_XNT+=1"
FOR /F "TOKENS=1-9 DELIMS= " %%1 in ('SC QUERY %SVC_NAME%') DO (IF "%%1"=="STATE" CALL SET "SVC_STATE=%%4")
CALL ECHO  [ %##%%SVC_XNT%%#$% ]  	[State[%#@%%SVC_STATE%%#$%] 	[%#@%%SVC_NAME%%#$%]&&CALL SET SVC_XNT_%SVC_XNT%=%SVC_NAME%
EXIT /B
:T6X
CLS&&CALL:PAD_LINE&&ECHO                       User account enumeration&&CALL:PAD_LINE
NET USER>"$USR"
FOR /F "TOKENS=1-9 SKIP=4 DELIMS= " %%a IN ($USR) DO (
IF NOT "%%a"=="The" IF NOT "%%a"=="" NET USER %%a&&CALL:PAD_LINE
IF NOT "%%a"=="The" IF NOT "%%b"=="" NET USER %%b&&CALL:PAD_LINE
IF NOT "%%a"=="The" IF NOT "%%c"=="" NET USER %%c&&CALL:PAD_LINE
IF NOT "%%a"=="The" IF NOT "%%d"=="" NET USER %%d&&CALL:PAD_LINE
IF NOT "%%a"=="The" IF NOT "%%e"=="" NET USER %%e&&CALL:PAD_LINE
IF NOT "%%a"=="The" IF NOT "%%f"=="" NET USER %%f&&CALL:PAD_LINE
IF NOT "%%a"=="The" IF NOT "%%g"=="" NET USER %%g&&CALL:PAD_LINE
IF NOT "%%a"=="The" IF NOT "%%h"=="" NET USER %%h&&CALL:PAD_LINE
IF NOT "%%a"=="The" IF NOT "%%i"=="" NET USER %%i&&CALL:PAD_LINE)
DEL /Q /F "$USR">NUL
ECHO                     End of user account enumeration&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:T7X
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO            %XLR2%This will scan and attempt to repair system files%#$%&&ECHO.&&ECHO.                         Press (%##%X%#$%) to proceed&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF NOT "%CONFIRM%"=="X" SET "ERROR=1"&&EXIT /B
SFC /SCANNOW
EXIT /B
:T8X
CLS&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                  Enter Username: %XLR2%0-9 A-Z - No Spaces%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=NEWUSER"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
SET "CHAR_STR=%NEWUSER%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK
IF DEFINED CHAR_FLG SET "NEWUSER="
IF NOT DEFINED NEWUSER EXIT /B
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO            Enter Product key: %#@%XXXXX-XXXXX-XXXXX-XXXXX-XXXXX%#$%&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&SET "PROMPT_SET=PRODUCT_KEY"&&SET "PROMPT_ANY=1"&&CALL:PROMPT_SET
IF NOT DEFINED PRODUCT_KEY SET "PRODUCT_KEY=92NFX-8DJQP-P6BBQ-THF9C-7CG2H"
CALL:ANSWER_FILE>"%CACHE_FOLDER%\unattend.xml"
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                      Unattend.xml has been generated.&&ECHO           Next, create an unattended installation list entry.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:T9X
IF NOT EXIST "%CACHE_FOLDER%\wallpaper.jpg" COPY /Y "%WINDIR%\web\wallpaper\Windows\img0.jpg" "%CACHE_FOLDER%\wallpaper.jpg">NUL 2>&1
IF NOT EXIST "%CACHE_FOLDER%\wallpaper.jpg" ECHO.>"%CACHE_FOLDER%\wallpaper.jpg"
CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.&&ECHO                    Stock wallpaper has been copied.&&ECHO               Replace wallpaper.jpg with a custom image.&&ECHO.&&ECHO                  Next, create a wallpaper list entry.&&ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:T10X
@ECHO OFF&&CLS&&CALL:TITLE_X
CALL:PAD_LINE&&ECHO                              AutoBoot Menu&&CALL:PAD_LINE&&SET "BOX=T2"&&CALL:BOX&&ECHO.
IF NOT "%PROG_MODE%"=="RAMDISK" ECHO  (%##%I%#$%)nstall AutoBoot Switcher&&ECHO  (%##%R%#$%)emove AutoBoot Switcher
IF "%PROG_MODE%"=="RAMDISK" IF "%AUTOBOOT%"=="DISABLED" ECHO  (%##%*%#$%)Enable/Disable[%#@%%AUTOBOOT%%#$%]
IF "%PROG_MODE%"=="RAMDISK" IF "%AUTOBOOT%"=="ENABLED" ECHO  (%##%*%#$%)Enable/Disable[%#@%%AUTOBOOT%%#$%]&&ECHO  (%##%E%#$%)dit
ECHO.&&SET "BOX=B2"&&CALL:BOX&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF "%SELECT%"=="I" IF NOT "%PROG_MODE%"=="RAMDISK" CALL:AUTOBOOT_HOST
IF "%SELECT%"=="R" IF NOT "%PROG_MODE%"=="RAMDISK" CALL:AUTOBOOT_HOST
IF "%SELECT%"=="E" IF "%PROG_MODE%"=="RAMDISK" CALL:AUTOBOOT_VIEW&&SET "SELECT="
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="RAMDISK" CALL:AUTOBOOT_CMD
EXIT /B
:AUTOBOOT_VIEW
IF NOT EXIST "%PROG_SOURCE%\AutoBoot.cmd" EXIT /B
START NOTEPAD.EXE "%PROG_SOURCE%\AutoBoot.cmd"
EXIT /B
:AUTOBOOT_CMD
IF EXIST "%PROG_SOURCE%\AutoBoot.cmd" SET "AUTOBOOT=DISABLED"&&MOVE /Y "%PROG_SOURCE%\AutoBoot.cmd" "%PROG_SOURCE%\AutoBoot.txt">NUL&EXIT /B
IF NOT EXIST "%PROG_SOURCE%\AutoBoot.txt" CALL:PAD_LINE&&ECHO                     This will generate AutoBoot.cmd. &&ECHO         AutoBoot switcher will need to be installed on host OS.&&SET "AUTOMSG=                 Are your sure? Press (X) to confirm."
IF EXIST "%PROG_SOURCE%\AutoBoot.txt" CALL:PAD_LINE&&ECHO              AutoBoot.txt found. Restore or generate new?&&SET "AUTOMSG=                        (%#@%R%#$%)estore (%#@%C%#$%)reate New"
ECHO.%AUTOMSG%&&SET "AUTOMSG="&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "PROMPT_SET=CONFIRM"&&CALL:PROMPT_SET
IF "%CONFIRM%"=="R" SET "AUTOBOOT=ENABLED"&&MOVE /Y "%PROG_SOURCE%\AutoBoot.txt" "%PROG_SOURCE%\AutoBoot.cmd">NUL&&SET "SELECT="
IF "%CONFIRM%"=="X" SET "AUTOBOOT=ENABLED"&&CALL:AUTOBOOT_EXAMPLE>"%PROG_SOURCE%\AutoBoot.cmd"&&START NOTEPAD.EXE "%PROG_SOURCE%\AutoBoot.cmd"
EXIT /B
:AUTOBOOT_HOST
IF "%SELECT%"=="R" SET "BOOTSVC=REMOVE"&&CALL:AUTOBOOT_SVC&&CALL:PAD_LINE&&ECHO  AutoBoot switcher is removed.&&CALL:PAD_LINE
IF "%SELECT%"=="I" SET "BOOTSVC=INSTALL"&&CALL:AUTOBOOT_SVC&&CALL:PAD_LINE&&ECHO  AutoBoot switcher is installed.&&CALL:PAD_LINE
IF NOT DEFINED BOOT_OK CALL:PAD_LINE&&ECHO  Boot environment not installed on this machine. Aborted.&&CALL:PAD_LINE
CALL:PAUSED
EXIT /B
:AUTOBOOT_SVC
CALL:BOOT_QUERY
IF NOT DEFINED BOOT_OK EXIT /B
IF "%BOOTSVC%"=="INSTALL" SET "BOOTSVC="&&SC CREATE AutoBoot binpath="%WinDir%\SYSTEM32\CMD.EXE /C BCDEDIT.EXE /displayorder %GUID_TMP% /addfirst" start=auto>NUL 2>&1
IF "%BOOTSVC%"=="REMOVE" SET "BOOTSVC="&&SC DELETE AutoBoot>NUL 2>&1
EXIT /B
:AUTOBOOT_EXAMPLE
ECHO.::=======================================================================
ECHO.::    Script cannot have an EXIT otherwise it goes into the main menu. 
ECHO.::Autoboot service must be installed within host OS to switch upon boot.
ECHO.::==========================START OF AUTOBOOT============================
ECHO.::        Example of a VHDX backup/Restore - Host Folder = S:\$
ECHO.REM windick.cmd -diskmgr -mount -diskid 12345678-1234-1234-1234-123456781234 -part 1 -letter z
ECHO.REM copy /y s:\$\active.vhdx z:\Backups\last_power_off.vhdx
ECHO.REM windick.cmd -diskmgr -unmount -diskid 12345678-1234-1234-1234-123456781234 -part 1 -letter z 
ECHO.REM windick.cmd -imageproc -wim 22h2_ready2go.wim -index 1 -vhdx active.vhdx -size 25600
ECHO.REM del S:\$\active.vhdx
ECHO.REM move /y s:\$\image\active.vhdx s:\$
ECHO.ECHO - AutoBoot - Example - Your Script - Goes here -
ECHO.PAUSE
ECHO.::===========================END OF AUTOBOOT=============================
ECHO.::=======================================================================
EXIT /B
:ANSWER_FILE
ECHO;^<?xml version="1.0" encoding="utf-8"?^>
ECHO;^<unattend xmlns="urn:schemas-microsoft-com:unattend"^>
ECHO;	^<settings pass="oobeSystem"^>
ECHO;		^<component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>
ECHO;			^<InputLocale^>0409:00000409^</InputLocale^>
ECHO;			^<SystemLocale^>en-US^</SystemLocale^>
ECHO;			^<UILanguage^>en-US^</UILanguage^>
ECHO;			^<UILanguageFallback^>en-US^</UILanguageFallback^>
ECHO;			^<UserLocale^>en-US^</UserLocale^>
ECHO;		^</component^>
ECHO;		^<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>
ECHO;			^<TimeZone^>Mountain Standard Time^</TimeZone^>
ECHO;			^<AutoLogon^>
ECHO;				^<Enabled^>true^</Enabled^>
ECHO;				^<LogonCount^>9999999^</LogonCount^>
ECHO;				^<Username^>%NEWUSER%^</Username^>
ECHO;				^<Password^>
ECHO;					^<PlainText^>true^</PlainText^>
ECHO;					^<Value^>^</Value^>
ECHO;				^</Password^>
ECHO;			^</AutoLogon^>
ECHO;			^<OOBE^>
ECHO;				^<HideEULAPage^>true^</HideEULAPage^>
ECHO;				^<HideLocalAccountScreen^>true^</HideLocalAccountScreen^>
ECHO;				^<HideOnlineAccountScreens^>true^</HideOnlineAccountScreens^>
ECHO;				^<HideWirelessSetupInOOBE^>true^</HideWirelessSetupInOOBE^>
ECHO;				^<NetworkLocation^>Other^</NetworkLocation^>
ECHO;				^<ProtectYourPC^>3^</ProtectYourPC^>
ECHO;				^<SkipMachineOOBE^>true^</SkipMachineOOBE^>
ECHO;				^<SkipUserOOBE^>true^</SkipUserOOBE^>
ECHO;			^</OOBE^>
ECHO;			^<UserAccounts^>
ECHO;				^<LocalAccounts^>
ECHO;					^<LocalAccount wcm:action="add"^>
ECHO;						^<Group^>Administrators^</Group^>
ECHO;						^<Name^>%NEWUSER%^</Name^>
ECHO;						^<Password^>
ECHO;							^<PlainText^>true^</PlainText^>
ECHO;							^<Value^>^</Value^>
ECHO;						^</Password^>
ECHO;					^</LocalAccount^>
ECHO;				^</LocalAccounts^>
ECHO;			^</UserAccounts^>
ECHO;		^</component^>
ECHO;	^</settings^>
ECHO;	^<settings pass="specialize"^>
ECHO;		^<component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>
ECHO;			^<SkipAutoActivation^>true^</SkipAutoActivation^>
ECHO;		^</component^>
ECHO;		^<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>
ECHO;			^<ComputerName^>Computer^</ComputerName^>
ECHO;			^<CopyProfile^>false^</CopyProfile^>
ECHO;			^<ProductKey^>%PRODUCT_KEY%^</ProductKey^>
ECHO;		^</component^>
ECHO;	^</settings^>
ECHO;	^<settings pass="windowsPE"^>
ECHO;		^<component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>
ECHO;			^<InputLocale^>0409:00000409^</InputLocale^>
ECHO;			^<SystemLocale^>en-US^</SystemLocale^>
ECHO;			^<UILanguage^>en-US^</UILanguage^>
ECHO;			^<UILanguageFallback^>en-US^</UILanguageFallback^>
ECHO;			^<UserLocale^>en-US^</UserLocale^>
ECHO;			^<SetupUILanguage^>
ECHO;				^<UILanguage^>en-US^</UILanguage^>
ECHO;			^</SetupUILanguage^>
ECHO;		^</component^>
ECHO;		^<component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"^>
ECHO;			^<Diagnostics^>
ECHO;				^<OptIn^>false^</OptIn^>
ECHO;			^</Diagnostics^>
ECHO;			^<DynamicUpdate^>
ECHO;				^<Enable^>false^</Enable^>
ECHO;				^<WillShowUI^>OnError^</WillShowUI^>
ECHO;			^</DynamicUpdate^>
ECHO;			^<ImageInstall^>
ECHO;				^<OSImage^>
ECHO;					^<Compact^>true^</Compact^>
ECHO;					^<WillShowUI^>OnError^</WillShowUI^>
ECHO;					^<InstallFrom^>
ECHO;						^<MetaData wcm:action="add"^>
ECHO;							^<Key^>/IMAGE/INDEX^</Key^>
ECHO;							^<Value^>1^</Value^>
ECHO;						^</MetaData^>
ECHO;					^</InstallFrom^>
ECHO;				^</OSImage^>
ECHO;			^</ImageInstall^>
ECHO;			^<UserData^>
ECHO;				^<AcceptEula^>true^</AcceptEula^>
ECHO;				^<ProductKey^>
ECHO;					^<Key^>%PRODUCT_KEY%^</Key^>
ECHO;					^<WillShowUI^>OnError^</WillShowUI^>
ECHO;				^</ProductKey^>
ECHO;			^</UserData^>
ECHO;		^</component^>
ECHO;	^</settings^>
ECHO;^</unattend^>
EXIT /B
:RESTART
"shutdown.exe" -r -f -t 0
:QUIT
CALL:SETS_HANDLER>NUL 2>&1
IF EXIST "U:\EFI" CALL:EFI_UNMOUNT>NUL 2>&1
IF EXIST "V:\" CALL:VDISK_DETACH>NUL 2>&1
:CLEAN_EXIT
IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="ENABLED" CALL:HOST_HIDE
COLOR&&TITLE C:\Windows\system32\CMD.exe&&CD /D "%ORIG_CD%"
IF "%PROG_MODE%"=="RAMDISK" EXIT 0&&EXIT 0