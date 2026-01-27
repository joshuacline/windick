:: <# Windows Deployment Image Customization Kit v 1219 © github.com/joshuacline
:: Build, administrate and backup your Windows in a native WinPE recovery environment
@ECHO OFF&&SETLOCAL ENABLEDELAYEDEXPANSION&&SET "ARGS=%*"
FOR %%1 in (0 1 2 3 4 5 6 7 8 9) DO (CALL SET "ARG%%1=%%%%1%%")
GOTO:GET_INIT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:MAIN_MENU
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "MOUNT="&&IF NOT DEFINED MENU_MODE SET "MENU_MODE=NORMAL"
IF "%PROG_MODE%"=="RAMDISK" FOR %%a in (BASIC CUSTOM) DO (IF "%MENU_MODE%"=="%%a" GOTO:%MENU_MODE%_MODE)
IF NOT "%GUI_LAUNCH%"=="DISABLED" IF NOT "%WINPE_BOOT%"=="1" GOTO:GUI_MODE
IF EXIST "%ProgFolder%\$PKX" ECHO.Cleaning up pkx folder from previous session...&&SET "FOLDER_DEL=%ProgFolder%\$PKX"&&CALL:FOLDER_DEL
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:GET_SPACE_ENV&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.              Windows Deployment Image Customization Kit&&ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% 0 %$$%) %U09% Change Boot Order
ECHO. (%##% 1 %$$%) %U07% Image Processing&&ECHO. (%##% 2 %$$%) %U08% Image Management&&ECHO. (%##% 3 %$$%) %U11% Other Management&&ECHO. (%##% 4 %$$%) %U04% BootDisk Creator&&ECHO. (%##% 5 %$$%) %U03% Settings
ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="Z:\%HOST_FOLDERX%" ECHO.          ^< Disk %@@%%HOST_NUMBER%%$$% UID %@@%%HOST_TARGET%%$$% ^>
IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="X:\$" ECHO.        ^< Disk %COLOR2%ERROR%$$% UID %COLOR2%%HOST_TARGET%%$$% ^>
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&TITLE Windows Deployment Image Customization Kit v%VER_CUR%  (%ProgFolder%)
IF "%PROG_MODE%"=="RAMDISK" ECHO.  (%##%Q%$$%)uit  (%##%*%$$%) Basic Menu                                    %@@%%FREE%GB%$$% Free
IF "%PROG_MODE%"=="PORTABLE" IF "%WINPE_BOOT%"=="1" ECHO.  (%##%Q%$$%)uit                                                   %@@%%FREE%GB%$$% Free
IF "%PROG_MODE%"=="PORTABLE" IF NOT "%WINPE_BOOT%"=="1" ECHO.  (%##%Q%$$%)uit  (%##%*%$$%) %U06% Switch to GUI                            %@@%%FREE%GB%$$% Free
CALL:PAD_LINE&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF "%SELECT%"=="Q" GOTO:QUIT
IF DEFINED SELECT CALL:SHORTCUT_RUN
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF "%SELECT%"=="1" GOTO:IMAGE_PROCESSING
IF NOT DEFINED IMAGE_LAST SET "IMAGE_LAST=IMAGE"
IF "%SELECT%"=="2" GOTO:%IMAGE_LAST%_MANAGEMENT
IF NOT DEFINED MISC_LAST SET "MISC_LAST=FILE"
IF "%SELECT%"=="3" GOTO:%MISC_LAST%_MANAGEMENT
IF "%SELECT%"=="4" GOTO:BOOT_CREATOR
IF "%SELECT%"=="5" GOTO:SETTINGS_MENU
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="RAMDISK" SET "MENU_MODE=BASIC"&&GOTO:BASIC_MODE
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="PORTABLE" IF NOT "%WINPE_BOOT%"=="1" SET "GUI_LAUNCH=ENABLED"&&(ECHO.&&ECHO.GUI_LAUNCH=ENABLED)>>"windick.ini"
IF "%SELECT%"=="~" SET&&CALL:PAUSED
IF "%SELECT%"=="0" IF "%PROG_MODE%"=="RAMDISK" CALL:BCD_MENU
GOTO:MAIN_MENU
:GUI_MODE
START powershell -noprofile -WindowStyle Hidden -executionpolicy bypass -command "$Content = Get-Content -Path '%~f0' -raw -Encoding utf8;$ContentUTF = [ScriptBlock]::Create($Content);& $ContentUTF"
GOTO:QUIT
:BASIC_MODE
@ECHO OFF&&SET "MOUNT="&&CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:GET_SPACE_ENV&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.              Windows Deployment Image Customization Kit&&ECHO.&&ECHO.&&ECHO. (%##% 0 %$$%) %U09% Change Boot Order&&ECHO. (%##% 1 %$$%) %U07% Backup&&ECHO. (%##% 2 %$$%) %U07% Restore
ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="Z:\%HOST_FOLDERX%" ECHO.          ^< Disk %@@%%HOST_NUMBER%%$$% UID %@@%%HOST_TARGET%%$$% ^>
IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="X:\$" ECHO.        ^< Disk %COLOR2%ERROR%$$% UID %COLOR2%%HOST_TARGET%%$$% ^>
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&TITLE Windows Deployment Image Customization Kit v%VER_CUR%  (%ProgFolder%)
ECHO.  (%##%Q%$$%)uit  (%##%*%$$%) Main Menu                                    %@@%%FREE%GB%$$% Free
CALL:PAD_LINE&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF "%SELECT%"=="Q" GOTO:QUIT
IF DEFINED SELECT CALL:SHORTCUT_RUN
IF DEFINED HOST_ERROR GOTO:BASIC_MODE
IF "%SELECT%"=="0" CALL:BCD_MENU&SET "SELECT="
IF "%SELECT%"=="1" CALL:BASIC_BACKUP&SET "SELECT="
IF "%SELECT%"=="2" CALL:BASIC_RESTORE&SET "SELECT="
IF "%SELECT%"=="*" SET "MENU_MODE=NORMAL"&&GOTO:MAIN_MENU
GOTO:BASIC_MODE
:CUSTOM_MODE
@ECHO OFF&&SET "MOUNT="&&CLS&&SET "MENU_MODE=NORMAL"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:GET_SPACE_ENV&TITLE
IF NOT DEFINED MENU_LIST GOTO:MAIN_MENU
IF NOT EXIST "%ListFolder%\%MENU_LIST%" SET "MENU_LIST="&&GOTO:MAIN_MENU
SET "$HEAD_CHECK=%ListFolder%\%MENU_LIST%"&&CALL:GET_HEADER
IF NOT "%$HEAD%"=="MENU-SCRIPT" ECHO.&&ECHO.%COLOR4%ERROR:%$$% %MENU_LIST% is not a base or execution list. Leaving custom menu.&&ECHO.&&CALL:PAUSED&GOTO:MAIN_MENU
SET "TIMER_MSG= %$$%Executing %@@%%MENU_LIST%%$$% in [ %COLOR4%%%TIMER%%%$$% ] seconds. %##%Close window to abort.%$$%"&&SET "TIMER=10"&&CALL:TIMER&&SET "MENU_MODE=CUSTOM"&&CALL:SETS_HANDLER
CLS&&CALL %CMD% /C ""%ProgFolder%\windick.cmd" -IMAGEMGR -RUN -LIST "%MENU_LIST%" -MENU"
SET "TIMER=10"&&CALL:TIMER&&SET "TIMER_MSG= %$$%Reboot in [ %COLOR4%%%TIMER%%%$$% ] seconds."&&SET "TIMER=15"&&CALL:TIMER
GOTO:QUIT
:COMMAND_MODE
IF DEFINED GUI_ACTIVE SET "PROG_MODE=GUI"&&CALL:SETS_HANDLER&CLS
IF NOT "%PROG_MODE%"=="GUI" SET "PAD_TYPE=0"&&CALL:SETS_MAIN
SET "MOUNT="&&IF NOT "%ARG1%"=="/?" IF NOT "%ARG1%"=="-HELP" IF NOT "%ARG1%"=="-INTERNAL" IF NOT "%ARG1%"=="-AUTOBOOT" IF NOT "%ARG1%"=="-NEXTBOOT" IF NOT "%ARG1%"=="-BOOTMAKER" IF NOT "%ARG1%"=="-BOOTCREATOR" IF NOT "%ARG1%"=="-DISKMGR" IF NOT "%ARG1%"=="-FILEMGR" IF NOT "%ARG1%"=="-IMAGEPROC" IF NOT "%ARG1%"=="-IMAGEMGR" ECHO.Type windick.cmd -help for more options.&&GOTO:QUIT
IF "%ARG1%"=="/?" SET "ARG1=-HELP"
IF "%ARG1%"=="-HELP" CALL:COMMAND_HELP
IF "%ARG1%"=="-BOOTMAKER" SET "ARG1=-BOOTCREATOR"
IF "%ARG1%"=="-INTERNAL" IF "%ARG2%"=="-SETTINGS" SET "MENU_EXIT=1"&&GOTO:SETTINGS_MENU
IF "%ARG1%"=="-FILEMGR" IF NOT "%ARG2%"=="-GRANT" ECHO.Valid options are -grant
IF "%ARG1%"=="-FILEMGR" IF "%ARG2%"=="-GRANT" IF NOT EXIST "%ARG3%" ECHO.%COLOR4%ERROR:%$$% %ARG3% doesn't exist
IF "%ARG1%"=="-FILEMGR" IF "%ARG2%"=="-GRANT" IF DEFINED ARG3 IF EXIST "%ARG3%" SET "$PICK=%ARG3%"&&CALL:FMGR_OWN
IF "%ARG1%"=="-NEXTBOOT" IF NOT "%ARG2%"=="-RECOVERY" IF NOT "%ARG2%"=="-VHDX" ECHO.Valid options are -recovery and -vhdx
IF "%ARG1%"=="-NEXTBOOT" FOR %%a in (VHDX RECOVERY) DO (IF "%ARG2%"=="-%%a" SET "BOOT_TARGET=%%a"&&CALL:BOOT_TOGGLE)
IF "%ARG1%"=="-NEXTBOOT" IF DEFINED BOOT_OK ECHO.Next boot is %NEXT_BOOT%
IF "%ARG1%"=="-NEXTBOOT" IF NOT DEFINED BOOT_OK ECHO.%COLOR4%ERROR:%$$% The boot environment is not installed on this system.
IF "%ARG1%"=="-AUTOBOOT" IF NOT "%ARG2%"=="-INSTALL" IF NOT "%ARG2%"=="-REMOVE" ECHO.Valid options are -install and -remove
IF "%ARG1%"=="-AUTOBOOT" IF "%ARG2%"=="-REMOVE" SET "BOOTSVC=REMOVE"&&CALL:AUTOBOOT_SVC
IF "%ARG1%"=="-AUTOBOOT" IF "%ARG2%"=="-INSTALL" SET "BOOTSVC=INSTALL"&&CALL:AUTOBOOT_SVC
IF "%ARG1%"=="-BOOTCREATOR" CALL:COMMAND_BOOTCREATOR
IF "%ARG1%"=="-DISKMGR" CALL:COMMAND_DISKMGR
IF "%ARG1%"=="-IMAGEMGR" CALL:COMMAND_IMAGEMGR
IF "%ARG1%"=="-IMAGEPROC" SET "SOURCE_TYPE="&&SET "TARGET_TYPE="&&SET "$PASS="&&FOR %%▓ in (WIM PATH VHDX) DO (IF "%ARG2%"=="-%%▓" SET "$PASS=1"&&SET "SOURCE_TYPE=%%▓"&&CALL:COMMAND_IMAGEPROC_%%▓)
IF "%ARG1%"=="-IMAGEPROC" IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% ARG2 not -wim, -path, or -vhdx&&EXIT /B
GOTO:QUIT
:COMMAND_IMAGEPROC_PATH
IF NOT DEFINED ARG3 ECHO.%COLOR4%ERROR:%$$% ARG3 'path' is not specified&&EXIT /B
IF NOT EXIST "%ARG3%\*" ECHO.%COLOR4%ERROR:%$$% 'path' "%ARG3%" doesn't exist&&EXIT /B
IF NOT "%ARG4%"=="-WIM" ECHO.%COLOR4%ERROR:%$$% ARG4 is not -wim&&EXIT /B
IF NOT DEFINED ARG5 ECHO.%COLOR4%ERROR:%$$% ARG5 'wim' is not specified&&EXIT /B
IF NOT "%ARG6%"=="-XLVL" ECHO.%COLOR4%ERROR:%$$% ARG6 is not -xlvl&&EXIT /B
IF NOT "%ARG7%"=="FAST" IF NOT "%ARG7%"=="MAX" ECHO.%COLOR4%ERROR:%$$% ARG7 'compression' is not fast or max&&EXIT /B
SET "TARGET_TYPE=WIM"&&SET "PATH_SOURCE=%ARG3%"&&SET "WIM_TARGET=%ARG5%"&&SET "COMPRESS=%ARG7%"&&CALL:IMAGEPROC_START
EXIT /B
:COMMAND_IMAGEPROC_VHDX
IF NOT DEFINED ARG3 ECHO.%COLOR4%ERROR:%$$% ARG3 'vhdx' is not specified&&EXIT /B
IF NOT EXIST "%ImageFolder%\%ARG3%" ECHO.%COLOR4%ERROR:%$$% 'vhdx' "%ImageFolder%\%ARG3%" doesn't exist&&EXIT /B
IF NOT "%ARG4%"=="-INDEX" ECHO.%COLOR4%ERROR:%$$% ARG4 is not -index&&EXIT /B
IF NOT DEFINED ARG5 ECHO.%COLOR4%ERROR:%$$% ARG5 'index' number is not specified&&EXIT /B
SET "$PASS="&&FOR %%▓ in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25) DO (IF "%ARG5%"=="%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% ARG5 'index' is not between 1-25&&EXIT /B
IF NOT "%ARG6%"=="-WIM" ECHO.%COLOR4%ERROR:%$$% ARG6 is not -wim&&EXIT /B
IF NOT DEFINED ARG7 ECHO.%COLOR4%ERROR:%$$% ARG7 'wim' is not specified&&EXIT /B
IF NOT "%ARG8%"=="-XLVL" ECHO.%COLOR4%ERROR:%$$% ARG8 is not -xlvl&&EXIT /B
IF /I NOT "%ARG9%"=="FAST" IF /I NOT "%ARG9%"=="MAX" ECHO.%COLOR4%ERROR:%$$% ARG9 'compression' is not fast or max&&EXIT /B
SET "TARGET_TYPE=WIM"&&SET "VHDX_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "WIM_TARGET=%ARG7%"&&SET "COMPRESS=%ARG9%"&&CALL:IMAGEPROC_START
EXIT /B
:COMMAND_IMAGEPROC_WIM
IF NOT DEFINED ARG3 ECHO.%COLOR4%ERROR:%$$% 'wim' [%ARG3%] is not defined&&EXIT /B
IF NOT EXIST "%ImageFolder%\%ARG3%" ECHO.%COLOR4%ERROR:%$$% 'wim' "%ImageFolder%\%ARG3%" doesn't exist&&EXIT /B
IF NOT "%ARG4%"=="-INDEX" ECHO.%COLOR4%ERROR:%$$% ARG4 is not -index&&EXIT /B
IF NOT DEFINED ARG5 ECHO.%COLOR4%ERROR:%$$% ARG5 'index' number is not specified&&EXIT /B
SET "$PASS="&&FOR %%▓ in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25) DO (IF "%ARG5%"=="%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% ARG5 'index' is not between 1-25&&EXIT /B
SET "$PASS="&&FOR %%▓ in (PATH VHDX) DO (IF "%ARG6%"=="-%%▓" SET "$PASS=1"&&SET "TARGET_TYPE=%%▓")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% ARG6 'target' is not -path or -vhdx&&EXIT /B
IF "%TARGET_TYPE%"=="PATH" IF NOT DEFINED ARG7 ECHO.%COLOR4%ERROR:%$$% ARG7 'path' is not specified&&EXIT /B
IF "%TARGET_TYPE%"=="PATH" IF NOT EXIST "%ARG7%\*" ECHO.%COLOR4%ERROR:%$$% 'path' "%ARG7%" doesn't exist&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" IF NOT DEFINED ARG7 ECHO.%COLOR4%ERROR:%$$% ARG7 'vhdx' is not specified&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" IF NOT "%ARG8%"=="-SIZE" ECHO.%COLOR4%ERROR:%$$% ARG8 is not -size&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" IF NOT DEFINED ARG9 ECHO.%COLOR4%ERROR:%$$% ARG9 'size' is not specified&&EXIT /B
IF "%TARGET_TYPE%"=="VHDX" SET "WIM_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "VHDX_TARGET=%ARG7%"&&SET "VHDX_SIZE=%ARG9%"&&CALL:IMAGEPROC_START
IF "%TARGET_TYPE%"=="PATH" SET "INPUT=%ARG7%"&&SET "OUTPUT=ARG7"&&CALL:SLASHER
IF "%TARGET_TYPE%"=="PATH" SET "WIM_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "PATH_TARGET=%ARG7%"&&CALL:IMAGEPROC_START
EXIT /B
:COMMAND_IMAGEMGR
SET "$PASS="&&SET "$LISTPACK="&&FOR %%▓ in (NEWPACK EXAMPLE EXPORT CREATE RUN) DO (IF "%ARG2%"=="-%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.ERROR: ARG2 not -newpack, -export, -example, -create, or -run&&EXIT /B
IF "%ARG2%"=="-NEWPACK" SET "MENU_SKIP=1"&&CALL:PROJ_NEW
IF "%ARG2%"=="-EXAMPLE" IF DEFINED ARG3 SET "NEW_NAME=%ARG3%"&&SET "MENU_SKIP=1"&&CALL:BASE_TEMPLATE
IF "%ARG2%"=="-EXPORT" IF "%ARG3%"=="-DRIVERS" IF "%ARG4%"=="-LIVE" SET "LIVE_APPLY=1"&&CALL:DRVR_EXPORT_SKIP
IF "%ARG2%"=="-EXPORT" IF "%ARG3%"=="-DRIVERS" IF "%ARG4%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG5 IF EXIST "%ImageFolder%\%ARG5%" SET "$PICK=%ImageFolder%\%ARG5%"&&CALL:DRVR_EXPORT_SKIP
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-BASE" IF DEFINED ARG4 SET "NEW_NAME=%ARG4%"&&IF "%ARG5%"=="-LIVE" SET "LIVE_APPLY=1"&&SET "BASE_CHOICE=%ARG6%"&&CALL:LIST_BASE_CREATE_CMD
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-BASE" IF DEFINED ARG4 SET "NEW_NAME=%ARG4%"&&IF "%ARG5%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG6 IF EXIST "%ImageFolder%\%ARG6%" SET "$PICK=%ImageFolder%\%ARG6%"&&SET "BASE_CHOICE=%ARG7%"&&CALL:LIST_BASE_CREATE_CMD
IF "%ARG2%"=="-RUNEXT" IF DEFINED ARG3 IF DEFINED ARG4 IF EXIST "%ARG4%" SET "INPUT=%ARG4%"&&CALL:GET_FILEEXT
IF "%ARG2%"=="-RUNEXT" IF DEFINED ARG3 IF DEFINED ARG4 IF EXIST "%ARG4%" SET "INPUT=%$PATH_X%"&&SET "OUTPUT=$PATH_X"&&CALL:SLASHER&&FOR /F "TOKENS=1 DELIMS=." %%a IN ("%EXT_UPPER%") DO (SET "ARG3=-%%a")
IF "%ARG2%"=="-RUNEXT" IF "%ARG3%"=="-LIST" IF EXIST "%ARG4%" SET "ARG2=-RUN"&&SET "ListFolder=%$PATH_X%"&&SET "ARG4=%$FILE_X%%$EXT_X%"
IF "%ARG2%"=="-RUNEXT" IF "%ARG3%"=="-PACK" IF EXIST "%ARG4%" SET "PackFolder=%$PATH_X%"&&SET "ARG4=%$FILE_X%%$EXT_X%"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-CUSTOM" SET "CUSTOM_SESSION=1"&&SET "DELETE_DONE=%ARG4%"&&SET "ARG3=-LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-PACK" IF DEFINED ARG4 IF NOT EXIST "%PackFolder%\%ARG4%" ECHO.%COLOR4%ERROR:%$$% pack "%PackFolder%\%ARG4%" doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ARG4 IF NOT EXIST "%ListFolder%\%ARG4%" ECHO.%COLOR4%ERROR:%$$% list "%ListFolder%\%ARG4%" doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-VHDX" IF DEFINED ARG6 IF NOT EXIST "%ImageFolder%\%ARG6%" ECHO.%COLOR4%ERROR:%$$% vhdx "%ImageFolder%\%ARG6%" doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF NOT DEFINED ARG6 ECHO.%COLOR4%ERROR:%$$% path [%ARG6%] is not defined&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF DEFINED ARG6 IF NOT EXIST "%ARG6%\*" ECHO.%COLOR4%ERROR:%$$% path "%ARG6%" doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 SET "PARSE_X="&&FOR /F "TOKENS=1-9* DELIMS=%U00%" %%a in ('ECHO.%ARGS%') DO (IF "%%b"=="COMMAND" SET "PARSE_X=1"&&SET "ARG4=%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"&&SET "ARGZ=5"&&CALL SET "ARGX=%%f"&&CALL:GET_ARGS)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED PARSE_X FOR /F "TOKENS=1-6* DELIMS= " %%a in ('ECHO.%ARG5%') DO (SET "ARG5=%%a"&&SET "ARG6=%%b"&&SET "ARG7=%%c"&&SET "ARG8=%%d"&&SET "ARG9=%%e")
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED PARSE_X SET "PARSE_X="&&FOR %%a in (5 6 7 8 9) DO (SET "CAPS_SET=ARG%%a"&&CALL SET "CAPS_VAR=%%ARG%%a%%"&&CALL:CAPS_SET)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 SET "DELETE_DONE=1"&&SET "ARG3=-LIST"&&SET "ARG4=$LIST"&&ECHO.MENU-SCRIPT>"%ListFolder%\$LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 ECHO.%ARG4%>"%ListFolder%\$LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-PACK" IF DEFINED ARG4 IF EXIST "%PackFolder%\%ARG4%" SET "$PACK_FILE=%PackFolder%\%ARG4%"&&SET "$LISTPACK=%ARG4%"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ARG4 IF EXIST "%ListFolder%\%ARG4%" SET "$LIST_FILE=%ListFolder%\%ARG4%"&&SET "$LISTPACK=%ARG4%"
IF NOT DEFINED $LISTPACK GOTO:COMMAND_IMAGEMGR_END
IF "%ARG2%"=="-RUN" FOR %%G in ("%$LISTPACK%") DO (SET "CAPS_SET=IMAGEMGR_EXT"&&SET "CAPS_VAR=%%~xG"&&CALL:CAPS_SET)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF "%IMAGEMGR_EXT%"==".BASE" SET "BASE_EXEC=1"&&CALL:LIST_VIEWER&SET "IMAGEMGR_EXT=.LIST"&SET "$HEAD=MENU-SCRIPT"&SET "$LISTPACK=$LIST"&SET "$LIST_FILE=%ListFolder%\$LIST"&IF "%FOLDER_MODE%"=="ISOLATED" MOVE /Y "$LIST" "%ListFolder%">NUL 2>&1
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ERROR GOTO:COMMAND_IMAGEMGR_END
IF "%ARG2%"=="-RUN" IF DEFINED MENU_SESSION SET "ARG5=-MENU"
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-LIVE" SET "CURR_TARGET=LIVE_APPLY"&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-MENU" SET "CURR_TARGET=LIVE_APPLY"&&SET "MENU_SESSION=1"&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF DEFINED ARG6 IF EXIST "%ARG6%" SET "CURR_TARGET=PATH_APPLY"&&SET "INPUT=%ARG6%"&&SET "OUTPUT=TARGET_PATH"&&CALL:SLASHER&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-VHDX" IF DEFINED ARG6 IF EXIST "%ImageFolder%\%ARG6%" SET "CURR_TARGET=VDISK_APPLY"&&SET "$VDISK_FILE=%ImageFolder%\%ARG6%"&&CALL:IMAGEMGR_EXECUTE_COMMAND
:COMMAND_IMAGEMGR_END
IF DEFINED DELETE_DONE DEL /Q /F "%ListFolder%\%DELETE_DONE%">NUL 2>&1
SET "DELETE_DONE="
EXIT /B
:IMAGEMGR_EXECUTE_COMMAND
IF "%CURR_TARGET%"=="PATH_APPLY" IF "%TARGET_PATH%"=="%SYSTEMDRIVE%" SET "CURR_TARGET=LIVE_APPLY"
SET "PATH_APPLY="&&SET "LIVE_APPLY="&&SET "VDISK_APPLY="&&SET "%CURR_TARGET%=1"
FOR %%G in ("%$LISTPACK%") DO (SET "CAPS_SET=IMAGEMGR_EXT"&&SET "CAPS_VAR=%%~xG"&&CALL:CAPS_SET)
IF "%$LISTPACK%"=="$LIST" SET "IMAGEMGR_EXT=.LIST"
IF "%IMAGEMGR_EXT%"==".LIST" SET "CURR_SESSION=EXEC"&&CALL:LIST_EXEC
IF "%IMAGEMGR_EXT%"==".PKX" SET "CURR_SESSION=PACK"&&CALL:PKX_EXEC
SET "%CURR_TARGET%="&&IF "%PROG_MODE%"=="GUI" CALL:PAUSED
FOR %%▓ in (CURR_SESSION CURR_TARGET TARGET_PATH PATH_APPLY LIVE_APPLY VDISK_APPLY) DO (SET "%%▓=")
EXIT /B
:COMMAND_DISKMGR
SET "$PASS="&&FOR %%▓ in (DISKLIST INSPECT ERASE CHANGEUID CREATE FORMAT DELETE MOUNT UNMOUNT) DO (IF "%ARG2%"=="-%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.ERROR: ARG2 not -DISKLIST, -INSPECT, -ERASE, -CREATE, -FORMAT, -DELETE, -MOUNT, or -UNMOUNT&&EXIT /B
IF DEFINED ARG2 IF "%ARG3%"=="-DISKUID" IF DEFINED ARG4 SET "DISK_TARGET=%ARG4%"&&CALL:DISK_DETECT>NUL 2>&1
IF DEFINED ARG2 IF "%ARG3%"=="-DISKUID" IF DEFINED ARG4 SET "ARG3=-DISK"&&SET "ARG4=%DISK_DETECT%"
IF DEFINED ARG2 IF "%ARG3%"=="-DISK" IF "%DISK_TARGET%"=="00000000" ECHO.%COLOR4%ERROR:%$$% Disk uid 00000000 can not be addressed by uid. Convert to GPT first (erase).&&EXIT /B
IF "%ARG3%"=="-DISK" IF DEFINED ARG4 CALL:DISK_DETECT>NUL 2>&1
IF "%ARG2%"=="-LIST" CALL:DISK_LIST
IF "%ARG2%"=="-INSPECT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&CALL:DISKMGR_INSPECT
IF "%ARG2%"=="-ERASE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&SET "$GET=TST_LETTER"&&CALL:LETTER_ANY&&CALL:DISKMGR_ERASE&SET "TST_LETTER="
IF "%ARG2%"=="-CHANGEUID" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&SET "GET_DISK_ID=%ARG5%"&&CALL:DISKMGR_CHANGEID
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-SIZE"  IF DEFINED ARG6 SET "PART_SIZE=%ARG6%"&&CALL:DISKMGR_CREATE
IF "%ARG2%"=="-FORMAT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&CALL:DISKMGR_FORMAT
IF "%ARG2%"=="-DELETE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&CALL:DISKMGR_DELETE
IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF "%ARG5%"=="-PART" IF DEFINED ARG6 SET "PART_NUMBER=%ARG6%"&&IF "%ARG7%"=="-LETTER" IF DEFINED ARG8 SET "DISK_LETTER=%ARG8%"&&CALL:DISKMGR_MOUNT
IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-VHDX" IF EXIST "%ImageFolder%\%ARG4%" SET "$VDISK_FILE=%ImageFolder%\%ARG4%"&&IF "%ARG5%"=="-LETTER" IF DEFINED ARG6 SET "VDISK_LTR=%ARG6%"&&CALL:VDISK_ATTACH
IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-VHDX" IF EXIST "%ImageFolder%\%ARG4%" IF "%ARG5%"=="-LETTER" IF DEFINED ARG6 IF "%ARG7%"=="-HIVE" SET "TARGET_PATH=%VDISK_LTR%:"&&CALL:MOUNT_EXT
IF "%ARG2%"=="-UNMOUNT" IF "%ARG3%"=="-LETTER" IF DEFINED ARG4 IF "%ARG5%"=="-HIVE" CALL:MOUNT_INT
IF "%ARG2%"=="-UNMOUNT" IF "%ARG3%"=="-LETTER" IF DEFINED ARG4 SET "$LTR=%ARG4%"&&CALL:DISKMGR_UNMOUNT
EXIT /B
:COMMAND_BOOTCREATOR
IF "%ARG2%"=="-CREATE" IF NOT EXIST "%CacheFolder%\BOOT.SAV" ECHO.%COLOR4%ERROR:%$$% Boot media %CacheFolder%\boot.sav doesn't exist&&EXIT /B
IF DEFINED ARG2 IF "%ARG3%"=="-DISKUID" IF DEFINED ARG4 SET "DISK_TARGET=%ARG4%"&&CALL:DISK_DETECT>NUL 2>&1
IF DEFINED ARG2 IF "%ARG3%"=="-DISKUID" IF DEFINED ARG4 SET "ARG3=-DISK"&&SET "ARG4=%DISK_DETECT%"
IF DEFINED ARG2 IF "%ARG3%"=="-DISK" IF "%DISK_TARGET%"=="00000000" ECHO.%COLOR4%ERROR:%$$% Disk uid 00000000 can not addressed by uid. Convert to GPT first (erase).&&EXIT /B
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-DISK" IF DEFINED ARG4 SET "DISK_NUMBER=%ARG4%"&&IF DEFINED ARG6 SET "VHDX_SLOTX=%ARG6%"&&CALL:BOOT_CREATOR_START
EXIT /B
:COMMAND_HELP
ECHO. Command Line Parameters:
ECHO.   %##%Miscellaneous%$$%
ECHO.   -help                                                           This menu
ECHO.   -nextboot -vhdx                                                 Schedule next boot to vhdx
ECHO.   -nextboot -recovery                                             Schedule next boot to recovery
ECHO.   -autoboot -install                                              Install reboot to recovery switcher service
ECHO.   -autoboot -remove                                               Remove reboot to recovery switcher service
ECHO.   %##%Image Processing%$$%
ECHO.   -imageproc -wim %@@%x.wim%$$% -index %@@%#%$$% -vhdx %@@%x.vhdx%$$% -size %@@%GB%$$%
ECHO.   -imageproc -vhdx %@@%x.vhdx%$$% -index %@@%#%$$% -wim %@@%x.wim%$$% -xlvl %@@%fast/max%$$%
ECHO. Examples-
ECHO.   %@@%-imageproc -wim x.wim -index 1 -path "c:\abc"%$$%
ECHO.   %@@%-imageproc -path "c:\abc" -wim x.wim -xlvl fast%$$%
ECHO.   %@@%-imageproc -wim x.wim -index 1 -vhdx x.vhdx -size 25%$$%
ECHO.   %@@%-imageproc -vhdx x.vhdx -index 1 -wim x.wim -xlvl fast%$$%
ECHO.   %##%Image Management%$$%
ECHO.   -imagemgr -run -list %@@%x.list%$$% -live /or/ -vhdx /or/ -path /or/ -menu%$$%
ECHO.   -imagemgr -run -item %@@%"%U00%x%U00%x%U00%x%U00%x%U00%"%$$% -live /or/ -vhdx %@@%x.vhdx%$$%
ECHO.   -imagemgr -run -pack %@@%x.pkx%$$% -live /or/ -vhdx /or/ -path /or/ -menu%$$%
ECHO.   -imagemgr -create -base %@@%x.base%$$% -live /or/ -vhdx %@@%x.vhdx%$$%
ECHO. Examples-
ECHO.   %@@%-imagemgr -run -list "x y z.list" -live%$$%
ECHO.   %@@%-imagemgr -run -pack x.pkx -vhdx x.vhdx%$$%
ECHO.   %@@%-imagemgr -run -item "%U00%EXTPACKAGE%U00%x y z.appx%U00%INSTALL%U00%DX%U00%" -vhdx x.vhdx%$$%
ECHO.   %@@%-imagemgr -run -list "x y z.list" -menu%$$%
ECHO.   %@@%-imagemgr -create -base x.base -live "1 2 3 4 5 6 7"%$$%
ECHO.   %@@%-imagemgr -create -base x.base -vhdx x.vhdx "1 2 3 4 5 6 7"%$$%
ECHO.   %##%File Management%$$%
ECHO.   -filemgr -grant %@@%file/folder%$$%
ECHO. Examples-
ECHO.   %@@%-filemgr -grant c:\x.txt%$$%
ECHO.   %##%Disk Management%$$%
ECHO.   -diskmgr -list                                                  Condensed list of disks
ECHO.   -diskmgr -inspect -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$%                     DiskPart inquiry on specified disk
ECHO.   -diskmgr -erase -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$%                       Delete all partitions on specified disk
ECHO.   -diskmgr -create -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% -size %@@%GB%$$%             Create NTFS partition on specified disk
ECHO.   -diskmgr -format -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% -part %@@%#%$$%              Format partition w/NTFS on specified disk
ECHO.   -diskmgr -delete -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% -part %@@%#%$$%              Delete partition on specified disk
ECHO.   -diskmgr -changeuid -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% %@@%new-uid%$$%           Change disk uid of specified disk
ECHO.   -diskmgr -mount -disk %@@%#%$$% /or/ -diskuid %@@%uid%$$% -part %@@%#%$$% -letter %@@%letter%$$%         Assign drive letter
ECHO.   -diskmgr -unmount -letter %@@%letter%$$%                                         Remove drive letter
ECHO.   -diskmgr -mount -vhdx %@@%x.vhdx%$$% -letter %@@%letter%$$%                              Mount virtual disk
ECHO. Examples-
ECHO.   %@@%-diskmgr -create -disk 0 -size 25%$$%
ECHO.   %@@%-diskmgr -mount -disk 0 -part 1 -letter e%$$%
ECHO.   %@@%-diskmgr -unmount -letter e%$$%
ECHO.   %##%BootDisk Creator%$$%
ECHO.   -bootcreator -create -disk %@@%#%$$% -vhdx %@@%x.vhdx%$$%                         Erase specified disk and make bootable
ECHO.   -bootcreator -create -diskuid %@@%uid%$$% -vhdx %@@%x.vhdx%$$%                    Erase specified disk and make bootable
ECHO. Examples-
ECHO.   %@@%-bootcreator -create -disk 0 -vhdx x.vhdx%$$%
ECHO.   %@@%-bootcreator -create -diskuid 12345678-1234-1234-1234-123456781234 -vhdx x.vhdx
ECHO.
EXIT /B
:BASE_EXAMPLE
ECHO.MENU-SCRIPT
ECHO.❗* BUILDER EXECUTION INTERACTIVE LIST ITEMS *❗
ECHO.
ECHO.❕Table❕ⓠ: Execution item, suppresses announcement - ⓡ: Reference item, no announcement❕
ECHO.❕Note❕List items without a 'ⓠ' or 'ⓡ' prefix are processed as execution❕
ECHO.
ECHO.❕Group❕🪟 Builder interactive items❕🪛 Choice item❕Normal❕
ECHO.Note: Choice Item. Choice1-9 are valid. Up to 9 choices seperated by '❗'
ECHO.❕ⓠChoice1❕Select an option❕✅ Option 1 selected❗❎ Option 2 selected❗❎ Option 3 selected❕VolaTILE❕
ECHO.❕ⓠTextHost❕Choice1-S:◁Choice1.S▷ Choice1-I:◁Choice1.I▷ Choice1-1:◁Choice1.1▷ Choice1-2:◁Choice1.2▷ Choice1-3:◁Choice1.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Group:◁Group▷ SubGroup:◁SubGroup▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟 Builder interactive items❕🪛 Prompt item❕Normal❕

ECHO.❕Note❕Prompt Item. PROMPT1-9 are valid. Prompt filter NUMBER, LETTER, ALPHA, MENU, MOST, and NONE are usable options. Minimum and maximum character limit are optional.❕
ECHO.
ECHO.❕ⓠPrompt1❕Enter text❕Alpha❗3-20❕VolaTILE❕
ECHO.❕ⓠTextHost❕ⓠPrompt1-S:◁Prompt1.S▷ Prompt1-I:◁Prompt1.I▷ Prompt1-1:◁Prompt1.1▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟 Builder interactive items❕🪛 Picker item❕Normal❕
ECHO.Note: Picker Item. Picker1-9 are valid. ◁ImageFolder▷, ◁ListFolder▷, ◁PackFolder▷, ◁CacheFolder▷, and ◁ProgFolder▷ are usable options.
ECHO.❕ⓠPicker1❕Select a file❕◁ImageFolder▷❗*.wim❕VolaTILE❕
ECHO.❕ⓠTextHost❕Picker1-S:◁Picker1.S▷ Picker1-I:◁Picker1.I▷ Picker1-1:◁Picker1.1▷❕Screen❕DX❕
ECHO.
ECHO.
ECHO.❗* BUILDER EXECUTION NON-INTERACTIVE LIST ITEMS *❗
ECHO.
ECHO.❕Group❕🪟 Builder non-interactive items❕🪛 Condit item❕Normal❕
ECHO.Note: Condit Item. Condit1-9 are valid. DEFINED, NDEFINED, EXIST, NEXIST, EQ, NE, GE, LE, LT, and GT are usable options. Enter ◁Null▷ into the 4th column if 'else' is not needed.
ECHO.❕ⓠCondit1❕◁WinTar▷❗Exist❕WinTar Exists❕◁Null▷❕
ECHO.❕ⓠCondit2❕◁Choice1.I▷❗EQ❗1❕Choice 1 index equals 1❕Choice 1 index does not equal 1❕
ECHO.❕ⓠTextHost❕Condit1-S:◁Condit1.S▷ Condit1-I:◁Condit1.I▷ Condit1-1:◁Condit1.1▷ Condit1-2:◁Condit1.2▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Condit2-S:◁Condit2.S▷ Condit2-I:◁Condit2.I▷ Condit2-1:◁Condit2.1▷ Condit2-2:◁Condit2.2▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟 Builder non-interactive items❕🪛 Array item❕Normal❕
ECHO.Note: Array items are similar to a condit item, except it's always 'EQ' and is an array of IF's. Optional 5th column adds 'else' function.
ECHO.❕ⓠArray1❕a❕a❗b❗c❕✅ A1 Option 1 selected❗✅ A1 Option 2 selected❗✅ A1 Option 3 selected❕
ECHO.❕ⓠArray2❕1❕1❗2❗3❕✅ A2 0ption 1 selected❗✅ A2 Option 2 selected❗✅ A2 Option 3 selected❕✅ A2 Option 1 else selected❗✅ A2 0ption 2 else selected❗✅ A2 Option 3 else selected❕
ECHO.❕ⓠTextHost❕Array1-S:◁Array1.S▷ Array1-I:◁Array1.I▷ Array1-1:◁Array1.1▷ Array1-2:◁Array1.2▷ Array1-3:◁Array1.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Array2-S:◁Array2.S▷ Array2-I:◁Array2.I▷ Array2-1:◁Array2.1▷ Array2-2:◁Array2.2▷ Array2-3:◁Array2.3▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟 Builder non-interactive items❕🪛 Math item❕Normal❕
ECHO.Note: Math item. MATH1-9 are valid. +, -, /, and * are usable options.
ECHO.❕ⓠMath1❕1❕*❕5❕
ECHO.❕ⓠTextHost❕Math1-S:◁Math1.S▷ Math1-I:◁Math1.I▷ Math1-1:◁Math1.1▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟 Builder non-interactive items❕🪛 String item❕Normal❕
ECHO.Note: String item. String1-9 are valid. STRING and INTEGER are usable options.
ECHO.❕ⓠString1❕10❗20❗30❗40❗50❕Integer❕3❕
ECHO.❕ⓠString2❕A❗B❗C❗D❗E❕String❕2❕
ECHO.❕ⓠTextHost❕String1-S:◁String1.S▷ String1-I:◁String1.I▷ String1-1:◁String1.1▷ String1-2:◁String1.2▷ String1-3:◁String1.3▷ String1-4:◁String1.4▷ String1-5:◁String1.5▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕String2-S:◁String2.S▷ String2-I:◁String2.I▷ String2-1:◁String2.1▷ String2-2:◁String2.2▷ String2-3:◁String2.3▷ String2-4:◁String2.4▷ String2-5:◁String2.5▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟 Builder non-interactive items❕🪛 Routine item❕Normal❕
ECHO.Note: Routine items are loop based. Routine1-9 are valid. COMMAND and SPLIT are usable options. Optional column# match seperated by '❗'.
ECHO.❕ⓠRoutine1❕^<^>:❗DIR /B C:\❗1❗Program Files❕Command❕1❕
ECHO.❕ⓠRoutine2❕:❗A:B:C❗3❗C❕Split❕2❕
ECHO.❕X❕ⓠRoutine1❕^<^>:❗DIR /B C:\❕Command❕1❕
ECHO.❕X❕ⓠRoutine2❕:❗A:B:C❕Split❕2❕
ECHO.❕ⓠTextHost❕Routine1-S:◁Routine1.S▷ Routine1-I:◁Routine1.I▷  Routine1-1:◁Routine1.1▷ Routine1-2:◁Routine1.2▷ Routine1-3:◁Routine1.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Routine2-S:◁Routine2.S▷ Routine2-I:◁Routine2.I▷  Routine2-1:◁Routine2.1▷ Routine2-2:◁Routine2.2▷ Routine2-3:◁Routine2.3▷❕Screen❕DX❕
ECHO.
ECHO.
ECHO.❗* BUILDER REFERENCE LIST ITEMS EXAMPLE *❗
ECHO.
ECHO.❕Group❕🎨 Reference Example❕🎨Theme ➥ ◁Array1.S▷❕Normal❕
ECHO.❕ⓡRoutine1❕ ❗reg.exe query "◁HiveUser▷\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme"❗1❗AppsUseLightTheme❕Command❕3❕
ECHO.❕ⓡArray1❕◁Routine1.S▷❕0x0❗0x1❕🌑Dark❗🌕Light❕
ECHO.❕ⓠChoice1❕Select an option❕🌕Light theme❗🌑Dark theme❕VolaTILE❕
ECHO.❕ⓠArray1❕◁Choice1.I▷❕1❗2❕1❗0❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize❗AppsUseLightTheme❗◁Array1.S▷❗Dword❕Create❕DX❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize❗SystemUsesLightTheme❗◁Array1.S▷❗Dword❕Create❕DX❕
ECHO.❕ⓠTextHost❕◁Choice1.S▷ applied.❕Screen❕DX❕
ECHO.
ECHO.
ECHO.❗* EXECUTION LIST ITEMS *❗
ECHO.
ECHO.❕Group❕🪟 Execution items❕🪛 Command item❕Normal❕
ECHO.Note: Command item. 'NORMAL', 'NOMOUNT', 'NORMAL❗RAU', 'NORMAL❗RAS', 'NORMAL❗RATI', 'NOMOUNT❗RAU', 'NOMOUNT❗RAS', or 'NOMOUNT❗RATI' are usable options.
ECHO.❕ⓠTextHost❕testing 1 2 3.❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟 Execution items❕🪛 Registry create item❕Normal❕
ECHO.Note: Registry item. 'CREATE', 'DELETE', 'CREATE❗RAU', 'CREATE❗RAS', 'CREATE❗RATI', 'DELETE❗RAU', 'DELETE❗RAS', or 'DELETE❗RATI' are usable options. DWORD, QWORD, BINARY, STRING, EXPAND, and MULTI are usable options.
ECHO.
ECHO.Note: Registry item create 'key'.
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❕Create❕DX❕
ECHO.Note: Registry item create 'value'.
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗◁Null▷❗TestData❗String❕Create❕DX❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗TestValue❗◁Null▷❗String❕Create❕DX❕
ECHO.Note: Registry item delete 'value'.
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗TestValue❕Delete❕DX❕
ECHO.Note: Registry item delete 'key'.
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❕Delete❕DX❕
ECHO.
ECHO.❕Group❕🪟 Execution items❕🪛 FileOper item❕Normal❕
ECHO.Note: FileOper item. CREATE, DELETE, RENAME, COPY, MOVE, and TAKEOWN are usable options.
ECHO.Note: FileOper item create 'folder'.
ECHO.❕ⓠFileOper❕c:\test❕Create❕DX❕
ECHO.Note: FileOper item move.
ECHO.❕ⓠTextHost❕test❕File❗c:\testmove.txt❕DX❕
ECHO.❕ⓠFileOper❕testmove.txt❗c:\test❕Move❕DX❕
ECHO.
ECHO.❕Group❕🪟 Execution items❕🪛 Session item + TextHost item❕Normal❕
ECHO.❕ⓠTextHost❕MENU-SCRIPT❕File❗◁ListFolder▷\testlist.list❕DX❕
ECHO.❕ⓠTextHost❕◁U00▷ⓠTextHost◁U00▷Greetings from session 2◁U00▷Screen◁U00▷DX◁U00▷❕File❗◁ListFolder▷\testlist.list❕DX❕
ECHO.Note: Using the '-PATH "◁DrvTar▷"' parameter during an active session will reuse the active session's target.
ECHO.❕ⓠSession❕-IMAGEMGR -RUN -LIST "testlist.list" -PATH "◁DrvTar▷"❕◁Null▷❕DX❕
ECHO.❕ⓠTextHost❕End of session 1❕Screen❕DX❕
ECHO.❕ⓠFileOper❕◁ListFolder▷\testlist.list❕Delete❕DX❕
ECHO.
ECHO.❕Group❕🪟Miscellaneous Examples❕Items being used in conjunction❕Normal❕
ECHO.❕ⓠChoice1❕Select an option❕🪛 Choice A❗🪛 Choice B❗🪛 Choice C❗❕VolaTILE❕
ECHO.❕ⓠArray1❕◁Choice1.I▷❕1❗2❗3❕A❗B❗C❕
ECHO.❕ⓠArray2❕◁Array1.S▷❕A❗B❗C❕DX❗DX❗DX❕
ECHO.❕ⓠTextHost❕Choice ◁Array2.S▷ picked.❕Screen❕◁Array2.1▷❕
ECHO.❕ⓠTextHost❕Choice ◁Array2.S▷ picked.❕Screen❕◁Array2.2▷❕
ECHO.❕ⓠTextHost❕Choice ◁Array2.S▷ picked.❕Screen❕◁Array2.3▷❕
EXIT /B
:MENU_EXAMPLE_BASE
ECHO.MENU-SCRIPT
ECHO.❗* This is an example of a custom menu for recovery *❗
ECHO.
ECHO.❕Group❕Recovery Operation Example❕Backup picked vhdx to backup.wim❕Normal❕
ECHO.❕ⓠPicker1❕Select a vhdx to backup❕◁ProgFolder▷❗*.vhdx❕VolaTILE❕
ECHO.❕ⓠCondit1❕◁ProgFolder▷\◁Picker1.S▷❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕◁ProgFolder▷\◁Picker1.S▷ does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting backup.wim❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ImageFolder▷\backup.wim❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -vhdx "◁Picker1.S▷" -index 1 -wim "backup.wim" -size 25❕◁Null▷❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
ECHO.
ECHO.❕Group❕Recovery Operation Example❕Restore picked wim to current.vhdx❕Normal❕
ECHO.❕ⓠPicker1❕Select a wim to restore❕◁ImageFolder▷❗*.wim❕VolaTILE❕
ECHO.❕ⓠCondit1❕◁ProgFolder▷\◁Picker1.S▷❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕◁ImageFolder▷\◁Picker1.S▷ does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting current.vhdx❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ProgFolder▷\current.vhdx❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -wim "◁Picker1.S▷" -index 1 -vhdx "current.vhdx" -size 25❕◁Null▷❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
EXIT /B
:MENU_EXAMPLE_EXEC
ECHO.MENU-SCRIPT
ECHO.❗* This is an example of a reboot to restore scenerio as an execution list *❗
ECHO.
ECHO.❕ⓠCondit1❕◁ImageFolder▷\backup.wim❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕ECHO.◁ImageFolder▷\backup.wim does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting current.vhdx❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ProgFolder▷\current.vhdx❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -wim "backup.wim" -index 1 -vhdx "current.vhdx" -size 25❕◁Null▷❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
EXIT /B
:GET_INIT
SET "CMD=CMD.EXE"&&SET "DISM=DISM.EXE"&&SET "REG=REG.EXE"&&SET "BCDEDIT=BCDEDIT.EXE"
SET "ERROR="&&SET "MENU_EXIT="&&SET "SETS_LOAD="&&SET "GUI_ACTIVE="
SET "VER_GET=%~f0"&&CALL:GET_PROGVER&&CD /D "%~DP0"&&CHCP 65001>NUL
IF EXIST "%ProgFolder0%\$CON" SET "GUI_ACTIVE=1"&DEL /F /Q "%ProgFolder0%\$CON">NUL 2>&1
SET "ORIG_CD=%CD%"&&FOR /F "TOKENS=*" %%a in ("%CD%") DO (SET "CAPS_SET=ProgFolder0"&&SET "CAPS_VAR=%%a"&&CALL:CAPS_SET)
FOR /F "TOKENS=1-2 DELIMS=:" %%a IN ("%ProgFolder0%") DO (SET "CHAR_STR=%%b"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK&&IF "%%b"=="\" SET "ProgFolder0=%%a:")
IF DEFINED CHAR_FLG SET "ERROR=Remove the space from the path or folder name, then launch again."
IF NOT EXIST "%ProgFolder0%" SET "ERROR=Invalid path or folder name. Relocate, then launch again."
IF "%ProgFolder0%"=="X:\$" IF NOT "%SYSTEMDRIVE%"=="X:" SET "ERROR=Relocate to path other than X:\$."
IF "%ProgFolder0%"=="%SYSTEMDRIVE%\WINDOWS\SYSTEM32" SET "ERROR=Invalid path or folder name. Relocate, then launch again."
SET "PATH_TEMP="&&FOR /F "TOKENS=1-9 DELIMS=\" %%a IN ("%ProgFolder0%") DO (IF "%%a\%%b\%%c"=="%SystemDrive%\WINDOWS\TEMP" SET "PATH_TEMP=1"
IF "%%a\%%b\%%d\%%e\%%f"=="%SystemDrive%\USERS\APPDATA\LOCAL\TEMP" SET "PATH_TEMP=1")
IF DEFINED PATH_TEMP SET "ERROR=This should not be run from a temp folder. Extract zip into a new folder, then launch again."
%REG% query "HKU\S-1-5-19\Environment">NUL
IF NOT "%ERRORLEVEL%" EQU "0" SET "ERROR=Right click and run as administrator."
SET "LANG_PASS="&&FOR /F "TOKENS=4-5 DELIMS= " %%a IN ('DIR') DO (IF "%%a %%b"=="bytes free" SET "LANG_PASS=1")
IF NOT DEFINED LANG_PASS SET "ERR_MSG=Non-english host language/locale."
IF "%SYSTEMDRIVE%"=="X:" IF EXIST "X:\$\HOST_TARGET" SET "WINPE_BOOT=1"
IF DEFINED ERROR CALL ECHO.ERROR: %ERROR%&&PAUSE&&GOTO:QUIT
CALL:SESSION_CLEAR&CALL:GET_ARGS&CALL:GET_SID&CALL:MOUNT_INT
IF DEFINED ARG1 SET "PROG_MODE=COMMAND"&&GOTO:COMMAND_MODE
IF NOT "%ProgFolder0%"=="X:\$" SET "PROG_MODE=PORTABLE"&&CALL:SETS_HANDLER&&GOTO:MAIN_MENU
IF "%ProgFolder0%"=="X:\$" IF "%SystemDrive%"=="X:" SET "PROG_MODE=RAMDISK"
IF EXIST "%ProgFolder0%\RECOVERY_LOCK" CALL:RECOVERY_LOCK
IF DEFINED LOCKOUT GOTO:QUIT
CALL:HOST_AUTO&&CALL:SETS_HANDLER&&CALL:LOGO
%REG% DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\MiniNT" /f>NUL 2>&1
GOTO:MAIN_MENU
:GET_FILEPATH
FOR %%G in ("%$GET_FILEPATH%") DO (SET "$PATH=%%~dG%%~pG"&&SET "$BODY=%%~nG"&&SET "$EXT=%%~xG")
SET "$GET_FILEPATH="&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "$PATH=%%$PATH:%%G=%%G%%"&&CALL SET "$BODY=%%$BODY:%%G=%%G%%"&&CALL SET "$EXT=%%$EXT:%%G=%%G%%")
EXIT /B
:GET_ARGS
FOR %%1 in (1 2 3 4 5 6 7 8 9) DO (IF DEFINED ARG%%1 SET "ARGZ=%%1"&&CALL SET "ARGX=%%ARG%%1%%"&&CALL:GET_ARGSX)
IF DEFINED ARG1 FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
FOR %%1 in (1 2 3 4 5 6 7 8 9) DO (IF DEFINED ARG%%1 CALL SET "ARG%%1=%%ARG%%1:%%G=%%G%%"))
EXIT /B
:GET_ARGSX
CALL SET "ARG%ARGZ%=%ARGX:"=%"
CALL SET "ARG%ARGZ%X=%ARGX:"=%"
EXIT /B
:GET_BYTES
FOR %%a in (INPUT OUTPUT) DO (IF NOT DEFINED %%a EXIT /B)
SET "%OUTPUT%="&&SET "XNT=0"&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%INPUT%^| FIND /V ""') do (SET "CHAR=%%G"&&SET /A "XNT+=1"&&CALL:CHAR_XNT)
GOTO:GET_BYTES_%GET_BYTES%
:GET_BYTES_GB
IF %XNT% LSS 10 SET /A "%OUTPUT%=0"
IF "%XNT%"=="10" SET /A "%OUTPUT%=%CHAR1%"
IF "%XNT%"=="11" SET /A "%OUTPUT%=%CHAR1%%CHAR2%"
IF "%XNT%"=="12" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%"
IF "%XNT%"=="13" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%"
IF "%XNT%"=="14" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%"
IF "%XNT%"=="15" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%"
IF "%XNT%"=="16" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%"
GOTO:GET_BYTES_END
:GET_BYTES_MB
IF %XNT% LSS 7 SET /A "%OUTPUT%=0"
IF "%XNT%"=="7" SET /A "%OUTPUT%=%CHAR1%"
IF "%XNT%"=="8" SET /A "%OUTPUT%=%CHAR1%%CHAR2%"
IF "%XNT%"=="9" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%"
IF "%XNT%"=="10" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%"
IF "%XNT%"=="11" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%"
IF "%XNT%"=="12" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%"
IF "%XNT%"=="13" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%"
IF "%XNT%"=="14" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%%CHAR8%"
IF "%XNT%"=="15" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%%CHAR8%%CHAR9%"
IF "%XNT%"=="16" SET /A "%OUTPUT%=%CHAR1%%CHAR2%%CHAR3%%CHAR4%%CHAR5%%CHAR6%%CHAR7%%CHAR8%%CHAR9%%CHAR10%"
:GET_BYTES_END
FOR %%a in (1 2 3 4 5 6 7 8 9 10) DO (SET "CHAR%%a=")
SET "INPUT="&&SET "OUTPUT="&&SET "CHAR="&&SET "GET_BYTES="&&EXIT /B
:CHAR_XNT
IF %XNT% GTR 10 EXIT /B
SET "CHAR%XNT%=%CHAR%"
EXIT /B
:GET_FREE_SPACE
FOR %%a in (INPUT OUTPUT) DO (IF NOT DEFINED %%a EXIT /B)
SET "%OUTPUT%="&&FOR /F "TOKENS=1-5 DELIMS= " %%a IN ('DIR "%INPUT%\" 2^>NUL') DO (SET "OUTPUTX=%%c")
IF NOT DEFINED OUTPUTX SET "%OUTPUT%=ERROR"&&SET "OUTPUT="&&SET "INPUT="&&SET "ERROR=GET_FREE_SPACE"&&CALL:DEBUG&&EXIT /B
SET "%OUTPUT%=%OUTPUTX:,=%"
CALL SET "CHECK_VAR=%%%OUTPUT%%%"&&SET "$CHECK=NUMBER"&&CALL:CHECK
IF NOT DEFINED ERROR CALL SET "INPUT=%%%OUTPUT%%%"&&CALL:GET_BYTES
SET "OUTPUT="&&SET "OUTPUTX="&&SET "INPUT="&&EXIT /B
:GET_SPACE_ENV
SET "FREE="&&FOR /F "TOKENS=1-5 DELIMS= " %%a IN ('DIR "%ProgFolder%\"') DO (SET "FREE=%%c")
IF DEFINED FREE SET "FREE=%FREE:,=%"
IF DEFINED FREE SET "GET_BYTES=GB"&&SET "INPUT=%FREE%"&&SET "OUTPUT=FREE"&&CALL:GET_BYTES
EXIT /B
:GET_FILESIZE
FOR %%a in (INPUT OUTPUT) DO (IF NOT DEFINED %%a EXIT /B)
SET "%OUTPUT%="&&FOR /F "TOKENS=1-5* SKIP=3 DELIMS= " %%a IN ('DIR "%INPUT%"') DO (IF NOT "%%e"=="" IF NOT DEFINED OUTPUTX SET "OUTPUTX=%%d")
IF NOT DEFINED OUTPUTX SET "%OUTPUT%=ERROR"&&SET "OUTPUT="&&SET "INPUT="&&SET "ERROR=GET_FILESIZE"&&CALL:DEBUG&&EXIT /B
SET "%OUTPUT%=%OUTPUTX:,=%"
CALL SET "CHECK_VAR=%%%OUTPUT%%%"&&SET "$CHECK=NUMBER"&&CALL:CHECK
IF NOT DEFINED ERROR CALL SET "INPUT=%%%OUTPUT%%%"&&CALL:GET_BYTES
SET "OUTPUT="&&SET "OUTPUTX="&&SET "INPUT="&&EXIT /B
:GET_FILEEXT
SET "$PATH_X="&&SET "$FILE_X="&&SET "$EXT_X="&&FOR %%G in ("%INPUT%") DO (SET "$PATH_X=%%~dG%%~pG"&&SET "$FILE_X=%%~nG"&&SET "$EXT_X=%%~xG")
SET "$CASE=UPPER"&&SET "CAPS_SET=EXT_UPPER"&&SET "CAPS_VAR=%$EXT_X%"&&CALL:CAPS_SET
SET "INPUT="&&EXIT /B
:GET_SID
FOR /F "TOKENS=2* SKIP=1 DELIMS=:\. " %%a in ('%REG% QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUser 2^>NUL') do (IF "%%a"=="REG_SZ" SET "UsrNam=%%b")
FOR /F "TOKENS=2* SKIP=1 DELIMS=:\. " %%a in ('%REG% QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUserSID 2^>NUL') do (IF "%%a"=="REG_SZ" SET "UsrSid=%%b")
SET "ERRORLEVEL=0"&&EXIT /B
:GET_NEXTBOOT
SET "BOOT_OK="&&SET "GUID_TMP="&&SET "GUID_CUR="&&FOR /F "TOKENS=1-5 DELIMS= " %%a in ('%BCDEDIT% /V') do (
IF "%%a"=="displayorder" SET "GUID_CUR=%%b"
IF "%%a"=="identifier" SET "GUID_TMP=%%b"
IF "%%a"=="description" IF "%%b"=="Recovery" SET "BOOT_OK=1"&&GOTO:GET_NEXTBOOTX)
:GET_NEXTBOOTX
IF "%GUID_TMP%"=="%GUID_CUR%" SET "NEXT_BOOT=RECOVERY"
IF NOT "%GUID_TMP%"=="%GUID_CUR%" SET "NEXT_BOOT=VHDX"
EXIT /B
:GET_WIMINDEX
IF NOT DEFINED $IMAGE_X EXIT /B
FOR /F "TOKENS=1-5 SKIP=5 DELIMS=:<> " %%a in ('%DISM% /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"%$IMAGE_X%" 2^>NUL') DO (IF "%%a"=="Index" SET "INDEX_Z=%%b"
IF "%%d"=="%INDEX_WORD%" SET "INDEX_WORD="&&SET "$IMAGE_X="&&EXIT /B)
SET "INDEX_WORD="&&SET "INDEX_Z="&&SET "$IMAGE_X="&&EXIT /B
:GET_PATHINFO
FOR %%a in ($PATHEDIT $PATHVER) DO (IF DEFINED %%a SET "%%a=")
IF "%$PATH_X%"=="%SYSTEMDRIVE%" SET "$IMAGE_X=ONLINE"
IF "%$PATH_X%"=="%SYSTEMDRIVE%\" SET "$IMAGE_X=ONLINE"
IF NOT "%$IMAGE_X%"=="ONLINE" SET "$IMAGE_X=IMAGE:"%$PATH_X%""
FOR /F "TOKENS=1-2* DELIMS=<>: " %%a in ('%DISM% /ENGLISH /%$IMAGE_X% /GET-CURRENTEDITION 2^>NUL') DO (IF "%%a %%b"=="Image Version" IF NOT "%%c"=="undefined>" SET "$PATHVER=%%c"
IF "%%a %%b"=="Current Edition" IF NOT "%%c"=="undefined>" SET "$PATHEDIT=%%c")
IF NOT DEFINED $PATHVER SET "ERROR=GET_PATHINFO"&&CALL:DEBUG
SET "$PATH_X="&&SET "$IMAGE_X="&&EXIT /B
:GET_IMAGEINFO
FOR %%a in ($IMGNAME $IMGEDIT $IMGDESC $IMGVER $BUILD) DO (IF DEFINED %%a SET "%%a=")
FOR /F "TOKENS=1-2* SKIP=3 DELIMS=:<> " %%a in ('%DISM% /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"%$IMAGE_X%" /Index:%INDEX_X% 2^>NUL') DO (
IF "%%a"=="Name" IF NOT "%%b"=="undefined" IF NOT "%%c"=="" SET "$IMGNAME=%%b %%c"
IF "%%a"=="Name" IF NOT "%%b"=="undefined" IF "%%c"=="" SET "$IMGNAME=%%b"
IF "%%a"=="Description" IF NOT "%%b"=="undefined" IF NOT "%%c"=="" SET "$IMGDESC=%%b %%c"
IF "%%a"=="Description" IF NOT "%%b"=="undefined" IF "%%c"=="" SET "$IMGDESC=%%b"
IF "%%a"=="Version" IF NOT "%%b"=="undefined" SET "$IMGVER=%%b"
IF "%%a"=="Edition" IF NOT "%%b"=="undefined" SET "$IMGEDIT=%%b"
IF "%%a %%b"=="ServicePack Build" IF NOT "%%c"=="undefined>" SET "$BUILD=%%c")
IF DEFINED $IMGVER IF DEFINED $BUILD SET "$IMGVER=%$IMGVER%.%$BUILD%"&&SET "$BUILD="
IF NOT DEFINED $IMGVER SET "ERROR=GET_IMAGEINFO"&&CALL:DEBUG
SET "$IMAGE_X="&&SET "INDEX_X="&&EXIT /B
:GET_PROGVER
IF NOT DEFINED VER_SET SET "VER_SET=VER_CUR"
IF EXIST "%VER_GET%" SET /P VER_CHK=<"%VER_GET%"
SET "%VER_SET%="&&FOR /F "TOKENS=1-9 DELIMS= " %%A IN ("%VER_CHK%") DO (SET "%VER_SET%=%%I")
IF NOT DEFINED %VER_SET% SET "ERROR=GET_PROGVER"&&CALL:DEBUG
SET "VER_CHK="&&SET "VER_GET="&&SET "VER_SET="&&EXIT /B
:GET_HEADER
SET "$HEAD="&&FOR %%a in ($HEAD_CHECK) DO (IF NOT DEFINED %%a EXIT /B)
SET /P $HEAD=<"%$HEAD_CHECK%"
IF NOT DEFINED $HEAD SET "ERROR=HEADER"&&GOTO:HEADER_SKIP
FOR /F "TOKENS=1-9 DELIMS= " %%a IN ("!$HEAD!") DO (IF "%%a"=="MENU-SCRIPT" SET "$HEAD=MENU-SCRIPT"
IF NOT "%%b"=="" FOR %%◌ in (%%a %%b %%c %%d %%e %%f %%g %%h) DO (IF "%%◌"=="MENU" SET "MENU_SESSION=1"))
IF NOT "!$HEAD!"=="MENU-SCRIPT" SET "ERROR=HEADER"&&ECHO.%COLOR2%ERROR:%$$% Header is not MENU-SCRIPT, check file.
:HEADER_SKIP
IF DEFINED ERROR IF "%DEBUG%"=="ENABLED" CALL:DEBUG
SET "$HEAD_CHECK="&&EXIT /B
:GET_RANDOM
IF NOT DEFINED RND_TYPE SET "RND_TYPE=1"
CALL:RND%RND_TYPE% >NUL 2>&1
IF NOT DEFINED RND1 GOTO:GET_RANDOM
IF "%RND2%"=="%RND1%" GOTO:GET_RANDOM
SET "RND2=%RND1%"&&CALL SET "%RND_SET%=%RND1%"&&SET "RND_TYPE="&&SET "RND_SET="&&SET "RND1="
EXIT /B
:RND1
FOR /F "TOKENS=1-9 DELIMS=:." %%a in ("%TIME%") DO (FOR /F "DELIMS=" %%G IN ('%CMD% /D /U /C CALL ECHO.%%d') DO (CALL SET "RND1=%%G"))
EXIT /B
:RND2
SET "RND1=%RANDOM%%RANDOM%"&&SET "RND1=!RND1:~5,5!"&&SET "RND1=!RND1:~1,1!"
EXIT /B
:TIMER
FOR /F "TOKENS=3 DELIMS=:." %%a in ("%TIME%") DO (IF NOT "%%a"=="%TIMER_LAST%" SET "TIMER_LAST=%%a"&&SET /A "TIMER-=1"&&IF DEFINED TIMER_MSG CLS&&CALL ECHO.%TIMER_MSG%)
IF NOT "%TIMER%"=="0" GOTO:TIMER
SET "TIMER="&&SET "TIMER_LAST="&&SET "TIMER_MSG="&&EXIT /B
:TIMER_POINT3
FOR /F "TOKENS=1-9 DELIMS=:." %%a in ("%TIME%") DO (FOR /F "DELIMS=" %%G IN ('%CMD% /D /U /C CALL ECHO.%%d') DO (CALL SET "TIMER_X=%%G"))
FOR %%a in (2 5 8) DO (IF "%TIMER_X%"=="%%a" SET "TIMER_X="&&EXIT /B)
GOTO:TIMER_POINT3
:SLASHER
FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%INPUT%^| FIND /V ""') do (SET "SLASH_X=%%G"&&CALL:SLASHER_X)
IF NOT "%SLASH_X%"=="\" IF EXIST "%INPUT%\" SET "%OUTPUT%=%INPUT%"
IF "%SLASH_X%"=="\" IF EXIST "%INPUT%" SET "%OUTPUT%=%SLASH_Z%"
IF NOT EXIST "%INPUT%\" SET "%OUTPUT%="
FOR %%a in (SLASH_X SLASH_Y SLASH_Z OUTPUT INPUT) DO (SET "%%a=")
EXIT /B
:SLASHER_X
SET "SLASH_Z=%SLASH_Y%"&&SET "SLASH_Y=%SLASH_Y%%SLASH_X%"
EXIT /B
:CLEAN
IF EXIST "%ListFolder%\$LIST" DEL /Q /F "%ListFolder%\$LIST">NUL 2>&1
IF NOT EXIST "$*" EXIT /B
IF EXIST "%ImageFolder%\$TEMP.vhdx" CALL:VTEMP_DELETE>NUL 2>&1
IF EXIST "%ImageFolder%\$TEMP.wim" DEL /Q /F "%ImageFolder%\$TEMP.wim">NUL 2>&1
FOR %%G in (TEMP LIST DISK LOG) DO (IF EXIST "$%%G*" DEL /Q /F "$%%G*">NUL 2>&1)
FOR %%G in (DRVR FEAT) DO (IF NOT DEFINED %%G_QRY IF EXIST "$%%G" DEL /Q /F "$%%G">NUL 2>&1)
FOR %%G in (RAS RATI) DO (IF NOT DEFINED CURR_TARGET IF EXIST "$%%G.cmd" CALL:RASTI_CHECK&CALL:RAS_DELETE&DEL /Q /F "$%%G.cmd">NUL 2>&1)
EXIT /B
:FOLDER_DEL
IF NOT DEFINED FOLDER_DEL EXIT /B
%DISM% /cleanup-MountPoints>NUL 2>&1
ATTRIB -R -S -H "%FOLDER_DEL%" /S /D /L>NUL 2>&1
TAKEOWN /F "%FOLDER_DEL%" /R /D Y>NUL 2>&1
ICACLS "%FOLDER_DEL%" /grant %USERNAME%:F /T>NUL 2>&1
RD /S /Q "\\?\%FOLDER_DEL%">NUL 2>&1
SET "FOLDER_DEL="&&EXIT /B
:PAD_PREV
ECHO.               Press (%##%Enter%$$%) to return to previous menu
EXIT /B
:PAUSED
IF NOT DEFINED NO_PAUSE SET /P "PAUSED=.                      Press (%##%Enter%$$%) to continue..."
SET "NO_PAUSE="&&EXIT /B
:CONFIRM
IF DEFINED ERROR EXIT /B
SET "$HEADERS= %U01% %U01% %U01% %U01%                  %COLOR4%Are you sure?%$$% Press (%##%X%$$%) to proceed%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" SET "ERROR=CONFIRM"&&CALL:DEBUG
EXIT /B
:RECOVERY_LOCK
SET "LOCKOUT="&&SET "$HEADERS= %U01% %U01% %U01% %U01%                       Enter recovery password%U01% %U01% %U01% "&&SET "$NO_ERRORS=1"&&SET "$SELECT=RECOVERY_PROMPT"&&SET "$CHECK=MOST"&&CALL:PROMPT_BOX
SET /P RECOVERY_LOCK=<"%ProgFolder0%\RECOVERY_LOCK"
IF NOT "%RECOVERY_PROMPT%"=="%RECOVERY_LOCK%" SET "LOCKOUT=1"
SET "RECOVERY_PROMPT="&&SET "RECOVERY_LOCK="
EXIT /B
:DEBUG
IF NOT "%DEBUG%"=="ENABLED" EXIT /B
IF NOT DEFINED ERROR EXIT /B
ECHO.%COLOR4%ERROR:%$$% %ERROR%
CALL:PAUSED
EXIT /B
:PAD_LINE
IF NOT DEFINED PAD_TYPE SET "PAD_TYPE=1"
IF NOT DEFINED ACC_COLOR SET "ACC_COLOR=6"
IF NOT DEFINED BTN_COLOR SET "BTN_COLOR=7"
IF NOT DEFINED TXT_COLOR SET "TXT_COLOR=0"
IF NOT DEFINED PAD_SIZE SET "PAD_SIZE=LARGE"
IF NOT DEFINED PAD_SEQ SET "PAD_SEQ=0000000000"
IF "%PAD_TYPE%"=="0" SET "PADX= "&&ECHO.%$$%&&EXIT /B
IF "%PAD_TYPE%"=="1" SET "PADX=─"
IF "%PAD_TYPE%"=="2" SET "PADX=━"
IF "%PAD_TYPE%"=="3" SET "PADX=◌"
IF "%PAD_TYPE%"=="4" SET "PADX=○"
IF "%PAD_TYPE%"=="5" SET "PADX=●"
IF "%PAD_TYPE%"=="6" SET "PADX=❍"
IF "%PAD_TYPE%"=="7" SET "PADX=□"
IF "%PAD_TYPE%"=="8" SET "PADX=■"
IF "%PAD_TYPE%"=="9" SET "PADX=☰"
IF "%PAD_TYPE%"=="10" SET "PADX=☲"
IF "%PAD_TYPE%"=="11" SET "PADX=░"
IF "%PAD_TYPE%"=="12" SET "PADX=▒"
IF "%PAD_TYPE%"=="13" SET "PADX=▓"
IF "%PAD_TYPE%"=="14" SET "PADX=~"
IF "%PAD_TYPE%"=="15" SET "PADX=="
IF "%PAD_TYPE%"=="16" SET "PADX=#"
SET "PAD_SEQX=%PAD_SEQ%"&&IF NOT "%PAD_SEQ%X"=="%PAD_SEQX%X" SET "XNTX=0"&&SET "COLORX="&&FOR /F "DELIMS=" %%G IN ('%CMD% /D /U /C ECHO.%PAD_SEQ%^| FIND /V ""') do (CALL SET "COLORX=%%G"&&CALL:COLOR_ASSIGN&&CALL SET /A XNTX+=1)
IF "%PAD_SIZE%"=="LARGE" SET "PAD_BLK=%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%%PADX%"
IF "%PAD_SIZE%"=="SMALL" SET "PAD_BLK=%#0%%PADX%%#1%%PADX%%#2%%PADX%%#3%%PADX%%#4%%PADX%%#5%%PADX%%#6%%PADX%%#7%%PADX%%#8%%PADX%%#9%%PADX%"
IF "%PAD_SIZE%"=="LARGE" ECHO.%#0%%PAD_BLK%%#1%%PAD_BLK%%#2%%PAD_BLK%%#3%%PAD_BLK%%#4%%PAD_BLK%%#5%%PAD_BLK%%#6%%PAD_BLK%%$$%
IF "%PAD_SIZE%"=="SMALL" ECHO.%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%PAD_BLK%%$$%
SET "#Z=%$$%"&&SET "#0=%#1%"&SET "#1=%#2%"&SET "#2=%#3%"&SET "#3=%#4%"&SET "#4=%#5%"&SET "#5=%#6%"&SET "#6=%#7%"&SET "#7=%#8%"&SET "#8=%#9%"&SET "#9=%#0%"&&SET "PAD_BLK="&&SET "PADX="&&SET "COLORX=%$$%"
EXIT /B
:COLOR_ASSIGN
IF DEFINED XNTX CALL SET "#%XNTX%=%%COLOR%COLORX%%%"
EXIT /B
:PAD_WRITE
::ECHO.>>"TXT.TXT" 2>&1
EXIT /B
:BOX_DISP
IF "%PAD_BOX%"=="DISABLED" EXIT /B
IF "%$BOX%"=="RT" ECHO.%##%╭────────────────────────────────────────────────────────────────────╮%$$%
IF "%$BOX%"=="RB" ECHO.%##%╰────────────────────────────────────────────────────────────────────╯%$$%
IF "%$BOX%"=="ST" ECHO.%##%┌────────────────────────────────────────────────────────────────────┐%$$%
IF "%$BOX%"=="SB" ECHO.%##%└────────────────────────────────────────────────────────────────────┘%$$%
EXIT /B
:MENU_SELECT
IF DEFINED ERROR CALL:DEBUG&&SET "ERROR="
IF NOT DEFINED $CASE SET "$CASE=UPPER"
IF NOT DEFINED $CHECK SET "$CHECK=MENU"
IF NOT DEFINED $SELECT SET "$SELECT=SELECT"
SET "%$SELECT%="&&SET "SELECT_VAR="&&SET /P "SELECT_VAR=$>>"
IF NOT DEFINED SELECT_VAR SET "ERROR=MENU_SELECT"
IF NOT DEFINED ERROR SET "SELECT_VAR=%SELECT_VAR:"=%"
IF NOT DEFINED ERROR SET "SELECT_VAR=%SELECT_VAR:;=%"
IF NOT DEFINED ERROR SET "CHECK_VAR=%SELECT_VAR%"&&CALL:CHECK
IF NOT DEFINED ERROR IF /I "%$CASE%"=="ANY" SET "%$SELECT%=%SELECT_VAR%"
IF NOT DEFINED ERROR FOR %%■ in (UPPER LOWER) DO (IF /I "%%■"=="%$CASE%" SET "CAPS_SET=%$SELECT%"&&SET "CAPS_VAR=%SELECT_VAR%"&&CALL:CAPS_SET)
IF NOT DEFINED ERROR IF NOT DEFINED %$SELECT% SET "ERROR=MENU_SELECT"
IF DEFINED ERROR SET "%$SELECT%="&&IF DEFINED $VERBOSE FOR /F "TOKENS=*" %%■ in ("%SELECT_VAR% ") DO (ECHO.%COLOR4%ERROR:%$$% input [ %COLOR4%%%■%$$%] is invalid)
SET "SELECT_LAST=%SELECT_VAR%"
IF DEFINED $CHOICE SET "$CHOICE_LAST=%$CHOICE%"
ECHO.%$$%&&CALL SET "$CHOICE=%%$ITEM%SELECT_VAR%%%"
FOR %%a in ($CASE $SELECT SELECT_VAR) DO (SET "%%a=")
IF NOT DEFINED $PICKER EXIT /B
FOR %%a in ($PICKER $PICK $PATH $BODY $EXT) DO (SET "%%a=")
IF NOT DEFINED $CHOICE EXIT /B
IF NOT EXIST "%$FOLD%\%$CHOICE%" EXIT /B
IF EXIST "%$FOLD%\%$CHOICE%" SET "$PICK=%$FOLD%\%$CHOICE%"
IF NOT DEFINED ERROR FOR %%G in ("%$PICK%") DO (SET "$PATH=%%~dG%%~pG"&&SET "$BODY=%%~nG"&&SET "$EXT=%%~xG")
IF NOT DEFINED ERROR FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "$EXT=%%$EXT:%%G=%%G%%")
EXIT /B
:CAPS_SET
IF NOT DEFINED CAPS_VAR SET "%CAPS_SET%="&&SET "CAPS_SET="&&SET "CAPS_VAR="&&SET "$CASE="&&EXIT /B
IF NOT DEFINED $CASE SET "$CASE=UPPER"
IF /I "%$CASE%"=="LOWER" FOR %%G in (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO (CALL SET "CAPS_VAR=%%CAPS_VAR:%%G=%%G%%")
IF /I "%$CASE%"=="UPPER" FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "CAPS_VAR=%%CAPS_VAR:%%G=%%G%%")
IF "%CAPS_VAR%"=="=" SET "CAPS_VAR="
IF /I "%CAPS_VAR%"=="a=a" SET "CAPS_VAR="
CALL SET "%CAPS_SET%=%CAPS_VAR%"
SET "CAPS_SET="&&SET "CAPS_VAR="&&SET "$CASE="
EXIT /B
:CHECK
IF "%DEBUG%"=="ENABLED" ECHO.$CHECK[%$CHECK%]&&CALL:DEBUG
SET "$CHECK_LAST=%$CHECK%"&&FOR /F "TOKENS=1-3 DELIMS=❗-" %%a IN ("%$CHECK%") DO (SET "$CHECK=%%a"&&SET "TEXTMIN=%%b"&&SET "TEXTMAX=%%c")
IF NOT DEFINED CHECK_VAR SET "ERROR=CHECK"
IF /I "%$CHECK%"=="NONE" GOTO:TEXTMINMAXCHK
SET "NUMBERS=0 1 2 3 4 5 6 7 8 9"&&SET "LETTERS=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z"
IF /I "%$CHECK%"=="NUMBER" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% ^""
IF /I "%$CHECK%"=="LETTER" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%LETTERS% ^""
IF /I "%$CHECK%"=="ALPHA" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% . - _ ^""
IF /I "%$CHECK%"=="PATH" SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% . - _ ^\ ^: ^""
IF /I "%$CHECK%"=="MENU" SET "NO_SPACE=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% @ # $ . - _ + = ~ ^* ^""
IF /I "%$CHECK%"=="MOST" SET "CHECK_FLT=%NUMBERS% %LETTERS% @ # $ ^\ ^/ ^: ^( ^) ^[ ^] ^{ ^} ^. ^- ^_ ^+ ^= ^~ ^* ^%% ^""
IF NOT DEFINED ERROR SET "$XNT=-2"&&FOR /F "DELIMS=" %%■ in ('%CMD% /D /U /C ECHO."%CHECK_VAR%"^| FIND /V ""') do (SET "$GO="&&SET /A "$XNT+=1"&&FOR %%a in (%CHECK_FLT%) DO (
IF "[%%■]"=="[*]" IF NOT DEFINED NO_ASTRK SET "$GO=1"
IF "[%%■]"=="[ ]" IF NOT DEFINED NO_SPACE SET "$GO=1"
IF "[%%■]"=="[!]" SET "ERROR=CHECK"
IF "[%%a]"=="[%%■]" SET "$GO=1")
IF NOT DEFINED $GO SET "ERROR=CHECK")
:TEXTMINMAXCHK
IF NOT DEFINED ERROR IF DEFINED TEXTMIN CALL:TEXTMIN
IF NOT DEFINED ERROR IF DEFINED TEXTMAX CALL:TEXTMAX
:CHECK_END
SET "$CHECK=%$CHECK_LAST%"&&FOR %%a in ($CHECK_LAST CHECK_VAR CHECK_FLT TEXTMIN TEXTMAX NUMBERS LETTERS NO_SPACE NO_ASTRK) DO (SET "%%a=")
IF DEFINED ERROR IF "%DEBUG%"=="ENABLED" CALL:DEBUG
EXIT /B
:TEXTMIN
IF /I "%$CHECK%"=="NUMBER" SET /A "TEXTMIN=%TEXTMIN%"&&SET /A "CHECK_VAR=%CHECK_VAR%"
IF /I "%$CHECK%"=="NUMBER" IF %CHECK_VAR% LSS %TEXTMIN% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %CHECK_VAR% LSS %TEXTMIN%)
IF /I NOT "%$CHECK%"=="NUMBER" IF %$XNT% LSS %TEXTMIN% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %$XNT% LSS %TEXTMIN%)
EXIT /B
:TEXTMAX
IF /I "%$CHECK%"=="NUMBER" SET /A "TEXTMAX=%TEXTMAX%"&&SET /A "CHECK_VAR=%CHECK_VAR%"
IF /I "%$CHECK%"=="NUMBER" IF %CHECK_VAR% GTR %TEXTMAX% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %CHECK_VAR% GTR %TEXTMAX%)
IF /I NOT "%$CHECK%"=="NUMBER" IF %$XNT% GTR %TEXTMAX% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %$XNT% GTR %TEXTMAX%)
EXIT /B
:CHAR_CHK
FOR %%a in (CHAR_STR CHAR_CHK) DO (IF NOT DEFINED %%a EXIT /B)
SET "CHAR_FLG="&&FOR /F "DELIMS=" %%■ in ('%CMD% /D /U /C ECHO.%CHAR_STR%^| FIND /V ""') do (IF "%%■"=="%CHAR_CHK%" SET "CHAR_FLG=1"&&SET "ERROR=CHAR_CHK"&&CALL:DEBUG)
EXIT /B
:LOGO
IF "%RECOVERY_LOGO%"=="DISABLED" EXIT /B
IF NOT DEFINED RECOVERY_LOGO SET "RECOVERY_LOGO=DISABLED"
SET "ROW_X=%%@1%%█%%@2%%█%%@3%%█%%@4%%█%%@1%%█%%@2%%█%%@3%%█%%@4%%█"&&SET "ROW_T=%%@1%% %%@2%%▀%%@3%%█%%@4%%█%%@1%%█%%@2%%█%%@3%%▀%%@4%% "&&SET "ROW_B=%%@1%% %%@2%%▄%%@3%%█%%@4%%█%%@1%%█%%@2%%█%%@3%%▄%%@4%% "
SET "RND_SET=@1"&&CALL:GET_RANDOM&&SET "RND_SET=@2"&&CALL:GET_RANDOM&&SET "RND_SET=@3"&&CALL:GET_RANDOM&&SET "RND_SET=@4"&&CALL:GET_RANDOM
CALL SET "@1=%%COLOR%@1%%%"&&CALL SET "@2=%%COLOR%@2%%%"&&CALL SET "@3=%%COLOR%@3%%%"&&CALL SET "@4=%%COLOR%@4%%%"&&SET "LOGOX="&&SET "XNTZ="&&CALL:LOGO_X&&CLS&&FOR %%a in (@1 @2 @3 @4 @5 @6 @7 @8 @9 ROW_X ROW_T ROW_B) DO (SET "%%a=")
EXIT /B
:LOGO_X
CLS&&CALL ECHO.%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%&&SET "@1=%@2%"&SET "@2=%@3%"&SET "@3=%@4%"&SET "@4=%@1%"&&CALL ECHO.%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%%ROW_T%&&ECHO.&&ECHO.                               %COLOR0%WELCOME TO&&ECHO.&&ECHO.       %@1% ▄█     █▄   ▄█ ███▄▄▄▄   ███████▄   ▄█  ▄███████  ▄█   ▄█▄&&ECHO.       %@2%███     ███ ███ ███▀▀▀██▄ ███  ▀███ ███ ███   ███ ███ ▄███▀&&ECHO.       %@3%███     ███ ███ ███   ███ ███   ███ ███ ███   █▀  ███▐██▀&&ECHO.       %@4%███     ███ ███ ███   ███ ███   ███ ███ ███      ▄█████▀&&ECHO.       %@1%███     ███ ███ ███   ███ ███   ███ ███ ███   █▄  ███▐██▄&&ECHO.       %@2%███ ▄█▄ ███ ███ ███   ███ ███  ▄███ ███ ███   ███ ███ ▀███▄&&ECHO.       %@3% ▀███▀███▀  █▀   ▀█   █▀  ███████▀  █▀  ███████▀  ███   ▀█▀&&ECHO.&&ECHO.                          %COLOR0%RECOVERY ENVIRONMENT&&ECHO.
CALL ECHO.%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%%ROW_B%&&SET "@1=%@2%"&SET "@2=%@3%"&SET "@3=%@4%"&SET "@4=%@1%"
CALL ECHO.%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%ROW_X%%$$% &&SET "@1=%@4%"&SET "@2=%@1%"&SET "@3=%@2%"&SET "@4=%@3%"
CALL:TIMER_POINT3&SET /A "XNTZ+=1"&IF NOT "%XNTZ%"=="7" GOTO:LOGO_X
EXIT /B
:SETS_LIST
SET SETS_LIST=GUI_LAUNCH GUI_RESUME GUI_SCALE GUI_CONFONT GUI_CONFONTSIZE GUI_CONTYPE GUI_FONTSIZE GUI_LVFONTSIZE GUI_TXT_FORE GUI_TXT_BACK GUI_BTN_COLOR GUI_HLT_COLOR GUI_BG_COLOR GUI_PAG_COLOR PAD_BOX PAD_TYPE PAD_SIZE PAD_SEQ TXT_COLOR ACC_COLOR BTN_COLOR COMPRESS SAFE_EXCLUDE HOST_HIDE PE_WALLPAPER BOOT_TIMEOUT VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5 ADDFILE_0 ADDFILE_1 ADDFILE_2 ADDFILE_3 ADDFILE_4 ADDFILE_5 ADDFILE_6 ADDFILE_7 ADDFILE_8 ADDFILE_9 HOTKEY_1 SHORT_1 HOTKEY_2 SHORT_2 HOTKEY_3 SHORT_3 RECOVERY_LOGO MENU_MODE MENU_LIST REFERENCE APPX_SKIP COMP_SKIP SVC_SKIP SXS_SKIP DEBUG
EXIT /B
:SETS_LOAD
IF EXIST "windick.ini" FOR /F "TOKENS=1-1* DELIMS==" %%a in (windick.ini) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
EXIT /B
:SETS_CLEAR
CALL:SETS_LIST
FOR %%a in (%SETS_LIST%) DO (SET %%a=)
SET "SETS_LIST="&&EXIT /B
:SETS_HANDLER
IF NOT "%PROG_MODE%"=="RAMDISK" SET "ProgFolder=%ProgFolder0%"
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%ProgFolder%" SET "ProgFolder=%ProgFolder0%"
CD /D "%ProgFolder0%"&&IF EXIST "windick.ini" IF NOT DEFINED SETS_LOAD SET "SETS_LOAD=1"&&CALL:SETS_LOAD
CALL:SETS_LIST&&ECHO.Windows Deployment Image Customization Kit v %VER_CUR% Settings>"windick.ini"
FOR %%a in (%SETS_LIST%) DO (CALL ECHO.%%a=%%%%a%%>>"windick.ini")
SET "SETS_LIST="&&IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="X:\$" SET "HOST_GET=1"
IF "%PROG_MODE%"=="RAMDISK" IF NOT "%DISK_TARGET%"=="%HOST_TARGET%" SET "HOST_GET=1"
IF DEFINED HOST_GET SET "HOST_GET="&&CALL:HOST_AUTO
IF "%PROG_MODE%"=="RAMDISK" IF EXIST "Z:\%HOST_FOLDERX%" COPY /Y "windick.ini" "Z:\%HOST_FOLDERX%">NUL
:SETS_MAIN
IF NOT DEFINED PAD_TYPE SET "PAD_TYPE=1"
IF NOT DEFINED ACC_COLOR SET "ACC_COLOR=6"
IF NOT DEFINED BTN_COLOR SET "BTN_COLOR=7"
IF NOT DEFINED TXT_COLOR SET "TXT_COLOR=0"
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25"
IF NOT DEFINED REFERENCE SET "REFERENCE=LIVE"
IF NOT DEFINED PAD_SIZE SET "PAD_SIZE=LARGE"
IF NOT DEFINED PAD_BOX SET "PAD_BOX=ENABLED"
IF NOT DEFINED PAD_SEQ SET "PAD_SEQ=0000000000"
IF NOT DEFINED HOST_FOLDER SET "HOST_FOLDER=$"
IF NOT DEFINED HOST_HIDE SET "HOST_HIDE=DISABLED"
IF NOT DEFINED SAFE_EXCLUDE SET "SAFE_EXCLUDE=ENABLED"
IF NOT DEFINED ADDFILE_0 SET "ADDFILE_0=list\tweaks.base"
IF NOT DEFINED HOTKEY_1 SET "HOTKEY_1=CMD"&&SET "SHORT_1=CMD.EXE"
IF NOT DEFINED HOTKEY_2 SET "HOTKEY_2=NOTE"&&SET "SHORT_2=NOTEPAD.EXE"
IF NOT DEFINED HOTKEY_3 SET "HOTKEY_3=REG"&&SET "SHORT_3=REGEDIT.EXE"
IF NOT DEFINED APPX_SKIP SET "APPX_SKIP=Microsoft.DesktopAppInstaller Microsoft.VCLibs.140.00"
IF NOT "%PROG_MODE%"=="RAMDISK" SET "ProgFolder=%ProgFolder0%"
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%ProgFolder%" SET "ProgFolder=%ProgFolder0%"
SET "FOLDER_MODE=UNIFIED"&&IF NOT "%COMPRESS%"=="FAST" IF NOT "%COMPRESS%"=="MAX" SET "COMPRESS=FAST"
IF EXIST "%ProgFolder%\CACHE" IF EXIST "%ProgFolder%\IMAGE" IF EXIST "%ProgFolder%\PACK" IF EXIST "%ProgFolder%\LIST" SET "FOLDER_MODE=ISOLATED"
IF "%FOLDER_MODE%"=="ISOLATED" FOR %%a in (Cache Image Pack List) DO (SET "%%aFolder=%ProgFolder%\%%a")
IF "%FOLDER_MODE%"=="UNIFIED" FOR %%a in (Cache Image Pack List) DO (SET "%%aFolder=%ProgFolder%")
IF DEFINED REFERENCE IF NOT EXIST "%ImageFolder%\%REFERENCE%" SET "REFERENCE=LIVE"
FOR %%a in (MOUNT TARGET_PATH PATH_APPLY LIVE_APPLY VDISK_APPLY ERROR $NO_MOUNT $HALT $ONLY1 $ONLY2 $ONLY3 $VERBOSE $VHDX VDISK VDISK_LTR MENU_SESSION CUSTOM_SESSION MENU_SKIP DELETE_DONE FEAT_QRY DRVR_QRY SC_PREPARE RO_PREPARE) DO (SET "%%a=")
CHCP 65001>NUL&IF NOT DEFINED U00 SET "U00=❕"&&SET "U01=❗"&&SET "U02=🗂 "&&SET "U03=🛠️"&&SET "U04=💾"&&SET "U05=🗳 "&&SET "U06=🪟"&&SET "U07=🔄"&&SET "U08=🪛"&&SET "U09=🥾"&&SET "U10=✒ "&&SET "U11=🗃 "&&SET "U12=🎨"&&SET "U13=🧾"&&SET "U14=⏳"&&SET "U15=✅"&&SET "U16=❎"&&SET "U17=🚫"&&SET "U18=🗜 "&&SET "U19=🛡 "&&SET "U0L=◁"&&SET "U0R=▷"&&SET "COLOR0=[97m"&&SET "COLOR1=[31m"&&SET "COLOR2=[91m"&&SET "COLOR3=[33m"&&SET "COLOR4=[93m"&&SET "COLOR5=[92m"&&SET "COLOR6=[96m"&&SET "COLOR7=[94m"&&SET "COLOR8=[34m"&&SET "COLOR9=[95m"
CALL SET "@@=%%COLOR%ACC_COLOR%%%"&&CALL SET "##=%%COLOR%BTN_COLOR%%%"&&CALL SET "$$=%%COLOR%TXT_COLOR%%%"
SET "COLORA=%@@%"&&SET "COLORB=%##%"&&SET "COLORT=%$$%"
FOR %%a in (COMMAND GUI) DO (IF "%PROG_MODE%"=="%%a" EXIT /B)
FOR %%a in (MENU_LIST) DO (SET "OBJ_FLD=%ListFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (PE_WALLPAPER) DO (SET "OBJ_FLD=%CacheFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (VHDX_SLOTX WIM_SOURCE VHDX_SOURCE) DO (SET "OBJ_FLD=%ImageFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (SET "ADDFILE_NUM=%%a"&&CALL SET "ADDFILE_CHK=%%ADDFILE_%%a%%"&&CALL:ADDFILE_CHK)
IF "%PROG_MODE%"=="RAMDISK" FOR %%a in (VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5) DO (SET "OBJ_FLD=%ProgFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (MENU_LIST PE_WALLPAPER PATH_SOURCE PATH_TARGET WIM_SOURCE VHDX_SOURCE WIM_TARGET VHDX_TARGET VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5) DO (IF NOT DEFINED %%a SET "%%a=SELECT")
IF NOT EXIST "%PATH_SOURCE%\" SET "PATH_SOURCE=SELECT"
IF NOT EXIST "%PATH_TARGET%\" SET "PATH_TARGET=SELECT"
FOR %%a in (ADDFILE_CHK ADDFILE_NUM OBJ_FLD OBJ_CHK OBJ_CHKX) DO (SET "%%a=")
EXIT /B
:ADDFILE_CHK
IF NOT DEFINED ADDFILE_%ADDFILE_NUM% SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%ADDFILE_CHK%"=="SELECT" EXIT /B
FOR /F "TOKENS=1-9 DELIMS=\" %%a in ("%ADDFILE_CHK%") DO (
IF "%%a"=="pack" IF NOT EXIST "%PackFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="list" IF NOT EXIST "%ListFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="image" IF NOT EXIST "%ImageFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="cache" IF NOT EXIST "%CacheFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="main" IF NOT EXIST "%ProgFolder%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT")
EXIT /B
:OBJ_CLEAR
CALL SET "OBJ_CHKX=%%%OBJ_CHK%%%"
IF NOT EXIST "%OBJ_FLD%\%OBJ_CHKX%" CALL SET "%OBJ_CHK%=SELECT"
EXIT /B
:FOLDER_MODE
SET "$HEADERS= %U01% %U01% %U01%        The folder structure will be regenerated. If a file is %U01%    open or mounted and cannot be moved it's possible to lose data.%U01% %U01% %U01% %U01%                         Press (%##%X%$$%) to proceed"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" EXIT /B
IF "%FOLDER_MODE%"=="UNIFIED" SET "FOLDER_MODE=ISOLATED"&&GOTO:FOLDER_ISOLATED
IF "%FOLDER_MODE%"=="ISOLATED" SET "FOLDER_MODE=UNIFIED"&&GOTO:FOLDER_UNIFIED
:FOLDER_UNIFIED
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%ProgFolder%\%%a" MOVE /Y "%ProgFolder%\%%a\*.*" "%ProgFolder%">NUL 2>&1)
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%ProgFolder%\%%a" XCOPY /S /C /Y "%ProgFolder%\%%a" "%ProgFolder%">NUL 2>&1)
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%ProgFolder%\%%a" RD /Q /S "\\?\%ProgFolder%\%%a">NUL 2>&1)
IF "%PROG_MODE%"=="GUI" ECHO.Restart app for changes to take effect.&&CALL:PAUSED
EXIT /B
:FOLDER_ISOLATED
FOR %%a in (cache image pack list) DO (IF NOT EXIST "%ProgFolder%\%%a" MD "%ProgFolder%\%%a">NUL 2>&1)
FOR %%a in (XML JPG PNG REG EFI SDI SAV) DO (IF EXIST "%ProgFolder%\*.%%a" MOVE /Y "%ProgFolder%\*.%%a" "%ProgFolder%\CACHE">NUL 2>&1)
FOR %%a in (LIST BASE) DO (IF EXIST "%ProgFolder%\*.%%a" MOVE /Y "%ProgFolder%\*.%%a" "%ProgFolder%\LIST">NUL 2>&1)
FOR %%a in (ISO VHDX WIM) DO (IF EXIST "%ProgFolder%\*.%%a" MOVE /Y "%ProgFolder%\*.%%a" "%ProgFolder%\IMAGE">NUL 2>&1)
FOR %%a in (PKX CAB MSU APPX APPXBUNDLE MSIXBUNDLE) DO (IF EXIST "%ProgFolder%\*.%%a" MOVE /Y "%ProgFolder%\*.%%a" "%ProgFolder%\PACK">NUL 2>&1)
IF "%PROG_MODE%"=="GUI" ECHO.Restart app for changes to take effect.&&CALL:PAUSED
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:FILE_VIEWER
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&CALL:BOX_HEADERS
SET "$FOLD=!$FOLD:◁=%%!"&&SET "$FOLD=!$FOLD:▷=%%!"
SET "$FILT=!$FILT:◁=%%!"&&SET "$FILT=!$FILT:▷=%%!"
FOR /F "TOKENS=*" %%a IN ("!$FOLD!") DO (CALL SET "$FOLD=%%a")
FOR /F "TOKENS=*" %%a IN ("!$FILT!") DO (CALL SET "$FILT=%%a")
ECHO.&&ECHO.  %@@%AVAILABLE %$FILT%s:%$$%&&ECHO.&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
IF NOT DEFINED $NO_ERRORS CALL:PAD_PREV
IF DEFINED $CHOICEMINO SET "$CHOICEMIN=0"
IF NOT DEFINED $CHOICEMINO SET "$CHOICEMIN=1"
IF DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$CHOICEMAXO%"
IF NOT DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$XNT%"
IF DEFINED $CHECKO SET "$CHECK=%$CHECKO%"
IF NOT DEFINED $CHECKO SET "$CHECK=NUMBER❗%$CHOICEMIN%-%$CHOICEMAX%"
CALL:MENU_SELECT
IF NOT DEFINED $CHOICE IF NOT DEFINED ERROR SET "$CHOICE=%SELECT%"
IF DEFINED $NO_ERRORS IF NOT DEFINED $CHOICE IF DEFINED $ITEM1 GOTO:FILE_VIEWER
FOR %%a in ($FOLD $FILT $CHOICEMINO $CHOICEMAXO $CHECKO $CENTERED $HEADERS $NO_ERRORS $VERBOSE) DO (SET "%%a=")
EXIT /B
:FILE_LIST
FOR %%a in ($FOLD $FILT) DO (IF NOT DEFINED %%a GOTO:FILE_LIST_SKIP)
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEM%%a SET "$ITEM%%a=")
IF NOT DEFINED $DISP SET "$DISP=NUM"
IF "%$DISP%"=="NUM" SET "$PICKER=1"
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
IF EXIST "!$FOLD!" FOR /F "TOKENS=1-9 DELIMS= " %%a IN ("!$FILT!") DO (IF NOT "%%a"=="" SET "$FILTARG=%%a"&&CALL:FILTARG&&IF NOT "%%b"=="" SET "$FILTARG=%%b"&&CALL:FILTARG&&IF NOT "%%c"=="" SET "$FILTARG=%%c"&&CALL:FILTARG&&IF NOT "%%d"=="" SET "$FILTARG=%%d"&&CALL:FILTARG&&IF NOT "%%e"=="" SET "$FILTARG=%%e"&&CALL:FILTARG&&IF NOT "%%f"=="" SET "$FILTARG=%%f"&&CALL:FILTARG&&IF NOT "%%g"=="" SET "$FILTARG=%%g"&&CALL:FILTARG&&IF NOT "%%h"=="" SET "$FILTARG=%%h"&&CALL:FILTARG&&IF NOT "%%i"=="" SET "$FILTARG=%%i"&&CALL:FILTARG)
IF NOT DEFINED $ITEM1 ECHO.&&ECHO.   Empty.&&ECHO.
IF DEFINED $ITEMSBTM CALL:ITEMSBTM
:FILE_LIST_SKIP
FOR %%a in ($DISP $ITEMSTOP $ITEMSBTM $FILTARG) DO (SET "%%a=")
EXIT /B
:FILTARG
IF NOT EXIST "!$FOLD!\!$FILTARG!" EXIT /B
FOR /F "TOKENS=*" %%■ in ('DIR /A: /B /O:GN "!$FOLD!\!$FILTARG!"') DO (CALL SET /A "$XNT+=1"&&CALL SET "$VCLM$=%%■"&&CALL:FILE_LISTX)
EXIT /B
:FILE_LISTX
SET "$ITEM%$XNT%=!$VCLM$!"
IF EXIST "!$FOLD!\!$VCLM$!\*" (SET "$LCLR1=%@@%"&&SET "$LCLR2=%$$%") ELSE (SET "$LCLR1="&&SET "$LCLR2=")
IF "%$DISP%"=="NUM" FOR /F "TOKENS=*" %%● in ("!$VCLM$!") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %$LCLR1%%%●%$LCLR2%)
IF "%$DISP%"=="BAS" FOR /F "TOKENS=*" %%● in ("!$VCLM$!") DO (ECHO.   %$LCLR1%%%●%$LCLR2%)
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:LIST_VIEWER
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
SET "INPUT=%$LIST_FILE%"&&CALL:GET_FILEEXT
IF DEFINED MENU_SESSION SET "REFERENCE=LIVE"
IF NOT "%REFERENCE%"=="LIVE" IF NOT DEFINED $VATTACH SET "LIVE_APPLY="&&SET "$VDISK_FILE=%ImageFolder%\%REFERENCE%"&&SET "VDISK_LTR=ANY"&&ECHO.Loading reference image...&&CALL:VDISK_ATTACH
IF NOT "%REFERENCE%"=="LIVE" IF NOT DEFINED $VATTACH IF EXIST "%VDISK_LTR%:\" SET "TARGET_PATH=%VDISK_LTR%:"&&SET "$VATTACH=1"&&CALL:MOUNT_EXT
IF "%REFERENCE%"=="LIVE" SET "TARGET_PATH=%SYSTEMDRIVE%"&&SET "LIVE_APPLY=1"&&CALL:MOUNT_INT
IF DEFINED BASE_EXEC (SET "$LIST_MODE=Execute") else (SET "$LIST_MODE=Builder")
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&SET "$CENTERED=1"&&SET "$HEADERS=%U13% List %$LIST_MODE%%U01% %U01%  !$FILE_X!%$EXT_X%%U01% %U01%"&&CALL:BOX_HEADERS&SET "$LIST_SCOPE=GROUP"&&CALL:LIST_FILE
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&IF NOT DEFINED ERROR CALL:PAD_PREV
IF DEFINED ERROR SET "TIMER=1"&&CALL:TIMER&&GOTO:LIST_VIEWER_END
SET "$VERBOSE=1"&&SET "$CHECK=NUMBER❗1-%$XNT%"&&CALL:MENU_SELECT
IF NOT DEFINED ERROR FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 IN ("!$CHOICE!") DO (SET "$ONLY2=%%2")
IF DEFINED ERROR SET "$ONLY1="&&GOTO:LIST_VIEWER_END
:SUBGROUP_BOX
SET "INPUT=%$LIST_FILE%"&&CALL:GET_FILEEXT&&CALL:SESSION_CLEAR
IF DEFINED BASE_EXEC (SET "$LIST_MODE=Execute") else (SET "$LIST_MODE=Builder")
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&SET "$CENTERED=1"&&SET "$HEADERS=%U13% !$FILE_X!%$EXT_X%%U01% %U01%!$ONLY2!%U01% %U01%"&&CALL:BOX_HEADERS&&SET "$LIST_SCOPE=SUBGROUP"&&CALL:LIST_FILE
ECHO.&&ECHO.                        Multiples OK ( %##%1 2 3%$$% )
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV
SET "$VERBOSE=1"&&SET "LIST_START="&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF NOT DEFINED ERROR FOR %%a in (%SELECT%) DO (CALL SET "FULL_TARGET=%%$ITEM%%a%%"&&CALL:UNIFIED_PARSE_BUILDER)
IF NOT DEFINED LIST_START IF DEFINED SELECT SET "ERROR=1"&&FOR /F "TOKENS=*" %%■ in ("%SELECT_LAST% ") DO (ECHO.%COLOR4%ERROR:%$$% input [ %COLOR4%%%■%$$%] is invalid)
IF DEFINED ERROR SET "ERROR="&&SET "$ONLY2="&&GOTO:LIST_VIEWER
:LIST_VIEWER_APPEND
IF DEFINED BASE_EXEC SET "$LIST_FILE=%ListFolder%\$LIST"&&GOTO:LIST_VIEWER_END
SET "$CENTERED="&&SET "$HEADERS=                            %U04% Append Items%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new list"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MAKE
IF "%SELECT%"=="0" IF NOT DEFINED ERROR MOVE /Y "$LIST" "%$PICK%">NUL&GOTO:LIST_VIEWER_END
IF DEFINED ERROR SET "ERROR="&&SET "$ONLY3="&&GOTO:SUBGROUP_BOX
SET "$LIST_FILE=%$PICK%"&&CALL:LIST_COMBINE&&CALL:APPEND_SCREEN
:LIST_VIEWER_END
FOR %%▓ in (LIVE_APPLY BASE_EXEC GROUP_TYPE $ONLY1 $ONLY2 $ONLY3 $CENTERED $HEADERS $NO_ERRORS $VERBOSE) DO (SET "%%▓=")
IF NOT "%REFERENCE%"=="LIVE" IF DEFINED $VATTACH ECHO.Unloading reference image...&&SET "$VATTACH="&&SET "$VDISK_FILE=%ImageFolder%\%REFERENCE%"&CALL:MOUNT_INT&CALL:VDISK_DETACH
EXIT /B
:UNIFIED_PARSE_BUILDER
IF NOT DEFINED FULL_TARGET EXIT /B
SET "FULL_TARGETQ=%FULL_TARGET:"=%"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 in ("%FULL_TARGETQ%") DO (
SET "GROUP_TARGET=%%2"&&SET "SUB_TARGET=%%3"&&SET "GROUP_TYPE=%%4"&&SET "GROUP_MSG=%%5"&&SET "GROUP_CHOICES=%%6"&&SET "GROUP_CHOICE=%%7"
IF NOT "%%1"=="" SET "COLUMN_XNT=1"&&IF NOT "%%2"=="" SET "COLUMN_XNT=2"&&IF NOT "%%3"=="" SET "COLUMN_XNT=3"&&IF NOT "%%4"=="" SET "COLUMN_XNT=4"&&IF NOT "%%5"=="" SET "COLUMN_XNT=5"&&IF NOT "%%6"=="" SET "COLUMN_XNT=6"&&IF NOT "%%7"=="" SET "COLUMN_XNT=7")
FOR /F "TOKENS=*" %%░ IN ("%GROUP_TYPE%") DO (IF /I NOT "%%░"=="NORMAL" IF /I NOT "%%░"=="DRAWER" IF /I NOT "%%░"=="SCOPED" SET "GROUP_TYPE=NORMAL")
IF /I "%GROUP_TYPE%"=="NORMAL" CALL:NORMAL_LIST
IF /I "%GROUP_TYPE%"=="DRAWER" CALL:DRAWER_BOX
IF /I "%GROUP_TYPE%"=="SCOPED" CALL:DRAWER_BOX
EXIT /B
:LIST_FILE
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEM%%a SET "$ITEM%%a=")
IF NOT EXIST "%$LIST_FILE%" GOTO:LIST_FILE_SKIP
SET "$HEAD_CHECK=%$LIST_FILE%"&&CALL:GET_HEADER
IF DEFINED ERROR GOTO:LIST_FILE_SKIP
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
COPY /Y "%$LIST_FILE%" "$TEMP">NUL 2>&1
SET "$VCLM2_LAST="&&SET "$SUBGROUP_LAST="&&SET "$LIST_FILEX="&&SET "$LIST_FILEZ="&&IF EXIST "$TEMP" FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%1 in ($TEMP) DO (
IF "%$LIST_SCOPE%"=="GROUP" IF /I "%%1"=="GROUP" SET "$LIST_FILEX=1"
IF "%$LIST_SCOPE%"=="SUBGROUP" IF /I "%%1"=="GROUP" IF NOT "%%2"=="%$ONLY2%" SET "$LIST_FILEZ="
IF "%$LIST_SCOPE%"=="SUBGROUP" IF /I "%%1"=="GROUP" IF "%%2"=="%$ONLY2%" SET "$LIST_FILEX=1"&&SET "$LIST_FILEZ=1"
IF DEFINED $LIST_FILEZ IF NOT "%%1"=="" FOR /F "TOKENS=* DELIMS=ⓡ" %%░ IN ("%%1") DO (IF NOT "%%1"=="%%░" SET "$VCLMX=%%░"&&CALL:LIST_FILEX_SKIP)
IF DEFINED $LIST_FILEX SET "$LIST_FILEX="&&SET "$VCLM1=%%1"&&SET "$VCLM2=%%2"&&SET "$VCLM3=%%3"&&SET "$VCLM4=%%4"&&SET "$VCLM5=%%5"&&SET "$VCLM6=%%6"&&SET "$VCLM7=%%7"&&SET "$VCLM8=%%8"&&SET "$VCLM9=%%9"&&CALL:LIST_FILEX)
IF "%$LIST_SCOPE%"=="SUBGROUP" IF DEFINED $SUBGROUP_LAST SET "$SUBGROUP_LAST=!$SUBGROUP_LAST:◁=%%!"&&SET "$SUBGROUP_LAST=!$SUBGROUP_LAST:▷=%%!"&&CALL SET "$SUBGROUP_LAST=!$SUBGROUP_LAST!"&&FOR /F "TOKENS=*" %%░ IN ("!$SUBGROUP_LAST!") DO (ECHO. %%░%$$%)
IF NOT DEFINED $ITEM1 ECHO.&&ECHO.   Empty.&&ECHO.
IF DEFINED $ITEMSBTM CALL:ITEMSBTM
:LIST_FILE_SKIP
FOR %%a in ($VCLM1 $VCLM2 $VCLM3 $VCLM4 $VCLM5 $VCLM6 $VCLM7 $VCLM2_LAST $ITEMSTOP $ITEMSBTM) DO (SET "%%a=")
EXIT /B
:LIST_FILEX_SKIP
SET "COLUMN0="&&FOR %%░ IN (X) DO (
IF NOT "%%1"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%"
IF NOT "%%2"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%"
IF NOT "%%3"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%"
IF NOT "%%4"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%"
IF NOT "%%5"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%"
IF NOT "%%6"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%"
IF NOT "%%7"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%"
IF NOT "%%8"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%%%8%U00%"
IF NOT "%%9"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%%%8%U00%%%9%U00%"
IF DEFINED COLUMN0 CALL:UNIFIED_PARSE_EXECUTE)
EXIT /B
:LIST_FILEX
IF DEFINED $VCLM2 SET "$VCLM2=!$VCLM2:"=!"
IF DEFINED $VCLM3 SET "$VCLM3=!$VCLM3:"=!"
IF "%$LIST_SCOPE%"=="GROUP" IF DEFINED $VCLM2 FOR /F "TOKENS=*" %%░ IN ("!$VCLM2!") DO (IF "%%░"=="!$VCLM2_LAST!" EXIT /B
SET "$VCLM2_LAST=%%░")
SET /A "$XNT+=1"
IF "%$LIST_SCOPE%"=="GROUP" IF DEFINED $VCLM2 FOR /F "TOKENS=*" %%░ IN ("!$VCLM2!") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %%░%$$%)
IF "%$LIST_SCOPE%"=="SUBGROUP" IF DEFINED $SUBGROUP_LAST SET "$SUBGROUP_LAST=!$SUBGROUP_LAST:◁=%%!"&&SET "$SUBGROUP_LAST=!$SUBGROUP_LAST:▷=%%!"&&CALL SET "$SUBGROUP_LAST=!$SUBGROUP_LAST!"&&FOR /F "TOKENS=*" %%░ IN ("!$SUBGROUP_LAST!") DO (ECHO. %%░%$$%)
IF "%$LIST_SCOPE%"=="SUBGROUP" IF DEFINED $VCLM3 FOR /F "TOKENS=*" %%░ IN ("!$VCLM3!") DO (SET "$SUBGROUP_LAST=%$$%( %##%%$XNT%%$$% ) %%░%$$%")
FOR %%░ IN (X) DO (
IF NOT "%%1"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%"
IF NOT "%%2"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%"
IF NOT "%%3"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%"
IF NOT "%%4"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%"
IF NOT "%%5"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%"
IF NOT "%%6"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%"
IF NOT "%%7"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%"
IF NOT "%%8"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%%%8%U00%"
IF NOT "%%9"=="" SET "$ITEM%$XNT%=%U00%%%1%U00%%%2%U00%%%3%U00%%%4%U00%%%5%U00%%%6%U00%%%7%U00%%%8%U00%%%9%U00%"
IF "%%1"=="" SET "$ITEM%$XNT%=")
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:NORMAL_LIST
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
FOR %%▓ in (FULL_TARGET $LIST_FILE) DO (IF NOT DEFINED %%▓ EXIT /B)
IF NOT EXIST "%$LIST_FILE%" EXIT /B
SET "NORMAL_LISTX="&&SET "WRITEZ="&&SET "$XNT="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%a in ($TEMP) DO (
IF /I "%%a"=="GROUP" IF "%%b"=="!GROUP_TARGET!" IF "%%c"=="!SUB_TARGET!" SET "NORMAL_LISTX=1"&&SET "WRITEZ=1"
IF /I "%%a"=="GROUP" IF NOT "%%b"=="!GROUP_TARGET!" SET "NORMAL_LISTX="
IF /I "%%a"=="GROUP" IF NOT "%%c"=="!SUB_TARGET!" SET "NORMAL_LISTX="
IF DEFINED NORMAL_LISTX IF NOT "%%a"=="" FOR /F "TOKENS=* DELIMS=ⓡ" %%░ IN ("%%a") DO (IF NOT "%%a"=="%%░" SET "$VCLMX=%%░"&&CALL:NORMAL_LIST_SKIP)
IF NOT "%%a"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%"
IF NOT "%%b"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%"
IF NOT "%%c"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%"
IF NOT "%%d"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%"
IF NOT "%%e"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"
IF NOT "%%f"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%"
IF NOT "%%g"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%"
IF NOT "%%h"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%"
IF NOT "%%i"=="" SET "$NORMAL_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%%%i%U00%"
IF "%%a"=="" SET "$NORMAL_ITEM="
IF DEFINED NORMAL_LISTX SET "$VCLM1=%%a"&&SET "$VCLM2=%%b"&&SET "$VCLM3=%%c"&&SET "$VCLM4=%%d"&&SET "$VCLM5=%%e"&&SET "$VCLM6=%%f"&&SET "$VCLM7=%%g"&&CALL:NORMAL_LISTX)
EXIT /B
:NORMAL_LIST_SKIP
SET "COLUMN0="&&FOR %%░ IN (X) DO (
IF NOT "%%a"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%"
IF NOT "%%b"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%"
IF NOT "%%c"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%"
IF NOT "%%d"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%"
IF NOT "%%e"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"
IF NOT "%%f"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%"
IF NOT "%%g"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%"
IF NOT "%%h"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%"
IF NOT "%%i"=="" SET "COLUMN0=%U00%ⓠ!$VCLMX!%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%%%i%U00%"
IF DEFINED COLUMN0 CALL:UNIFIED_PARSE_EXECUTE)
EXIT /B
:NORMAL_LISTX
SET "$VCLM1=!$VCLM1:"=!"
SET "@QUIET="&&FOR /F "TOKENS=* DELIMS=ⓠ" %%● IN ("!$VCLM1!") DO (IF NOT "%%●"=="!$VCLM1!" SET "$VCLM1=%%●"&&SET "@QUIET=1")
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
IF DEFINED WRITEZ SET "WRITEZ="&&ECHO.>>"$LIST"
FOR %%@ in (PROMPT CHOICE PICKER) DO (FOR %%▓ in (0 1 2 3 4 5 6 7 8 9) DO (IF /I "!$VCLM1!"=="%%@%%▓" CALL:NORMAL_LIST_%%@))
ECHO.!$NORMAL_ITEM!>>"$LIST"
EXIT /B
:NORMAL_LIST_CHOICE
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a in ("!$VCLM3!") DO (
IF NOT "%%a"=="" SET "$CHOICE_LIST=%U01%%%a%U01%"
IF NOT "%%b"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%"
IF NOT "%%c"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%"
IF NOT "%%d"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%"
IF NOT "%%e"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%"
IF NOT "%%f"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%%%f%U01%"
IF NOT "%%g"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%%%f%U01%%%g%U01%"
IF NOT "%%h"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%%%f%U01%%%g%U01%%%h%U01%"
IF NOT "%%i"=="" SET "$CHOICE_LIST=%U01%%%a%U01%%%b%U01%%%c%U01%%%d%U01%%%e%U01%%%f%U01%%%g%U01%%%h%U01%%%i%U01%"
IF "%%a"=="" SET "$CHOICE_LIST=")
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%!$VCLM2!"
SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:CHOICE_BOX
IF DEFINED @QUIET FOR /F "TOKENS=*" %%● IN ("!$VCLM1!") DO (SET "$VCLM1=ⓠ%%●")
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!SELECT!%U00%"
EXIT /B
:NORMAL_LIST_PICKER
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%!$VCLM2!"
SET "$FOLD="&&SET "$FILT="&&FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$VCLM3!") DO (SET "$FOLD=%%a"&&SET "$FILT=%%b")
IF NOT DEFINED $FILT SET "$FILT=*.*"
IF NOT DEFINED $FOLD SET "$FOLD=%ProgFolder%"
SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:FILE_VIEWER
IF DEFINED @QUIET FOR /F "TOKENS=*" %%● IN ("!$VCLM1!") DO (SET "$VCLM1=ⓠ%%●")
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!$CHOICE!%U00%"
EXIT /B
:NORMAL_LIST_PROMPT
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01% %U01% %U01%!$VCLM2!%U01% %U01% "
SET "$CHECK=!$VCLM3!"&&SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:PROMPT_BOX
IF DEFINED @QUIET FOR /F "TOKENS=*" %%● IN ("!$VCLM1!") DO (SET "$VCLM1=ⓠ%%●")
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!SELECT!%U00%"
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:DRAWER_BOX
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
IF NOT DEFINED FULL_TARGET EXIT /B
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&SET "$CENTERED=1"&&SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%"&&CALL:BOX_HEADERS&&CALL:DRAWER_LIST
IF NOT DEFINED $ITEMD1 ECHO.   Empty.
ECHO.&&ECHO.                        Multiples OK ( %##%1 2 3%$$% )&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
SET "LIST_STARTZ="&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF DEFINED SELECT FOR %%a in (%SELECT%) DO (CALL SET "$DRAWER_ITEM=%%$ITEMD%%a%%"&&CALL:DRAWER_WRITE)
IF NOT DEFINED LIST_STARTZ IF DEFINED SELECT FOR /F "TOKENS=*" %%■ in ("%SELECT_LAST% ") DO (ECHO.%COLOR4%ERROR:%$$% input [ %COLOR4%%%■%$$%] is invalid)
IF NOT DEFINED $ITEMD1 SET "ERROR="&&SET "$CENTERED="&&EXIT /B
IF NOT DEFINED LIST_STARTZ SET "ERROR="&&GOTO:DRAWER_BOX
SET "$CENTERED="&&EXIT /B
:DRAWER_LIST
FOR %%▓ in (FULL_TARGET $LIST_FILE) DO (IF NOT DEFINED %%▓ EXIT /B)
IF NOT EXIST "%$LIST_FILE%" EXIT /B
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEMD%%a SET "$ITEMD%%a=")
SET "DRAWER_LISTX="&&SET "WRITEZ="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%a in ($TEMP) DO (
IF /I "%%a"=="GROUP" IF "%%b"=="!GROUP_TARGET!" IF "%%c"=="!SUB_TARGET!" SET "DRAWER_LISTX=1"
IF /I "%%a"=="GROUP" IF NOT "%%b"=="!GROUP_TARGET!" SET "DRAWER_LISTX="
IF /I "%%a"=="GROUP" IF NOT "%%c"=="!SUB_TARGET!" SET "DRAWER_LISTX="
IF NOT "%%a"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%"
IF NOT "%%b"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%"
IF NOT "%%c"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%"
IF NOT "%%d"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%"
IF NOT "%%e"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"
IF NOT "%%f"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%"
IF NOT "%%g"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%"
IF NOT "%%h"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%"
IF NOT "%%i"=="" SET "$DRAWER_ITEM=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%%%i%U00%"
IF "%%a"=="" SET "$DRAWER_ITEM="
IF DEFINED DRAWER_LISTX IF DEFINED $DRAWER_ITEM CALL:DRAWER_LISTX)
EXIT /B
:DRAWER_LISTX
IF NOT DEFINED $XNT SET "$XNT=0"&&EXIT /B
SET /A "$XNT+=1"
IF /I "!GROUP_TYPE!"=="DRAWER" FOR /F "TOKENS=*" %%□ IN ("!$DRAWER_ITEM!") DO (SET "$ITEMD%$XNT%=%%□"&&ECHO. %$$%^( %##%%$XNT%%$$% ^) %%□%$$%)
IF /I "!GROUP_TYPE!"=="SCOPED" FOR /F "TOKENS=*" %%□ IN ("!$DRAWER_ITEM!") DO (SET "$ITEMD%$XNT%=%%□"&&ECHO. %$$%^( %##%%$XNT%%$$% ^) %%b%$$%)
EXIT /B
:DRAWER_WRITE
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
IF DEFINED GROUP_CHOICES CALL:DRAWER_WRITE_CHOICE&&ECHO.>>"$LIST"
IF DEFINED GROUP_CHOICES SET "GROUP_CHOICES="&&FOR /F "TOKENS=*" %%▓ in ("!GROUP_ITEM!") DO (ECHO.%%▓>>"$LIST")
FOR /F "TOKENS=*" %%▓ in ("!$DRAWER_ITEM!") DO (SET "$DRAWER_ITEM="&&ECHO.%%▓>>"$LIST")
SET "LIST_STARTZ=1"&&EXIT /B
:DRAWER_WRITE_CHOICE
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="&&SET "GROUP_ITEM="
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 IN ("!$DRAWER_ITEM!") DO (SET "$ARBIT=%%2")
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%  !GROUP_MSG!"
SET "$CHOICE_LIST=!GROUP_CHOICES!"&&SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:CHOICE_BOX
FOR /F "TOKENS=1-9 DELIMS=❕" %%a in ("!FULL_TARGET!") DO (SET "GROUP_ITEM=❕%%a❕%%b❕%%c❕%%d❕%%e❕%%f❕!SELECT!❕")
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:PROMPT_BOX
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&CALL:BOX_HEADERS&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
IF NOT DEFINED $NO_ERRORS CALL:PAD_PREV
IF NOT DEFINED $CASE SET "$CASE=ANY"
CALL:MENU_SELECT
IF DEFINED $NO_ERRORS IF DEFINED ERROR GOTO:PROMPT_BOX
FOR %%a in ($NO_ERRORS $HEADERS $CENTERED) DO (SET "%%a=")
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:CHOICE_BOX
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&CALL:BOX_HEADERS&&ECHO.
CALL:CHOICE_LIST
IF NOT DEFINED $ITEMC1 ECHO.   Empty.
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&IF NOT DEFINED $NO_ERRORS CALL:PAD_PREV
IF DEFINED $CHOICEMINO SET "$CHOICEMIN=0"
IF NOT DEFINED $CHOICEMINO SET "$CHOICEMIN=1"
IF DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$CHOICEMAXO%"
IF NOT DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$XNT%"
IF DEFINED $CHECKO SET "$CHECK=%$CHECKO%"
IF NOT DEFINED $CHECKO SET "$CHECK=NUMBER❗%$CHOICEMIN%-%$CHOICEMAX%"
SET "$VERBOSE=1"&&CALL:MENU_SELECT
IF DEFINED $NO_ERRORS IF NOT DEFINED $ITEMC1 SET "ERROR="
IF DEFINED $NO_ERRORS IF DEFINED ERROR IF DEFINED $ITEMC1 GOTO:CHOICE_BOX
FOR %%a in ($NO_ERRORS $CHOICE_LIST $ITEMSTOP $ITEMSBTM $CHOICEMINO $CHOICEMAXO $CHECKO $HEADERS $CENTERED) DO (SET "%%a=")
EXIT /B
:CHOICE_LIST
FOR %%a in ($CHOICE_LIST) DO (IF NOT DEFINED %%a GOTO:CHOICE_LIST_SKIP)
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEMC%%a SET "$ITEMC%%a=")
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
SET "$CHOICE_LIST=!$CHOICE_LIST:◁=%%!"&&SET "$CHOICE_LIST=!$CHOICE_LIST:▷=%%!"
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$CHOICE_LIST!") DO (
IF "%%e"=="" ECHO.&&IF "%%c"=="" ECHO.&&IF "%%a"=="" ECHO.
IF NOT "%%a"=="" SET "$VCLM$=%%a"&&CALL:CHOICE_LISTX&&IF NOT "%%b"=="" SET "$VCLM$=%%b"&&CALL:CHOICE_LISTX&&IF NOT "%%c"=="" SET "$VCLM$=%%c"&&CALL:CHOICE_LISTX&&IF NOT "%%d"=="" SET "$VCLM$=%%d"&&CALL:CHOICE_LISTX&&IF NOT "%%e"=="" SET "$VCLM$=%%e"&&CALL:CHOICE_LISTX&&IF NOT "%%f"=="" SET "$VCLM$=%%f"&&CALL:CHOICE_LISTX&&IF NOT "%%g"=="" SET "$VCLM$=%%g"&&CALL:CHOICE_LISTX&&IF NOT "%%h"=="" SET "$VCLM$=%%h"&&CALL:CHOICE_LISTX&&IF NOT "%%i"=="" SET "$VCLM$=%%i"&&CALL:CHOICE_LISTX
IF "%%f"=="" ECHO.&&IF "%%d"=="" ECHO.&&IF "%%b"=="" ECHO.)
IF NOT DEFINED $ITEMC1 ECHO.&&ECHO.   Empty.&&ECHO.
IF DEFINED $ITEMSBTM CALL:ITEMSBTM
:CHOICE_LIST_SKIP
FOR %%a in (XXX) DO (SET "%%a=")
EXIT /B
:CHOICE_LISTX
CALL SET /A "$XNT+=1"
CALL SET "$ITEMC%$XNT%=!$VCLM$!"
FOR /F "TOKENS=*" %%# in ("!$VCLM$!") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %%#)
EXIT /B
:ITEMSTOP
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$ITEMSTOP!") DO (IF NOT "%%a"=="" ECHO.%%a&&IF NOT "%%b"=="" ECHO.%%b&&IF NOT "%%c"=="" ECHO.%%c&&IF NOT "%%d"=="" ECHO.%%d&&IF NOT "%%e"=="" ECHO.%%e&&IF NOT "%%f"=="" ECHO.%%f&&IF NOT "%%g"=="" ECHO.%%g&&IF NOT "%%h"=="" ECHO.%%h&&IF NOT "%%i"=="" ECHO.%%i)
EXIT /B
:ITEMSBTM
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$ITEMSBTM!") DO (IF NOT "%%a"=="" ECHO.%%a&&IF NOT "%%b"=="" ECHO.%%b&&IF NOT "%%c"=="" ECHO.%%c&&IF NOT "%%d"=="" ECHO.%%d&&IF NOT "%%e"=="" ECHO.%%e&&IF NOT "%%f"=="" ECHO.%%f&&IF NOT "%%g"=="" ECHO.%%g&&IF NOT "%%h"=="" ECHO.%%h&&IF NOT "%%i"=="" ECHO.%%i)
EXIT /B
:BOX_HEADERS
IF NOT DEFINED $HEADERS EXIT /B
SET "$HEADERS_LAST=!$HEADERS!"&&SET "$HEADERSX=!$HEADERS:◁=%%!"&&SET "$HEADERSX=!$HEADERSX:▷=%%!"
IF NOT "!$HEADERSX!"=="!$HEADERS!" CALL SET "$HEADERS=!$HEADERSX!"
IF NOT DEFINED $CENTERED FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$HEADERS!") DO (IF NOT "%%a"=="" ECHO.%%a&&IF NOT "%%b"=="" ECHO.%%b&&IF NOT "%%c"=="" ECHO.%%c&&IF NOT "%%d"=="" ECHO.%%d&&IF NOT "%%e"=="" ECHO.%%e&&IF NOT "%%f"=="" ECHO.%%f&&IF NOT "%%g"=="" ECHO.%%g&&IF NOT "%%h"=="" ECHO.%%h&&IF NOT "%%i"=="" ECHO.%%i)
IF DEFINED $CENTERED FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$HEADERS!") DO (IF NOT "%%a"=="" SET "$CENTERED_MSG=%%a"&&CALL:TXT_CENTER&&IF NOT "%%b"=="" SET "$CENTERED_MSG=%%b"&&CALL:TXT_CENTER&&IF NOT "%%c"=="" SET "$CENTERED_MSG=%%c"&&CALL:TXT_CENTER&&IF NOT "%%d"=="" SET "$CENTERED_MSG=%%d"&&CALL:TXT_CENTER&&IF NOT "%%e"=="" SET "$CENTERED_MSG=%%e"&&CALL:TXT_CENTER&&IF NOT "%%f"=="" SET "$CENTERED_MSG=%%f"&&CALL:TXT_CENTER&&IF NOT "%%g"=="" SET "$CENTERED_MSG=%%g"&&CALL:TXT_CENTER&&IF NOT "%%h"=="" SET "$CENTERED_MSG=%%h"&&CALL:TXT_CENTER&&IF NOT "%%i"=="" SET "$CENTERED_MSG=%%i"&&CALL:TXT_CENTER)
SET "$HEADERS=!$HEADERS_LAST!"
EXIT /B
:TXT_CENTER
IF "!$CENTERED_MSG!"==" " ECHO.&&SET "$CENTERED_MSG="&&SET "$QUIET="&&EXIT /B
SET "$XNT="&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO."!$CENTERED_MSG!"^| FIND /V ""') do (SET /A "$XNT+=1")
SET "$TSPACE=35"&&SET /A "$XNT/=2"
SET /A "$TSPACE-=%$XNT%"&&SET "$SPACE_BUF="&&SET "$XNT="&&FOR %%1 in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35) DO (SET "$XNT=%%1"&&CALL:CENTER_TITLE)
FOR /F "TOKENS=* DELIMS=" %%a in ("%$SPACE_BUF%!$CENTERED_MSG!") DO (SET "TXT_CENTER=%%a"&&IF NOT DEFINED $QUIET ECHO.%%a)
FOR %%a in ($CENTERED_MSG $SPACE_BUF $TSPACE $QUIET) DO (SET "%%a=")
EXIT /B
:CENTER_TITLE
IF NOT DEFINED $TSPACE EXIT /B
SET "$SPACE_BUF= %$SPACE_BUF%"&&IF "%$XNT%"=="%$TSPACE%" SET "$TSPACE="
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:SETTINGS_MENU
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:SETS_HANDLER&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                              %U03% Settings&&ECHO.&&ECHO.
ECHO. (%##% 1 %$$%) %U12% Appearance&&ECHO. (%##% 2 %$$%) %U15% Shortcuts&&ECHO. (%##% 3 %$$%) %U18% Compression          %@@%%COMPRESS%%$$%&&ECHO. (%##% 4 %$$%) %U02% Folder Layout        %@@%%FOLDER_MODE%%$$%
IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% 5 %$$%) %U19% Host Hide            %@@%%HOST_HIDE%%$$%&&ECHO. (%##% 6 %$$%) %U07% Update
ECHO. (%##% . %$$%) %U17% Clear Settings
IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% * %$$%) %U01% %COLOR2%Enable Custom Menu%$$%
ECHO.&&ECHO.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT IF DEFINED MENU_EXIT GOTO:QUIT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="~" IF NOT "%DEBUG%"=="ENABLED" SET "DEBUG=ENABLED"&SET "SELECT="
IF "%SELECT%"=="~" IF "%DEBUG%"=="ENABLED" SET "DEBUG=DISABLED"&SET "SELECT="
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="RAMDISK" GOTO:MENU_LIST
IF "%SELECT%"=="." CALL:SETS_CLEAR&SET "SELECT="
IF "%SELECT%"=="1" GOTO:APPEARANCE
IF "%SELECT%"=="2" GOTO:SHORTCUTS
IF "%SELECT%"=="3" CALL:COMPRESS_LVL&SET "SELECT="
IF "%SELECT%"=="4" CALL:FOLDER_MODE&SET "SELECT="
IF "%SELECT%"=="5" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="DISABLED" SET "HOST_HIDE=ENABLED"&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.           The vhdx host partition will be hidden upon exit.&&ECHO.                     Boot into recovery to revert.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED&SET "SELECT="
IF "%SELECT%"=="5" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="ENABLED" SET "HOST_HIDE=DISABLED"&&SET "SELECT="
IF "%SELECT%"=="6" IF "%PROG_MODE%"=="RAMDISK" GOTO:UPDATE_RECOVERY
GOTO:SETTINGS_MENU
:MENU_LIST
SET "$HEADERS=                        %U01% Custom Main Menu %U01%%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new template"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF DEFINED ERROR GOTO:SETTINGS_MENU
IF "%SELECT%"=="0" CALL:MENU_TEMPLATE&GOTO:MENU_LIST
SET "MENU_LISTX=%$CHOICE%"&&SET "$HEADERS= %U01%                %COLOR2%Attention:%$$% This is an advanced feature%U01%    that can be used in reboot to restore and many other scenerios.%U01% %U01% %U01%         Proceeding will load a list instead of the main menu.%U01% %U01% %U01%                         Press (%##%X%$$%) to proceed"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" GOTO:MENU_LIST
SET "MENU_LIST=%MENU_LISTX%"&&SET "MENU_MODE=CUSTOM"&&ECHO.&&ECHO.Using %@@%%MENU_LISTX%%$$% instead of the main menu.&&ECHO.&&CALL:PAUSED&GOTO:CUSTOM_MODE
GOTO:MENU_LIST
:MENU_TEMPLATE
SET "$HEADERS=                     Custom Recovery Menu Template"&&SET "$CHOICE_LIST=Base-List%U01%Exec-List"&&SET "$SELECT=SELECTX"&&CALL:CHOICE_BOX
IF DEFINED ERROR EXIT /B
IF "%SELECTX%"=="1" SET "REC_LIST=base"
IF "%SELECTX%"=="2" SET "REC_LIST=list"
SET "$HEADERS= %U01% %U01% %U01% %U01%                        Enter name of new .%REC_LIST%%U01% %U01% %U01% "&&SET "$SELECT=NEW_NAME"&&SET "$CHECK=PATH"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF "%SELECTX%"=="1" CALL:MENU_EXAMPLE_BASE>"%ListFolder%\%NEW_NAME%.%REC_LIST%"
IF "%SELECTX%"=="2" CALL:MENU_EXAMPLE_EXEC>"%ListFolder%\%NEW_NAME%.%REC_LIST%"
START NOTEPAD.EXE "%ListFolder%\%NEW_NAME%.%REC_LIST%"
EXIT /B
:APPEARANCE
CLS&&CALL:SETS_HANDLER&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U12% Appearance&&ECHO.&&ECHO.&&ECHO. (%##% 1 %$$%) Pad Type           %@@%PAD %PAD_TYPE%%$$%&&ECHO. (%##% 2 %$$%) Pad Size           %@@%%PAD_SIZE%%$$%&&ECHO. (%##% 3 %$$%) Pad Sequence       %@@%%PAD_SEQ%%$$%&&CALL ECHO. (%##% 4 %$$%) Text Color         %@@%COLOR %%COLOR%TXT_COLOR%%%%TXT_COLOR%%$$%&&CALL ECHO. (%##% 5 %$$%) Accent Color       %@@%COLOR %%COLOR%ACC_COLOR%%%%ACC_COLOR%%$$%&&CALL ECHO. (%##% 6 %$$%) Button Color       %@@%COLOR %%COLOR%BTN_COLOR%%%%BTN_COLOR%%$$%&&ECHO. (%##% 7 %$$%) Pad Box            %@@%%PAD_BOX%%$$%&&ECHO.&&ECHO.&&ECHO.                         Color (%##% - %$$%/%##% + %$$%) Shift&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:SETTINGS_MENU
IF "%SELECT%"=="+" CALL:COLOR_SHIFT_TXT&SET "SELECT="
IF "%SELECT%"=="-" CALL:COLOR_SHIFT_PAD&SET "SELECT="
IF "%SELECT%"=="1" CALL:PAD_TYPE&SET "SELECT="
IF "%SELECT%"=="2" IF "%PAD_SIZE%"=="LARGE" SET "PAD_SIZE=SMALL"&SET "SELECT="
IF "%SELECT%"=="2" IF "%PAD_SIZE%"=="SMALL" SET "PAD_SIZE=LARGE"&SET "SELECT="
IF "%SELECT%"=="3" SET "$HEADERS=                             %U12% Appearance%U01% %U01%                  Enter 10 digit color sequence seed%U01% %U01% %U01% %U01% %U01%          [ %COLOR0%0%COLOR0%0%COLOR0%0%COLOR0%0%COLOR0%0%COLOR6%6%COLOR6%6%COLOR6%6%COLOR6%6%COLOR6%6%$$% ]    [ %COLOR0%0%COLOR1%1%COLOR2%2%COLOR3%3%COLOR4%4%COLOR5%5%COLOR6%6%COLOR7%7%COLOR8%8%COLOR9%9%$$% ]    [ %COLOR1%11%COLOR2%22%COLOR3%33%COLOR4%44%COLOR5%55%$$% ]%U01% %U01% "&&SET "$SELECT=COLOR_XXX"&&SET "$CHECK=NUMBER"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF "%SELECT%"=="3" SET "XNTX="&&FOR /F "DELIMS=" %%G IN ('%CMD% /D /U /C ECHO.%COLOR_XXX%^| FIND /V ""') do (CALL SET /A XNTX+=1)
IF "%SELECT%"=="3" IF "%XNTX%"=="10" SET "PAD_SEQ=%COLOR_XXX%"&&SET "COLOR_XXX="&SET "SELECT="
IF "%SELECT%"=="4" SET "COLOR_TMP=TXT_COLOR"&&CALL:COLOR_CHOICE&SET "SELECT="
IF "%SELECT%"=="5" SET "COLOR_TMP=ACC_COLOR"&&CALL:COLOR_CHOICE&SET "SELECT="
IF "%SELECT%"=="6" SET "COLOR_TMP=BTN_COLOR"&&CALL:COLOR_CHOICE&SET "SELECT="
IF "%SELECT%"=="7" IF "%PAD_BOX%"=="DISABLED" SET "PAD_BOX=ENABLED"&SET "SELECT="
IF "%SELECT%"=="7" IF "%PAD_BOX%"=="ENABLED" SET "PAD_BOX=DISABLED"&SET "SELECT="
GOTO:APPEARANCE
:PAD_TYPE
SET "$HEADERS=                             %U12% Appearance%U01% %U01%                           Select a pad type%U01% %U01% %U01% (%##%0%$$%) %@@%None%$$%  (%##%1%$$%) %@@%─%$$%  (%##%2%$$%) %@@%━%$$%  (%##%3%$$%) %@@%◌%$$%  (%##%4%$$%) %@@%○%$$%  (%##%5%$$%) %@@%●%$$%  (%##%6%$$%) %@@%❍%$$%  (%##%7%$$%) %@@%□%$$%  (%##%8%$$%) %@@%■%$$%%U01% %U01%    (%##%9%$$%) %@@%☰%$$%  (%##%10%$$%) %@@%☲%$$%  (%##%11%$$%) %@@%░%$$%  (%##%12%$$%) %@@%▒%$$%  (%##%13%$$%) %@@%▓%$$%   (%##%14%$$%) %@@%~%$$%  (%##%15%$$%) %@@%=%$$%  (%##%16%$$%) %@@%#%$$%%U01% "&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER❗0-16"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "PAD_TYPE=%SELECTX%"
EXIT /B
:COLOR_CHOICE
SET "$HEADERS=                             %U12% Appearance%U01% %U01%                             Select a color%U01% %U01% %U01% %U01%                  [ %COLOR0% 0 %COLOR1% 1 %COLOR2% 2 %COLOR3% 3 %COLOR4% 4 %COLOR5% 5 %COLOR6% 6 %COLOR7% 7 %COLOR8% 8 %COLOR9% 9 %$$% ]%U01% %U01% "&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER❗0-9"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "%COLOR_TMP%=%SELECTX%"
SET "COLOR_TMP="&&EXIT /B
:COLOR_SHIFT_PAD
FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%PAD_SEQ%^| FIND /V ""') do (SET "XXX_XXX=%%G"&&SET /A "PAD_XNT+=1"&&CALL:PAD_XNT)
SET "PAD_SEQ=%PAD_SHIFT%"&&FOR %%a in (PAD_SHIFT PAD_XNT XXX_XXX) DO (SET "%%a=")
EXIT /B
:COLOR_SHIFT_TXT
FOR %%a in (TXT_COLOR ACC_COLOR BTN_COLOR) DO (SET /A "%%a+=1")
IF "%TXT_COLOR%"=="10" SET "TXT_COLOR=0"
IF "%ACC_COLOR%"=="10" SET "ACC_COLOR=0"
IF "%BTN_COLOR%"=="10" SET "BTN_COLOR=0"
EXIT /B
:PAD_XNT
IF %PAD_XNT% GTR 10 EXIT /B
SET /A "XXX_XXX+=1"&&IF "%XXX_XXX%"=="9" SET "XXX_XXX=0"
SET "PAD_SHIFT=%PAD_SHIFT%%XXX_XXX%"
EXIT /B
:COMPRESS_LVL
IF /I "%COMPRESS%"=="FAST" SET "COMPRESS=MAX"&&EXIT /B
IF /I "%COMPRESS%"=="MAX" SET "COMPRESS=FAST"&&EXIT /B
EXIT /B
:SHORTCUTS
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&SET "$HEADERS=                             %U15% Shortcuts%U01% %U01%                      Select a main menu shortcut"&&SET "$CHOICE_LIST=%HOTKEY_1%	%SHORT_1%%U01%%HOTKEY_2%	%SHORT_2%%U01%%HOTKEY_3%	%SHORT_3%"&&CALL:CHOICE_BOX
IF DEFINED ERROR GOTO:SETTINGS_MENU
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:SETTINGS_MENU
IF DEFINED SELECT CALL:SHORTCUT_RUN
SET "SHORT_SET="&&FOR %%a in (1 2 3) DO (
IF "%SELECT%"=="%%a" SET "SHORT_SET=1"&&SET "$HEADERS=                             %U15% Shortcuts%U01% %U01% %U01% %U01% %U01%             Enter a command or the path to an application%U01% %U01% %U01% "&&SET "$SELECT=SHORT_X%SELECT%"&&SET "$CASE=ANY"&&SET "$CHECK=MOST"&&CALL:PROMPT_BOX
IF "%SELECT%"=="%%a" IF NOT DEFINED ERROR CALL SET "SHORT_%SELECT%=%%SHORT_X%SELECT%%%"&&SET "$HEADERS=                             %U15% Shortcuts%U01% %U01% %U01% %U01% %U01%                         Enter 3+ digit hotkey%U01% %U01% %U01% "&&SET "$SELECT=HOTKEY_X%SELECT%"&&SET "$CASE=ANY"&&SET "$CHECK=ALPHA"&&CALL:PROMPT_BOX
IF "%SELECT%"=="%%a" IF NOT DEFINED ERROR CALL SET "HOTKEY_%SELECT%=%%HOTKEY_X%SELECT%%%"&&SET "SHORT_XNT=0"&&FOR /F "DELIMS=" %%G in ('CALL %CMD% /D /U /C ECHO.%%HOTKEY_%SELECT%%%^| FIND /V ""') do (CALL SET /A "SHORT_XNT+=1"))
IF DEFINED SHORT_SET IF NOT DEFINED ERROR IF NOT "%SHORT_XNT%" GEQ "3" SET "HOTKEY_%SELECT%="&&SET "SHORT_%SELECT%="
GOTO:SHORTCUTS
:SHORTCUT_RUN
IF "%SELECT%"=="%HOTKEY_1%" SET "SHORT_RUN=%SHORT_1%"
IF "%SELECT%"=="%HOTKEY_2%" SET "SHORT_RUN=%SHORT_2%"
IF "%SELECT%"=="%HOTKEY_3%" SET "SHORT_RUN=%SHORT_3%"
IF NOT DEFINED SHORT_RUN EXIT /B
CALL START %SHORT_RUN%
SET "SHORT_RUN="&&EXIT /B
:AUTOBOOT_SVC
CALL:GET_NEXTBOOT
IF NOT DEFINED BOOT_OK ECHO.%COLOR4%ERROR:%$$% The boot environment is not installed on this system.&&EXIT /B
IF "%BOOTSVC%"=="INSTALL" ECHO.Recovery switcher service is installed.&&SC CREATE AutoBoot binpath="%WinDir%\SYSTEM32\%CMD% /C %BCDEDIT% /displayorder %GUID_TMP% /addfirst" start=auto>NUL 2>&1
IF "%BOOTSVC%"=="REMOVE" ECHO.Recovery switcher service is removed.&&SC DELETE AutoBoot>NUL 2>&1
SET "BOOTSVC="&&EXIT /B
:UPDATE_RECOVERY
CLS&&CALL:SETS_HANDLER&&CALL:GET_SPACE_ENV&&SET "$HEADERS=                            Recovery Update"&&SET "$CHOICE_LIST=Program  (%##%*%$$%) Test%U01%Recovery Wallpaper%U01%Recovery Password%U01%Boot Media%U01%Host Folder%U01%EFI Files%U01%windick.ini"&&SET "$CHECKO=MENU"&&SET "$VERBOSE=1"&&CALL:CHOICE_BOX
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:SETTINGS_MENU
IF "%SELECT%"=="*" IF EXIST "%ProgFolder%\windick.cmd" SET "VER_GET=%ProgFolder%\windick.cmd"&&CALL:GET_PROGVER&&COPY /Y "%ProgFolder%\windick.cmd" "%ProgFolder0%"&GOTO:MAIN_MENU
SET "$GO="&&FOR %%a in (1 2 3 4 5 6 7) DO (IF "%SELECT%"=="%%a" SET "$GO=1")
IF NOT DEFINED $GO GOTO:UPDATE_RECOVERY
FOR %%a in (0 1 2 3 4 5 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END)
IF "%SELECT%"=="1" SET "UPDATE_TYPE=PROG"
IF "%SELECT%"=="2" SET "UPDATE_TYPE=WALL"
IF "%SELECT%"=="3" SET "UPDATE_TYPE=PASS"
IF "%SELECT%"=="4" SET "UPDATE_TYPE=BOOT"
IF "%SELECT%"=="5" SET "UPDATE_TYPE=HOST"
IF "%SELECT%"=="6" SET "UPDATE_TYPE=EFI"
IF "%SELECT%"=="7" SET "UPDATE_TYPE=SETS"
IF "%UPDATE_TYPE%"=="SETS" SET "$HEADERS=                           Default Settings"&&SET "$NO_ERRORS=1"&&SET "$CHOICE_LIST=Replace windick.ini%U01%Remove windick.ini"&&SET "$VERBOSE=1"&&CALL:CHOICE_BOX
IF "%UPDATE_TYPE%"=="SETS" IF DEFINED ERROR GOTO:UPDATE_RECOVERY
IF "%UPDATE_TYPE%"=="SETS" IF "%SELECT%"=="1" SET "UPDATE_TYPE=CONFIG"
IF "%UPDATE_TYPE%"=="SETS" IF "%SELECT%"=="2" SET "UPDATE_TYPE=DEL_CONFIG"
IF "%UPDATE_TYPE%"=="CONFIG" IF NOT EXIST "%ProgFolder%\windick.ini" ECHO.%COLOR4%ERROR:%$$% File windick.ini is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="EFI" IF NOT EXIST "%CacheFolder%\boot.sdi" IF NOT EXIST "%CacheFolder%\bootmgfw.efi" ECHO.%COLOR4%ERROR:%$$% Files boot.sdi and bootmgfw.efi are not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%CacheFolder%\boot.sav" ECHO.%COLOR4%ERROR:%$$% File boot.sav is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PROG" IF NOT EXIST "%ProgFolder%\windick.cmd" ECHO.%COLOR4%ERROR:%$$% File windick.cmd is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PROG" SET "VER_GET=%ProgFolder%\windick.cmd"&&SET "VER_SET=VER_X"&&CALL:GET_PROGVER
IF "%UPDATE_TYPE%"=="PROG" SET "VER_GET=%ProgFolder0%\windick.cmd"&&SET "VER_SET=VER_Y"&&CALL:GET_PROGVER
IF "%UPDATE_TYPE%"=="PROG" IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File windick.cmd is corrupt. Abort.&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PASS" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.        %COLOR4%Important:%$$% Do not use any of these symbols [%COLOR2% ^< ^> %% ^^! ^& ^^^^ %$$%].&&ECHO.&&ECHO.                       Enter new recovery password&&ECHO.               Press (%##%0%$$%) to remove the recovery password&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&SET "$SELECT=RECOVERY_LOCK"&&SET "$CASE=ANY"&&SET "$CHECK=MOST"&&SET "$VERBOSE=1"&&CALL:MENU_SELECT
IF "%UPDATE_TYPE%"=="PASS" IF DEFINED ERROR CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PASS" IF "%RECOVERY_LOCK%"=="0" SET "RECOVERY_LOCK="
IF "%UPDATE_TYPE%"=="WALL" CALL:PE_WALLPAPER
IF "%UPDATE_TYPE%"=="WALL" IF NOT DEFINED $PICK SET "ERROR=UPDATE_RECOVERY"&&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="HOST" CALL:HOST_FOLDER
IF "%UPDATE_TYPE%"=="HOST" IF DEFINED ERROR GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="HOST" IF EXIST "Z:\%HOST_FOLDER%" ECHO.%COLOR2%ERROR:%$$% Host folder %@@%%HOST_FOLDER%%$$% already exists. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="HOST" REN "Z:\%HOST_FOLDERX%" "%HOST_FOLDER%">NUL 2>&1
IF "%UPDATE_TYPE%"=="HOST" IF NOT EXIST "Z:\%HOST_FOLDER%" ECHO.%COLOR2%ERROR:%$$% Host folder is currently in use. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="HOST" REN "Z:\%HOST_FOLDER%" "%HOST_FOLDERX%">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" SET "$PATH_X=%SYSTEMDRIVE%"&&CALL:GET_PATHINFO&MOVE /Y "%CacheFolder%\boot.sav" "%CacheFolder%\$BOOT.wim">NUL
IF "%UPDATE_TYPE%"=="BOOT" SET "INDEX_WORD=Setup"&&SET "$IMAGE_X=%CacheFolder%\$BOOT.wim"&&CALL:GET_WIMINDEX
IF "%UPDATE_TYPE%"=="BOOT" IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
IF "%UPDATE_TYPE%"=="BOOT" SET "$IMAGE_X=%CacheFolder%\$BOOT.wim"&&SET "INDEX_X=%INDEX_Z%"&&CALL:GET_IMAGEINFO
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CacheFolder%\$BOOT.wim" "%CacheFolder%\boot.sav">NUL
IF "%UPDATE_TYPE%"=="BOOT" IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&CALL:PAUSED&GOTO:UPDATE_END
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.
IF "%UPDATE_TYPE%"=="DEL_CONFIG" ECHO.           This will remove the default windick.ini file.
IF "%UPDATE_TYPE%"=="CONFIG" ECHO.           This will replace the default windick.ini file.
IF "%UPDATE_TYPE%"=="EFI" ECHO.             This will replace the current EFI boot files.
IF "%UPDATE_TYPE%"=="BOOT" ECHO.        This will replace %@@%v%$PATHVER%%$$% with %@@%v%$IMGVER%%$$%
IF "%UPDATE_TYPE%"=="PROG" ECHO.                  This will replace %@@%v%VER_Y%%$$% with %@@%v%VER_X%%$$%.
IF "%UPDATE_TYPE%"=="PASS" IF DEFINED RECOVERY_LOCK ECHO.           Recovery password will be changed to %@@%%RECOVERY_LOCK%%$$%.
IF "%UPDATE_TYPE%"=="PASS" IF NOT DEFINED RECOVERY_LOCK ECHO.                  Recovery password will be cleared.
IF "%UPDATE_TYPE%"=="WALL" ECHO.              This will replace the recovery background.
IF "%UPDATE_TYPE%"=="HOST" ECHO.              Host folder will be changed to %@@%%HOST_FOLDER%%$$%.&&ECHO.       %COLOR4%NOTE:%$$% The boot menu will need to be configured next boot.
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&SET "TIMER=5"&&CALL:TIMER&&CALL:CONFIRM
IF NOT "%CONFIRM%"=="X" SET "ERROR=UPDATE_RECOVERY"&&GOTO:UPDATE_END
SET "REBOOT_MAN=1"&&CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.                  %COLOR4%Recovery update has been initiated.%$$%&&ECHO.  %COLOR2%Caution:%$$% Interrupting this process can render the disk unbootable.&&ECHO.
CALL:EFI_MOUNT
IF DEFINED ERROR GOTO:UPDATE_END
SET "GET_BYTES=MB"&&SET "INPUT=%EFI_LETTER%:"&&SET "OUTPUT=EFI_FREE"&&CALL:GET_FREE_SPACE
IF NOT DEFINED ERROR SET "GET_BYTES=MB"&&SET "INPUT=%EFI_LETTER%:\$.WIM"&&SET "OUTPUT=BOOT_X"&&CALL:GET_FILESIZE
IF NOT DEFINED ERROR SET /A "EFI_FREE+=%BOOT_X%"
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% Unable to get file size or free space. Abort.&&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="EFI" IF EXIST "%CacheFolder%\boot.sdi" ECHO.Using boot.sdi located in folder, for efi image boot support.&&COPY /Y "%CacheFolder%\boot.sdi" "%EFI_LETTER%:\Boot">NUL
IF "%UPDATE_TYPE%"=="EFI" IF EXIST "%CacheFolder%\bootmgfw.efi" ECHO.Using bootmgfw.efi located in folder, for the efi bootloader.&&COPY /Y "%CacheFolder%\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL
IF "%UPDATE_TYPE%"=="EFI" FOR %%a in (boot.sdi bootmgfw.efi) DO (IF NOT EXIST "%CacheFolder%\%%a" ECHO.File %%a is not located in folder, skipping.)
IF "%UPDATE_TYPE%"=="EFI" ECHO.Unmounting EFI...&&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
CALL:VTEMP_CREATE
IF DEFINED ERROR CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
ECHO.Extracting boot-media...
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CacheFolder%\boot.sav" "%CacheFolder%\$BOOT.wim">NUL
IF "%UPDATE_TYPE%"=="BOOT" SET "INDEX_WORD=Setup"&&SET "$IMAGE_X=%CacheFolder%\$BOOT.wim"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
IF NOT "%UPDATE_TYPE%"=="BOOT" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%EFI_LETTER%:\$.WIM" /INDEX:1 /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF "%UPDATE_TYPE%"=="BOOT" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%CacheFolder%\$BOOT.wim" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CacheFolder%\$BOOT.wim" "%CacheFolder%\boot.sav">NUL
IF NOT EXIST "%VDISK_LTR%:\Windows" ECHO.%COLOR2%ERROR:%$$% BOOT MEDIA&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="BOOT" MD "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%ProgFolder0%\windick.cmd" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%ProgFolder0%\HOST_TARGET" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%ProgFolder0%\HOST_FOLDER" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%WINDIR%\System32\setup.bmp" "%VDISK_LTR%:\Windows\System32">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%ProgFolder0%\SETTINGS_INI" DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%ProgFolder0%\RECOVERY_LOCK" DEL /Q /F "\\?\%VDISK_LTR%:\$\RECOVERY_LOCK">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%ProgFolder0%\SETTINGS_INI" COPY /Y "%ProgFolder0%\SETTINGS_INI" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%ProgFolder0%\RECOVERY_LOCK" COPY /Y "%ProgFolder0%\RECOVERY_LOCK" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%VDISK_LTR%:\setup.exe" DEL /Q /F "\\?\%VDISK_LTR%:\setup.exe">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" (ECHO.[LaunchApp]&&ECHO.AppPath=X:\$\windick.cmd)>"%VDISK_LTR%:\Windows\System32\winpeshl.ini"
IF "%UPDATE_TYPE%"=="BOOT" ECHO.Updating boot media %@@%v%$PATHVER%%$$% to %@@%v%$IMGVER%%$$%.
IF "%UPDATE_TYPE%"=="DEL_CONFIG" ECHO.Removing default windick.ini file.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="CONFIG" ECHO.Updating default windick.ini file.&&COPY /Y "%ProgFolder%\windick.ini" "%VDISK_LTR%:\$\SETTINGS_INI">NUL
IF "%UPDATE_TYPE%"=="PROG" ECHO.Updating windick.cmd %@@%v%VER_Y%%$$% to %@@%v%VER_X%%$$%.&&COPY /Y "%ProgFolder%\windick.cmd" "%VDISK_LTR%:\$">NUL
IF "%UPDATE_TYPE%"=="PROG" ECHO.Removing default windick.ini file to ensure compatibility.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="PASS" IF DEFINED RECOVERY_LOCK ECHO.Recovery password will be changed to %@@%%RECOVERY_LOCK%%$$%.&&ECHO.%RECOVERY_LOCK%>"%VDISK_LTR%:\$\RECOVERY_LOCK"
IF "%UPDATE_TYPE%"=="PASS" IF NOT DEFINED RECOVERY_LOCK ECHO.Recovery password will be cleared.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\RECOVERY_LOCK">NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" ECHO.Using %PE_WALLPAPER% located in folder for the recovery wallpaper.
IF "%UPDATE_TYPE%"=="WALL" TAKEOWN /F "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" ICACLS "%VDISK_LTR%:\Windows\System32\setup.bmp" /grant %USERNAME%:F>NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" COPY /Y "%CacheFolder%\%PE_WALLPAPER%" "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
IF "%UPDATE_TYPE%"=="HOST" ECHO.Host folder will be changed to %@@%%HOST_FOLDER%%$$%.&&ECHO.%HOST_FOLDER%>"%VDISK_LTR%:\$\HOST_FOLDER"
ECHO.Saving boot-media...&&%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%VDISK_LTR%:" /IMAGEFILE:"%ImageFolder%\$TEMP.wim" /COMPRESS:%COMPRESS% /NAME:"WindowsPE" /CheckIntegrity /Verify /Bootable&ECHO.
SET "$IMAGE_X=%ImageFolder%\$TEMP.wim"&&SET "INDEX_X=1"&&CALL:GET_IMAGEINFO
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
SET "GET_BYTES=MB"&&SET "INPUT=%ImageFolder%\$TEMP.wim"&&SET "OUTPUT=BOOT_X"&&CALL:GET_FILESIZE
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% Unable to get file size or free space. Abort.&&ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
CALL:GET_SPACE_ENV&&FOR %%a in (EFI_FREE BOOT_X) DO (IF NOT DEFINED %%a SET "%%a=0")
IF %EFI_FREE% LEQ %BOOT_X% ECHO.%COLOR2%ERROR:%$$% File boot.sav %BOOT_X%MB exceeds %EFI_FREE%MB. Abort.&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
FOR %%a in (0 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END)
DEL /Q /F "%EFI_LETTER%:\$.WIM">NUL 2>&1
MOVE /Y "%ImageFolder%\$TEMP.wim" "%EFI_LETTER%:\$.WIM">NUL
ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT
:UPDATE_END
IF EXIST "%ImageFolder%\$TEMP.wim" DEL /Q /F "%ImageFolder%\$TEMP.wim">NUL 2>&1
IF "%UPDATE_TYPE%"=="HOST" IF NOT DEFINED ERROR REN "Z:\%HOST_FOLDERX%" "%HOST_FOLDER%">NUL 2>&1
IF NOT DEFINED ERROR FOR %%a in (Z:\%HOST_FOLDER% Z:) DO (ICACLS "%%a" /deny everyone:^(DE,WA,WDAC^)>NUL 2>&1)
IF DEFINED REBOOT_MAN ECHO.&&ECHO.                       THE SYSTEM WILL NOW RESTART.&&ECHO.&&ECHO.              %@@%UPDATE FINISH:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED&GOTO:QUIT
SET "RECOVERY_LOCK="&&GOTO:UPDATE_RECOVERY
:VTEMP_CREATE
IF DEFINED ERROR EXIT /B
IF EXIST "%ImageFolder%\$TEMP.vhdx" CALL:VTEMP_DELETE>NUL 2>&1
ECHO.Mounting temporary vdisk...&&SET "$VDISK_FILE=%ImageFolder%\$TEMP.vhdx"&&SET "VDISK_LTR=ANY"&&SET "VHDX_SIZE=50"&&CALL:VDISK_CREATE>NUL 2>&1
IF NOT EXIST "%VDISK_LTR%:\" SET "ERROR=VTEMP_CREATE"&&CALL:DEBUG
EXIT /B
:VTEMP_DELETE
IF EXIST "%ImageFolder%\$TEMP.vhdx" ECHO.Unmounting temporary vdisk...&&SET "$VDISK_FILE=%ImageFolder%\$TEMP.vhdx"&&CALL:VDISK_DETACH>NUL 2>&1
IF EXIST "%ImageFolder%\$TEMP.vhdx" DEL /Q /F "%ImageFolder%\$TEMP.vhdx">NUL 2>&1
EXIT /B
:PE_WALLPAPER
SET "$HEADERS=                          Recovery Wallpaper"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%CacheFolder%"&&SET "$FILT=*.JPG *.PNG"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=WALL"&&CALL:BASIC_FILE&EXIT /B
IF DEFINED $PICK SET "PE_WALLPAPER=%$CHOICE%"
IF NOT DEFINED $PICK SET "PE_WALLPAPER=SELECT"
EXIT /B
:HOST_FOLDER
SET "$HEADERS= %U01% %U01% %U01% %U01%                      Enter the host folder name%U01% %U01% %U01% "&&SET "$CHECK=ALPHA❗1-20"&&SET "$VERBOSE=1"&&SET "$SELECT=SELECTX"&&CALL:PROMPT_BOX
IF NOT DEFINED SELECTX SET "ERROR=HOST_FOLDER"&&CALL:DEBUG
IF DEFINED ERROR CALL:PAUSED
IF NOT DEFINED ERROR SET "HOST_FOLDER=%SELECTX%"
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:IMAGE_PROCESSING
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&FOR %%a in (SOURCE TARGET) DO (IF NOT DEFINED %%a_TYPE SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX")
SET "SOURCE_LOCATION="&&FOR %%a in (A B C D E F G H I J K L N O P Q R S T U W Y Z) DO (IF EXIST "%%a:\sources\boot.wim" SET "SOURCE_LOCATION=%%a:\sources")
SET "PROC_DISPLAY="&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                        %U07% Image Processing^|%SOURCE_TYPE%&&ECHO.
IF DEFINED SOURCE_LOCATION ECHO. (%##%-%$$%) Import Boot  %COLOR5%Windows Installation Media Detected%$$%  Import WIM (%##%+%$$%)&&ECHO.
IF NOT EXIST "%ImageFolder%\*.WIM" ECHO.        %@@%Insert a Windows Disc/ISO to import installation media%$$%&&ECHO.
IF NOT EXIST "%CacheFolder%\BOOT.SAV" ECHO.            %@@%Insert a Windows Disc/ISO to import boot media%$$%&&ECHO.
IF "%SOURCE_TYPE%"=="WIM" IF "%WIM_SOURCE%"=="SELECT" SET "WIM_INDEX=1"&&SET "$IMGEDIT="
IF NOT DEFINED $IMGEDIT SET "$IMGEDIT=SELECT"&&SET "WIM_INDEX=1"
FOR %%G in (%SOURCE_TYPE% %TARGET_TYPE%) DO (IF "%%G"=="VHDX" SET "PROC_DISPLAY=1")
FOR %%G in (%SOURCE_TYPE% %TARGET_TYPE%) DO (IF "%%G"=="PATH" SET "PROC_DISPLAY=2")
IF "%PROC_DISPLAY%"=="1" ECHO.  %@@%AVAILABLE %@@%%SOURCE_TYPE%s%$$% (%##%X%$$%) %@@%%TARGET_TYPE%s%$$%:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM *.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST
IF "%PROC_DISPLAY%"=="2" ECHO.  %@@%AVAILABLE %@@%%SOURCE_TYPE%s%$$% (%##%X%$$%) %@@%%TARGET_TYPE%s%$$%:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO.   %%G:)
IF "%PROC_DISPLAY%"=="2" SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM"&&SET "$DISP=BAS"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="PATH" ECHO. [%@@%PATH%$$%] (%##%S%$$%)ource %@@%%PATH_SOURCE%%$$%&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="VHDX" ECHO. [%@@%VHDX%$$%] (%##%S%$$%)ource %@@%%VHDX_SOURCE%%$$%&&CALL:PAD_LINE
IF "%SOURCE_TYPE%"=="WIM" ECHO. [%@@%WIM%$$%] (%##%S%$$%)ource %@@%%WIM_SOURCE%%$$%   (%##%I%$$%)ndex %@@%%WIM_INDEX%%$$%   Edition: %@@%%$IMGEDIT%%$$%&&CALL:PAD_LINE
IF "%TARGET_TYPE%"=="VHDX" ECHO. [%@@%VHDX%$$%] (%##%T%$$%)arget %@@%%VHDX_TARGET%%$$%        (%##%C%$$%)onvert      (%##%V%$$%)disk Size %@@%%VHDX_SIZE%GB%$$%&&CALL:PAD_LINE
IF "%TARGET_TYPE%"=="WIM" ECHO. [%@@%WIM%$$%] (%##%T%$$%)arget %@@%%WIM_TARGET%%$$%         (%##%C%$$%)onvert&&CALL:PAD_LINE
IF "%TARGET_TYPE%"=="PATH" ECHO. [%@@%PATH%$$%] (%##%T%$$%)arget %@@%%PATH_TARGET%%$$%        (%##%C%$$%)onvert&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="C" CALL:IMAGEPROC_START&SET "SELECT="
IF "%SELECT%"=="X" CALL:IMAGEPROC_SLOT&SET "SELECT="
IF "%SELECT%"=="T" CALL:IMAGEPROC_TARGET&SET "SELECT="
IF "%SELECT%"=="S" CALL:IMAGEPROC_SOURCE&SET "SELECT="
IF "%SELECT%"=="V" IF "%TARGET_TYPE%"=="VHDX" CALL:IMAGEPROC_VSIZE&SET "SELECT="
IF "%SELECT%"=="I" IF "%SOURCE_TYPE%"=="WIM" IF NOT "%WIM_SOURCE%"=="SELECT" CALL:WIM_INDEX_MENU
IF "%SELECT%"=="+" IF DEFINED SOURCE_LOCATION CALL:SOURCE_IMPORT&SET "SELECT="
IF "%SELECT%"=="-" IF DEFINED SOURCE_LOCATION CALL:BOOT_IMPORT&SET "SELECT="
GOTO:IMAGE_PROCESSING
:IMAGEPROC_START
SET "SOURCE_X="&&SET "TARGET_X="&&IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.         %@@%IMAGE PROCESSING START:%$$%  %DATE%  %TIME%
CALL SET "SOURCE_X=%%%SOURCE_TYPE%_SOURCE%%%"
CALL SET "TARGET_X=%%%TARGET_TYPE%_TARGET%%%"
FOR %%a in (SOURCE_X TARGET_X) DO (IF NOT DEFINED %%a SET "%%a=SELECT")
IF "%SOURCE_X%"=="SELECT" ECHO.&&ECHO.                          %COLOR4%Source %SOURCE_TYPE% not set.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_X%"=="SELECT" ECHO.&&ECHO.                          %COLOR4%Target %TARGET_TYPE% not set.%$$%&&GOTO:IMAGEPROC_END
IF "%SOURCE_TYPE%"=="PATH" IF NOT EXIST "%PATH_SOURCE%\" ECHO.&&ECHO.                         %COLOR4%Source %SOURCE_TYPE% doesn't exist.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_TYPE%"=="PATH" IF NOT EXIST "%PATH_TARGET%\" ECHO.&&ECHO.                         %COLOR4%Target %TARGET_TYPE% doesn't exist.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_TYPE%"=="WIM" IF EXIST "%ImageFolder%\%WIM_TARGET%" ECHO.&&ECHO. %COLOR4%Target %WIM_TARGET% exists. Try another name or delete the existing file.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%ImageFolder%\%VHDX_TARGET%" SET "$HEADERS= %U01% %U01%                  File %@@%%VHDX_TARGET%%$$% already exists.%U01% %U01%  %COLOR2%Note:%$$% Updating can cause loss of data. Create a backup beforehand.%U01% %U01%                         Press (%##%X%$$%) to proceed%U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%ImageFolder%\%VHDX_TARGET%" IF NOT "%CONFIRM%"=="X" ECHO.&&ECHO. %##%Abort.%$$%&&GOTO:IMAGEPROC_END
IF NOT DEFINED WIM_INDEX SET "WIM_INDEX=1"
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25"
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="VHDX" CALL:WIM2VHDX
IF "%SOURCE_TYPE%"=="VHDX" IF "%TARGET_TYPE%"=="WIM" CALL:VHDX2WIM
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" SET "$PATH_X=%PATH_SOURCE%"&&CALL:GET_PATHINFO
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" IF NOT DEFINED $PATHEDIT SET "$PATHEDIT=Index_1"
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" ECHO.Capturing %PATH_SOURCE% to target image %WIM_TARGET%...&&%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%PATH_SOURCE%" /IMAGEFILE:"%ImageFolder%\%WIM_TARGET%" /COMPRESS:%COMPRESS% /NAME:"%$PATHEDIT%"
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="PATH" ECHO.Applying image %WIM_SOURCE% index %WIM_INDEX% to %PATH_TARGET%...&&%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%ImageFolder%\%WIM_SOURCE%" /INDEX:%WIM_INDEX% /APPLYDIR:"%PATH_TARGET%"
:IMAGEPROC_END
ECHO.&&ECHO.          %@@%IMAGE PROCESSING END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:WIM2VHDX
ECHO.&&IF EXIST "%ImageFolder%\%VHDX_TARGET%" SET "$VDISK_FILE=%ImageFolder%\%VHDX_TARGET%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT EXIST "%ImageFolder%\%VHDX_TARGET%" SET "$VDISK_FILE=%ImageFolder%\%VHDX_TARGET%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_CREATE
IF NOT EXIST "%VDISK_LTR%:\" ECHO.&&ECHO.          %COLOR4%Vdisk Error. If VHDX refuses mounting, try another.%$$%
IF EXIST "%VDISK_LTR%:\" ECHO.Applying image %WIM_SOURCE% index %WIM_INDEX% to %VDISK_LTR%:...
IF EXIST "%VDISK_LTR%:\" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%ImageFolder%\%WIM_SOURCE%" /INDEX:%WIM_INDEX% /APPLYDIR:"%VDISK_LTR%:"
ECHO.&&CALL:VDISK_DETACH
EXIT /B
:VHDX2WIM
ECHO.&&SET "$VDISK_FILE=%ImageFolder%\%VHDX_SOURCE%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT EXIST "%VDISK_LTR%:\" ECHO.&&ECHO.          %COLOR4%Vdisk Error. If VHDX refuses mounting, try another.%$$%
IF EXIST "%VDISK_LTR%:\" SET "$PATH_X=%VDISK_LTR%:"&&CALL:GET_PATHINFO
IF EXIST "%VDISK_LTR%:\" IF NOT DEFINED $PATHEDIT SET "$PATHEDIT=Index_1"
IF EXIST "%VDISK_LTR%:\" ECHO.Capturing %VDISK_LTR%: to target image %WIM_TARGET%...
IF EXIST "%VDISK_LTR%:\" %DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%VDISK_LTR%:" /IMAGEFILE:"%ImageFolder%\%WIM_TARGET%" /COMPRESS:%COMPRESS% /NAME:"%$PATHEDIT%"
ECHO.&&CALL:VDISK_DETACH
EXIT /B
:BASIC_BACKUP
SET "$HEADERS=                          %U07% Image Processing%U01% %U01%              Select a virtual hard disk image to backup"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=VHDX"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "VHDX_SOURCE=%$BODY%%$EXT%"
SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"&&CALL:IMAGEPROC_TARGET
IF NOT DEFINED WIM_TARGET EXIT /B
IF EXIST "%ImageFolder%\%WIM_TARGET%" ECHO.&&ECHO.%COLOR2%ERROR:%$$% File already exists.&&EXIT /B
SET "WIM_INDEX=1"&&CALL:IMAGEPROC_START
EXIT /B
:BASIC_RESTORE
SET "$HEADERS=                          %U07% Image Processing%U01% %U01%                      Select an image to restore"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=WIM"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "WIM_SOURCE=%$BODY%%$EXT%"
CALL:WIM_INDEX_MENU
IF DEFINED ERROR EXIT /B
SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"&&CALL:IMAGEPROC_TARGET
IF NOT DEFINED VHDX_TARGET EXIT /B
IF EXIST "%ImageFolder%\%VHDX_TARGET%" ECHO.&&ECHO.%COLOR2%ERROR:%$$% File already exists.&&EXIT /B
CALL:IMAGEPROC_VSIZE
IF DEFINED ERROR EXIT /B
CALL:IMAGEPROC_START
EXIT /B
:BOOT_IMPORT
IF EXIST "%CacheFolder%\boot.sav" SET "$HEADERS= %U01% %U01% %U01% %U01%         File boot.sav already exists. Press (%##%X%$$%) to overwrite%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF EXIST "%CacheFolder%\boot.sav" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%SOURCE_LOCATION%\boot.wim" ECHO.Importing %@@%boot.wim%$$% to boot.sav...&&COPY /Y "%SOURCE_LOCATION%\boot.wim" "%CacheFolder%\boot.sav"
EXIT /B
:SOURCE_IMPORT
SET "WIM_EXT="&&FOR %%G in (wim esd) DO (IF EXIST "%SOURCE_LOCATION%\install.%%G" SET "WIM_EXT=%%G")
IF EXIST "%CacheFolder%\boot.sav" SET "$HEADERS= %U01% %U01% %U01% %U01%                        Enter name of new .WIM%U01% %U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT DEFINED NEW_NAME EXIT /B
IF EXIST "%ImageFolder%\%NEW_NAME%.wim" SET "$HEADERS= %U01% %U01% %U01% %U01%         File %NEW_NAME%.wim already exists. Press (%##%X%$$%) to overwrite.%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF EXIST "%ImageFolder%\%NEW_NAME%.wim" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED NEW_NAME ECHO.Copying install.%WIM_EXT% to %@@%%NEW_NAME%.wim%$$%...&&COPY /Y "%SOURCE_LOCATION%\install.%WIM_EXT%" "%ImageFolder%\%NEW_NAME%.wim"&&SET "NEW_NAME="
EXIT /B
:IMAGEPROC_VSIZE
SET "$HEADERS=                          %U07% Image Processing%U01% %U01% %U01% %U01%                       Enter new VHDX size in GB%U01% %U01% %U01% %U01%                 Note: 25GB or greater is recommended"&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER❗1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR SET "ERROR=IMAGEPROC_VSIZE"&&EXIT /B
SET "VHDX_SIZE=%SELECTX%"
EXIT /B
:IMAGEPROC_TARGET
IF "%TARGET_TYPE%"=="PATH" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U07% Image Processing&&ECHO.&&ECHO.                         Enter the PATH target&&ECHO.&&ECHO.  %@@%AVAILABLE PATHs:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO. ^( %##%%%G%$$% ^) Volume %%G:)
IF "%TARGET_TYPE%"=="PATH" ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MOST"&&SET "$SELECT=PATH_LETTER"&&CALL:MENU_SELECT
IF "%TARGET_TYPE%"=="PATH" IF DEFINED PATH_LETTER FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%PATH_LETTER%"=="%%G" IF EXIST "%%G:\" SET "PATH_TARGET=%PATH_LETTER%:"&&EXIT /B)
IF "%TARGET_TYPE%"=="PATH" IF DEFINED PATH_LETTER SET "INPUT=%PATH_LETTER%"&&SET "OUTPUT=PATH_TARGET"&&CALL:SLASHER
IF "%TARGET_TYPE%"=="PATH" IF NOT DEFINED PATH_LETTER SET "PATH_TARGET="
IF NOT "%TARGET_TYPE%"=="PATH" SET "$HEADERS=                          %U07% Image Processing%U01% %U01% %U01% %U01% %U01%                        Enter name of new .%TARGET_TYPE%%U01% %U01% %U01% "&&SET "$NO_ERRORS=1"&&SET "$SELECT=SELECTX"&&SET "$CHECK=PATH"&&CALL:PROMPT_BOX
IF "%TARGET_TYPE%"=="WIM" IF DEFINED SELECTX SET "WIM_TARGET=%SELECTX%.wim"
IF "%TARGET_TYPE%"=="VHDX" IF DEFINED SELECTX SET "VHDX_TARGET=%SELECTX%.vhdx"
EXIT /B
:IMAGEPROC_SOURCE
IF "%SOURCE_TYPE%"=="PATH" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U07% Image Processing&&ECHO.&&ECHO.                         Enter the PATH source&&ECHO.&&ECHO.  %@@%AVAILABLE PATHs:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO. ^( %##%%%G%$$% ^) Volume %%G:)
IF "%SOURCE_TYPE%"=="PATH" ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MOST"&&SET "$SELECT=PATH_LETTER"&&CALL:MENU_SELECT
IF "%SOURCE_TYPE%"=="PATH" FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%PATH_LETTER%"=="%%G" IF EXIST "%%G:\" SET "PATH_SOURCE=%PATH_LETTER%:"&&EXIT /B)
IF "%SOURCE_TYPE%"=="PATH" IF DEFINED PATH_LETTER SET "INPUT=%PATH_LETTER%"&&SET "OUTPUT=PATH_SOURCE"&&CALL:SLASHER
IF "%SOURCE_TYPE%"=="PATH" IF NOT DEFINED PATH_LETTER SET "PATH_SOURCE="
IF NOT "%SOURCE_TYPE%"=="PATH" SET "$HEADERS=                          %U07% Image Processing%U01% %U01%                          Select a %SOURCE_TYPE% source"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %U13% File Operation"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.%SOURCE_TYPE%"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT "%SOURCE_TYPE%"=="PATH" IF "%SELECT%"=="0" SET "FILE_TYPE=%SOURCE_TYPE%"&&CALL:BASIC_FILE&EXIT /B
IF NOT "%SOURCE_TYPE%"=="PATH" CALL SET "%SOURCE_TYPE%_SOURCE=%$CHOICE%"
EXIT /B
:WIM_INDEX_MENU
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U07% Image Processing&&ECHO.&&ECHO.                            Select an index&&ECHO.&&ECHO.  %@@%AVAILABLE INDEXs:%$$%&&ECHO.
SET "INDEX_DSP="&&SET "NAME_DSP="&&FOR /F "TOKENS=1-7 SKIP=5 DELIMS=:<> " %%a in ('%DISM% /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"%ImageFolder%\%WIM_SOURCE%" 2^>NUL') DO (
IF "%%a"=="Index" SET "INDEX_DSP=%%b"
IF "%%a"=="Name" SET "NAME_DSP=%%b %%c %%d %%e %%f %%g"&&CALL:WIM_INDEX_LIST)
IF NOT DEFINED INDEX_DSP ECHO.%COLOR2%ERROR%$$%&&SET "ERROR=WIM_INDEX_MENU"&&CALL:DEBUG&&EXIT /B
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT SET "ERROR=WIM_INDEX_MENU"&&CALL:DEBUG&&EXIT /B
SET "$IMAGE_X=%ImageFolder%\%WIM_SOURCE%"&&SET "INDEX_X=%SELECT%"&&CALL:GET_IMAGEINFO
SET "WIM_INDEX=%SELECT%"&&IF DEFINED ERROR SET "WIM_INDEX=1"&&ECHO.%COLOR2%ERROR%$$%
EXIT /B
:WIM_INDEX_LIST
ECHO. ( %##%%INDEX_DSP%%$$% ) %NAME_DSP%
EXIT /B
:IMAGEPROC_SLOT
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="PATH" SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"&&EXIT /B
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="VHDX" SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"&&EXIT /B
IF "%SOURCE_TYPE%"=="VHDX" IF "%TARGET_TYPE%"=="WIM" SET "SOURCE_TYPE=PATH"&&SET "TARGET_TYPE=WIM"&&EXIT /B
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=PATH"&&EXIT /B
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:IMAGE_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "IMAGE_LAST=IMAGE"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U13% Image Management&&ECHO.
ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&SET "$DISP=BAS"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U13%LIST%$$%(%##%X%$$%)PACK%U05%%$$%  (%##%R%$$%)un List  (%##%E%$$%)dit List  (%##%B%$$%)uild List  (%##%.%$$%) Reference&&CALL:PAD_LINE
IF DEFINED ADV_IMGM ECHO. [%@@%OPTIONS%$$%] (%##%S%$$%)afe Exclude %@@%%SAFE_EXCLUDE%%$$%&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="." CALL:REFERENCE
IF "%SELECT%"=="X" GOTO:PACKAGE_MANAGEMENT
IF "%SELECT%"=="R" SET "IMAGEMGR_TYPE=LIST"&&CALL:IMAGEMGR_EXECUTE&SET "SELECT="
IF "%SELECT%"=="B" CALL:IMAGEMGR_BUILDER&SET "SELECT="
IF "%SELECT%"=="O" IF DEFINED ADV_IMGM SET "ADV_IMGM="&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_IMGM SET "ADV_IMGM=1"&SET "SELECT="
IF "%SELECT%"=="E" CALL:LIST_EDIT&&SET "SELECT="
IF "%SELECT%"=="S" IF "%SAFE_EXCLUDE%"=="DISABLED" SET "SAFE_EXCLUDE=ENABLED"&SET "SELECT="
IF "%SELECT%"=="S" IF "%SAFE_EXCLUDE%"=="ENABLED" SET "SAFE_EXCLUDE=DISABLED"&SET "SELECT="
GOTO:IMAGE_MANAGEMENT
:REFERENCE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U13% Reference&&ECHO.&&ECHO.            Select a reference image to load with the menu&&ECHO.&&ECHO.  %@@%AVAILABLE *.VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) %U06% Current Environment&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF "%SELECT%"=="0" SET "REFERENCE=LIVE"
IF NOT DEFINED $PICK EXIT /B
SET "REFERENCE=%$CHOICE%"
EXIT /B
:LIST_EDIT
SET "$HEADERS=                             %U13% Edit List%U01% %U01%                             Select a list"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=LISTS"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
START NOTEPAD "%$PICK%"
EXIT /B
:IMAGEMGR_EXECUTE
IF "%IMAGEMGR_TYPE%"=="LIST" SET "$HEADERS=                            %U13% List Execute%U01% %U01%                            Select an option"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF DEFINED ERROR EXIT /B
IF "%IMAGEMGR_TYPE%"=="PACK" SET "$HEADERS=                            %U05% Pack Execute%U01% %U01%                            Select an option"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" IF "%IMAGEMGR_TYPE%"=="PACK" SET "FILE_TYPE=PKX"&&CALL:BASIC_FILE&EXIT /B
IF "%SELECT%"=="0" IF "%IMAGEMGR_TYPE%"=="LIST" SET "FILE_TYPE=LISTS"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "$LISTPACK=%$CHOICE%"&&FOR %%G in ("%$PICK%") DO (SET "CAPS_SET=IMAGEMGR_EXT"&&SET "CAPS_VAR=%%~xG"&&CALL:CAPS_SET)
IF "%IMAGEMGR_EXT%"==".BASE" SET "$LIST_FILE=%$PICK%"&SET "BASE_EXEC=1"&&CALL:LIST_VIEWER&SET "IMAGEMGR_EXT=.LIST"&SET "$HEAD=MENU-SCRIPT"&SET "$LISTPACK=$LIST"&IF "%FOLDER_MODE%"=="ISOLATED" MOVE /Y "$LIST" "%ListFolder%">NUL
IF DEFINED ERROR EXIT /B
IF DEFINED MENU_SESSION CLS&&CALL %CMD% /C ""%ProgFolder%\windick.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -MENU"&CALL:PAUSED&EXIT /B
IF "%IMAGEMGR_EXT%"==".PKX" SET "$IMGMGRX=                           %U05% Pack Execute"
IF "%IMAGEMGR_EXT%"==".LIST" SET "$IMGMGRX=                           %U13% List Execute"
SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"&&SET "$HEADERS=%$IMGMGRX%%U01% %U01%                            Select a target"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF DEFINED ERROR EXIT /B
IF "%SELECT%"=="0" SET "LIVE_APPLY=1"
IF NOT DEFINED LIVE_APPLY CLS&&CALL %CMD% /C ""%ProgFolder%\windick.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -vhdx "%$CHOICE%""&&CALL:PAUSED&EXIT /B
IF DEFINED LIVE_APPLY CLS&&CALL %CMD% /C ""%ProgFolder%\windick.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -live"&CALL:PAUSED&EXIT /B
EXIT /B
:LIST_EXEC
IF NOT DEFINED $LIST_FILE EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" IF NOT "%PROG_MODE%"=="GUI" IF NOT EXIST "%ProgFolder%\$PKX" CLS
SET "MOUNT="&&CALL:MOUNT_INT&&FOR %%G in ("%$LIST_FILE%") DO SET "LIST_NAME=%%~nG%%~xG"
IF NOT DEFINED LIST_ITEMS_EXECUTE CALL:LIST_ITEMS
IF NOT DEFINED SAFE_EXCLUDE SET "SAFE_EXCLUDE=ENABLED"
SET "$BOX=ST"&&CALL:BOX_DISP
IF NOT DEFINED CUSTOM_SESSION ECHO.             %@@%%CURR_SESSION%-LIST START:%$$%  %DATE%  %TIME%&&ECHO.
SET "$HEAD_CHECK=%$LIST_FILE%"&&CALL:GET_HEADER
IF DEFINED ERROR GOTO:LIST_EXEC_END
IF DEFINED MENU_SESSION GOTO:LIST_EXEC_JUMP
IF DEFINED VDISK_APPLY SET "VDISK_LTR=ANY"&CALL:VDISK_ATTACH
IF DEFINED VDISK_APPLY SET "TARGET_PATH=%VDISK_LTR%:"
IF DEFINED LIVE_APPLY SET "TARGET_PATH=%SYSTEMDRIVE%"
IF DEFINED PATH_APPLY SET "TARGET_PATH=%TARGET_PATH%"
IF DEFINED LIVE_APPLY IF NOT DEFINED CUSTOM_SESSION IF NOT DEFINED MENU_SESSION ECHO.Using live system as target.
IF NOT EXIST "%TARGET_PATH%\" ECHO.&&ECHO.           %COLOR4%Path error or Windows is not installed on Vdisk.%$$%&&ECHO.&&GOTO:LIST_EXEC_END
:LIST_EXEC_JUMP
FOR %%□ in ($HALT GROUP SUBGROUP) DO (IF DEFINED %%□ SET "%%□=")
CALL:SESSION_CLEAR&&CALL:RAS_DELETE
COPY /Y "%$LIST_FILE%" "$TEMP">NUL 2>&1
IF EXIST "$TEMP" FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ($TEMP) DO (
SET "COLUMN0="&&IF DEFINED $HALT ECHO.%COLOR2%ERROR:%$$% HALT.&&GOTO:LIST_EXEC_END
IF NOT "%%a"=="" SET "COLUMN0=%U00%%%a%U00%"
IF NOT "%%b"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%"
IF NOT "%%c"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%"
IF NOT "%%d"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%"
IF NOT "%%e"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"
IF NOT "%%f"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%"
IF NOT "%%g"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%"
IF NOT "%%h"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%"
IF NOT "%%i"=="" SET "COLUMN0=%U00%%%a%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%%%f%U00%%%g%U00%%%h%U00%%%i%U00%"
IF DEFINED COLUMN0 CALL:UNIFIED_PARSE_EXECUTE)
:LIST_EXEC_END
CALL:MOUNT_INT&IF DEFINED VDISK_APPLY CALL:VDISK_DETACH
CALL:SESSION_CLEAR&&CALL:RAS_DELETE
IF NOT DEFINED CUSTOM_SESSION ECHO.&&ECHO.             %@@%%CURR_SESSION%-LIST END:%$$%  %DATE%  %TIME%
SET "$BOX=SB"&&CALL:BOX_DISP&&SET "MOUNT="&&CALL:MOUNT_INT
IF NOT EXIST "%ProgFolder%\$PKX" CALL:CLEAN
FOR %%a in (LIST_ITEMS_EXECUTE LIST_ITEMS_BUILDER DRVR_QRY FEAT_QRY SC_PREPARE RO_PREPARE) DO (SET "%%a=")
EXIT /B
:UNIFIED_PARSE_EXECUTE
CALL:EXPAND_COLUMN
FOR %%● in (QCLM1 QCLM2 QCLM3) DO (IF NOT DEFINED %%● EXIT /B)
SET "$RAS="&&SET "$ITEM_TYPE="&&IF NOT DEFINED LIST_ITEMS_EXECUTE CALL:LIST_ITEMS
FOR %%● in (%LIST_ITEMS_EXECUTE%) DO (IF /I "%%●"=="!$QCLM1$!" SET "$ITEM_TYPE=EXECUTE")
FOR %%● in (%LIST_ITEMS_BUILDER%) DO (IF /I "%%●"=="!$QCLM1$!" SET "$ITEM_TYPE=BUILDER")
IF NOT DEFINED $ITEM_TYPE EXIT /B
IF /I "!$QCLM1$!"=="GROUP" CALL:SESSION_CLEAR
IF NOT DEFINED $QCLM4$ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! one of the four columns is not specified.&&EXIT /B
IF "!$ITEM_TYPE!"=="BUILDER" CALL:SCRO_QUEUE&&FOR %%○ in (1 2 3 4 5 6 7 8 9 I S) DO (SET "!$QCLM1$!.%%○=")
IF "!$ITEM_TYPE!"=="BUILDER" FOR /F "TOKENS=1 DELIMS=123456789" %%● IN ("!$QCLM1$!") DO (CALL:%%●_ITEM)
IF "!$ITEM_TYPE!"=="EXECUTE" FOR /F "TOKENS=*" %%● in ("!$QCLM4$!") DO (IF /I "%%●"=="DX" CALL:!$QCLM1$!_ITEM
FOR %%○ in (SC RO) DO (IF /I "%%●"=="%%○" CALL:SCRO_CREATE))
CD /D "%ProgFolder0%">NUL 2>&1
EXIT /B
:TEXTHOST_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!"&&SET "$OUTPUT=ZCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (FILE SCREEN) DO (IF /I "!$ZCLM1$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not valid. Example: 'SCREEN' or 'FILE❗C:\TEXT.TXT'&&EXIT /B
IF /I "!$ZCLM1$!"=="FILE" IF EXIST "!$ZCLM2$!\*" ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not valid. Textfile target is a folder.&&EXIT /B
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% to !$ZCLM1$!
IF /I "!$ZCLM1$!"=="FILE" FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (ECHO.%%●>>"!$ZCLM2$!")
IF /I "!$ZCLM1$!"=="SCREEN" FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (ECHO.%%●)
EXIT /B
:SESSION_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
CALL %CMD% /C ""%ProgFolder%\windick.cmd" !$QCLM2$!"
EXIT /B
:GROUP_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 in ("!$QCLM2$!%U01%!$QCLM3$!") DO (SET "GROUP=%%1"&&SET "SUBGROUP=%%2")
IF DEFINED $QCLM7$ FOR /F "TOKENS=*" %%● IN ("!$QCLM7$!") DO (SET "CHOICE0.I=%%●"
FOR %%○ in (1 2 3 4 5 6 7 8 9) DO (IF "%%●"=="%%○" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM6$!") DO (SET "CHOICE0.S=%%%$QCLM7$%"&&SET "CHOICE0.%%●=%%%$QCLM7$%")))
FOR %%● in (S I) DO (IF NOT DEFINED CHOICE0.%%● SET "CHOICE0.I="&&SET "CHOICE0.S=")
EXIT /B
:PICKER_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=*" %%○ in ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=%%○"&&SET "!$QCLM1$!.S=%%○")
EXIT /B
:PROMPT_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=*" %%○ in ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=%%○"&&SET "!$QCLM1$!.S=%%○")
EXIT /B
:CHOICE_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=*" %%○ IN ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=%%○"
FOR %%◌ in (1 2 3 4 5 6 7 8 9) DO (IF "%%○"=="%%◌" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM3$!") DO (SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.%%◌=%%%$QCLM4$%")))
FOR %%○ in (S I) DO (IF NOT DEFINED !$QCLM1$!.%%○ SET "!$QCLM1$!.I="&&SET "!$QCLM1$!.S=")
EXIT /B
:STRING_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM2$!") DO (
IF /I "!$QCLM3$!"=="STRING" IF NOT "%%1"=="" SET "!$QCLM1$!.1=%%1"&&IF NOT "%%2"=="" SET "!$QCLM1$!.2=%%2"&&IF NOT "%%3"=="" SET "!$QCLM1$!.3=%%3"&&IF NOT "%%4"=="" SET "!$QCLM1$!.4=%%4"&&IF NOT "%%5"=="" SET "!$QCLM1$!.5=%%5"&&IF NOT "%%6"=="" SET "!$QCLM1$!.6=%%6"&&IF NOT "%%7"=="" SET "!$QCLM1$!.7=%%7"&&IF NOT "%%8"=="" SET "!$QCLM1$!.8=%%8"&&IF NOT "%%9"=="" SET "!$QCLM1$!.9=%%9"
IF /I "!$QCLM3$!"=="INTEGER" IF NOT "%%1"=="" SET /A "!$QCLM1$!.1=%%1"&&IF NOT "%%2"=="" SET /A "!$QCLM1$!.2=%%2"&&IF NOT "%%3"=="" SET /A "!$QCLM1$!.3=%%3"&&IF NOT "%%4"=="" SET /A "!$QCLM1$!.4=%%4"&&IF NOT "%%5"=="" SET /A "!$QCLM1$!.5=%%5"&&IF NOT "%%6"=="" SET /A "!$QCLM1$!.6=%%6"&&IF NOT "%%7"=="" SET /A "!$QCLM1$!.7=%%7"&&IF NOT "%%8"=="" SET /A "!$QCLM1$!.8=%%8"&&IF NOT "%%9"=="" SET /A "!$QCLM1$!.9=%%9")
FOR /F "TOKENS=*" %%○ IN ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=%%○"
FOR %%◌ in (1 2 3 4 5 6 7 8 9) DO (IF "%%○"=="%%◌" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM2$!") DO (
IF /I "!$QCLM3$!"=="STRING" SET "!$QCLM1$!.S=%%%$QCLM4$%"
IF /I "!$QCLM3$!"=="INTEGER" SET /A "!$QCLM1$!.S=%%%$QCLM4$%"
)))
FOR %%○ in (S I) DO (IF NOT DEFINED !$QCLM1$!.%%○ SET "!$QCLM1$!.I="&&SET "!$QCLM1$!.S=")
EXIT /B
:EXPAND_COLUMN
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&SET "$NO_QUOTE=1"&&CALL:EXPANDOFLEX
SET "@QUIET="&&FOR /F "TOKENS=* DELIMS=ⓠ" %%● IN ("!$QCLM1$!") DO (IF NOT "%%●"=="!$QCLM1$!" SET "@QUIET=1"&&SET "$QCLM1$=!$QCLM1$:ⓠ=!")
IF DEFINED $QCLM4$ FOR /F "TOKENS=*" %%● in ("!$QCLM4$!") DO (
IF /I "%%●"=="%U0L%HALT%U0R%" SET "$HALT=1"&&FOR %%○ in (1 2 3 4 5 6 7 8 9) DO (SET "$QCLM%%○="&&SET "$QCLM%%○$="))
EXIT /B
:EXPANDOFLEX
IF DEFINED $NO_QUOTE SET "$INPUT=!$INPUT:"=!"
SET "$NO_QUOTE="&&SET "!$OUTPUT!0=!$INPUT!"&&FOR /F "TOKENS=1-9 DELIMS=%DELIMS%" %%a in ("!$INPUT!") DO (SET "PART1=%%a"&&SET "PART2=%%b"&&SET "PART3=%%c"&&SET "PART4=%%d"&&SET "PART5=%%e"&&SET "PART6=%%f"&&SET "PART7=%%g"&&SET "PART8=%%h"&&SET "PART9=%%i")
FOR %%● in (1 2 3 4 5 6 7 8 9) DO (SET "$PART%%●="&&SET "!$OUTPUT!%%●="&&SET "$!$OUTPUT!%%●="&&SET "$!$OUTPUT!%%●$="&&IF DEFINED PART%%● SET "!$OUTPUT!%%●=!PART%%●!"&&SET "$PART%%●=!PART%%●:◁=%%!"&&SET "$PART%%●=!$PART%%●:▷=%%!"&&SET "$!$OUTPUT!%%●=!$PART%%●!"&&CALL SET "$!$OUTPUT!%%●$=!$PART%%●!"
IF DEFINED PART%%● IF NOT DEFINED $!$OUTPUT!%%●$ SET "$!$OUTPUT!%%●$=!PART%%●!")
EXIT /B
:RASTI_CREATE
IF NOT "%WINPE_BOOT%"=="1" SET "SRV_X="&&FOR /F "TOKENS=1-2* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SET "SRV_X=1"&&IF NOT "%%c"=="%CMD% /C START %ProgFolder0%\$RAS.cmd" %REG% add "HKLM\SYSTEM\ControlSet001\Services\$RAS" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %ProgFolder0%\$RAS.cmd" /f)
IF NOT "%WINPE_BOOT%"=="1" IF NOT DEFINED SRV_X SC CREATE $RAS BINPATH="%CMD% /C START "%ProgFolder0%\$RAS.cmd"" START=DEMAND>NUL 2>&1
IF /I "%$RAS%"=="RATI" ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %ProgFolder0%\$RATI.cmd" /f^>NUL 2^>^&^1>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.NET START TrustedInstaller^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%%%%SystemRoot%%%%\servicing\TrustedInstaller.exe" /f^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
IF /I "%$RAS%"=="RATI" ECHO.DEL /Q /F "%ProgFolder0%\$RAS.cmd"^>NUL^&EXIT>>"%ProgFolder0%\$RAS.cmd"
ECHO.@ECHO OFF^&CD /D "%ProgFolder0%">"%ProgFolder0%\$%$RAS%.cmd"
IF NOT DEFINED VAR_ITEMS CALL:VAR_ITEMS
FOR %%■ in (DrvTar WinTar UsrTar HiveSoftware HiveSystem HiveUser ProgFolder ImageFolder ListFolder PackFolder CacheFolder PkxFolder ApplyTarget UsrNam UsrSid %VAR_ITEMS%) DO (IF DEFINED %%■ ECHO.SET "%%■=!%%■!">>"%ProgFolder0%\$%$RAS%.cmd")
ECHO.CALL:ROUTINE^>"%ProgFolder0%\$LOG">>"%ProgFolder0%\$%$RAS%.cmd"
ECHO.DEL /Q /F "%ProgFolder0%\$%$RAS%.cmd"^>NUL^&EXIT>>"%ProgFolder0%\$%$RAS%.cmd"
ECHO.:ROUTINE>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%"=="COMMAND" IF EXIST "$LIST" ECHO.FOR /F "TOKENS=*" %%%%@ in ($LIST) DO (%CMD% /C %%%%@)>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%:%$QCLM3$%"=="SERVICE:DELETE" ECHO.%REG% DELETE "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%:%$QCLM3$%"=="SERVICE:AUTO" ECHO.%REG% ADD "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "2" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%:%$QCLM3$%"=="SERVICE:MANUAL" ECHO.%REG% ADD "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "3" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%:%$QCLM3$%"=="SERVICE:DISABLE" ECHO.%REG% ADD "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "4" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%"=="TASK" ECHO.%REG% DELETE "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%"=="TASK" ECHO.%REG% DELETE "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{%TASKID%}" /F^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
IF /I "%$QCLM1$%"=="TASK" ECHO.DEL /Q /F "%WinTar%\System32\Tasks\%$QCLM2$%"^>NUL 2^>^&^1>>"%ProgFolder0%\$%$RAS%.cmd"
SET "XNT="&&ECHO.EXIT /B>>"%ProgFolder0%\$%$RAS%.cmd"
IF NOT "%WINPE_BOOT%"=="1" NET START $RAS>NUL 2>&1
IF "%WINPE_BOOT%"=="1" IF "%$RAS%"=="RAS" CALL %CMD% /C "%ProgFolder0%\$RAS.cmd"
IF "%WINPE_BOOT%"=="1" IF "%$RAS%"=="RATI" CALL %CMD% /C "%ProgFolder0%\$RAS.cmd">NUL 2>&1
:RASTI_WAIT
SET /A "XNT+=1"&&FOR %%■ in (SERVICE TASK) DO (IF /I "%$QCLM1$%"=="%%■" FOR %%□ in (RAS RATI) DO (
IF EXIST "%ProgFolder0%\$%%□.cmd" CALL:TIMER_POINT3
IF EXIST "%ProgFolder0%\$%%□.cmd" IF "%XNT%"=="10" IF NOT DEFINED RETRY SET "RETRY=1"&&GOTO:RASTI_CREATE
IF EXIST "%ProgFolder0%\$%%□.cmd" IF "%XNT%"=="10" IF DEFINED RETRY CALL:RASTI_CHECK&DEL /Q /F "%ProgFolder0%\$%%□.cmd">NUL 2>&1))
FOR %%□ in (RAS RATI) DO (IF EXIST "%ProgFolder0%\$%%□.cmd" GOTO:RASTI_WAIT)
IF EXIST "%ProgFolder0%\$LOG" IF /I NOT "%$QCLM1$%"=="SERVICE" IF /I NOT "%$QCLM1$%"=="TASK" FOR /F "TOKENS=* DELIMS=" %%□ in (%ProgFolder0%\$LOG) DO (ECHO.%%□)
IF EXIST "%ProgFolder0%\$LOG" DEL /Q /F "%ProgFolder0%\$LOG">NUL 2>&1
SET "RETRY="&&SET "XNT="&&EXIT /B
:RASTI_CHECK
SET "$GO="&&FOR /F "TOKENS=1-3* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" IF "%%c"=="%CMD%" SET "$GO=1")
IF NOT DEFINED $GO EXIT /B
IF NOT "%WINPE_BOOT%"=="1" SET "SRV_X="&&FOR /F "TOKENS=1-2* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SET "SRV_X=1"&&IF NOT "%%c"=="%CMD% /C START %ProgFolder0%\$RAS.cmd" %REG% add "HKLM\SYSTEM\ControlSet001\Services\$RAS" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %ProgFolder0%\$RAS.cmd" /f)
IF NOT "%WINPE_BOOT%"=="1" IF NOT DEFINED SRV_X SC CREATE $RAS BINPATH="%CMD% /C START "%ProgFolder0%\$RAS.cmd"" START=DEMAND>NUL 2>&1
ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>"%ProgFolder0%\$RAS.cmd"
ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%%%%SystemRoot%%%%\servicing\TrustedInstaller.exe" /f^>NUL 2^>^&^1>>"%ProgFolder0%\$RAS.cmd"
ECHO.DEL /Q /F "%ProgFolder0%\$RAS.cmd"^>NUL^&EXIT>>"%ProgFolder0%\$RAS.cmd"
IF NOT "%WINPE_BOOT%"=="1" NET START $RAS>NUL 2>&1
IF "%WINPE_BOOT%"=="1" CALL %CMD% /C "%ProgFolder0%\$RAS.cmd"
EXIT /B
:RAS_DELETE
IF "%WINPE_BOOT%"=="1" EXIT /B
FOR /F "TOKENS=1 DELIMS= " %%a IN ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\SERVICES\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SC DELETE $RAS>NUL 2>&1)
EXIT /B
:ARRAY_ITEM
SET "$IFELSE="
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM4!"&&SET "$OUTPUT=ACTN"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!"&&SET "$OUTPUT=MATCH"&&CALL:EXPANDOFLEX
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH1$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.S=!$ACTN1$!"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "$IFELSE=1"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH2$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.S=!$ACTN2$!"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "$IFELSE=2"
IF /I NOT "!ACTN3!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH3$!" SET "!$QCLM1$!.I=3"&&SET "!$QCLM1$!.S=!$ACTN3$!"&&SET "!$QCLM1$!.3=!$ACTN3$!"&&SET "$IFELSE=3"
IF /I NOT "!ACTN4!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH4$!" SET "!$QCLM1$!.I=4"&&SET "!$QCLM1$!.S=!$ACTN4$!"&&SET "!$QCLM1$!.4=!$ACTN4$!"&&SET "$IFELSE=4"
IF /I NOT "!ACTN5!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH5$!" SET "!$QCLM1$!.I=5"&&SET "!$QCLM1$!.S=!$ACTN5$!"&&SET "!$QCLM1$!.5=!$ACTN5$!"&&SET "$IFELSE=5"
IF /I NOT "!ACTN6!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH6$!" SET "!$QCLM1$!.I=6"&&SET "!$QCLM1$!.S=!$ACTN6$!"&&SET "!$QCLM1$!.6=!$ACTN6$!"&&SET "$IFELSE=6"
IF /I NOT "!ACTN7!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH7$!" SET "!$QCLM1$!.I=7"&&SET "!$QCLM1$!.S=!$ACTN7$!"&&SET "!$QCLM1$!.7=!$ACTN7$!"&&SET "$IFELSE=7"
IF /I NOT "!ACTN8!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH8$!" SET "!$QCLM1$!.I=8"&&SET "!$QCLM1$!.S=!$ACTN8$!"&&SET "!$QCLM1$!.8=!$ACTN8$!"&&SET "$IFELSE=8"
IF /I NOT "!ACTN9!"=="◁NULL▷" IF /I "!$QCLM2$!"=="!$MATCH9$!" SET "!$QCLM1$!.I=9"&&SET "!$QCLM1$!.S=!$ACTN9$!"&&SET "!$QCLM1$!.9=!$ACTN9$!"&&SET "$IFELSE=9"
IF NOT DEFINED $QCLM5$ EXIT /B
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM5!"&&SET "$OUTPUT=ELSE"&&CALL:EXPANDOFLEX
IF /I NOT "!ELSE1!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH1$!" SET "!$QCLM1$!.1=!$ELSE1$!"&&IF "!$IFELSE!"=="1" SET "!$QCLM1$!.S=!$ELSE1$!"
IF /I NOT "!ELSE2!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH2$!" SET "!$QCLM1$!.2=!$ELSE2$!"&&IF "!$IFELSE!"=="2" SET "!$QCLM1$!.S=!$ELSE2$!"
IF /I NOT "!ELSE3!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH3$!" SET "!$QCLM1$!.3=!$ELSE3$!"&&IF "!$IFELSE!"=="3" SET "!$QCLM1$!.S=!$ELSE3$!"
IF /I NOT "!ELSE4!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH4$!" SET "!$QCLM1$!.4=!$ELSE4$!"&&IF "!$IFELSE!"=="4" SET "!$QCLM1$!.S=!$ELSE4$!"
IF /I NOT "!ELSE5!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH5$!" SET "!$QCLM1$!.5=!$ELSE5$!"&&IF "!$IFELSE!"=="5" SET "!$QCLM1$!.S=!$ELSE5$!"
IF /I NOT "!ELSE6!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH6$!" SET "!$QCLM1$!.6=!$ELSE6$!"&&IF "!$IFELSE!"=="6" SET "!$QCLM1$!.S=!$ELSE6$!"
IF /I NOT "!ELSE7!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH7$!" SET "!$QCLM1$!.7=!$ELSE7$!"&&IF "!$IFELSE!"=="7" SET "!$QCLM1$!.S=!$ELSE7$!"
IF /I NOT "!ELSE8!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH8$!" SET "!$QCLM1$!.8=!$ELSE8$!"&&IF "!$IFELSE!"=="8" SET "!$QCLM1$!.S=!$ELSE8$!"
IF /I NOT "!ELSE9!"=="◁NULL▷" IF /I NOT "!$QCLM2$!"=="!$MATCH9$!" SET "!$QCLM1$!.9=!$ELSE9$!"&&IF "!$IFELSE!"=="9" SET "!$QCLM1$!.S=!$ELSE9$!"
EXIT /B
:ROUTINE_ITEM
SET "$PASS="&&FOR %%□ IN (SPLIT COMMAND) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not SPLIT or COMMAND.&&EXIT /B
CALL:IF_LIVE_EXT
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=ROUT"&&CALL:EXPANDOFLEX
IF /I "!$QCLM4$!"=="COMMAND" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: '^<^>❗DIR C:\ /B❗1❗TEST.TXT' or '^<^>❗DIR C:\ /B'&&EXIT /B)
IF /I "!$QCLM4$!"=="SPLIT" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: ':❗A:B:C❗3❗C' or ':❗A:B:C'&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
IF /I "!$QCLM3$!"=="COMMAND" FOR /F "TOKENS=1-9 DELIMS=%$ROUT1$%" %%1 in ('!$ROUT2$!') DO (
IF NOT DEFINED $ROUT3$ SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.1=%%%$QCLM4$%"&&SET /A "!$QCLM1$!.I=1"
IF DEFINED $ROUT3$ IF /I "!$ROUT4$!"=="%%%$ROUT3$%" SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.1=%%%$QCLM4$%"&&SET "!$QCLM1$!.I=1")
IF /I "!$QCLM3$!"=="SPLIT" FOR /F "TOKENS=1-9 DELIMS=%$ROUT1$%" %%1 in ("!$ROUT2$!") DO (
IF NOT "%%1"=="" SET "!$QCLM1$!.1=%%1"&&IF NOT "%%2"=="" SET "!$QCLM1$!.2=%%2"&&IF NOT "%%3"=="" SET "!$QCLM1$!.3=%%3"&&IF NOT "%%4"=="" SET "!$QCLM1$!.4=%%4"&&IF NOT "%%5"=="" SET "!$QCLM1$!.5=%%5"&&IF NOT "%%6"=="" SET "!$QCLM1$!.6=%%6"&&IF NOT "%%7"=="" SET "!$QCLM1$!.7=%%7"&&IF NOT "%%8"=="" SET "!$QCLM1$!.8=%%8"&&IF NOT "%%9"=="" SET "!$QCLM1$!.9=%%9"
IF NOT DEFINED $ROUT3$ SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET /A "!$QCLM1$!.I=!$QCLM4$!"
IF DEFINED $ROUT3$ IF /I "!$ROUT4$!"=="%%%$ROUT3$%" SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.I=!$QCLM4$!")
EXIT /B
:MATH_ITEM
SET "$PASS="&&FOR %%□ IN (+ - /) DO (IF "!$QCLM3$!"=="*" SET "$PASS=1"
IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 OPERATION is not *, /, +, or -.&&EXIT /B
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET /A "!$QCLM1$!.I=1"&&SET /A "!$QCLM1$!.S=!$QCLM2$!"&&SET /A "!$QCLM1$!.S!$QCLM3$!=!$QCLM4$!"&&SET /A "!$QCLM1$!.1=!$QCLM1$!.S!"
EXIT /B
:CONDIT_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=COND"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (EXIST NEXIST DEFINED NDEFINED EQ NE LE GE GT LT) DO (IF /I "!$COND2$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 CONDITION is not EQ, NE, LE, GE, GT, LT, EXIST, NEXIST, DEFINED or NDEFINED. Example: 'c:\❗EXIST' or '1❗EQ❗1' or 'CHOICE1❗DEFINED'&&EXIT /B
FOR %%□ IN (EQ NE LE GE GT LT) DO (IF /I "!$COND2$!"=="%%□" IF NOT DEFINED $COND3$ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 3 COMPARE is not specified. Example: '1❗EQ❗1'&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% item 
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!%U01%!QCLM4!"&&SET "$OUTPUT=ACTN"&&CALL:EXPANDOFLEX
IF DEFINED $ACTN2$ FOR %%□ IN (EQ NE LE GE GT LT) DO (IF /I "!$COND2$"=="%%□" SET /A "$COND1$=!$COND1$!"&&SET /A "$COND3$=!$COND3$!")
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="DEFINED" IF DEFINED !$COND1$! SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="DEFINED" IF NOT DEFINED !$COND1$! SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="NDEFINED" IF NOT DEFINED !$COND1$! SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="NDEFINED" IF DEFINED !$COND1$! SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="EXIST" IF EXIST "!$COND1$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="EXIST" IF NOT EXIST "!$COND1$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="NEXIST" IF NOT EXIST "!$COND1$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="NEXIST" IF EXIST "!$COND1$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="EQ" IF /I "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="EQ" IF /I NOT "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="NE" IF /I NOT "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="NE" IF /I "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="LE" IF "!$COND1$!" LEQ "!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="LE" IF NOT "!$COND1$!" LEQ "!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="GE" IF "!$COND1$!" GEQ "!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="GE" IF NOT "!$COND1$!" GEQ "!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="GT" IF "!$COND1$!" GTR "!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="GT" IF NOT "!$COND1$!" GTR "!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I "!$COND2$!"=="LT" IF "!$COND1$!" LSS "!$COND3$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&SET "!$QCLM1$!.S=!$ACTN1$!"
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I "!$COND2$!"=="LT" IF NOT "!$COND1$!" LSS "!$COND3$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&SET "!$QCLM1$!.S=!$ACTN2$!"
EXIT /B
:FILEOPER_ITEM
SET "$FILE_OBJ="&&SET "$PASS="&&FOR %%□ IN (CREATE DELETE RENAME COPY MOVE TAKEOWN) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not CREATE, DELETE, RENAME, COPY, MOVE, or TAKEOWN.&&EXIT /B
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_MIX
FOR /F "TOKENS=*" %%a in ("!$QCLM3$!") DO (SET "$FILEOPER=%%a"&&SET "$RAS=%%b")
FOR /F "TOKENS=1-4 DELIMS=%U01%" %%a in ("!$QCLM2$!") DO (SET "$OBJONE=%%a"&&SET "$OBJTWO=%%b")
IF /I "%$FILEOPER%"=="COPY" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
IF /I "%$FILEOPER%"=="MOVE" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
IF /I "%$FILEOPER%"=="RENAME" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
SET "$EXIT="&&FOR %%□ IN (DELETE RENAME COPY MOVE TAKEOWN) DO (IF /I "%$FILEOPER%"=="%%□" IF NOT EXIST "!$OBJONE!" SET "$EXIT=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR4%ERROR:%$$% !$OBJONE! doesn't exist.)
IF /I "%$FILEOPER%"=="CREATE" IF EXIST "!$OBJONE!" SET "$EXIT=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR4%ERROR:%$$% !$OBJONE! already exists.
IF DEFINED $EXIT EXIT /B
IF EXIST "!$OBJONE!\*" SET "$FILE_OBJ=FOLD"
IF NOT EXIST "!$OBJONE!\*" SET "$FILE_OBJ=FILE"
IF /I "%$FILEOPER%"=="CREATE" SET "$FILE_OBJ=FOLD"
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF /I "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF /I "!$RAS!"=="RAS" SET "RUN_AS=system"
IF /I "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% !$FILEOPER! !$FILE_OBJ! !$OBJONE! as %##%%RUN_AS%%$$%!
IF /I "%$FILEOPER%"=="CREATE" IF /I "%$FILE_OBJ%"=="FOLD" MD "\\?\!$OBJONE!">NUL 2>&1
IF /I "%$FILEOPER%"=="DELETE" IF /I "%$FILE_OBJ%"=="FOLD" IF EXIST "!$OBJONE!" RD /S /Q "\\?\!$OBJONE!"
IF /I "%$FILEOPER%"=="DELETE" IF /I "%$FILE_OBJ%"=="FILE" IF EXIST "!$OBJONE!" DEL /Q /F "\\?\!$OBJONE!"
IF /I "%$FILEOPER%"=="RENAME" IF /I "%$FILE_OBJ%"=="FILE" REN "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF /I "%$FILEOPER%"=="RENAME" IF /I "%$FILE_OBJ%"=="FOLD" REN "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF /I "%$FILEOPER%"=="COPY" IF /I "%$FILE_OBJ%"=="FILE" XCOPY "!$OBJONE!" "!$OBJTWO!" /C /Y>NUL 2>&1
IF /I "%$FILEOPER%"=="COPY" IF /I "%$FILE_OBJ%"=="FOLD" XCOPY "!$OBJONE!" "!$OBJTWO!\" /E /C /I /Y>NUL 2>&1
IF /I "%$FILEOPER%"=="MOVE" IF /I "%$FILE_OBJ%"=="FILE" MOVE /Y "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF /I "%$FILEOPER%"=="MOVE" IF /I "%$FILE_OBJ%"=="FOLD" MOVE /Y "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF /I "%$FILEOPER%"=="TAKEOWN" IF /I "%$FILE_OBJ%"=="FILE" TAKEOWN /F "!$OBJONE!">NUL 2>&1
IF /I "%$FILEOPER%"=="TAKEOWN" IF /I "%$FILE_OBJ%"=="FOLD" TAKEOWN /F "!$OBJONE!" /R /D Y>NUL 2>&1
IF /I "%$FILEOPER%"=="TAKEOWN" IF DEFINED $FILE_OBJ ICACLS "!$OBJONE!" /grant %USERNAME%:F /T>NUL 2>&1
EXIT /B
:REGISTRY_ITEM
SET "$REG_OBJ="&&SET "$PASS="&&FOR %%□ IN (CREATE DELETE IMPORT EXPORT IMPORT%U01%RAS IMPORT%U01%RATI EXPORT%U01%RAS EXPORT%U01%RATI CREATE%U01%RAS CREATE%U01%RATI DELETE%U01%RAS DELETE%U01%RATI) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not CREATE, DELETE, IMPORT, EXPORT, CREATE%U01%RAS, CREATE%U01%RATI, DELETE%U01%RAS, or DELETE%U01%RATI.&&EXIT /B
CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$QCLM3$!") DO (SET "$QCLM3$=%%a"&&SET "$REG_OPER=%%a"&&SET "$RAS=%%b")
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=RCLM"&&CALL:EXPANDOFLEX
SET "$REG_KEY=!$RCLM1$!"&&SET "$REG_VAL=!$RCLM2$!"&&SET "$REG_DAT=!$RCLM3$!"&&SET "$REG_TYPE=!$RCLM4$!"
IF /I "%$REG_OPER%"=="IMPORT" IF DEFINED $REG_KEY IF NOT EXIST "!$REG_KEY!" ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg file does not exist.&&EXIT /B
IF /I "%$REG_OPER%"=="IMPORT" IF NOT DEFINED $REG_KEY ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg file location is not specified.&&EXIT /B
IF /I "%$REG_OPER%"=="EXPORT" IF DEFINED $REG_KEY IF NOT DEFINED $REG_VAL ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 "REG KEY" is not specified.&&EXIT /B
IF /I "%$REG_OPER%"=="EXPORT" IF NOT DEFINED $REG_KEY ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg "file location" is not specified.&&EXIT /B
IF /I "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL IF NOT DEFINED $REG_DAT ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 3 "registry value data" is not specified.&&EXIT /B
IF /I "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL SET "$PASS="&&FOR %%□ IN (DWORD QWORD BINARY STRING EXPAND MULTI) DO (IF /I "!$REG_TYPE!"=="%%□" SET "$PASS=1")
IF /I "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 4 "registry value type" is not DWORD, QWORD, BINARY, STRING, EXPAND, or MULTI.&&EXIT /B
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF /I "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF /I "!$RAS!"=="RAS" SET "RUN_AS=system"
IF /I "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
IF /I "%$REG_OPER%"=="IMPORT" GOTO:REGISTRY_ITEM_END
IF /I "%$REG_OPER%"=="EXPORT" GOTO:REGISTRY_ITEM_END
IF DEFINED $REG_VAL SET "$REG_OBJ=VAL"
IF NOT DEFINED $REG_VAL SET "$REG_OBJ=KEY"
IF /I "%$REG_TYPE%"=="DWORD" SET "$REG_TYPEX=REG_DWORD"
IF /I "%$REG_TYPE%"=="QWORD" SET "$REG_TYPEX=REG_QWORD"
IF /I "%$REG_TYPE%"=="BINARY" SET "$REG_TYPEX=REG_BINARY"
IF /I "%$REG_TYPE%"=="STRING" SET "$REG_TYPEX=REG_SZ"
IF /I "%$REG_TYPE%"=="EXPAND" SET "$REG_TYPEX=REG_EXPAND_SZ"
IF /I "%$REG_TYPE%"=="MULTI" SET "$REG_TYPEX=REG_MULTI_SZ"
IF /I "!$REG_DAT!"=="◁NULL▷" SET "$REG_DAT="
IF /I "!$REG_VAL!"=="◁NULL▷" SET "$REG_VAL="&&SET "$REG_TYPEX=REG_SZ"
IF NOT DEFINED @QUIET IF /I "%$REG_OBJ%"=="KEY" ECHO.Executing %@@%!$QCLM1$!%$$% !$REG_OPER! as %##%%RUN_AS%%$$% key !$REG_KEY!
IF NOT DEFINED @QUIET IF /I "%$REG_OBJ%"=="VAL" ECHO.Executing %@@%!$QCLM1$!%$$% !$REG_OPER! as %##%%RUN_AS%%$$% key !$REG_KEY! value !$REG_VAL!
IF /I "%$REG_OPER%"=="DELETE" IF /I "%$REG_OBJ%"=="KEY" IF NOT DEFINED $RAS %CMD% /C %REG% DELETE "!$REG_KEY!" /f>NUL
IF /I "%$REG_OPER%"=="DELETE" IF /I "%$REG_OBJ%"=="VAL" IF NOT DEFINED $RAS %CMD% /C %REG% DELETE "!$REG_KEY!" /v "!$REG_VAL!" /f>NUL
IF /I "%$REG_OPER%"=="CREATE" IF /I "%$REG_OBJ%"=="KEY" IF NOT DEFINED $RAS %CMD% /C %REG% ADD "!$REG_KEY!" /f>NUL
IF /I "%$REG_OPER%"=="CREATE" IF /I "%$REG_OBJ%"=="VAL" IF NOT DEFINED $RAS %CMD% /C %REG% ADD "!$REG_KEY!" /v "!$REG_VAL!" /t "!$REG_TYPEX!" /d "!$REG_DAT!" /f>NUL
IF /I "%$REG_OPER%"=="DELETE" IF /I "%$REG_OBJ%"=="KEY" IF DEFINED $RAS ECHO.%CMD% /C %REG% DELETE "!$REG_KEY!" /f ^>NUL>"$LIST"
IF /I "%$REG_OPER%"=="DELETE" IF /I "%$REG_OBJ%"=="VAL" IF DEFINED $RAS ECHO.%CMD% /C %REG% DELETE "!$REG_KEY!" /v "!$REG_VAL!" /f ^>NUL>"$LIST"
IF /I "%$REG_OPER%"=="CREATE" IF /I "%$REG_OBJ%"=="KEY" IF DEFINED $RAS ECHO.%CMD% /C %REG% ADD "!$REG_KEY!" /f ^>NUL>"$LIST"
IF /I "%$REG_OPER%"=="CREATE" IF /I "%$REG_OBJ%"=="VAL" IF DEFINED $RAS ECHO.%CMD% /C %REG% ADD "!$REG_KEY!" /v "!$REG_VAL!" /t "!$REG_TYPEX!" /d "!$REG_DAT!" /f ^>NUL>"$LIST"
:REGISTRY_ITEM_END
IF /I "%$REG_OPER%"=="IMPORT" IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% !$REG_OPER! as %##%%RUN_AS%%$$%
IF /I "%$REG_OPER%"=="EXPORT" IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% !$REG_OPER! as %##%%RUN_AS%%$$%
IF /I "%$REG_OPER%"=="IMPORT" IF NOT DEFINED $RAS %CMD% /C %REG% IMPORT "!$REG_KEY!" >NUL 2>&1
IF /I "%$REG_OPER%"=="IMPORT" IF DEFINED $RAS ECHO.%CMD% /C %REG% IMPORT "!$REG_KEY!" ^>NUL>"$LIST"
IF /I "%$REG_OPER%"=="EXPORT" IF NOT DEFINED $RAS %CMD% /C %REG% EXPORT "!$REG_KEY!" "!$REG_VAL!" /Y>NUL 2>&1
IF /I "%$REG_OPER%"=="EXPORT" IF DEFINED $RAS ECHO.%CMD% /C %REG% EXPORT "!$REG_KEY!" "!$REG_VAL!" /Y^>NUL>"$LIST"
IF DEFINED $RAS SET "$QCLM1$=COMMAND"&&SET "$QCLM3$=NORMAL"&&CALL:RASTI_CREATE
EXIT /B
:COMMAND_ITEM
SET "$PASS="&&FOR %%□ IN (NORMAL NOMOUNT NORMAL%U01%RAU NORMAL%U01%RAS NORMAL%U01%RATI NOMOUNT%U01%RAU NOMOUNT%U01%RAS NOMOUNT%U01%RATI) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not NORMAL, NOMOUNT, NORMAL%U01%RAU, NORMAL%U01%RAS, NORMAL%U01%RATI, NOMOUNT%U01%RAU, NOMOUNT%U01%RAS, or NOMOUNT%U01%RATI.&&EXIT /B
IF /I "!$QCLM3$!"=="NOMOUNT" CALL:IF_LIVE_MIX
IF /I "!$QCLM3$!"=="NORMAL" CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$QCLM3$!") DO (SET "$QCLM3$=%%a"&&SET "$RAS=%%b")
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF /I "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF /I "!$RAS!"=="RAS" SET "RUN_AS=system"
IF /I "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
SET "$COLUMN0=!COLUMN0:◁=%%!"&&SET "$COLUMN0=!$COLUMN0:▷=%%!"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ("!$COLUMN0!") DO (SET "$COLUMN2=%%b")
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% as %##%%RUN_AS%%$$% !$COLUMN2!
IF DEFINED $RAS ECHO.!$COLUMN2!>"$LIST"
IF DEFINED $RAS CALL:RASTI_CREATE
IF NOT DEFINED $RAS %CMD% /C !$COLUMN2!
SET "$COLUMN0="&&SET "$COLUMN2="
EXIT /B
:EXTPACKAGE_ITEM
SET "$PASS="&&FOR %%□ IN (INSTALL) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not INSTALL.&&EXIT /B
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (SET "EXTPACKAGE=%PackFolder%\%%□"
IF NOT EXIST "%PackFolder%\%%□" ECHO.%COLOR4%ERROR:%$$% %PackFolder%\%%□ doesn't exist.&&EXIT /B)
SET "PACK_GOOD=The operation completed successfully"
FOR %%G in ("%EXTPACKAGE%") DO (SET "PACKFULL=%%~nG%%~xG"&&SET "PACKEXT=%%~xG")
IF /I "%PACKEXT%"==".PKX" CALL %CMD% /C ""%ProgFolder%\windick.cmd" -IMAGEMGR -RUN -PACK "%$QCLM2$%" -path "%DrvTar%""&EXIT /B
FOR %%G in (APPXBUNDLE MSIXBUNDLE) DO (IF /I "%PACKEXT%"==".%%G" SET "PACKEXT=.APPX")
IF NOT DEFINED @QUIET ECHO.Installing %@@%%PACKFULL%%$$%...
CALL:IF_LIVE_MIX
IF /I "%PACKEXT%"==".APPX" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ADD-PROVISIONEDAPPXPACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" ECHO.%COLOR5%%PACK_GOOD%.%$$%&&EXIT /B)
IF /I "%PACKEXT%"==".APPX" FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ADD-PROVISIONEDAPPXPACKAGE /PACKAGEPATH:"%EXTPACKAGE%" /SKIPLICENSE 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF /I "%PACKEXT%"==".APPX" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF /I "%PACKEXT%"==".CAB" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ADD-PACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF /I "%PACKEXT%"==".CAB" GOTO:CAB_EXEC
IF /I "%PACKEXT%"==".MSU" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ADD-PACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF /I "%PACKEXT%"==".MSU" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
EXIT /B
:PKX_EXEC
IF EXIST "%ProgFolder%\$PKX" ECHO.%COLOR4%ERROR:%$$% A package is already in session. Delete the $PKX folder before proceeding.&&EXIT /B
FOR %%G in ("%$PACK_FILE%") DO (SET "PKX_NAME=%%~nG%%~xG")
SET "PkxFolder=%ProgFolder%\$PKX"&&MD "%ProgFolder%\$PKX">NUL 2>&1
FOR /F "TOKENS=*" %%□ IN ("%PKX_NAME%") DO (ECHO.Extracting %@@%%%□%$$%...)
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%$PACK_FILE%" /INDEX:1 /APPLYDIR:"%ProgFolder%\$PKX">NUL 2>&1
IF NOT EXIST "%ProgFolder%\$PKX\package.list" ECHO.%COLOR2%ERROR:%$$% Package is either missing package.list or unable to extract.
SET "ListFolder=%ProgFolder%\$PKX"&&SET "PackFolder=%ProgFolder%\$PKX"&&SET "CacheFolder=%ProgFolder%\$PKX"&&IF EXIST "%ProgFolder%\$PKX\package.list" SET "$LIST_FILE=%ProgFolder%\$PKX\package.list"&&CALL:LIST_EXEC
CD /D "%ProgFolder0%">NUL
FOR %%a in ($PACK_FILE PkxFolder PKX_NAME) DO (SET "%%a=")
IF EXIST "%ProgFolder%\$PKX" SET "FOLDER_DEL=%ProgFolder%\$PKX"&&CALL:FOLDER_DEL
IF EXIST "%ProgFolder%\$PKX" ECHO.%COLOR4%ERROR:%$$% Unable to complete package cleanup as the package is still active. Do not spawn commands asynchronously.
IF NOT EXIST "%ProgFolder%\$PKX" CALL:CLEAN
EXIT /B
:CAB_EXEC
IF EXIST "%ProgFolder%\$CAB" ECHO.%COLOR4%ERROR:%$$% A package is already in session. Delete the $CAB folder before proceeding.&&EXIT /B
IF EXIST "%ProgFolder%\$CAB" SET "FOLDER_DEL=%ProgFolder%\$CAB"&&CALL:FOLDER_DEL
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%PACKFULL%") DO (ECHO.Extracting %@@%%%□%$$%...)
MD "%ProgFolder%\$CAB">NUL 2>&1
EXPAND "%EXTPACKAGE%" -F:* "%ProgFolder%\$CAB">NUL 2>&1
SET "$QCLM2$=%ProgFolder%\$CAB"&&CALL:DRVR_INSTALL
IF EXIST "%ProgFolder%\$CAB" SET "FOLDER_DEL=%ProgFolder%\$CAB"&&CALL:FOLDER_DEL
EXIT /B
:APPX_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing AppX %@@%%%□%$$%...)
CALL:IF_LIVE_EXT
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
IF DEFINED APPX_SKIP SET "CAPS_SET=APPX_SKIPX"&&SET "CAPS_VAR=%APPX_SKIP%"&&CALL:CAPS_SET
IF DEFINED APPX_SKIP FOR %%1 in (%APPX_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&GOTO:APPX_END)
FOR /F "TOKENS=1-1* DELIMS=\" %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" /F "%$QCLM2$%" 2^>NUL') DO (IF "%%a"=="HKEY_LOCAL_MACHINE" SET "APPX_KEY=%%a\%%b"&&CALL:APPX_NML)
IF NOT DEFINED APPX_KEY FOR /F "TOKENS=1-1* DELIMS=\" %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" /F "%$QCLM2$%" 2^>NUL') DO (IF "%%a"=="HKEY_LOCAL_MACHINE" SET "APPX_KEY=%%a\%%b"&&CALL:APPX_IBX)
IF NOT DEFINED APPX_KEY IF NOT DEFINED APPX_DONE FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% AppX %%□ doesn't exist.)
IF DEFINED APPX_KEY IF NOT DEFINED APPX_DONE FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR2%ERROR:%$$% AppX %%□ is a stub or unable to remove.)
:APPX_END
FOR %%a in (APPX_DONE APPX_PATH APPX_VER APPX_KEY) DO (SET "%%a=")
EXIT /B
:APPX_NML
FOR /F "TOKENS=1-9 SKIP=2 DELIMS=\ " %%a in ('%REG% QUERY "%APPX_KEY%" /V Path 2^>NUL') DO (IF "%%a"=="Path" SET "APPX_PATH=%DrvTar%\Program Files\WindowsApps\%%g")
FOR /F "TOKENS=1-3* DELIMS=_" %%a IN ("%APPX_KEY%") DO (SET "APPX_VER=%%d")
IF DEFINED APPX_PATH IF DEFINED APPX_VER CALL:IF_LIVE_MIX
IF DEFINED APPX_PATH IF DEFINED APPX_VER FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /REMOVE-Provisionedappxpackage /PACKAGENAME:"%$QCLM2$%_%APPX_VER%" 2^>NUL') DO (
IF "%%1"=="The operation completed successfully" SET "APPX_DONE=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR5%%%1.%$$%
IF "%%1"=="The operation completed successfully" IF EXIST "%APPX_PATH%\*" SET "FOLDER_DEL=%APPX_PATH%"&&CALL:FOLDER_DEL)
IF DEFINED APPX_DONE CALL:IF_LIVE_EXT
IF DEFINED APPX_DONE %REG% ADD "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%$QCLM2$%_%APPX_VER%" /f>NUL 2>&1
EXIT /B
:APPX_IBX
CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-9 SKIP=2 DELIMS=\ " %%a in ('%REG% QUERY "%APPX_KEY%" /V Path 2^>NUL') DO (IF "%%a"=="Path" SET "APPX_PATH=%DrvTar%\Windows\SystemApps\%%f")
FOR /F "TOKENS=1-3* DELIMS=_" %%a IN ("%APPX_KEY%") DO (SET "APPX_VER=%%d")
IF DEFINED APPX_PATH IF DEFINED APPX_VER FOR /F "TOKENS=1 DELIMS=." %%1 in ('%REG% DELETE "%APPX_KEY%" /F 2^>NUL') DO (IF "%%1"=="The operation completed successfully" SET "APPX_DONE=1"&&ECHO. %COLOR5%%%1.%$$%&&IF EXIST "%APPX_PATH%\*" SET "FOLDER_DEL=%APPX_PATH%"&&CALL:FOLDER_DEL&%REG% ADD "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%$QCLM2$%_%APPX_VER%" /f>NUL 2>&1)
EXIT /B
:CAPABILITY_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Capability %@@%%%□%$$%...)
CALL:IF_LIVE_MIX
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /REMOVE-CAPABILITY /CAPABILITYNAME:"%$QCLM2$%" 2^>NUL') DO (IF "%%1"=="The operation completed successfully" CALL ECHO.%COLOR5%%%1.%$$%&&EXIT /B)
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Capability %%□ doesn't exist.)
EXIT /B
:COMPONENT_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Component %@@%%%□%$$%...)
CALL:IF_LIVE_EXT
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
IF DEFINED COMP_SKIP SET "CAPS_SET=COMP_SKIPX"&&SET "CAPS_VAR=%COMP_SKIP%"&&CALL:CAPS_SET
IF DEFINED COMP_SKIP FOR %%1 in (%COMP_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&EXIT /B)
SET "X0Z="&&SET "COMP_XNT="&&SET "FNL_XNT="&&FOR /F "TOKENS=1* DELIMS=:~" %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /F "%$QCLM2$%" 2^>NUL') DO (IF NOT "%%a"=="" CALL SET /A "COMP_XNT+=1"&&CALL SET /A "FNL_XNT+=1"&&CALL SET "TX1=%%a"&&CALL SET "TX2=%%b"&&CALL:COMP_ITEM2)
EXIT /B
:COMP_ITEM2
IF "%X0Z%"=="%TX1%" EXIT /B
IF "%COMP_XNT%" GTR "1" EXIT /B
IF "%TX1%"=="End of search" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Component %%□ doesn't exist.&&EXIT /B)
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
FOR %%a in (1 2 3 4 5 6 7 8 9) DO (CALL SET "COMP_Z%%a=")
SET "X0Z="&&SET "SUB_XNT="&&SET "COMP_FLAG="&&FOR /F "TOKENS=1* DELIMS=:~" %%1 IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /F "%$QCLM2$%" 2^>NUL') DO (IF NOT "%%1"=="" CALL SET /A "SUB_XNT+=1"&&CALL SET "X1=%%1"&&CALL SET "X2=%%2"&&CALL:COMP_DELETE)
EXIT /B
:COMP_AVOID
IF "%$QCLM2$%~%X2%"=="%COMPX%" SET "COMP_AVD=1"
EXIT /B
:COMP_DELETE
IF "%X1%"=="End of search" EXIT /B
IF "%FNL_XNT%" GTR "9" EXIT /B
IF "%SUB_XNT%" GTR "9" EXIT /B
IF "%X0Z%"=="%$QCLM2$%~%X2%" EXIT /B
SET "COMP_AVD="&&FOR %%a in (1 2 3 4 5 6 7 8 9) DO (CALL SET "COMPX=%%COMP_Z%%a%%"&&CALL:COMP_AVOID)
IF DEFINED COMP_AVD EXIT /B
SET "COMP_ABT=X"&&SET "COMP_ABT1="&&IF "%SAFE_EXCLUDE%"=="ENABLED" FOR /F "TOKENS=1-9 DELIMS=-" %%1 IN ("%$QCLM2$%") DO (IF "%%4"=="FEATURES" SET "COMP_ABT1=1")
SET "COMP_ABT2="&&IF "%SAFE_EXCLUDE%"=="ENABLED" FOR /F "TOKENS=1-9 DELIMS=-" %%1 IN ("%$QCLM2$%") DO (IF "%%5"=="REQUIRED" SET "COMP_ABT2=1")
SET "COMP_Z%FNL_XNT%=%$QCLM2$%~%X2%"&&SET "COMP_ABT3="&&FOR %%1 in (%COMP_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" SET "COMP_ABT3=1")
IF NOT DEFINED COMP_ABT1 IF NOT DEFINED COMP_ABT2 IF NOT DEFINED COMP_ABT3 SET "COMP_ABT="
SET /A "FNL_XNT+=1"&&SET "X0Z=%$QCLM2$%~%X2%"
IF NOT DEFINED COMP_FLAG IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Subcomp %@@%%%□~%X2%%$$%...)
IF DEFINED COMP_ABT IF "%FNL_XNT%"=="2" SET "COMP_FLAG=1"&&FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR2%ERROR:%$$% Component %%□ is required or unable to remove.)
IF DEFINED COMP_ABT EXIT /B
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
%REG% ADD "%X1%~%X2%" /V "Visibility" /T REG_DWORD /D "1" /F>NUL 2>&1
%REG% DELETE "%X1%~%X2%\Owners" /F>NUL 2>&1
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_MIX
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /REMOVE-PACKAGE /PACKAGENAME:"%$QCLM2$%~%X2%" 2^>NUL') DO (SET "DISMSG="&&IF "%%1"=="The operation completed successfully" CALL SET "DISMSG=%%1.")
IF NOT DEFINED DISMSG FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR2%ERROR:%$$% Component %%□ is a stub or unable to remove.)
IF DEFINED DISMSG IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%DISMSG%") DO (ECHO.%COLOR5%%%□%$$%)
EXIT /B
:DRIVER_ITEM
SET "$PASS="&&FOR %%□ IN (INSTALL DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not INSTALL or DELETE.&&EXIT /B)
IF /I "%$QCLM1$%:%$QCLM3$%:%$QCLM4$%"=="DRIVER:INSTALL:DX" CALL:DRVR_INSTALL
IF /I "%$QCLM1$%:%$QCLM3$%:%$QCLM4$%"=="DRIVER:DELETE:DX" CALL:DRVR_REMOVE
EXIT /B
:DRVR_INSTALL
SET "PACK_GOOD=The operation completed successfully"&&SET "PACK_BAD=The operation did not complete successfully"&&CALL:IF_LIVE_MIX
FOR /F "TOKENS=*" %%a in ('DIR/S/B "%$QCLM2$%\*.INF" 2^>NUL') DO (
IF NOT EXIST "%%a\*" FOR %%G in ("%%a") DO (IF NOT DEFINED @QUIET CALL ECHO.Installing %@@%%%~nG.inf%$$%...)
IF NOT EXIST "%%a\*" IF DEFINED LIVE_APPLY SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('pnputil.exe /add-driver "%%a" /install 2^>NUL') DO (IF "%%1"=="Driver package added successfully" CALL SET "DISMSG=%PACK_GOOD%")
IF NOT EXIST "%%a\*" IF NOT DEFINED LIVE_APPLY SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /ADD-DRIVER /DRIVER:"%%a" /ForceUnsigned 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" CALL SET "DISMSG=%PACK_GOOD%")
IF NOT EXIST "%%a\*" IF DEFINED DISMSG IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF NOT EXIST "%%a\*" IF NOT DEFINED DISMSG ECHO.%COLOR2%ERROR:%$$% %PACK_BAD%.)
EXIT /B
:DRVR_REMOVE
SET "FILE_OUTPUT=$DRVR"&&CALL:IF_LIVE_MIX
IF NOT DEFINED DRVR_QRY IF EXIST "$DRVR" DEL /Q /F "$DRVR">NUL 2>&1
FOR /F "TOKENS=1 DELIMS= " %%# in ("%$QCLM3$%") DO (CALL SET "$QCLM3$=%%#")
IF NOT EXIST "$DRVR" IF NOT DEFINED @QUIET ECHO.Getting driver listing...
IF NOT EXIST "$DRVR" SET "DRVR_QRY=1"&&FOR /F "TOKENS=1-9 DELIMS=|" %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-DRIVERS /FORMAT:TABLE 2^>NUL') DO (FOR /F "TOKENS=1 DELIMS= " %%# in ("%%a") DO (SET "X1=%%#")
FOR /F "TOKENS=1 DELIMS= " %%# in ("%%g") DO (SET "X3=%%#")
FOR /F "TOKENS=1 DELIMS= " %%# in ("%%b") DO (SET "CAPS_SET=X2"&&SET "CAPS_VAR=%%#"&&CALL:CAPS_SET&&CALL:FILE_OUTPUT))
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Driver %@@%%%□%$$%...)
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
SET "DISMSG="&&IF EXIST "$DRVR" FOR /F "TOKENS=1-3 DELIMS=%U00%" %%a in ($DRVR) DO (IF NOT DEFINED @QUIET IF "%%b"=="%$QCLM2$%" ECHO.Uninstalling %@@%%%a%$$% v%%c...
IF "%%b"=="%$QCLM2$%" IF DEFINED LIVE_APPLY FOR /F "TOKENS=1 DELIMS=." %%1 in ('PNPUTIL.EXE /DELETE-DRIVER "%%a" /UNINSTALL /FORCE 2^>NUL') DO (IF "%%1"=="Driver package deleted successfully" SET "DISMSG=The operation completed successfully.")
IF "%%b"=="%$QCLM2$%" IF NOT DEFINED LIVE_APPLY FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /REMOVE-DRIVER /DRIVER:"%%a" 2^>NUL') DO (IF "%%1"=="The operation completed successfully" SET "DISMSG=%%1."))
IF NOT DEFINED DISMSG FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Driver %%□ doesn't exist.)
IF DEFINED DISMSG IF NOT DEFINED @QUIET ECHO.%COLOR5%%DISMSG%%$$%
EXIT /B
:FILE_OUTPUT
IF "%FILE_OUTPUT%"=="$FEAT" ECHO.%X1%%U00%%X2%>>"$FEAT"
IF "%FILE_OUTPUT%"=="$DRVR" ECHO.%X1%%U00%%X2%%U00%%X3%>>"$DRVR"
EXIT /B
:FEATURE_ITEM
SET "$PASS="&&FOR %%□ IN (ENABLE DISABLE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not ENABLE or DISABLE.&&EXIT /B)
SET "FILE_OUTPUT=$FEAT"&&CALL:IF_LIVE_MIX
IF NOT DEFINED FEAT_QRY IF EXIST "$FEAT" DEL /Q /F "$FEAT">NUL 2>&1
IF NOT EXIST "$FEAT" IF NOT DEFINED @QUIET ECHO.Getting feature listing...
IF NOT EXIST "$FEAT" SET "FEAT_QRY=1"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=| " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-FEATURES /FORMAT:TABLE 2^>NUL') DO (FOR %%X in (Enabled Disabled) DO (IF "%%b"=="%%X" SET "CAPS_SET=X1"&&SET "CAPS_VAR=%%a"&&SET "X2=%%b"&&CALL:CAPS_SET&&CALL:FILE_OUTPUT))
IF /I "%$QCLM3$%"=="ENABLE" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (IF NOT DEFINED @QUIET ECHO.Enabling Feature %@@%%%□%$$%... 
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%□"&&CALL:CAPS_SET)
IF /I "%$QCLM3$%"=="DISABLE" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (IF NOT DEFINED @QUIET ECHO.Disabling Feature %@@%%%□%$$%...
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%□"&&CALL:CAPS_SET)
SET "FEAT="&&IF EXIST "$FEAT" FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ($FEAT) DO (IF "%%a"=="%$QCLM2$%" SET "FEAT=1"&&SET "X1=%%a"&&SET "X2=%%b")
IF NOT DEFINED FEAT FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Feature %%□ doesn't exist.&&EXIT /B)
IF /I "%$QCLM3$%"=="ENABLE" IF "%X2%"=="Enabled" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="ENABLE" IF "%X2%"=="Enabled" EXIT /B
IF /I "%$QCLM3$%"=="DISABLE" IF "%X2%"=="Disabled" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="DISABLE" IF "%X2%"=="Disabled" EXIT /B
IF /I "%$QCLM3$%"=="ENABLE" FOR /F "TOKENS=1 DELIMS=." %%■ in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /ENABLE-FEATURE /FEATURENAME:"%$QCLM2$%" /ALL 2^>NUL') DO (
IF "%%■"=="The operation completed successfully" IF NOT DEFINED @QUIET ECHO.%COLOR5%%%■.%$$%
IF "%%■"=="The operation completed successfully" SET "X2=Enabled"&&CALL:FILE_OUTPUT&&EXIT /B)
IF /I "%$QCLM3$%"=="DISABLE" FOR /F "TOKENS=1 DELIMS=." %%■ in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /DISABLE-FEATURE /FEATURENAME:"%$QCLM2$%" /REMOVE 2^>NUL') DO (
IF "%%■"=="The operation completed successfully" IF NOT DEFINED @QUIET ECHO.%COLOR5%%%$.%$$%
IF "%%■"=="The operation completed successfully" SET "X2=Disabled"&&CALL:FILE_OUTPUT&&EXIT /B)
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Feature %%□ is a stub or unable to change.)
EXIT /B
:SERVICE_ITEM
SET "$PASS="&&FOR %%□ IN (AUTO MANUAL DISABLE DELETE) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not AUTO, MANUAL, DISABLE, or DELETE.&&EXIT /B
CALL:IF_LIVE_EXT
FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (FOR /F "TOKENS=*" %%■ IN ("%$QCLM2$%") DO (
IF /I "%%□"=="DELETE" IF NOT DEFINED @QUIET ECHO.Removing Service %@@%%%■%$$%...
IF /I NOT "%%□"=="DELETE" IF NOT DEFINED @QUIET ECHO.Changing start to %@@%%%□%$$% for Service %@@%%%■%$$%...
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%■"&&CALL:CAPS_SET))
IF DEFINED SVC_SKIP SET "CAPS_SET=SVC_SKIPX"&&SET "CAPS_VAR=%SVC_SKIP%"&&CALL:CAPS_SET
IF DEFINED SVC_SKIP FOR %%1 in (%SVC_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&EXIT /B)
SET "$GO="&&FOR /F "TOKENS=1-3 DELIMS= " %%a IN ('%REG% QUERY "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V Start 2^>NUL') DO (
IF "%%a"=="Start" SET "$GO=1"
IF /I "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF "%%c"=="0x2" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF "%%c"=="0x2" EXIT /B
IF /I "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF "%%c"=="0x3" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF "%%c"=="0x3" EXIT /B
IF /I "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF "%%c"=="0x4" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF /I "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF "%%c"=="0x4" EXIT /B)
IF NOT DEFINED $GO FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Service %%□ doesn't exist.&&EXIT /B)
IF /I "%$QCLM3$%"=="DELETE" SET "$RAS=RATI"&&CALL:RASTI_CREATE
IF /I NOT "%$QCLM3$%"=="DELETE" SET "$RAS=RAS"&&CALL:RASTI_CREATE
FOR /F "TOKENS=1-3 DELIMS= " %%a IN ('%REG% QUERY "%HiveSystem%\ControlSet001\Services\%$QCLM2$%" /V Start 2^>NUL') DO (
IF /I "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF NOT "%%c"=="0x2" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF /I "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF NOT "%%c"=="0x3" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF /I "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF NOT "%%c"=="0x4" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF /I "%$QCLM3$%"=="DELETE" IF "%%a"=="Start" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
EXIT /B
:TASK_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Task %@@%%%□%$$%...)
CALL:IF_LIVE_EXT
SET "TASKID="&&FOR /F "TOKENS=1-4 DELIMS={} " %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /V Id 2^>NUL') DO (IF "%%a"=="Id" SET "TASKID=%%c")
IF NOT DEFINED TASKID FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Task %%□ doesn't exist.&&EXIT /B)
SET "$RAS=RAS"&&CALL:RASTI_CREATE
FOR /F "TOKENS=1 DELIMS= " %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /V Id 2^>NUL') DO (IF "%%a"=="Id" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
EXIT /B
:WINSXS_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF DEFINED LIVE_APPLY ECHO.%COLOR4%ERROR:%$$% OFFLINE IMAGE ONLY&&EXIT /B
CALL:IF_LIVE_EXT
IF NOT DEFINED SXS_SKIP SET "SXS_SKIP=amd64_microsoft-windows-s..cingstack.resources amd64_microsoft-windows-servicingstack amd64_microsoft.vc80.crt amd64_microsoft.vc90.crt amd64_microsoft.windows.c..-controls.resources amd64_microsoft.windows.common-controls amd64_microsoft.windows.gdiplus x86_microsoft.vc80.crt x86_microsoft.vc90.crt x86_microsoft.windows.c..-controls.resources x86_microsoft.windows.common-controls x86_microsoft.windows.gdiplus"
ECHO.&&ECHO.Removing %@@%WinSxS folder%$$%...&&SET "SUBZ="&&SET "SUBXNT="&&FOR /F "TOKENS=1-2* DELIMS=_" %%a IN ('DIR "%WinTar%\WinSxS" /A: /B /O:GN') DO (IF NOT "%%a"=="" SET "QUERYX=%%a_%%b"&&SET "SUBX=%%c"&&SET /A "SUBXNT+=1"&&CALL:LATERS_WINSXS)
EXIT /B
:LATERS_WINSXS
IF "%QUERYX%_%SUBX%"=="%SUBZ%" EXIT /B
FOR %%1 in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) DO (IF %SUBXNT% EQU %%1500 CALL ECHO.WinSxS folder queue item %##%%%1500%$$%...
IF "%SUBXNT%"=="%%1000" CALL ECHO.WinSxS folder queue item %##%%%1000%$$%...)
SET "DNTX="&&FOR %%a in (%SXS_SKIP%) DO (IF "%QUERYX%"=="%%a" SET "DNTX=1")
SET "SUBZ=%QUERYX%_%SUBX%"&&SET "DNTX="&&FOR %%a in (%SXS_SKIP%) DO (IF "%QUERYX%"=="%%a" SET "DNTX=1")
IF NOT DEFINED DNTX (TAKEOWN /F "%WinTar%\WinSxS\%QUERYX%_%SUBX%" /R /D Y>NUL 2>&1
ICACLS "%WinTar%\WinSxS\%QUERYX%_%SUBX%" /grant %USERNAME%:F /T>NUL 2>&1
RD /Q /S "\\?\%WinTar%\WinSxS\%QUERYX%_%SUBX%" >NUL 2>&1) ELSE (ECHO.Keeping %@@%%QUERYX%_%SUBX%%$$%)
EXIT /B
:SCRO_CREATE
CALL:IF_LIVE_EXT
IF /I "%$QCLM4$%"=="SC" SET "SCRO=SetupComplete"
IF /I "%$QCLM4$%"=="RO" SET "SCRO=RunOnce"
IF NOT DEFINED %$QCLM4$%_PREPARE SET "%$QCLM4$%_PREPARE=1"&&CALL:SCRO_PREPARE
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("!$QCLM2$!") DO (ECHO.Scheduling %@@%%%□%$$% for %@@%%SCRO%%$$%...)
CALL:SCRO_DISPATCH
IF /I NOT "!$QCLM1$!"=="EXTPACKAGE" GOTO:SCRO_CREATE_SKIP
FOR /F "TOKENS=*" %%░ in ("!$QCLM2$!") DO (
IF EXIST "%PackFolder%\%%░" IF NOT DEFINED @QUIET ECHO.Copying Package %@@%%%░ for %##%%SCRO%%$$%...
IF EXIST "%PackFolder%\%%░" COPY /Y "%PackFolder%\%%░" "%DrvTar%\$">NUL
IF EXIST "%PackFolder%\%%░" ECHO.%U00%EXTPACKAGE%U00%%%░%U00%INSTALL%U00%DX%U00%>>"%DrvTar%\$\%SCRO%.list"
IF NOT EXIST "%PackFolder%\%%░" ECHO.%COLOR4%ERROR:%$$% %PackFolder%\%%░ doesn't exist.)
EXIT /B
:SCRO_CREATE_SKIP
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ("!COLUMN0!") DO (ECHO.%U00%%%a%U00%%%b%U00%%%c%U00%DX%U00%>>"%DrvTar%\$\%SCRO%.list")
EXIT /B
:SCRO_PREPARE
IF NOT EXIST "%DrvTar%\$" MD "%DrvTar%\$">NUL 2>&1
COPY /Y "%ProgFolder0%\windick.cmd" "%DrvTar%\$">NUL 2>&1
IF NOT EXIST "%DrvTar%\$\%SCRO%.LIST" ECHO.MENU-SCRIPT>"%DrvTar%\$\%SCRO%.list"
IF "%SCRO%"=="RunOnce" %REG% add "%HiveSoftware%\Microsoft\Windows\CurrentVersion\RunOnce" /v "Runonce" /t REG_EXPAND_SZ /d "%%WINDIR%%\Setup\Scripts\RunOnce.cmd" /f>NUL 2>&1
IF NOT EXIST "%WinTar%\Setup\Scripts" MD "%WinTar%\Setup\Scripts">NUL 2>&1
ECHO.%%SYSTEMDRIVE%%\$\windick.cmd -imagemgr -run -list %SCRO%.list -live>"%WinTar%\Setup\Scripts\%SCRO%.cmd"
ECHO.EXIT 0 >>"%WinTar%\Setup\Scripts\%SCRO%.cmd"
EXIT /B
:SESSION_CLEAR
SET "SCROXNT="&&CALL:VAR_CLEAR&&FOR %%▓ in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (FOR %%▒ in (SC RO) DO (IF DEFINED SESSION%%▒[%%▓] SET "SESSION%%▒[%%▓]="))
EXIT /B
:SCRO_DISPATCH
FOR %%● in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (
IF DEFINED SESSION%$QCLM4$%[%%●] ECHO.!SESSION%$QCLM4$%[%%●]!>>"%DrvTar%\$\%SCRO%.list"
IF DEFINED SESSION%$QCLM4$%[%%●] SET "SESSION%$QCLM4$%[%%●]=")
EXIT /B
:SCRO_QUEUE
SET /A "SCROXNT+=1"
FOR %%● in (SC RO) DO (SET "SESSION%%●[!SCROXNT!]=!COLUMN0!")
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:IMAGEMGR_BUILDER
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
SET "$BCLM3="&&SET "$BCLM1="&&SET "$BCLM4="&&SET "$HEAD="&&CALL:SETS_HANDLER&&CALL:CLEAN
SET "$HEADERS=                            %U13% List Builder%U01% %U01%                            Select an option"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %U13% Miscellaneous"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MISCELLANEOUS&GOTO:IMAGEMGR_BUILDER
IF NOT DEFINED SELECT EXIT /B
IF NOT DEFINED $PICK GOTO:IMAGEMGR_BUILDER
IF NOT DEFINED ERROR SET "$LIST_FILE=%$PICK%"&&CALL:LIST_VIEWER
GOTO:IMAGEMGR_BUILDER
:LIST_COMBINE
IF EXIST "$LIST" FOR /F "TOKENS=1-1* SKIP=1 DELIMS=%U00%" %%a in ($LIST) DO (IF "%%a"=="GROUP" ECHO.>>"%$LIST_FILE%"
ECHO.%U00%%%a%U00%%%b>>"%$LIST_FILE%")
SET "$LIST_FILE="
EXIT /B
:LIST_MAKE
SET "$HEADERS=                            %U13% List Builder%U01% %U01%                            Create new list%U01% %U01% %U01% %U01%                        Enter name of new .LIST%U01% %U01% "&&SET "$SELECT=$LIST_NAME"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR SET "ERROR=LIST_MAKE"&&CALL:DEBUG&&EXIT /B
SET "$CHOICE=%$LIST_NAME%.list"&&ECHO.MENU-SCRIPT>"%ListFolder%\%$LIST_NAME%.list"
IF EXIST "%ListFolder%\%$CHOICE%" SET "$PICK=%ListFolder%\%$CHOICE%"
EXIT /B
:LIST_MISCELLANEOUS
CLS&&SET "IMAGE_LAST=IMAGE"&&CALL:SETS_MAIN&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP
ECHO.                            %U13% List Builder&&ECHO.&&ECHO.                             Miscellaneous&&ECHO.&&ECHO. (%##% 1 %$$%) %U13% Create Source Base&&ECHO. (%##% 2 %$$%) %U08% Generate Example Base&&ECHO. (%##% 3 %$$%) %U13% Convert Group Base&&ECHO. (%##% 4 %$$%) %U10% External Package Item&&ECHO.
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV
SET "$CHECK=NUMBER❗0-4"&&SET "$VERBOSE=1"&&SET "$SELECT=SELECTX"&&CALL:MENU_SELECT
IF NOT DEFINED SELECTX EXIT /B
IF "%SELECTX%"=="0" CALL:LIST_DIFFERENCER
IF "%SELECTX%"=="1" CALL:LIST_BASE_CREATE
IF "%SELECTX%"=="2" CALL:BASE_TEMPLATE
IF "%SELECTX%"=="3" CALL:LIST_CONVERT
IF "%SELECTX%"=="4" CALL:LIST_PACK_CREATE
GOTO:LIST_MISCELLANEOUS
:BASE_TEMPLATE
IF NOT DEFINED MENU_SKIP SET "$HEADERS= %U01% %U01% %U01% %U01%                        Enter name of new .base%U01% %U01% %U01% "&&SET "$SELECT=NEW_NAME"&&SET "$CHECK=PATH"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%EXAMPLE-BASE START:%$$%  %DATE%  %TIME%&&ECHO.&&ECHO.&&CALL:BASE_EXAMPLE>"%ListFolder%\%NEW_NAME%"
ECHO.                   Example base created successfully.&&ECHO.&&ECHO.&&ECHO.            %@@%EXAMPLE-BASE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:LIST_PACK_CREATE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                           %U13% Miscellaneous&&ECHO.
ECHO.                         External Package Item&&ECHO.&&ECHO.  %@@%AVAILABLE *.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLEs:%$$%&&ECHO.
SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST&&ECHO.&&ECHO.                        Multiples OK ( %##%1 2 3%$$% )
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF DEFINED ERROR EXIT /B
IF "%SELECT%"=="0" SET "FILE_TYPE=PACK"&&CALL:BASIC_FILE&EXIT /B
CALL:LIST_TIME
IF NOT DEFINED $BCLM4 EXIT /B
SET "$BCLM1=ExtPackage"&&SET "$BCLM3=Install"&&SET "LIST_START="&&FOR %%a in (%SELECT%) DO (CALL SET "ITEMX=%%$ITEM%%a%%"&&CALL SET "LIST_WRITE=%U00%%%$ITEM%%a%%%U00%"&&CALL:LIST_WRITE)
IF NOT DEFINED LIST_START SET "ERROR=1"&&EXIT /B
SET "$BCLM1="&&SET "$BCLM3="&&SET "$HEADERS=                            %U04% Append Items%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new list"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MAKE
IF NOT DEFINED $PICK EXIT /B
SET "$LIST_FILE=%$PICK%"&&CALL:LIST_COMBINE&&CALL:APPEND_SCREEN
EXIT /B
:LIST_WRITE
IF NOT DEFINED ITEMX EXIT /B
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 IN ("%LIST_WRITE%") DO (CALL ECHO.%U00%ExtPackage%U00%%%1%U00%%$BCLM3%%U00%%$BCLM4%%U00%>>"$LIST")
EXIT /B
:LIST_CONVERT
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                            Create Base-List%U01% %U01%                       Select a list to convert"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=LIST"&&CALL:BASIC_FILE&GOTO:LIST_CONVERT_END
IF DEFINED $PICK SET "$HEAD_CHECK=%$PICK%"&&CALL:GET_HEADER
IF DEFINED ERROR GOTO:LIST_CONVERT_END
COPY /Y "%$PICK%" "$TEMP">NUL
IF EXIST "$TEMP" SET "ISGROUP="&&FOR /F "TOKENS=1 SKIP=1 DELIMS=%U00%" %%1 in ($TEMP) DO (IF "%%1"=="GROUP" SET "ISGROUP=1"&&GOTO:LIST_CONVERT_SKIP)
:LIST_CONVERT_SKIP
IF NOT DEFINED ISGROUP ECHO.%COLOR4%ERROR:%$$% List does not contain any groups.&&SET "ERROR=1"&&CALL:PAUSED&GOTO:LIST_CONVERT_END
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                            Create Base-List%U01% %U01% %U01% %U01%                        Enter name of new .BASE%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR GOTO:LIST_CONVERT_END
IF DEFINED ISGROUP MOVE /Y "$TEMP" "%ListFolder%\%SELECT%.base">NUL
IF DEFINED ISGROUP CALL:APPEND_SCREEN
:LIST_CONVERT_END
SET "$LIST_FILE="&&CALL:CLEAN
EXIT /B
:LIST_DIFFERENCER
SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                             Select base 1"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT DEFINED $PICK EXIT /B
SET "$LIST1=%$PICK%"&&SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                             Select base 2"&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT DEFINED $PICK EXIT /B
SET "$LIST2=%$PICK%"&&CALL:PAD_SAME
IF "%$LIST1%"=="%$LIST2%" EXIT /B
SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                        Enter name of new list"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT DEFINED NEW_NAME EXIT /B
CALL:PAD_LINE&&ECHO.Differencing %$LIST1% and %$LIST2%...&&CALL:PAD_LINE
COPY /Y "%$LIST1%" "$LIST">NUL
COPY /Y "%$LIST2%" "$TEMP">NUL
ECHO.MENU-SCRIPT>"%ListFolder%\%NEW_NAME%.list"
SET "XXX1=IF NOT DEFINED $X0$"&&SET "XXX2=%ListFolder%\%NEW_NAME%.list"
SET "X=%U00%"&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%a in ($LIST) DO (
SET "$X0$="&&FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%1 in ($TEMP) DO (IF "[%%1:%%2]"=="[%%a:%%b]" SET "$X0$=1")
IF "%%a"=="APPX" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%>>"%XXX2%"
IF "%%a"=="COMPONENT" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%>>"%XXX2%"
IF "%%a"=="CAPABILITY" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%>>"%XXX2%"
IF "%%a"=="FEATURE" IF DEFINED $X0$ ECHO.%X%%%a%X%%%b%X%DISABLE%X%DX%X%>>"%XXX2%"
IF "%%a"=="FEATURE" %XXX1% ECHO.%X%%%a%X%%%b%X%ABSENT%X%>>"%XXX2%"
IF "%%a"=="SERVICE" IF DEFINED $X0$ ECHO.%X%%%a%X%%%b%X%%%c%X%DX%X%>>"%XXX2%"
IF "%%a"=="SERVICE" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%>>"%XXX2%"
IF "%%a"=="TASK" %XXX1% ECHO.%X%%%a%X%%%b%X%DELETE%X%DX%X%RAS%X%>>"%XXX2%")
SET "$LIST1="&&SET "$LIST2="&&CALL:CLEAN
CALL:PAUSED
EXIT /B
:LIST_BASE_CREATE
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                          Create Source Base"&&SET "$ITEMSTOP= ( %##%0%$$% ) All base list items"&&SET "$CHOICE_LIST=Appx%U01%Feature%U01%Component%U01%Capability%U01%Service%U01%Task%U01%Driver"&&SET "$VERBOSE=1"&&SET "$CHECKO=PATH"&&SET "$SELECT=BASE_CHOICE"&&CALL:CHOICE_BOX
IF "%BASE_CHOICE%"=="0" SET "BASE_CHOICE=1 4 2 5 6 7 3"
SET "$GO="&&FOR /F "TOKENS=1" %%a IN ("%BASE_CHOICE%") DO (FOR %%1 IN (1 2 3 4 5 6 7) DO (IF "%%a"=="%%1" SET "$GO=1"))
IF NOT DEFINED $GO EXIT /B
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                          Create Source Base%U01% %U01%                   Select a source to generate base"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "LIVE_APPLY=1"
IF NOT DEFINED LIVE_APPLY IF NOT DEFINED $PICK EXIT /B
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                          Create Source Base%U01% %U01% %U01% %U01%                      Enter name of new base list%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT DEFINED NEW_NAME EXIT /B
:LIST_BASE_CREATE_CMD
IF NOT DEFINED LIVE_APPLY SET "INPUT=%$PICK%"&&CALL:GET_FILEEXT
IF NOT DEFINED LIVE_APPLY SET "DISP_NAME=%$FILE_X%.vhdx"
IF DEFINED LIVE_APPLY SET "DISP_NAME=Current Environment"
SET "INPUT=%NEW_NAME%"&&CALL:GET_FILEEXT
IF "%EXT_UPPER%"==".BASE" SET "NEW_NAME=%$FILE_X%"
SET "$BCLM1="&&SET "$BCLM3="&&CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.       %@@%BASE-LIST CREATION START:%$$%  %DATE%  %TIME%&&ECHO.
IF NOT DEFINED LIVE_APPLY SET "$VDISK_FILE=%$PICK%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT DEFINED LIVE_APPLY IF NOT EXIST "%VDISK_LTR%:\WINDOWS" ECHO.&&ECHO.             %##%Vdisk error or Windows not installed on Vdisk.%$$%&&ECHO.&&CALL:VDISK_DETACH&&GOTO:LIST_BASE_CLEANUP
IF NOT DEFINED LIVE_APPLY SET "TARGET_PATH=%VDISK_LTR%:"
IF DEFINED LIVE_APPLY SET "TARGET_PATH=%SYSTEMDRIVE%"
ECHO. %@@%GETTING VERSION%$$%..&&ECHO.&&CALL:IF_LIVE_MIX
SET "INFO_E="&&SET "INFO_V="&&ECHO.MENU-SCRIPT>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-9 DELIMS=: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-CURRENTEDITION 2^>NUL') DO (
IF "%%a %%b"=="Image Version" SET "INFO_V=%%c"
IF "%%a %%b"=="Current Edition" IF NOT "%%c"=="is" SET "INFO_E=%%c")
FOR %%a in (INFO_V INFO_E) DO (IF NOT DEFINED %%a SET "%%a=Unavailable")
ECHO.Version:%@@%%INFO_V%%$$% Edition:%@@%%INFO_E%%$$% Source:%@@%%DISP_NAME%%$$%&&ECHO.Version:%INFO_V% Edition:%INFO_E% Source:%DISP_NAME%>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
SET "INPUT=%$PICK%"&&CALL:GET_FILEEXT
IF "%EXT_UPPER%"==".BASE" SET "NEW_NAME="
IF DEFINED LIVE_APPLY SET "$BASE_GROUP=Current Environment - %DATE% - %TIME%"
IF NOT DEFINED LIVE_APPLY SET "$BASE_GROUP=%$FILE_X%%$EXT_X% - %DATE% - %TIME%"
IF NOT DEFINED BASE_CHOICE SET "BASE_CHOICE=1 4 2 5 6 7 3"
FOR %%■ IN (%BASE_CHOICE%) DO (
IF "%%■"=="1" CALL:GET_BASE_APPX
IF "%%■"=="2" CALL:GET_BASE_FEATURE
IF "%%■"=="3" CALL:GET_BASE_COMPONENT
IF "%%■"=="4" CALL:GET_BASE_CAPABILITY
IF "%%■"=="5" CALL:GET_BASE_SERVICE
IF "%%■"=="6" CALL:GET_BASE_TASK
IF "%%■"=="7" CALL:GET_BASE_DRIVER)
SET "BASE_WRITE="&&SET "BASE_WRITELAST="&&CALL:MOUNT_INT
IF NOT DEFINED LIVE_APPLY CALL:VDISK_DETACH
:LIST_BASE_CLEANUP
ECHO.&&ECHO.        %@@%BASE-LIST CREATION END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:CLEAN&&CALL:PAUSED
EXIT /B
:GET_BASE_APPX
ECHO.&&ECHO. %@@%Getting AppX Listing%$$%..&&ECHO.&&SET "$BCLM1=AppX"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08% AppX❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=9* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
SET "$BCLM3=%U0L%CHOICE0.S%U0R%"&&FOR /F "TOKENS=9* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_FEATURE
ECHO.&&ECHO. %@@%Getting Feature Listing%$$%..&&ECHO.&&SET "$BCLM1=Feature"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08% Feature❕Scoped❕Select an option❕Enable❗Disable❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-9 DELIMS=|: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-FEATURES /FORMAT:TABLE 2^>NUL') DO (
IF "%%b"=="Enabled" SET "$BASE_CHOICE=Default is ENABLE"&&SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE
IF "%%b"=="Disabled" SET "$BASE_CHOICE=Default is DISABLE"&&SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE)
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_COMPONENT
ECHO.&&ECHO. %@@%Getting Component Listing%$$%..&&ECHO.&&SET "$BCLM1=Component"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08% Component❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=8* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=~" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_CAPABILITY
ECHO.&&ECHO. %@@%Getting Capability Listing%$$%..&&ECHO.&&SET "$BCLM1=Capability"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08% Capability❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-2 DELIMS=|: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-CAPABILITIES /FORMAT:TABLE 2^>NUL') DO (
IF "%%b"=="Installed" SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE)
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_SERVICE
ECHO.&&ECHO. %@@%Getting Service Listing%$$%..&&ECHO.&&SET "$BCLM1=Service"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08% Service❕Scoped❕Select an option❕Auto%U01%Manual%U01%Disable%U01%Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-4* DELIMS=\" %%a in ('%REG% QUERY "%HiveSystem%\ControlSet001\Services" 2^>NUL') DO (FOR /F "TOKENS=1-9 DELIMS= " %%1 in ('%REG% QUERY "%HiveSystem%\ControlSet001\Services\%%e" 2^>NUL') DO (SET "BASE_WRITE=%%e"
IF "%%1"=="Start" IF "%%3"=="0x2" SET "$BASE_CHOICE=Default is Auto"
IF "%%1"=="Start" IF "%%3"=="0x3" SET "$BASE_CHOICE=Default is Manual"
IF "%%1"=="Start" IF "%%3"=="0x4" SET "$BASE_CHOICE=Default is Disable"
IF "%%1"=="Type" IF "%%3"=="0x10" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x20" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x60" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x110" CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_TASK
ECHO.&&ECHO. %@@%Getting Task Listing%$$%..&&ECHO.&&SET "$BCLM1=Task"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08% Task❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-3* DELIMS= " %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree" /f ID /e /s 2^>NUL') DO (IF "%%b"=="REG_SZ" IF NOT "%%c"=="" FOR /F "TOKENS=2* DELIMS=\ " %%1 in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\%%c" /f PATH /e /s 2^>NUL') DO (IF "%%1"=="REG_SZ" IF NOT "%%2"=="" SET "BASE_WRITE=%%2"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_DRIVER
ECHO.&&ECHO. %@@%Getting Driver Listing%$$%..&&ECHO.&&SET "$BCLM1=Driver"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08% Driver❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
SET "DRIVER_NAME="&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-DRIVERS 2^>NUL') DO (
IF "%%a %%b"=="Published Name" SET "DRIVER_INF=%%c"
IF "%%a %%b %%c"=="Original File Name" SET "DRIVER_NAME=%%d"&&SET "BASE_WRITE=%%d"
IF "%%a %%b"=="Class Name" SET "DRIVER_CLS=%%c"
IF "%%a"=="Version" SET "DRIVER_VER=%%b"&&CALL:BASE_WRITE)
IF NOT DEFINED DRIVER_NAME ECHO.No 3rd party drivers installed.
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:BASE_WRITE
IF DEFINED BASE_WRITE IF DEFINED BASE_WRITELAST IF /I "%BASE_WRITE%"=="%BASE_WRITELAST%" EXIT /B
SET "BASE_WRITELAST=%BASE_WRITE%"
ECHO.%@@%%$BCLM1%%$$% %BASE_WRITE%%$$%
ECHO.%U00%%$BCLM1%%U00%%BASE_WRITE%%U00%%$BCLM3%%U00%DX%U00%%$BASE_CHOICE%>>"%ListFolder%\%NEW_NAME%.base"
EXIT /B
:LIST_TIME
SET "$BCLM4="&&SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                            Time of Action"&&SET "$CHOICE_LIST=Default       %U00%%@@%DX%$$%%U00% Immediate execution%U01%SetupComplete %U00%%@@%SC%$$%%U00% Scheduled execution%U01%RunOnce       %U00%%@@%RO%$$%%U00% Scheduled execution"&&SET "$VERBOSE=1"&&SET "$SELECT=SELECTZ"&&CALL:CHOICE_BOX
IF "%SELECTZ%"=="1" SET "$BCLM4=DX"
IF "%SELECTZ%"=="2" SET "$BCLM4=SC"
IF "%SELECTZ%"=="3" SET "$BCLM4=RO"
EXIT /B
:APPEND_SCREEN
IF DEFINED BASE_EXEC EXIT /B
SET "$HEADERS=                            %U13% List Builder%U01% %U01% %U01% %U01% %U01%               Selected options have been added to list%U01% %U01% %U01% "&&SET "$SELECT=SELECTX1"&&SET "$VERBOSE="&&SET "$CHECK=NONE"&&CALL:PROMPT_BOX
EXIT /B
:PAD_SAME
IF "%$LIST_FILE%"=="%$PICK%" CALL:PAD_LINE&&ECHO.%@@%%$LIST_FILE%%$$% and %@@%%$PICK%%$$% are the same...&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:LIST_ITEMS
SET LIST_ITEMS_EXECUTE=APPX FEATURE COMPONENT CAPABILITY SERVICE TASK WINSXS DRIVER EXTPACKAGE COMMAND SESSION REGISTRY FILEOPER TEXTHOST
SET LIST_ITEMS_BUILDER=ARRAY0 ARRAY1 ARRAY2 ARRAY3 ARRAY4 ARRAY5 ARRAY6 ARRAY7 ARRAY8 ARRAY9 MATH1 MATH2 MATH3 MATH4 MATH5 MATH6 MATH7 MATH8 MATH9 STRING1 STRING2 STRING3 STRING4 STRING5 STRING6 STRING7 STRING8 STRING9 CONDIT1 CONDIT2 CONDIT3 CONDIT4 CONDIT5 CONDIT6 CONDIT7 CONDIT8 CONDIT9 PROMPT1 PROMPT2 PROMPT3 PROMPT4 PROMPT5 PROMPT6 PROMPT7 PROMPT8 PROMPT9 CHOICE1 CHOICE2 CHOICE3 CHOICE4 CHOICE5 CHOICE6 CHOICE7 CHOICE8 CHOICE9 PICKER1 PICKER2 PICKER3 PICKER4 PICKER5 PICKER6 PICKER7 PICKER8 PICKER9 ROUTINE1 ROUTINE2 ROUTINE3 ROUTINE4 ROUTINE5 ROUTINE6 ROUTINE7 ROUTINE8 ROUTINE9 GROUP
EXIT /B
:VAR_ITEMS
SET VAR_ITEMS=PROMPT0.I PROMPT1.I PROMPT2.I PROMPT3.I PROMPT4.I PROMPT5.I PROMPT6.I PROMPT7.I PROMPT8.I PROMPT9.I PROMPT0.S PROMPT1.S PROMPT2.S PROMPT3.S PROMPT4.S PROMPT5.S PROMPT6.S PROMPT7.S PROMPT8.S PROMPT9.S PROMPT0.1 PROMPT1.1 PROMPT2.1 PROMPT3.1 PROMPT4.1 PROMPT5.1 PROMPT6.1 PROMPT7.1 PROMPT8.1 PROMPT9.1 STRING0.I STRING1.I STRING2.I STRING3.I STRING4.I STRING5.I STRING6.I STRING7.I STRING8.I STRING9.I STRING0.S STRING1.S STRING2.S STRING3.S STRING4.S STRING5.S STRING6.S STRING7.S STRING8.S STRING9.S STRING0.1 STRING1.1 STRING2.1 STRING3.1 STRING4.1 STRING5.1 STRING6.1 STRING7.1 STRING8.1 STRING9.1 STRING0.2 STRING1.2 STRING2.2 STRING3.2 STRING4.2 STRING5.2 STRING6.2 STRING7.2 STRING8.2 STRING9.2 STRING0.3 STRING1.3 STRING2.3 STRING3.3 STRING4.3 STRING5.3 STRING6.3 STRING7.3 STRING8.3 STRING9.3 STRING0.4 STRING1.4 STRING2.4 STRING3.4 STRING4.4 STRING5.4 STRING6.4 STRING7.4 STRING8.4 STRING9.4 STRING0.5 STRING1.5 STRING2.5 STRING3.5 STRING4.5 STRING5.5 STRING6.5 STRING7.5 STRING8.5 STRING9.5 STRING0.6 STRING1.6 STRING2.6 STRING3.6 STRING4.6 STRING5.6 STRING6.6 STRING7.6 STRING8.6 STRING9.6 STRING0.7 STRING1.7 STRING2.7 STRING3.7 STRING4.7 STRING5.7 STRING6.7 STRING7.7 STRING8.7 STRING9.7 STRING0.8 STRING1.8 STRING2.8 STRING3.8 STRING4.8 STRING5.8 STRING6.8 STRING7.8 STRING8.8 STRING9.8 STRING0.9 STRING1.9 STRING2.9 STRING3.9 STRING4.9 STRING5.9 STRING6.9 STRING7.9 STRING8.9 STRING9.9 PICKER0.I PICKER1.I PICKER2.I PICKER3.I PICKER4.I PICKER5.I PICKER6.I PICKER7.I PICKER8.I PICKER9.I PICKER0.S PICKER1.S PICKER2.S PICKER3.S PICKER4.S PICKER5.S PICKER6.S PICKER7.S PICKER8.S PICKER9.S PICKER0.1 PICKER1.1 PICKER2.1 PICKER3.1 PICKER4.1 PICKER5.1 PICKER6.1 PICKER7.1 PICKER8.1 PICKER9.1 CHOICE0.I CHOICE1.I CHOICE2.I CHOICE3.I CHOICE4.I CHOICE5.I CHOICE6.I CHOICE7.I CHOICE8.I CHOICE9.I CHOICE0.S CHOICE1.S CHOICE2.S CHOICE3.S CHOICE4.S CHOICE5.S CHOICE6.S CHOICE7.S CHOICE8.S CHOICE9.S CHOICE0.1 CHOICE1.1 CHOICE2.1 CHOICE3.1 CHOICE4.1 CHOICE5.1 CHOICE6.1 CHOICE7.1 CHOICE8.1 CHOICE9.1 CHOICE0.2 CHOICE1.2 CHOICE2.2 CHOICE3.2 CHOICE4.2 CHOICE5.2 CHOICE6.2 CHOICE7.2 CHOICE8.2 CHOICE9.2 CHOICE0.3 CHOICE1.3 CHOICE2.3 CHOICE3.3 CHOICE4.3 CHOICE5.3 CHOICE6.3 CHOICE7.3 CHOICE8.3 CHOICE9.3 CHOICE0.4 CHOICE1.4 CHOICE2.4 CHOICE3.4 CHOICE4.4 CHOICE5.4 CHOICE6.4 CHOICE7.4 CHOICE8.4 CHOICE9.4 CHOICE0.5 CHOICE1.5 CHOICE2.5 CHOICE3.5 CHOICE4.5 CHOICE5.5 CHOICE6.5 CHOICE7.5 CHOICE8.5 CHOICE9.5 CHOICE0.6 CHOICE1.6 CHOICE2.6 CHOICE3.6 CHOICE4.6 CHOICE5.6 CHOICE6.6 CHOICE7.6 CHOICE8.6 CHOICE9.6 CHOICE0.7 CHOICE1.7 CHOICE2.7 CHOICE3.7 CHOICE4.7 CHOICE5.7 CHOICE6.7 CHOICE7.7 CHOICE8.7 CHOICE9.7 CHOICE0.8 CHOICE1.8 CHOICE2.8 CHOICE3.8 CHOICE4.8 CHOICE5.8 CHOICE6.8 CHOICE7.8 CHOICE8.8 CHOICE9.8 CHOICE0.9 CHOICE1.9 CHOICE2.9 CHOICE3.9 CHOICE4.9 CHOICE5.9 CHOICE6.9 CHOICE7.9 CHOICE8.9 CHOICE9.9 CONDIT0.I CONDIT1.I CONDIT2.I CONDIT3.I CONDIT4.I CONDIT5.I CONDIT6.I CONDIT7.I CONDIT8.I CONDIT9.I CONDIT0.S CONDIT1.S CONDIT2.S CONDIT3.S CONDIT4.S CONDIT5.S CONDIT6.S CONDIT7.S CONDIT8.S CONDIT9.S CONDIT0.1 CONDIT1.1 CONDIT2.1 CONDIT3.1 CONDIT4.1 CONDIT5.1 CONDIT6.1 CONDIT7.1 CONDIT8.1 CONDIT9.1 CONDIT0.2 CONDIT1.2 CONDIT2.2 CONDIT3.2 CONDIT4.2 CONDIT5.2 CONDIT6.2 CONDIT7.2 CONDIT8.2 CONDIT9.2 CONDIT0.3 CONDIT1.3 CONDIT2.3 CONDIT3.3 CONDIT4.3 CONDIT5.3 CONDIT6.3 CONDIT7.3 CONDIT8.3 CONDIT9.3 CONDIT0.4 CONDIT1.4 CONDIT2.4 CONDIT3.4 CONDIT4.4 CONDIT5.4 CONDIT6.4 CONDIT7.4 CONDIT8.4 CONDIT9.4 CONDIT0.5 CONDIT1.5 CONDIT2.5 CONDIT3.5 CONDIT4.5 CONDIT5.5 CONDIT6.5 CONDIT7.5 CONDIT8.5 CONDIT9.5 CONDIT0.6 CONDIT1.6 CONDIT2.6 CONDIT3.6 CONDIT4.6 CONDIT5.6 CONDIT6.6 CONDIT7.6 CONDIT8.6 CONDIT9.6 CONDIT0.7 CONDIT1.7 CONDIT2.7 CONDIT3.7 CONDIT4.7 CONDIT5.7 CONDIT6.7 CONDIT7.7 CONDIT8.7 CONDIT9.7 CONDIT0.8 CONDIT1.8 CONDIT2.8 CONDIT3.8 CONDIT4.8 CONDIT5.8 CONDIT6.8 CONDIT7.8 CONDIT8.8 CONDIT9.8 CONDIT0.9 CONDIT1.9 CONDIT2.9 CONDIT3.9 CONDIT4.9 CONDIT5.9 CONDIT6.9 CONDIT7.9 CONDIT8.9 CONDIT9.9 ARRAY0.I ARRAY1.I ARRAY2.I ARRAY3.I ARRAY4.I ARRAY5.I ARRAY6.I ARRAY7.I ARRAY8.I ARRAY9.I ARRAY0.S ARRAY1.S ARRAY2.S ARRAY3.S ARRAY4.S ARRAY5.S ARRAY6.S ARRAY7.S ARRAY8.S ARRAY9.S ARRAY0.1 ARRAY1.1 ARRAY2.1 ARRAY3.1 ARRAY4.1 ARRAY5.1 ARRAY6.1 ARRAY7.1 ARRAY8.1 ARRAY9.1 ARRAY0.2 ARRAY1.2 ARRAY2.2 ARRAY3.2 ARRAY4.2 ARRAY5.2 ARRAY6.2 ARRAY7.2 ARRAY8.2 ARRAY9.2 ARRAY0.3 ARRAY1.3 ARRAY2.3 ARRAY3.3 ARRAY4.3 ARRAY5.3 ARRAY6.3 ARRAY7.3 ARRAY8.3 ARRAY9.3 ARRAY0.4 ARRAY1.4 ARRAY2.4 ARRAY3.4 ARRAY4.4 ARRAY5.4 ARRAY6.4 ARRAY7.4 ARRAY8.4 ARRAY9.4 ARRAY0.5 ARRAY1.5 ARRAY2.5 ARRAY3.5 ARRAY4.5 ARRAY5.5 ARRAY6.5 ARRAY7.5 ARRAY8.5 ARRAY9.5 ARRAY0.6 ARRAY1.6 ARRAY2.6 ARRAY3.6 ARRAY4.6 ARRAY5.6 ARRAY6.6 ARRAY7.6 ARRAY8.6 ARRAY9.6 ARRAY0.7 ARRAY1.7 ARRAY2.7 ARRAY3.7 ARRAY4.7 ARRAY5.7 ARRAY6.7 ARRAY7.7 ARRAY8.7 ARRAY9.7 ARRAY0.8 ARRAY1.8 ARRAY2.8 ARRAY3.8 ARRAY4.8 ARRAY5.8 ARRAY6.8 ARRAY7.8 ARRAY8.8 ARRAY9.8 ARRAY0.9 ARRAY1.9 ARRAY2.9 ARRAY3.9 ARRAY4.9 ARRAY5.9 ARRAY6.9 ARRAY7.9 ARRAY8.9 ARRAY9.9 MATH0.I MATH1.I MATH2.I MATH3.I MATH4.I MATH5.I MATH6.I MATH7.I MATH8.I MATH9.I MATH0.S MATH1.S MATH2.S MATH3.S MATH4.S MATH5.S MATH6.S MATH7.S MATH8.S MATH9.S MATH0.1 MATH1.1 MATH2.1 MATH3.1 MATH4.1 MATH5.1 MATH6.1 MATH7.1 MATH8.1 MATH9.1 ROUTINE0.I ROUTINE1.I ROUTINE2.I ROUTINE3.I ROUTINE4.I ROUTINE5.I ROUTINE6.I ROUTINE7.I ROUTINE8.I ROUTINE9.I ROUTINE0.S ROUTINE1.S ROUTINE2.S ROUTINE3.S ROUTINE4.S ROUTINE5.S ROUTINE6.S ROUTINE7.S ROUTINE8.S ROUTINE9.S ROUTINE0.1 ROUTINE1.1 ROUTINE2.1 ROUTINE3.1 ROUTINE4.1 ROUTINE5.1 ROUTINE6.1 ROUTINE7.1 ROUTINE8.1 ROUTINE9.1 ROUTINE0.2 ROUTINE1.2 ROUTINE2.2 ROUTINE3.2 ROUTINE4.2 ROUTINE5.2 ROUTINE6.2 ROUTINE7.2 ROUTINE8.2 ROUTINE9.2 ROUTINE0.3 ROUTINE1.3 ROUTINE2.3 ROUTINE3.3 ROUTINE4.3 ROUTINE5.3 ROUTINE6.3 ROUTINE7.3 ROUTINE8.3 ROUTINE9.3 ROUTINE0.4 ROUTINE1.4 ROUTINE2.4 ROUTINE3.4 ROUTINE4.4 ROUTINE5.4 ROUTINE6.4 ROUTINE7.4 ROUTINE8.4 ROUTINE9.4 ROUTINE0.5 ROUTINE1.5 ROUTINE2.5 ROUTINE3.5 ROUTINE4.5 ROUTINE5.5 ROUTINE6.5 ROUTINE7.5 ROUTINE8.5 ROUTINE9.5 ROUTINE0.6 ROUTINE1.6 ROUTINE2.6 ROUTINE3.6 ROUTINE4.6 ROUTINE5.6 ROUTINE6.6 ROUTINE7.6 ROUTINE8.6 ROUTINE9.6 ROUTINE0.7 ROUTINE1.7 ROUTINE2.7 ROUTINE3.7 ROUTINE4.7 ROUTINE5.7 ROUTINE6.7 ROUTINE7.7 ROUTINE8.7 ROUTINE9.7 ROUTINE0.8 ROUTINE1.8 ROUTINE2.8 ROUTINE3.8 ROUTINE4.8 ROUTINE5.8 ROUTINE6.8 ROUTINE7.8 ROUTINE8.8 ROUTINE9.8 ROUTINE0.9 ROUTINE1.9 ROUTINE2.9 ROUTINE3.9 ROUTINE4.9 ROUTINE5.9 ROUTINE6.9 ROUTINE7.9 ROUTINE8.9 ROUTINE9.9
EXIT /B
:VAR_CLEAR
IF NOT DEFINED VAR_ITEMS CALL:VAR_ITEMS
FOR %%a in (%VAR_ITEMS%) DO (SET "%%a=")
EXIT /B
:IF_LIVE_EXT
IF DEFINED LIVE_APPLY CALL:MOUNT_INT
IF DEFINED LIVE_APPLY IF NOT DEFINED UsrSid IF "%PROG_MODE%"=="COMMAND" CALL:MOUNT_USR
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
EXIT /B
:IF_LIVE_MIX
IF DEFINED LIVE_APPLY CALL:MOUNT_INT
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_MIX
EXIT /B
:MOUNT_USR
SET "$GO="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKU\AllUsersX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_USERS" SET "$GO=1")
IF NOT DEFINED $GO SET "MOUNT="
IF "%MOUNT%"=="USR" EXIT /B
SET "MOUNT=USR"&&SET "HiveUser=HKEY_USERS\AllUsersX"&&SET "UsrTar=%DrvTar%\Users\Default"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% LOAD HKU\AllUsersX "%DrvTar%\Users\Default\Ntuser.dat">NUL 2>&1
EXIT /B
:MOUNT_INT
FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\SoftwareX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Unmounting external registry hives..)
IF "%MOUNT%"=="INT" EXIT /B
SET "MOUNT=INT"&&SET "HiveUser=HKEY_CURRENT_USER"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SOFTWARE"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SYSTEM"&&SET "ApplyTarget=ONLINE"&&SET "DrvTar=%SYSTEMDRIVE%"&&SET "WinTar=%WINDIR%"&&SET "UsrTar=%USERPROFILE%"
IF DEFINED UsrSid SET "HiveUser=HKEY_USERS\%UsrSid%"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
EXIT /B
:MOUNT_EXT
SET "$GO="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\SoftwareX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "$GO=1")
IF NOT DEFINED $GO SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Mounting external registry hives..
IF "%MOUNT%"=="EXT" EXIT /B
SET "MOUNT=EXT"&&SET "HiveUser=HKEY_USERS\AllUsersX"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SoftwareX"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SystemX"&&SET "ApplyTarget=IMAGE:%TARGET_PATH%"&&SET "DrvTar=%TARGET_PATH%"&&SET "WinTar=%TARGET_PATH%\Windows"&&SET "UsrTar=%TARGET_PATH%\Users\Default"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
%REG% LOAD HKU\AllUsersX "%TARGET_PATH%\Users\Default\Ntuser.dat">NUL 2>&1
%REG% LOAD HKLM\SoftwareX "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SOFTWARE">NUL 2>&1
%REG% LOAD HKLM\SystemX "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SYSTEM">NUL 2>&1
EXIT /B
:MOUNT_MIX
FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\SoftwareX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Unmounting external registry hives..)
IF "%MOUNT%"=="MIX" EXIT /B
SET "MOUNT=MIX"&&SET "HiveUser=HKEY_CURRENT_USER"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SOFTWARE"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SYSTEM"&&SET "ApplyTarget=IMAGE:%TARGET_PATH%"&&SET "DrvTar=%TARGET_PATH%"&&SET "WinTar=%TARGET_PATH%\Windows"&&SET "UsrTar=%TARGET_PATH%\Users\Default"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:PACKAGE_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "IMAGE_LAST=PACKAGE"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U05% Image Management&&ECHO.&&ECHO.  %@@%PACKAGE CONTENTS:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%\project"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U05%PACK%$$%(%##%X%$$%)LIST%U13%     (%##%R%$$%)un Pack     (%##%E%$$%)dit Pack     (%##%B%$$%)uild Pack&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="E" CALL:PROJ_EDIT&SET "SELECT="
IF "%SELECT%"=="B" GOTO:PACK_BUILDER&SET "SELECT="
IF "%SELECT%"=="X" GOTO:IMAGE_MANAGEMENT&SET "SELECT="
IF "%SELECT%"=="R" SET "IMAGEMGR_TYPE=PACK"&&CALL:IMAGEMGR_EXECUTE&SET "SELECT="
GOTO:PACKAGE_MANAGEMENT
:PACK_BUILDER
SET "$HEADERS=                           %U05% Pack Builder%U01% %U01%                           Select an option"&&SET "$CHOICE_LIST=%U04% Capture Project Folder%U01%%U05% New Package Template%U01%%U05% Restore Package%U01%%U07% Export Drivers"&&SET "$VERBOSE=1"&&CALL:CHOICE_BOX
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:PACKAGE_MANAGEMENT
IF "%SELECT%"=="1" CALL:PROJ_CREATE&SET "SELECT="
IF "%SELECT%"=="2" CALL:PROJ_NEW&SET "SELECT="
IF "%SELECT%"=="3" CALL:PROJ_RESTORE&SET "SELECT="
IF "%SELECT%"=="4" CALL:DRVR_EXPORT&SET "SELECT="
GOTO:PACK_BUILDER
:DRVR_EXPORT
IF DEFINED ERROR EXIT /B
SET "$HEADERS=                             Driver Export%U01% %U01%                   Select a source to export drivers"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "LIVE_APPLY=1"
:DRVR_EXPORT_SKIP
IF NOT DEFINED LIVE_APPLY IF NOT DEFINED $PICK EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%DRIVER-EXPORT START:%$$%  %DATE%  %TIME%&&ECHO.
IF DEFINED LIVE_APPLY ECHO.Using live system for driver export.
IF NOT DEFINED LIVE_APPLY SET "$VDISK_FILE=%$PICK%"&&CALL:VDISK_ATTACH
IF NOT DEFINED LIVE_APPLY SET "TARGET_PATH=%VDISK_LTR%:"
IF DEFINED LIVE_APPLY SET "TARGET_PATH=%SYSTEMDRIVE%"
CALL:IF_LIVE_MIX
IF NOT EXIST "%ProgFolder%\project\driver" MD "%ProgFolder%\project\driver">NUL 2>&1
IF EXIST "%ProgFolder%\project\driver" ECHO.Exporting drivers to %ProgFolder%\project\driver...
IF EXIST "%ProgFolder%\project\driver" %DISM% /ENGLISH /%ApplyTarget% /EXPORT-DRIVER /destination:"%ProgFolder%\project\driver"
FOR %%a in (CMD LIST) DO (IF NOT EXIST "%ProgFolder%\project\PACKAGE.%%a" CALL:NEW_PACKAGE%%a)
IF NOT DEFINED LIVE_APPLY CALL:VDISK_DETACH
ECHO.&&ECHO.            %@@%DRIVER-EXPORT END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:PROJ_EDIT
FOR %%a in (package.cmd package.list) DO (IF EXIST "%ProgFolder%\project\%%a" START NOTEPAD.EXE "%ProgFolder%\project\%%a")
EXIT /B
:PROJ_RESTORE
SET "$HEADERS=                          %U05% Package Extract"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%File Operation%$$%"&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=PKX"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
CALL:PROJ_CLEAR
IF DEFINED ERROR EXIT /B
CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.          %@@%PACKAGE RESTORE START:%$$%  %DATE%  %TIME%
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%$PICK%" /INDEX:1 /APPLYDIR:"%ProgFolder%\project"
IF NOT EXIST "%ProgFolder%\project\package.list" ECHO.%COLOR2%ERROR:%$$% Package is either missing package.list or unable to extract.&&RD /S /Q "%ProgFolder%\project">NUL 2>&1
ECHO.&&ECHO.           %@@%PACKAGE RESTORE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED
EXIT /B
:PROJ_CREATE
IF NOT EXIST "%ProgFolder%\project\*" ECHO.&&ECHO.%COLOR4%ERROR:%$$% Package folder is empty.&&ECHO.&IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
IF NOT EXIST "%ProgFolder%\project\*" EXIT /B
SET "$HEADERS=                           %U05% Pack Builder%U01% %U01%                        Capture Project Folder%U01% %U01% %U01% %U01%                      Enter new .PKX package name%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=PACKNAME"&&CALL:PROMPT_BOX
IF NOT DEFINED PACKNAME EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%PACKAGE CREATE START:%$$%  %DATE%  %TIME%
%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%ProgFolder%\project" /IMAGEFILE:"%PackFolder%\%PACKNAME%.pkx" /COMPRESS:%COMPRESS% /NAME:"PKX" /CheckIntegrity /Verify
ECHO.&&ECHO.            %@@%PACKAGE CREATE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:PROJ_NEW
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%PACK-TEMPLATE START:%$$%  %DATE%  %TIME%&&ECHO.&&ECHO.
CALL:PROJ_CLEAR
IF DEFINED ERROR EXIT /B
IF NOT EXIST "%ProgFolder%\project\driver" MD "%ProgFolder%\project\driver">NUL 2>&1
CALL:NEW_PACKAGELIST&CALL:NEW_PACKAGECMD
ECHO.               New package template created successfully.&&ECHO.&&ECHO.&&ECHO.            %@@%PACK-TEMPLATE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:NEW_PACKAGELIST
(ECHO.MENU-SCRIPT&&ECHO.&&ECHO.Delete the driver list entry below and driver folder if there aren't drivers included in the package.&&ECHO.%U00%DRIVER%U00%"%%PkxFolder%%\driver"%U00%INSTALL%U00%DX%U00%&&ECHO.&&ECHO.Delete the command list entry below and package.cmd if a script is not needed.&&ECHO.%U00%COMMAND%U00%%CMD% /C "%%PkxFolder%%\package.cmd"%U00%NORMAL%U00%DX%U00%&&ECHO.&&ECHO.Manually add, copy and paste items, or replace this package.list with an existing execution list.&&ECHO.Copy any listed items such as scripts, installers, appx, cab, and msu packages into the project folder before package creation.)>"%ProgFolder%\project\package.list"
EXIT /B
:NEW_PACKAGECMD
(ECHO.::================================================&&ECHO.::These variables are built in and can help&&ECHO.::keep a script consistant throughout the entire&&ECHO.::process, whether applying to a vhdx or live.&&ECHO.::Add any files to package folder before creating.&&ECHO.::================================================&&ECHO.::Windows folder :    %%WinTar%%&&ECHO.::Drive root :        %%DrvTar%%&&ECHO.::User or defuser :   %%UsrTar%%&&ECHO.::HKLM\SOFTWARE :     %%HiveSoftware%%&&ECHO.::HKLM\SYSTEM :       %%HiveSystem%%&&ECHO.::HKCU or defuser :   %%HiveUser%%&&ECHO.::DISM target :       %%ApplyTarget%%&&ECHO.::==================START OF PACK=================&&ECHO.&&ECHO.@ECHO OFF&&ECHO.REM "%%PkxFolder%%\example.msi" /quiet /noprompt&&ECHO.&&ECHO.::===================END OF PACK==================)>"%ProgFolder%\project\package.cmd"
EXIT /B
:PROJ_CLEAR
IF DEFINED MENU_SKIP GOTO:PROJ_CLEAR_SKIP
SET "$HEADERS= %U01% %U01% %U01% %U01%         Project folder will be cleared. Press (%##%X%$$%) to proceed%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" SET "ERROR=PROJ_CLEAR"&&CALL:DEBUG&&EXIT /B
:PROJ_CLEAR_SKIP
IF EXIST "%ProgFolder%\project" SET "FOLDER_DEL=%ProgFolder%\project"&&CALL:FOLDER_DEL
IF NOT EXIST "%ProgFolder%\project" MD "%ProgFolder%\project">NUL 2>&1
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:FILE_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "MISC_LAST=FILE"&&CALL:SETS_HANDLER&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Management&&ECHO.
IF NOT DEFINED FMGR_DUAL SET "FMGR_DUAL=DISABLED"
IF NOT DEFINED FMGR_SOURCE SET "FMGR_SOURCE=%ProgFolder%"&&SET "FMGR_TARGET=%ProgFolder%"
IF NOT EXIST "%FMGR_SOURCE%\*" SET "FMGR_SOURCE=%ProgFolder%"&&SET "FMGR_TARGET=%ProgFolder%"
IF "%FMGR_DUAL%"=="ENABLED" ECHO.                           %@@%SOURCE%$$% (%##%S%$$%) %@@%TARGET%$$%&&ECHO.&&ECHO.  %@@%TARGET FOLDER:%$$% %FMGR_TARGET%&&ECHO.&&SET "$FOLD=%FMGR_TARGET%"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.
ECHO.  %@@%SOURCE FOLDER:%$$% %FMGR_SOURCE%&&ECHO.&&ECHO.  (%##%..%$$%)&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U02%FILE%$$%(%##%X%$$%)DISK%U04% (%##%.%$$%) (%##%N%$$%)ew (%##%O%$$%)pen (%##%C%$$%)opy (%##%M%$$%)ove (%##%R%$$%)en (%##%D%$$%)el (%##%#%$$%)Own (%##%V%$$%)&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="S" CALL:FMGR_SWAP&SET "SELECT="
IF "%SELECT%"=="X" GOTO:DISK_MANAGEMENT
IF "%SELECT%"=="N" CALL:FMGR_NEW&SET "SELECT="
IF "%SELECT%"=="." CALL:FMGR_EXPLORE&SET "SELECT="
IF "%SELECT%"=="C" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Copy"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_COPY&SET "SELECT="
IF "%SELECT%"=="O" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Open"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_OPEN&SET "SELECT="
IF "%SELECT%"=="M" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Move"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_MOVE&SET "SELECT="
IF "%SELECT%"=="R" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Rename"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_REN&SET "SELECT="
IF "%SELECT%"=="#" SET "$HEADERS=                          %U02% File Management%U01% %U01%                            Take Ownership"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_OWN&SET "SELECT="
IF "%SELECT%"=="D" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Delete"&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_DEL&SET "SELECT="
IF "%SELECT%"=="V" IF "%FMGR_DUAL%"=="DISABLED" SET "FMGR_DUAL=ENABLED"&SET "SELECT="
IF "%SELECT%"=="V" IF "%FMGR_DUAL%"=="ENABLED" SET "FMGR_DUAL=DISABLED"&SET "SELECT="
IF "%SELECT%"==".." CALL SET "FMGR_SOURCE=%%FMGR_SOURCE_%FMS#%%%"&&CALL SET /A "FMS#-=1"
GOTO:FILE_MANAGEMENT
:FMGR_NEW
SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Create"&&SET "$CHOICE_LIST=Folder%U01%File"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_TYPE"&&CALL:CHOICE_BOX
IF DEFINED ERROR EXIT /B
IF "%NEW_TYPE%"=="1" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Create%U01% %U01% %U01% %U01%                         Enter new folder name%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF "%NEW_TYPE%"=="1" SET "NEW_TYPE="&&MD "%FMGR_SOURCE%\%NEW_NAME%">NUL 2>&1
IF "%NEW_TYPE%"=="2" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Create%U01% %U01% %U01% %U01%              Enter new file name including the extension%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF "%NEW_TYPE%"=="2" SET "NEW_TYPE="&&ECHO.>"%FMGR_SOURCE%\%NEW_NAME%"
EXIT /B
:FMGR_REN
IF NOT DEFINED $PICK EXIT /B
IF EXIST "%$PICK%\*" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Rename%U01% %U01% %U01% %U01%                         Enter new folder name%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT EXIST "%$PICK%\*" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Rename%U01% %U01% %U01% %U01%              Enter new file name including the extension%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
ECHO.Renaming %@@%%$PICK%%$$% to %@@%%FMGR_SOURCE%\%NEW_NAME%%$$%.
REN "%$PICK%" "%NEW_NAME%"
EXIT /B
:FMGR_DEL
IF NOT DEFINED $PICK EXIT /B
IF NOT EXIST "%$PICK%\*" DEL /Q /F "\\?\%$PICK%"
IF EXIST "%$PICK%\*" RD /S /Q "\\?\%$PICK%"
IF NOT EXIST "%$PICK%\*" IF NOT EXIST "%$PICK%" ECHO.Deleting %@@%%$PICK%%$$%.
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
IF NOT EXIST "%$PICK%\*" ECHO.Copying %@@%%$PICK%%$$% to %@@%%FMGR_TARGET%%$$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%" /C /Y>NUL 2>&1
IF EXIST "%$PICK%\*" ECHO.Copying %@@%%$PICK%%$$% to %@@%%FMGR_TARGET%%$$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%\%$CHOICE%\" /E /C /I /Y>NUL 2>&1
EXIT /B
:FMGR_SYM
IF NOT DEFINED $PICK EXIT /B
IF "%FMGR_SOURCE%"=="%FMGR_TARGET%" CALL:FMGR_SAME&EXIT /B
IF EXIST "%$PICK%\*" MKLINK /J "%FMGR_TARGET%\%$CHOICE%" "%$PICK%"
IF NOT EXIST "%$PICK%\*" MKLINK "%FMGR_TARGET%\%$CHOICE%" "%$PICK%"
EXIT /B
:FMGR_MOVE
IF NOT DEFINED $PICK EXIT /B
IF "%FMGR_SOURCE%"=="%FMGR_TARGET%" CALL:FMGR_SAME&EXIT /B
IF NOT EXIST "%$PICK%\*" ECHO.Moving %@@%%$PICK%%$$% to %@@%%FMGR_TARGET%%$$%...&&MOVE /Y "%$PICK%" "%FMGR_TARGET%">NUL 2>&1
IF EXIST "%$PICK%\*" ECHO.Moving %@@%%$PICK%%$$% to %@@%%FMGR_TARGET%%$$%...&&XCOPY "%$PICK%" "%FMGR_TARGET%\%$CHOICE%\" /E /C /I /Y>NUL 2>&1
IF EXIST "%$PICK%\*" RD /S /Q "\\?\%$PICK%">NUL 2>&1
EXIT /B
:FMGR_OWN
IF NOT DEFINED $PICK EXIT /B
ECHO.
IF NOT EXIST "%$PICK%\*" TAKEOWN /F "%$PICK%"
IF NOT EXIST "%$PICK%\*" ICACLS "%$PICK%" /grant %USERNAME%:F >NUL 2>&1
IF EXIST "%$PICK%\*" TAKEOWN /F "%$PICK%" /R /D Y
IF EXIST "%$PICK%\*" ICACLS "%$PICK%" /grant %USERNAME%:F /T >NUL 2>&1
ECHO.
CALL:PAUSED
EXIT /B
:FMGR_EXPLORE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Management&&ECHO.&&ECHO.                       Enter the PATH to explore&&ECHO.&&ECHO.  %@@%AVAILABLE PATHs:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO. ^( %##%%%G%$$% ^) Volume %%G:)
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF DEFINED SELECT FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%SELECT%"=="%%G" IF EXIST "%%G:\" SET "FMGR_SOURCE=%SELECT%:"&&EXIT /B)
IF DEFINED SELECT SET "INPUT=%SELECT%"&&SET "OUTPUT=FMGR_SOURCE"&&CALL:SLASHER
EXIT /B
:FMGR_SAME
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.                      Source/Target are the same.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:FMGR_SWAP
IF NOT EXIST "%FMGR_SOURCE%" EXIT /B
IF NOT EXIST "%FMGR_TARGET%" EXIT /B
SET "FMGR_SOURCE=%FMGR_TARGET%"&&SET "FMGR_TARGET=%FMGR_SOURCE%"
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:BASIC_FILE
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
IF DEFINED FILE_OPER GOTO:BASIC_FILETYPE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                           Select an option&&ECHO.&&ECHO.&&ECHO.&&ECHO. (%##%1%$$%) Rename&&ECHO. (%##%2%$$%) Delete&&ECHO. (%##%3%$$%) Copy&&IF "%FOLDER_MODE%"=="ISOLATED" FOR %%G in (VHDX MAIN IMAGE) DO (IF "%FILE_TYPE%"=="%%G" ECHO. ^(%##%4%$$%^) Move)
ECHO.&&ECHO.&&ECHO.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=FILE_PROMPT"&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF "%FILE_PROMPT%"=="1" SET "FILE_OPER=Rename"
IF "%FILE_PROMPT%"=="2" SET "FILE_OPER=Delete"
IF "%FILE_PROMPT%"=="3" SET "FILE_OPER=Copy"
IF "%FILE_PROMPT%"=="4" IF "%FOLDER_MODE%"=="ISOLATED" FOR %%G in (VHDX MAIN IMAGE) DO (IF "%FILE_TYPE%"=="%%G" SET "FILE_OPER=MoveVHDX")
IF NOT DEFINED FILE_OPER GOTO:BASIC_ERROR
:BASIC_FILETYPE
IF "%FILE_OPER%"=="MoveVHDX" IF "%FOLDER_MODE%"=="ISOLATED" CALL:VHDX_MOVE&GOTO:BASIC_ERROR
IF DEFINED FILE_SKIP GOTO:BASIC_FILEOPER
:BASIC_FILEPICK
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&SET "$CENTERED_MSG=%FILE_OPER%"&&CALL:TXT_CENTER&&ECHO.
FOR %%X in (WIM VHDX ISO) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
FOR %%X in (LIST BASE) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
FOR %%X in (CAB MSU PKX APPX APPXBUNDLE MSIXBUNDLE) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
IF "%FILE_TYPE%"=="WALL" ECHO.  %@@%AVAILABLE JPGs/PNGs:%$$%&&ECHO.&&SET "$FOLD=%CacheFolder%"&&SET "$FILT=*.JPG *.PNG"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="MAIN" ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="IMAGE" ECHO.  %@@%AVAILABLE WIMs/VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM *.VHDX"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="LISTS" ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.BASE *.LIST"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="PACK" ECHO.  %@@%AVAILABLE PACKAGEs:%$$%&&ECHO.&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED $PICK GOTO:BASIC_ERROR
:BASIC_FILEOPER
IF "%FILE_OPER%"=="Delete" CALL:CONFIRM
IF "%FILE_OPER%"=="Delete" IF "%CONFIRM%"=="X" DEL /Q /F "%$PICK%">NUL
IF "%FILE_OPER%"=="Delete" GOTO:BASIC_ERROR
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&SET "$CENTERED_MSG=%FILE_OPER%"&&CALL:TXT_CENTER&&ECHO.&&ECHO.&&ECHO.&&ECHO.&&SET "$CENTERED_MSG=Enter new name of %$EXT%"&&CALL:TXT_CENTER&&ECHO.&&ECHO.&&ECHO.&&ECHO.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=FILE_PROMPT"&&SET "$CASE=ANY"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&CALL:MENU_SELECT
IF NOT DEFINED FILE_PROMPT GOTO:BASIC_ERROR
IF EXIST "%$PATH%\%FILE_PROMPT%%$EXT%" GOTO:BASIC_ERROR
SET "CASE=LOWER"&&SET "CAPS_SET=$EXT"&&SET "CAPS_VAR=%$EXT%"&&CALL:CAPS_SET
IF "%FILE_OPER%"=="Rename" REN "%$PICK%" "%FILE_PROMPT%%$EXT%">NUL 2>&1
IF "%FILE_OPER%"=="Copy" ECHO.Copying %FILE_PROMPT%%$EXT%...&&COPY /Y "%$PICK%" "%$PATH%%FILE_PROMPT%%$EXT%">NUL 2>&1
:BASIC_ERROR
SET "FILE_OPER="&&SET "FILE_TYPE="&&SET "FILE_NAME="&&SET "FILE_SKIP="&&SET "$PICK="
EXIT /B
:VHDX_MOVE
IF NOT "%FOLDER_MODE%"=="ISOLATED" EXIT /B
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                       Move VHDX between folders&&ECHO.&&ECHO.  %@@%IMAGE FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&ECHO.                               ( %##%-%$$% / %##%+%$$% )&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
IF "%SELECT%"=="-" CALL:MOVE2IMAGE
IF "%SELECT%"=="+" CALL:MOVE2MAIN
GOTO:VHDX_MOVE
:MOVE2IMAGE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                         Move to image folder&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%ImageFolder%\%$CHOICE%" CALL:PAD_LINE&&ECHO. File already exists in IMAGE folder. Press (%##%X%$$%) to overwrite %@@%%$CHOICE%%$$%.&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%ImageFolder%\%$CHOICE%" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED $PICK MOVE /Y "%$PICK%" "%ImageFolder%\">NUL
EXIT /B
:MOVE2MAIN
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                          Move to main folder&&ECHO.&&ECHO.  %@@%IMAGE FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%ProgFolder%\%$CHOICE%" CALL:PAD_LINE&&ECHO. File already exists in MAIN folder. Press (%##%X%$$%) to overwrite %@@%%$CHOICE%%$$%.&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%ProgFolder%\%$CHOICE%" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED $PICK MOVE /Y "%$PICK%" "%ProgFolder%\">NUL
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:DISK_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
::"MOUNTVOL","\\?\Volume{00000000-0000-0000-0000-100000000000}\","\\?\GLOBALROOT\Device\harddisk0\partition1\","\\?\BOOTPARTITION\"
@ECHO OFF&&CLS&&SET "DISK_LETTER="&&SET "DISK_MSG="&&SET "MISC_LAST=DISK"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U04% Disk Management&&CALL:DISK_LIST_BASIC&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U04%DISK%$$%(%##%X%$$%)FILE%U02%     (%##%I%$$%)nspect    (%##%E%$$%)rase                  (%##%O%$$%)ptions&&CALL:PAD_LINE&&ECHO. [%@@%PART%$$%] (%##%C%$$%)reate     (%##%D%$$%)elete     (%##%F%$$%)ormat     (%##%M%$$%)ount     (%##%U%$$%)nmount&&CALL:PAD_LINE
IF DEFINED ADV_DISK ECHO. [%@@%IMAGE%$$%](%##%N%$$%)ew VHDX      (%##%V%$$%)HDX Mount     (%##%.%$$%)ISO Mount      (%##%U%$$%)nmount&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="X" GOTO:FILE_MANAGEMENT
IF "%SELECT%"=="N" CALL:VHDX_NEW_PROMPT&SET "SELECT="
IF "%SELECT%"=="U" CALL:DISK_UNMOUNT_PROMPT&SET "SELECT="
IF "%SELECT%"=="O" IF DEFINED ADV_DISK SET "ADV_DISK="&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_DISK SET "ADV_DISK=1"&SET "SELECT="
IF "%SELECT%"=="." CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.  %@@%AVAILABLE ISOs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.ISO"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT&&CALL:ISO_MOUNT&SET "SELECT="
IF "%SELECT%"=="V" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT&&CALL:VHDX_MOUNT&SET "SELECT="
IF "%SELECT%"=="UID" CALL:DISK_MENU&&CALL:DISK_UID_PROMPT&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="E" CALL:DISK_ERASE_PROMPT&&CALL:DISK_PART_END&&SET "SELECT="
IF "%SELECT%"=="I" SET "QUERY_MSG=                        Select a disk to inspect"&&CALL:DISK_MENU&&CALL:DISKMGR_INSPECT&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="C" SET "QUERY_MSG=                   Select a disk to create partition"&&CALL:DISK_MENU&&CALL:PART_CREATE_PROMPT&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="F" SET "QUERY_MSG=                   %COLOR2%Select a disk to format partition%$$%"&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:CONFIRM&&CALL:DISKMGR_FORMAT&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="D" SET "QUERY_MSG=                   %COLOR2%Select a disk to delete partition%$$%"&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:CONFIRM&&CALL:DISKMGR_DELETE&&CALL:DISK_PART_END&SET "SELECT="
IF "%SELECT%"=="M" SET "QUERY_MSG=                   Select a disk to mount partition"&&CALL:DISK_MENU&&CALL:PART_GET&&CALL:LETTER_GET&&CALL:CONFIRM&&CALL:DISKMGR_MOUNT&SET "SELECT="
GOTO:DISK_MANAGEMENT
:VHDX_NEW_PROMPT
SET "$HEADERS=                          %U04% Disk Management%U01% %U01%                        Enter name of new .VHDX"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=VHDX_NAME"&&CALL:PROMPT_BOX
IF DEFINED VHDX_NAME (SET "VHDX_NAME=%VHDX_NAME%.vhdx") ELSE (EXIT /B)
IF EXIST "%ImageFolder%\%VHDX_NAME%" SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG&&SET "VHDX_NAME="&&ECHO.&&ECHO.ERROR&&EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01% %U01% %U01%                       Enter new VHDX size in GB%U01% %U01% %U01% %U01%                 Note: 25GB or greater is recommended"&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER❗1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF %SELECTX% LSS 1 SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF %SELECTX% GTR 9999 SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF NOT DEFINED ERROR IF %SELECTX% LSS 25 CALL:CONFIRM
IF NOT DEFINED ERROR IF %SELECTX% LSS 25 IF NOT "%CONFIRM%"=="X" SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF NOT DEFINED ERROR SET "VHDX_SIZE=%SELECTX%"
IF DEFINED ERROR EXIT /B
SET "$VDISK_FILE=%ImageFolder%\%VHDX_NAME%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_CREATE
SET "VHDX_NAME="&&EXIT /B
:DISK_UID
FOR %%a in (DISK_X UID_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.uniqueid disk id=%UID_X%&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK"
SET "DISK_X="&&SET "UID_X="&&CALL:DEL_DISK&&EXIT /B
:PART_ASSIGN
FOR %%a in (DISK_X PART_X LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.assign letter=%LETT_X% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:VOL_REMOVE
FOR %%a in (LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select VOLUME %LETT_X%&&ECHO.Remove letter=%LETT_X% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_REMOVE
FOR %%a in (DISK_X PART_X LETT_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.Remove letter=%LETT_X% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_DELETE
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.delete partition override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_FORMAT
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.format quick fs=ntfs override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK"
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_4000
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.gpt attributes=0x4000000000000001&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_8000
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.gpt attributes=0x0000000000000000&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_EFIX
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.set id=c12a7328-f81f-11d2-ba4b-00a0c93ec93b override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:PART_BAS
FOR %%a in (DISK_X PART_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.select partition %PART_X%&&ECHO.set id=ebd0a0a2-b9e5-4433-87c0-68b6b72699c7 override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:DISK_CLEAN
FOR %%a in (DISK_X) DO (IF NOT DEFINED %%a EXIT /B)
(ECHO.select disk %DISK_X%&&ECHO.attributes disk clear readonly&&ECHO.clean&&ECHO.convert gpt&&ECHO.select partition 1&&ECHO.delete partition override&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "LETT_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
:DEL_DISK
IF EXIST "$DISK" DEL /Q /F "$DISK">NUL
EXIT /B
:BOOT_FETCH
SET "$HEADERS= %U01% %U01% %U01% %U01%     File boot.sav doesn't exist. Press (%##%X%$$%) to copy from recovery%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" EXIT /B
CALL:EFI_MOUNT&&CALL:PAD_LINE
ECHO.Copying %@@%boot.sav%$$%...&&COPY /Y "%EFI_LETTER%:\$.WIM" "%CacheFolder%\boot.sav">NUL 2>&1
CALL:EFI_UNMOUNT
EXIT /B
:LETTER_GET
IF DEFINED ERROR EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01%                        Enter the drive letter"&&SET "$CHECK=LETTER"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "CAPS_SET=DISK_LETTER"&&SET "CAPS_VAR=%SELECT%"&&CALL:CAPS_SET
EXIT /B
:PART_GET
IF DEFINED ERROR EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01%                       Enter the partition number"&&SET "$CHECK=NUMBER"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "PART_NUMBER=%SELECT%"
EXIT /B
:DISK_PART_END
IF DEFINED ERROR EXIT /B
IF DEFINED DISK_MSG ECHO.&&CALL:PAD_LINE&&ECHO.%DISK_MSG%
ECHO.&&CALL:PAD_LINE&&ECHO	                      End of Disk-Part Operation&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:PART_CREATE_PROMPT
IF DEFINED ERROR EXIT /B
IF NOT DEFINED DISK_NUMBER EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01%            Enter a partition size. (%##%0%$$%) Remainder of space"&&SET "$CHECK=NUMBER"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "PART_SIZE=%SELECT%"&&CALL:CONFIRM&&CALL:DISKMGR_CREATE
EXIT /B
:DISKMGR_CREATE
IF DEFINED ERROR EXIT /B
IF "%PART_SIZE%"=="0" SET "PART_SIZE="
ECHO.Creating partition on disk %DISK_NUMBER%.
SET "DISK_X=%DISK_NUMBER%"&&SET "SIZE_X=%PART_SIZE%"
IF DEFINED SIZE_X SET "SIZE_X= size=%SIZE_X%"
(ECHO.select disk %DISK_X%&&ECHO.create partition primary%SIZE_X%&&ECHO.format quick fs=ntfs&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "DISK_X="&&SET "PART_X="&&SET "SIZE_X="&&CALL:DEL_DISK&&EXIT /B
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
(ECHO.select disk %DISK_NUMBER%&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK"
EXIT /B
:VDISK_CREATE
IF NOT DEFINED $VDISK_FILE EXIT /B
IF NOT DEFINED VDISK_LTR SET "VDISK_LTR=ANY"
IF "%VDISK_LTR%"=="ANY" SET "$GET=VDISK_LTR"&&CALL:LETTER_ANY
FOR %%G in ("%$VDISK_FILE%") DO (SET "VHDX_123=%%~nG%%~xG")
ECHO.Mounting vdisk %VHDX_123% letter %VDISK_LTR%...&&SET "VHDX_123="
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25"
SET "VHDX_MB=%VHDX_SIZE%"
SET /A "VHDX_MB*=1025"
(ECHO.create vdisk file="%$VDISK_FILE%" maximum=%VHDX_MB% type=expandable&&ECHO.select vdisk file="%$VDISK_FILE%"&&ECHO.attach vdisk&&ECHO.create partition primary&&ECHO.select partition 1&&ECHO.format fs=ntfs quick&&ECHO.assign letter=%VDISK_LTR% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "VHDX_MB="&&IF EXIST "$DISK" DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:VDISK_ATTACH
IF NOT DEFINED $VDISK_FILE EXIT /B
IF NOT DEFINED VDISK_LTR SET "VDISK_LTR=ANY"
IF "%VDISK_LTR%"=="ANY" SET "$GET=VDISK_LTR"&&CALL:LETTER_ANY
FOR %%G in ("%$VDISK_FILE%") DO (SET "VHDX_123=%%~nG%%~xG")
ECHO.Mounting vdisk %VHDX_123% letter %VDISK_LTR%...
:VDISK_RETRY
(ECHO.Select vdisk file="%$VDISK_FILE%"&&ECHO.attach vdisk&&ECHO.list vdisk&&ECHO.Exit)>"$DISK"
IF NOT EXIST "%VDISK_LTR%:\" IF NOT DEFINED VRETRY CALL:VDISK_DETACH>NUL 2>&1
IF NOT EXIST "%VDISK_LTR%:\" FOR /F "TOKENS=1-8* DELIMS=* " %%a IN ('DISKPART /s "$DISK"') DO (SET "DISK_NUM="&&IF "%%a"=="VDisk" IF /I "%%i"=="%$VDISK_FILE%" IF EXIST "%%i" SET "DISK_NUM=%%d"&&SET "VDISK_QRY=%%i"&&CALL:VDISK_ASGN)
IF NOT EXIST "%VDISK_LTR%:\" IF NOT DEFINED VRETRY SET "VRETRY=1"&&GOTO:VDISK_RETRY
SET "VRETRY="&&SET "VHDX_123="&&SET "VDISK_PART="&&SET "VDISK_QRY="&&SET "DISK_NUM="&&IF EXIST "$DISK" DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:VDISK_ASGN
SET "$PASS="&&SET "VDISK=%$VDISK_FILE%"
IF /I "%VDISK_QRY%"=="%$VDISK_FILE%" SET "$PASS=1"
IF NOT DEFINED $PASS EXIT /B
(ECHO.select disk %DISK_NUM%&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-8* DELIMS=* " %%1 IN ('DISKPART /s "$DISK"') DO (IF "%%1"=="Partition" IF NOT "%%2"=="" IF NOT "%%2"=="###" SET "VDISK_PART=%%2")
IF DEFINED VDISK_PART (ECHO.Select vdisk file="%$VDISK_FILE%"&&ECHO.select partition %VDISK_PART%&&ECHO.assign letter=%VDISK_LTR% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
EXIT /B
:VDISK_DETACH
IF NOT DEFINED $VDISK_FILE EXIT /B
FOR %%G in ("%$VDISK_FILE%") DO (SET "VHDX_123=%%~nG%%~xG")
ECHO.Unmounting vdisk %VHDX_123% letter %VDISK_LTR%...&&SET "VHDX_123="
(ECHO.Select vdisk file="%$VDISK_FILE%"&&ECHO.Detach vdisk&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
IF EXIST "$DISK*" DEL /Q /F "$DISK*">NUL 2>&1
EXIT /B
:VDISK_COMPACT
(ECHO.Select vdisk file="%$PICK%"&&ECHO.Attach vdisk readonly&&ECHO.compact vdisk&&ECHO.detach vdisk&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK"&&DEL /F "$DISK">NUL 2>&1
EXIT /B
:VHDX_MOUNT
IF NOT DEFINED $PICK EXIT /B
SET "$VDISK_FILE=%$PICK%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT EXIST "%VDISK_LTR%:\" ECHO.ERROR&&CALL:VDISK_DETACH
EXIT /B
:ISO_MOUNT
IF NOT DEFINED $PICK EXIT /B
"%$PICK%"
EXIT /B
:DISKMGR_MOUNT
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER DISK_LETTER PART_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
IF EXIST "%DISK_LETTER%:\" ECHO.%COLOR4%ERROR:%$$% Select a different drive letter.&&EXIT /B
IF "%PROG_MODE%"=="RAMDISK" IF "%DISK_LETTER%"=="Z" ECHO.%COLOR4%ERROR:%$$% Select a different drive letter.&&EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" ECHO.&&ECHO.Mounting disk %DISK_NUMBER% partition %PART_NUMBER% to letter %DISK_LETTER%:\...
SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&SET "LETT_X=%DISK_LETTER%"&&CALL:PART_ASSIGN
IF NOT EXIST "%DISK_LETTER%:\" SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=%PART_NUMBER%"&&SET "LETT_X=%DISK_LETTER%"&&CALL:PART_ASSIGN
IF EXIST "%DISK_LETTER%:\" SET "DISK_MSG=Partition %PART_NUMBER% on Disk %DISK_NUMBER% has been assigned letter %DISK_LETTER%."
IF NOT EXIST "%DISK_LETTER%:\" SET "DISK_MSG=ERROR: Partition %PART_NUMBER% on Disk %DISK_NUMBER% was not assigned letter %DISK_LETTER%."
EXIT /B
:DISK_UNMOUNT_PROMPT
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                            Volume Unmount&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO. ^( %##%%%G%$$% ^) Volume %%G:)
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=$LTR"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF DEFINED $LTR CALL:DISKMGR_UNMOUNT
EXIT /B
:LETTER_ANY
IF NOT DEFINED $GET EXIT /B
FOR %%G in (Z Y X W V U T S R Q P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" SET "%$GET%=%%G")
SET "$GET="&&EXIT /B
:DISKMGR_UNMOUNT
IF NOT EXIST "%$LTR%:\" EXIT /B
SET "$CHECK=LETTER"&&SET "CHECK_VAR=%$LTR%"&&CALL:CHECK
IF DEFINED ERROR GOTO:DISKMGR_UNMOUNT_END
(ECHO.List Volume&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-9 DELIMS= " %%a IN ('DISKPART /s "$DISK"') DO (IF "%%c"=="%$LTR%" SET "$VOL=%%b")
(ECHO.Select Volume %$VOL%&&ECHO.Detail Volume&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-9 DELIMS= " %%a IN ('DISKPART /s "$DISK"') DO (
IF "%%a"=="Disk" IF NOT "%%b"=="###" SET "$DISK=%%b"
IF "%%a"=="*" IF "%%b"=="Disk" SET "$DISK=%%c")
(ECHO.List Vdisk&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-8* DELIMS= " %%a IN ('DISKPART /s "$DISK"') DO (IF "%%a"=="VDisk" IF "%%d"=="%$DISK%" IF EXIST "%%i" SET "$VDISK=%%i"&&FOR %%G in ("%%i") DO (SET "$NAM=%%~nG%%~xG"))
IF NOT DEFINED $VDISK ECHO.Unmounting disk %$DISK% letter %$LTR%...&&(ECHO.Select Volume %$VOL%&&ECHO.Remove letter=%$LTR% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
IF DEFINED $VDISK ECHO.Unmounting vdisk %$NAM% letter %$LTR%...&&(ECHO.Select vdisk file="%$VDISK%"&&ECHO.Detach vdisk&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK" >NUL 2>&1
:DISKMGR_UNMOUNT_END
FOR %%G in ($DISK $VDISK $VOL $NAM $LTR) DO (SET "%%G=")
IF EXIST "$DISK" DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:DISK_ERASE_PROMPT
SET "QUERY_MSG=                         %COLOR2%Select a disk to erase%$$%"&&CALL:DISK_MENU
IF NOT DEFINED ERROR CALL:CONFIRM&&SET "$GET=TST_LETTER"&&CALL:LETTER_ANY&&CALL:DISKMGR_ERASE&SET "TST_LETTER="
EXIT /B
:DISKMGR_ERASE
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER) DO (IF NOT DEFINED %%a EXIT /B)
CALL SET "GET_DISK_ID=%%DISKID_%DISK_NUMBER%%%"
SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_CLEAN&&SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&SET "LETT_X=%TST_LETTER%"&&CALL:PART_ASSIGN
IF EXIST "%TST_LETTER%:\" SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_CLEAN
CALL:DISKMGR_CHANGEID>NUL 2>&1
IF NOT EXIST "%TST_LETTER%:\" SET "DISK_MSG=All partitions on Disk %DISK_NUMBER% have been erased."
IF EXIST "%TST_LETTER%:\" SET "DISK_MSG=%##%Disk %DISK_NUMBER% is currently in use - unplug disk - reboot into Windows - replug and try again.%$$%"
IF EXIST "%TST_LETTER%:\" SET "LETT_X=%TST_LETTER%"&&CALL:VOL_REMOVE
IF EXIST "%TST_LETTER%:\" SET "DISK_X=%DISK_NUMBER%"&&SET "PART_X=1"&&SET "LETT_X=%TST_LETTER%"&&CALL:PART_REMOVE
SET "TEST_X="&&EXIT /B
:DISK_UID_PROMPT
ECHO.                       Enter a new disk UID (%##%#%$$%) &&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL:MENU_SELECT
IF NOT DEFINED SELECT SET "ERROR=DISK_UID_PROMPT"&&CALL:DEBUG&&EXIT /B
IF NOT DEFINED ERROR SET "GET_DISK_ID=%SELECT%"&&CALL:CONFIRM&&CALL:DISKMGR_CHANGEID
EXIT /B
:DISKMGR_CHANGEID
IF DEFINED ERROR EXIT /B
FOR %%a in (DISK_NUMBER GET_DISK_ID) DO (IF NOT DEFINED %%a EXIT /B)
SET "UID_XNT="&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%GET_DISK_ID%^| FIND /V ""') do (CALL SET /A "UID_XNT+=1")
IF NOT "%UID_XNT%"=="36" SET "GET_DISK_ID=00000000-0000-0000-0000-000000000000"
SET "UID_X=%GET_DISK_ID%"&&SET "DISK_X=%DISK_NUMBER%"&&CALL:DISK_UID
EXIT /B
:HOST_HIDE
ECHO.Hiding the vhdx host partition...&&SET /P DISK_TARGET=<"%ProgFolder0%\HOST_TARGET"&&CALL:DISK_DETECT>NUL 2>&1
IF NOT DEFINED DISK_DETECT EXIT /B
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&SET "LETT_X=Z"&&CALL:PART_REMOVE&&SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&CALL:PART_4000
EXIT /B
:HOST_AUTO
SET "HOST_ERROR="&&IF NOT DEFINED ARBIT_FLAG CLS&&ECHO.Querying disks...
IF EXIST "Z:\" (ECHO.select volume Z&&ECHO.remove letter=Z noerr&&ECHO.exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
IF EXIST "%ProgFolder0%\HOST_FOLDER" SET /P HOST_FOLDERX=<"%ProgFolder0%\HOST_FOLDER"
IF NOT DEFINED HOST_FOLDERX SET "HOST_FOLDERX=$"
SET /P HOST_TARGET=<"%ProgFolder0%\HOST_TARGET"
SET "DISK_TARGET=%HOST_TARGET%"
IF DEFINED ARBIT_FLAG CALL:DISK_DETECT>NUL 2>&1
IF NOT DEFINED ARBIT_FLAG SET "QUERY_X=1"&&CALL:DISK_DETECT
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&CALL:PART_8000&&SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&SET "LETT_X=Z"&&CALL:PART_ASSIGN
IF EXIST "Z:\" IF NOT EXIST "Z:\%HOST_FOLDERX%" MD "Z:\%HOST_FOLDERX%">NUL 2>&1
IF EXIST "Z:\%HOST_FOLDERX%" IF NOT EXIST "Z:\%HOST_FOLDERX%\windick.cmd" COPY /Y "%ProgFolder0%\windick.cmd" "Z:\%HOST_FOLDERX%">NUL 2>&1
IF EXIST "Z:\%HOST_FOLDERX%\windick.ini" COPY /Y "Z:\%HOST_FOLDERX%\windick.ini" "%ProgFolder0%">NUL 2>&1
IF NOT DEFINED SETS_LOAD IF EXIST "%ProgFolder0%\SETTINGS_INI" COPY /Y "%ProgFolder0%\SETTINGS_INI" "%ProgFolder0%\windick.ini">NUL 2>&1
IF NOT EXIST "Z:\%HOST_FOLDERX%" IF NOT DEFINED ARBIT_FLAG SET "ARBIT_FLAG=1"&&GOTO:HOST_AUTO
SET "ARBIT_FLAG="&&IF EXIST "Z:\%HOST_FOLDERX%" SET "ProgFolder=Z:\%HOST_FOLDERX%"&&SET "HOST_NUMBER=%DISK_DETECT%"
IF NOT DEFINED DISK_DETECT SET "HOST_ERROR=1"&&SET "DISK_TARGET="
EXIT /B
:EFI_MOUNT
IF NOT DEFINED DISK_TARGET SET "EFI_LETTER="&&EXIT /B
SET "$GET=EFI_LETTER"&&CALL:LETTER_ANY
SET /P HOST_TARGET=<"%ProgFolder0%\HOST_TARGET"
SET "DISK_TARGET=%HOST_TARGET%"&&CALL:DISK_DETECT>NUL 2>&1
IF NOT DEFINED DISK_DETECT SET "ERROR=EFI_MOUNT"&&CALL:DEBUG&&ECHO.%COLOR2%ERROR:%$$% EFI target disk could not be found.&&SET "EFI_LETTER="&&EXIT /B
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&CALL:PART_BAS
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&SET "LETT_X=%EFI_LETTER%"&&CALL:PART_ASSIGN
IF NOT EXIST "%EFI_LETTER%:\" SET "ERROR=EFI_MOUNT"&&CALL:DEBUG&&ECHO.%COLOR2%ERROR:%$$% EFI %EFI_LETTER%:\ could not be mounted.&&SET "EFI_LETTER="
EXIT /B
:EFI_UNMOUNT
IF NOT DEFINED DISK_TARGET SET "EFI_LETTER="
IF NOT EXIST "%EFI_LETTER%:\" SET "EFI_LETTER="
IF NOT DEFINED EFI_LETTER EXIT /B
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&SET "LETT_X=%EFI_LETTER%"&&CALL:PART_REMOVE
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&CALL:PART_EFIX
IF EXIST "%EFI_LETTER%:\" SET "ERROR=EFI_UNMOUNT"&&CALL:DEBUG&&ECHO.%COLOR2%ERROR:%$$% EFI %EFI_LETTER%:\ could not dismount.
SET "EFI_LETTER="&&EXIT /B
:DISK_MENU
CLS&&SET "DISK_TARGET="&&CALL:PAD_LINE&&SET "DISK_GET=1"&&CALL:DISK_LIST
CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER"&&SET "$VERBOSE=1"&&SET "$SELECT=DISK_NUMBER"&&CALL:MENU_SELECT
IF NOT DEFINED DISK_%DISK_NUMBER% SET "ERROR=DISK_MENU"&&CALL:DEBUG
IF DEFINED ERROR EXIT /B
CALL SET "DISK_TARGET=%%DISKID_%DISK_NUMBER%%%"
FOR %%G in (DISK_NUMBER DISK_TARGET) DO (IF NOT DEFINED %%G SET "ERROR=DISK_MENU"&&CALL:DEBUG)
IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_NUMBER%"=="%DISK_NUMBER%" SET "ERROR=DISK_MENU"&&CALL:DEBUG
IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_TARGET%"=="%DISK_TARGET%" SET "ERROR=DISK_MENU"&&CALL:DEBUG
EXIT /B
:DISK_LIST
SET "$BOX=RT"&&CALL:BOX_DISP
IF DEFINED QUERY_MSG ECHO.%QUERY_MSG%
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%SystemDrive%") DO (SET "SYS_VOLUME=%%G")
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%ProgFolder%") DO (SET "PROG_VOLUME=%%G")
(ECHO.LIST DISK&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-5 SKIP=8 DELIMS= " %%a in ('DISKPART /s "$DISK"') DO (
IF "%%a"=="Disk" IF NOT "%%b"=="###" SET "DISKVND="&&(ECHO.select disk %%b&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&SET "LTRX=X"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS={}: " %%1 in ('DISKPART /s "$DISK"') DO (
IF "%%1 %%2"=="Disk %%b" ECHO.&&ECHO.   %@@%Disk%$$% ^(%##%%%b%$$%^)
IF NOT "%%1 %%2"=="Disk %%b" IF NOT DEFINED DISKVND SET "DISKVND=$"&&ECHO.   %%1 %%2 %%3 %%4 %%5
IF "%%1"=="Type" ECHO.    %@@%Type%$$% = %%2
IF "%%1 %%2"=="Disk ID" ECHO.    %@@%UID%$$%  = %%3
IF "%%1 %%3"=="Volume %SYS_VOLUME%" ECHO.  %COLOR2%  System Volume%$$%
IF "%%1 %%3"=="Volume %PROG_VOLUME%" ECHO.  %COLOR2%  Program Volume%$$%
IF "%%1 %%2 %%3"=="Pagefile Disk Yes" ECHO.  %COLOR2%  Active Pagefile%$$%
IF "%%1"=="Partition" IF NOT "%%2"=="###" SET "PARTX=%%2"&&SET "SIZEX=%%4 %%5"&&(ECHO.select disk %%b&&ECHO.select partition %%2&&ECHO.detail partition&&ECHO.Exit)>"$DISK"&&SET "LTRX="&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=* " %%A in ('DISKPART /s "$DISK"') DO (IF "%%A"=="Volume" IF NOT "%%B"=="###" SET "LTRX=%%C"&&CALL:DISK_CHECK)
IF NOT DEFINED LTRX IF NOT "%%2"=="DiskPart..." ECHO.    %@@%Part %%2%$$% Vol * %%4 %%5))
IF DEFINED DISK_GET CALL:DISK_DETECT>NUL 2>&1
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP
FOR %%a in ($GO LTRX PARTX SIZEX QUERY_MSG DISK_GET) DO (SET "%%a=")
DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:DISK_CHECK
SET "$GO="&&FOR %%■ in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%%■"=="%LTRX%" SET "$GO=1"&&ECHO.    %@@%Part %PARTX%%$$% Vol %@@%%LTRX%%$$% %SIZEX%)
IF NOT DEFINED $GO ECHO.    %@@%Part %PARTX%%$$% Vol * %SIZEX%
EXIT /B
:DISK_LIST_BASIC
(ECHO.LIST DISK&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-5 SKIP=8 DELIMS= " %%a in ('DISKPART /s "$DISK"') DO (
IF "%%a"=="Disk" IF NOT "%%b"=="###" ECHO.&&ECHO.   %@@%%%a%$$% %@@%%%b%$$%&&SET "DISKVND="&&(ECHO.select disk %%b&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS={}: " %%1 in ('DISKPART /s "$DISK"') DO (
IF NOT "%%1 %%2"=="Disk %%b" IF NOT DEFINED DISKVND SET "DISKVND=$"&&ECHO.   %%1 %%2 %%3 %%4 %%5
FOR %%■ in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF "%%1"=="Volume" IF "%%3"=="%%■" ECHO.    Vol %@@%%%■%$$%)))
ECHO.&&DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:DISK_DETECT
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%SystemDrive%") DO (SET "SYS_VOLUME=%%G")
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%ProgFolder%") DO (SET "PROG_VOLUME=%%G")
SET "DISK_DETECT="&&FOR %%a in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30) DO (IF DEFINED DISK_%%a SET "DISK_%%a="&&SET "DISKID_%%a=")
(ECHO.LIST DISK&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1,2,4 SKIP=8 DELIMS= " %%a in ('DISKPART /s "$DISK"') DO (IF "%%a"=="Disk" IF NOT "%%b"=="###" SET "DISK_%%b="&&(ECHO.select disk %%b&&ECHO.detail disk&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS={}: " %%1 in ('DISKPART /s "$DISK"') DO (
IF "%%1 %%2"=="Disk %%b" SET "DISK_%%b=%%b"
IF "%%1 %%2"=="Disk ID" SET "DISKID_%%b=%%3"&&IF "%%3"=="%DISK_TARGET%" SET "DISK_DETECT=%%b"
IF "%%1 %%2"=="Disk ID" IF DEFINED QUERY_X ECHO.Getting info for disk uid %##%%%3%$$%...
IF "%%1 %%2 %%3"=="Pagefile Disk Yes" SET "DISK_%%b="
IF "%%2 %%3 %%4"=="File Backed Virtual" SET "DISK_%%b=VDISK"
IF "%%1 %%3"=="Volume %SYS_VOLUME%" SET "DISK_%%b="
IF "%%1 %%3"=="Volume %PROG_VOLUME%" SET "DISK_%%b="
IF "%%1 %%3"=="Volume Z" IF "%PROG_MODE%"=="RAMDISK" SET "HOST_VOLUME=%%2"))
IF DEFINED QUERY_X SET "QUERY_X="&&CLS
DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:BOOT_CREATOR
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U04% BootDisk Creator&&ECHO.&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&ECHO. (%##%O%$$%)ptions                     (%##%C%$$%)reate        (%##%V%$$%)HDX %@@%%VHDX_SLOTX%%$$%&&CALL:PAD_LINE
IF DEFINED ADV_BOOT ECHO. [%@@%OPTIONS%$$%]   (%##%A%$$%)dd File      (%##%E%$$%)xport EFI      (%##%W%$$%)allpaper %@@%%PE_WALLPAPER%%$$%&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="E" CALL:EFI_FETCH
IF "%SELECT%"=="V" SET "$VHDX=X"&&CALL:VHDX_CHECK
IF "%SELECT%"=="O" IF DEFINED ADV_BOOT SET "ADV_BOOT="&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_BOOT SET "ADV_BOOT=1"&SET "SELECT="
IF "%SELECT%"=="A" CALL:ADDFILE_MENU
IF "%SELECT%"=="C" CALL:BOOT_CREATOR_PROMPT
IF "%SELECT%"=="W" CALL:PE_WALLPAPER
GOTO:BOOT_CREATOR
:ADDFILE_MENU
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.
FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (CALL ECHO. File ^(%##%%%G%$$%^) %@@%%%ADDFILE_%%G%%%$$%)
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (IF "%SELECT%"=="%%G" SET "ADDFILEX=%SELECT%"&&CALL:ADDFILE_CHOOSE)
GOTO:ADDFILE_MENU
:ADDFILE_CHOOSE
CLS&&SET "ADDFILEZ="&&IF "%FOLDER_MODE%"=="UNIFIED" SET "SELECTX=5"&&GOTO:ADDFILE_JUMP
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.&&ECHO. (%##%1%$$%) Package&&ECHO. (%##%2%$$%) List&&CALL ECHO. (%##%3%$$%) Image&&ECHO. (%##%4%$$%) Cache&&ECHO. (%##%5%$$%) Main&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER❗1-5"&&SET "$SELECT=SELECTX"&&CALL:MENU_SELECT
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" IF NOT "%SELECTX%"=="3" IF NOT "%SELECTX%"=="4" IF NOT "%SELECTX%"=="5" EXIT /B
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.
IF "%SELECTX%"=="1" SET "ADDFILEZ=pack" ECHO.  %@@%AVAILABLE PACKAGEs:%$$%&&ECHO.&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST
IF "%SELECTX%"=="2" SET "ADDFILEZ=list"&&ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST *.BASE"&&CALL:FILE_LIST
IF "%SELECTX%"=="3" SET "ADDFILEZ=image"&&ECHO.  %@@%AVAILABLE IMAGEs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM *.VHDX *.ISO"&&CALL:FILE_LIST
IF "%SELECTX%"=="4" SET "ADDFILEZ=cache"&&ECHO.  %@@%AVAILABLE CACHE FILEs:%$$%&&ECHO.&&SET "$FOLD=%CacheFolder%"&&SET "$FILT=*.*"&&CALL:FILE_LIST
:ADDFILE_JUMP
IF "%SELECTX%"=="5" SET "ADDFILEZ=main"&&ECHO.  %@@%AVAILABLE MAIN FILEs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.*"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED ADDFILEZ IF DEFINED $PICK IF EXIST "%$PICK%" IF NOT EXIST "%$PICK%\*" SET "ADDFILE_%ADDFILEX%=%ADDFILEZ%\%$CHOICE%"
IF DEFINED ADDFILEZ IF NOT DEFINED $PICK SET "ADDFILE_%ADDFILEX%=SELECT"
EXIT /B
:EFI_FETCH
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.        EFI boot files will be extracted from the boot media.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:CONFIRM
IF NOT "%CONFIRM%"=="X" EXIT /B
CLS&&IF EXIST "%CacheFolder%\boot.sdi" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.         File boot.sdi already exists. Press (%##%X%$$%) to overwrite&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF EXIST "%CacheFolder%\boot.sdi" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%CacheFolder%\bootmgfw.efi" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.       File bootmgfw.efi already exists. Press (%##%X%$$%) to overwrite&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF EXIST "%CacheFolder%\bootmgfw.efi" IF NOT "%CONFIRM%"=="X" EXIT /B
CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.            %@@%EFI EXPORT START:%$$%  %DATE%  %TIME%&&ECHO.&&CALL:VTEMP_CREATE&ECHO.Extracting boot-media. Using boot.sav located in folder...
SET "$IMAGE_X=%CacheFolder%\boot.sav"&&SET "INDEX_WORD=Setup"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%CacheFolder%\boot.sav" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF EXIST "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" ECHO.File boot.sdi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" "%CacheFolder%">NUL 2>&1
IF EXIST "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" ECHO.File bootmgfw.efi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" "%CacheFolder%">NUL 2>&1
ECHO.&&ECHO.EFI boot files will be used during boot creation when present.&&ECHO.&&CALL:VTEMP_DELETE&&ECHO.&&ECHO.             %@@%EFI EXPORT END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED
EXIT /B
:BOOT_CREATOR_PROMPT
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%CacheFolder%\boot.sav" CALL:BOOT_FETCH
IF NOT EXIST "%CacheFolder%\boot.sav" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.   Import boot media from within image processing before proceeding.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED&&EXIT /B
IF "%VHDX_SLOTX%"=="SELECT" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.&&ECHO.              No virtual hard disk file has been selected.&&ECHO.        Virtual disks can be added to the boot menu in Recovery.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:CONFIRM
IF "%VHDX_SLOTX%"=="SELECT" IF NOT "%CONFIRM%"=="X" EXIT /B
SET "QUERY_MSG=                         %COLOR2%Select a disk to erase%$$%"&&CALL:DISK_MENU
IF DEFINED ERROR EXIT /B
CALL:CONFIRM
IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED DISK_NUMBER CALL:BOOT_CREATOR_START
EXIT /B
:PART_CREATE
IF DEFINED ERROR EXIT /B
CALL:DISKMGR_ERASE
IF NOT DEFINED EFI SET "EFI=efi"
IF NOT DEFINED EFI_SIZE SET "EFI_SIZE=1024"
(ECHO.select disk %DISK_NUMBER%&&ECHO.create partition %EFI% size=%EFI_SIZE%&&ECHO.select partition 1&&ECHO.format quick fs=fat32 label="ESP"&&ECHO.assign letter=%EFI_LETTER% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "TIMER=3"&&CALL:TIMER
IF NOT EXIST "%EFI_LETTER%:\" (ECHO.select disk %DISK_NUMBER%&&ECHO.select partition 1&&ECHO.format quick fs=fat32 label="ESP"&&ECHO.assign letter=%EFI_LETTER% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "TIMER=3"&&CALL:TIMER
IF NOT EXIST "%EFI_LETTER%:\" FOR %%a in (1 2 3) DO (IF NOT DEFINED RETRY_PART%%a SET "RETRY_PART%%a=1"&&SET "EFI=primary"&&GOTO:PART_CREATE)
(ECHO.select disk %DISK_NUMBER%&&ECHO.create partition primary&&ECHO.select partition 2&&ECHO.format quick fs=ntfs&&ECHO.assign letter=%PRI_LETTER% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "TIMER=3"&&CALL:TIMER
IF NOT EXIST "%PRI_LETTER%:\" (ECHO.select disk %DISK_NUMBER%&&ECHO.select partition 2&&ECHO.format quick fs=ntfs&&ECHO.assign letter=%PRI_LETTER% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
SET "TIMER=3"&&CALL:TIMER&&DEL /Q /F "$DISK">NUL 2>&1
SET "RETRY_PART1="&&SET "RETRY_PART2="&&SET "RETRY_PART3="
IF EXIST "%EFI_LETTER%:\" IF EXIST "%PRI_LETTER%:\" SET "EFI="&&EXIT /B
ECHO.                     %COLOR2%The disk is currently in use.%$$%&&ECHO.     A malfunctioning disk, or if a program located on the disk&&ECHO.            is currently in use can also cause an error.&&ECHO.  For best results it is recommended to use an external nvme drive.&&ECHO.    Unplug the USB disk and/or reboot if this continues to occur.&&ECHO.
SET "EFI="&&ECHO.&&SET "ERROR=PART_CREATE"&&CALL:DEBUG&&EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:BOOT_CREATOR_START
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%BOOT CREATOR START:%$$%  %DATE%  %TIME%&&ECHO.&&CALL:GET_SPACE_ENV
SET "DISK_MSG="&&%DISM% /cleanup-MountPoints>NUL 2>&1
SET "CHAR_STR=%VHDX_SLOTX%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK
IF DEFINED CHAR_FLG ECHO.%COLOR4%ERROR:%$$% Remove the space from the VHDX name, then try again. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_FINISH
FOR %%a in (0 1 2 3 4 5 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_FINISH)
CALL:DISK_DETECT>NUL&CALL SET "DISK_TARGET=%%DISKID_%DISK_NUMBER%%%"&CALL:DISK_DETECT>NUL
SET "UID_XNT="&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%DISK_TARGET%^| FIND /V ""') do (CALL SET /A "UID_XNT+=1")
IF NOT "%UID_XNT%"=="36" (ECHO.Converting to GPT..&&CALL:DISKMGR_ERASE&&CALL:DISK_DETECT>NUL 2>&1
CALL SET "DISK_TARGET=%%DISKID_%DISK_NUMBER%%%"&&CALL ECHO.Assigning new disk uid %%DISKID_%DISK_NUMBER%%%...&&CALL:DISK_DETECT>NUL 2>&1)
SET "UID_XNT="&&FOR /F "DELIMS=" %%G in ('%CMD% /D /U /C ECHO.%DISK_TARGET%^| FIND /V ""') do (CALL SET /A "UID_XNT+=1")
IF NOT "%UID_XNT%"=="36" ECHO.%COLOR2%ERROR:%$$% Disk could not be converted to GPT. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_FINISH
FOR %%a in (DISK_DETECT DISK_NUMBER DISK_TARGET) DO (IF NOT DEFINED %%a ECHO.%COLOR2%ERROR:%$$% Unable to query disk number or uid.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_FINISH)
SET "EFI_LETTER="&&FOR %%G in (Z Y X W V U T S R Q P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" SET "EFI_LETTER=%%G")
SET "PRI_LETTER="&&FOR %%G in (Z Y X W V U T S R Q P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" IF NOT "%%G"=="%EFI_LETTER%" SET "PRI_LETTER=%%G")
SET "TST_LETTER="&&FOR %%G in (Z Y X W V U T S R Q P O N M L K J I H G F E D) DO (IF NOT EXIST "%%G:\" IF NOT "%%G"=="%EFI_LETTER%" IF NOT "%%G"=="%PRI_LETTER%" SET "TST_LETTER=%%G")
ECHO.Creating partitions on disk uid %DISK_TARGET%...&&CALL:PART_CREATE
IF DEFINED ERROR GOTO:BOOT_CLEANUP
ECHO.Mounting temporary vdisk...&&MD "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
FOR %%a in (%PRI_LETTER%: %PRI_LETTER%:\%HOST_FOLDER%) DO (ICACLS "%%a" /deny everyone:^(DE,WA,WDAC^)>NUL 2>&1)
SET "$VDISK_FILE=%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.vhdx"&&SET "VDISK_LTR=ANY"&&SET "VHDX_SIZE=50"&&CALL:VDISK_CREATE>NUL 2>&1
IF EXIST "%CacheFolder%\BOOT.SAV" ECHO.Extracting boot-media. Using boot.sav located in folder...&&COPY /Y "%CacheFolder%\boot.sav" "%PRI_LETTER%:\%HOST_FOLDER%\boot.wim">NUL 2>&1
SET "$IMAGE_X=%PRI_LETTER%:\%HOST_FOLDER%\boot.wim"&&SET "INDEX_WORD=Setup"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
SET "$IMAGE_X=%PRI_LETTER%:\%HOST_FOLDER%\boot.wim"&&SET "INDEX_X=%INDEX_Z%"&&CALL:GET_IMAGEINFO
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&GOTO:BOOT_CLEANUP
ECHO. v%$IMGVER%&&%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%PRI_LETTER%:\%HOST_FOLDER%\boot.wim" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
MOVE /Y "%PRI_LETTER%:\%HOST_FOLDER%\boot.wim" "%PRI_LETTER%:\%HOST_FOLDER%\boot.sav">NUL 2>&1
IF NOT EXIST "%VDISK_LTR%:\Windows" ECHO.%COLOR2%ERROR:%$$% Files created with boot.sav are corrupt. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
MD "%VDISK_LTR%:\$">NUL 2>&1
ECHO.%DISK_TARGET%>"%VDISK_LTR%:\$\HOST_TARGET"
ECHO.%HOST_FOLDER%>"%VDISK_LTR%:\$\HOST_FOLDER"
COPY /Y "%ProgFolder0%\windick.cmd" "%VDISK_LTR%:\$">NUL&COPY /Y "%ProgFolder0%\windick.cmd" "%PRI_LETTER%:\%HOST_FOLDER%">NUL&COPY /Y "%ProgFolder%\windick.ini" "%PRI_LETTER%:\%HOST_FOLDER%">NUL
FOR %%a in (Boot EFI\Boot EFI\Microsoft\Boot) DO (MD %EFI_LETTER%:\%%a>NUL 2>&1)
IF EXIST "%CacheFolder%\boot.sdi" ECHO.Using boot.sdi located in folder, for efi image boot support.&&COPY /Y "%CacheFolder%\boot.sdi" "%EFI_LETTER%:\Boot">NUL
IF NOT EXIST "%CacheFolder%\boot.sdi" COPY /Y "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" "%EFI_LETTER%:\Boot">NUL 2>&1
IF NOT EXIST "%EFI_LETTER%:\Boot\boot.sdi" ECHO.%COLOR2%ERROR:%$$% boot.sdi missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
IF EXIST "%CacheFolder%\bootmgfw.efi" ECHO.Using bootmgfw.efi located in folder, for the efi bootloader.&&COPY /Y "%CacheFolder%\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL
IF NOT EXIST "%CacheFolder%\bootmgfw.efi" COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL 2>&1
IF NOT EXIST "%EFI_LETTER%:\EFI\Boot\bootx64.efi" ECHO.%COLOR2%ERROR:%$$% bootmgfw.efi missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
IF DEFINED PE_WALLPAPER IF EXIST "%CacheFolder%\%PE_WALLPAPER%" (ECHO.Using %PE_WALLPAPER% for the recovery wallpaper.
TAKEOWN /F "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
ICACLS "%VDISK_LTR%:\Windows\System32\setup.bmp" /grant %USERNAME%:F>NUL 2>&1
COPY /Y "%CacheFolder%\%PE_WALLPAPER%" "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1)
IF EXIST "%VDISK_LTR%:\setup.exe" DEL /Q /F "\\?\%VDISK_LTR%:\setup.exe">NUL 2>&1
COPY /Y "%VDISK_LTR%:\Windows\System32\config\ELAM" "%TEMP%\BCD">NUL 2>&1
::ECHO."%%SYSTEMDRIVE%%\$\windick.CMD">"%VDISK_LTR%:\WINDOWS\SYSTEM32\STARTNET.CMD"
(ECHO.[LaunchApp]&&ECHO.AppPath=X:\$\windick.cmd)>"%VDISK_LTR%:\Windows\System32\winpeshl.ini"
SET "VHDX_SLOTZ=%VHDX_SLOT0%"&&SET "VHDX_SLOT0=%VHDX_SLOTX%"&&SET "HOST_X=%HOST_FOLDER%"&&CALL:BCD_CREATE>NUL 2>&1
SET "VHDX_SLOT0=%VHDX_SLOTZ%"&&SET "VHDX_SLOTZ="&&IF NOT EXIST "%EFI_LETTER%:\EFI\Microsoft\Boot\BCD" ECHO.%COLOR2%ERROR:%$$% BCD missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
::%DISM% /IMAGE:"%VDISK_LTR%:" /SET-SCRATCHSPACE:512 >NUL 2>&1
ECHO.Saving boot-media...&&%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%VDISK_LTR%:" /IMAGEFILE:"%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.wim" /COMPRESS:FAST /NAME:"WindowsPE" /CheckIntegrity /Verify /Bootable&ECHO.
SET "$IMAGE_X=%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.wim"&&SET "INDEX_X=1"&&CALL:GET_IMAGEINFO
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&GOTO:BOOT_CLEANUP
SET "GET_BYTES=MB"&&SET "INPUT=%EFI_LETTER%:"&&SET "OUTPUT=EFI_FREE"&&CALL:GET_FREE_SPACE
IF NOT DEFINED ERROR SET "GET_BYTES=MB"&&SET "INPUT=%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.wim"&&SET "OUTPUT=BOOT_X"&&CALL:GET_FILESIZE
IF NOT DEFINED ERROR SET /A "EFI_FREE+=%BOOT_X%"
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% Unable to get file size or free space. Abort.&&GOTO:BOOT_CLEANUP
CALL:GET_SPACE_ENV&&FOR %%a in (EFI_FREE BOOT_X) DO (IF NOT DEFINED %%a SET "%%a=0")
IF %EFI_FREE% LEQ %BOOT_X% ECHO.%COLOR2%ERROR:%$$% File boot.sav %BOOT_X%MB exceeds %EFI_FREE%MB. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
FOR %%a in (0 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP)
IF NOT DEFINED ERROR MOVE /Y "%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.wim" "%EFI_LETTER%:\$.WIM">NUL
:BOOT_CLEANUP
ECHO.Unmounting temporary vdisk...&&SET "$VDISK_FILE=%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.vhdx"&&CALL:VDISK_DETACH>NUL 2>&1
ECHO.Unmounting EFI...&&IF EXIST "%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.vhdx" DEL /Q /F "%PRI_LETTER%:\%HOST_FOLDER%\$TEMP.vhdx">NUL 2>&1
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&SET "LETT_X=%EFI_LETTER%"&&CALL:PART_REMOVE
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=1"&&CALL:PART_EFIX
IF NOT DEFINED ERROR (
IF EXIST "%CacheFolder%\boot.sdi" ECHO.Copying boot.sdi...&&COPY /Y "%CacheFolder%\boot.sdi" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
IF EXIST "%CacheFolder%\bootmgfw.efi" ECHO.Copying bootmgfw.efi...&&COPY /Y "%CacheFolder%\bootmgfw.efi" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
IF DEFINED PE_WALLPAPER IF EXIST "%CacheFolder%\%PE_WALLPAPER%" ECHO.Copying %PE_WALLPAPER%... &&COPY /Y "%CacheFolder%\%PE_WALLPAPER%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (CALL SET "ADDFILE_CHK=%%ADDFILE_%%a%%"&&CALL:ADDFILE_COPY)
IF DEFINED VHDX_SLOTX IF EXIST "%ImageFolder%\%VHDX_SLOTX%" IF EXIST "%PRI_LETTER%:\%HOST_FOLDER%" ECHO.Copying %VHDX_SLOTX%......&&COPY /Y "%ImageFolder%\%VHDX_SLOTX%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1)
CALL SET "VDISK_CHK=%%DISK_%DISK_DETECT%%%"
IF "%VDISK_CHK%"=="VDISK" SET "$LTR=%PRI_LETTER%"&&CALL:DISKMGR_UNMOUNT
:BOOT_FINISH
SET "ADDFILE_CHK="&&SET "VDISK_CHK="&&SET "PATH_TEMP="&&SET "PATH_FILE="&&SET "EFI_LETTER="&&SET "PRI_LETTER="&&SET "TST_LETTER="&&IF "%PROG_MODE%"=="RAMDISK" CALL:HOST_AUTO>NUL 2>&1
CALL:DEL_DISK&&ECHO.&&ECHO.            %@@%BOOT CREATOR END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:ADDFILE_COPY
IF "%ADDFILE_CHK%"=="SELECT" EXIT /B
SET "PATH_TEMP="&&SET "PATH_FILE="&&FOR /F "TOKENS=1-9 DELIMS=\" %%a in ("%ADDFILE_CHK%") DO (
IF "%%a"=="pack" SET "PATH_TEMP=%PackFolder%"&&SET "PATH_FILE=%%b"
IF "%%a"=="list" SET "PATH_TEMP=%ListFolder%"&&SET "PATH_FILE=%%b"
IF "%%a"=="image" SET "PATH_TEMP=%ImageFolder%"&&SET "PATH_FILE=%%b"
IF "%%a"=="cache" SET "PATH_TEMP=%CacheFolder%"&&SET "PATH_FILE=%%b"
IF "%%a"=="main" SET "PATH_TEMP=%ProgFolder%"&&SET "PATH_FILE=%%b")
IF DEFINED PATH_TEMP IF DEFINED PATH_FILE IF EXIST "%PATH_TEMP%\%PATH_FILE%" IF NOT EXIST "%PATH_TEMP%\%PATH_FILE%\*" ECHO.Copying %PATH_FILE%...&&COPY /Y "%PATH_TEMP%\%PATH_FILE%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
EXIT /B
:BCD_MENU
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&IF NOT DEFINED BOOT_TIMEOUT SET "BOOT_TIMEOUT=5"
ECHO.                           %U09% Boot Menu Editor&&ECHO.&&ECHO. Time (%##%T%$$%^) %U14% %@@%%BOOT_TIMEOUT%%$$% seconds
IF NOT DEFINED NEXT_BOOT SET "BOOT_TARGET=GET"&&CALL:BOOT_TOGGLE
IF "%NEXT_BOOT%"=="RECOVERY" ECHO. Slot (%##%*%$$%) %U06% %@@%Recovery%$$%
FOR %%G in (0) DO (IF DEFINED VHDX_SLOT%%G IF NOT "%VHDX_SLOT0%"=="SELECT" CALL ECHO. Slot ^(%##%%%G%$$%^) %U06% %@@%%%VHDX_SLOT%%G%%%$$%)
FOR %%G in (1 2 3 4 5) DO (CALL ECHO. Slot ^(%##%%%G%$$%^) %U06% %@@%%%VHDX_SLOT%%G%%%$$%)
FOR %%G in (6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25) DO (IF DEFINED VHDX_SLOT%%G CALL ECHO. Slot ^(%##%%%G%$$%^) %U06% %@@%%%VHDX_SLOT%%G%%%$$%)
IF "%NEXT_BOOT%"=="VHDX" ECHO. Slot (%##%*%$$%) %@@%Recovery%$$%
ECHO.&&ECHO.                Press (%##%X%$$%) to apply boot menu settings&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
IF "%SELECT%"=="T" CALL:BOOT_TIMEOUT&SET "SELECT="
IF "%SELECT%"=="*" IF "%NEXT_BOOT%"=="RECOVERY" SET "NEXT_BOOT=VHDX"&&SET "SELECT="
IF "%SELECT%"=="*" IF "%NEXT_BOOT%"=="VHDX" SET "NEXT_BOOT=RECOVERY"&&SET "SELECT="
IF "%SELECT%"=="X" IF "%PROG_MODE%"=="RAMDISK" CALL:BCD_REBUILD&SET "$HEADERS=                           %U09% Boot Menu Editor%U01% %U01% %U01% %U01% %U01%            Selected options have been applied to boot menu%U01% %U01% %U01% "&&SET "$SELECT=SELECTX1"&&SET "$CHECK=NONE"&&CALL:PROMPT_BOX&SET "SELECT="
FOR %%G in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 20 21 22 23 24 25) DO (IF "%SELECT%"=="%%G" SET "$VHDX=%%G"&&CALL:VHDX_CHECK&SET "SELECT=")
GOTO:BCD_MENU
:BOOT_TIMEOUT
SET "$HEADERS=                           %U09% Boot Menu Editor%U01% %U01%                  Enter boot menu timeout in seconds"&&SET "$CHECK=NUMBER❗1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR IF NOT "%SELECT%"=="0" SET "BOOT_TIMEOUT=%SELECT%"
IF DEFINED ERROR SET "BOOT_TIMEOUT="
EXIT /B
:VHDX_CHECK
IF "%$VHDX%"=="X" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             Boot Creator&&ECHO.&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) File Operation&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHOICEMINO=1"&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF "%$VHDX%"=="X" IF "%SELECT%"=="0" SET "FILE_TYPE=VHDX"&&CALL:BASIC_FILE&SET "ERROR=NONE"&&CALL:DEBUG&EXIT /B
IF NOT "%$VHDX%"=="X" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                           Boot Menu Editor&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) File Operation&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHOICEMINO=1"&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF NOT "%$VHDX%"=="X" IF "%SELECT%"=="0" SET "FILE_TYPE=MAIN"&&CALL:BASIC_FILE&SET "ERROR=NONE"&&CALL:DEBUG&EXIT /B
IF NOT DEFINED $PICK SET "VHDX_SLOT%$VHDX%="&&SET "$VHDX="&&EXIT /B
SET "CHAR_STR=%$CHOICE%"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK
IF DEFINED CHAR_FLG ECHO.&&ECHO.%COLOR4%ERROR:%$$% Remove the space from the VHDX name, then try again.&&ECHO.&&SET "VHDX_SLOT%$VHDX%="&&CALL:PAUSED
IF NOT DEFINED CHAR_FLG SET "VHDX_SLOT%$VHDX%=%$CHOICE%"
SET "$VHDX="
EXIT /B
:BOOT_TOGGLE
CALL:GET_NEXTBOOT
IF NOT DEFINED BOOT_OK EXIT /B
IF NOT "%BOOT_TARGET%"=="VHDX" IF NOT "%BOOT_TARGET%"=="RECOVERY" EXIT /B
IF "%BOOT_TARGET%"=="VHDX" SET "NEXT_BOOT=VHDX"&&%BCDEDIT% /displayorder %GUID_TMP% /addlast>NUL 2>&1
IF "%BOOT_TARGET%"=="RECOVERY" SET "NEXT_BOOT=RECOVERY"&&%BCDEDIT% /displayorder %GUID_TMP% /addfirst>NUL 2>&1
CALL:GET_NEXTBOOT&&SET "BOOT_TARGET="
EXIT /B
:BCD_CREATE
IF NOT DEFINED BOOT_TIMEOUT SET "BOOT_TIMEOUT=5"
SET "BCD_KEY=BCD00000001"&&SET "BCD_FILE=%TEMP%\$BCD"
FOR %%a in (BCD BCD1 $BCD) DO (IF EXIST "%TEMP%\%%a" DEL /Q /F "%TEMP%\%%a" >NUL)
%BCDEDIT% /createstore "%BCD_FILE%"
%BCDEDIT% /STORE "%BCD_FILE%" /create {bootmgr}
%BCDEDIT% /STORE "%BCD_FILE%" /SET {bootmgr} description "Boot Manager"
%BCDEDIT% /STORE "%BCD_FILE%" /SET {bootmgr} device boot
%BCDEDIT% /STORE "%BCD_FILE%" /SET {bootmgr} timeout %BOOT_TIMEOUT%
FOR /f "TOKENS=2 DELIMS={}" %%a in ('%BCDEDIT% /STORE "%BCD_FILE%" /create /device') do SET "RAMDISK={%%a}"
%BCDEDIT% /STORE "%BCD_FILE%" /SET %RAMDISK% ramdisksdidevice boot
%BCDEDIT% /STORE "%BCD_FILE%" /SET %RAMDISK% ramdisksdipath \boot\boot.sdi
FOR /f "TOKENS=2 DELIMS={}" %%a in ('%BCDEDIT% /STORE "%BCD_FILE%" /create /application osloader') do SET "BCD_GUID={%%a}"
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% systemroot \Windows
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% detecthal Yes
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% winpe Yes
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% osdevice ramdisk=[boot]\$.WIM,%RAMDISK%
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% device ramdisk=[boot]\$.WIM,%RAMDISK%
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% path \windows\system32\winload.efi
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% description "Recovery"
%BCDEDIT% /STORE "%BCD_FILE%" /displayorder %BCD_GUID% /addlast
FOR %%a in (25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0) DO (CALL SET "BCD_NAME=%%VHDX_SLOT%%a%%"&&CALL:BCD_VHDX)
%REG% UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
%REG% LOAD HKLM\%BCD_KEY% "%TEMP%\$BCD">NUL 2>&1
%REG% EXPORT HKLM\%BCD_KEY% "%TEMP%\BCD1"
%REG% UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
SET "BCD_FILE=%TEMP%\BCD"&&IF NOT EXIST "%TEMP%\BCD" COPY /Y "%WINDIR%\System32\config\ELAM" "%TEMP%\BCD">NUL 2>&1
%REG% LOAD HKLM\%BCD_KEY% "%BCD_FILE%">NUL 2>&1
%REG% IMPORT "%TEMP%\BCD1" >NUL 2>&1
%REG% add "HKLM\%BCD_KEY%\Description" /v "KeyName" /t REG_SZ /d "%BCD_KEY%" /f>NUL 2>&1
%REG% add "HKLM\%BCD_KEY%\Description" /v "System" /t REG_DWORD /d "1" /f>NUL 2>&1
%REG% add "HKLM\%BCD_KEY%\Description" /v "TreatAsSystem" /t REG_DWORD /d "1" /f>NUL 2>&1
%REG% delete "HKLM\%BCD_KEY%" /v "FirmwareModified" /f>NUL 2>&1
%REG% UNLOAD HKLM\%BCD_KEY%>NUL 2>&1
IF EXIST "%BCD_FILE%" COPY /Y "%BCD_FILE%" "%EFI_LETTER%:\EFI\Microsoft\Boot\BCD">NUL 2>&1
FOR %%a in (BCD BCD1 $BCD) DO (IF EXIST "%TEMP%\%%a" DEL /Q /F "%TEMP%\%%a" >NUL)
SET "BCD_GUID="&&SET "BCD_FILE="&&SET "BCD_KEY="&&SET "BCD_NAME="&&EXIT /B
:BCD_VHDX
IF NOT DEFINED BCD_NAME EXIT /B
IF "%BCD_NAME%"=="SELECT" EXIT /B
FOR /f "TOKENS=3" %%a in ('%BCDEDIT% /STORE "%BCD_FILE%" /create /application osloader') do SET "BCD_GUID=%%a"
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% device vhd=[locate]\%HOST_X%\%BCD_NAME%
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% path \Windows\SYSTEM32\winload.efi
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% osdevice vhd=[locate]\%HOST_X%\%BCD_NAME%
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% systemroot \Windows
%BCDEDIT% /STORE "%BCD_FILE%" /SET %BCD_GUID% description "%BCD_NAME%"
%BCDEDIT% /STORE "%BCD_FILE%" /displayorder %BCD_GUID% /addfirst
EXIT /B
:BCD_REBUILD
ECHO.Rebuilding BCD store, saving boot menu...&&CALL:EFI_MOUNT
IF NOT DEFINED ERROR SET "HOST_X=%HOST_FOLDERX%"&&CALL:BCD_CREATE>NUL 2>&1
CALL:EFI_UNMOUNT&SET "BOOT_TARGET=%NEXT_BOOT%"&&CALL:BOOT_TOGGLE
EXIT /B
:QUIT
IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="ENABLED" CALL:HOST_HIDE
COLOR&&TITLE C:\Windows\system32\%CMD%&&CD /D "%ORIG_CD%"
IF "%PROG_MODE%"=="RAMDISK" EXIT 0&&EXIT 0
GOTO:END_OF_FILE
#>▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶GUISTART◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS
Add-Type -MemberDefinition @"
[DllImport("kernel32.dll", SetLastError = true)] public static extern IntPtr GetStdHandle(int nStdHandle);
[StructLayout(LayoutKind.Sequential)] public struct COORD {public short X;public short Y;}
public const int STD_OUTPUT_HANDLE = -11;
[DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr handle);
[DllImport("Kernel32.dll")] public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")] public static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);
[DllImport("user32.dll")] public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);
[DllImport("user32.dll")] public static extern bool GetParent(IntPtr hWndChild);
[DllImport("user32.dll")] public static extern bool SetParent(IntPtr hWndChild, IntPtr hWndNewParent);
[DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
[DllImport("user32.dll")] public static extern bool DestroyWindow(IntPtr hWnd);
[DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
"@ -Name "Functions" -Namespace "WinMekanix" -PassThru | Out-Null
Add-Type -TypeDefinition @"
using System;using System.Runtime.InteropServices;public class WinMekanix {
    private const int STD_OUTPUT_HANDLE = -11;
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)] public struct CONSOLE_FONT_INFO_EX
    {public uint cbSize;public uint nFont;public COORD dwFontSize;public int FontFamily;public int FontWeight;[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]public string FaceName;}
    [StructLayout(LayoutKind.Sequential)] public struct COORD
    {public short X;public short Y;}
    [DllImport("kernel32.dll", SetLastError = true)] public static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport("kernel32.dll", SetLastError = true)] public static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
    [DllImport("kernel32.dll", SetLastError = true)] public static extern bool GetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
    public static bool SetConsoleFont(string fontName, short fontSize)
    {IntPtr consoleOutputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
        if (consoleOutputHandle == IntPtr.Zero)
        {return false;}
        CONSOLE_FONT_INFO_EX fontInfo = new CONSOLE_FONT_INFO_EX();
        fontInfo.cbSize = (uint)Marshal.SizeOf(fontInfo);GetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);fontInfo.dwFontSize.X = 0;fontInfo.dwFontSize.Y = fontSize;fontInfo.FaceName = fontName;return SetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);} }
"@
$PSScriptRootX = "$($PWD.Path)";$ProjectFolder = "$PSScriptRootX\project"
if (Test-Path -Path "$PSScriptRootX\image") {$ImageFolder = "$PSScriptRootX\image"} else {$ImageFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\list") {$ListFolder = "$PSScriptRootX\list"} else {$ListFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\pack") {$PackFolder = "$PSScriptRootX\pack"} else {$PackFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\cache") {$CacheFolder = "$PSScriptRootX\cache"} else {$CacheFolder = "$PSScriptRootX"}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Group-View {$ListItem = ""
if ($partXb -eq "ⓡRoutine1") {$ListItem = "Routine"}
if ($partXb -eq "ⓡArray1") {$ListItem = "Array"}
if ($ListItem -eq "Array") {$global:Array1 = "";$ifX = ""
$stringX1 = $partXc.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$partXc = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$stringX1 = $partXd.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$partXd = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$stringX1 = $partXe.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$partXe = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
if ($partXd) {$if1, $if2, $if3, $if4, $if5, $if6, $if7, $if8, $if9 = $partXd -split "[❗]"}
if ($partXe) {$do1, $do2, $do3, $do4, $do5, $do6, $do7, $do8, $do9 = $partXe -split "[❗]"}
if ($partXc -eq "$if1") {$ArrayX = $do1;$ifX = 1};if ($partXc -eq "$if2") {$ArrayX = $do2;$ifX = 2};if ($partXc -eq "$if3") {$ArrayX = $do3;$ifX = 3};if ($partXc -eq "$if4") {$ArrayX = $do4;$ifX = 4};if ($partXc -eq "$if5") {$ArrayX = $do5;$ifX = 5};if ($partXc -eq "$if6") {$ArrayX = $do6;$ifX = 6};if ($partXc -eq "$if7") {$ArrayX = $do7;$ifX = 7};if ($partXc -eq "$if8") {$ArrayX = $do8;$ifX = 8};if ($partXc -eq "$if9") {$ArrayX = $do9;$ifX = 9}
$global:Array1 = [PSCustomObject]@{
I = "$ifX"
S = "$ArrayX"
$ifX = "$ArrayX"
}
}
if ($ListItem -eq "Routine") {$Routine1 = "";$RoutineX = ""
if ($partXd -eq "Command") {
if ($partXc) {$delims, $command, $columntar, $columnstr = $partXc -split "[❗]"}
$stringX1 = $command.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$command = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$scriptblockX = { cmd.exe /c "@ECHO OFF&FOR /F `"TOKENS=1-9 DELIMS=$delims`" %1 in ('$command') do (echo %1%2%3%4%5%6%7%8%9)" }
$scriptblockZ = [scriptblock]::create($scriptblockX)
$commandX = Invoke-command $scriptblockZ
Foreach ($line in $commandX) {
$Part1g, $Part2g, $Part3g, $Part4g, $Part5g, $Part6g, $Part7g, $Part8g, $Part9g = $line -split "[]"
if ($columntar -eq 1) {if ($Part1g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 2) {if ($Part2g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 3) {if ($Part3g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 4) {if ($Part4g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 5) {if ($Part5g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 6) {if ($Part6g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 7) {if ($Part7g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 8) {if ($Part8g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($columntar -eq 9) {if ($Part9g -eq $columnstr) {
if ($partXe -eq 1) {$RoutineX = $Part1g};if ($partXe -eq 2) {$RoutineX = $Part2g};if ($partXe -eq 3) {$RoutineX = $Part3g};if ($partXe -eq 4) {$RoutineX = $Part4g};if ($partXe -eq 5) {$RoutineX = $Part5g};if ($partXe -eq 6) {$RoutineX = $Part6g};if ($partXe -eq 7) {$RoutineX = $Part7g};if ($partXe -eq 8) {$RoutineX = $Part8g};if ($partXe -eq 9) {$RoutineX = $Part9g}
}}
if ($RoutineX) {
$stringX1 = $RoutineX.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$RoutineX = $ExecutionContext.InvokeCommand.ExpandString($stringX2)}
$global:Routine1 = [PSCustomObject]@{
I = "1"
S = "$RoutineX"
1 = "$RoutineX"
}}}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MOUNT_INT {
$global:HiveUser = "HKEY_CURRENT_USER"
$global:HiveSoftware = "HKEY_LOCAL_MACHINE\SOFTWARE"
$global:HiveSystem = "HKEY_LOCAL_MACHINE\SYSTEM"
$global:DrvTar = "$env:SystemDrive"
$global:WinTar = "$env:SystemDrive\Windows"
$global:UsrTar = "$env:USERPROFILE";#$global:UsrTar = "$HOME"
$global:ApplyTarget = "ONLINE"
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function VDISK_DETACH {
$scriptblockX = { cmd.exe /c "@ECHO OFF&FOR /F `"TOKENS=1-9 DELIMS=$delims`" %1 in ('cmd.exe /c "$PSScriptRootX\windick.cmd" -DISKMGR -UNMOUNT -LETTER "$vdiskltr" -HIVE') do (echo %1%2%3%4%5%6%7%8%9)" }
$scriptblockZ = [scriptblock]::create($scriptblockX)
$commandX = Invoke-command $scriptblockZ
Foreach ($line in $commandX) {$Part1mnt, $Part2mnt = $line -split "[]"}
$global:vdiskltr = ""
MOUNT_INT
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MOUNT_EXT {
$global:HiveUser = "HKEY_USERS\AllUsersX"
$global:HiveSoftware = "HKEY_LOCAL_MACHINE\SoftwareX"
$global:HiveSystem = "HKEY_LOCAL_MACHINE\SystemX"
$global:DrvTar = "$vdiskltr`:"
$global:WinTar = "$vdiskltr`:\Windows"
$global:UsrTar = "$vdiskltr`:\Users\Default"
$global:ApplyTarget = "IMAGE:$vdiskltr`:"
}
function VDISK_ATTACH {
$scriptblockX = { cmd.exe /c "@ECHO OFF&FOR /F `"TOKENS=1-9 DELIMS=$delims`" %1 in ('cmd.exe /c "$PSScriptRootX\windick.cmd" -DISKMGR -MOUNT -VHDX "$REFERENCE" -LETTER ANY -HIVE') do (echo %1%2%3%4%5%6%7%8%9)" }
$scriptblockZ = [scriptblock]::create($scriptblockX)
$commandX = Invoke-command $scriptblockZ
Foreach ($line in $commandX) {$nullX, $global:vdiskltr, $nullY = $line -split "[]"}
MOUNT_EXT
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewPanel {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$C)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object Drawing.Point($XLOC, $YLOC)
$panel.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$panel.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
if ($C) {$panel.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_PAG_COLOR")}
$form.Controls.Add($panel)
return $panel
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewPictureBox {
param([int]$X,[int]$Y,[int]$H,[int]$W)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$pictureBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$pictureDecrypt = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($pictureBase64))
$pictureBox.Image = $pictureDecrypt
$pictureBox.SizeMode = 'StretchImage';#Normal, StretchImage, AutoSize, CenterImage, Zoom
$pictureBox.Visible = $true
$element = $pictureBox;AddElement
return $pictureBox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewTextBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Check)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$textbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$textbox.Text = "$Text"
$textbox.Visible = $true
$textbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$textbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
if ($Check -eq 'NUMBER') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^0-9]")) {$this.Text = "$textXlastNum"} else {$global:textXlastNum = "$textX"}})}
if ($Check -eq 'LETTER') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z]")) {$this.Text = "$textXlastLtr"} else {$global:textXlastLtr = "$textX"}})}
if ($Check -eq 'ALPHA') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z0-9._-]")) {$this.Text = "$textXlastAlp"} else {$global:textXlastAlp = "$textX"}})}
if ($Check -eq 'PATH') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z0-9._\\: -]")) {$this.Text = "$textXlastPath"} else {$global:textXlastPath = "$textX"}})}
if ($Check -eq 'MENU') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z0-9._@#$+=~*-]")) {$this.Text = "$textXlastMenu"} else {$global:textXlastMenu = "$textX"}})}
if ($Check -eq 'MOST') {$textbox.Add_TextChanged({$global:textX = "$($this.Text)"
if (-not ($this.Text -notmatch "[^a-zA-Z0-9._@#$+=~\\:`/(){}%* -]")) {$this.Text = "$textXlastMost"} else {$global:textXlastMost = "$textX"}})}
$element = $textbox;AddElement
#$textbox.Bounds = New-Object System.Drawing.Rectangle($XLOC, $YLOC, $WSIZ, $HSIZ)
#$textX = $textX.Remove($textX.Length -1, 1)
#$textX.Substring(0, $textX.Length -1)
#$textbox.SelectionColor = 'White'
#$textbox.ReadOnly = $true
#$textBox.Multiline = $true
#$textBox.ScrollBars = "Vertical"
#$textBox.Dock = "Fill"
#$textBox.ReadOnly = $true
#$textBox.AppendText = "Option X"
return $textbox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewRichTextBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$richTextBox = New-Object System.Windows.Forms.RichTextBox
$richTextBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$richTextBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$richTextBox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$richTextBox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$richTextBox.Visible = $true
$element = $richTextBox;AddElement
#$richTextBox.Dock = DockStyle.Fill
#$richTextBox.LoadFile("C:\\xyz.rtf")
#$richTextBox.Find("Text")
#$richTextBox.SelectionColor = Color.Red
#$richTextBox.SaveFile("C:\\xyz.rtf")
return $richTextBox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewListView {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Headers,[string]$Text)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$listview = New-Object System.Windows.Forms.ListView
$listview.Location = New-Object Drawing.Point($XLOC, $YLOC)
$listview.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$listview.View = [System.Windows.Forms.View]::Details
$listview.View = "Details";#$listview.View = "List"
$listview.MultiSelect = $false
$listview.HideSelection = $true
if ($GUI_LVFONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_LVFONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_LVFONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$listview.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
if ($Headers) {$listview.HeaderStyle = "$Headers"} else {$listview.HeaderStyle = 'None'}
$listview.Visible = $true
$listview.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$listview.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$element = $listview;AddElement
#$listview.Columns[0].Width = -2
#$listview.Columns[1].Width = -2
#$listview.CheckBoxes = true
#$listview.FullRowSelect = true
#$listview.GridLines = true
#$listview.Sorting = SortOrder.Ascending
#$listview.HeaderStyle = 'Clickable';#NonClickable;#None
#$imageListSmall = New-Object System.Windows.Forms.ImageList
#$listview.SmallImageList = $imageListSmall
#$ListViewSelect = $listView.SelectedItems
#$ListViewFocused = $listView.FocusedItem
return $listview
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewLabel {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Bold,[string]$LabelFont,[string]$TextSize,[string]$TextAlign,[string]$Text)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$label = New-Object Windows.Forms.Label
$label.Location = New-Object Drawing.Point($XLOC, $YLOC)
$label.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$label.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$fontX = [int]($GUI_SCALE / $DpiCur * $TextSize * $ScaleRef);$fontX = [Math]::Floor($fontX);
if ($Bold -eq 'True') {$FontStyle = 'Bold';$LabelFont = 'Consolas'} else {$FontStyle = 'Regular'}
if ($TextSize) {$label.Font = New-Object System.Drawing.Font("$LabelFont", $fontX,[System.Drawing.FontStyle]::$FontStyle)}
$label.AutoSize = $true
if ($TextAlign) {$label.AutoSize = $false
$label.Dock = "None";#None, Top, Bottom, Left, Right, Fill
#$label.TextAlign = "CenterScreen";#MiddleCenter, TopLeft, CenterScreen, Center, Fill"
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter}
$label.Text = "$Text"
$element = $label;AddElement
return $label
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MessageBox {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxChoices,[string]$MessageBoxText,[string]$Check,[string]$TextMin,[string]$TextMax)
if ($MessageBoxType -eq 'Choice') {if ($MessageBoxChoices) {$parta, $partb, $partc, $partd, $parte, $partf, $partg, $parth, $parti, $partj, $partk, $partl, $partm, $partn, $parto = $MessageBoxChoices -split '[❗]'}}

#if ($MessageBoxType -eq 'Picker') {if ($MessageBoxChoices) {$parta1X, $partb1X, $partc1X = $MessageBoxChoices -split '[*]';$parta1 = $parta1X -replace "`"|'", "";$partb1 = $partb1X -replace "`"|'", ""}};#`"
$formbox = New-Object System.Windows.Forms.Form
$formbox.SuspendLayout()
$WSIZ = [int](500 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](250 * $ScaleRef * $GUI_SCALE)
$formbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$formbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formbox.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$formbox.StartPosition = "CenterScreen"
$formbox.FormBorderStyle = 'FixedDialog'
$formbox.AutoSizeMode = 'GrowAndShrink'
$formbox.WindowState = 'Normal'
$formbox.MaximizeBox = $false
$formbox.MinimizeBox = $true
$formbox.ControlBox = $False
$formbox.AutoScale = $true
$formbox.AutoSize = $true
#$formbox.MdiParent = $form
if ($MessageBoxTitle) {$formbox.Text = "$MessageBoxTitle"}
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formbox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](140 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
$labelbox.Text = "$MessageBoxText"
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.DialogResult = "OK"
$okButton.Enabled = $true
$okButton.Cursor = 'Hand'
$okButton.Text = "OK"
if ($MessageBoxType -eq 'YesNo') {
$XLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Text = "Yes"
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$cancelButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$cancelButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$cancelButton.Add_MouseEnter({$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$cancelButton.Add_MouseLeave({$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$cancelButton.DialogResult = "CANCEL"
$cancelButton.Cursor = 'Hand'
$cancelButton.Text = "No"
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($cancelButton)
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Info') {
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Prompt') {
$WSIZ = [int](430 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](40 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](135 * $ScaleRef * $GUI_SCALE)
$inputbox = New-Object System.Windows.Forms.TextBox
$inputbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$inputbox.Size = New-Object System.Drawing.Size($WSIZ,$HSIZ)
$inputbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$inputbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$global:textX = "";$global:textXlast = "$textX"
$inputbox.Add_TextChanged({$global:textX = "$($this.Text)";$revert = $false;$okEnable = $true
ForEach ($i in @("NUMBER","LETTER","ALPHA","PATH","MENU","MOST")) {if ($Check -eq "$i") {#"[](){}<>!@#$%^&*|;:,.?_~=+-/``\\[]"
if ($Check -eq 'NUMBER') {$allowed = "0-9"}
if ($Check -eq 'LETTER') {$allowed = "a-zA-Z"}
if ($Check -eq 'ALPHA') {$allowed = "a-zA-Z0-9._-"}
if ($Check -eq 'PATH') {$allowed = "a-zA-Z0-9._\\: -"}
if ($Check -eq 'MENU') {$allowed = "a-zA-Z0-9._@#$+=~*-"}
if ($Check -eq 'MOST') {$allowed = "a-zA-Z0-9._@#$+=~\\:`/(){}%* -"}
if ($Check -eq 'NUMBER') {$inputboxX = [int]($($inputbox.Text));$this.Text = $inputboxX
if ($TextMin) {if ($inputboxX -lt $TextMin) {$okEnable = $false}
if ($TextMax) {if ($inputboxX -gt $TextMax) {$revert = $true}}}}
if ($Check -ne 'NUMBER') {
if ($TextMin) {if ($inputbox.Text.Length -lt $TextMin) {$okEnable = $false}
if ($TextMax) {if ($inputbox.Text.Length -gt $TextMax) {$revert = $true}}}}
if (-not ($this.Text -notmatch "[^$allowed]")) {$revert = $true}}}
if (-not ($inputbox.Text.Length -gt 0)) {$okEnable = $false}
if ($okEnable -eq $true) {$okButton.Enabled = $true} else {$okButton.Enabled = $false}
if ($revert -eq $true) {$this.Text = "$textXlast"} else {$global:textXlast = "$textX"}
})
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Add_Click({$null})
$okButton.Enabled = $false
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($inputbox)
$formbox.Controls.Add($okButton)
$formbox.Controls.Add($cancelButton)}
if ($MessageBoxType -eq 'Choice') {
$WSIZ = [int](430 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](40 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](135 * $ScaleRef * $GUI_SCALE)
$dropbox = New-Object System.Windows.Forms.ComboBox
$dropbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$dropbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$dropbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$dropbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
ForEach ($i in @("$parta","$partb","$partc","$partd","$parte","$partf","$partg","$parth","$parti","$partj","$partk","$partl","$partm","$partn","$parto","$partp","$partq","$partr","$parts","$partt","$partu","$partv","$partw","$partx","$party","$partz")) {if ($i) {$dropbox.Items.Add($i)}}
$dropbox.Add_SelectedIndexChanged({$null})
$dropbox.DisplayMember = "$DisplayMember"
$dropbox.DropDownStyle = 'DropDownList'
$dropbox.FlatStyle = 'Flat'
$dropbox.Text = "$Text"
$dropbox.SelectedIndex = 0
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($dropbox)
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Picker') {$PartMatch = $null
$WSIZ = [int](430 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](40 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](135 * $ScaleRef * $GUI_SCALE)
$dropbox = New-Object System.Windows.Forms.ComboBox
$dropbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$dropbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$dropbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$dropbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$stringX1 = $MessageBoxChoices.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$MessageBoxChoices = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$partPath, $partExt = $MessageBoxChoices -split '[❗]'
if (Test-Path -Path "$partPath\$partExt") {$FilePath = "$partPath\$partExt"} else {$FilePath = "$PSScriptRootX\*.*"}
Get-ChildItem -Path "$FilePath" -Name | ForEach-Object {[void]$dropbox.Items.Add($_)}
$dropbox.Add_SelectedIndexChanged({$null})
$dropbox.DisplayMember = "$DisplayMember"
$dropbox.DropDownStyle = 'DropDownList'
$dropbox.FlatStyle = 'Flat'
$dropbox.Text = "$Text"
$dropbox.SelectedIndex = 0
$XLOC = [int](340 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](200 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($dropbox)
$formbox.Controls.Add($okButton)}
$formbox.Controls.Add($labelbox)
$formbox.ResumeLayout();$global:boxresult = $formbox.ShowDialog()
$global:boxoutput = $null;$global:boxindex = $null;
if ($MessageBoxType -eq 'Prompt') {if ($inputbox.Text) {$global:boxoutput = $inputbox.Text} else {$global:boxresult = $null}}
if ($MessageBoxType -eq 'Choice') {if ($dropbox.SelectedItem) {$global:boxoutput = $dropbox.SelectedItem;$boxindexX = $dropbox.SelectedIndex;$global:boxindex = $boxindexX + 1} else {$global:boxresult = $null}}
if ($MessageBoxType -eq 'Picker') {if ($dropbox.SelectedItem) {$global:boxoutput = $dropbox.SelectedItem;$boxindexX = $dropbox.SelectedIndex;$global:boxindex = $boxindexX + 1} else {$global:boxresult = $null}}
$formbox.Dispose()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MessageBoxAbout {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxText)
$formbox = New-Object System.Windows.Forms.Form
$formbox.SuspendLayout()
$WSIZ = [int](600 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](450 * $ScaleRef * $GUI_SCALE)
$formbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($MessageBoxTitle) {$formbox.Text = "$MessageBoxTitle"}
$formbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formbox.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formbox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$formbox.StartPosition = "CenterScreen"
$formbox.FormBorderStyle = 'FixedDialog'
$formbox.AutoSizeMode = 'GrowAndShrink'
$formbox.FormBorderStyle = 'FixedDialog';#FixedDialog, FixedSingle, Fixed3D
$formbox.MaximizeBox = $false
$formbox.MinimizeBox = $true
$formbox.ControlBox = $False
$formbox.AutoScale = $true
$formbox.WindowState = 'Normal'
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](225 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](375 * $ScaleRef * $GUI_SCALE)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.DialogResult = "OK"
$okButton.Cursor = 'Hand'
$okButton.Text = "OK"
$WSIZ = [int](600 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](110 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0)
$YLOC = [int](290 * $ScaleRef * $GUI_SCALE)
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelbox.Text = "For documentation visit github.com/joshuacline"
$Page = 'x';$pictureBase64 = $logojpgB64;$PictureBox1_PageSP = NewPictureBox -X '15' -Y '15' -W '565' -H '300';$formbox.Controls.Add($PictureBox1_PageSP);
$pictureBase64 = $logo2;$PictureBox2_PageSP = NewPictureBox -X '255' -Y '200' -W '20' -H '20';$formbox.Controls.Add($PictureBox2_PageSP);$PictureBox2_PageSP.BringToFront()
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($okButton)
$formbox.Controls.Add($labelbox)
$formbox.ResumeLayout()
$formbox.ShowDialog()
$formbox.Dispose()
}
function MessageBoxListView {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxText)
$formboxX = New-Object System.Windows.Forms.Form
$formboxX.SuspendLayout()
$WSIZ = [int](700 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](450 * $ScaleRef * $GUI_SCALE)
$formboxX.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($MessageBoxTitle) {$formboxX.Text = "$MessageBoxTitle"}
$formboxX.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formboxX.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formboxX.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formboxX.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$formboxX.StartPosition = "CenterScreen"
$formboxX.FormBorderStyle = 'FixedDialog'
$formboxX.AutoSizeMode = 'GrowAndShrink'
$formboxX.FormBorderStyle = 'FixedDialog';#FixedDialog, FixedSingle, Fixed3D
$formboxX.MaximizeBox = $false
$formboxX.MinimizeBox = $true
$formboxX.ControlBox = $False
$formboxX.AutoScale = $true
$formboxX.WindowState = 'Normal'
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](285 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](375 * $ScaleRef * $GUI_SCALE)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.Add_Click({
$global:checkedItemsX = $ListViewBox.CheckedItems | ForEach-Object {$ListWriteX = 0
$partaa, $ListViewCheckedX, $partcc = $_ -split '[{}]'
Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partYa, $partYb, $partYc, $partYd, $partYe, $partYf, $partYg, $partYh, $partYi, $partYj, $partYk, $partYl, $partYm, $partYn = $_ -split "[❕]"
if ($partYc -eq $ListViewCheckedX) {Add-Content -Path "$ListFolder\`$LIST" -Value "$_" -Encoding UTF8;}}}})
$okButton.DialogResult = "OK"
$okButton.Cursor = 'Hand'
$okButton.Text = "OK"
$WSIZ = [int](645 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](325 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$ListViewBox = New-Object System.Windows.Forms.ListView
$ListViewBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$ListViewBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$listview.View = [System.Windows.Forms.View]::Details
$ListViewBox.View = "Details";#$listview.View = "List"
$ListViewBox.MultiSelect = $false
$ListViewBox.HideSelection = $true
if ($GUI_LVFONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_LVFONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_LVFONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$ListViewBox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
if ($Headers) {$ListViewBox.HeaderStyle = "$Headers"} else {$ListViewBox.HeaderStyle = 'None'}
$ListViewBox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$ListViewBox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$ListViewBox.Visible = $true
$WSIZ = [int](542 * $ScaleRef * $GUI_SCALE);[void]$ListViewBox.Columns.Add("X", $WSIZ);$formboxX.Controls.Add($ListViewBox)
$ListViewBox.GridLines = $false;$ListViewBox.CheckBoxes = $true;$ListViewBox.FullRowSelect = $true
$wtfbbq = Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partZa, $partZb, $partZc, $partZd, $partZe, $partZf, $partZg, $partZh, $partZi, $partZj, $partZk, $partZl, $partZm, $partZn = $_ -split "[❕]"
if ($partZb -eq 'GROUP') {if ($partZc -ne $ListViewChoiceS3) {$gogogo = 0}}
if ($partZb -eq 'GROUP') {if ($partZd -ne $ListViewChecked) {$gogogo = 0}}
if ($partZb -eq 'GROUP') {if ($partZc -eq $ListViewChoiceS3) {if ($partZd -eq $ListViewChecked) {$gogogo = 1}}}
if ($gogogo -eq 1) {
if ($partZb -ne 'GROUP') {if ($_ -ne "") {[void]$ListViewBox.Items.Add("$partZc")}}}}
$formboxX.AcceptButton = $okButton
$formboxX.Controls.Add($okButton)
#$formboxX.Controls.Add($labelbox)
$formboxX.ResumeLayout()
$formboxX.ShowDialog()
$formboxX.Dispose()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function GetTextInfo {
param ([Parameter(Mandatory=$true)]
[string]$TextFile)
$stream = [System.IO.File]::OpenRead($TextFile)
$bytes = New-Object byte[] 3
$readBytes = $stream.Read($bytes, 0, 3)
if ($readBytes -eq 3) {return ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)}
$stream.Close();$stream.Dispose()
return $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickFolder {
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowserDialog.RootFolder = 'Desktop'
#$FolderBrowserDialog.InitialDirectory = "$Pick"
$FolderBrowserDialog.ShowNewFolderButton = $true
$FolderBrowserDialog.Description = 'Description'
$FolderBrowserDialog.ShowDialog() | Out-Null
$Pick = $FolderBrowserDialog.FileName
Write-Host "Selected file: $Pick"
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickFolderx {
$shell = New-Object -ComObject Shell.Application
$FolderPicker = $shell.BrowseForFolder(0, "Select a folder:", 0, $null)
$Pick = $FolderPicker.Self.Path
Write-Host "Selected folder: $Pick"}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickFile {
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.InitialDirectory = "$FilePath"
$OpenFileDialog.RestoreDirectory = $true
$OpenFileDialog.Filter = $FileFilt
$OpenFileDialog.ShowDialog() | Out-Null
$global:Pick = $OpenFileDialog.FileName
Write-Host "Selected file: $Pick"
#$OpenFileDialog.Filter = "WIM files (*.wim)|*.wim"
#$OpenFileDialog.Filter = "Text files (*.txt;*.zip)|*.txt;*.zip"
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewRadioButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$GroupName)
$radio = New-Object System.Windows.Forms.RadioButton
$radio.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$radio.Text = "$Text"
$radio.Add_CheckedChanged($Add_CheckedChanged)
$radio.AutoSize = $false
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$radio.Location = New-Object Drawing.Point($XLOC, $YLOC)
$radio.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($GroupBoxName -eq 'Group1') {$GroupBox1_PageSC.Controls.Add($radio)}
if ($GroupBoxName -eq 'Group2') {$GroupBox2_PageSC.Controls.Add($radio)}
#$radio.Checked = "$false"
return $radio
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewGroupBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Checked)
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$groupBox.Text = "$Text"
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$groupBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$groupBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$element = $groupBox;AddElement
#$groupBox.Checked = "$false"
return $groupBox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewSlider {
param([int]$X,[int]$Y,[int]$H,[int]$W,[int]$Value)
$slider = New-Object System.Windows.Forms.TrackBar
$slider.Minimum = 50
$slider.Maximum = 150
$slider.TickFrequency = 10
$slider.LargeChange = 10
$slider.SmallChange = 5
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$slider.Width = $WSIZ
$slider.Location = New-Object Drawing.Point($XLOC, $YLOC)
$slider.Value = "$Value"
$slider.Add_MouseWheel({
#$slider.FocusedItem()
$ScrollAmt = $_.Delta / 120;
$SliderValuePlus = $($Slider1_PageSC.Value) + 7
$SliderValueMinus = $($Slider1_PageSC.Value) - 7
if ($ScrollAmt -gt 0) {$Slider1_PageSC.Value = $SliderValuePlus}
if ($ScrollAmt -lt 0) {$Slider1_PageSC.Value = $SliderValueMinus}
if ($Slider1_PageSC.Value -lt $Slider1_PageSC.Minimum) {$Slider1_PageSC.Value = $Slider1_PageSC.Minimum}
if ($Slider1_PageSC.Value -gt $Slider1_PageSC.Maximum) {$Slider1_PageSC.Value = $Slider1_PageSC.Maximum}})
$slider.Add_Scroll({
$ScaleJ = $($Slider1_PageSC.Value) / 100
$LabelX_PageSC.Text = "GUI Scale Factor $($Slider1_PageSC.Value)%"
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
ForEach ($i in @("","GUI_SCALE=$ScaleJ")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
if ($boxresult -eq "OK") {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\windick.cmd";$NoExitPrompt = 1;$form.Close()}
})
#$slider.Add_MouseUp({$null})
#$slider.Add_MouseDown({$null})
#$slider.Add_ValueChanged({$null})
$element = $slider;AddElement
return $slider
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewToggle {
param ([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$toggle = New-Object System.Windows.Forms.CheckBox
$toggle.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$toggle.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$toggle.Text = "$Text"
$toggle.Add_CheckedChanged($Add_CheckedChanged)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$toggle.Location = New-Object Drawing.Point($XLOC, $YLOC)
$toggle.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$element = $toggle;AddElement
return $toggle
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewDropBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[int]$C,[string]$Text,[string]$DisplayMember)
$dropbox = New-Object System.Windows.Forms.ComboBox
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
#$dropbox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::Simple
$dropbox.DropDownStyle = 'DropDownList'#ReadOnly
$dropbox.FlatStyle = 'Flat'# Flat, Popup, System
$dropbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$dropbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$dropbox.DisplayMember = $DisplayMember
$dropbox.Text = "$Text"
$dropbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$dropbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$dropbox.Add_SelectedIndexChanged({
$DropBox1_PageW2V.Tag = 'Disable'
$DropBox2_PageW2V.Tag = 'Disable'
$DropBox1_PageV2W.Tag = 'Disable'
$DropBox2_PageV2W.Tag = 'Disable'
$DropBox3_PageV2W.Tag = 'Disable'
$DropBox1_PageLB.Tag = 'Disable'
$DropBox1_PageBC.Tag = 'Disable'
$DropBox2_PageBC.Tag = 'Disable'
$DropBox3_PageBC.Tag = 'Disable'
$DropBox1_PageSC.Tag = 'Disable'
$DropBox2_PageSC.Tag = 'Disable'
$DropBox3_PageSC.Tag = 'Disable'
$DropBox4_PageSC.Tag = 'Disable'
$DropBox5_PageSC.Tag = 'Disable'
$this.Tag = 'Enable'
if ($DropBox1_PageW2V.Tag -eq 'Enable') {if ($DropBox1_PageW2V.SelectedItem -eq 'Import Installation Media') {ImportWim}
if ($DropBox1_PageW2V.SelectedItem) {if ($DropBox1_PageW2V.SelectedItem -ne 'Import Installation Media') {DropBox1W2V}}}
if ($DropBox2_PageBC.Tag -eq 'Enable') {if ($DropBox2_PageBC.SelectedItem -eq 'Import Wallpaper') {ImportWallpaper}}
if ($DropBox3_PageBC.Tag -eq 'Enable') {if ($DropBox3_PageBC.SelectedItem -eq 'Refresh') {DropBox3BC}}
if ($DropBox1_PageV2W.Tag -eq 'Enable') {DropBox1V2W}
if ($DropBox1_PageSC.Tag -eq 'Enable') {DropBox1SC}
if ($DropBox2_PageSC.Tag -eq 'Enable') {DropBox2SC}
if ($DropBox3_PageSC.Tag -eq 'Enable') {DropBox3SC}
if ($DropBox4_PageSC.Tag -eq 'Enable') {DropBox4SC}
if ($DropBox5_PageSC.Tag -eq 'Enable') {DropBox5SC}
if ($DropBox1_PageLB.Tag -eq 'Enable') {DropBox1LB}
})
$element = $dropbox;AddElement
#$dropbox.IsEditable = $false
#$dropbox.IsReadOnly = $true
#$dropbox.Add_TextChanged({Write-Host "X"})
return $dropbox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Hover_Text,[scriptblock]$Add_Click)
$button = New-Object Windows.Forms.Button
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$button.Location = New-Object Drawing.Point($XLOC, $YLOC)
$button.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$button.Add_Click($Add_Click)
$button.Text = $Text
$button.Cursor = 'Hand'
$button.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$button.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$button.Add_MouseEnter({$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$button.Add_MouseLeave({$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$hovertext = New-Object System.Windows.Forms.ToolTip
$hovertext.SetToolTip($button, $Hover_Text)
#$button.FlatStyle = 'Flat'
#$button.FlatAppearance.BorderSize = '3'
#$paint = $button;$global:shape = 'Rectangle';Add_Paint
#$colorHex1 = [Convert]::ToInt32($GUI_BTN_COLOR.Substring(0, 2), 16);#$colorHex2 = [Convert]::ToInt32($GUI_BTN_COLOR.Substring(2, 2), 16)
$element = $button;AddElement
return $button
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$global:Mswitch = 1;$global:Pswitch = 1
function NewPageButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$button = New-Object Windows.Forms.Button
$button.Location = New-Object Drawing.Point($XLOC, $YLOC)
$button.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$button.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$button.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
#$button.FlatAppearance.BorderSize = '3'
#$button.FlatStyle = 'Flat'
$button.Text = $Text
$button.Cursor = 'Hand'
$button.Add_Click({
$Button_V2W.Tag = 'Disable'
$Button_W2V.Tag = 'Disable'
$Button_LB.Tag = 'Disable'
$Button_PB.Tag = 'Disable'
$Button_BC.Tag = 'Disable'
$Button_SC.Tag = 'Disable'
$Button_SP.Tag = 'Disable'
$this.Tag = 'Enable'
if (-not ($Button_W2V.Tag -eq 'Enable')) {if (-not ($Button_V2W.Tag -eq 'Enable')) {$global:Pswitch = 1}}
if (-not ($Button_LB.Tag -eq 'Enable')) {if (-not ($Button_PB.Tag -eq 'Enable')) {$global:Mswitch = 1}}
if ($Button_W2V.Tag -eq 'Enable') {if ($Pswitch -eq 1) {$Button_W2V.Tag = 'Disable';$Button_V2W.Tag = 'Enable';$global:Pswitch = ""}}
if ($Button_V2W.Tag -eq 'Enable') {if ($Pswitch -eq 1) {$Button_W2V.Tag = 'Enable';$Button_V2W.Tag = 'Disable';$global:Pswitch = ""}}
if ($Button_LB.Tag -eq 'Enable') {if ($Mswitch -eq 1) {$Button_LB.Tag = 'Disable';$Button_PB.Tag = 'Enable';$global:Mswitch = ""}}
if ($Button_PB.Tag -eq 'Enable') {if ($Mswitch -eq 1) {$Button_LB.Tag = 'Enable';$Button_PB.Tag = 'Disable';$global:Mswitch = ""}}
if ($Button_W2V.Tag -eq 'Enable') {Button_PageW2V}
if ($Button_V2W.Tag -eq 'Enable') {Button_PageV2W}
if ($Button_LB.Tag -eq 'Enable') {Button_PageLB}
if ($Button_PB.Tag -eq 'Enable') {Button_PagePB}
if ($Button_BC.Tag -eq 'Enable') {Button_PageBC}
if ($Button_SC.Tag -eq 'Enable') {Button_PageSC}
if ($Button_SP.Tag -eq 'Enable') {Button_PageSP;if ($SplashX -eq 5) {$global:SplashChange = 1};$global:SplashX += 1}
if ($Button_W2V.Tag -ne 'Enable') {$PageW2V.Visible = $false}
if ($Button_V2W.Tag -ne 'Enable') {$PageV2W.Visible = $false}
if ($Button_LB.Tag -ne 'Enable') {$PageLB.Visible = $false}
if ($Button_PB.Tag -ne 'Enable') {$PagePB.Visible = $false}
if ($Button_BC.Tag -ne 'Enable') {$PageBC.Visible = $false}
if ($Button_SC.Tag -ne 'Enable') {$PageSC.Visible = $false}
if ($Button_SP.Tag -ne 'Enable') {$PageSP.Visible = $false;$scrolltimer.Enabled = $false}
$Button_W2V.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_V2W.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_LB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_PB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_BC.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$Button_SC.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
if ($this.Tag -eq 'Enable') {$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_V2W.Tag -eq 'Enable') {$Button_W2V.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_W2V.Tag -eq 'Enable') {$Button_V2W.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_LB.Tag -eq 'Enable') {$Button_PB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_PB.Tag -eq 'Enable') {$Button_LB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
if (Test-Path -Path "$PSScriptRootX\`$TEMP") {Remove-Item -Path "$PSScriptRootX\`$TEMP" -Force}
})
$button.Add_MouseEnter({$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$button.Add_MouseLeave({if ($this.Tag -eq 'Enable') {$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")} else {$this.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")}
if ($Button_V2W.Tag -eq 'Enable') {$Button_W2V.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_W2V.Tag -eq 'Enable') {$Button_V2W.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_LB.Tag -eq 'Enable') {$Button_PB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
if ($Button_PB.Tag -eq 'Enable') {$Button_LB.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")}
})
$PageMain.Controls.Add($button)
return $button
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function SplashChange {
if ($SplashChange) {$NextSplash = Get-Random -Minimum 1 -Maximum 2;
if ($NextSplash -eq 1) {$Label0_PageSP.Text = "The World Is Yours"}}
if (-not ($Label0_PageSP.Text)) {$Label0_PageSP.Text = "Welcome to the Windows Deployment Image Customization Kit Graphical User Interface"}
$ScrollLength = $Label0_PageSP.Text.Length
$global:Label0_PageSPL = ($GUI_SCALE / $DpiCur * -16 * $ScaleRef * $ScrollLength * 3.333);
$global:Label0_PageSPL = [Math]::Floor($Label0_PageSPL)
New-Object System.Drawing.Point($Label0_PageSPX, $Label0_PageSPY)
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Add_Paint {$paint.Add_Paint({param([object]$sender, [System.Windows.Forms.PaintEventArgs]$e);$graphics = $e.Graphics
$pen = New-Object System.Drawing.Pen([System.Drawing.Color]::Red, 10);$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Green);#$graphics.CloseFigure();#$graphics.AddEllipse($WSIZ, $HSIZ, $XLOC, $YLOC);#$graphics.FillRectangle($brush, $rectangle);#$graphics.AddLine($WSIZ, $HSIZ, $XLOC, $YLOC);
if ($shape -eq 'Rectangle') {$drawX = New-Object System.Drawing.Rectangle($XLOC, $YLOC, $WSIZ, $HSIZ);$graphics.DrawRectangle($pen, $drawX)};if ($shape -eq 'Ellipse') {$drawX = New-Object System.Drawing.Ellipse($XLOC, $YLOC, $WSIZ, $HSIZ);$graphics.DrawEllipse($pen, $drawX)};if ($shape -eq 'Line') {$drawX = New-Object System.Drawing.Line($XLOC, $YLOC, $WSIZ, $HSIZ);$graphics.DrawLine($pen, $drawX)}
$pen.Dispose();$brush.Dispose()})
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Get-ChildProcesses ($ParentProcessId) {$filter = "parentprocessid = '$($ParentProcessId)'"
Get-CIMInstance -ClassName win32_process -filter $filter | Foreach-Object {$_
if ($_.ParentProcessId -ne $_.ProcessId) {Get-ChildProcesses $_.ProcessId}}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageW2V {
$global:GUI_RESUME = "ImageProcessingW2V"
if (Test-Path -Path $ImageFolder\$($DropBox1_PageW2V.SelectedItem)) {$null} else {$DropBox1_PageW2V.SelectedItem = $null}
$ListView1_PageW2V.Items.Clear();#$ListView1_PageW2V.Columns[0].Width = -2
$DropBox1_PageW2V.ResetText();$DropBox1_PageW2V.Items.Clear()
$DropBox2_PageW2V.ResetText();$DropBox2_PageW2V.Items.Clear()
Get-ChildItem -Path "$ImageFolder\*.wim" -Name | ForEach-Object {[void]$DropBox1_PageW2V.Items.Add($_)}
Get-ChildItem -Path "$ImageFolder\*.wim" -Name | ForEach-Object {[void]$ListView1_PageW2V.Items.Add($_)}
[void]$DropBox1_PageW2V.Items.Add("Import Installation Media")
if ($($TextBox1_PageW2V.Text)) {$null} else {$TextBox1_PageW2V.Text = 'NewFile.vhdx'}
if ($($TextBox2_PageW2V.Text)) {$null} else {$TextBox2_PageW2V.Text = '25'}
$PageW2V.Visible = $true;$PageW2V.BringToFront();$Button_V2W.Visible = $true;$Button_W2V.Visible = $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageV2W {
$global:GUI_RESUME = "ImageProcessingV2W"
if (Test-Path -Path $ImageFolder\$($DropBox1_PageV2W.SelectedItem)) {$null} else {$DropBox1_PageV2W.SelectedItem = $null}
$ListView1_PageV2W.Items.Clear();#$ListView1_PageW2V.Columns[0].Width = -2
$DropBox1_PageV2W.ResetText();$DropBox1_PageV2W.Items.Clear()
$DropBox2_PageV2W.ResetText();$DropBox2_PageV2W.Items.Clear()
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageV2W.Items.Add($_)}
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageV2W.Items.Add($_)}
if ($($TextBox1_PageV2W.Text)) {$null} else {$TextBox1_PageV2W.Text = 'NewFile.wim'}
if ($($DropBox3_PageV2W.SelectedItem)) {$null} else {$DropBox3_PageV2W.Items.Clear();$DropBox3_PageV2W.Items.Add("Fast");$DropBox3_PageV2W.Items.Add("Max");$DropBox3_PageV2W.SelectedItem = "Fast";}
$PageV2W.Visible = $true;$PageV2W.BringToFront();$Button_W2V.Visible = $true;$Button_V2W.Visible = $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageLB {
$global:GUI_RESUME = "ImageManagementList"
$ListView1_PageLB.Items.Clear();$ListView2_PageLB.Items.Clear()
Get-ChildItem -Path "$ListFolder\*.base" -Name | ForEach-Object {[void]$ListView1_PageLB.Items.Add($_)}
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView2_PageLB.Items.Add($_)}
if ($DropBox1_PageLB.SelectedItem) {$null} else {$DropBox1_PageLB.Items.Clear();[void]$DropBox1_PageLB.Items.Add("🪟 Current Environment");Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
[void]$DropBox1_PageLB.Items.Add("Refresh");$DropBox1_PageLB.SelectedItem = "$REFERENCE";}
if ($REFERENCE -eq "LIVE") {if (-not ($DropBox1_PageLB.SelectedItem -eq "🪟 Current Environment")) {$DropBox1_PageLB.SelectedItem = "🪟 Current Environment";}}
$PageMain.Visible = $true;$PageLEWiz.Visible = $false;$PageLBWiz.Visible = $false;$PageLB.Visible = $true;$PageLB.BringToFront();$Button_PB.Visible = $true;$Button_LB.Visible = $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PagePB {
$global:GUI_RESUME = "ImageManagementPack"
$ListView1_PagePB.Items.Clear();$ListView2_PagePB.Items.Clear()
Get-ChildItem -Path "$PackFolder\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePB.Items.Add($_)}
if (Test-Path -Path $ProjectFolder) {
Get-ChildItem -Path "$ProjectFolder" -Name | ForEach-Object {[void]$ListView2_PagePB.Items.Add($_)}}
$PageMain.Visible = $true;$PagePEWiz.Visible = $false;$PagePBWiz.Visible = $false;$PagePB.Visible = $true;$PagePB.BringToFront();$Button_LB.Visible = $true;$Button_PB.Visible = $false
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageBC {
$global:GUI_RESUME = "BootDiskCreator"
$DropBox3_PageBC.Items.Clear();$DropBox3_PageBC.Items.Add("Refresh");$DropBox3_PageBC.Text = "Select Disk"
if (Test-Path -Path $ImageFolder\$($DropBox1_PageBC.SelectedItem)) {$null} else {$DropBox1_PageBC.SelectedItem = $null}
$ListView1_PageBC.Items.Clear();Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageBC.Items.Add($_)}
$DropBox1_PageBC.ResetText();$DropBox1_PageBC.Items.Clear();$DropBox1_PageBC.Text = "Select .vhdx"
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageBC.Items.Add($_)}
if (Test-Path -Path $CacheFolder\$($DropBox2_PageBC.SelectedItem)) {$null} else {$DropBox2_PageBC.SelectedItem = $null}
$empty = $true;
$DropBox2_PageBC.ResetText();$DropBox2_PageBC.Items.Clear()
Get-ChildItem -Path "$CacheFolder\*.jpg" -Name | ForEach-Object {$empty = $false;[void]$DropBox2_PageBC.Items.Add($_)}
Get-ChildItem -Path "$CacheFolder\*.png" -Name | ForEach-Object {$empty = $false;[void]$DropBox2_PageBC.Items.Add($_)}
[void]$DropBox2_PageBC.Items.Add("Import Wallpaper")
$PageBC.Visible = $true;$PageBC.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageSC {
$global:GUI_RESUME = "Settings"
if ($($DropBox1_PageSC.SelectedItem)) {$null} else {$DropBox1_PageSC.ResetText();$DropBox1_PageSC.Items.Clear();
$key = Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont"
#$key.GetValueNames() | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}
$key.GetValueNames() | ForEach-Object {$key.GetValue($_) | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}}
$DropBox1_PageSC.SelectedItem = "$GUI_CONFONT"}
if ($($DropBox2_PageSC.SelectedItem)) {$null} else {$DropBox2_PageSC.ResetText();$DropBox2_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36','40','44','48','52','56','60','64','68','72')) {[void]$DropBox2_PageSC.Items.Add($i)}
$DropBox2_PageSC.SelectedItem = "$GUI_CONFONTSIZE"}
if ($($DropBox3_PageSC.SelectedItem)) {$null} else {$DropBox3_PageSC.ResetText();$DropBox3_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36')) {[void]$DropBox3_PageSC.Items.Add($i)}
$DropBox3_PageSC.SelectedItem = "$GUI_LVFONTSIZE"}
if ($($DropBox4_PageSC.SelectedItem)) {$null} else {$DropBox4_PageSC.ResetText();$DropBox4_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36')) {[void]$DropBox4_PageSC.Items.Add($i)}
$DropBox4_PageSC.SelectedItem = "$GUI_FONTSIZE"}
if ($($DropBox5_PageSC.SelectedItem)) {$null} else {
$DropBox5_PageSC.ResetText();$DropBox5_PageSC.Items.Clear();
[void]$DropBox5_PageSC.Items.Add("🎨 Theme");[void]$DropBox5_PageSC.Items.Add("Button");[void]$DropBox5_PageSC.Items.Add("Highlight");[void]$DropBox5_PageSC.Items.Add("Text Color");[void]$DropBox5_PageSC.Items.Add("Text Canvas");[void]$DropBox5_PageSC.Items.Add("Side Panel");[void]$DropBox5_PageSC.Items.Add("Background")}
$DropBox5_PageSC.SelectedItem = ""
$PageSC.Visible = $true;$PageSC.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageSP {$scrolltimer.Enabled = $true
$global:GUI_RESUME = "Splash";$PageSP.Visible = $true;$PageSP.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function GUI_Resume {
ForEach ($i in @('ImageProcessingW2V','ImageProcessingV2W','ImageManagementList','ImageManagementPack','BootDiskCreator','Settings','Splash')) {if ($GUI_RESUME -eq "$i") {$GUI_RESUME_PASS = 1}}
if ($GUI_RESUME_PASS) {$null} else {$GUI_RESUME = 'Splash'}
if ($GUI_RESUME -eq 'ImageProcessingW2V') {$Button_W2V.Tag = 'Enable';Button_PageW2V;$global:Pswitch = ""}
if ($GUI_RESUME -eq 'ImageProcessingV2W') {$Button_V2W.Tag = 'Enable';Button_PageV2W;$global:Pswitch = ""}
if ($GUI_RESUME -eq 'ImageManagementList') {$Button_LB.Tag = 'Enable';Button_PageLB;$global:Mswitch = ""}
if ($GUI_RESUME -eq 'ImageManagementPack') {$Button_PB.Tag = 'Enable';Button_PagePB;$global:Mswitch = ""}
if ($GUI_RESUME -eq 'BootDiskCreator') {$Button_BC.Tag = 'Enable';Button_PageBC}
if ($GUI_RESUME -eq 'Settings') {$Button_SC.Tag = 'Enable';Button_PageSC}
if ($GUI_RESUME -eq 'Splash') {$Button_SP.Tag = 'Enable';Button_PageSP}
$ColorFill = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")
if ($Button_W2V.Tag -eq 'Enable') {$Button_V2W.BackColor = $ColorFill}
if ($Button_V2W.Tag -eq 'Enable') {$Button_W2V.BackColor = $ColorFill}
if ($Button_LB.Tag -eq 'Enable') {$Button_PB.BackColor = $ColorFill}
if ($Button_PB.Tag -eq 'Enable') {$Button_LB.BackColor = $ColorFill}
if ($Button_BC.Tag -eq 'Enable') {$Button_BC.BackColor = $ColorFill}
if ($Button_SC.Tag -eq 'Enable') {$Button_SC.BackColor = $ColorFill}
if ($Button_SP.Tag -eq 'Enable') {$Button_SP.BackColor = $ColorFill}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportBoot {
if (Test-Path -Path $CacheFolder\boot.sav) {$result = [System.Windows.Forms.MessageBox]::Show("Boot media already exists.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)} else {
$FilePath = "$CacheFolder";$FileFilt = "ISO files (*.iso)|*.iso";PickFile
if ($Pick) {
$Image = Mount-DiskImage -ImagePath "$Pick" -PassThru
$drvLetter = ($Image | Get-Volume).DriveLetter
if (Test-Path -Path "$drvLetter`:\sources\boot.wim") {
$source = "$drvLetter`:\sources\boot.wim";$target = "$CacheFolder"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Rename-Item -Path "$CacheFolder\boot.wim" -NewName "boot.sav"}
Dismount-DiskImage -DevicePath $Image.DevicePath} else {$null}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportWim {
$FilePath = "$ImageFolder";$FileFilt = "ISO files (*.iso)|*.iso";PickFile
if ($Pick) {
$Image = Mount-DiskImage -ImagePath "$Pick" -PassThru
$drvLetter = ($Image | Get-Volume).DriveLetter
$source = "$drvLetter`:\sources\install.wim";$target = "$FilePath"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Dismount-DiskImage -DevicePath $Image.DevicePath}
Button_PageW2V
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportWallpaper {
$DropBox2_PageBC.SelectedItem = $null
$FilePath = $HOME;$FileFilt = "Picture files (*.jpg;*.png)|*.jpg;*.png";PickFile
if ($Pick) {
$source = "$Pick";$target = "$CacheFolder"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Dismount-DiskImage -DevicePath $Image.DevicePath}
Button_PageBC
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox1LB {
if ($DropBox1LBChanged -eq '1') {
$global:REFERENCE = "$($DropBox1_PageLB.SelectedItem)";if ($REFERENCE -eq "🪟 Current Environment") {$global:REFERENCE = "LIVE"}
if ($REFERENCE -eq "Refresh") {$DropBox1_PageLB.Items.Clear();[void]$DropBox1_PageLB.Items.Add("🪟 Current Environment");Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
[void]$DropBox1_PageLB.Items.Add("Refresh");$DropBox1_PageLB.SelectedItem = "🪟 Current Environment";} else {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "REFERENCE=$REFERENCE" -Encoding UTF8}}
if ($REFERENCE -eq "LIVE") {if (-not ($DropBox1_PageLB.SelectedItem -eq "🪟 Current Environment")) {$DropBox1_PageLB.SelectedItem = "🪟 Current Environment";}}
$global:DropBox1LBChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox3BC {
$ListView1_PageBC.Items.Clear();[void]$ListView1_PageBC.Items.Add("Querying disks...")
$DropBox3_PageBC.Items.Clear();
$disks = Get-Disk | Sort-Object -Property Number
$ListView1_PageBC.Items.Clear();foreach ($disk in $disks) {
#$diskModel = $disk.Model;#$diskID = $disk.UniqueID;#$diskSerialNumber = $disk.SerialNumber
$diskNumber = $disk.Number;$diskSize = $disk.Size / 1073741824;$diskSize = [Math]::Floor($diskSize)
if (Test-Path -Path "$PSScriptRootX\`$DISK") {Remove-Item -Path "$PSScriptRootX\`$DISK" -Force}
Add-Content -Path "$PSScriptRootX\`$DISK" -Value "select disk $diskNumber" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$DISK" -Value "detail disk" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$DISK" -Value "exit" -Encoding UTF8
$diskpart = DISKPART /S "$PSScriptRootX\`$DISK";Remove-Item -Path "$PSScriptRootX\`$DISK" -Force
$ltr = $null;$vols = $null;$pagefile = 0;$sysdrive = 0;$progdrive = 0;$diskreason = $null;
Foreach ($line in $diskpart) {$parta, $partb, $partc, $partd, $parte, $partf, $partg, $parth, $parti, $partj, $partk, $partl, $partm, $partn = $line -split '[{}:. 	 ]'
if ($start -eq 'y') {$name = $line;$start = $null};if ($start -eq 'x') {$start = 'y'};if ($partg -eq 'disk') {$start = 'x'}
if ($parta -eq 'Disk') {if ($partb -eq 'ID') {if ($parte) {$diskid = $parte} else {$diskid = $partd}}}
if ($parta -eq 'Pagefile') {if ($partb -eq 'Disk') {if ($partf -eq 'Yes') {$pagefile = 1}}}
if ($partc -eq 'Volume') {if (-not ($partd -eq '###')) {
if ($parti -eq '') {$vols = "*, $vols"};if ($parti -eq $null) {$vols = "*, $vols"}
if ($parti -ne $null) {if ($parti -ne '') {$vols = "$parti, $vols"}}
if ($parti -eq "$sysltr") {$sysdrive = 1}
if ($parti -eq "$progltr") {$progdrive = 1}
}}}
if ($pagefile -eq '1') {$diskreason = "$diskreason PageFile"}
if ($sysdrive -eq '1') {$diskreason = "$diskreason SysDrive"}
if ($progdrive -eq '1') {$diskreason = "$diskreason ProgDrive"}
if ($diskreason) {$diskreason = "`|$diskreason"} else {[void]$DropBox3_PageBC.Items.Add("Disk $diskNumber `| $name `| $vols`| $diskSize GB")}
[void]$ListView1_PageBC.Items.Add("Disk $diskNumber `| $name `| $vols`| $diskSize GB $diskreason")}
[void]$DropBox3_PageBC.Items.Add("Refresh");}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox1W2V {
if ($DropBox1_PageW2V.SelectedItem) {if ($DropBox1_PageW2V.SelectedItem -ne 'Import Installation Media') {
$DropBox2_PageW2V.Items.Clear()
$ListView1_PageW2V.Items.Clear()
$command = DISM.EXE /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"$ImageFolder\$($DropBox1_PageW2V.SelectedItem)"
Foreach ($line in $command) {
if ($line -match "Index :") {
[void]$ListView1_PageW2V.Items.Add($line)
$parts = $line.Split(":", 9)
$column2 = $parts[1].Trim()
[void]$DropBox2_PageW2V.Items.Add($column2)}
if ($line -match "Name :") {
$parts = $line.Split(":", 9)
$column1 = $parts[0].Trim()
$column2 = $parts[1].Trim()
#$item = New-Object System.Windows.Forms.ListViewItem
#$item.Text = $file.Name
#[void]$item.SubItems.Add($file.Length)
#[void]$item.SubItems.Add($file.Extension)
#[void]$listView.Items.Add($item)
[void]$ListView1_PageW2V.Items.Add($column2)
}}
if ($column2) {$null} else {[void]$DropBox2_PageW2V.Items.Add("1");[void]$ListView1_PageW2V.Items.Add("Index : 1");[void]$ListView1_PageW2V.Items.Add("<no information>")}
$DropBox2_PageW2V.SelectedItem = "1"
}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox1V2W {
$DropBox2_PageV2W.Items.Clear()
$ListView1_PageV2W.Items.Clear();#$DropBox2_PageV2W.Text = '1'
$command = DISM.EXE /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"$ImageFolder\$($DropBox1_PageV2W.SelectedItem)" /INDEX:1
Foreach ($line in $command) {
if ($line -match "Index :") {
[void]$ListView1_PageV2W.Items.Add($line)
$parts = $line.Split(":", 9)
$column2 = $parts[1].Trim()
[void]$DropBox2_PageV2W.Items.Add($column2)}
if ($line -match "Name :") {
$parts = $line.Split(":", 9)
$column1 = $parts[0].Trim()
$column2 = $parts[1].Trim()
[void]$ListView1_PageV2W.Items.Add($column2)
}}
if ($column2) {$null} else {[void]$DropBox2_PageV2W.Items.Add("1");[void]$ListView1_PageV2W.Items.Add("Index : 1");[void]$ListView1_PageV2W.Items.Add("<no information>")}
$DropBox2_PageV2W.SelectedItem = "1"
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox1SC {
if ($DropBox1SCChanged -eq '1') {
$global:GUI_CONFONT = "$($DropBox1_PageSC.SelectedItem)";[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_CONFONT=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8}
$global:DropBox1SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox2SC {
if ($DropBox2SCChanged -eq '1') {
$global:GUI_CONFONTSIZE = "$($DropBox2_PageSC.SelectedItem)"
if ($GUI_CONFONTSIZE -eq 'Auto') {$global:CFSIZE0 = 28} else {$global:CFSIZE0 = $GUI_CONFONTSIZE}
#$ScaleFont = $CFSIZE0 * $ScaleRef * $GUI_SCALE
$ScaleFont = $GUI_SCALE / $DpiCur * $CFSIZE0 * $ScaleRef
$ScaleFontX = [Math]::Floor($ScaleFont);$global:CFSIZEX = $ScaleFontX
[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_CONFONTSIZE=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8}
$global:DropBox2SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox3SC {
#$global:GUI_LVFONTSIZE = "$($DropBox3_PageSC.SelectedItem)"
if ($DropBox3SCChanged -eq '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_LVFONTSIZE=$($DropBox3_PageSC.SelectedItem)" -Encoding UTF8
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\windick.cmd";$NoExitPrompt = 1;$form.Close()}}
$global:DropBox3SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox4SC {
#$global:GUI_FONTSIZE = "$($DropBox4_PageSC.SelectedItem)"
if ($DropBox4SCChanged -eq '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_FONTSIZE=$($DropBox4_PageSC.SelectedItem)" -Encoding UTF8
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\windick.cmd";$NoExitPrompt = 1;$form.Close()}}
$global:DropBox4SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox5SC {
if ($($DropBox5_PageSC.SelectedItem) -eq '🎨 Theme') {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Theme' -MessageBoxText 'Select a theme' -MessageBoxChoices "Dark❗DarkRed❗DarkGreen❗DarkBlue❗Light❗LightRed❗LightGreen❗LightBlue"
if ($boxoutput -eq "Dark") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF151515';$GUI_BTN_COLORX = 'FF404040';$GUI_HLT_COLORX = 'FF777777';$GUI_BG_COLORX = 'FF252525';$GUI_PAG_COLORX = 'FF151515'}
if ($boxoutput -eq "DarkRed") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF150000';$GUI_BTN_COLORX = 'FF400000';$GUI_HLT_COLORX = 'FF770000';$GUI_BG_COLORX = 'FF250000';$GUI_PAG_COLORX = 'FF150000'}
if ($boxoutput -eq "DarkGreen") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF001500';$GUI_BTN_COLORX = 'FF004000';$GUI_HLT_COLORX = 'FF007700';$GUI_BG_COLORX = 'FF002500';$GUI_PAG_COLORX = 'FF001500'}
if ($boxoutput -eq "DarkBlue") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF000015';$GUI_BTN_COLORX = 'FF000040';$GUI_HLT_COLORX = 'FF000077';$GUI_BG_COLORX = 'FF000025';$GUI_PAG_COLORX = 'FF000015'}
if ($boxoutput -eq "Light") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFFFFFFF';$GUI_BTN_COLORX = 'FFC0C0C0';$GUI_HLT_COLORX = 'FFD5D5D5';$GUI_BG_COLORX = 'FFA0A0A0';$GUI_PAG_COLORX = 'FF555555'}
if ($boxoutput -eq "LightRed") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFFFD0D0';$GUI_BTN_COLORX = 'FFFF8888';$GUI_HLT_COLORX = 'FFFFACAC';$GUI_BG_COLORX = 'FFE06C6C';$GUI_PAG_COLORX = 'FF990000'}
if ($boxoutput -eq "LightGreen") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFD0FFD0';$GUI_BTN_COLORX = 'FF88FF88';$GUI_HLT_COLORX = 'FFACFFAC';$GUI_BG_COLORX = 'FF6CE06C';$GUI_PAG_COLORX = 'FF009900'}
if ($boxoutput -eq "LightBlue") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFD0D0FF';$GUI_BTN_COLORX = 'FF8888FF';$GUI_HLT_COLORX = 'FFACACFF';$GUI_BG_COLORX = 'FF6C6CE0';$GUI_PAG_COLORX = 'FF000099'}
ForEach ($i in @("","GUI_TXT_FORE=$GUI_TXT_FOREX","GUI_TXT_BACK=$GUI_TXT_BACKX","GUI_BTN_COLOR=$GUI_BTN_COLORX","GUI_HLT_COLOR=$GUI_HLT_COLORX","GUI_BG_COLOR=$GUI_BG_COLORX","GUI_PAG_COLOR=$GUI_PAG_COLORX")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\windick.cmd";$NoExitPrompt = 1;$form.Close()}
}
if ($($DropBox5_PageSC.SelectedItem) -ne '🎨 Theme') {$colorDialog = New-Object System.Windows.Forms.ColorDialog;$boxresultX = $colorDialog.ShowDialog()}
If ($boxresultX -eq [System.Windows.Forms.DialogResult]::OK) {
$colorSelect = $colorDialog.Color;$colorHex = $($colorSelect.ToArgb().ToString('X'))
if ($($DropBox5_PageSC.SelectedItem) -eq 'Text Color') {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_TXT_FORE=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Text Canvas') {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_TXT_BACK=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Button') {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_BTN_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Highlight') {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_HLT_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Background') {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_BG_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Side Panel') {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_PAG_COLOR=$colorHex" -Encoding UTF8}
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\windick.cmd";$NoExitPrompt = 1;$form.Close()}
}
$DropBox5_PageSC.ResetText();$DropBox5_PageSC.Items.Clear();
[void]$DropBox5_PageSC.Items.Add("🎨 Theme");[void]$DropBox5_PageSC.Items.Add("Button");[void]$DropBox5_PageSC.Items.Add("Highlight");[void]$DropBox5_PageSC.Items.Add("Text Color");[void]$DropBox5_PageSC.Items.Add("Text Canvas");[void]$DropBox5_PageSC.Items.Add("Side Panel");[void]$DropBox5_PageSC.Items.Add("Background")
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage1 {$global:PBWiz_Stage = 1
$Label1_PagePBWiz.Text = "🗳 Pack Builder"
$Label2_PagePBWiz.Text = "Select an option"
$ListView1_PagePBWiz.GridLines = $false
$ListView1_PagePBWiz.CheckBoxes = $false
$ListView1_PagePBWiz.FullRowSelect = $true
$ListView1_PagePBWiz.Items.Clear();
$item1 = New-Object System.Windows.Forms.ListViewItem("💾 Capture Project Folder")
[void]$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🗳 New Package Template")
[void]$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🗳 Restore Package")
[void]$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🔄 Export Drivers")
[void]$ListView1_PagePBWiz.Items.Add($item1)
$PagePBWiz.Visible = $true;$PageMain.Visible = $false;$PagePB.Visible = $false;$PagePBWiz.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage2 {$global:PBWiz_Stage = 2;
if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PagePBWiz.FocusedItem}
$ListView1_PagePBWiz.GridLines = $false;$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]'

if ($ListViewChoiceS2 -eq "💾 Capture Project Folder") {
$Label1_PagePBWiz.Text = "🗳 Pack Builder"
$Label2_PagePBWiz.Text = "Capture Project Folder"
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Package' -MessageBoxText 'Enter new .pkx package name' -Check 'PATH'

if ($boxresult -ne "OK") {$global:PBWiz_Stage = 1;$Label1_PagePBWiz.Text = "🗳 Pack Builder";$Label2_PagePBWiz.Text = "Select an option"}
if ($boxresult -eq "OK") {$ListView1_PagePBWiz.Items.Clear();
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
$command = @"
DISM /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"$PSScriptRootX\project" /IMAGEFILE:"$PackFolder\$boxoutput.pkx" /COMPRESS:Fast /NAME:"PKX" /CheckIntegrity /Verify
"@
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-CUSTOM","ARG4=`$LIST","ARG5=-LIVE")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
ForEach ($i in @("MENU-SCRIPT","`❕ⓠCommand`❕ECHO.           %@@%PACKAGE CREATE START`:%`$`$%  %DATE%  %TIME%`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕$command`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕ECHO.`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕ECHO.            %@@%PACKAGE CREATE END`:%`$`$%  %DATE%  %TIME%`❕NORMAL`❕DX`❕")) {Add-Content -Path "$ListFolder\`$LIST" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

if ($ListViewChoiceS2 -eq "🗳 New Package Template") {
$Label1_PagePBWiz.Text = "🗳 Pack Builder"
$Label2_PagePBWiz.Text = "New Package Template"
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$global:PBWiz_Stage = 1;$Label1_PagePBWiz.Text = "🗳 Pack Builder";$Label2_PagePBWiz.Text = "Select an option"}
if ($boxresult -eq "OK") {if (Test-Path -Path $ProjectFolder) {Remove-Item -Path "$ProjectFolder" -Recurse -Force}
ForEach ($i in @("ARG1=-IMAGEMGR","ARG2=-NEWPACK")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

if ($ListViewChoiceS2 -eq "🗳 Restore Package") {
$Label1_PagePBWiz.Text = "🗳 Restore Package"
$Label2_PagePBWiz.Text = "Select a package"
$ListView1_PagePBWiz.Items.Clear()
Get-ChildItem -Path "$PackFolder\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePBWiz.Items.Add($_)}
}
if ($ListViewChoiceS2 -eq "🔄 Export Drivers") {
$Label1_PagePBWiz.Text = "🔄 Export Drivers"
$Label2_PagePBWiz.Text = "Select a source"
$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.Items.Clear();
[void]$ListView1_PagePBWiz.Items.Add("🪟 Current Environment")
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PagePBWiz.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage3 {$global:PBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PagePBWiz.FocusedItem}
$ListView1_PagePBWiz.GridLines = $false;$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
if ($ListViewChoiceS2 -eq "🔄 Export Drivers") {
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-EXPORT","ARG3=-DRIVERS")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
If ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "ARG4=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG4=-VHDX","ARG5=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}

if ($ListViewChoiceS2 -eq "🗳 Restore Package") {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$global:PBWiz_Stage = 2;}
if ($boxresult -eq "OK") {
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
if (Test-Path -Path "$ProjectFolder") {Remove-Item -Path "$ProjectFolder" -Recurse -Force}
New-Item -ItemType Directory -Path "$PSScriptRootX\project"
$command = @"
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"$PackFolder\$ListViewChoiceS3" /INDEX:1 /APPLYDIR:"$ProjectFolder"
"@
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-CUSTOM","ARG4=`$LIST","ARG5=-LIVE")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
ForEach ($i in @("MENU-SCRIPT","`❕ⓠCommand`❕ECHO.           %@@%PACKAGE EXTRACT START`:%`$`$%  %DATE%  %TIME%`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕$command`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕ECHO.`❕NORMAL`❕DX`❕","`❕ⓠCommand`❕ECHO.            %@@%PACKAGE EXTRACT END`:%`$`$%  %DATE%  %TIME%`❕NORMAL`❕DX`❕")) {Add-Content -Path "$ListFolder\`$LIST" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage1 {$global:LEWiz_Stage = 1;$global:ListMode = 'Execute'
$Label1_PageLEWiz.Text = "🧾 List Execute"
$Label2_PageLEWiz.Text = "Select an option"
$ListView1_PageLEWiz.GridLines = $false
$ListView1_PageLEWiz.CheckBoxes = $false
$ListView1_PageLEWiz.FullRowSelect = $true
$ListView1_PageLEWiz.Items.Clear();
Get-ChildItem -Path "$ListFolder\*.base" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
$PageLEWiz.Visible = $true;$PageMain.Visible = $false;$PageLB.Visible = $false;$PageLEWiz.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage2 {$global:LEWiz_Stage = 2;$global:marked = $null;$global:boxresult = $null
$global:ListViewSelectS2 = $ListView1_PageLEWiz.FocusedItem
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]';
$LBWiz_TypeZ = Get-Content -Path "$ListFolder\$ListViewChoiceS2" -TotalCount 1
$global:LBWiz_TypeX, $partbxyz = $LBWiz_TypeZ -split '[ ]';

if ($LBWiz_TypeX -ne 'MENU-SCRIPT') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'Header is not MENU-SCRIPT, check file.';LEWiz_Stage1;$global:LBWiz_Stage = $null;$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront();return}
$LBWiz_TypeEXT = [System.IO.Path]::GetExtension("$ListFolder\$ListViewChoiceS2").ToUpper()

if ($LBWiz_TypeEXT -eq ".BASE") {$PageLBWiz.Visible = $true;$PageLEWiz.Visible = $false;$PageLBWiz.BringToFront();LBWiz_Stage2}
$Label1_PageLEWiz.Text = "🧾 List Execute"
$Label2_PageLEWiz.Text = "Select a target"
$ListView1_PageLEWiz.GridLines = $false;$ListView1_PageLEWiz.CheckBoxes = $false;$ListView1_PageLEWiz.FullRowSelect = $true
if ($LBWiz_TypeEXT -eq ".BASE") {$global:ListViewChoiceS2 = "`$LIST"}
$ListView1_PageLEWiz.Items.Clear();
[void]$ListView1_PageLEWiz.Items.Add("🪟 Current Environment")
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage3 {$global:LEWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLEWiz.FocusedItem}
$ListView1_PageLEWiz.GridLines = $false;$ListView1_PageLEWiz.CheckBoxes = $false;$ListView1_PageLEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-LIST","ARG4=$ListViewChoiceS2")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "ARG5=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}}
$global:LEWiz_Stage = $null;$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLEWiz.Visible = $false;Button_PageLB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
$PictureBoxConsole.Visible = $true;$PictureBoxConsole.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage1 {$global:PEWiz_Stage = 1;
$Label1_PagePEWiz.Text = "🗳 Pack Execute"
$Label2_PagePEWiz.Text = "Select a package"
$ListView1_PagePEWiz.GridLines = $false
$ListView1_PagePEWiz.CheckBoxes = $false
$ListView1_PagePEWiz.FullRowSelect = $true
$ListView1_PagePEWiz.Items.Clear();
Get-ChildItem -Path "$PackFolder\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePEWiz.Items.Add($_)}
$PagePEWiz.Visible = $true;$PageMain.Visible = $false;$PagePB.Visible = $false;$PagePEWiz.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage2 {$global:PEWiz_Stage = 2;
$Label1_PagePEWiz.Text = "🗳 Pack Execute"
$Label2_PagePEWiz.Text = "Select a target"
if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PagePEWiz.FocusedItem}
$ListView1_PagePEWiz.GridLines = $false;$ListView1_PagePEWiz.CheckBoxes = $false;$ListView1_PagePEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]'
$ListView1_PagePEWiz.Items.Clear();
[void]$ListView1_PagePEWiz.Items.Add("🪟 Current Environment")
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PagePEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage3 {$global:PEWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PagePEWiz.FocusedItem}
$ListView1_PagePEWiz.GridLines = $false;$ListView1_PagePEWiz.CheckBoxes = $false;$ListView1_PagePEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-PACK","ARG4=$ListViewChoiceS2")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "ARG5=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}}
$global:PEWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePEWiz.Visible = $false;Button_PagePB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
$PictureBoxConsole.Visible = $true;$PictureBoxConsole.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage1 {$global:LBWiz_Stage = 1;$global:ListMode = 'Builder'
$Label1_PageLBWiz.Text = "🧾 List Builder"
$Label2_PageLBWiz.Text = "Select an option"
$ListView1_PageLBWiz.GridLines = $false
$ListView1_PageLBWiz.CheckBoxes = $false
$ListView1_PageLBWiz.FullRowSelect = $true
$ListView1_PageLBWiz.Items.Clear();
$item1 = New-Object System.Windows.Forms.ListViewItem("🧾 Miscellaneous")
#[void]$item1.SubItems.Add("Description for X")
[void]$ListView1_PageLBWiz.Items.Add($item1)
Get-ChildItem -Path "$ListFolder\*.base" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
$PageLBWiz.Visible = $true;$PageMain.Visible = $false;$PageLB.Visible = $false;$PageLBWiz.BringToFront()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage2 {$global:LBWiz_Stage = 2;MOUNT_INT
$GRP = $null;if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {
if ($ListMode -eq "Builder") {$global:ListViewSelectS2 = $ListView1_PageLBWiz.FocusedItem}}
$parta, $global:BaseFile, $partc = $ListViewSelectS2 -split '[{}]';

if ($BaseFile -eq "🧾 Miscellaneous") {$global:LBWiz_Type = 'MISC';}
if ($BaseFile -ne "🧾 Miscellaneous") {
$LBWiz_TypeZ = Get-Content -Path "$ListFolder\\$BaseFile" -TotalCount 1
$global:LBWiz_Type, $partbxyz = $LBWiz_TypeZ -split '[ ]';"$ListFolder\\$BaseFile"
if ($LBWiz_Type -ne 'MENU-SCRIPT') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'Header is not MENU-SCRIPT, check file.';LBWiz_Stage1;return}}

$ListView1_PageLBWiz.Items.Clear()
$ListView1_PageLBWiz.GridLines = $false
$ListView1_PageLBWiz.CheckBoxes = $false
$ListView1_PageLBWiz.FullRowSelect = $true

if ($LBWiz_Type -eq 'MISC') {
$Label1_PageLBWiz.Text = "🧾 List $ListMode"
$Label2_PageLBWiz.Text = "Miscellaneous"
ForEach ($i in @("🧾 Create Source Base","🧾 Generate Example Base","🧾 Convert Group Base","✒ External Package Item")) {[void]$ListView1_PageLBWiz.Items.Add("$i")}
}
if ($LBWiz_Type -eq 'MENU-SCRIPT') {
if ($REFERENCE -eq 'LIVE') {MOUNT_INT}
if ($REFERENCE -ne 'LIVE') {if (-not ($vdiskltr)) {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Mounting Reference Image...";VDISK_ATTACH}}

$Label1_PageLBWiz.Text = "🧾 List $ListMode"
$Label2_PageLBWiz.Text = "$BaseFile"
Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh = $_ -split "[❕]"
if ($partXb -eq 'GROUP') {if (-not ($partXc -eq $GRP)) {
$GRP = "$partXc";#$item1.SubItems.Add("$partXf")
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXc")
[void]$ListView1_PageLBWiz.Items.Add($item1)}}}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage3MISC {$global:LBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLBWiz.FocusedItem}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'

if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {
$Label1_PageLBWiz.Text = "🧾 Miscellaneous"
$Label2_PageLBWiz.Text = "Create Source Base"
$ListView1_PageLBWiz.Items.Clear()
ForEach ($i in @("All source items","AppX","Capability","Feature","Service","Task","Component","Driver")) {[void]$ListView1_PageLBWiz.Items.Add("$i")}}

if ($ListViewChoiceS3 -eq "🧾 Generate Example Base") {
$Label1_PageLBWiz.Text = "🧾 Miscellaneous"
$Label2_PageLBWiz.Text = "Generate Example Base"
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Generate Example Base' -MessageBoxText 'Enter new base name' -Check 'PATH'
if ($boxresult -eq "OK") {$BaseName = "$boxoutput";
ForEach ($i in @("ARG1=-IMAGEMGR","ARG2=-EXAMPLE","ARG3=$boxoutput.base")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
return}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "✒ External Package Item") {
$Label1_PageLBWiz.Text = "🧾 Miscellaneous";
$Label2_PageLBWiz.Text = "Select a package"
$ListView1_PageLBWiz.Items.Clear()
Get-ChildItem -Path "$PackFolder\*.appx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.appxbundle" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.cab" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.msixbundle" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.msu" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$PackFolder\*.pkx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}

if ($ListViewChoiceS3 -eq "🧾 Convert Group Base") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();
$Label1_PageLBWiz.Text = "🧾 Convert Group Base";
$Label2_PageLBWiz.Text = "Select a list to convert"
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4MISC {$global:LBWiz_Stage = 4;
if ($marked -ne $null) {$global:ListViewSelectS4 = $marked} else { $global:ListViewSelectS4 = $ListView1_PageLBWiz.FocusedItem}
$parta, $global:ListViewChoiceS4, $partc = $ListViewSelectS4 -split '[{}]'
if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {
if ($ListViewChoiceS4 -eq 'All source items') {$global:ListViewBase = '1 4 2 5 6 7 3'}
if ($ListViewChoiceS4 -eq 'AppX') {$global:ListViewBase = 1}
if ($ListViewChoiceS4 -eq 'Feature') {$global:ListViewBase = 2}
if ($ListViewChoiceS4 -eq 'Component') {$global:ListViewBase = 3}
if ($ListViewChoiceS4 -eq 'Capability') {$global:ListViewBase = 4}
if ($ListViewChoiceS4 -eq 'Service') {$global:ListViewBase = 5}
if ($ListViewChoiceS4 -eq 'Task') {$global:ListViewBase = 6}
if ($ListViewChoiceS4 -eq 'Driver') {$global:ListViewBase = 7}
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Source Base' -MessageBoxText 'Enter new .base name' -Check 'PATH'
if ($boxresult -ne "OK") {$global:ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$global:ListName = "$boxoutput.base";$ListTarget = "$ListFolder\$boxoutput.base";if (Test-Path -Path $ListTarget) {Remove-Item -Path "$ListTarget" -Force}
PickEnvironment
$Label1_PageLBWiz.Text = "🧾 Create Source Base"
$Label2_PageLBWiz.Text = "Select a source"
}}

if ($ListViewChoiceS3 -eq "🧾 Convert Group Base") {$is_group = $null
$LBWiz_TypeZ = Get-Content -Path "$ListFolder\$ListViewChoiceS4" -TotalCount 1
$LBWiz_TypeY, $partbxyz = $LBWiz_TypeZ -split '[ ]';

if ($LBWiz_TypeY -ne 'MENU-SCRIPT') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'Header is not MENU-SCRIPT, check file.';$global:marked = $ListViewSelectS3;LBWiz_Stage3MISC;return}
Get-Content "$ListFolder\$ListViewChoiceS4" -Encoding UTF8 | ForEach-Object {$partXa, $partXb, $partXc = $_ -split "[❕]";if ($partXb -eq 'GROUP') {$is_group = 1}}
if ($is_group -eq $null) {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText "List does not contain any groups.";$global:marked = $ListViewSelectS3;LBWiz_Stage3MISC;return}
if ($is_group -eq 1) {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Group Base' -MessageBoxText 'Enter new .base name' -Check 'PATH'
$ListName = "$boxoutput.base";$ListTarget = "$ListFolder\$boxoutput.base";
if (Test-Path -Path $ListTarget) {Remove-Item -Path "$ListTarget" -Force}
Copy-Item -Path "$ListFolder\$ListViewChoiceS4" -Destination "$ListFolder\$boxoutput.base" -Force}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "✒ External Package Item") {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Time of Action' -MessageBoxText 'Select a run time' -MessageBoxChoices "❕DX❕ Default - Immediate execution❗❕SC❕ SetupComplete - Scheduled execution❗❕RO❕ RunOnce - Scheduled execution"
if ($boxoutput -eq "❕DX❕ Default - Immediate execution") {$global:ExecuteTime = "DX"}
if ($boxoutput -eq "❕SC❕ SetupComplete - Scheduled execution") {$global:ExecuteTime = "SC"}
if ($boxoutput -eq "❕RO❕ RunOnce - Scheduled execution") {$global:ExecuteTime = "RO"}
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$Label1_PageLBWiz.Text = "💾 Append Items";$Label2_PageLBWiz.Text = "Select a list"
[void]$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5MISC {
if ($marked -ne $null) {$global:ListViewSelectS5 = $marked} else { $global:ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem}
$parta, $ListViewChoiceS5, $partc = $ListViewSelectS5 -split '[{}]'

if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-CREATE","ARG3=-BASE","ARG4=$ListName")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS5 -eq "🪟 Current Environment") {ForEach ($i in @("ARG5=-LIVE","ARG6=$ListViewBase")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}}
if ($ListViewChoiceS5 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS5","ARG7=$ListViewBase")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
return}
if ($ListViewChoiceS5 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 4;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$ListFolder\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "MENU-SCRIPT" -Encoding UTF8}}}
if ($ListViewChoiceS5 -ne "🧾 Create New List") {$global:LBWiz_Stage = 4;$ListName = "$ListViewChoiceS5";$ListTarget = "$ListFolder\$ListViewChoiceS5"}
Add-Content -Path "$ListTarget" -Value "`❕ExtPackage`❕$ListViewChoiceS4`❕Install`❕$ExecuteTime`❕" -Encoding UTF8
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage3GRP {$global:LBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLBWiz.FocusedItem}

$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.CheckBoxes = $true;$Label1_PageLBWiz.Text = "🧾 $BaseFile";$Label2_PageLBWiz.Text = "$ListViewChoiceS3"
$global:SubGroupLast = "";$ReadGroup = "";Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]"
if ($partXb -eq 'GROUP') {if ($partXc -eq $ListViewChoiceS3) {$ReadGroup = 1}}
if ($partXb -eq 'GROUP') {if ($partXc -ne $ListViewChoiceS3) {$ReadGroup = ""}}
if ($ReadGroup) {
if ($partXb) {$GrpViewChk1, $GrpViewChk2 = $partXb -split "[ⓡ]";if (-not ("$GrpViewChk1$GrpViewChk2" -eq "$partXb")) {Group-View}}
if ($partXb -eq 'GROUP') {
if ($partXc -eq $ListViewChoiceS3) {
if ($SubGroupLast) {$SubGroupLastOG = $SubGroupLast
$stringX1 = $SubGroupLast.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$stringX3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$item1 = New-Object System.Windows.Forms.ListViewItem("$stringX3")
$item1.SubItems.Add("$SubGroupLastOG")
[void]$ListView1_PageLBWiz.Items.Add($item1)}
$global:GroupLast = $partXc;$global:SubGroupLast = $partXd}}
}}
if ($SubGroupLast) {$SubGroupLastOG = $SubGroupLast
$stringX1 = $SubGroupLast.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$stringX3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$item1 = New-Object System.Windows.Forms.ListViewItem("$stringX3")
$item1.SubItems.Add("$SubGroupLastOG")
[void]$ListView1_PageLBWiz.Items.Add($item1)
$global:GroupLast = $partXc;$global:SubGroupLast = $partXd}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.FullRowSelect = $true
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4GRP {$global:LBWiz_Stage = 4;
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
if ($ListMode -eq 'Execute') {Add-Content -Path "$ListFolder\`$LIST" -Value "MENU-SCRIPT" -Encoding UTF8}
ForEach ($checkedItem in $ListView1_PageLBWiz.CheckedItems) {$ListWrite = 0

if ($partXb) {
$GrpViewChk1, $GrpViewChk2 = $partXb -split "[ⓡ]";
if (-not ("$GrpViewChk1$GrpViewChk2" -eq "$partXb")) {Group-View}}

#$ExpandoFlex = $checkedItem.SubItems[0].Text
#$stringX1 = $ExpandoFlex.Replace("◁", "`$(`$")
#$stringX2 = $stringX1.Replace("▷", ")")
#$ListViewCheckedExpand = $ExecutionContext.InvokeCommand.ExpandString($stringX2)

$ListViewChecked = $checkedItem.SubItems[1].Text;$ListViewCheckedExpand = $checkedItem.SubItems[0].Text
Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]";if ($partXb) {$partXb = $partXb.Replace("ⓠ", "")}

if ($partXb -eq 'GROUP') {if ($partXc -ne $ListViewChoiceS3) {$ListWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXd -ne $ListViewChecked) {$ListWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXc -eq $ListViewChoiceS3) {if ($partXd -eq $ListViewChecked) {$ListWrite = 1}}}
if ($partXb -eq 'GROUP') {if ($partXe -eq "SCOPED") {if ($partXc -eq $ListViewChoiceS3) {if ($partXd -eq $ListViewChecked) {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewCheckedX" -MessageBoxText "$partXf" -MessageBoxChoices "$partXg"
Add-Content -Path "$ListFolder\`$LIST" -Value "`❕$partXb`❕$partXc`❕$partXd`❕$partXe`❕$partXf`❕$partXg`❕$boxindex`❕" -Encoding UTF8
$ListWrite = 0;MessageBoxListView;return}}}}
if ($ListWrite -eq '1') {$ListPrompt = $null;
$Label1_PageLBWiz.Text = "$ListViewChoiceS3"
$Label2_PageLBWiz.Text = "$ListViewCheckedExpand"
ForEach ($i in @("PROMPT0","PROMPT1","PROMPT2","PROMPT3","PROMPT4","PROMPT5","PROMPT6","PROMPT7","PROMPT8","PROMPT9")) {if ($i -eq "$partXb") {$ListPrompt = 1}}
ForEach ($i in @("CHOICE0","CHOICE1","CHOICE2","CHOICE3","CHOICE4","CHOICE5","CHOICE6","CHOICE7","CHOICE8","CHOICE9")) {if ($i -eq "$partXb") {$ListPrompt = 2}}
ForEach ($i in @("PICKER0","PICKER1","PICKER2","PICKER3","PICKER4","PICKER5","PICKER6","PICKER7","PICKER8","PICKER9")) {if ($i -eq "$partXb") {$ListPrompt = 3}}
if ($ListPrompt -eq $null) {Add-Content -Path "$ListFolder\`$LIST" -Value "$_" -Encoding UTF8}
if ($ListPrompt -eq '1') {$partw1, $partx1 = $partXd -split "❗";$party1, $partz1 = $partx1 -split "-";
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -Check "$partw1" -TextMin "$party1" -TextMax "$partz1"
Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxoutput`❕" -Encoding UTF8}
if ($ListPrompt -eq '2') {MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -MessageBoxChoices "$partXd"
Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxindex`❕" -Encoding UTF8}
if ($ListPrompt -eq '3') {MessageBox -MessageBoxType 'Picker' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -MessageBoxChoices "$partXd"
Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxoutput`❕" -Encoding UTF8}
}}}
if ($ListMode -eq 'Builder') {
$Label1_PageLBWiz.Text = "💾 Append Items"
$Label2_PageLBWiz.Text = "Select a list"
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();[void]$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($ListMode -eq 'Execute') {if ($REFERENCE -ne 'LIVE') {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH}
$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront()}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5GRP {
if ($REFERENCE -ne 'LIVE') {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH;$Label1_PageLBWiz.Text = "💾 Append Items";$Label2_PageLBWiz.Text = "Select a list"}
$ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem
$parta, $partb, $partc = $ListViewSelectS5 -split '[{}]'
if ($partb -eq "🧾 Create New List") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";}
if ($boxresult -eq "OK") {
$ListName = "$boxoutput.list";$ListTarget = "$ListFolder\$boxoutput.list";
if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "MENU-SCRIPT" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
if ($partb -ne "🧾 Create New List") {$ListName = "$partb";$ListTarget = "$ListFolder\$partb"}
Get-Content "$ListFolder\`$LIST" -Encoding UTF8 | ForEach-Object {
$partxxx, $partyyy, $partzzz = $_ -split '[❕]';if ($partyyy -eq "GROUP") {Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8}
if ($_ -ne "") {Add-Content -Path "$ListTarget" -Value "$_" -Encoding UTF8}}
#Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}

if ($ListName -ne "$null") {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName"
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickEnvironment {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();
[void]$ListView1_PageLBWiz.Items.Add("🪟 Current Environment")
Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function AddElement {
if ($Page -eq 'PageW2V') {$PageW2V.Controls.Add($element)}
if ($Page -eq 'PageV2W') {$PageV2W.Controls.Add($element)}
if ($Page -eq 'PageLB') {$PageLB.Controls.Add($element)}
if ($Page -eq 'PagePB') {$PagePB.Controls.Add($element)}
if ($Page -eq 'PageBC') {$PageBC.Controls.Add($element)}
if ($Page -eq 'PageSC') {$PageSC.Controls.Add($element)}
if ($Page -eq 'PageSP') {$PageSP.Controls.Add($element)}
if ($Page -eq 'PageConsole') {$PageConsole.Controls.Add($element)}
if ($Page -eq 'PageDebug') {$PageDebug.Controls.Add($element)}
if ($Page -eq 'PagePBWiz') {$PagePBWiz.Controls.Add($element)}
if ($Page -eq 'PagePEWiz') {$PagePEWiz.Controls.Add($element)}
if ($Page -eq 'PageLBWiz') {$PageLBWiz.Controls.Add($element)}
if ($Page -eq 'PageLEWiz') {$PageLEWiz.Controls.Add($element)}
if ($Page -eq 'PageMain') {$PageMain.Controls.Add($element)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LoadSettings {
$LoadINI = Get-Content -Path "$PSScriptRootX\windick.ini" | Select-Object -Skip 1
$Settings = $LoadINI | ConvertFrom-StringData
$global:REFERENCE = $Settings.REFERENCE
$global:GUI_SCALE = $Settings.GUI_SCALE
$global:GUI_RESUME = $Settings.GUI_RESUME
$global:GUI_CONFONT = $Settings.GUI_CONFONT
$global:GUI_CONTYPE = $Settings.GUI_CONTYPE
$global:GUI_FONTSIZE = $Settings.GUI_FONTSIZE
$global:GUI_CONFONTSIZE = $Settings.GUI_CONFONTSIZE
$global:GUI_LVFONTSIZE = $Settings.GUI_LVFONTSIZE
$global:GUI_HLT_COLOR = $Settings.GUI_HLT_COLOR
$global:GUI_BTN_COLOR = $Settings.GUI_BTN_COLOR
$global:GUI_BG_COLOR = $Settings.GUI_BG_COLOR
$global:GUI_PAG_COLOR = $Settings.GUI_PAG_COLOR
$global:GUI_TXT_FORE = $Settings.GUI_TXT_FORE
$global:GUI_TXT_BACK = $Settings.GUI_TXT_BACK
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Launch-CMD {
param([int]$X,[int]$Y,[int]$H,[int]$W)
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$PageMain.Visible = $false;$PageBlank.Visible = $true;$PageBlank.BringToFront()
if (Test-Path -Path "$PSScriptRootX\`$CON") {Remove-Item -Path "$PSScriptRootX\`$CON" -Force -Recurse}
if (Test-Path -Path "$PSScriptRootX\`$PKX") {Remove-Item -Path "$PSScriptRootX\`$PKX" -Force -Recurse}
if (Test-Path -Path "$PSScriptRootX\`$CAB") {Remove-Item -Path "$PSScriptRootX\`$CAB" -Force -Recurse}
if (Test-Path -Path "$PSScriptRootX\`$DISK") {Remove-Item -Path "$PSScriptRootX\`$DISK" -Force -Recurse}
Add-Content -Path "$PSScriptRootX\`$CON" -Value "$PSScriptRootX" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$CON" -Value "GUI_CONFONT=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$CON" -Value "GUI_CONFONTSIZE=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRootX\`$CON" -Value "GUI_SCALE=$GUI_SCALE" -Encoding UTF8
if ($ButtonRadio1_Group1.Checked -eq $true) {$GUI_CONTYPE = 'Embed'} else {$GUI_CONTYPE = 'Spawn'}
$CMDWindow = Start-Process "PowerShell" -PassThru -ArgumentList "-noprofile", "-WindowStyle", "Hidden", "-Command", {
Add-Type -TypeDefinition @'
using System;using System.Runtime.InteropServices;public class WinMekanix {
    private const int STD_OUTPUT_HANDLE = -11;
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)] public struct CONSOLE_FONT_INFO_EX
    {public uint cbSize;public uint nFont;public COORD dwFontSize;public int FontFamily;public int FontWeight;[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]public string FaceName;}
    [StructLayout(LayoutKind.Sequential)] public struct COORD
    {public short X;public short Y;}
    [DllImport(\"kernel32.dll\", SetLastError = true)] public static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport(\"kernel32.dll\", SetLastError = true)] public static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
    [DllImport(\"kernel32.dll\", SetLastError = true)] public static extern bool GetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
    public static bool SetConsoleFont(string fontName, short fontSize)
    {IntPtr consoleOutputHandle = GetStdHandle(STD_OUTPUT_HANDLE);
        if (consoleOutputHandle == IntPtr.Zero)
        {return false;}
        CONSOLE_FONT_INFO_EX fontInfo = new CONSOLE_FONT_INFO_EX();
        fontInfo.cbSize = (uint)Marshal.SizeOf(fontInfo);GetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);fontInfo.dwFontSize.X = 0;fontInfo.dwFontSize.Y = fontSize;fontInfo.FaceName = fontName;return SetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);} }
'@
Add-Type -AssemblyName System.Windows.Forms
[VOID][System.Text.Encoding]::Unicode;CLS
[VOID][WinMekanix]::SetConsoleFont('Consolas', 1)
$PSScriptRootX = "$($PWD.Path)";#$PSScriptRootX = Get-Content -Path \"$env:temp\`$CON\" -TotalCount 1
$LoadINI = Get-Content -Path \"$PSScriptRootX\`$CON\" | Select-Object -Skip 1
$Settings = $LoadINI | ConvertFrom-StringData
$GUI_SCALE = $Settings.GUI_SCALE
$GUI_CONFONT = $Settings.GUI_CONFONT
$GUI_CONFONTSIZE = $Settings.GUI_CONFONTSIZE
$DimensionX = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$DimensionY = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$GetCurDpi = [System.Drawing.Graphics]::FromHwnd(0)
$DpiX = $GetCurDpi.DpiX;$DpiCur = $DpiX / 96
$RefX = 1000;$DimScaleX = $DimensionX / $RefX
$RefY = 1000;$DimScaleY = $DimensionY / $RefY
if ($DimScaleX -ge $DimScaleY) {$ScaleRef = $DimScaleY}
if ($DimScaleY -ge $DimScaleX) {$ScaleRef = $DimScaleX}
if ($GUI_SCALE) {$null} else {$GUI_SCALE = 1.00}
if ($GUI_CONFONT) {$null} else {$GUI_CONFONT = 'Consolas'}
if ($GUI_CONFONTSIZE) {$null} else {$GUI_CONFONTSIZE = 'Auto'}
if ($GUI_CONFONTSIZE -eq 'Auto') {$CFSIZE0 = 28} else {$CFSIZE0 = $GUI_CONFONTSIZE}
#$ScaleFont = $CFSIZE0 * $ScaleRef * $GUI_SCALE
$ScaleFont = $GUI_SCALE / $DpiCur * $CFSIZE0 * $ScaleRef
$ScaleFontX = [Math]::Floor($ScaleFont);$CFSIZEX = $ScaleFontX
[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
CLS;Write-Host "Console Virtual Dimensions: $DimensionX x $DimensionY"
Start-Process \"$env:comspec\" -Wait -NoNewWindow -ArgumentList "/c", \"$PSScriptRootX\windick.cmd\", "-EXTERNAL"
$PathCheck = \"$PSScriptRootX\\`$CON\";if (Test-Path -Path $PathCheck) {Remove-Item -Path \"$PSScriptRootX\`$CON\" -Force}
if ($PAUSE_END -eq '1') {pause}}
$CMDHandle = $CMDWindow.MainWindowHandle;#$CMDHandleX = $CMDWindow.Handle;
do {$CMDHandle = $CMDWindow.MainWindowHandle;Start-Sleep -Milliseconds 100} until ($CMDHandle -ne 0)
$global:CMDProcessId = $CMDWindow.Id;$PanelHandle = $PageConsole.Handle
$getproc = Get-ChildProcesses $CMDProcessId | Select ProcessId, Name, ParentProcessId
$part1, $part2, $part3 = $getproc -split ";";$part4 = $part1 -split ";";$global:SubProcessId = $part4 -Split "@{ProcessId="
Write-Host "Starting console PID: $CMDProcessId conhost PID:$SubProcessId"
if ($GUI_CONTYPE -eq 'Embed') {[VOID][WinMekanix.Functions]::SetParent($CMDHandle, $PanelHandle)}
do {Start-Sleep -Milliseconds 100} until (-not (Test-Path -Path "$PSScriptRootX\`$CON"))
if ($GUI_CONTYPE -eq 'Embed') {[VOID][WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 1);[VOID][WinMekanix.Functions]::MoveWindow($CMDHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)}
$PageBlank.Visible = $false;$PageConsole.Visible = $true;$PageConsole.BringToFront()
[VOID][WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 3)}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
[string]$SplashLogo=@"
/9j/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAD6APoDASEAAhEBAxEB/8QAHAABAAIDAQEBAAAAAAAAAAAAAAQFAQMGAgcI/8QAOxAAAgIBAgQEAwYFAwMFAAAAAAECAwQFEQYSITETQVFxIjJhBxRCUoGhI2KCkbEVctEWJDNDY5LB4f/EABUBAQEAAAAAAAAAAAAAAAAAAAAB/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A/P4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADYBsAAAAAAAAAAAAAAAAAAAAbase697VVTm/5Y7gWNPDep3JPwVBfzvYsKOD7ZP8Aj5dcF/KnJgSI8J4sX8eTZJfRJG1cNYEV2tl/UEZhomm1WJzxnOKfWLm1uWescNaNXhY2oafjOOPcuWUJTcnCXuBRT0rBXaj9zdZoenx0qOQ6pKyU9l8XTYoq56XjeSkvZkeel1/hsa90QR56fOPWM4sj2Uzq2547bhWsAAAAAAAAAAAABvx8TIy7FCimdkn+VF9icI3z5Xl2qrf8EfikB2elfZvmTrVuPoeRemt1O6Pf9GS8nRdT0mPLkaXbjwX/ALWy/YIhc8J9+jPLjD8wGuTgu3U0zk39ANM/iT9UWNEnZwnnQl2rujKP03AoJdiTc+bQqv5bGiipl3NEiDTNblZmXeJZyp/DHoBGAUAAAAAAAAABKw9Pyc6W1FbkvOT6JfqdPp/DGNRtZmS8aX5F0iv+QjrtB0PL1rMhgaZjxjv8zitowXq2d1bZw79n6VVVUNV1vb4pz6wqYFJk/aHxRl2Occ3wY77qFcEkibg/afreO+TUKqc6l/NGcdmBc05PAnFnw34y07Mkvw/D1/wYyPsmx7ouzT9U5oPqk9mBWW/ZbkVRlz5Te3pHY5PiHQJaLKKcm03t1A56XaRZVLw+EMub/wDUyIxX6AUEiXL4dAW/4rOhRTy8zRLzIImXb4NL2fxS6IqGFAAAAAAAAAAeoVysmowi5SfZIv8AA0CKSty3u/KtP/IR9G1vGxY8PaLk4ePXRVKtwcK1suZd/dlJHeSjFLdvsgPqF+TXwHwZTjY2y1bPjzTn5xTPnS5pylbZJylJ7tt9WyjDtfke4zU+jRB4nXt1Rc6PxZqekSUY3zsp/LJ9vYD6VoXGmNq0FCU0p+cWcx9p+M/u1GRFfBzlHzCXystJbS4LfL3hlfF+qIOen2JeoPl0vCiu0otsop5dzTLbq29klu2QUeVe77nL8K6JfQ0BQAAAAAAAAJOHh25lqhWunnJ9kB2fDkMbRsyMpVxshYvDtlJbvZ+noTNQwnp+o242+8U94S9YvqmVF3OfjcBY6a60Zjj+jW5r4Zw1n8TadjS+WVqcvZdSC246z5ahxZfDf+Hj7VQXpsUFj7IDWeofMgJHL8PUiX2UVfPfVD6OSAjQ1nFw7VbXn1wmvNSO1j9oHDGs8L26frOpqnJUdoyVcpJvyfQD51LVtN5pJZkWuuz5X1J2na7pX+m5+HfmwhG2KlXun86AqfvmLJdMivf3JFuRVfpdKjbBzqk47c3VplECSK7Ur/Cq8JfPPv8AREFOAoAAAAAAAAlYeHPKs27QXzSOkoqhRWq64pRX7hEmJe6o/H03S8x/M6nVN/WLKJeA/F4N1Ovu6siqzb0T6bk3gW2FXGenym9k5NJv1aINfE+PZjcV6hCxNPxXLd+jKLN1TT8P/wA2VDmX4Y9WBRZHF9Md1jY8pPylN7IrLuKtStTUJQqT/JHqBXXajmXve3Ktl/UyM5OT3k2/dhWAAAAzu12bQG2GVdD5bZL9TxZbO2bnOTlJ+YHgAAAAAAAAJmnYFmoZPhwajFfFOb7RQF9CuuleHUtoR6Lfu/qzdHuEb4di+xo/e+FsitdZ4dyt/pl0ZRJ4bsqndmYN9sKqczGlDnsltGMl1i2/0OXs4rq0vIrsw34uVTLeMl8qaf7kFXxLxrrXFOdLL1C+MZNcqhTHkil+hzzbb3b3YVgAAAAAAAAAAAAAAAAAB6rhKyahFbtvZHU4ddeHjKmtfG18cvVhHrlbbaTN1dc2+kW/YDZHoyVi8QY/D+ROzIg7421Srnjxezmmv2KONztWyM5uMpclW/SuL6L/AJIBFAAAAANn6Gdn6MDAAAAAAAAAAAAACz02nkTufzPpEtKpNySCOjwMSiNcbblv59S0o1XT6rVBVx6vZ7LuBz3GOtaZTdCnSvjytv41i+WP0XqzhJzlZNznJyk+7YV5AGdibiaPn5r/AIGPNr8z6IC7x+DrOjyshQXmoLdnXaVw9wLiqLz8LU8uaXXe5Rjv7RCL6ObwRhNSweCsWU0tk8ibn+zZpnxRXHpj8NaHVHySxIsCNdxVZYtrNE0eS9FiJFddrmJPvoGnRf8ALDYCl1LLrzNksLFpgvKutL9yotx6G3vVD+wESzDof4NvYrsuqumajBvfz38gI4CgAAAAAAGyqvxbYwXmwLmCUUkuy6Il463tivqEXWoXShCMEmlt/c5vUdSdCdNUv4r+aS/D/wDoFE2292YCspblrgaDkZbUrX4Nb85d3+gH0HgjG4c0bUJLVdNqy67Uo+NcuZ1P1SO81D7N5ZVf3zh7KhdjyXMqm+q9mEclmaLq2mzccrBujt58u6/uiudiXSUNn9QMpynJRqrcpPskty6wOCtd1OKnHG8Gt/itfL+wG7L+zzMorbeo4zsX4dzlNT0bP01v7xU+T88eqKKawi2dwIts1CEpvtEo7Juybm31ZB5AUAAAAAAAm4EPilN+S2QFjHsSsZpWxbfZhEviDM+64tUt14lu/hx+n5jjXJybbe7fdhWDZTRZfYoVxbbA7vgrR8WvWKpX1QvsSbXOt0n7ErPqlRqd8ZLb4217BCCU136nQaFxRqmgWp4l8vD361yfQDv8H7V8W+ChqeAvq0t0TJcUcC563yMWpN+tZRpnxjwZpUXLAwYTs8uWvzOP177RNT1NuGKli09ko9wONvzsuyXNPKtcvVyZL03XLlasXMm7aLOjUupBV67gxwstqv8A8c+sfoUs13ApdSv3s8GL6R7+5ACgAAAAAAAAWWJHlx4/V7gTI9TdB7dW9kur9gim1HNsz8t3WPfZKMV6RXYiBWyimd9sYQXV/sdHiY9eNUoQXXzl5sIvtCzY4OfG6Xy+Z3UcXReIormtjXe10afmBVavwfn6TV94gvHxu/PDuinhLfpJAbFGD8zPhL1A8S8KPeyK/VGiVuP5X1//ADQEW2dW/wAN1b/qRob2kpRa3XXoyiz1tvK0zGyVF9tmzlMq5Y9ErH37R9yDnJScpOT7vqYCgAAAAAAAAW1Udqq1/KBviac+514vKn1m9v0CKgylu0l3YVeYWOserb8cu7J9aCJNZKplKMk4Nprs0yjvOG/tE07R8S3H4hy26lH4Yxjzzl9NjgeI+OdNy9Stt0bTbKaW+jul1f12XYg5q/ibUrt1GxVp+UEQLdQzLnvZk2y/qYVodtj7zk/dmOZ+rAbv1Z6jdbHtZJfqBJjqufCrwll2+H+Tm6f2NN+Xdk8viz35ewGkAAAAAAAAAAuIfLH/AGoI2xK/Up816hv0jECES8Crntc2uke3uFXFb37kmsI3O6qivxbpqEF5+vsU+dr9tqdeKnVX6/iYFNKTk25Sbb82zAUAAAAAAAAAAAAAAAAAtqnvVB/QCRHyKjLe+Vb7hGgtsOPJRH1fUKmwNk768el2WPovL1YRQ5eZZl28030Xyx8kiMFDOzfRdWBc6Lwjr/ENrr0rS8jJlFby5Vskvq2blwdqisnXaqqpwbUoyl1TQHr/AKSyV8+RUvbc02cM3w7X1sIjWaHk1/ig/ZkW3T8ir5q+/bYKjyi4vZrZmAAAAAAAAAAABZ4b5qEvNPYCXDo0U2T0ybP9zCNa7lzTFvlivJAWeJjRtsUXJLzbb7LzOf1LKjkZUvC38GL2gn6eoEI9Ri5yUYJtvskFXuPw3ZXySz263Jb+EvmS+voX+Fg4mNFeFRBNebW7CPp32UZLr4nnQ38NtLW3kc1rlXgcR6jV22vl/kCms79SFftu9u3kBX3diFkSUKed9o77gc9bN2WSm+7Z4CgAAAAAAAAABMwZ7TlD16oCzXyqWxU50eTLn9eoRHXdF5B8qW3doDGVkSqw7Nm05rk/5KMK9Qi5yUYrdvyOo0HBqoyFbNJuC5m36hFg7ZX3ztk95Se5Mr2jHmlJRj6t7FF9wfxhovDnElObn5qhTFNSdcXN9foit4p430HO4mzM3Bsvsx7Zc0W6+V/2ZBRWcU6dJtqN23saJ6/gWdpTj7xA1Sz8S2PwXx9n0KjVclTaprknFdW15sCtAUAAAAAAAAAAPdc3XNSXdMC7rnGyqMo9mQ9Tq+Gu1f7WEVpd421lNcm+rQGnVeVU0Ri922+Yqgqfp1fV2Py6I6PEi/uljXu/RIIrMrW1TvXipSku832/Qp78vIyZc11spb+r6AafMwFAAAAAAAAAAAAAAAABNwMnw5eFN/BJ9H6MtLKldTKt9pLp7hFBKLhJxktmuhPwJ81bg+8eqA9ajHeiEvSWxWBVrgr/ALdberNmpZ1leP8Ac65bKe0rGvP0QRTAKDYAAAAAAAAAAAAAAAAABa4GamlTbLZ9oy/+gM6phtr7xBfSaX+SuptdNqmv1QRcTrWXiSUPi5lvH3KNrYCy02a5JR809zRqe/36fTyX+AIZnYKyAjDRgKMAAAAAAAAAAAAAAALowLPC1Pk2ryFzV9t/QZ2ncsHk43x0Pq9uvKEa9N1GWDkKTSlX5p/5NmpYsW3l463pm93t+FgQ8a3wLoy8vMmavWvFqyIvmjbBdfqgK3YyAAAw0BgBQAAAAAAAAAAAAAAAm6fqeVpt3iY89k1tKElvGS9GvNATMn/SdQonfj74OXFbyx38Vc/9j7r2ZAxs23F3itpVy+aEuzCPWTXiyqjdjWNOTalTJdYfr5o9V3f9nPHtTlHvBrvFgRHFowAAAw2BgBQAAAAAAAAAAAAAAAAABuqW+yLCrDlOO+xUa78V190QZLaWxB5AA8sKAAAAAAAAAAAAAAAAAAAAk423Mjo8K2tVqPTcqPfEksaEqsfH2arguZrzk+5ylj+JkHjcbhRswAAAAAAAAAAAAAAAAAAAAB7hPlZKhluPmwjFuS7O73IknuwMAKAAAAAAAAAAAAAAAAAAAAAAZ3YGNwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf/9k=
"@
function SplashScreen {
$SplashForm = New-Object System.Windows.Forms.Form
$SplashForm.Size = New-Object System.Drawing.Size($SplashSize, $SplashSize)
$SplashForm.StartPosition = "CenterScreen"
$SplashForm.ShowInTaskbar = $false
$SplashForm.ControlBox = $false
$PictureBoxSplash = New-Object System.Windows.Forms.PictureBox
$PictureBoxSplash.Dock = "Fill"
$PictureBoxSplash.SizeMode = 'StretchImage'
$PictureBoxSplash.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($SplashLogo))
$SplashForm.Controls.Add($PictureBoxSplash)
$PictureBoxSplash.Visible = $true;$PictureBoxSplash.BringToFront()
$SplashForm.Show()
Start-Sleep -Milliseconds 250
return $SplashForm
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$PSHandle = [WinMekanix.Functions]::GetConsoleWindow()
[VOID][WinMekanix.Functions]::SetForegroundWindow($PSHandle)
[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 0)
[VOID][System.Text.Encoding]::Unicode;LoadSettings
[VOID][WinMekanix.Functions]::SetProcessDPIAware()
[VOID][System.Windows.Forms.Application]::EnableVisualStyles()
[VOID][System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)
$sysltr, $nullx = $env:SystemDrive -split '[:]';$progltr, $nullx = $PSScriptRootX -split '[:]'
$STDOutputHandle = [WinMekanix.Functions]::GetStdHandle([WinMekanix.Functions]::STD_OUTPUT_HANDLE)
$getproc = Get-ChildProcesses $PID | Select ProcessId, Name, ParentProcessId
$part1, $part2, $part3 = $getproc -split ";";$part4 = $part1 -split ";";
$ConhostPID = $part4 -Split "@{ProcessId=";Write-Host "Main thread PID: $PID conhost PID:$ConhostPID"
$RawUIMAX = $host.UI.RawUI.MaxWindowSize
$DimensionX = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$DimensionY = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$DimensionVX = [System.Windows.Forms.SystemInformation]::VirtualScreen.Width
$DimensionVY = [System.Windows.Forms.SystemInformation]::VirtualScreen.Height
$GetCurDpi = [System.Drawing.Graphics]::FromHwnd(0)
$DpiX = $GetCurDpi.DpiX;$DpiCur = $DpiX / 96
$RefX = 1000;$DimScaleX = $DimensionX / $RefX
$RefY = 1000;$DimScaleY = $DimensionY / $RefY
if ($DimScaleX -ge $DimScaleY) {$ScaleRef = $DimScaleY;$SplashSize = $DimScaleY}
if ($DimScaleY -ge $DimScaleX) {$ScaleRef = $DimScaleX;$SplashSize = $DimScaleY}
$SplashSize = [int]($ScaleRef / 2 * 1000);$SplashSize = [Math]::Floor($SplashSize);
$SplashScreen = SplashScreen
if ($GUI_SCALE) {$null} else {$global:GUI_SCALE = 1.00}
if ($GUI_CONFONT) {$null} else {$global:GUI_CONFONT = 'Consolas'}
if ($GUI_FONTSIZE) {$null} else {$global:GUI_FONTSIZE = 'Auto'}
if ($GUI_LVFONTSIZE) {$null} else {$global:GUI_LVFONTSIZE = 'Auto'}
if ($GUI_CONFONTSIZE) {$null} else {$global:GUI_CONFONTSIZE = 'Auto'}
if ($GUI_CONFONTSIZE -eq 'Auto') {$global:CFSIZE0 = 28} else {$global:CFSIZE0 = $GUI_CONFONTSIZE}
#$ScaleFont = $CFSIZE0 * $ScaleRef * $GUI_SCALE
$ScaleFont = $GUI_SCALE / $DpiCur * $CFSIZE0 * $ScaleRef
$ScaleFontX = [Math]::Floor($ScaleFont);$global:CFSIZEX = $ScaleFontX
[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
if ($GUI_BG_COLOR.Length -ne 8) {$GUI_BG_COLOR = 'FF252525'}
if ($GUI_BTN_COLOR.Length -ne 8) {$GUI_BTN_COLOR = 'FF404040'}
if ($GUI_HLT_COLOR.Length -ne 8) {$GUI_HLT_COLOR = 'FF777777'}
if ($GUI_TXT_FORE.Length -ne 8) {$GUI_TXT_FORE = 'FFFFFFFF'}
if ($GUI_PAG_COLOR.Length -ne 8) {$GUI_PAG_COLOR = 'FF151515'}
if ($GUI_TXT_BACK.Length -ne 8) {$GUI_TXT_BACK = 'FF151515'}
$Splash = [Int32]"0x$GUI_TXT_BACK";if ($Splash -ge '-10000000') {$BGIMG = 'Light'} else {$BGIMG = 'Dark'}
ForEach ($i in @("$PSScriptRootX\`$PKX","$PSScriptRootX\`$CAB","$ListFolder\`$LIST","$PSScriptRootX\`$LIST","$PSScriptRootX\`$DISK")) {if (Test-Path -Path "$i") {Remove-Item -Path "$i" -Recurse -Force}}
if (Test-Path -Path "$PSScriptRootX\`$CON") {Remove-Item -Path "$PSScriptRootX\`$CON" -Force}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$form = New-Object Windows.Forms.Form
$form.SuspendLayout()
$version = Get-Content -Path "windick.cmd" -TotalCount 1;
$part1, $part2 = $version -split " v ";$part3, $part4 = $part2 -split " ";
$form.Text = "Windows Deployment Image Customization Kit v$part3"
$WSIZ = [int]($RefX * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($RefY * $ScaleRef * $GUI_SCALE)
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$form.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$form.ClientSize = New-Object System.Drawing.Size($WSIZ,$HSIZ)
$form.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_PAG_COLOR")
$form.StartPosition = 'CenterScreen'
$form.MaximizeBox = $false
$form.MinimizeBox = $true
$form.add_FormClosing({$action = $_
if ($NoExitPrompt) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_RESUME=$GUI_RESUME" -Encoding UTF8}
if (-not ($NoExitPrompt)) {MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Close' -MessageBoxText 'Are you sure you want to close?'
if ($boxresult -ne "OK") {$action.Cancel = $true}
if ($boxresult -eq "OK") {Stop-Process -Id $SubProcessId -Force -ErrorAction SilentlyContinue;Stop-Process -Id $CMDProcessId -Force -ErrorAction SilentlyContinue
Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "GUI_RESUME=$GUI_RESUME" -Encoding UTF8}}})
$form.FormBorderStyle = 'FixedDialog';#FixedDialog, FixedSingle, Fixed3D
$form.AutoSize = $true
$form.AutoSizeMode = 'GrowAndShrink';#AutoSizeMode: GrowAndShrink, GrowOnly, and ShrinkOnly.
$form.AutoScale = $true
$form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$form.WindowState = 'Normal'
;#$form.IsMdiContainer = $true
$PageMain = NewPanel -X '0' -Y '0' -W '1000' -H '666' -C 'Yes'
$PageDebug = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageDebug);$PageDebug.Visible = $false;[VOID][WinMekanix.Functions]::SetParent($PSHandle, $PageDebug.Handle)
$PageSP = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageSP);$PageSP.Visible = $false
$PageW2V = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageW2V);$PageW2V.Visible = $false
$PageV2W = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageV2W);$PageV2W.Visible = $false
$PageLB = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageLB);$PageLB.Visible = $false
$PageLBWiz = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageLBWiz);$PageLBWiz.Visible = $false;
$PageLEWiz = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageLEWiz);$PageLEWiz.Visible = $false;
$PagePB = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PagePB);$PagePB.Visible = $false
$PagePBWiz = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PagePBWiz);$PagePBWiz.Visible = $false;
$PagePEWiz = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PagePEWiz);$PagePEWiz.Visible = $false;
$PageBC = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageBC);$PageBC.Visible = $false
$PageSC = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageSC);$PageSC.Visible = $false
$PageBlank = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageBlank);$PageBlank.Visible = $false
$PageConsole = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageConsole);$PageConsole.Visible = $false;
$WSIZ = [int](1000 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](666 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$Button_W2V = NewPageButton -X '10' -Y '70' -W '230' -H '70' -C '0' -Text 'Image Processing';$Button_W2V.Visible = $false
$Button_V2W = NewPageButton -X '10' -Y '70' -W '230' -H '70' -C '0' -Text 'Image Processing'
$Button_LB = NewPageButton -X '10' -Y '225' -W '230' -H '70' -C '0' -Text 'Image Management';$Button_LB.Visible = $false
$Button_PB = NewPageButton -X '10' -Y '225' -W '230' -H '70' -C '0' -Text 'Image Management'
$Button_BC = NewPageButton -X '10' -Y '380' -W '230' -H '70' -C '0' -Text 'BootDisk Creator'
$Button_SC = NewPageButton -X '10' -Y '535' -W '230' -H '70' -C '0' -Text 'Settings'
#$form.ControlBox = $False
#$form.UseLayoutRounding = $true
#$form.AutoScaleMode = 'DPI';#DPI, Font, and None.
#$form.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$form.AutoScaleDimensions =  New-Object System.Drawing.SizeF(96, 96)
#$form.AutoScaleMode = System.Windows.Forms.AutoScaleMode.DPI
#$form.Add_Resize({[WinMekanix.Functions]::MoveWindow($PanelHandle, 0, 0, $Panel.Width, $Panel.Height, $true) | Out-Null})
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageSP';$Label0_PageSP = NewLabel -X '1000' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text '';$Label0_PageSPX = [int](750 * $ScaleRef * $GUI_SCALE);$Label0_PageSPY = [int](5 * $ScaleRef * $GUI_SCALE);SplashChange
$scrolltimer = New-Object System.Windows.Forms.Timer;$scrolltimer.Interval = 25;$scrolltimer.Enabled = $false
$scrolltimer.Add_Tick({$Label0_PageSP.Left -= 2;if ($Label0_PageSP.Location.X -le $Label0_PageSPL) {$Label0_PageSP.Location = New-Object System.Drawing.Point($Label0_PageSPX, $Label0_PageSPY);
SplashChange}})

$Button2_PageSP = NewButton -X '225' -Y '585' -W '300' -H '60' -Text 'About' -Hover_Text 'About' -Add_Click {MessageBoxAbout}
#$ButtonTest_PageSP = NewButton -X '50' -Y '585' -W '150' -H '60' -Text 'TEST' -Hover_Text 'About' -Add_Click {$null}
#$ButtonReload_PageSP = NewButton -X '550' -Y '585' -W '150' -H '60' -Text 'RELOAD' -Hover_Text '' -Add_Click {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\windick.cmd";$NoExitPrompt = 1;$form.Close()}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageW2V';$Label0_PageW2V = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🔄 Image Processing|WIM" -TextAlign 'X'
$ListView1_PageW2V = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageW2V.Columns.Add("X", $WSIZ)
$Button1_PageW2V = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Convert' -Hover_Text 'Start Image Conversion' -Add_Click {$halt = $null
if ($($DropBox1_PageW2V.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No wim selected.'}
if ($halt -ne '1') {
ForEach ($i in @("","ARG1=-IMAGEPROC","ARG2=-WIM","ARG3=$($DropBox1_PageW2V.SelectedItem)","ARG4=-INDEX","ARG5=$($DropBox2_PageW2V.SelectedItem)","ARG6=-VHDX","ARG7=$($TextBox1_PageW2V.Text)","ARG8=-SIZE","ARG9=$($TextBox2_PageW2V.Text)")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

$Label1_PageW2V = NewLabel -X '100' -Y '410' -W '175' -H '30' -Text 'Source Image'
$DropBox1_PageW2V = NewDropBox -X '25' -Y '445' -W '300' -H '40' -C '0' -DisplayMember 'Name' -Text 'Page 1'
$Label2_PageW2V = NewLabel -X '500' -Y '410' -W '175' -H '30' -Text 'Source Index'
$DropBox2_PageW2V = NewDropBox -X '425' -Y '445' -W '300' -H '40' -C '0' -DisplayMember 'Description'
$Label3_PageW2V = NewLabel -X '100' -Y '490' -W '175' -H '30' -Text 'Target Image'
$TextBox1_PageW2V = NewTextBox -X '25' -Y '525' -W '300' -H '40' -Check 'PATH'
$Label4_PageW2V = NewLabel -X '485' -Y '490' -W '205' -H '30' -Text 'VHDX Size (GB)'
$TextBox2_PageW2V = NewTextBox -X '425' -Y '525' -W '300' -H '40' -Check 'NUMBER'
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageV2W';$Label0_PageV2W = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🔄 Image Processing|VHD" -TextAlign 'X'
$ListView1_PageV2W = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageV2W.Columns.Add("X", $WSIZ)
$Button1_PageV2W = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Convert' -Hover_Text 'Start Image Conversion' -Add_Click {$halt = $null
if ($($DropBox1_PageV2W.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No vhdx selected.'}
if ($halt -ne '1') {ForEach ($i in @("","ARG1=-IMAGEPROC","ARG2=-VHDX","ARG3=$($DropBox1_PageV2W.SelectedItem)","ARG4=-INDEX","ARG5=$($DropBox2_PageV2W.SelectedItem)","ARG6=-WIM","ARG7=$($TextBox1_PageV2W.Text)","ARG8=-XLVL","ARG9=$($DropBox3_PageV2W.SelectedItem)")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

$Label1_PageV2W = NewLabel -X '100' -Y '410' -W '175' -H '30' -Text 'Source Image'
$DropBox1_PageV2W = NewDropBox -X '25' -Y '445' -W '300' -H '40' -C '0' -DisplayMember 'Name'
$Label2_PageV2W = NewLabel -X '500' -Y '410' -W '175' -H '30' -Text 'Source Index'
$DropBox2_PageV2W = NewDropBox -X '425' -Y '445' -W '300' -H '40' -DisplayMember 'Description'
$Label3_PageV2W = NewLabel -X '100' -Y '490' -W '175' -H '30' -Text 'Target Image'
$TextBox1_PageV2W = NewTextBox -X '25' -Y '525' -W '300' -H '40' -Check 'PATH'
$Label4_PageV2W = NewLabel -X '485' -Y '490' -W '205' -H '30' -Text '   Compression'
$DropBox3_PageV2W = NewDropBox -X '425' -Y '525' -W '300' -H '40' -C '0' -DisplayMember 'Description'
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageLB';$Label0_PageLB = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🧾 Image Management" -TextAlign 'X'
$Label1_PageLB = NewLabel -X '85' -Y '535' -W '175' -H '30' -Text 'Reference'
$DropBox1_PageLB = NewDropBox -X '215' -Y '530' -W '325' -H '40' -C '0' -DisplayMember 'Name'
$ListView1_PageLB = NewListView -X '390' -Y '90' -W '335' -H '420';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageLB.Columns.Add("X", $WSIZ)
$ListView2_PageLB = NewListView -X '25' -Y '90' -W '335' -H '420';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView2_PageLB.Columns.Add("X", $WSIZ)
$Button1_PageLB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🏁 List Execute' -Hover_Text 'List Execute' -Add_Click {LEWiz_Stage1}
$Button2_PageLB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🏗 List Builder' -Hover_Text 'List Builder' -Add_Click {LBWiz_Stage1}

$Button3_PageLB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '✏ Edit List' -Hover_Text 'Edit List' -Add_Click {
$FilePath = "$ListFolder"
$FileFilt = "List files (*.base;*.list)|*.base;*.list";PickFile
if ($Pick) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$Pick"}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PagePB';$Label0_PagePB = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🗳 Image Management" -TextAlign 'X'
$ListView1_PagePB = NewListView -X '25' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PagePB.Columns.Add("X", $WSIZ)
$ListView2_PagePB = NewListView -X '390' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView2_PagePB.Columns.Add("X", $WSIZ)
$Button0_PagePB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🏁 Pack Execute' -Hover_Text 'Pack Execute' -Add_Click {PEWiz_Stage1}
$Button3_PagePB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🏗 Pack Builder' -Hover_Text 'Pack Builder' -Add_Click {PBWiz_Stage1}
$Button4_PagePB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '✏ Edit Pack' -Hover_Text 'Edit Pack' -Add_Click {
if (Test-Path -Path "$PSScriptRootX\project\package.list") {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PSScriptRootX\project\package.list"}
if (Test-Path -Path "$PSScriptRootX\project\package.cmd") {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PSScriptRootX\project\package.cmd"}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageBC';$Label0_PageBC = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "💾 BootDisk Creator" -TextAlign 'X'

$ListView1_PageBC = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageBC.Columns.Add("X", $WSIZ)
$Button1_PageBC = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Create' -Hover_Text 'Start BootDisk Creation' -Add_Click {$halt = $null;$nullx, $disknum, $nully = $($DropBox3_PageBC.SelectedItem) -split '[| ]'
if (-not (Test-Path -Path "$CacheFolder\boot.sav")) {
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Import Boot Media' -MessageBoxText 'Boot media needs to be imported from a windows .iso before proceeding.';if ($boxresult -eq "OK") {ImportBoot}}
if (-not (Test-Path -Path "$CacheFolder\boot.sav")) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No boot media.'}
if ($($DropBox1_PageBC.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No vhdx selected.'}
if ($disknum -eq 'Disk') {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No disk selected.'}
if ($disknum -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No disk selected.'}
if ($halt -ne '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Erase' -MessageBoxText "This will erase Disk $disknum. If you've inserted or removed any disks, refresh before proceeding. Are you sure?"
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {ForEach ($i in @("","ARG1=-BOOTMAKER","ARG2=-CREATE","ARG3=-DISK","ARG4=$disknum","ARG5=-VHDX","ARG6=$($DropBox1_PageBC.SelectedItem)","PE_WALLPAPER=$($DropBox2_PageBC.SelectedItem)")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}}

$Label1_PageBC = NewLabel -X '100' -Y '410' -W '175' -H '30' -Text 'Active VHDX'
$DropBox1_PageBC = NewDropBox -X '25' -Y '445' -W '300' -H '40' -C '0' -DisplayMember 'Name'
$Label2_PageBC = NewLabel -X '500' -Y '410' -W '210' -H '30' -Text 'PE Wallpaper'
$DropBox2_PageBC = NewDropBox -X '425' -Y '445' -W '300' -H '40' -DisplayMember 'Description'
$Label3_PageBC = NewLabel -X '315' -Y '490' -W '175' -H '30' -Text 'Target Disk'
$DropBox3_PageBC = NewDropBox -X '25' -Y '525' -W '700' -H '40' -Text 'Select Disk'
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageSC';$Label0_PageSC = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🛠 Settings" -TextAlign 'X'
$GUI_SLIDE = [int](100 * $GUI_SCALE);
$Slider1_PageSC = NewSlider -X '300' -Y '120' -W '225' -H '60' -Value "$GUI_SLIDE"
$LabelX_PageSC = NewLabel -X '290' -Y '85' -W '585' -H '35' -Text "GUI Scale Factor $($Slider1_PageSC.Value)%"

$Button1_PageSC = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🛠 Console Settings' -Hover_Text 'Console Settings' -Add_Click {ForEach ($i in @("","ARG1=-INTERNAL","ARG2=-SETTINGS")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
#$TextPath = "$PSScriptRootX\`$CON";$TextWrite = [System.IO.StreamWriter]::new($TextPath, $false, [System.Text.Encoding]::UTF8);#$TextWrite.WriteLine("x");$TextWrite.Close()
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}

$Button2_PageSC = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🐜 Debug' -Hover_Text 'Debug' -Add_Click {
[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 2);[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 1);#0=Hidden,1=Normal,2=Minimized,3=Maximized
$WSIZ = [int](1000 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](575 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE);$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$PageDebug.Visible = $true;$PageMain.Visible = $false;$PageSC.Visible = $false;$PageDebug.BringToFront()
[VOID][WinMekanix.Functions]::MoveWindow($PSHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)}
$Button3_PageSC = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🔄 Switch to CMD' -Hover_Text 'Switch to CMD' -Add_Click {ForEach ($i in @("","GUI_LAUNCH=DISABLED")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRootX\windick.cmd";$NoExitPrompt = 1;$form.Close()}

$GroupBoxName = 'Group1';$GroupBox1_PageSC = NewGroupBox -X '20' -Y '85' -W '260' -H '75' -Text 'Console Window'
#if ($Button_SC.Tag -eq 'Enable') 
$Add_CheckedChanged = {if ($ButtonGroup1Changed -eq '1') {if ($ButtonRadio1_Group1.Checked) {
ForEach ($i in @("","GUI_CONTYPE=Embed")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}}}
$global:ButtonGroup1Changed = '1';}
$ButtonRadio1_Group1 = NewRadioButton -X '15' -Y '30' -W '120' -H '35' -Text 'Embed' -GroupName 'Group1'
$Add_CheckedChanged = {if ($ButtonGroup1Changed -eq '1') {if ($ButtonRadio2_Group1.Checked) {
ForEach ($i in @("","GUI_CONTYPE=Spawn")) {Add-Content -Path "$PSScriptRootX\windick.ini" -Value "$i" -Encoding UTF8}}}
$global:ButtonGroup1Changed = '1';}
$ButtonRadio2_Group1 = NewRadioButton -X '135' -Y '30' -W '120' -H '35' -Text 'Spawn' -GroupName 'Group1'
if ($GUI_CONTYPE) {$null} else {$GUI_CONTYPE = 'Embed'}
if ($GUI_CONTYPE -eq 'Embed') {$ButtonRadio1_Group1.Checked = $true}
if ($GUI_CONTYPE -eq 'Spawn') {$ButtonRadio2_Group1.Checked = $true}

$Label2_PageSC = NewLabel -X '25' -Y '165' -W '585' -H '35' -Text 'Console Font'
$DropBox1_PageSC = NewDropBox -X '25' -Y '200' -W '190' -H '40' -C '0' -Text "$GUI_CONFONT"
$Label3_PageSC = NewLabel -X '25' -Y '250' -W '585' -H '35' -Text 'Console FontSize'
$DropBox2_PageSC = NewDropBox -X '25' -Y '285' -W '190' -H '40' -C '0' -Text "$GUI_CONFONTSIZE"
$Label4_PageSC = NewLabel -X '25' -Y '420' -W '585' -H '35' -Text 'ListView FontSize'
$DropBox3_PageSC = NewDropBox -X '25' -Y '455' -W '190' -H '40' -C '0' -Text "$GUI_LVFONTSIZE"
$Label5_PageSC = NewLabel -X '25' -Y '335' -W '585' -H '35' -Text 'GUI FontSize'
$DropBox4_PageSC = NewDropBox -X '25' -Y '370' -W '190' -H '40' -C '0' -Text "$GUI_FONTSIZE"
$Label6_PageSC = NewLabel -X '25' -Y '505' -W '585' -H '35' -Text 'GUI Appearance'
$DropBox5_PageSC = NewDropBox -X '25' -Y '540' -W '190' -H '40' -C '0' -Text ""
#$Add_CheckedChanged = {if ($Toggle1_PageSC.Checked) {$GUI_CONTYPE = 'Spawn';$Toggle1_PageSC.Text = "Enabled";} else {$GUI_CONTYPE = 'Embed';$Toggle1_PageSC.Text = "";}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageConsole';$Button1_PageConsole = NewButton -X '350' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
$PageMain.Visible = $true;$PictureBoxConsole.SendToBack();$PictureBoxConsole.Visible = $false;$PageConsole.Visible = $false
if ($Button_LB.Tag -eq 'Enable') {Button_PageLB}
if ($Button_PB.Tag -eq 'Enable') {Button_PagePB}
if ($Button_BC.Tag -eq 'Enable') {Button_PageBC}
if ($Button_SC.Tag -eq 'Enable') {Button_PageSC}
if ($Button_V2W.Tag -eq 'Enable') {Button_PageV2W}
if ($Button_W2V.Tag -eq 'Enable') {Button_PageW2V}
Write-Host "Stopping console PID: $CMDProcessId conhost PID:$SubProcessId";Stop-Process -Id $SubProcessId -Force -ErrorAction SilentlyContinue;Stop-Process -Id $CMDProcessId -Force -ErrorAction SilentlyContinue}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageDebug';$Button1_PageDebug = NewButton -X '350' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {$PageMain.Visible = $true;$PageSC.Visible = $true;$PageDebug.Visible = $false}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageLBWiz';$Label1_PageLBWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "" -TextAlign 'X'

$Label2_PageLBWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'
$Button1_PageLBWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($LBWiz_Stage -eq '1') {$global:LBWiz_Stage = $null;$global:marked = $null;Button_PageLB}
if ($LBWiz_Stage -eq '2') {
if ($LBWiz_Type -eq 'MENU-SCRIPT') {if ($REFERENCE -ne 'LIVE') {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH}}
if ($ListMode -eq 'Builder') {LBWiz_Stage1}
if ($ListMode -eq 'Execute') {LEWiz_Stage1;$global:LBWiz_Stage = $null;$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront();return}}
if ($LBWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;LBWiz_Stage2}

if ($LBWiz_Type -eq 'MENU-SCRIPT') {if ($LBWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LBWiz_Stage3GRP}
if ($LBWiz_Stage -eq '5') {LBWiz_Stage4GRP}}
if ($LBWiz_Type -eq 'MISC') {if ($LBWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LBWiz_Stage3MISC}
if ($LBWiz_Stage -eq '5') {LBWiz_Stage4MISC}}}

$Button2_PageLBWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($LBWiz_Type -eq 'MISC') {
if ($LBWiz_Stage -eq '4') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage5MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '3') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage4MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '2') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage3MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
if ($LBWiz_Type -eq 'MENU-SCRIPT') {
if ($LBWiz_Stage -eq '4') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage5GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '3') {if ($ListView1_PageLBWiz.CheckedItems) {$global:marked = $null;LBWiz_Stage4GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '2') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage3GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
if ($LBWiz_Stage -eq '1') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}

$ListView1_PageLBWiz = NewListView -X '25' -Y '135' -W '950' -H '425';
$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageLBWiz.Columns.Add("X", $WSIZ)
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageLEWiz';$Label1_PageLEWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🧾 List Execute" -TextAlign 'X'
$Label2_PageLEWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'

$Button1_PageLEWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($LEWiz_Stage -eq '1') {$global:LEWiz_Stage = $null;$global:marked = $null;Button_PageLB}
if ($LEWiz_Stage -eq '2') {LEWiz_Stage1}
if ($LEWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;LEWiz_Stage2}
if ($LEWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LEWiz_Stage3}
}
$Button2_PageLEWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($LEWiz_Stage -eq '2') {if ($ListView1_PageLEWiz.SelectedItems) {$global:marked = $null;LEWiz_Stage3} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LEWiz_Stage -eq '1') {if ($ListView1_PageLEWiz.SelectedItems) {$global:marked = $null;LEWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
$ListView1_PageLEWiz = NewListView -X '25' -Y '135' -W '950' -H '425';$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageLEWiz.Columns.Add("X", $WSIZ)
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PagePBWiz';$Label1_PagePBWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text '' -TextAlign 'X'
$Label2_PagePBWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'

$Button1_PagePBWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($PBWiz_Stage -eq '1') {$global:PBWiz_Stage = $null;$global:marked = $null;Button_PagePB}
if ($PBWiz_Stage -eq '2') {PBWiz_Stage1}
if ($PBWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;PBWiz_Stage2}}
$Button2_PagePBWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($PBWiz_Stage -eq '3') {if ($ListView1_PagePBWiz.SelectedItems) {$global:marked = $null;PBWiz_Stage4} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($PBWiz_Stage -eq '2') {if ($ListView1_PagePBWiz.SelectedItems) {$global:marked = $null;PBWiz_Stage3} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($PBWiz_Stage -eq '1') {if ($ListView1_PagePBWiz.SelectedItems) {$global:marked = $null;PBWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}

$ListView1_PagePBWiz = NewListView -X '25' -Y '135' -W '950' -H '425';# -Headers 'NonClickable';#$WSIZ = [int](470 * $ScaleRef * $GUI_SCALE);#$ListView1_PagePBWiz.Columns.Add("Item Name", $WSIZ);#$ListView1_PagePBWiz.Columns.Add("Description", $WSIZ)
$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PagePBWiz.Columns.Add("X", $WSIZ)
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PagePEWiz';$Label1_PagePEWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🗳 Pack Execute" -TextAlign 'X'
$Label2_PagePEWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'

$Button1_PagePEWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($PEWiz_Stage -eq '1') {$global:PEWiz_Stage = $null;$global:marked = $null;Button_PagePB}
if ($PEWiz_Stage -eq '2') {PEWiz_Stage1}
if ($PEWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;PEWiz_Stage2}}

$Button2_PagePEWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($PEWiz_Stage -eq '2') {if ($ListView1_PagePEWiz.SelectedItems) {$global:marked = $null;PEWiz_Stage3} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($PEWiz_Stage -eq '1') {if ($ListView1_PagePEWiz.SelectedItems) {$global:marked = $null;PEWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
$ListView1_PagePEWiz = NewListView -X '25' -Y '135' -W '950' -H '425';$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PagePEWiz.Columns.Add("X", $WSIZ)
#$FilePath = "C:\gif.gif";$FileContent = Get-Content -Path "$FilePath" -Encoding Byte;$Base64Out = [System.Convert]::ToBase64String($FileContent);Write-Host "$Base64Out"#Convert
#77u/RVhFQy1MSVNU
#$NewBlankList = [Convert]::FromBase64String($EmptyNoneList);[System.IO.File]::WriteAllBytes($ListTar, $NewBlankList)
[string]$EmptyList=@"
77u/
"@
[string]$logo2=@"
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
"@
[string]$logobar=@"
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
"@
[string]$splashjpg1=@"
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wRwbuvLWADxHQn3hdDolTSIgRARARARARARARARARARARARARARARARARARARAUg0L/whaa/7Vpf861BMtrsD4NqF6DhgSOilb4gxMH2tKhDQC9oPInCJXdYa2On0Tb6yd+I4qFj3uJ7AwZ+xVnZLbU671zDSva/NdUb85A/NxfO5DhhoDc9679Xb4KVV+jr8d7f73fX0EEVLTx08LAyKJgYxjeTWgYAC7FwO9X2s2updpmg7gHYaZ6mleO/fj4fYrBQEQV1s9kdp7Ud/wBE1L/97TGvt5P9JTyuyfE7rjgnxVioK025ybmgImf1lwgafeT9yo3d4K34Z2squIz1q522nbWantdM9m+wSOleCOGGg8/atxfLZbnXORraKnaGgA7rAOPPsXn+L5rRr5rWfJ7L2Y0mPLo/xI85az8T2/OfRY/itXDCyK4VscbQ1jXgADs4LdwnJa+piJR7T6TFg0cTjjbq7KmQQ00kh4hrSV9P7PbQbHoCy0LmbsjaZsko+u/ru+LirXiU/FWHk+Hx8MykyKtWAvPXV1LbaKasrZ44KaFu9JLI4Na0eJKCqbHrBtbrm46sgsN7lslVTRUMdVHSh+HMcS5xa1xJZx5gFb3UO1rTlFp+vntlwbU3KNrooaXo3tk6UjDcscAcZxxwg3Wz/TjtMaPo6Kcl1bIOnq3niXTP4uye3B4exSdARARARB8d2isjotdCrBxHFV1Eme4ASqOsOWNJznAznv7fvWER8cz9P1YxX45n0j9Uh0Rb33TW9ko24+UrYnOz2NYekPwYV69uVZNVbWLrHJJvMpmQRRDA6reia4j9pzjx71mzlXSIgRARARARARARARARARARARARARARARARARARARAXvslyNmv1uurYhK6iqoqgRl2N/ccHYz2ZwgtjbpCI9opd/W0MD/70jfuVZA4IKJhLblfv9z6z2qM/KStImH1I3loHtIB8gVauwfSgpLRUalqY/l6zMNMSOULTxcP0nD3Natua3NMekQ0YactZ9Zn7rjRam5X21djoaLTdza/cFDfKaR5H0HEtP2qwUBEFd7SYpLFcbLrmnDj+KphDXNb86lkOHcBzwSCrBikZNEyWNwdG9oc1w5EHkUFV7eiTpazsycOurMjvxHIVTmOAVzwuPhsqOJT8VWy0fD02qaqbsp6YNHm93+peusf0tbNJ9J5/wXk+J25tff0fRfZmnLoKz83RhR9g/wAq3D+0H2Lt4J/yo+jl9rv+FH1eqkt5u96tdqDHP9NrIoXBv0C7Lv7uV9ctaGtAAwBwAVnxCd823yeP0MbYd2UXE7Eb1bre06PpWOrXumrJuFPRQDemmPg0dnioNBpi/a/ro7jrHMVKw71LZYX/ACUXc6U/Od/78EFp2+hZQUwhjDWj6LRho4cgO5V1cqGn17tYjpXx5tmmGNlne0YMtW4gtYTjiGgZ88oLPRARARAXVVTNp6Sad3qxsc857gMoPh4Oc7Dyes4bxPeTxP2lZCMlk7EKBtZtGhmc0n0KllnHc1x3WD4Pcqv1Hcorzqe7XSFj2RVtbNUMa/G81r3lwBx24KMZaxEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEF8fhA0obqm01YxmWhcw+O6/8A21UBRMNnpyyVGo9Q0NopciWrlDC8fMbzc72NBPsC+y6Cip7bb6ehpIxHT08bYomDk1rRgBCXoREIRtdo3VmzC87ji2SBjKhpHMFjw77lLbbVCttdJVtOWzwskB82goPUiDy3O3092tdVb6pgfT1MTopGnta4YKhmy6vqIbRVaWub/wDKdhlNKQ4YMkH9FIB9Et4exBo9u/Gy2Fnfcc+6J6qHd4K84VH4dpU3EvHVutEtDKC7V5H5yctB7wxv+JXDHivD6q3Nq8tvV9R4JTk0WOPQwo6wf5WuP9oPsVrwL/lR9FV7X/8ABj6ppsot/wCMNp9NIQSy30stSe7ePybf3nL6OVhrLb57PKaSNsNWHuaxhe9wa1oySTgAKsrztCuF/r5LLoNjJXxndqbxK0GCn48dzPB7veOIXM6Gy01oCmoK192rpZq66yj5S4VRzI7waDwYPIKcxRMhZuRtDW9yDVaqv8Gl9MXC81GN2liLmtJxvv5Nb7SQFp9mlgmsWkIn13G53F5rq1xGCZZOsQfEcAgmCICICICi20i5C1bOr9Vb5Y40j4mEc99/Ub8XBB8hYAOG+qOA8lkIyW7sjNRaNJa31JAGCakoS2nLhkb7I3y8R2jixUQjERARARARARARARARARARARARARARARARARARARARARBde02F35AbOagDq/ilsR8+ihd/CVVpRML32BaWMcNZqepZgyZpaTP0QflHe1wDf1SrvRAiDXagtwu+nLnbTyqqWSH9ppH3qP7K7iLlszscga5roaf0Z4dz3oyWH91BMUQFXGtx+S2trFrSMYpZHC2XPu6N56jz2Ddd9yDUbdZA6i02GkFrqx7gRyPyZ/xVTSvEcL3nk1pKvOGTthvP+9lPxCN8tY/3ukVhiNLoOm3vWnaZD+u7P2Lo3V4C1t8t5n5y+tcPry6akekfY3VG2D/K9z/tR9gV3wGf3v8AJQe1/wDwY+q3NhFBvflDdych88dIzwDG7x+LwrfqamKjpZamd4ZFE0ve49gHNduaebJafV5jFG2Oseio5pb7tTkzI+W2aTLiI4IT8vXtzzcfmsPLCsix6dorJRQ01NBHDDEAI4oxgN8T3nxWpsblEFca2B1TruwaPjLjTQH8aXLH9Ww4jaezi77lY6AiAiAiAqj2/XgUulKC1Mk3ZK2qD3DvjjG8f7xYg+dQuQRktGVtNaPwZa50znNlvNxAi4E7zmytwPAbkDjx7vFUmjERARARARARARARARARARARARARARARARARARARARAWy0/Yq3Ut+o7NbmtdVVcm4zfOGt4ZLie4AEnnwHagt/bFfLWxlr0da4XmOxgMdK48sR7rYx3kAgkqraSJtVVQxekRQtkkbGZ5HdSPJA3nHuGcnwCJfZmnKW3UOnbfSWmWOWghgayGSN4cHNA55HPPNbRECICr7ZO90Nu1Ba3sLDQXupia0/RJDh9qCwUQFXuvg6+6q0xpaMOMclQa+rweAii5B3gScII9t2Aa3S7GjAFRNgfqBVDdXEW2VrR1ngRt8ycK40duXSZJ+v2Veqjm1WOPp908rom0tso6NuAGNa3Hg1uFrd3wXz6k77y+u4K8uOIYLVGN4Mut1d3SD91X3AZ21W/pLzXtdG+irH9UPoXZBb/QNmtse4YfV79W79dxI+GFM6ylirqGopJ2h0M8bontPItcMEe4rsmd53eajshWx2qfPs2oIJXb0lFJNSuOCPUkIHA8Rwwp4oSLhLKyGJ8sjg2NjS5zjyAHMoK+2XxSXeW960qWnfvVSRTb2QW00ZLWDB5csqxEBEBEBEBfMm3K9m5a8fRxkuittO2EDHAyO67v4B7EEDvNCLbdp6EEOdTbsbyO14aN74kj2LxB251yMho3iPALGs71iWS0trjpbJso0Npx8LQ58YqJXA+q+OMAj2mZ3uVJLJiIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgKf7E/+F6xf/mP8xIg7KiGnm2pSQVsbZKd98eyZjuTmmoIwfDGPYr9vGhdM3tgbV2ena9ow2Wnb0UjfJzcfHK4NXktjvWYdOGsWrMSgkuzDU2l6l1bofUEvPeNLK5sT3H3GN58wF7qDbRebBXNt2t7BLDJkjpoIyx7uPPcJ3XebXFdOHNGSu8NN6TWdlnWDWmntTR5tV1p55O2Eu3ZW+bDxHuW+W5gKv8ASwdb9rWs7fv/ACNUymro2Y5EtLXn3gILARBwllZBC+WRwZGxpc5x5ADmVAtAwC+3u8a1mhGKyQ01ve7O8KZh5+TnDPsQR3bv62mP/iJ/3AqoEPpd5tVJ2SVTXO8m9b7lYVvycPy2/wB7OOK8/EMVfp901uzt6pa3ub9q8GF4Wk/C+sU6VhghQu4l3pV4YwEyPlbGwDmXEAAe9XXBrbZrT6S837URvpqR/VD67s9BHarLQ2+IAMpaeOFoHc1oH3L2qweXV9s8LaDVGuLIHH5G6+mNaTybOwO4eGQrBQFBdq9wni0myzUR/n98qGW+Dqk4Dz13cO5ufegl1qtsFntFHbaVu7BSwthYPBowvYgIgIgIg81xroLZbaqvqXhkFNE6aRx7GtGT9i+T9KwS6t2kU9TV8Omq33CqOMhrWnpCDnszusWrNblx2t6SmO6N11Y+4XCprntw6pmfOR3b7i771zttI2vudJRueGNqJ44XOJxgPeGn4FbKxtEQJh+EFWU1RtHipqd5c6ht8NPMC0jddl7wPHqvaeHeqqUoEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQFY2w2jnqNqlvqY2gw0UM89Q8uADI+jczPE8es9o4d/cCg6NXVceo9oNzqLLDJIKutPozYeL5CAG7zcdri0uHmFb2itp9Fd4o7ZfJBQ3dh6Iul6jJnDhwz6r+9p45XJrMU3pvHeG/DflnaVhrrqqelulOaK40cFbTP4GKdgcPiqvFktS3R1XpFo6q+1Dsa0tVOL7VVVdumA6rWHpo2nOeAdxH6rgtXom8X3RO0mLTF6uU9bb69oZDJLI5zQ4+o5m8SRxBYRnmQrXDqa3tyOW+C1a80r4VfVTDQ7eKCbfIZcrLJDu9hdHIHfYV1NCwUQQzaTc6qCwMs9rJN1u8gpacAeqCeu7uGG55qT2m3xWm0UlvhGI6eJsY49wQVTt39bTH/wARP+4FWunYvSNYxnHCmpnv8i4gBbtRfl4Zk9ZY6OnNxTEklad+skPjhefdXjY7Pp8doCFH7BQm57T6K3g8JbpFI/xbGN8/BqteFW2yW+jz3tHG+Cn1fWCK3eTQClxbNuFwjeMi8WmOZhb2OicWkO9hGCp+gKuYx+VG2mSQ5dQ6YpdxvAgelS8+Pg0ILGRARARARBV23PULbXoxtpjkAqbpKIy0HB6FvWefI9Vv6yrXQtE61aA1Zqh+GyGkfR0zyOIOOsR5ucwfqLl1c7Y9vnMR/eGVVa4DTut9UcB5BTXZRQG4bS7M3c3mwyPqHeAYx2P7xaupCPbUbm67bTtQ1LoxGWVjqfAOciLEQPtDM+1RFECICICICICICICICICICICICICICICICICICICICILR2cbO7ZcLNLrLVtUKbTtLI5nQOY8OqsNIyHNIOA8tA3d4uLXN4Y472o2g6SsmkrtaNE6frbXUXEbj6iV4J3TwJ3jI54IaXbo5AkntOQbEbXbjqGovtyqqWnjoG9HTMmla3MrxxIBPzWcP1laGq9CaP1u90/pVPT3J3D0qklZvP8Ht5P8AbxQQKawbTNnZ/wAmym92lmSI2tMoDR9QnfZ5NLgpZojXMOsrfPL0ApayncBLC2TeBafVc04BweI8wVXazTxEe8q7NPl3nllJHuUI2k6bOoNPmenYTX0OZYd3gXtx12e0DI8QFwYL8mWLO7JTmxzCTbJNZnVek2RVUu/cqDEM7nHjK3HUk9o5+IK4bQOjodZ6EvDzu9Hcn0ZP9tGQPiF6BSrCRBXlsLtTbW7hXuw6hsMIpIe4zP4uPmBwVhoKd28D/wCzB/8AxM37gUC0RHv1l3rDy32Qt9gyftWHEb7cNtHzs6eE05uJ1n5RLaP6zi48ycrG74Lym76Kxu+C57KbeKvbHWVBZn0KCWXPYC4MYPg56tOGfxJ+jz/tF/Ap9f0fRSK6eRV/rDeodp+hri1wayaSpoZcjmHsBaPeFYCDxXe5Q2azVtzqDiGlhfM/yaMqJ7KbbUUujhc65uK+8zvuM5yT+c4tHHl1cIJyiAiAiAiD5b2w6gdqDaDPTU5MsFvAo4WNOd6TOX+0vw39VS3XtE3Sex23WJmHSSTQxSEfOeCZXu9rmn3rg1c75cVPnO//AIzr2lSIVsbCaeKHUF4vNTO2Gmt9vzI95Aa0PcSSSeQAiJXexlRqIgRARARARARARARARARARARARARARARARARARARAXdR0k9fW09FSxmWoqJGxRRjm57jgD2khBd+22qFvqbFpKjLmW620Ub2sLs5J3o2Z7y1jHftL06R2RWe76YoblcqysNRVxCYsp5GtZG13EN5HjjmufUZZx13htxVi09W4dsO0q4kmruo/+ZEftjK4O2EaakBbBdblG/HAyRwuA88MC56a3edphstg26w08lNtB2ZH0m23N15s8RG/E4Oe0N8Y3EuYPFjuHaFEqbWNBateR6htcEtNR1YDq6jc7e3N4/KBrvnNzh7T4kYC6YvXPjmIYcs4rxMr8bMyaJksTw+N4DmuHIg8iF1OcqCY2leUjeFS1kjtmm02lvcAe201bnOkaziN0/nGeOM7w8z3K0trM8B0LR3drw+npLjR1gkafmdIBkHycvQ4L8+OLKPUU5Mk1WC1wc0OByCMhZW1pVxYydM7WbtZ3AijvMQraYnkJG8HhWOgqDbyQ2k048nlVyf5sqE6Oj6HSXTkYdUSSSn2nA+AC4uK320kV+dlrwKm+tm3yj9Xt3Qm6F5vd7ljCk+xejaL7qu5OcA180VMzzaC537zVa8K/iW+jz/tF/Ap9f0XEsOc1jS5xDWtGSScABXjyKs9MMdr/W82sKgE2a2OfS2ZvZI7OHzfDA/1KzUFe7VZX3Gks2koH4mvtcyKQB2CIGHfkPwCn8UTIIWRRtDY2NDWtHYBwAQc0QEQEQFpdW36PTOlbleJMZpoS6Np+dIeDG+1xAQfNmy+zSah17BUVJM0dITW1D3cd5+er7S8736qlO3etJqLLQB+A1ktQ5veeq1v2uVXktza+lflH+WceFT4Vs6OfDZdhWtrxNC8ir3qNpbjJ3mNiB8g+Q58AVaMZUWiIEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQFaGwOhp6jaO6tndI38W0E1UwMIwT1YznhxG7I49nEBBr6ZldtG163pZi2oucxke88eiiAzgfosAaPFWFJsfvFolfNpjVD4HEhwZJvQknxczqn2tXLnz1pbktHRvx45mOaHF132saZBNdbBdqZrsdI2ITZH6UWHe9q91n2z26pqfRbzQzWuXO66TPSMafrDAc32hc+TTUvHNjlspmms7XWDFVQ1UDJ6eVksMg3mSRuDmuHeCFXesNmNBd3SV1o6OhrzlzowMQynxA9U+I9q48Ga2G/3dt8UZadHk0HqGe1Fmkb/HJSV0BIpOl5SM7GA9uOzsI8lP3uUaqu1947T1b9LO9Np7wj+q7HHqKxTURwJx8pTvPzJBy9h4g+BKjej71NqPZjqHQ1aD6dR0khpWO5lrDkN/VcAPLC7uHX3pNfk4uI49rRf5rn0ZdhfNF2e5YwZ6SNzhnOHAYd8QVvVYq1ANqdDNDa6HU1E0+mWSoE+WesYScSDPdjjjwU2t9dBcrdT1tM8PgnjEjHDtBCCpPwhSWWCyyjm2rf/m3KP0lP6Dp2hpe1kLGn3ZKqeLW+ClfV6D2frvmtb6OtFSPYBIAz3KVbKqbotGemBzibhWT1JBGMdbcHwYD7VccIjraXl/aS3THH1Tpk8sZBZI4Y5cVD9dX6uuhptE0Ex9NuuDUytHGClBO+4+JxgcO9Xezyye2GOgtlrpLVRMEMFNGIomE9g4Dj2lbdYpV3aM6i2yXi5nedSWGmbb4OW6Zn9aQjxA6qsRARARARAVI/hAah3Ke2acgk60rvS6hoPHdHVjHtdvH9RB69jFi/Fukn3ORoE1yk32nGD0TctZ7+s79ZVzthrhWbQamIZxSU8MGfHBef84FTaafea69vlv8ApDZPhQVoyQO8qz9Xzvsn4O+nLcKprJrtU+kyRADMkR3pT7A4xcRjsVywlSiIgRARARARARARARARARARARARARARARARARARARAVy/g6Usz9VXqsdG30CK3GKeV26N1z3tLRnnghj+XDhx7EELlmFo1W+XTlVK9tNVH0Gdjes9ucM4duQd3HzvaresW2e3SsNLqGlmoa2Lqyviic+MuBwctHXYcg8COC5dVg97G8d2/Dk5ekpla9Y2C9VIhtd3pqioLS4Rxvw/A58Oa4ap05adWwtjudK10kYxFOzqyx+Tufs5Ksi+TBO3Z2xSuXqquo09q7Z3O+rsVU6vtm9vPiDN4Y+vH/ABM9ylGmtpVpv+5BUEUFc7gI5HZZIfqP5HyPFb8uOuenvad/MxXnDb3d+3k3l7s1vvtIKe4QB4ad6ORvVfG7sLXDiCuFvZWU1N6NWTipdHwZUcnSN7N4fS7yOB58M4XFN5mnJPksa49r80ebvc9V7qCD8mddWrVUJeylkqGsrdzuPB3sczI8wFv0N+XLt82vX4+fDM/JZmx6aKDRc9rbJvfiy41NJzzwDy4fBwU/6Znerx550VsVPXUM9JMA6KaN0bgRkEEYUK2TVcsOnqnTtWXemWWpfTPLuG83OWkDsGPNBqdu1KKnT1l3vVFzja7ycC0/aozXnBYwdmT9ypeLbzNI+r03s9EfHP0eLB7iiqdpep3h5rlOKa2VUx+ZE4/BWVoendTaFskTm7p9DjcR5tB+9XnCY+C0+ryXtHb8SlfR7r/e6TTtjqrrWE9FA3IaOb3fNaPEngtHoeyVcEVTqG8jN6uxEkg7IIvmRjuwMK2ebS5cqvUTbHaKutrCXU9LA6QntG6M48e5Etfsptc1Boamq6sD066yPuNS7dwS6U7wz+rhTZYpEQEQEQYc4NaXOIAAySexfJGp66bX20qpdRybwrasUtI7iQ2IHca7yxvPWNrctZtPkmH0rRUkNvoKejgYGQ08TYmNAwA1owPsXyrqyudctXXerc8OElZLukfRa7cb8GhUnCfiyXtP+7y2WagMdJljAS9w3Wgcy48AB7cKytv0tPRP0np2CJzPxdby/OMN3X7rGgduR0Jz5hXrXKmkRAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiDcaZ0zdNXXyG0WiDpaiTi5zuDImDm957GjPxAAJIBtTXN8oNK6ci2daaLNyAAXariG6ambA3mnieZGXcTgAMHAYQSDYvs8yYdW3aM8RvUEL29/wDTHPh6vgSVa960fp3UPG7Wajqn4wJHxgPHk4cfigrrUuxNrKiirtE1Qt1XA/JZU1MhaD2Pa4h5BB4buMEHmMcdvLZtpbowIxpVr93Bc6eodk9+NwLnzaeuWYmW/FnnHG0PL+Tm1J3Ot0oPJs/+CjN42LaqvtWaqqqtOQSn13U0Ujek8XcOKYtPTHO9U5NRbJG0txadmuvbRRili1PbZYh6rZ4XybngCeOF7zoTXj+epbQ39Ghd/isbaPFa28wzprctY2iWP5PNau56uoB5W7/aXlr9k+qLpRSUlZq+kfBIMOaLb/tqa6TFWYmILa7NaJrMuNo2SaqsMMsFq122kglf0j2strXbzsYz1nE8gO1bI6C17jhtHef/ANMjH3rpcgNAa7I620WXPhQRrR1uzvUWmYbtqKbaFUwF0fTVlQymG/IGDh28eHABSGnNA3rXOlqev1Lqm8COaXp6WncWEtjHqOdkHDjz4LdP2LwSHr6rvbv1o/8ARWq+Kl/FG7di1GTFvyTsjOutn9m0Zpme6T6iv005+TpoBPG3pZDyHqchxJ8AVCJZ4rDbKGrh1TR3aR+6Kuha/efGT2sd247crVk0uO9Jrs6cHEc+PLF5nd13+/UFVZKmnpKkSzStDQ0NPaeKtCk2n6PpqOCnFwmAijawD0ObsGPorXw/DbFjmL992/jOqpqM1bY+sbI3fNZadv8Aqe1y1lxLrHQfL+jClmL5p+wuBjxujzUmO1jSYPGqq/8Awcn+C794VG0sjatpZ5wyesc7sHokgz7xhRi865ptfzU2kbXRVkXp9XFFNJK5jSIw7Lhhrj2NKjc2fQUUTIYWRRt3WMaGtA7AOS5qEiICICIIhtOvr9PbP7nVwyGOplYKeBzcZD3ndB9gJPsVK7FLKK3VNRc3szFbocR+Ej8tHuYHftLl1tuXT3n0+7KvdeN4rGW6yV9dL+bp6eSV3k1pP3L5BGd0b2d7A3s889vxyuDhEfDefoyskOibe+6a3sdGzGJK6IuyMjdYekPwYV79u9xmrtqtdBJublFDDTxbo47pYJDnx3pHfBXLCVbIiBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBdkEE1VURU9PE+aeV4ZHHG0uc9xOAABxJJ7EF7VtNQ7FdL+gUE0VRrO5w4qKwDPosRPHcB5NyOGeLnDJ4ANGm2WbPpdX3j8Z3GMmz00mZS/J9Jkzno89o7XH2IPp1rQxoa0AAcAB2LKAiAiAiAiAiAq317nVOrrHoaN381kP4xugB5wRnqsPg533ILHa1rGhrQGtAwAOQCygp650lu2k7QLiy6VLm2CxN9EhYyUs6apPGRwI+jgN9y938mOzpvrQTPHjXTH7HLly6mtLbbt9NPe8bxDtj2f7NYP/uhkmP6x8r/tK7vyN2cD/k/S/wDdPWmdZT5t0aLL8mRpLZ03/k7R+2Arl+TGzxv/ACboP/DLH9tr80/sOX5PFdbHoSGilbR6doBWFvyTWUwDiezC0+ze0NqNdNiLGmn03Q9HyyDVTvL3uB8BkLpw5oyTs05dPbHG8rqRdLnEQEQEQUR+EHei+qs9hjfwY11ZK3xOWM+HSKQbIrObZoSnqHgiW4PNUQexp4M/uBqrOK22wRHzlnTu9e1OtdRbOrruHD6hrKcfrvDT8CV8zk7zie9RwmNsMz6pt3WNsRoGVu0eCV4cfQ6WWcY5B3VYM+x7lWOo7lFedT3a6QseyKtrZqhjX43mte8uAOO3BVo1tYiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiArs2YUdv0ToCs2iXKhFRXyyuprWx7m4IzuZb9El2+0k8Q1hxwcchHNP2W77TNbyGaV7pKiTp66rDeETOXD2Dda1fVFntNFYrTTWy3QiGkp2BkbB3d5PaTzJ7Sg9yICICxkDtQYMjBze0eZWOmi/rGe9BgzxDnIz3rHpEP9Y33obselQf1g9yelw/T+BTYY9LhHzj7lXmzqobdr5qfVkzXl1dW+i0xzkCCHqjHmcqdkbrC9LZ9Fy0+qtSM0/pW53UMJdTU7nszjBfjDR78JsboHoy0PtWlKGGXJqZWdPO4nJMj+scn2remNebzW5skz6vR4Y5aRDBi8FgxeC1NvMwYvBcTEiYl0Vc0VFSyVM8gZFG0uc5xwOHFenY7ROZo192maRU3iqlrX5OSGk4YPc34q14dWfisq+I3ieWsLCRWarEQEQEQfJ20Ssk1PtSucUDiS6rbb4M8hukRcP1y4r6PoqSG30NPR07AyGCNsbGgYwAMBUvF7eCv1lsorDbpXNjsNqt5J3p6p0uO8MYR+89qosLr4ZG2nj80W7re2RGotGk9balgazpqShLYN8ZG+yN8vEd3Fiodd7ARARARARARARARARARARARARARARARARARARARAV57TJ5aHZroGzOhdE70JlRMx4ILXNhYzBB5HMjkE32I0RpNCtqYzh1bUySvcR2NcYx8GKyS+b6Z+ClDhiT+sf8AtFYxJ/WP/aQYIkPz3e8rj0bjzc73qRjok6HwQOhHcs9CEGREFkQ+CDPReCyIUGp1VWG0aSu9xb61PRyyN8904Xh2dWgWrZ7Y6Xo9x3orZHjHz39Z3xKCUdCq+2ut6TTtrtAYX/jO7U8Dh9QEud+6Fjedqymsb2hueiDeq0YA4BOj8F5mXoIsx0YWDF5LFPM1l3vNqsVP01zroaZp9UOd1neAaOJ9igNbtLrbrWG3aSs09XUHgJJIi93PmIxyHi4hdum0k5J5rdnNn1UUjaO73W7ZBqnVM0dbrK8up487wpmESyDyA+TZ/eU2i2MaTpmD0UXKnlA/PQ18jXk9/PHwVzWsVjaFTe02neXH8h9W2XddpzW9XKxuT6NeWCoa7w38bwHkuMe0W6aclZTa8sT7ewkNF0o8zUrjwHHHFnE9qyYp9RV1JcqSOqoamKpp5ACyWJ4c1w8wvQgIgLzXCrZQW2qrJDhlPC+V3k0E/cg+VdmVK+9bRrbNP8oWukrZXHvDSf33hfTC89xa2+aI+UNtOyhduFc6bVVDRj1Kaj3j+lI8/dGFWAVtoY209PoxnutMvisf4M9dIZpI571cCyItz1iJAC3I5Axwu8+XaqRXWwEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQFfO36Yu1fZ4PmtoS73yf7KC1dmsAh2baea351Ex/vGVK91BncCdGFO4dGE6IJuHRBOiCgOiCz0QQZ6MJuBBncHcm6O5BBdsczqfZZeejbl8oihH60jAprSU4paOCnGMRRtYMeAwg7sKu9o439V6GhPJ1wlf+zGsMvgn6MqeKG9MadH3Lzi35kW1BrzTund+OorRUVbR/vam+Uf7exvtKhceqdda7ldBpS0uo6MnBquBxx7ZXdUeTQ4qx02j5viv2c2bU7dKpDYNhUL5RXatuk9fVPGXwwyODfJ0p67vZuq1bVZbZY6QUlroKejgHzIYw0HxPefNWkRt0V8zu96KQXCaGKohfDNGySJ4w5j2ghw7iCgr5+k67Qt1feNJMdNaZTvV9jBzn68GeT/qnAPeppZL3QahtUVxt03SwScOIw5jhza4djgeBBQbBEBRDalWig2Y3+Q85KYwDxMhDB+8gp3YbRdLqa6V2eEFK2Mf/ADHk/wDlq9l5ric76ifyba9nzBtJrRX7QrzI15c2OYQDwDGNaQP1t5RYO3OuRkN62PAK/wBPHLirHpH2YSsva8yqsuzXQNiLgyI07pp4gBxlayPBzz4dLJ7/AACphbmIiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAiAr42/RFusbPP811CW+6T/aQW5s1eJdmunXDsoY2+4YUqwEDCzhARARARARARBANsxDdm1W4+q2ppi7y6Zi3uspnxWWGI1clHT1FXDT1VTG7ddHE92Dh3zcnDd7hjezngg8E1DS6d1NY4rRNLG+ulfFUUZmfI2SFsbnGXDicFrgwb/bvYOcharadLHR3nRlwme2OKG6OY97jgNDozz9ywyRvSY9GVOloR6/7X7DbN6K1tfdajO6DF1Ys/pn1v1QVpKe2bSto5+Wk/EtqdzBzCC3PY0fKP9u6FxabRxX4r93Rlz79KpzpnYppixhstfGbvUtOQ6paBE0+EY4e/KseONkUbY42NYxowGtGAB5KwcrkiAiAiAq21XR1Whb1+Wdma422Rwbe6BgO69hOOnaBye3t7x7UFh0lXBXUcNXSysmp52CSKRhyHtIyCPYu5AVWbeq91NoWnpWj/fdbG0nuDAX/AMKDQbCaMMsF2rQOM1W2LPeGMB+15VqveGMc9xw1oySvLa6d9Tf/AH5N1ez4/rqx1wr6mteMOqZnzkfpuLvvXZbKMXC6UlEXboqZ44CfB72tPwK9RWNoiGpMvwhZ4JNodLBDK17qW2RQyAHJY7fkcAe47rmnyIVTqUCICICICICICICICICICICICICICICICICICICICu/aSH3PZ1oG9sqRVA0IpZ5d/fLpOjYXZdniQ6N4PbkHKCydiFcyq2bwQNcS6jqZoXAn1etvtH7LwrHQEQEQEQEQEQEQQva1R+m7Lb9FjO5AJf2HNf8AwrZ3DVFho9NU9wvlZSQ0tZTtf0cxB6UObndDT62R2cUFTS7T7dS10lBs60mw1kjRH6QafrFoPACNvW3Rn5xaAuEezjWWtqplbrO8vgjzkU4Ie5vPgGD5NnP6xUifae0DYNNFslFQxuqcYNTN8pL+0eXswpJucclSh2NlmZjdkd7Tldza2ZvrBrlGw7m17D67HN8uK7W1UL+UgHnwTZLtBDhkEEd4WVAIgLhNDHUQSQTMa+KRpY9jhwcCMEFBA9nhmsFyvGiakvcy2vFRb3uOd6kkOWjicnddlqn6AqB/CEuInulktrJMiKOWZzR9IlrR9jkEv2UUZpNnVtc5u66oMlQR4Pe4t/u4W11vXm2aHvVW1269lHIGHucRut+JC8rf49VPrb9W7yfK26GndbyHAZ7gpnsqoDcNpVlZ0e+2GR1Q7wDGHB/aLV6pqlHtqNzddtp2oal0YjLKt1Pug5yIgIgfaGZ9qiKIEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQFd2nzDqj8HKuoGti9M09UunawPBeW7xkLyObctfK0d+6fYGx2BXz0a9XKxSEltVGKiLwczqu97Sz3L6AQEQEQEQEQEQFEtTbSdMaWa5lXcGz1gGRSUvykp8wODfNxCCsLprzWW0unqbTpewmC11DXQzTOw4uYeBBkOGN4Hk3eK9un9hrC6Op1Rc5amRrQ0U9M8hoaOTTIetjwbuoLRtVgtViphBa6CCkiHzYm4z4nvPivf0eFKGNxYMakY6NY6NBgx+Cx0aAGEHq5Hkuxs0zOT8+fFB3Nq3Z6zAR4Fdjaph5gj2KNku0SMdycFyUCH6jpTRa50xfY2nD3yW2pOBjckaXMPf67Gj9ZTBBwkkEbc9vYF8r7X6w1G0WsiySaSOOHe+txef84g99o2x3Oz2eitsNponxUsLYWOfK/JDQBx4Lx6o2qXPVFiltM9uo4IZnsc58cjnHquDscR3tVbXhtK5fec3nuz5vJBArb2B0W9qi53J7gI6ShDePLMj+fuiVkxlRCIgRARARARARARARARARARARARARARARARARARARAVpbCdSQ2jWstorZN2ivMPoxaQN0zA/J5J48QXtAHMvHsDy1sFZs22j4ia4vtlUJIQT+dhPIZx2xktz35X1NY75b9R2mG52yds1NKOBHNp7WuHY4doQbFEBEBEBEHCWaKCJ0s0jI42jLnvcAAPElVrqXbdpqzB8NrL7xVDgPRzuwg+Mh4H9UOQQujum0Pa0+RtJXU1qtDX7jxBL0Y4dhwTI/h+iCplprYlpqytjkuLXXapHE9O0NhzjsjHA/rZKCyI4YoYmxRRtjjaMNawYA9i5boQY3Am4FO4x0adGm6GOjWOjTcY6PwWDGm4xuHuWNxA3PBNxA6NcmhzeTiiXku1I+voWxc3xzwzsz9JkjXD7FsS95yBgeKgdR6oLpDwHFxPcvjnVFwN21Vdq/f3xPWSuafq7xDf7oCENSuQRk5AK19HyRWXYXra7ywvcKzeo2lvM5Y2IHyD5XHyyiJUWiIEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQFyjkfDKyWJ7mSMcHNe04LSORB7Cg+ho5LHtx05GYZ46HWdBTta/pW7on4ceAJ3oi4nBHFhPLB61f0Ny1Vsx1FLE0S0VUB8rTyjeinb2HHJw7nt4hErv0rtn05fWxw3KQWitPDdqHfJOP1ZOXsdgqxmSMlYHxva9jhkOacgohyRARBrLzqG0afpunu1xp6OPvleATz5DmeRVT6l2/U8W/T6atzp38hVVgLGebYx1j7S1BWM1ZrXaTXGIur7s5rsmGJuIIj4jhG39biphR7Ca30VhvOoKG311Q7cpqYDpBI7BO6XEtycAnDRyBKCLXfQGs9EVXpwpKloi4tr7a9zg0eJbhzfaMLf6c256htgZHdoorvTD55IjmH6zRuu9oHmiVuab2qaU1I5kMVeKOrfypq35NxPc0+q72Eqa4RBhMIGEwgYTCBhN1BjcCFgQNwJuIG6E3QgYTCDSauun4k0feLkMb1NSSPZntdu9Ue/C+cNlWkKPVuqn0VyZK+jpqR0knRPMeXZa1vEcePWKCT/7hH/O9d76z/QWf9wn/neu99Z/oIGdhP8AzvXe+s/0Vq9ouq9GfyaU2mdGXaeVguAmmhcyZu9Hh7jvOe0bw3yw4OeIB7EFMogIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIgIg7IJ5qWoiqKeV8M8Tw+OSNxa5jgcggjiCD2q4bJthtuoLfFZdpFrZcYd87lyijDZIskYJa0DGAT1mYOABuk5JD21myGnvdELnoO/Ut2oX8OhmkDXx5bvbpcO3iOq5oIzxUV6LXOgZHFrLzaY2dZ24CYDntON6NEt5btuWsaZjWSyW64lvMy0+HEecbgPgpBF+ELcGD5fTlK8/UrHt+2MobOY/CJqc8dLw4/wC0D/6S1F928aiuFP0VspaW0tI60zXdNJ7HOAa33FDZHLRojWevKr8YNgqJmyjjcLhK5rXDnwc7JcOPzQWqVS6Y2baBc78q74bxc48n8X0jTugjB3XNaeBOR+ccMoNBqTbjcqmhdadJ0MWn7a0uYx0Ab0pjwQAMDEZ456vEHGHcMmrq2uq7lVyVddVT1VTJjfmnkL3uwMDLjxPAAexEJhpja1rDSscNPSXP0qii4NpK1vSsA3d0NB9drRgYa1wHDlzzNGa22Z62pwdVWmWx3h7CZrhQRncc/AGRu5cc88Oa4DvPMhi6bFrhJR/jDSt0ob/bpMlhjkaHOwccDksfggjm3iMKP2zV2tNBVTaFtRWUgZ/xGujLoyBkYDXch+gQEStDTu3631JbDqG2yUch4GopMyx+1vrD2bytKz6hs+oacz2i5U1bGPWMMgcW+BHMe1ENmiAiAiAiBhMIMYTCBhMIKt273YUOhore09e4VTGEfUZ8ofi1o9qgmhX/AJObH9aamJqGSzs9Cp5IXYex2NxrmnIxiSbOefDggo5EBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEHooq6sttZHV0FVPS1MedyaCQse3IIOHDiOBI9qsK27dtdUMrnVNbS3KIs3Ohq6Vm6OXHMe64nhjiccTwQSKbbRpK81kb75s7pJGcQ+USRyvaMcMAxtzx8R9y66jWGxapcHHR94iIP9AGx5/ZmCDp/KjYt/0X1H/wCId/8A2F6afaNsqsLDV2PRFZNcY8GL03dxnPE77nyEHGTwaePdzQQzVO1vV2q4nU9TXiionM3H0tADEx4IIIcclzgQeLSSPBQdARARB77Pe7pp+4NrrRXz0VS3A6SF5bvDIO64cnNyBlpyDjiFalu27mutsdt1ppykvcJe0PnAa127wy7oy0tc7meBaOzhzQbKn0ds715KG6O1E62172NcLbVtJwSC4taH4c4gA53HOAx3EKNXfZzrXSFV6W2jqHiP1a22SOfgebcPb7sIls9PbbdU2g7la6G704PH0jqyDykaPtaVatg216Tu+7HWTS2mc8MVg+Tz4SDLffhELCp6mCrgbPTTRzQvGWyRuDmkeBC7UBEBEBEBEBEHzLtt1HHeNaijhkElLa4ei6vbI7rSYPgAwL2bU4n6T2QaT0q4SsqamQ1NTh3VLmjee13f15QR+j5IKORARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARAU10ntV1ZpAllJXmrpejEbaSuLpYmActwbwLMZ5NIB7QcDATtm03Z7rOp6PV+lfxZKQ0MuFK8vIwDneLGteBwAAAfz44wub9kdtv8D6zQurKO5RhrHupp3gSRhwyN5zOLScHg5gPA9yJROW1a32eVBm6G5WoA7zpqd2YHdnEtyw/rBS6wbe77RMYy9UVNc4uXTRfISnx4ZYfc1BZlk2x6NvG6yW4OtszvmV7ejH7fFn95TqGeKphbNBKyWJ4y17HBwI8CEQ7EQEQEQYc4NaXOIDQMkk8AqY2hbZ4KeKW06VmE1Q4bslwbxZHnmI/pO8eQQQbZxpD8ZVD9WXt5g09bC6qlnkDndO5h3sDtcAQSSOZ6uCoZtF1k/XOsKm7hj4qUNbDSRSY3mRNzjOO0kuceJxvYyQAgiiICICICICICICICICICICICICICICICICICICICICICICICICICICICICICICICIC5xSyQTMmhkdHLG4OY9hw5pHEEEcigsHTm2vWVhdHFUV4utG0EOgrxvucCcn5T188wMkgZ5cApQdb7KtXOYL9pyqsVbKXdJV0XFjOZBLmYc4nAHGM4J7uKD1VGxaK6QSVmjtU2+607X7ha6RuWngS3pI8tzgg4Le1RSTTuvdCyPnio7tbh86ahc50Tsd5jy0j9IIlu7Ntz1ZQ4bVuorrEOB6WPceB+nHw97VOrV+EDZKgNbdLTXUbzwLoS2dgPwd/dRCW0O1XRFeDuagpYXDm2q3oD/AHwFtvyz0v0PTflHaejxne9Njxj3oNXXbU9EW9uZNRUcpPANpSZyfYwFQ29fhAWmnDmWa1VVZJy6SpIhj88cXH3BBWF81trDX1ULe+SaVsnq26giIafNoy5w8XEtUhoNmtv0naDqTaFUtgo4x8nbIXh0tQ/sYSOZPHqtOBzLgASCUS2jbTnazp6W0W63stthon70FPwLnlu81jjgYbhhxujIGTxdwxXqIEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQEQc4ZpaaeOeCV8U0Tg+OSNxa5jgcggjiCD2qfaf2062sDejNybcoACBHcmmXBJznfyHnyLsceSCZy7Xdn2o6Zz9U6If6XvYDqZkchLcDj0mY3A5zw8uPdwhseyDUrgbZqqqs07oRI6Gtfusj5ZaXSjBcCeTXnkcZAyg5jYbXV1E2ssGqLTcad+dyRoc1j8HBw5rng4IIXj/kG1dv5zaM/S9Kd/wCmid3p/kQuFDRuq9Q6ns9spmEB0jy5zG5OBlziwcV2fk5si05uG86wku0jmEtZRv3mHHf0AJB/SciGurdt9HZ6Ge36E0vS2iJ5wKqYNLyN3G90Y4BwOCCXPHDiDlVTd7zcr/cZK+61s1ZVSE5kldnAyTgDk0cTgDAHYEHhRARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARARB//2Q==
"@
[string]$splashjpg2=@"
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NONPPPPON6gI4ggo4wN9PPPPPPPPPPPPPPPPPAAHyINvMSIwggggggggggg19PPPPPPPPPPPPPPPOQ/qA/LAggggggggggggggggZPPPPPPPPPPPONAaR/ZFnraAgggggiDADBAggggg9PPPPPPPPPOKm72Saf8AH7TI8889/wA88888NPPPPrVk08888888842k08pVIpSWwwwwww8wwwwwwwwopCic888888888s9j8uT8gFCOBUyGwLWhJjLtTnopCDk08888880040a+vz0tCxCnCnDmpXDTKSLSIowCC3D88888+mtYO6g8C8xcaENnCnDpHQNbKSLBoDACEj88826Z8ZCbyx98KZciAlAtCnpXLDoVKSJoDQCR/wAPPiDUPAwh0SzPHlPDgC54bAQ1Wiky9bQKAwyk+/vBrNvpwggg8Mng1/CZECYA9YxUKQUy0/KAwwF//vB7MStIggh4vxAWUKAJECwwS0QECAky1KAwwQ+wvOuLwAQh4XE+EXzh5YwJEC5KRSQECJUWKAwwU/8A3zz0wS412FSsdP0QgK2ACRAupVEkBAiUEAMMgTwPzzf9wpzyAtkf7+7k9zoKLJO5gJKLJKKQgMIBeozzwETLDinIBVyo2jiD7l3DDDTjDDDDDDCgNQLV/wA8tCCkQignUEEf4/8ACiltAN5ylBQAPxcVaAw171PPGgggglAlFUwlDHn6lnTpw5iVw5wki0qKA6Cmt/OKAggglwlFnhlVV/G5/uQpw6R4DLwkiwaAA+VfPDAwgggiwgCNxtBAPAdlSDQp6Vyw7BSkiaC1qLPPFIwggggAgKk3Kxh+AzIks2QgxGgky1SRKKOZXPPOQggggoAhIgP6+APWhdmojLIxUKQEy07KBerfPPHwggggig0wIkyBXvnvfrz1yS0QECAky1KE9XPPPH4wggggwgQOIAVcuMHZesbTKQSQECJXWKD9fPPPN6QggghAlFT4KdeZgwQEBly6lUyQECJQQL/PPPPLbAggggiKBLYwFQKxjhlSKEbAI0wQWQZQFPPPPPBBQgggghEQESylSDfPPPPPPPPPPPPPPPLFPPPPPGHSQgggh4XgxIFaIM888888884AQLCCDDPPPPPPKTuSggqoLTqO6WiV6wwwwgwhIAmPGzfPPPPPPPPPFs7gg0JBKOEwBFGPSAghA0Ahx8cSnPPP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
"@
[string]$shazzam_img=@"
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
"@
[string]$logojpgB64=@"
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
"@
$Page = 'PageConsole';$pictureBase64 = $shazzam_img;$PictureBoxConsole = NewPictureBox -X '910' -Y '576' -W '90' -H '90';$PictureBoxConsole.Visible = $false
$Page = 'PageSP';if ($BGIMG -eq 'Dark') {$pictureBase64 = $splashjpg1} else {$pictureBase64 = $splashjpg2}
$PictureBox1_PageMain = NewPictureBox -X '120' -Y '75' -W '500' -H '500';
$Page = 'PageMain';$Button_SP = NewPageButton -X '-5' -Y '630' -W '50' -H '40' -C '0' -Text '';$Button_SPImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($logobar));$Button_SP.Image = $Button_SPImage
$form.ResumeLayout()
$form.Add_Shown({$form.Activate()})
GUI_Resume
$SplashScreen.Close()
$SplashScreen.Dispose()
$form.ShowDialog()
$form.Dispose()
#$form.Refresh()
#$currentTime = (Get-Date);$part1Time, $part2Time , $currentSeconds = $currentTime -split '[:]'
#if ($CMDWindow) {$CMDHandle = $CMDWindow.MainWindowHandle;$processId = 0;$threadId = [WinMekanix.Functions]::GetWindowThreadProcessId($CMDHandle, [ref]$processId)
#$process.Handle = $explorer.HWND;#$CurDir =  $PWD.Path
#if ($processId -gt 0) {$null} else {$null}} else {$null}
#$process = Get-ProcessNull xyz.exe;Wait-Process -Id $process.Id
#REGNull ADD "HKCU\Console" /V "FontSize" /T REG_DWORD /D "$ScaleFont" /F
#Set-ItemProperty -Path "HKCU:\Console" -Name "FontSize" -Value "$ScaleFont"
#$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(100, 1000)
#$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(30, 34)
#Write-Error "ERROR: $([System.Runtime.InteropServices.Marshal]::GetLastWin32Error())"
#ForEachNull ($i in Get-Content "c:\txt.txt") {[void]$listview.Items.Add($i)}
#ForEachNull ($line in $command) {$textBox.AppendText("$line`r`n")}  
#Get-ContentNull "$PSScriptRootX\ini.ini" | ForEach-Object {[void]$ListView1_PageSC.Items.Add($_)}
#Get-ItemNull -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Property | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}
#Get-ItemNull | Select-Object Name, Length, Extension
#Get-ItemNull -Path "$FilePath\*.*" -Name | ForEach-Object {[void]$DropBox1_PagePB.Items.Add($_)}
#GetProcessNull | Select-Object -Property Name, WorkingSet, PeakWorkingSet | Sort-Object -Property WorkingSet -Descending | Out-GridView
#InvokeCommandNull -ComputerName S1, S2, S3 -ScriptBlock {Get-Culture} | Out-GridView
#$Rnd = Get-Random -Minimum 1 -Maximum 100
#If ([string]::IsNullOrEmpty($InitialDirectory) -eq $False) { $FolderBrowserDialog.SelectedPath = $InitialDirectory }
#If ($FolderBrowserDialog.ShowDialog($MainForm) -eq [System.Windows.Forms.DialogResult]::OK) { $return = $($FolderBrowserDialog.SelectedPath) }
#Try { $FolderBrowserDialog.Dispose() } Catch {}
:END_OF_FILE
::#🗃\🗂\🧾\💾\🗳\🏗\🛠\🪛\✂\🗜\✒\✏\🥾\🪟\🛜\🔄\🌐\🛡\🪪\✅\❎\🚫\⏳\🏁\🎨\❗\🛳\🚽\💥\🚥\🚦\🕸\🐜\🛤\🏞\🌕\🌑\◀\▶\❕#