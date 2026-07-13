:: <# Windows Deployment Image Customization Kit v 1225 © github.com/joshuacline
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
ECHO.❗* Builder Execution Interactive List Items *❗
ECHO.
ECHO.❕Table❕ⓠ: Execution item, suppresses announcement / ⓡ: Reference item, no announcement❕
ECHO.❕Note❕List items without a 'ⓠ' or 'ⓡ' prefix are processed as execution.❕
ECHO.
ECHO.❕Group❕🪟Builder interactive items❕🪛Choice item❕Normal❕
ECHO.❕Note❕Choice Item: Choice1-9 are valid. Up to 9 choices seperated by '❗'.❕
ECHO.❕ⓠChoice❕Select an option❕A❗B❗C❕VolaTILE❕
ECHO.❕ⓠTextHost❕Choice1.I:◁Choice1.I▷ Choice1.S:◁Choice1.S▷ Choice1.1:◁Choice1.1▷ Choice1.2:◁Choice1.2▷ Choice1.3:◁Choice1.3▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder interactive items❕🪛Prompt item❕Normal❕
ECHO.❕Note❕Prompt Item: Prompt1-9 are valid. Prompt filter 'Number', 'Letter', 'Alpha', 'Menu', 'Most', and 'None' are usable options. Minimum and maximum character limit are optional.❕
ECHO.❕ⓠPrompt❕Enter text❕Alpha❗3-20❕VolaTILE❕
ECHO.❕ⓠTextHost❕Prompt1.I:◁Prompt1.I▷ Prompt1.S:◁Prompt1.S▷ Prompt1.1:◁Prompt1.1▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder interactive items❕🪛Picker item❕Normal❕
ECHO.❕Note❕Picker Item: Picker1-9 are valid. '◁ImageFolder▷', '◁ListFolder▷', '◁PackFolder▷', '◁CacheFolder▷', and '◁ProgFolder▷' are suggested options.❕
ECHO.❕ⓠPicker❕Select a file❕◁ImageFolder▷❗*.wim❕VolaTILE❕
ECHO.❕ⓠTextHost❕Picker1.I:◁Picker1.I▷ Picker1.S:◁Picker1.S▷ Picker1.1:◁Picker1.1▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder interactive items❕🪛Info item❕Normal❕
ECHO.❕Note❕Info Item: Info1 is valid. 'Small' and 'Large' are usable options.❕
ECHO.❕ⓠInfo❕✅InfoBox Item Header❕✅InfoBox message goes here.❕Large❕
ECHO.
ECHO.
ECHO.
ECHO.❗* Builder Execution Non-Interactive List Items *❗
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛Condit item❕Normal❕
ECHO.❕Note❕Condit Item: Condit1-9 are valid. 'Defined', 'Ndefined', 'Exist', 'Nexist', 'EQ', 'NE', 'GE', 'LE', 'LT', and 'GT' are usable options. Enter ◁Null▷ into the 4th column if 'else' is not needed.❕
ECHO.❕ⓠString❕TestString❕String❕1❕
ECHO.❕ⓠCondit❕◁WinTar▷❗Exist❕WinTar Exists❕◁Null▷❕
ECHO.❕ⓠCondit2❕◁String1.I▷❗EQ❗1❕String1 equals 'TestString'❕String1 does not equal 'TestString'❕
ECHO.❕ⓠTextHost❕Condit1.I:◁Condit1.I▷ Condit1.S:◁Condit1.S▷ Condit1.1:◁Condit1.1▷ Condit1.2:◁Condit1.2▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Condit2.I:◁Condit2.I▷ Condit2.S:◁Condit2.S▷ Condit2.1:◁Condit2.1▷ Condit2.2:◁Condit2.2▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛Array item❕Normal❕
ECHO.❕Note❕Array Item: Array1-9 are valid. Similar to a condit item except the condition is always 'EQ'. An array of if EQ's, optional '◁Else▷' needs to be placed last.❕
ECHO.❕ⓠChoice❕Select an option❕A❗B❗C❗Z❕VolaTILE❕
ECHO.❕ⓠArray❕◁Choice1.S▷❕A❗B❗C❗◁Else▷❕✅Array1.1 selected❗✅Array1.2 selected❗✅Array1.3 selected❗✅Array1.4 selected❕
ECHO.❕ⓠArray2❕◁Choice1.I▷❕1❗2❗3❗◁Else▷❕✅Array2.1 selected❗✅Array2.2 selected❗✅Array2.3 selected❗✅Array2.4 selected❕
ECHO.❕ⓠTextHost❕Array1.I:◁Array1.I▷ Array1.S:◁Array1.S▷ Array1.1:◁Array1.1▷ Array1.2:◁Array1.2▷ Array1.3:◁Array1.3▷ Array1.4:◁Array1.4▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Array2.I:◁Array2.I▷ Array2.S:◁Array2.S▷ Array2.1:◁Array2.1▷ Array2.2:◁Array2.2▷ Array2.3:◁Array2.3▷ Array2.4:◁Array2.4▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛Math item❕Normal❕
ECHO.❕Note❕Math item: MATH1-9 are valid. '+', '-', '/', and '*' are usable options.❕
ECHO.❕ⓠMath❕1❕*❕5❕
ECHO.❕ⓠTextHost❕Math1.I:◁Math1.I▷ Math1.S:◁Math1.S▷ Math1.1:◁Math1.1▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛String item❕Normal❕
ECHO.❕Note❕String item: String1-9 are valid. 'String' and 'Integer' are usable options.❕
ECHO.❕ⓠChoice❕Select an option❕A❗B❗C❗D❗E❕VolaTILE❕
ECHO.❕ⓠString❕10❗20❗30❗40❗50❕Integer❕◁Choice1.I▷❕
ECHO.❕ⓠString2❕V❗W❗X❗Y❗Z❕String❕◁Choice1.I▷❕
ECHO.❕ⓠTextHost❕String1.I:◁String1.I▷ String1.S:◁String1.S▷ String1.1:◁String1.1▷ String1.2:◁String1.2▷ String1.3:◁String1.3▷ String1.4:◁String1.4▷ String1.5:◁String1.5▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕String2.I:◁String2.I▷ String2.S:◁String2.S▷ String2.1:◁String2.1▷ String2.2:◁String2.2▷ String2.3:◁String2.3▷ String2.4:◁String2.4▷ String2.5:◁String2.5▷❕Screen❕DX❕
ECHO.
ECHO.❕Group❕🪟Builder non-interactive items❕🪛Routine item❕Normal❕
ECHO.❕Note❕Routine item: Routine1-9 are valid. 'Command', 'Split', and 'Registry' are usable options. Optional column number match seperated by '❗'. For 'Command' routines an asterisk can be used in column 4 as a tokens modifier eg '3*'.❕
ECHO.❕ⓠRoutine❕◁HiveUser▷\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize❗AppsUseLightTheme❕Registry❕Integer❕
ECHO.❕ⓠRoutine2❕^<^>:❗DIR /B C:\❗1❗Program Files❕Command❕1❕
ECHO.❕Note❕Routine examples 3-5 listed below are not currently implemented as dynamic menu reference items 'ⓡ', only execution 'ⓠ'.❕
ECHO.❕ⓠRoutine3❕^<^>:❗DIR /B C:\❕Command❕1❕
ECHO.❕ⓠRoutine4❕:❗A:B:C❗3❗C❕Split❕2❕
ECHO.❕ⓠRoutine5❕:❗A:B:C❕Split❕2❕
ECHO.❕Note❕For Routine Registry items 'String' and 'Integer' are usable options.❕
ECHO.❕ⓠTextHost❕Routine1.I:◁Routine1.I▷ Routine1.S:◁Routine1.S▷ Routine1.1:◁Routine1.1▷ Routine1.2:◁Routine1.2▷ Routine1.3:◁Routine1.3▷ ❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Routine2.I:◁Routine2.I▷ Routine2.S:◁Routine2.S▷ Routine2.1:◁Routine2.1▷ Routine2.2:◁Routine2.2▷ Routine2.3:◁Routine2.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Routine3.I:◁Routine3.I▷ Routine3.S:◁Routine3.S▷ Routine3.1:◁Routine3.1▷ Routine3.2:◁Routine3.2▷ Routine3.3:◁Routine3.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Routine4.I:◁Routine4.I▷ Routine4.S:◁Routine4.S▷ Routine4.1:◁Routine4.1▷ Routine4.2:◁Routine4.2▷ Routine4.3:◁Routine4.3▷❕Screen❕DX❕
ECHO.❕ⓠTextHost❕Routine5.I:◁Routine5.I▷ Routine5.S:◁Routine5.S▷ Routine5.1:◁Routine5.1▷ Routine5.2:◁Routine5.2▷ Routine5.3:◁Routine5.3▷❕Screen❕DX❕
ECHO.
ECHO.
ECHO.
ECHO.❗* Builder Reference List Items Example *❗
ECHO.
ECHO.❕Group❕🎨Reference Example❕🎨Theme ➥ ◁Array1.S▷❕Normal❕
ECHO.❕ⓡRoutine❕◁HiveUser▷\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize❗AppsUseLightTheme❕Registry❕Integer❕
ECHO.❕ⓡArray❕◁Routine1.S▷❕◁Null▷❗0❗1❗◁Else▷❕❔Unconfigured❗🌑Dark❗🌕Light❗❔Unspecified❕
ECHO.❕ⓠChoice❕Select an option❕🌕Light theme❗🌑Dark theme❕VolaTILE❕
ECHO.❕ⓠArray❕◁Choice1.I▷❕1❗2❕1❗0❕
ECHO.
ECHO.❕Note❕Halt item❕
ECHO.❕ⓠChoice2❕Select an option❕Halt❗Don't Halt❕VolaTILE❕
ECHO.❕ⓠArray2❕◁Choice2.I▷❕1❗2❕HALT❗DX❕
ECHO.❕ⓠTextHost❕Halt skipped.❕Screen❕◁Array2.S▷❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize❗AppsUseLightTheme❗◁Array1.S▷❗Dword❕Create❕DX❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize❗SystemUsesLightTheme❗◁Array1.S▷❗Dword❕Create❕DX❕
ECHO.❕ⓠTextHost❕◁Choice1.S▷ ➥ applied.❕Screen❕DX❕
ECHO.
ECHO.❗* Execution List Items *❗
ECHO.
ECHO.❕Group❕🪟Execution items❕🪛Command item❕Normal❕
ECHO.❕Note❕Command item: 'Normal', 'NoMount', 'Normal❗RAU', 'Normal❗RAS', 'Normal❗RATI', 'NoMount❗RAU', 'NoMount❗RAS', or 'NoMount❗RATI' are usable options.❕
ECHO.❕ⓠCommand❕echo.testing 1 2 3.❕Normal❕DX❕
ECHO.
ECHO.❕Group❕🪟Execution items❕🪛Registry create item❕Normal❕
ECHO.❕Note❕Registry item: 'Create', 'Delete', 'Create❗RAU', 'Create❗RAS', 'Create❗RATI', 'Delete❗RAU', 'Delete❗RAS', or 'Delete❗RATI' are usable options. 'Dword', 'Qword', 'Binary', 'String', 'Expand', and 'Multi' are usable options.❕
ECHO.
ECHO.❕Note❕Registry item create key.❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❕Create❕DX❕
ECHO.
ECHO.❕Note❕Registry item create value with empty value and data.❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗◁Null▷❗TestData❗String❕Create❕DX❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗TestValue❗◁Null▷❗String❕Create❕DX❕
ECHO.
ECHO.❕Note❕Registry item delete value.❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❗TestValue❕Delete❕DX❕
ECHO.
ECHO.❕Note❕Registry item delete key.❕
ECHO.❕ⓠRegistry❕◁HiveUser▷\Test❕Delete❕DX❕
ECHO.
ECHO.❕Group❕🪟Execution items❕🪛FileOper item❕Normal❕
ECHO.❕Note❕FileOper item: 'Create', 'Delete', 'Rename', 'Copy', 'Move', and 'Takeown' are usable options.❕
ECHO.❕Note❕FileOper item create folder.❕
ECHO.❕ⓠFileOper❕c:\test❕Create❕DX❕
ECHO.
ECHO.❕Note❕FileOper item move.❕
ECHO.❕ⓠTextHost❕test❕File❗c:\testmove.txt❕DX❕
ECHO.❕ⓠFileOper❕testmove.txt❗c:\test❕Move❕DX❕
ECHO.
ECHO.❕Group❕🪟Execution items❕🪛Session item❕Normal❕
ECHO.❕Note❕TextHost item: 'Screen' and 'File' are usable options. When outputting to a file, using the '◁U00▷' and '◁U01▷' variables will create white '❕' and red '❗' columns.❕
ECHO.❕ⓠTextHost❕MENU-SCRIPT❕File❗◁ListFolder▷\testlist.list❕DX❕
ECHO.❕ⓠTextHost❕◁U00▷ⓠTextHost◁U00▷Greetings from session 2◁U00▷Screen◁U00▷DX◁U00▷❕File❗◁ListFolder▷\testlist.list❕DX❕
ECHO.❕Note❕Session item. Using the '-PATH "◁DrvTar▷"' parameter during an active session will reuse the active session's target.❕
ECHO.❕ⓠSession❕-imagemgr -run -list "testlist.list" -path "◁DrvTar▷"❕New❕DX❕
ECHO.❕ⓠTextHost❕End of session 1❕Screen❕DX❕
ECHO.❕ⓠFileOper❕◁ListFolder▷\testlist.list❕Delete❕DX❕
ECHO.
ECHO.❕Group❕🪟Miscellaneous Examples❕Items being used in conjunction❕Normal❕
ECHO.❕ⓠChoice❕Select an option❕🪛Choice A❗🪛Choice B❗🪛Choice C❗❕VolaTILE❕
ECHO.❕ⓠArray❕◁Choice1.I▷❕1❗2❗3❕DX❗DX❗DX❕
ECHO.❕ⓠTextHost❕◁Choice1.S▷ picked.❕Screen❕◁Array1.1▷❕
ECHO.❕ⓠTextHost❕◁Choice1.S▷ picked.❕Screen❕◁Array1.2▷❕
ECHO.❕ⓠTextHost❕◁Choice1.S▷ picked.❕Screen❕◁Array1.3▷❕
ECHO.
ECHO.❕Note❕Installs any drivers located in a folder named driver.❕
ECHO.❕Group❕🪟Miscellaneous Examples❕Driver Install❕Normal
ECHO.❕ⓠCondit❕◁ProgFolder▷\driver❗Exist❕DX❕◁Null▷❕
ECHO.❕ⓠDriver❕◁ProgFolder▷\driver❕Install❕◁Condit1.1▷❕
EXIT /B
:MENU_EXAMPLE_BASE
ECHO.MENU-SCRIPT
ECHO.❗* This is an example of a custom menu for recovery *❗
ECHO.
ECHO.❕Group❕Recovery Operation Example❕Backup picked vhdx to backup.wim❕Normal❕
ECHO.❕ⓠPicker❕Select a vhdx to backup❕◁ProgFolder▷❗*.vhdx❕VolaTILE❕
ECHO.❕ⓠCondit❕◁ProgFolder▷\◁Picker1.S▷❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕◁ProgFolder▷\◁Picker1.S▷ does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting backup.wim❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ImageFolder▷\backup.wim❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -vhdx "◁Picker1.S▷" -index 1 -wim "backup.wim" -size 25❕New❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
ECHO.
ECHO.❕Group❕Recovery Operation Example❕Restore picked wim to current.vhdx❕Normal❕
ECHO.❕ⓠPicker❕Select a wim to restore❕◁ImageFolder▷❗*.wim❕VolaTILE❕
ECHO.❕ⓠCondit❕◁ProgFolder▷\◁Picker1.S▷❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕◁ImageFolder▷\◁Picker1.S▷ does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting current.vhdx❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ProgFolder▷\current.vhdx❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -wim "◁Picker1.S▷" -index 1 -vhdx "current.vhdx" -size 25❕New❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
EXIT /B
:MENU_EXAMPLE_EXEC
ECHO.MENU-SCRIPT
ECHO.❗* This is an example of a reboot to restore scenerio as an execution list *❗
ECHO.
ECHO.❕ⓠCondit❕◁ImageFolder▷\backup.wim❗Exist❕DX❕DX❕
ECHO.❕ⓠTextHost❕ECHO.◁ImageFolder▷\backup.wim does not exist.❕Screen❕◁Condit1.2▷❕
ECHO.❕ⓠTextHost❕Deleting current.vhdx❕Screen❕◁Condit1.1▷❕
ECHO.❕ⓠFileOper❕◁ProgFolder▷\current.vhdx❕Delete❕◁Condit1.1▷❕
ECHO.❕ⓠSession❕-imageproc -wim "backup.wim" -index 1 -vhdx "current.vhdx" -size 25❕New❕◁Condit1.1▷❕
ECHO.❕ⓠCommand❕PAUSE❕Normal❕DX❕
EXIT /B
:GET_INIT
SET "CMD=CMD.EXE"&&SET "DISM=DISM.EXE"&&SET "REG=REG.EXE"&&SET "BCDEDIT=BCDEDIT.EXE"
SET "ERROR="&&SET "MENU_EXIT="&&SET "SETS_LOAD="&&SET "GUI_ACTIVE="
SET "VER_GET=%~f0"&&CALL:GET_PROGVER&&CD /D "%~DP0"&&CHCP 65001>NUL
SET "ORIG_CD=%CD%"&&FOR /F "TOKENS=*" %%a in ("%CD%") DO (SET "CAPS_SET=ProgFolder0"&&SET "CAPS_VAR=%%a"&&CALL:CAPS_SET)
FOR /F "TOKENS=1-2 DELIMS=:" %%a IN ("%ProgFolder0%") DO (SET "CHAR_STR=%%b"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK&&IF "%%b"=="\" SET "ProgFolder0=%%a:")
IF EXIST "%ProgFolder0%\$CON" SET "GUI_ACTIVE=1"&DEL /F /Q "%ProgFolder0%\$CON">NUL 2>&1
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
FOR /F "TOKENS=1-9 DELIMS= " %%a IN ("!$HEAD!") DO (IF "%%a"=="MENU-SCRIPT" SET "$HEAD=%%a"&&IF NOT "%%b"=="" FOR %%◌ in (%%a %%b %%c %%d %%e %%f %%g %%h) DO (IF "%%◌"=="MENU" SET "MENU_SESSION=1"))
:HEADER_SKIP
IF NOT "!$HEAD!"=="MENU-SCRIPT" SET "ERROR=HEADER"&&ECHO.%COLOR2%ERROR:%$$% Header is not MENU-SCRIPT, check file.&&IF "%DEBUG%"=="ENABLED" CALL:DEBUG
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
SET SETS_LIST=BOOTLOADER GUI_LAUNCH GUI_RESUME GUI_SCALE GUI_CONFONT GUI_CONFONTSIZE GUI_CONTYPE GUI_FONTSIZE GUI_LVFONTSIZE GUI_TXT_FORE GUI_TXT_BACK GUI_BTN_COLOR GUI_HLT_COLOR GUI_BG_COLOR GUI_PAG_COLOR PAD_BOX PAD_TYPE PAD_SIZE PAD_SEQ TXT_COLOR ACC_COLOR BTN_COLOR COMPRESS SAFE_EXCLUDE HOST_HIDE PE_WALLPAPER BOOT_TIMEOUT VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5 ADDFILE_0 ADDFILE_1 ADDFILE_2 ADDFILE_3 ADDFILE_4 ADDFILE_5 ADDFILE_6 ADDFILE_7 ADDFILE_8 ADDFILE_9 HOTKEY_1 SHORT_1 HOTKEY_2 SHORT_2 HOTKEY_3 SHORT_3 MENU_MODE MENU_LIST REFERENCE RECOVERY_LOGO APPX_SKIP COMP_SKIP SVC_SKIP SXS_SKIP DEBUG
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
CD /D "%ProgFolder0%"&&IF "%PROG_MODE%"=="PORTABLE" IF NOT EXIST "windick.ini" IF NOT DEFINED SETS_LOAD CALL:SETS_MAIN
IF EXIST "windick.ini" IF NOT DEFINED SETS_LOAD SET "SETS_LOAD=1"&&CALL:SETS_LOAD
CALL:SETS_LIST&&ECHO.Windows Deployment Image Customization Kit v %VER_CUR% Settings>"windick.ini"
FOR %%a in (%SETS_LIST%) DO (CALL ECHO.%%a=%%%%a%%>>"windick.ini")
SET "SETS_LIST="&&IF "%PROG_MODE%"=="RAMDISK" IF "%ProgFolder%"=="X:\$" SET "HOST_GET=1"
IF "%PROG_MODE%"=="RAMDISK" IF NOT "%DISK_TARGET%"=="%HOST_TARGET%" SET "HOST_GET=1"
IF DEFINED HOST_GET SET "HOST_GET="&&CALL:HOST_AUTO
IF "%PROG_MODE%"=="RAMDISK" IF EXIST "Z:\%HOST_FOLDERX%" COPY /Y "windick.ini" "Z:\%HOST_FOLDERX%">NUL
:SETS_MAIN
IF NOT "%BOOTLOADER%"=="New" IF NOT "%BOOTLOADER%"=="Old" IF NOT "%BOOTLOADER%"=="boot.efi" SET "BOOTLOADER=New"
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
IF NOT DEFINED ADDFILE_0 SET "ADDFILE_0=◁ListFolder▷\default.base"
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
IF "%BOOTLOADER%"=="boot.efi" IF NOT EXIST "%CacheFolder%\boot.efi" SET "BOOTLOADER=New"
IF DEFINED REFERENCE IF /I NOT "%REFERENCE%"=="DISABLED" IF NOT EXIST "%ImageFolder%\%REFERENCE%" SET "REFERENCE=LIVE"
FOR %%a in (MOUNT TARGET_PATH PATH_APPLY LIVE_APPLY VDISK_APPLY ERROR $NO_MOUNT $HALT $ONLY1 $ONLY2 $ONLY3 $VERBOSE $VHDX VDISK VDISK_LTR MENU_SESSION CUSTOM_SESSION MENU_SKIP DELETE_DONE FEAT_QRY DRVR_QRY SC_PREPARE RO_PREPARE) DO (SET "%%a=")
CHCP 65001>NUL&IF NOT DEFINED U00 SET "U00=❕"&&SET "U01=❗"&&SET "U02=🗂 "&&SET "U03=🛠️"&&SET "U04=💾"&&SET "U05=🗳 "&&SET "U06=🪟"&&SET "U07=🔄"&&SET "U08=🪛"&&SET "U09=🥾"&&SET "U10=✒ "&&SET "U11=🗃 "&&SET "U12=🎨"&&SET "U13=🧾"&&SET "U14=⏳"&&SET "U15=✅"&&SET "U16=❎"&&SET "U17=🚫"&&SET "U18=🗜 "&&SET "U19=🛡 "&&SET "U0L=◁"&&SET "U0R=▷"&&SET "U0P=％"&&SET "U0D=＄"&&SET "COLOR0=[97m"&&SET "COLOR1=[31m"&&SET "COLOR2=[91m"&&SET "COLOR3=[33m"&&SET "COLOR4=[93m"&&SET "COLOR5=[92m"&&SET "COLOR6=[96m"&&SET "COLOR7=[94m"&&SET "COLOR8=[34m"&&SET "COLOR9=[95m"
CALL SET "@@=%%COLOR%ACC_COLOR%%%"&&CALL SET "##=%%COLOR%BTN_COLOR%%%"&&CALL SET "$$=%%COLOR%TXT_COLOR%%%"
SET "COLORA=%@@%"&&SET "COLORB=%##%"&&SET "COLORT=%$$%"
FOR %%a in (COMMAND GUI) DO (IF "%PROG_MODE%"=="%%a" EXIT /B)
FOR %%a in (MENU_LIST) DO (SET "OBJ_FLD=%ListFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (PE_WALLPAPER) DO (SET "OBJ_FLD=%CacheFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (VHDX_SLOTX WIM_SOURCE VHDX_SOURCE) DO (SET "OBJ_FLD=%ImageFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
IF "%PROG_MODE%"=="RAMDISK" FOR %%a in (VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5) DO (SET "OBJ_FLD=%ProgFolder%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (MENU_LIST PE_WALLPAPER PATH_SOURCE PATH_TARGET WIM_SOURCE VHDX_SOURCE WIM_TARGET VHDX_TARGET VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5) DO (IF NOT DEFINED %%a SET "%%a=SELECT")
IF NOT EXIST "%PATH_SOURCE%\" SET "PATH_SOURCE=SELECT"
IF NOT EXIST "%PATH_TARGET%\" SET "PATH_TARGET=SELECT"
FOR %%a in (OBJ_FLD OBJ_CHK OBJ_CHKX) DO (SET "%%a=")
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
IF /I NOT "%REFERENCE%"=="LIVE" IF /I NOT "%REFERENCE%"=="DISABLED" IF NOT DEFINED $VATTACH SET "LIVE_APPLY="&&SET "$VDISK_FILE=%ImageFolder%\%REFERENCE%"&&SET "VDISK_LTR=ANY"&&ECHO.Loading reference image...&&CALL:VDISK_ATTACH
IF /I NOT "%REFERENCE%"=="LIVE" IF /I NOT "%REFERENCE%"=="DISABLED" IF NOT DEFINED $VATTACH IF EXIST "%VDISK_LTR%:\" SET "TARGET_PATH=%VDISK_LTR%:"&&SET "$VATTACH=1"&&CALL:MOUNT_EXT
IF /I "%REFERENCE%"=="LIVE" SET "TARGET_PATH=%SYSTEMDRIVE%"&&SET "LIVE_APPLY=1"&&CALL:MOUNT_INT
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
IF /I NOT "%REFERENCE%"=="LIVE" IF /I NOT "%REFERENCE%"=="DISABLED" IF DEFINED $VATTACH ECHO.Unloading reference image...&&SET "$VDISK_FILE=%ImageFolder%\%REFERENCE%"&CALL:MOUNT_INT&CALL:VDISK_DETACH
SET "$VATTACH="&&EXIT /B
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
IF "%$LIST_SCOPE%"=="GROUP" IF /I "%%1"=="GROUP" SET "$LIST_FILEX=1"&&SET "$LIST_FILEZ="
IF "%$LIST_SCOPE%"=="SUBGROUP" IF /I "%%1"=="GROUP" IF NOT "%%2"=="%$ONLY2%" SET "$LIST_FILEZ="
IF "%$LIST_SCOPE%"=="SUBGROUP" IF /I "%%1"=="GROUP" IF "%%2"=="%$ONLY2%" SET "$LIST_FILEX=1"&&IF /I NOT "%REFERENCE%"=="DISABLED" SET "$LIST_FILEZ=1"
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
SET "$VCLMX="&&EXIT /B
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
SET "$VCLMX="&&EXIT /B
:NORMAL_LISTX
SET "$VCLM1=!$VCLM1:"=!"
SET "@QUIET="&&FOR /F "TOKENS=* DELIMS=ⓠ" %%● IN ("!$VCLM1!") DO (IF NOT "%%●"=="!$VCLM1!" SET "$VCLM1=%%●"&&SET "@QUIET=1")
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
IF DEFINED WRITEZ SET "WRITEZ="&&ECHO.>>"$LIST"
FOR %%@ in (PROMPT CHOICE PICKER INFO) DO (IF /I "!$VCLM1!"=="%%@" CALL:NORMAL_LIST_%%@
FOR %%▓ in (0 1 2 3 4 5 6 7 8 9) DO (IF /I "!$VCLM1!"=="%%@%%▓" CALL:NORMAL_LIST_%%@))
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
:NORMAL_LIST_INFO
SET "$HEADERS=!$VCLM2!%U01% %U01%!$VCLM3!%U01%"
SET "$CENTERED=1"&&CALL:INFO_BOX
IF DEFINED @QUIET FOR /F "TOKENS=*" %%● IN ("!$VCLM1!") DO (SET "$VCLM1=ⓠ%%●")
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!$VCLM4!%U00%"
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
:INFO_BOX
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&CALL:BOX_HEADERS&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED
FOR %%a in ($HEADERS $CENTERED) DO (SET "%%a=")
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
ECHO. (%##% 1 %$$%) %U12% Appearance&&ECHO. (%##% 2 %$$%) %U02% Folder Layout        %@@%%FOLDER_MODE%%$$%&&IF NOT "%PROG_MODE%"=="GUI" ECHO. (%##% 3 %$$%) %U04% Bootloader           %@@%%BOOTLOADER%%$$%&&ECHO. (%##% 4 %$$%) %U15% Shortcuts
IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% 5 %$$%) %U19% Host Hide            %@@%%HOST_HIDE%%$$%&&ECHO. (%##% 6 %$$%) %U07% Update
ECHO. (%##% . %$$%) %U17% Clear Settings
IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% * %$$%) %U01% %COLOR2%Enable Custom Menu%$$%
ECHO.&&ECHO.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT IF DEFINED MENU_EXIT GOTO:QUIT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="." CALL:SETS_CLEAR&SET "SELECT="&IF "%PROG_MODE%"=="GUI" ECHO.Restart app for changes to take effect.&CALL:PAUSED
IF "%SELECT%"=="~" IF NOT "%DEBUG%"=="ENABLED" SET "DEBUG=ENABLED"&SET "SELECT="
IF "%SELECT%"=="~" IF "%DEBUG%"=="ENABLED" SET "DEBUG=DISABLED"&SET "SELECT="
IF "%SELECT%"=="*" IF "%PROG_MODE%"=="RAMDISK" GOTO:MENU_LIST
IF "%SELECT%"=="1" GOTO:APPEARANCE
IF "%SELECT%"=="2" CALL:FOLDER_MODE&SET "SELECT="
IF "%SELECT%"=="3" IF NOT "%PROG_MODE%"=="GUI" CALL:BOOTSELECT&SET "SELECT="
IF "%SELECT%"=="4" IF NOT "%PROG_MODE%"=="GUI" GOTO:SHORTCUTS
IF "%SELECT%"=="5" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="DISABLED" SET "HOST_HIDE=ENABLED"&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.           The vhdx host partition will be hidden upon exit.&&ECHO.                     Boot into recovery to revert.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED&SET "SELECT="
IF "%SELECT%"=="5" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="ENABLED" SET "HOST_HIDE=DISABLED"&&SET "SELECT="
IF "%SELECT%"=="6" IF "%PROG_MODE%"=="RAMDISK" GOTO:UPDATE_RECOVERY
GOTO:SETTINGS_MENU
:BOOTSELECT
IF NOT EXIST "%CacheFolder%\boot.efi" SET "EFI_PRESENT="
IF EXIST "%CacheFolder%\boot.efi" SET "EFI_PRESENT=%U01%boot.efi"
SET "$HEADERS=                            %U15% Bootloader%U01% %U01%                          Select a bootloader"&&SET "$CHOICE_LIST=New%U01%Old%EFI_PRESENT%"&&SET "$NO_ERRORS=1"&&CALL:CHOICE_BOX
IF "%SELECT%"=="1" SET "BOOTLOADER=New"
IF "%SELECT%"=="2" SET "BOOTLOADER=Old"
IF "%SELECT%"=="3" SET "BOOTLOADER=boot.efi"
EXIT /B
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
IF "%UPDATE_TYPE%"=="EFI" IF NOT EXIST "%CacheFolder%\boot.sdi" IF NOT EXIST "%CacheFolder%\boot.efi" ECHO.%COLOR4%ERROR:%$$% Files boot.sdi and boot.efi are not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
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
IF "%UPDATE_TYPE%"=="EFI" IF EXIST "%CacheFolder%\boot.efi" ECHO.Using boot.efi located in folder, for the efi bootloader.&&COPY /Y "%CacheFolder%\boot.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL
IF "%UPDATE_TYPE%"=="EFI" FOR %%a in (boot.sdi boot.efi) DO (IF NOT EXIST "%CacheFolder%\%%a" ECHO.File %%a is not located in folder, skipping.)
IF "%UPDATE_TYPE%"=="EFI" ECHO.Unmounting EFI...&&CALL:EFI_UNMOUNT&ECHO.Note: If you are unable to boot try disabling secure-boot in the bios or using a different bootloader.&GOTO:UPDATE_END
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
IF "%TARGET_TYPE%"=="WIM" ECHO. [%@@%WIM%$$%] (%##%T%$$%)arget %@@%%WIM_TARGET%%$$%         (%##%C%$$%)onvert          (%##%.%$$%)Compression %@@%%COMPRESS%%$$%&&CALL:PAD_LINE
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
IF "%SELECT%"=="." CALL:COMPRESS_LVL&SET "SELECT="
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
ECHO. %@@%%U13%LIST%$$%(%##%X%$$%)PACK%U05%%$$%  (%##%R%$$%)un List  (%##%E%$$%)dit List  (%##%B%$$%)uild List  (%##%.%$$%)Reference&&CALL:PAD_LINE
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
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U13% Reference&&ECHO.&&ECHO.            Select a reference image to load with the menu&&ECHO.&&ECHO.  %@@%AVAILABLE *.VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) %U06% Current Environment&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO. ( %##%.%$$% ) Disabled&&ECHO.
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF "%SELECT%"=="0" SET "REFERENCE=LIVE"
IF "%SELECT%"=="." SET "REFERENCE=DISABLED"
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
FOR %%a in ($HALT LIST_ITEMS_EXECUTE LIST_ITEMS_BUILDER DRVR_QRY FEAT_QRY SC_PREPARE RO_PREPARE) DO (SET "%%a=")
EXIT /B
:UNIFIED_PARSE_EXECUTE
IF NOT DEFINED COLUMN0 EXIT /B
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a IN ("!COLUMN0!") DO (SET "COLUMN1=%%a"&&SET "COLUMN2=%%b"&&SET "COLUMN3=%%c"&&SET "COLUMN4=%%d")
SET "$INPUT=!COLUMN1!"&&SET "$OUTPUT=COLUMN1"&&SET "$NO_QUOTE=1"&&CALL:EXPAND_INPUT
IF "!COLUMN1!"=="HALT" SET "$HALT=1"&&SET "COLUMN1="
FOR %%● in (COLUMN1 COLUMN4) DO (IF NOT DEFINED %%● EXIT /B)
FOR /F "TOKENS=* DELIMS=ⓡ" %%● IN ("!COLUMN1!") DO (IF NOT "%%●"=="!COLUMN1!" SET "COLUMN1=!COLUMN1:ⓡ=!"&&IF NOT DEFINED $VCLMX EXIT /B)
SET "@QUIET="&&FOR /F "TOKENS=* DELIMS=ⓠ" %%● IN ("!COLUMN1!") DO (IF NOT "%%●"=="!COLUMN1!" SET "@QUIET=1"&&SET "COLUMN1=!COLUMN1:ⓠ=!")
SET "$RAS="&&SET "$ITEM_TYPE="&&IF NOT DEFINED LIST_ITEMS_EXECUTE CALL:LIST_ITEMS
FOR %%● in (%LIST_ITEMS_EXECUTE%) DO (IF /I "%%●"=="!COLUMN1!" SET "$ITEM_TYPE=EXECUTE")
FOR %%● in (%LIST_ITEMS_BUILDER%) DO (IF /I "%%●"=="!COLUMN1!" SET "$ITEM_TYPE=BUILDER")
IF NOT DEFINED $ITEM_TYPE EXIT /B
IF /I "!COLUMN1!"=="GROUP" CALL:SESSION_CLEAR
IF "!$ITEM_TYPE!"=="BUILDER" FOR %%● in (ARRAY MATH STRING CONDIT PROMPT CHOICE PICKER ROUTINE INFO) DO (IF /I "%%●"=="!COLUMN1!" SET "COLUMN1=!COLUMN1!1")
IF "!$ITEM_TYPE!"=="BUILDER" CALL:SCRO_QUEUE&&FOR %%○ in (1 2 3 4 5 6 7 8 9 I S) DO (SET "!COLUMN1!.%%○=")
IF "!$ITEM_TYPE!"=="BUILDER" FOR /F "TOKENS=1 DELIMS=123456789" %%● IN ("!COLUMN1!") DO (CALL:%%●_ITEM)
IF "!$ITEM_TYPE!"=="EXECUTE" SET "$INPUT=!COLUMN4!"&&SET "$OUTPUT=COLUMN4"&&CALL:EXPAND_INPUT
IF "!$ITEM_TYPE!"=="EXECUTE" IF "!COLUMN4!"=="HALT" SET "$HALT=1"&&SET "COLUMN4="
IF "!$ITEM_TYPE!"=="EXECUTE" IF NOT DEFINED COLUMN4 EXIT /B
IF "!$ITEM_TYPE!"=="EXECUTE" FOR /F "TOKENS=*" %%● in ("!COLUMN4!") DO (IF /I "%%●"=="DX" CALL:!COLUMN1!_ITEM
FOR %%○ in (SC RO) DO (IF /I "%%●"=="%%○" CALL:SCRO_CREATE))
IF /I NOT "!CD!"=="!ProgFolder0!" CD /D "!ProgFolder0!">NUL 2>&1
EXIT /B
:iNFO_ITEM
EXIT /B
:TEXTHOST_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!"&&SET "$OUTPUT=ZCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (FILE SCREEN) DO (IF /I "!$ZCLM1$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not valid. Example: 'SCREEN' or 'FILE❗C:\TEXT.TXT'&&EXIT /B
IF /I "!$ZCLM1$!"=="FILE" IF EXIST "!$ZCLM2$!\*" ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not valid. Textfile target is a folder.&&EXIT /B
IF DEFINED QCLM2 SET "$QCLM2$=!QCLM2:%%=％!"&&SET "$QCLM2$=!$QCLM2$:◁=%%!"&&SET "$QCLM2$=!$QCLM2$:▷=%%!"&&SET "$QCLM2$=!$QCLM2$:＄=$!"&&FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (CALL SET "$QCLM2$=%%●"&&SET "$QCLM2$=!$QCLM2$:％=%%!")
IF /I "!$ZCLM1$!"=="FILE" FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (ECHO.%%●>>"!$ZCLM2$!")
IF /I "!$ZCLM1$!"=="SCREEN" FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (ECHO.%%●)
EXIT /B
:SESSION_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
CALL %CMD% /C ""%ProgFolder%\windick.cmd" !$QCLM2$!"
SET "MOUNT="&&CALL:MOUNT_INT
EXIT /B
:GROUP_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 in ("!$QCLM2$!%U01%!$QCLM3$!") DO (SET "GROUP=%%1"&&SET "SUBGROUP=%%2")
IF DEFINED $QCLM7$ FOR /F "TOKENS=*" %%● IN ("!$QCLM7$!") DO (SET "CHOICE0.I=%%●"
FOR %%○ in (1 2 3 4 5 6 7 8 9) DO (IF "%%●"=="%%○" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM6$!") DO (SET "CHOICE0.S=%%%$QCLM7$%"&&SET "CHOICE0.%%●=%%%$QCLM7$%")))
FOR %%● in (S I) DO (IF NOT DEFINED CHOICE0.%%● SET "CHOICE0.I="&&SET "CHOICE0.S=")
EXIT /B
:PICKER_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "!$QCLM1$!"=="PICKER" SET "$QCLM1$=!$QCLM1$!1"
FOR /F "TOKENS=*" %%○ in ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=%%○"&&SET "!$QCLM1$!.S=%%○")
EXIT /B
:PROMPT_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "!$QCLM1$!"=="PROMPT" SET "$QCLM1$=!$QCLM1$!1"
FOR /F "TOKENS=*" %%○ in ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.1=%%○"&&SET "!$QCLM1$!.S=%%○")
EXIT /B
:CHOICE_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "!$QCLM1$!"=="CHOICE" SET "$QCLM1$=!$QCLM1$!1"
FOR /F "TOKENS=*" %%○ IN ("!$QCLM4$!") DO (SET "!$QCLM1$!.I=%%○"
FOR %%◌ in (1 2 3 4 5 6 7 8 9) DO (IF "%%○"=="%%◌" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM3$!") DO (SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.%%◌=%%%$QCLM4$%")))
FOR %%○ in (S I) DO (IF NOT DEFINED !$QCLM1$!.%%○ SET "!$QCLM1$!.I="&&SET "!$QCLM1$!.S=")
EXIT /B
:STRING_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "!$QCLM1$!"=="STRING" SET "$QCLM1$=!$QCLM1$!1"
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
:EXPANDOFLEX
IF DEFINED $NO_QUOTE SET "$NO_QUOTE="&&SET "$INPUT=!$INPUT:"=!"
SET "!$OUTPUT!0=!$INPUT!"&&FOR /F "TOKENS=1-9 DELIMS=%DELIMS%" %%a in ("!$INPUT!") DO (SET "PART1=%%a"&&SET "PART2=%%b"&&SET "PART3=%%c"&&SET "PART4=%%d"&&SET "PART5=%%e"&&SET "PART6=%%f"&&SET "PART7=%%g"&&SET "PART8=%%h"&&SET "PART9=%%i")
FOR %%● in (1 2 3 4 5 6 7 8 9) DO (SET "$PART%%●="&&SET "!$OUTPUT!%%●="&&SET "$!$OUTPUT!%%●="&&SET "$!$OUTPUT!%%●$="&&IF DEFINED PART%%● SET "!$OUTPUT!%%●=!PART%%●!"&&SET "$PART%%●=!PART%%●:◁=%%!"&&SET "$PART%%●=!$PART%%●:▷=%%!"&&SET "$!$OUTPUT!%%●=!$PART%%●!"&&CALL SET "$!$OUTPUT!%%●$=!$PART%%●!"
IF DEFINED PART%%● IF NOT DEFINED $NULLED IF NOT DEFINED $!$OUTPUT!%%●$ SET "$!$OUTPUT!%%●$=!PART%%●!"
IF DEFINED PART%%● IF DEFINED $NULLED SET "$NULLED="&&IF NOT DEFINED $!$OUTPUT!%%●$ SET "$!$OUTPUT!%%●$=◁Null▷")
IF "!$OUTPUT!"=="QCLM" SET "$QCLM1$=!$QCLM1$:ⓡ=!"&&SET "$QCLM1$=!$QCLM1$:ⓠ=!"
FOR %%● in ($INPUT $OUTPUT) DO (SET "%%●=")
EXIT /B
:EXPAND_INPUT
FOR %%● in ($INPUT $OUTPUT) DO (IF NOT DEFINED %%● SET "$INPUT_OG="&&SET "$INPUT="&&SET "$OUTPUT="&&SET "$NO_QUOTE="&&EXIT /B)
IF DEFINED $NO_QUOTE SET "$NO_QUOTE="&&SET "$INPUT=!$INPUT:"=!"
SET "!$OUTPUT!="&&SET "$INPUT_OG=!$INPUT!"&&SET "$INPUT=!$INPUT:◁=%%!"&&SET "$INPUT=!$INPUT:▷=%%!"
IF DEFINED $INPUT FOR /F "TOKENS=*" %%● in ("!$INPUT!") DO (CALL SET "$INPUT=%%●")
IF NOT DEFINED $INPUT IF NOT DEFINED $NULLED SET "!$OUTPUT!=!$INPUT_OG!"
IF NOT DEFINED $INPUT IF DEFINED $NULLED SET "$NULLED="&&SET "!$OUTPUT!=◁Null▷"
IF DEFINED $INPUT SET "!$OUTPUT!=!$INPUT!"
FOR %%● in ($INPUT_OG $INPUT $OUTPUT) DO (SET "%%●=")
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
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "!$QCLM1$!"=="ARRAY" SET "$QCLM1$=!$QCLM1$!1"
SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=$QCLM2$"&&SET "$NULLED=1"&&CALL:EXPAND_INPUT
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM4!"&&SET "$OUTPUT=ACTN"&&SET "$NULLED=1"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!"&&SET "$OUTPUT=MATCH"&&SET "$NULLED=1"&&CALL:EXPANDOFLEX
IF /I NOT "!ACTN1!"=="◁NULL▷" IF /I NOT "!MATCH1!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH1$!" SET "!$QCLM1$!.I=1"&&SET "!$QCLM1$!.S=!$ACTN1$!"&&SET "!$QCLM1$!.1=!$ACTN1$!"&&EXIT /B
IF /I NOT "!ACTN2!"=="◁NULL▷" IF /I NOT "!MATCH2!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH2$!" SET "!$QCLM1$!.I=2"&&SET "!$QCLM1$!.S=!$ACTN2$!"&&SET "!$QCLM1$!.2=!$ACTN2$!"&&EXIT /B
IF /I NOT "!ACTN3!"=="◁NULL▷" IF /I NOT "!MATCH3!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH3$!" SET "!$QCLM1$!.I=3"&&SET "!$QCLM1$!.S=!$ACTN3$!"&&SET "!$QCLM1$!.3=!$ACTN3$!"&&EXIT /B
IF /I NOT "!ACTN4!"=="◁NULL▷" IF /I NOT "!MATCH4!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH4$!" SET "!$QCLM1$!.I=4"&&SET "!$QCLM1$!.S=!$ACTN4$!"&&SET "!$QCLM1$!.4=!$ACTN4$!"&&EXIT /B
IF /I NOT "!ACTN5!"=="◁NULL▷" IF /I NOT "!MATCH5!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH5$!" SET "!$QCLM1$!.I=5"&&SET "!$QCLM1$!.S=!$ACTN5$!"&&SET "!$QCLM1$!.5=!$ACTN5$!"&&EXIT /B
IF /I NOT "!ACTN6!"=="◁NULL▷" IF /I NOT "!MATCH6!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH6$!" SET "!$QCLM1$!.I=6"&&SET "!$QCLM1$!.S=!$ACTN6$!"&&SET "!$QCLM1$!.6=!$ACTN6$!"&&EXIT /B
IF /I NOT "!ACTN7!"=="◁NULL▷" IF /I NOT "!MATCH7!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH7$!" SET "!$QCLM1$!.I=7"&&SET "!$QCLM1$!.S=!$ACTN7$!"&&SET "!$QCLM1$!.7=!$ACTN7$!"&&EXIT /B
IF /I NOT "!ACTN8!"=="◁NULL▷" IF /I NOT "!MATCH8!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH8$!" SET "!$QCLM1$!.I=8"&&SET "!$QCLM1$!.S=!$ACTN8$!"&&SET "!$QCLM1$!.8=!$ACTN8$!"&&EXIT /B
IF /I NOT "!ACTN9!"=="◁NULL▷" IF /I NOT "!MATCH9!"=="◁ELSE▷" IF /I "!$QCLM2$!"=="!$MATCH9$!" SET "!$QCLM1$!.I=9"&&SET "!$QCLM1$!.S=!$ACTN9$!"&&SET "!$QCLM1$!.9=!$ACTN9$!"&&EXIT /B
SET "$MATCH_XNT="&&FOR %%□ IN (1 2 3 4 5 6 7 8 9) DO (IF DEFINED MATCH%%□ SET "$MATCH_XNT=%%□")
SET "ACTNX=!ACTN%$MATCH_XNT%!"&&SET "$ACTNX$=!$ACTN%$MATCH_XNT%$!"&&SET "MATCHX=!MATCH%$MATCH_XNT%!"&&SET "$MATCHX$=!$MATCH%$MATCH_XNT%$!"
IF /I NOT "!ACTNX!"=="◁NULL▷" IF /I "!MATCHX!"=="◁ELSE▷" SET "!$QCLM1$!.I=%$MATCH_XNT%"&&SET "!$QCLM1$!.S=!$ACTNX$!"&&SET "!$QCLM1$!.%$MATCH_XNT%=!$ACTNX$!"
EXIT /B
:ROUTINE_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "!$QCLM1$!"=="ROUTINE" SET "$QCLM1$=!$QCLM1$!1"
SET "$PASS="&&FOR %%□ IN (SPLIT COMMAND REGISTRY) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not SPLIT, COMMAND, or REGISTRY.&&EXIT /B
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=ROUT"&&CALL:EXPANDOFLEX
IF /I "!$QCLM3$!"=="REGISTRY" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: 'HKCU❗FontSize'&&EXIT /B)
IF /I "!$QCLM3$!"=="COMMAND" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: '^<^>❗DIR C:\ /B❗1❗TEST.TXT' or '^<^>❗DIR C:\ /B'&&EXIT /B)
IF /I "!$QCLM3$!"=="SPLIT" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: ':❗A:B:C❗3❗C' or ':❗A:B:C'&&EXIT /B)
GOTO:ROUTINE_%$QCLM3$%
:ROUTINE_REGISTRY
SET "$ROUTX$="&&SET "$INTG="
IF /I "!$QCLM4$!"=="INTEGER" SET "$INTG=/A "
IF /I "!ROUT2!"=="◁NULL▷" (SET "$ROUT2$=(Default)") ELSE (SET "$ROUTX$=!$ROUT2$!")
SET /A "$VAL_RETRY=1"&&FOR /F "TOKENS=1-9 DELIMS= " %%1 in ("!$ROUT2$!") do (IF NOT "%%1"=="" SET /A "$VAL_RETRY+=1"&&IF NOT "%%2"=="" SET /A "$VAL_RETRY+=1"&&IF NOT "%%3"=="" SET /A "$VAL_RETRY+=1"&&IF NOT "%%4"=="" SET /A "$VAL_RETRY+=1"&&IF NOT "%%5"=="" SET /A "$VAL_RETRY+=1"&&IF NOT "%%6"=="" SET /A "$VAL_RETRY+=1"&&IF NOT "%%7"=="" SET /A "$VAL_RETRY+=1"&&IF NOT "%%8"=="" SET /A "$VAL_RETRY+=1"&&IF NOT "%%9"=="" SET /A "$VAL_RETRY+=1")
FOR /F "TOKENS=1-%$VAL_RETRY%* SKIP=2 DELIMS=	 " %%1 in ('reg.exe query "!$ROUT1$!" /v "!$ROUTX$!" 2^>NUL') DO (
IF "!$VAL_RETRY!"=="2" IF /I "%%1"=="!$ROUT2$!" SET %$INTG%"!$QCLM1$!.S=%%3"&&SET %$INTG%"!$QCLM1$!.1=%%3"&&SET /A "!$QCLM1$!.I=1"&&EXIT /B
IF "!$VAL_RETRY!"=="3" IF /I "%%1 %%2"=="!$ROUT2$!" SET %$INTG%"!$QCLM1$!.S=%%4"&&SET %$INTG%"!$QCLM1$!.1=%%4"&&SET /A "!$QCLM1$!.I=1"&&EXIT /B
IF "!$VAL_RETRY!"=="4" IF /I "%%1 %%2 %%3"=="!$ROUT2$!" SET %$INTG%"!$QCLM1$!.S=%%5"&&SET %$INTG%"!$QCLM1$!.1=%%5"&&SET /A "!$QCLM1$!.I=1"&&EXIT /B
IF "!$VAL_RETRY!"=="5" IF /I "%%1 %%2 %%3 %%4"=="!$ROUT2$!" SET %$INTG%"!$QCLM1$!.S=%%6"&&SET %$INTG%"!$QCLM1$!.1=%%6"&&SET /A "!$QCLM1$!.I=1"&&EXIT /B
IF "!$VAL_RETRY!"=="6" IF /I "%%1 %%2 %%3 %%4 %%5"=="!$ROUT2$!" SET %$INTG%"!$QCLM1$!.S=%%7"&&SET %$INTG%"!$QCLM1$!.1=%%7"&&SET /A "!$QCLM1$!.I=1"&&EXIT /B
IF "!$VAL_RETRY!"=="7" IF /I "%%1 %%2 %%3 %%4 %%5 %%6"=="!$ROUT2$!" SET %$INTG%"!$QCLM1$!.S=%%8"&&SET %$INTG%"!$QCLM1$!.1=%%8"&&SET /A "!$QCLM1$!.I=1"&&EXIT /B
IF "!$VAL_RETRY!"=="8" IF /I "%%1 %%2 %%3 %%4 %%5 %%6 %%7"=="!$ROUT2$!" SET %$INTG%"!$QCLM1$!.S=%%9"&&SET %$INTG%"!$QCLM1$!.1=%%9"&&SET /A "!$QCLM1$!.I=1"&&EXIT /B)
EXIT /B
:ROUTINE_COMMAND
SET "$TOKENS=9"&&FOR /F "TOKENS=1 DELIMS=*" %%● IN ("!$QCLM4$!") DO (IF NOT "%%●"=="!$QCLM4$!" SET "$QCLM4$=%%●"&&SET "$TOKENS=%%●"&&SET /A "$TOKENS-=1"&&SET "$TOKENS=!$TOKENS!*")
FOR /F "TOKENS=1-%$TOKENS% DELIMS=%$ROUT1$%" %%1 in ('!$ROUT2$! 2^>NUL') DO (
IF NOT DEFINED $ROUT3$ SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.1=%%%$QCLM4$%"&&SET /A "!$QCLM1$!.I=1"
IF DEFINED $ROUT3$ IF /I "!$ROUT4$!"=="%%%$ROUT3$%" SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.1=%%%$QCLM4$%"&&SET "!$QCLM1$!.I=1")
EXIT /B
:ROUTINE_SPLIT
SET "$TOKENS=9"&&FOR /F "TOKENS=1 DELIMS=*" %%● IN ("!$QCLM4$!") DO (IF NOT "%%●"=="!$QCLM4$!" SET "$QCLM4$=%%●"&&SET "$TOKENS=%%●"&&SET /A "$TOKENS-=1"&&SET "$TOKENS=!$TOKENS!*")
FOR /F "TOKENS=1-%$TOKENS% DELIMS=%$ROUT1$%" %%1 in ("!$ROUT2$!") DO (
IF NOT "%%1"=="" SET "!$QCLM1$!.1=%%1"&&IF NOT "%%2"=="" SET "!$QCLM1$!.2=%%2"&&IF NOT "%%3"=="" SET "!$QCLM1$!.3=%%3"&&IF NOT "%%4"=="" SET "!$QCLM1$!.4=%%4"&&IF NOT "%%5"=="" SET "!$QCLM1$!.5=%%5"&&IF NOT "%%6"=="" SET "!$QCLM1$!.6=%%6"&&IF NOT "%%7"=="" SET "!$QCLM1$!.7=%%7"&&IF NOT "%%8"=="" SET "!$QCLM1$!.8=%%8"&&IF NOT "%%9"=="" SET "!$QCLM1$!.9=%%9"
IF NOT DEFINED $ROUT3$ SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET /A "!$QCLM1$!.I=!$QCLM4$!"
IF DEFINED $ROUT3$ IF /I "!$ROUT4$!"=="%%%$ROUT3$%" SET "!$QCLM1$!.S=%%%$QCLM4$%"&&SET "!$QCLM1$!.I=!$QCLM4$!")
EXIT /B
:MATH_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "!$QCLM1$!"=="MATH" SET "$QCLM1$=!$QCLM1$!1"
SET "$PASS="&&FOR %%□ IN (+ - /) DO (IF "!$QCLM3$!"=="*" SET "$PASS=1"
IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 OPERATION is not *, /, +, or -.&&EXIT /B
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET /A "!$QCLM1$!.I=1"&&SET /A "!$QCLM1$!.S=!$QCLM2$!"&&SET /A "!$QCLM1$!.S!$QCLM3$!=!$QCLM4$!"&&SET /A "!$QCLM1$!.1=!$QCLM1$!.S!"
EXIT /B
:CONDIT_ITEM
IF NOT DEFINED @QUIET ECHO.Executing %@@%!COLUMN1!%$$% item 
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
IF /I "!$QCLM1$!"=="CONDIT" SET "$QCLM1$=!$QCLM1$!1"
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=COND"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (EXIST NEXIST DEFINED NDEFINED EQ NE LE GE GT LT) DO (IF /I "!$COND2$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 CONDITION is not EQ, NE, LE, GE, GT, LT, EXIST, NEXIST, DEFINED or NDEFINED. Example: 'c:\❗EXIST' or '1❗EQ❗1' or 'CHOICE1❗DEFINED'&&EXIT /B
FOR %%□ IN (EQ NE LE GE GT LT) DO (IF /I "!$COND2$!"=="%%□" IF NOT DEFINED $COND3$ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 3 COMPARE is not specified. Example: '1❗EQ❗1'&&EXIT /B)
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
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$FILE_OBJ="&&SET "$PASS="&&FOR %%□ IN (CREATE DELETE RENAME COPY MOVE TAKEOWN) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not CREATE, DELETE, RENAME, COPY, MOVE, or TAKEOWN.&&EXIT /B
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
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$REG_OBJ="&&SET "$PASS="&&FOR %%□ IN (CREATE DELETE IMPORT EXPORT IMPORT%U01%RAS IMPORT%U01%RATI EXPORT%U01%RAS EXPORT%U01%RATI CREATE%U01%RAS CREATE%U01%RATI DELETE%U01%RAS DELETE%U01%RATI) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not CREATE, DELETE, IMPORT, EXPORT, CREATE%U01%RAS, CREATE%U01%RATI, DELETE%U01%RAS, or DELETE%U01%RATI.&&EXIT /B
FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$QCLM3$!") DO (SET "$QCLM3$=%%a"&&SET "$REG_OPER=%%a"&&SET "$RAS=%%b")
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=RCLM"&&CALL:EXPANDOFLEX
SET "$REG_KEY=!$RCLM1$!"&&SET "$REG_VAL=!$RCLM2$!"&&SET "$REG_TYPE=!$RCLM4$!"
IF DEFINED RCLM3 SET "$RCLM3$=!RCLM3:%%=％!"&&SET "$RCLM3$=!$RCLM3$:◁=%%!"&&SET "$RCLM3$=!$RCLM3$:▷=%%!"&&SET "$RCLM3$=!$RCLM3$:＄=$!"&&FOR /F "TOKENS=* DELIMS=" %%● in ("!$RCLM3$!") DO (CALL SET "$RCLM3$=%%●"&&SET "$RCLM3$=!$RCLM3$:％=%%!")
IF DEFINED $RCLM3$ SET "$REG_DAT=!$RCLM3$:"=""!"
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
SET "$INPUT=!COLUMN3!"&&SET "$OUTPUT=COLUMN3"&&CALL:EXPAND_INPUT
SET "$PASS="&&FOR %%□ IN (NORMAL NOMOUNT NORMAL%U01%RAU NORMAL%U01%RAS NORMAL%U01%RATI NOMOUNT%U01%RAU NOMOUNT%U01%RAS NOMOUNT%U01%RATI) DO (IF /I "!COLUMN3!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not NORMAL, NOMOUNT, NORMAL%U01%RAU, NORMAL%U01%RAS, NORMAL%U01%RATI, NOMOUNT%U01%RAU, NOMOUNT%U01%RAS, or NOMOUNT%U01%RATI.&&EXIT /B
IF /I "!COLUMN3!"=="NOMOUNT" CALL:IF_LIVE_MIX
IF /I "!COLUMN3!"=="NORMAL" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$QCLM3$!") DO (SET "$QCLM3$=%%a"&&SET "$RAS=%%b")
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF /I "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF /I "!$RAS!"=="RAS" SET "RUN_AS=system"
IF /I "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
IF DEFINED COLUMN0 SET "$COLUMN0=!COLUMN0:%%=％!"&&SET "$COLUMN0=!$COLUMN0:◁=%%!"&&SET "$COLUMN0=!$COLUMN0:▷=%%!"&&SET "$COLUMN0=!$COLUMN0:＄=$!"&&SET "$COLUMN0=!$COLUMN0:％=%%!"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ("!$COLUMN0!") DO (SET "$COLUMN2=%%b")
IF NOT DEFINED @QUIET ECHO.Executing %@@%!$QCLM1$!%$$% as %##%%RUN_AS%%$$% !$COLUMN2!
IF DEFINED $RAS ECHO.!$COLUMN2!>"$LIST"
IF DEFINED $RAS CALL:RASTI_CREATE
IF NOT DEFINED $RAS %CMD% /C !$COLUMN2!
SET "$COLUMN0="&&SET "$COLUMN2="
EXIT /B
:EXTPACKAGE_ITEM
CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (INSTALL) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not INSTALL.&&EXIT /B
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (SET "EXTPACKAGE=%PackFolder%\%%□"
IF NOT EXIST "%PackFolder%\%%□" ECHO.%COLOR4%ERROR:%$$% %PackFolder%\%%□ doesn't exist.&&EXIT /B)
SET "PACK_GOOD=The operation completed successfully"
FOR %%G in ("%EXTPACKAGE%") DO (SET "PACKFULL=%%~nG%%~xG"&&SET "PACKEXT=%%~xG")
IF /I "%PACKEXT%"==".PKX" CALL %CMD% /C ""%ProgFolder%\windick.cmd" -IMAGEMGR -RUN -PACK "%$QCLM2$%" -path "%DrvTar%""&EXIT /B
FOR %%G in (APPXBUNDLE MSIXBUNDLE) DO (IF /I "%PACKEXT%"==".%%G" SET "PACKEXT=.APPX")
IF NOT DEFINED @QUIET ECHO.Installing %@@%%PACKFULL%%$$%...
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
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing AppX %@@%%%□%$$%...)
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
CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Capability %@@%%%□%$$%...)
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /NORESTART /REMOVE-CAPABILITY /CAPABILITYNAME:"%$QCLM2$%" 2^>NUL') DO (IF "%%1"=="The operation completed successfully" CALL ECHO.%COLOR5%%%1.%$$%&&EXIT /B)
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Capability %%□ doesn't exist.)
EXIT /B
:COMPONENT_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Component %@@%%%□%$$%...)
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
CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (INSTALL DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not INSTALL or DELETE.&&EXIT /B)
IF /I "%$QCLM1$%:%$QCLM3$%:%$QCLM4$%"=="DRIVER:INSTALL:DX" CALL:DRVR_INSTALL
IF /I "%$QCLM1$%:%$QCLM3$%:%$QCLM4$%"=="DRIVER:DELETE:DX" CALL:DRVR_REMOVE
EXIT /B
:DRVR_INSTALL
SET "PACK_GOOD=The operation completed successfully"&&SET "PACK_BAD=The operation did not complete successfully"
FOR /F "TOKENS=*" %%a in ('DIR/S/B "%$QCLM2$%\*.INF" 2^>NUL') DO (
IF NOT EXIST "%%a\*" FOR %%G in ("%%a") DO (IF NOT DEFINED @QUIET CALL ECHO.Installing %@@%%%~nG.inf%$$%...)
IF NOT EXIST "%%a\*" IF DEFINED LIVE_APPLY SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('pnputil.exe /add-driver "%%a" /install 2^>NUL') DO (IF "%%1"=="Driver package added successfully" CALL SET "DISMSG=%PACK_GOOD%")
IF NOT EXIST "%%a\*" IF NOT DEFINED LIVE_APPLY SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%ApplyTarget% /ADD-DRIVER /DRIVER:"%%a" /ForceUnsigned 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" CALL SET "DISMSG=%PACK_GOOD%")
IF NOT EXIST "%%a\*" IF DEFINED DISMSG IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF NOT EXIST "%%a\*" IF NOT DEFINED DISMSG ECHO.%COLOR2%ERROR:%$$% %PACK_BAD%.)
EXIT /B
:DRVR_REMOVE
SET "FILE_OUTPUT=$DRVR"
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
CALL:IF_LIVE_MIX
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (ENABLE DISABLE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not ENABLE or DISABLE.&&EXIT /B)
SET "FILE_OUTPUT=$FEAT"&&IF NOT DEFINED FEAT_QRY IF EXIST "$FEAT" DEL /Q /F "$FEAT">NUL 2>&1
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
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (AUTO MANUAL DISABLE DELETE) DO (IF /I "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not AUTO, MANUAL, DISABLE, or DELETE.&&EXIT /B
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
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Task %@@%%%□%$$%...)
SET "TASKID="&&FOR /F "TOKENS=1-4 DELIMS={} " %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /V Id 2^>NUL') DO (IF "%%a"=="Id" SET "TASKID=%%c")
IF NOT DEFINED TASKID FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Task %%□ doesn't exist.&&EXIT /B)
SET "$RAS=RAS"&&CALL:RASTI_CREATE
FOR /F "TOKENS=1 DELIMS= " %%a IN ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /V Id 2^>NUL') DO (IF "%%a"=="Id" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
EXIT /B
:WINSXS_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF /I "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF DEFINED LIVE_APPLY ECHO.%COLOR4%ERROR:%$$% OFFLINE IMAGE ONLY&&EXIT /B
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
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
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
ECHO.❕Group❕%$BASE_GROUP%❕%U08%AppX❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=9* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
SET "$BCLM3=%U0L%CHOICE0.S%U0R%"&&FOR /F "TOKENS=9* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_FEATURE
ECHO.&&ECHO. %@@%Getting Feature Listing%$$%..&&ECHO.&&SET "$BCLM1=Feature"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Feature❕Scoped❕Select an option❕Enable❗Disable❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-9 DELIMS=|: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-FEATURES /FORMAT:TABLE 2^>NUL') DO (
IF "%%b"=="Enabled" SET "$BASE_CHOICE=Default is ENABLE"&&SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE
IF "%%b"=="Disabled" SET "$BASE_CHOICE=Default is DISABLE"&&SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE)
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_COMPONENT
ECHO.&&ECHO. %@@%Getting Component Listing%$$%..&&ECHO.&&SET "$BCLM1=Component"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Component❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=8* DELIMS=\" %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=~" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_CAPABILITY
ECHO.&&ECHO. %@@%Getting Capability Listing%$$%..&&ECHO.&&SET "$BCLM1=Capability"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Capability❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-2 DELIMS=|: " %%a in ('%DISM% /ENGLISH /%ApplyTarget% /GET-CAPABILITIES /FORMAT:TABLE 2^>NUL') DO (
IF "%%b"=="Installed" SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE)
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_SERVICE
ECHO.&&ECHO. %@@%Getting Service Listing%$$%..&&ECHO.&&SET "$BCLM1=Service"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Service❕Scoped❕Select an option❕Auto%U01%Manual%U01%Disable%U01%Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
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
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Task❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
FOR /F "TOKENS=1-3* DELIMS= " %%a in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree" /f ID /e /s 2^>NUL') DO (IF "%%b"=="REG_SZ" IF NOT "%%c"=="" FOR /F "TOKENS=2* DELIMS=\ " %%1 in ('%REG% QUERY "%HiveSoftware%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\%%c" /f PATH /e /s 2^>NUL') DO (IF "%%1"=="REG_SZ" IF NOT "%%2"=="" SET "BASE_WRITE=%%2"&&CALL:BASE_WRITE))
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
ECHO.>>"%ListFolder%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_DRIVER
ECHO.&&ECHO. %@@%Getting Driver Listing%$$%..&&ECHO.&&SET "$BCLM1=Driver"&&SET "$BCLM3=%U0L%Choice0.S%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕Group❕%$BASE_GROUP%❕%U08%Driver❕Scoped❕Select an option❕Delete❕VolaTILE❕>>"%ListFolder%\%NEW_NAME%.base"
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
IF DEFINED BASE_WRITE IF DEFINED BASE_WRITELAST IF "%BASE_WRITE%"=="%BASE_WRITELAST%" EXIT /B
SET "BASE_WRITELAST=!BASE_WRITE!"
ECHO.%@@%!$BCLM1!%$$% !BASE_WRITE!%$$%
ECHO.%U00%!$BCLM1!%U00%!BASE_WRITE!%U00%!$BCLM3!%U00%DX%U00%!$BASE_CHOICE!>>"%ListFolder%\%NEW_NAME%.base"
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
SET LIST_ITEMS_BUILDER=INFO INFO1 ARRAY ARRAY ARRAY1 ARRAY2 ARRAY3 ARRAY4 ARRAY5 ARRAY6 ARRAY7 ARRAY8 ARRAY9 MATH MATH1 MATH2 MATH3 MATH4 MATH5 MATH6 MATH7 MATH8 MATH9 STRING STRING1 STRING2 STRING3 STRING4 STRING5 STRING6 STRING7 STRING8 STRING9 CONDIT CONDIT1 CONDIT2 CONDIT3 CONDIT4 CONDIT5 CONDIT6 CONDIT7 CONDIT8 CONDIT9 PROMPT PROMPT1 PROMPT2 PROMPT3 PROMPT4 PROMPT5 PROMPT6 PROMPT7 PROMPT8 PROMPT9 CHOICE CHOICE1 CHOICE2 CHOICE3 CHOICE4 CHOICE5 CHOICE6 CHOICE7 CHOICE8 CHOICE9 PICKER PICKER1 PICKER2 PICKER3 PICKER4 PICKER5 PICKER6 PICKER7 PICKER8 PICKER9 ROUTINE ROUTINE1 ROUTINE2 ROUTINE3 ROUTINE4 ROUTINE5 ROUTINE6 ROUTINE7 ROUTINE8 ROUTINE9 GROUP
EXIT /B
:VAR_ITEMS
SET VAR_ITEMS=CHOICE0.I CHOICE1.I CHOICE2.I CHOICE3.I CHOICE4.I CHOICE5.I CHOICE6.I CHOICE7.I CHOICE8.I CHOICE9.I CHOICE0.S CHOICE1.S CHOICE2.S CHOICE3.S CHOICE4.S CHOICE5.S CHOICE6.S CHOICE7.S CHOICE8.S CHOICE9.S CHOICE0.1 CHOICE1.1 CHOICE2.1 CHOICE3.1 CHOICE4.1 CHOICE5.1 CHOICE6.1 CHOICE7.1 CHOICE8.1 CHOICE9.1 CHOICE0.2 CHOICE1.2 CHOICE2.2 CHOICE3.2 CHOICE4.2 CHOICE5.2 CHOICE6.2 CHOICE7.2 CHOICE8.2 CHOICE9.2 CHOICE0.3 CHOICE1.3 CHOICE2.3 CHOICE3.3 CHOICE4.3 CHOICE5.3 CHOICE6.3 CHOICE7.3 CHOICE8.3 CHOICE9.3 CHOICE0.4 CHOICE1.4 CHOICE2.4 CHOICE3.4 CHOICE4.4 CHOICE5.4 CHOICE6.4 CHOICE7.4 CHOICE8.4 CHOICE9.4 CHOICE0.5 CHOICE1.5 CHOICE2.5 CHOICE3.5 CHOICE4.5 CHOICE5.5 CHOICE6.5 CHOICE7.5 CHOICE8.5 CHOICE9.5 CHOICE0.6 CHOICE1.6 CHOICE2.6 CHOICE3.6 CHOICE4.6 CHOICE5.6 CHOICE6.6 CHOICE7.6 CHOICE8.6 CHOICE9.6 CHOICE0.7 CHOICE1.7 CHOICE2.7 CHOICE3.7 CHOICE4.7 CHOICE5.7 CHOICE6.7 CHOICE7.7 CHOICE8.7 CHOICE9.7 CHOICE0.8 CHOICE1.8 CHOICE2.8 CHOICE3.8 CHOICE4.8 CHOICE5.8 CHOICE6.8 CHOICE7.8 CHOICE8.8 CHOICE9.8 CHOICE0.9 CHOICE1.9 CHOICE2.9 CHOICE3.9 CHOICE4.9 CHOICE5.9 CHOICE6.9 CHOICE7.9 CHOICE8.9 CHOICE9.9 PROMPT1.I PROMPT2.I PROMPT3.I PROMPT4.I PROMPT5.I PROMPT6.I PROMPT7.I PROMPT8.I PROMPT9.I PROMPT1.S PROMPT2.S PROMPT3.S PROMPT4.S PROMPT5.S PROMPT6.S PROMPT7.S PROMPT8.S PROMPT9.S PROMPT1.1 PROMPT2.1 PROMPT3.1 PROMPT4.1 PROMPT5.1 PROMPT6.1 PROMPT7.1 PROMPT8.1 PROMPT9.1 STRING1.I STRING2.I STRING3.I STRING4.I STRING5.I STRING6.I STRING7.I STRING8.I STRING9.I STRING1.S STRING2.S STRING3.S STRING4.S STRING5.S STRING6.S STRING7.S STRING8.S STRING9.S STRING1.1 STRING2.1 STRING3.1 STRING4.1 STRING5.1 STRING6.1 STRING7.1 STRING8.1 STRING9.1 STRING1.2 STRING2.2 STRING3.2 STRING4.2 STRING5.2 STRING6.2 STRING7.2 STRING8.2 STRING9.2 STRING1.3 STRING2.3 STRING3.3 STRING4.3 STRING5.3 STRING6.3 STRING7.3 STRING8.3 STRING9.3 STRING1.4 STRING2.4 STRING3.4 STRING4.4 STRING5.4 STRING6.4 STRING7.4 STRING8.4 STRING9.4 STRING1.5 STRING2.5 STRING3.5 STRING4.5 STRING5.5 STRING6.5 STRING7.5 STRING8.5 STRING9.5 STRING1.6 STRING2.6 STRING3.6 STRING4.6 STRING5.6 STRING6.6 STRING7.6 STRING8.6 STRING9.6 STRING1.7 STRING2.7 STRING3.7 STRING4.7 STRING5.7 STRING6.7 STRING7.7 STRING8.7 STRING9.7 STRING1.8 STRING2.8 STRING3.8 STRING4.8 STRING5.8 STRING6.8 STRING7.8 STRING8.8 STRING9.8 STRING1.9 STRING2.9 STRING3.9 STRING4.9 STRING5.9 STRING6.9 STRING7.9 STRING8.9 STRING9.9 PICKER1.I PICKER2.I PICKER3.I PICKER4.I PICKER5.I PICKER6.I PICKER7.I PICKER8.I PICKER9.I PICKER1.S PICKER2.S PICKER3.S PICKER4.S PICKER5.S PICKER6.S PICKER7.S PICKER8.S PICKER9.S PICKER1.1 PICKER2.1 PICKER3.1 PICKER4.1 PICKER5.1 PICKER6.1 PICKER7.1 PICKER8.1 PICKER9.1 CONDIT1.I CONDIT2.I CONDIT3.I CONDIT4.I CONDIT5.I CONDIT6.I CONDIT7.I CONDIT8.I CONDIT9.I CONDIT1.S CONDIT2.S CONDIT3.S CONDIT4.S CONDIT5.S CONDIT6.S CONDIT7.S CONDIT8.S CONDIT9.S CONDIT1.1 CONDIT2.1 CONDIT3.1 CONDIT4.1 CONDIT5.1 CONDIT6.1 CONDIT7.1 CONDIT8.1 CONDIT9.1 CONDIT1.2 CONDIT2.2 CONDIT3.2 CONDIT4.2 CONDIT5.2 CONDIT6.2 CONDIT7.2 CONDIT8.2 CONDIT9.2 CONDIT1.3 CONDIT2.3 CONDIT3.3 CONDIT4.3 CONDIT5.3 CONDIT6.3 CONDIT7.3 CONDIT8.3 CONDIT9.3 CONDIT1.4 CONDIT2.4 CONDIT3.4 CONDIT4.4 CONDIT5.4 CONDIT6.4 CONDIT7.4 CONDIT8.4 CONDIT9.4 CONDIT1.5 CONDIT2.5 CONDIT3.5 CONDIT4.5 CONDIT5.5 CONDIT6.5 CONDIT7.5 CONDIT8.5 CONDIT9.5 CONDIT1.6 CONDIT2.6 CONDIT3.6 CONDIT4.6 CONDIT5.6 CONDIT6.6 CONDIT7.6 CONDIT8.6 CONDIT9.6 CONDIT1.7 CONDIT2.7 CONDIT3.7 CONDIT4.7 CONDIT5.7 CONDIT6.7 CONDIT7.7 CONDIT8.7 CONDIT9.7 CONDIT1.8 CONDIT2.8 CONDIT3.8 CONDIT4.8 CONDIT5.8 CONDIT6.8 CONDIT7.8 CONDIT8.8 CONDIT9.8 CONDIT1.9 CONDIT2.9 CONDIT3.9 CONDIT4.9 CONDIT5.9 CONDIT6.9 CONDIT7.9 CONDIT8.9 CONDIT9.9 ARRAY1.I ARRAY2.I ARRAY3.I ARRAY4.I ARRAY5.I ARRAY6.I ARRAY7.I ARRAY8.I ARRAY9.I ARRAY1.S ARRAY2.S ARRAY3.S ARRAY4.S ARRAY5.S ARRAY6.S ARRAY7.S ARRAY8.S ARRAY9.S ARRAY1.1 ARRAY2.1 ARRAY3.1 ARRAY4.1 ARRAY5.1 ARRAY6.1 ARRAY7.1 ARRAY8.1 ARRAY9.1 ARRAY1.2 ARRAY2.2 ARRAY3.2 ARRAY4.2 ARRAY5.2 ARRAY6.2 ARRAY7.2 ARRAY8.2 ARRAY9.2 ARRAY1.3 ARRAY2.3 ARRAY3.3 ARRAY4.3 ARRAY5.3 ARRAY6.3 ARRAY7.3 ARRAY8.3 ARRAY9.3 ARRAY1.4 ARRAY2.4 ARRAY3.4 ARRAY4.4 ARRAY5.4 ARRAY6.4 ARRAY7.4 ARRAY8.4 ARRAY9.4 ARRAY1.5 ARRAY2.5 ARRAY3.5 ARRAY4.5 ARRAY5.5 ARRAY6.5 ARRAY7.5 ARRAY8.5 ARRAY9.5 ARRAY1.6 ARRAY2.6 ARRAY3.6 ARRAY4.6 ARRAY5.6 ARRAY6.6 ARRAY7.6 ARRAY8.6 ARRAY9.6 ARRAY1.7 ARRAY2.7 ARRAY3.7 ARRAY4.7 ARRAY5.7 ARRAY6.7 ARRAY7.7 ARRAY8.7 ARRAY9.7 ARRAY1.8 ARRAY2.8 ARRAY3.8 ARRAY4.8 ARRAY5.8 ARRAY6.8 ARRAY7.8 ARRAY8.8 ARRAY9.8 ARRAY1.9 ARRAY2.9 ARRAY3.9 ARRAY4.9 ARRAY5.9 ARRAY6.9 ARRAY7.9 ARRAY8.9 ARRAY9.9 MATH1.I MATH2.I MATH3.I MATH4.I MATH5.I MATH6.I MATH7.I MATH8.I MATH9.I MATH1.S MATH2.S MATH3.S MATH4.S MATH5.S MATH6.S MATH7.S MATH8.S MATH9.S MATH1.1 MATH2.1 MATH3.1 MATH4.1 MATH5.1 MATH6.1 MATH7.1 MATH8.1 MATH9.1 ROUTINE1.I ROUTINE2.I ROUTINE3.I ROUTINE4.I ROUTINE5.I ROUTINE6.I ROUTINE7.I ROUTINE8.I ROUTINE9.I ROUTINE1.S ROUTINE2.S ROUTINE3.S ROUTINE4.S ROUTINE5.S ROUTINE6.S ROUTINE7.S ROUTINE8.S ROUTINE9.S ROUTINE1.1 ROUTINE2.1 ROUTINE3.1 ROUTINE4.1 ROUTINE5.1 ROUTINE6.1 ROUTINE7.1 ROUTINE8.1 ROUTINE9.1 ROUTINE1.2 ROUTINE2.2 ROUTINE3.2 ROUTINE4.2 ROUTINE5.2 ROUTINE6.2 ROUTINE7.2 ROUTINE8.2 ROUTINE9.2 ROUTINE1.3 ROUTINE2.3 ROUTINE3.3 ROUTINE4.3 ROUTINE5.3 ROUTINE6.3 ROUTINE7.3 ROUTINE8.3 ROUTINE9.3 ROUTINE1.4 ROUTINE2.4 ROUTINE3.4 ROUTINE4.4 ROUTINE5.4 ROUTINE6.4 ROUTINE7.4 ROUTINE8.4 ROUTINE9.4 ROUTINE1.5 ROUTINE2.5 ROUTINE3.5 ROUTINE4.5 ROUTINE5.5 ROUTINE6.5 ROUTINE7.5 ROUTINE8.5 ROUTINE9.5 ROUTINE1.6 ROUTINE2.6 ROUTINE3.6 ROUTINE4.6 ROUTINE5.6 ROUTINE6.6 ROUTINE7.6 ROUTINE8.6 ROUTINE9.6 ROUTINE1.7 ROUTINE2.7 ROUTINE3.7 ROUTINE4.7 ROUTINE5.7 ROUTINE6.7 ROUTINE7.7 ROUTINE8.7 ROUTINE9.7 ROUTINE1.8 ROUTINE2.8 ROUTINE3.8 ROUTINE4.8 ROUTINE5.8 ROUTINE6.8 ROUTINE7.8 ROUTINE8.8 ROUTINE9.8 ROUTINE1.9 ROUTINE2.9 ROUTINE3.9 ROUTINE4.9 ROUTINE5.9 ROUTINE6.9 ROUTINE7.9 ROUTINE8.9 ROUTINE9.9
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
SET "UsrFld="&&SET "MOUNT=INT"&&SET "HiveUser=HKEY_CURRENT_USER"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SOFTWARE"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SYSTEM"&&SET "ApplyTarget=ONLINE"&&SET "DrvTar=%SYSTEMDRIVE%"&&SET "WinTar=%WINDIR%"&&SET "UsrTar=%USERPROFILE%"
SET "UsrSid="&&FOR /F "TOKENS=2* SKIP=1 DELIMS=:\ " %%a in ('%REG% QUERY "HKLM\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUserSID 2^>NUL') do (IF "%%a"=="REG_SZ" SET "UsrSid=%%b")
IF DEFINED UsrSid SET "HiveUser=HKEY_USERS\%UsrSid%"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
IF NOT "%DEBUG%"=="ENABLED" EXIT /B
IF NOT EXIST "%DrvTar%" ECHO.ERROR: DrvTar "%DrvTar%" is unavailable
IF NOT EXIST "%WinTar%" ECHO.ERROR: WinTar "%WinTar%" is unavailable
IF NOT EXIST "%UsrTar%" ECHO.ERROR: UsrTar "%UsrTar%" is unavailable
EXIT /B
:MOUNT_EXT
SET "$GO="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\SoftwareX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "$GO=1")
IF NOT DEFINED $GO SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Mounting external registry hives..
IF "%MOUNT%"=="EXT" EXIT /B
SET "MOUNT=EXT"&&SET "HiveUser=HKEY_USERS\AllUsersX"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SoftwareX"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SystemX"&&SET "ApplyTarget=IMAGE:%TARGET_PATH%"&&SET "DrvTar=%TARGET_PATH%"&&SET "WinTar=%TARGET_PATH%\Windows"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
%REG% LOAD HKLM\SoftwareX "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SOFTWARE">NUL 2>&1
SET "UsrSid="&&FOR /F "TOKENS=2* SKIP=1 DELIMS=:\ " %%a in ('%REG% QUERY "HKLM\SoftwareX\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUserSID 2^>NUL') do (IF "%%a"=="REG_SZ" SET "UsrSid=%%b")
SET "UsrFld="&&FOR /F "TOKENS=2-3* SKIP=1 DELIMS=:\ " %%a in ('%REG% QUERY "HKLM\SoftwareX\Microsoft\Windows NT\CurrentVersion\ProfileList\%UsrSid%" /v ProfileImagePath 2^>NUL') do (IF "%%a"=="REG_EXPAND_SZ" SET "UsrFld=%%c")
IF DEFINED UsrFld IF EXIST "%TARGET_PATH%\%UsrFld%" SET "UsrTar=%TARGET_PATH%\%UsrFld%"
IF DEFINED UsrFld IF NOT EXIST "%TARGET_PATH%\%UsrFld%" SET "UsrFld="
IF NOT DEFINED UsrFld SET "UsrFld=Users\Default"&&SET "UsrTar=%TARGET_PATH%\Users\Default"
%REG% LOAD HKLM\SystemX "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SYSTEM">NUL 2>&1
%REG% LOAD HKU\AllUsersX "%UsrTar%\Ntuser.dat">NUL 2>&1
IF NOT "%DEBUG%"=="ENABLED" EXIT /B
SET "$GO1="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "%HiveSoftware%" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "$GO1=1")
SET "$GO2="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "%HiveSystem%" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "$GO2=1")
SET "$GO3="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "%HiveUser%" /VE 2^>NUL') DO (IF "%%X"=="HKEY_USERS" SET "$GO3=1")
IF NOT DEFINED $GO1 ECHO.ERROR: HiveSoftware "%HiveSoftware%" is unavailable
IF NOT DEFINED $GO2 ECHO.ERROR: HiveSystem "%HiveSystem%" is unavailable
IF NOT DEFINED $GO3 ECHO.ERROR: HiveUser "%HiveUser%" is unavailable
IF NOT EXIST "%DrvTar%" ECHO.ERROR: DrvTar "%DrvTar%" is unavailable
IF NOT EXIST "%WinTar%" ECHO.ERROR: WinTar "%WinTar%" is unavailable
IF NOT EXIST "%UsrTar%" ECHO.ERROR: UsrTar "%UsrTar%" is unavailable
EXIT /B
:MOUNT_MIX
FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\SoftwareX" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Unmounting external registry hives..)
IF "%MOUNT%"=="MIX" EXIT /B
SET "MOUNT=MIX"&&SET "HiveUser=HKEY_CURRENT_USER"&&SET "HiveSoftware=HKEY_LOCAL_MACHINE\SOFTWARE"&&SET "HiveSystem=HKEY_LOCAL_MACHINE\SYSTEM"&&SET "ApplyTarget=IMAGE:%TARGET_PATH%"&&SET "DrvTar=%TARGET_PATH%"&&SET "WinTar=%TARGET_PATH%\Windows"
%REG% UNLOAD HKU\AllUsersX>NUL 2>&1
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
%REG% UNLOAD HKLM\SystemX>NUL 2>&1
%REG% LOAD HKLM\SoftwareX "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SOFTWARE">NUL 2>&1
SET "UsrSid="&&FOR /F "TOKENS=2* SKIP=1 DELIMS=:\ " %%a in ('%REG% QUERY "HKLM\SoftwareX\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUserSID 2^>NUL') do (IF "%%a"=="REG_SZ" SET "UsrSid=%%b")
SET "UsrFld="&&FOR /F "TOKENS=2-3* SKIP=1 DELIMS=:\ " %%a in ('%REG% QUERY "HKLM\SoftwareX\Microsoft\Windows NT\CurrentVersion\ProfileList\%UsrSid%" /v ProfileImagePath 2^>NUL') do (IF "%%a"=="REG_EXPAND_SZ" SET "UsrFld=%%c")
IF DEFINED UsrFld IF EXIST "%TARGET_PATH%\%UsrFld%" SET "UsrTar=%TARGET_PATH%\%UsrFld%"
IF DEFINED UsrFld IF NOT EXIST "%TARGET_PATH%\%UsrFld%" SET "UsrFld="
IF NOT DEFINED UsrFld SET "UsrFld=Users\Default"&&SET "UsrTar=%TARGET_PATH%\Users\Default"
%REG% UNLOAD HKLM\SoftwareX>NUL 2>&1
IF NOT "%DEBUG%"=="ENABLED" EXIT /B
IF NOT EXIST "%DrvTar%" ECHO.ERROR: DrvTar "%DrvTar%" is unavailable
IF NOT EXIST "%WinTar%" ECHO.ERROR: WinTar "%WinTar%" is unavailable
IF NOT EXIST "%UsrTar%" ECHO.ERROR: UsrTar "%UsrTar%" is unavailable
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
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (SET "ADDFILE_NUM=%%a"&&CALL SET "ADDFILE_CHK=%%ADDFILE_%%a%%"&&CALL:ADDFILE_CHK)
ECHO.                             %U02% Add File&&ECHO.
FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (CALL ECHO. File ^(%##%%%G%$$%^) %@@%%%ADDFILE_%%G%%%$$%)
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
FOR %%G in (0 1 2 3 4 5 6 7 8 9) DO (IF "%SELECT%"=="%%G" SET "ADDFILEX=%SELECT%"&&CALL:ADDFILE_CHOOSE)
FOR %%a in (ADDFILE_CHK ADDFILE_NUM) DO (SET "%%a=")
GOTO:ADDFILE_MENU
:ADDFILE_CHOOSE
CLS&&SET "ADDFILEZ="&&IF "%FOLDER_MODE%"=="UNIFIED" SET "SELECTX=5"&&GOTO:ADDFILE_JUMP
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.&&ECHO. (%##%1%$$%) Package&&ECHO. (%##%2%$$%) List&&CALL ECHO. (%##%3%$$%) Image&&ECHO. (%##%4%$$%) Cache&&ECHO. (%##%5%$$%) Main&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER❗1-5"&&SET "$SELECT=SELECTX"&&CALL:MENU_SELECT
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" IF NOT "%SELECTX%"=="3" IF NOT "%SELECTX%"=="4" IF NOT "%SELECTX%"=="5" EXIT /B
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.
IF "%SELECTX%"=="1" SET "ADDFILEZ=◁PackFolder▷" ECHO.  %@@%AVAILABLE PACKAGEs:%$$%&&ECHO.&&SET "$FOLD=%PackFolder%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST
IF "%SELECTX%"=="2" SET "ADDFILEZ=◁ListFolder▷"&&ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%ListFolder%"&&SET "$FILT=*.LIST *.BASE"&&CALL:FILE_LIST
IF "%SELECTX%"=="3" SET "ADDFILEZ=◁ImageFolder▷"&&ECHO.  %@@%AVAILABLE IMAGEs:%$$%&&ECHO.&&SET "$FOLD=%ImageFolder%"&&SET "$FILT=*.WIM *.VHDX *.ISO"&&CALL:FILE_LIST
IF "%SELECTX%"=="4" SET "ADDFILEZ=◁CacheFolder▷"&&ECHO.  %@@%AVAILABLE CACHE FILEs:%$$%&&ECHO.&&SET "$FOLD=%CacheFolder%"&&SET "$FILT=*.*"&&CALL:FILE_LIST
:ADDFILE_JUMP
IF "%SELECTX%"=="5" SET "ADDFILEZ=◁ProgFolder▷"&&ECHO.  %@@%AVAILABLE MAIN FILEs:%$$%&&ECHO.&&SET "$FOLD=%ProgFolder%"&&SET "$FILT=*.*"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED ADDFILEZ IF DEFINED $PICK IF EXIST "%$PICK%" IF NOT EXIST "%$PICK%\*" SET "ADDFILE_%ADDFILEX%=%ADDFILEZ%\%$CHOICE%"
IF DEFINED ADDFILEZ IF NOT DEFINED $PICK SET "ADDFILE_%ADDFILEX%=SELECT"
EXIT /B
:ADDFILE_CHK
IF NOT DEFINED ADDFILE_%ADDFILE_NUM% SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%ADDFILE_CHK%"=="SELECT" EXIT /B
SET "$INPUT=!ADDFILE_CHK!"&&SET "$OUTPUT=ADDFILE_CHK"&&SET "$NO_QUOTE=1"&&CALL:EXPAND_INPUT
IF NOT EXIST "%ADDFILE_CHK%" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
EXIT /B
:EFI_FETCH
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.        EFI boot files will be extracted from the boot media.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:CONFIRM
IF NOT "%CONFIRM%"=="X" EXIT /B
CLS&&IF EXIST "%CacheFolder%\boot.sdi" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.         File boot.sdi already exists. Press (%##%X%$$%) to overwrite&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF EXIST "%CacheFolder%\boot.sdi" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%CacheFolder%\boot.efi" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.       File boot.efi already exists. Press (%##%X%$$%) to overwrite&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF EXIST "%CacheFolder%\boot.efi" IF NOT "%CONFIRM%"=="X" EXIT /B
SET "$HEADERS=                            %U15% Bootloader%U01% %U01%                          Select a bootloader"&&SET "$CHOICE_LIST=New%U01%Old"&&SET "$NO_ERRORS=1"&&CALL:CHOICE_BOX
IF "%SELECT%"=="1" SET "BOOTLOADERX=New"
IF "%SELECT%"=="2" SET "BOOTLOADERX=Old"
CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.            %@@%EFI EXPORT START:%$$%  %DATE%  %TIME%&&ECHO.&&CALL:VTEMP_CREATE&ECHO.Extracting boot-media. Using boot.sav located in folder...
SET "$IMAGE_X=%CacheFolder%\boot.sav"&&SET "INDEX_WORD=Setup"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%CacheFolder%\boot.sav" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF EXIST "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" ECHO.File boot.sdi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" "%CacheFolder%">NUL 2>&1
IF "%BOOTLOADERX%"=="Old" IF NOT EXIST "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" ECHO.ERROR: boot.efi missing
IF "%BOOTLOADERX%"=="New" IF NOT EXIST "%VDISK_LTR%:\Windows\Boot\EFI_EX\bootmgfw_EX.efi" ECHO.ERROR: boot.efi missing
IF "%BOOTLOADERX%"=="Old" IF EXIST "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" ECHO.File boot.efi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" "%CacheFolder%\boot.efi">NUL 2>&1
IF "%BOOTLOADERX%"=="New" IF EXIST "%VDISK_LTR%:\Windows\Boot\EFI_EX\bootmgfw_EX.efi" ECHO.File boot.efi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI_EX\bootmgfw_EX.efi" "%CacheFolder%\boot.efi">NUL 2>&1
IF NOT EXIST "%CacheFolder%\boot.sdi" ECHO.ERROR: boot.sdi missing
ECHO.&&ECHO.EFI boot files will be used during boot creation when selected in settings.&&ECHO.&&CALL:VTEMP_DELETE&&ECHO.&&ECHO.             %@@%EFI EXPORT END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED
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
IF "%BOOTLOADER%"=="boot.efi" IF EXIST "%CacheFolder%\boot.sdi" ECHO.Using boot.sdi located in folder, for efi image boot support.&&COPY /Y "%CacheFolder%\boot.sdi" "%EFI_LETTER%:\Boot">NUL
IF NOT EXIST "%EFI_LETTER%:\Boot\boot.sdi" COPY /Y "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" "%EFI_LETTER%:\Boot">NUL 2>&1
IF NOT EXIST "%EFI_LETTER%:\Boot\boot.sdi" ECHO.%COLOR2%ERROR:%$$% boot.sdi missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
IF "%BOOTLOADER%"=="boot.efi" IF NOT EXIST "%CacheFolder%\boot.efi" SET "BOOTLOADER=New"
IF "%BOOTLOADER%"=="Old" COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL 2>&1
IF "%BOOTLOADER%"=="New" COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI_EX\bootmgfw_EX.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL 2>&1
IF "%BOOTLOADER%"=="boot.efi" IF EXIST "%CacheFolder%\boot.efi" ECHO.Using boot.efi located in folder for the bootloader.&&COPY /Y "%CacheFolder%\boot.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL
IF NOT EXIST "%EFI_LETTER%:\EFI\Boot\bootx64.efi" ECHO.%COLOR2%ERROR:%$$% boot.efi missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
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
IF EXIST "%CacheFolder%\boot.efi" ECHO.Copying boot.efi...&&COPY /Y "%CacheFolder%\boot.efi" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
IF DEFINED PE_WALLPAPER IF EXIST "%CacheFolder%\%PE_WALLPAPER%" ECHO.Copying %PE_WALLPAPER%... &&COPY /Y "%CacheFolder%\%PE_WALLPAPER%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (CALL SET "ADDFILE_CHK=%%ADDFILE_%%a%%"&&CALL:ADDFILE_COPY)
IF DEFINED VHDX_SLOTX IF EXIST "%ImageFolder%\%VHDX_SLOTX%" IF EXIST "%PRI_LETTER%:\%HOST_FOLDER%" ECHO.Copying %VHDX_SLOTX%......&&COPY /Y "%ImageFolder%\%VHDX_SLOTX%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
ECHO.Note: If you are unable to boot try disabling secure-boot in the bios or using a different bootloader.)
CALL SET "VDISK_CHK=%%DISK_%DISK_DETECT%%%"
IF "%VDISK_CHK%"=="VDISK" SET "$LTR=%PRI_LETTER%"&&CALL:DISKMGR_UNMOUNT
:BOOT_FINISH
SET "ADDFILE_CHK="&&SET "VDISK_CHK="&&SET "PATH_TEMP="&&SET "PATH_FILE="&&SET "EFI_LETTER="&&SET "PRI_LETTER="&&SET "TST_LETTER="&&IF "%PROG_MODE%"=="RAMDISK" CALL:HOST_AUTO>NUL 2>&1
CALL:DEL_DISK&&ECHO.&&ECHO.            %@@%BOOT CREATOR END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:ADDFILE_COPY
IF "%ADDFILE_CHK%"=="SELECT" EXIT /B
SET "$INPUT=!ADDFILE_CHK!"&&SET "$OUTPUT=ADDFILE_CHK"&&SET "$NO_QUOTE=1"&&CALL:EXPAND_INPUT
IF EXIST "%ADDFILE_CHK%" IF NOT EXIST "%ADDFILE_CHK%\*" ECHO.Copying %ADDFILE_CHK%...&&COPY /Y "%ADDFILE_CHK%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
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
[DllImport("user32.dll", SetLastError = true)] private static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);
[DllImport("user32.dll", SetLastError = true)] private static extern bool DeleteMenu(IntPtr hMenu, uint uPosition, uint uFlags);
[DllImport("kernel32.dll", SetLastError = true)] private static extern IntPtr GetConsoleWindow();
private const uint SC_CLOSE = 0xF060;private const uint MF_BYCOMMAND = 0x00000000;
public static void DisableCloseButton() {
IntPtr hWnd = GetConsoleWindow();
if (hWnd != IntPtr.Zero) {IntPtr hMenu = GetSystemMenu(hWnd, false);
if (hMenu != IntPtr.Zero) {DeleteMenu(hMenu, SC_CLOSE, MF_BYCOMMAND);}}}
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
if (consoleOutputHandle == IntPtr.Zero) {return false;}
CONSOLE_FONT_INFO_EX fontInfo = new CONSOLE_FONT_INFO_EX();
fontInfo.cbSize = (uint)Marshal.SizeOf(fontInfo);GetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);fontInfo.dwFontSize.X = 0;fontInfo.dwFontSize.Y = fontSize;fontInfo.FaceName = fontName;return SetCurrentConsoleFontEx(consoleOutputHandle, false, ref fontInfo);} }
"@
$PSScriptRootX = "$($PWD.Path)";$ProjectFolder = "$PSScriptRootX\project";
if (Test-Path -Path "$PSScriptRootX\image") {$ImageFolder = "$PSScriptRootX\image"} else {$ImageFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\list") {$ListFolder = "$PSScriptRootX\list"} else {$ListFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\pack") {$PackFolder = "$PSScriptRootX\pack"} else {$PackFolder = "$PSScriptRootX"}
if (Test-Path -Path "$PSScriptRootX\cache") {$CacheFolder = "$PSScriptRootX\cache"} else {$CacheFolder = "$PSScriptRootX"}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Group-View {$ListItem = "";
if ($partXb -eq "ⓡRoutine") {$ListItem = "Routine";$global:Routine1 = ""}
if ($partXb -eq "ⓡArray") {$ListItem = "Array";$global:Array1 = ""}
if ($ListItem -eq "Array") {$ifX = ""
if ($partXc) {if ($partXc -ne "◁Null▷") {$stringX1 = $partXc.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$partXc = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($partXc)) {$partXc = "◁Null▷"}}}
if ($partXd) {$if1, $if2, $if3, $if4, $if5, $if6, $if7, $if8, $if9, $if10 = $partXd -split "[❗]"
if ($partXe) {$do1, $do2, $do3, $do4, $do5, $do6, $do7, $do8, $do9, $do10 = $partXe -split "[❗]"
if ($if1) {if ($do1) {if ($if1 -ne "◁Null▷") {if ($if1 -ne "◁Else▷") {$stringX1 = $if1.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if1 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if1)) {$if1 = "◁Null▷"}}}
if ($do1 -ne "◁Null▷") {$stringX1 = $do1.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do1 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if1") {$ArrayX = $do1;$ifX = 1} else {if ($if1 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do1;$ifX = 1}}}}}}
if ($if2) {if ($do2) {if ($if2 -ne "◁Null▷") {if ($if2 -ne "◁Else▷") {$stringX1 = $if2.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if2 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if2)) {$if3 = "◁Null▷"}}}
if ($do2 -ne "◁Null▷") {$stringX1 = $do2.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do2 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if2") {$ArrayX = $do2;$ifX = 2} else {if ($if2 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do2;$ifX = 2}}}}}}
if ($if3) {if ($do3) {if ($if3 -ne "◁Null▷") {if ($if3 -ne "◁Else▷") {$stringX1 = $if3.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if3)) {$if3 = "◁Null▷"}}}
if ($do3 -ne "◁Null▷") {$stringX1 = $do3.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if3") {$ArrayX = $do3;$ifX = 3} else {if ($if3 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do3;$ifX = 3}}}}}}
if ($if4) {if ($do4) {if ($if4 -ne "◁Null▷") {if ($if4 -ne "◁Else▷") {$stringX1 = $if4.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if4 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if4)) {$if4 = "◁Null▷"}}}
if ($do4 -ne "◁Null▷") {$stringX1 = $do4.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do4 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if4") {$ArrayX = $do4;$ifX = 4} else {if ($if4 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do4;$ifX = 4}}}}}}
if ($if5) {if ($do5) {if ($if5 -ne "◁Null▷") {if ($if5 -ne "◁Else▷") {$stringX1 = $if5.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if5 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if5)) {$if5 = "◁Null▷"}}}
if ($do5 -ne "◁Null▷") {$stringX1 = $do5.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do5 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if5") {$ArrayX = $do5;$ifX = 5} else {if ($if5 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do5;$ifX = 5}}}}}}
if ($if6) {if ($do6) {if ($if6 -ne "◁Null▷") {if ($if6 -ne "◁Else▷") {$stringX1 = $if6.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if6 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if6)) {$if6 = "◁Null▷"}}}
if ($do6 -ne "◁Null▷") {$stringX1 = $do6.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do6 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if6") {$ArrayX = $do6;$ifX = 6} else {if ($if6 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do6;$ifX = 6}}}}}}
if ($if7) {if ($do7) {if ($if7 -ne "◁Null▷") {if ($if7 -ne "◁Else▷") {$stringX1 = $if7.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if7 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if7)) {$if7 = "◁Null▷"}}}
if ($do7 -ne "◁Null▷") {$stringX1 = $do7.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do7 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if7") {$ArrayX = $do7;$ifX = 7} else {if ($if7 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do7;$ifX = 7}}}}}}
if ($if8) {if ($do8) {if ($if8 -ne "◁Null▷") {if ($if8 -ne "◁Else▷") {$stringX1 = $if8.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if8 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if8)) {$if8 = "◁Null▷"}}}
if ($do8 -ne "◁Null▷") {$stringX1 = $do8.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do8 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if8") {$ArrayX = $do8;$ifX = 8} else {if ($if8 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do8;$ifX = 8}}}}}}
if ($if9) {if ($do9) {if ($if9 -ne "◁Null▷") {if ($if9 -ne "◁Else▷") {$stringX1 = $if9.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$if9 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if (-not ($if9)) {$if9 = "◁Null▷"}}}
if ($do9 -ne "◁Null▷") {$stringX1 = $do9.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")");$do9 = $ExecutionContext.InvokeCommand.ExpandString($stringX2);if ($partXc -eq "$if9") {$ArrayX = $do9;$ifX = 9} else {if ($if9 -eq "◁Else▷") {if (-not ($ifX)) {$ArrayX = $do9;$ifX = 9}}}}}}
}}
if ($ifX) {
$global:Array1 = [PSCustomObject]@{
I = "$ifX"
S = "$ArrayX"
$ifX = "$ArrayX"}
}}
if ($ListItem -eq "Routine") {$RoutineX = ""
if ($partXd -eq "Registry") {
if ($partXc) {$regkeyX, $regvalX = $partXc -split "[❗]"}
if ($regvalX -eq "◁NULL▷") {$regvalZ = "(Default)";$regvalX = ""} else {$regvalZ = "$regvalX"}
$stringX1 = $regkeyX.Replace("◁", "`$(`$");$stringX2 = $stringX1.Replace("▷", ")")
$stringX3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$stringV1 = $regvalX.Replace("◁", "`$(`$");$stringV2 = $stringV1.Replace("▷", ")")
$stringV3 = $ExecutionContext.InvokeCommand.ExpandString($stringV2)
$scriptblockX = { cmd.exe /c "@ECHO OFF&FOR /F `"TOKENS=* SKIP=2`" %1 in ('reg.exe query `"$stringX3`" /v `"$stringV3`" 2^>NUL') do (echo %1)" }
$scriptblockZ = [scriptblock]::create($scriptblockX)
$commandX = Invoke-command $scriptblockZ
Foreach ($line in $commandX) {
$Part1g, $Part2g, $Part3g = $line -split '    '
if ($Part1g -eq $regvalZ) {$RoutineX = $Part3g}
if ($RoutineX) {
$stringX1 = $RoutineX.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$RoutineX = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
if ($partXe -eq 'Integer') {$RoutineX = $RoutineX.Replace("0x", "")}}
$global:Routine1 = [PSCustomObject]@{
I = "1"
S = "$RoutineX"
1 = "$RoutineX"
}}}
if ($partXd -eq "Command") {
if ($partXc) {$delims, $command, $columntar, $columnstr = $partXc -split "[❗]"}
$stringX1 = $command.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$command = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$scriptblockX = { cmd.exe /c "@ECHO OFF&FOR /F `"TOKENS=1-9 DELIMS=$delims`" %1 in ('$command 2^>NUL') do (echo %1%2%3%4%5%6%7%8%9)" }
$scriptblockZ = [scriptblock]::create($scriptblockX)
$commandX = Invoke-command $scriptblockZ
#if (-not ($waitX)) {$global:waitX = 1;Start-Sleep -Milliseconds 250}
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
$doublebuffer = $listview.GetType().GetProperty("DoubleBuffered", [System.Reflection.BindingFlags] "NonPublic, Instance");$doublebuffer.SetValue($listview, $true, $null)
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
function MessageBoxAbout {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxText)
$formboxX = New-Object System.Windows.Forms.Form
$formboxX.SuspendLayout()
$WSIZ = [int](450 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](550 * $ScaleRef * $GUI_SCALE)
$formboxX.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$formboxX.Text = "About";#NoTitleBar
$formboxX.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formboxX.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formboxX.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formboxX.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$formboxX.StartPosition = "CenterScreen"
$formboxX.FormBorderStyle = 'FixedDialog'
$formboxX.AutoSizeMode = 'GrowAndShrink'
$formboxX.FormBorderStyle = 'FixedDialog'
$formboxX.MaximizeBox = $false
$formboxX.MinimizeBox = $true
$formboxX.ControlBox = $False
$formboxX.AutoScale = $true
$formboxX.AutoSize = $true
$formboxX.WindowState = 'Normal'
$WSIZ = [int](450 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](50 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](430 * $ScaleRef * $GUI_SCALE)
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
$labelbox.Text = "For info visit github.com/joshuacline"
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](155 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](485 * $ScaleRef * $GUI_SCALE)
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
$Page = 'x';$pictureBase64 = $logo_main;$PictureBox1_PageSP = NewPictureBox -X '15' -Y '15' -W '420' -H '420';$formboxX.Controls.Add($PictureBox1_PageSP);
$formboxX.Controls.Add($labelbox)
$formboxX.AcceptButton = $okButton
$formboxX.Controls.Add($okButton)
$formboxX.ResumeLayout()
$formboxX.ShowDialog()
$formboxX.Dispose()
}
function MessageBoxListView {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxText)
$formboxX = New-Object System.Windows.Forms.Form
$formboxX.SuspendLayout()
$WSIZ = [int](700 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](500 * $ScaleRef * $GUI_SCALE)
$formboxX.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($MessageBoxTitle) {$formboxX.Text = "$MessageBoxTitle"} else {$formboxX.Text = "Select an option"}
$formboxX.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formboxX.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formboxX.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formboxX.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$formboxX.StartPosition = "CenterScreen"
$formboxX.FormBorderStyle = 'FixedDialog'
$formboxX.AutoSizeMode = 'GrowAndShrink'
$formboxX.FormBorderStyle = 'FixedDialog'
$formboxX.MaximizeBox = $false
$formboxX.MinimizeBox = $true
$formboxX.ControlBox = $False
$formboxX.AutoScale = $true
$formboxX.AutoSize = $true
$formboxX.WindowState = 'Normal'
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](543 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](405 * $ScaleRef * $GUI_SCALE)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.Add_Click({
if ($ListViewBox.CheckedItems) {$global:checkedItemsX = $ListViewBox.CheckedItems | ForEach-Object {$ListWriteX = 0
$partaa, $ListViewCheckedX, $partcc = $_ -split '[{}]'
Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partYa, $partYb, $partYc, $partYd, $partYe, $partYf, $partYg, $partYh, $partYi, $partYj, $partYk, $partYl, $partYm, $partYn = $_ -split "[❕]"
if ($partYc -eq $ListViewCheckedX) {Add-Content -Path "$ListFolder\`$LIST" -Value "$_" -Encoding UTF8;}}}
} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}})
$okButton.DialogResult = "OK"
$okButton.Cursor = 'Hand'
$okButton.Text = "OK"
$WSIZ = [int](635 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](365 * $ScaleRef * $GUI_SCALE)
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
$doublebufferX = $ListViewBox.GetType().GetProperty("DoubleBuffered", [System.Reflection.BindingFlags] "NonPublic, Instance");$doublebufferX.SetValue($ListViewBox, $true, $null)
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
function MessageBoxInfo {
param([string]$MessageBoxSize,[string]$MessageBoxTitle,[string]$MessageBoxLabel,[string]$MessageBoxBody)
$formboxX = New-Object System.Windows.Forms.Form
$formboxX.SuspendLayout()
if (-not ($MessageBoxSize -eq "Small")) {if (-not ($MessageBoxSize -eq "Large")) {$MessageBoxSize = "Small"}}
if ($MessageBoxSize -eq "Small") {$WSIZ = [int](500 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](275 * $ScaleRef * $GUI_SCALE)}
if ($MessageBoxSize -eq "Large") {$WSIZ = [int](500 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](500 * $ScaleRef * $GUI_SCALE)}
$formboxX.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($MessageBoxTitle) {$formboxX.Text = "$MessageBoxTitle"} else {$formboxX.Text = "Select an option"}
$formboxX.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formboxX.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formboxX.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formboxX.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$formboxX.StartPosition = "CenterScreen"
$formboxX.FormBorderStyle = 'FixedDialog'
$formboxX.AutoSizeMode = 'GrowAndShrink'
$formboxX.FormBorderStyle = 'FixedDialog'
$formboxX.MaximizeBox = $false
$formboxX.MinimizeBox = $true
$formboxX.ControlBox = $False
$formboxX.AutoScale = $true
$formboxX.AutoSize = $true
$formboxX.WindowState = 'Normal'
$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](39 * $ScaleRef * $GUI_SCALE);$XLOC = [int](0 * $ScaleRef * $GUI_SCALE);$YLOC = [int](15 * $ScaleRef * $GUI_SCALE)
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
$labelbox.Text = "$MessageBoxLabel"
$formboxX.Controls.Add($labelbox)
if ($MessageBoxSize -eq "Small") {$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](130 * $ScaleRef * $GUI_SCALE);$XLOC = [int](0 * $ScaleRef * $GUI_SCALE);$YLOC = [int](50 * $ScaleRef * $GUI_SCALE)}
if ($MessageBoxSize -eq "Large") {$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](325 * $ScaleRef * $GUI_SCALE);$XLOC = [int](0 * $ScaleRef * $GUI_SCALE);$YLOC = [int](59 * $ScaleRef * $GUI_SCALE)}
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
$labelbox.Text = "$MessageBoxBody"
if ($MessageBoxSize -eq "Small") {$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE);$XLOC = [int](350 * $ScaleRef * $GUI_SCALE);$YLOC = [int](185 * $ScaleRef * $GUI_SCALE)}
if ($MessageBoxSize -eq "Large") {$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE);$XLOC = [int](350 * $ScaleRef * $GUI_SCALE);$YLOC = [int](420 * $ScaleRef * $GUI_SCALE)}
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
$formboxX.Controls.Add($labelbox)
$formboxX.AcceptButton = $okButton
$formboxX.Controls.Add($okButton)
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
$DropBox6_PageSC.Tag = 'Disable'
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
if ($DropBox6_PageSC.Tag -eq 'Enable') {DropBox6SC}
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
if ($DropBox1_PageLB.SelectedItem) {$null} else {$DropBox1_PageLB.Items.Clear();[void]$DropBox1_PageLB.Items.Add("🪟 Current Environment");[void]$DropBox1_PageLB.Items.Add("Disabled");Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
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
if ($($DropBox6_PageSC.SelectedItem)) {$null} else {
$DropBox6_PageSC.ResetText();$DropBox6_PageSC.Items.Clear();
[void]$DropBox6_PageSC.Items.Add("New");[void]$DropBox6_PageSC.Items.Add("Old");;if (Test-Path -Path $CacheFolder\boot.efi) {[void]$DropBox6_PageSC.Items.Add("boot.efi")}
$DropBox6_PageSC.SelectedItem = "$BOOTLOADER"}
if ($($DropBox6_PageSC.SelectedItem) -eq "boot.efi") {if (Test-Path -Path $CacheFolder\boot.efi) {$null} else {$DropBox6_PageSC.SelectedItem = "New"}}
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
$drvLetter = ($Image | Get-Volume).DriveLetter;$target = "$FilePath"
if (Test-Path -Path "$drvLetter`:\sources\install.esd") {$source = "$drvLetter`:\sources\install.esd"}
if (Test-Path -Path "$drvLetter`:\sources\install.wim") {$source = "$drvLetter`:\sources\install.wim"}
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
if (Test-Path -Path "$target\install.esd") {Rename-Item -Path "$target\install.esd" -NewName "install.wim"}
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
if ($REFERENCE -eq "Refresh") {$DropBox1_PageLB.Items.Clear();[void]$DropBox1_PageLB.Items.Add("🪟 Current Environment");[void]$DropBox1_PageLB.Items.Add("Disabled");Get-ChildItem -Path "$ImageFolder\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
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
function DropBox6SC {
if ($DropBox6SCChanged -eq '1') {
$global:BOOTLOADER = "$($DropBox6_PageSC.SelectedItem)"
Add-Content -Path "$PSScriptRootX\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRootX\windick.ini" -Value "BOOTLOADER=$($DropBox6_PageSC.SelectedItem)" -Encoding UTF8}
$global:DropBox6SCChanged = '1';
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
function LBWiz_Stage2 {$global:LBWiz_Stage = 2;
$GRP = $null;if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {
if ($ListMode -eq "Builder") {$global:ListViewSelectS2 = $ListView1_PageLBWiz.FocusedItem}}
$parta, $global:BaseFile, $partc = $ListViewSelectS2 -split '[{}]';

if ($BaseFile -eq "🧾 Miscellaneous") {$global:LBWiz_Type = 'MISC';}
if ($BaseFile -ne "🧾 Miscellaneous") {
$LBWiz_TypeZ = Get-Content -Path "$ListFolder\\$BaseFile" -TotalCount 1
$global:LBWiz_Type, $partbxyz = $LBWiz_TypeZ -split '[ ]'
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
if ($REFERENCE -ne 'DISABLED') {
if ($REFERENCE -eq 'LIVE') {MOUNT_INT}
if ($REFERENCE -ne 'LIVE') {if (-not ($vdiskltr)) {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Mounting Reference Image...";VDISK_ATTACH}}}

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
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
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
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.CheckBoxes = $true;$Label1_PageLBWiz.Text = "🧾 $BaseFile";
$Label2_PageLBWiz.Text = "Loading $ListViewChoiceS3..."
$global:SubGroupLast = "";$ReadGroup = "";Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]"
if ($partXb -eq 'GROUP') {if ($partXc -eq $ListViewChoiceS3) {$ReadGroup = 1} else {$ReadGroup = ""}}
if ($ReadGroup) {
if ($partXb) {$GrpViewChk1, $GrpViewChk2 = $partXb -split "[ⓡ]";if (-not ("$GrpViewChk1$GrpViewChk2" -eq "$partXb")) {if ($REFERENCE -ne 'DISABLED') {Group-View}}}
if ($partXb -eq 'GROUP') {
if ($partXc -eq $ListViewChoiceS3) {
if ($SubGroupLast) {$SubGroupLastOG = $SubGroupLast
$stringX1 = $SubGroupLast.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$stringX3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$item1 = New-Object System.Windows.Forms.ListViewItem("$stringX3")
$item1.SubItems.Add("$SubGroupLastOG")
[void]$ListView1_PageLBWiz.Items.Add($item1)
}
$global:GroupLast = $partXc;$global:SubGroupLast = $partXd}
$global:Array1 = "";$global:Routine1 = "";$global:Condit1 = ""}
}}
if ($SubGroupLast) {$SubGroupLastOG = $SubGroupLast
$stringX1 = $SubGroupLast.Replace("◁", "`$(`$")
$stringX2 = $stringX1.Replace("▷", ")")
$stringX3 = $ExecutionContext.InvokeCommand.ExpandString($stringX2)
$item1 = New-Object System.Windows.Forms.ListViewItem("$stringX3")
$item1.SubItems.Add("$SubGroupLastOG")
[void]$ListView1_PageLBWiz.Items.Add($item1)}
$global:Condit1 = "";$global:Array1 = "";$global:Routine1 = ""
$Label2_PageLBWiz.Text = "$ListViewChoiceS3";
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4GRP {$global:LBWiz_Stage = 4;
if (Test-Path -Path "$ListFolder\`$LIST") {Remove-Item -Path "$ListFolder\`$LIST" -Force}
if ($ListMode -eq 'Execute') {Add-Content -Path "$ListFolder\`$LIST" -Value "MENU-SCRIPT" -Encoding UTF8}
ForEach ($checkedItem in $ListView1_PageLBWiz.CheckedItems) {$ListWrite = 0
$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250
if ($partXb) {$GrpViewChk1, $GrpViewChk2 = $partXb -split "[ⓡ]";if (-not ("$GrpViewChk1$GrpViewChk2" -eq "$partXb")) {if ($REFERENCE -ne 'DISABLED') {Group-View}}}
$ListViewChecked = $checkedItem.SubItems[1].Text;$ListViewCheckedExpand = $checkedItem.SubItems[0].Text
Get-Content "$ListFolder\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]";if ($partXb) {$partXb = $partXb.Replace("ⓠ", "")}

if ($partXb -eq 'GROUP') {if ($partXc -ne $ListViewChoiceS3) {$ListWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXd -ne $ListViewChecked) {$ListWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXc -eq $ListViewChoiceS3) {if ($partXd -eq $ListViewChecked) {$ListWrite = 1}}}
if ($partXb -eq 'GROUP') {if ($partXe -eq "SCOPED") {if ($partXc -eq $ListViewChoiceS3) {if ($partXd -eq $ListViewChecked) {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewChecked" -MessageBoxText "$partXf" -MessageBoxChoices "$partXg";$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250;Add-Content -Path "$ListFolder\`$LIST" -Value "`❕$partXb`❕$partXc`❕$partXd`❕$partXe`❕$partXf`❕$partXg`❕$boxindex`❕" -Encoding UTF8
$ListWrite = 0;MessageBoxListView;return}}}}
if ($ListWrite -eq '1') {$ListPrompt = $null;
ForEach ($i in @("PROMPT","PROMPT1","PROMPT2","PROMPT3","PROMPT4","PROMPT5","PROMPT6","PROMPT7","PROMPT8","PROMPT9")) {if ($i -eq "$partXb") {$ListPrompt = 1;$Label1_PageLBWiz.Text = "$ListViewChoiceS3";$Label2_PageLBWiz.Text = "$ListViewCheckedExpand";$partw1, $partx1 = $partXd -split "❗";$party1, $partz1 = $partx1 -split "-";MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -Check "$partw1" -TextMin "$party1" -TextMax "$partz1";$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250;Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxoutput`❕" -Encoding UTF8}}
ForEach ($i in @("CHOICE","CHOICE1","CHOICE2","CHOICE3","CHOICE4","CHOICE5","CHOICE6","CHOICE7","CHOICE8","CHOICE9")) {if ($i -eq "$partXb") {$ListPrompt = 2;$Label1_PageLBWiz.Text = "$ListViewChoiceS3";$Label2_PageLBWiz.Text = "$ListViewCheckedExpand";MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -MessageBoxChoices "$partXd";$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250;Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxindex`❕" -Encoding UTF8}}
ForEach ($i in @("PICKER","PICKER1","PICKER2","PICKER3","PICKER4","PICKER5","PICKER6","PICKER7","PICKER8","PICKER9")) {if ($i -eq "$partXb") {$ListPrompt = 3;$Label1_PageLBWiz.Text = "$ListViewChoiceS3";$Label2_PageLBWiz.Text = "$ListViewCheckedExpand";MessageBox -MessageBoxType 'Picker' -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxText "$partXc" -MessageBoxChoices "$partXd";$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250;Add-Content -Path "$ListFolder\`$LIST" -Value "`❕ⓠ$partXb`❕$partXc`❕$partXd`❕$boxoutput`❕" -Encoding UTF8}}
ForEach ($i in @("INFO","INFO1")) {if ($i -eq "$partXb") {$Label1_PageLBWiz.Text = "$ListViewChoiceS3";$Label2_PageLBWiz.Text = "$ListViewCheckedExpand";MessageBoxInfo -MessageBoxSize "$partXe" -MessageBoxTitle "$ListViewCheckedExpand" -MessageBoxLabel "$partXc" -MessageBoxBody "$partXd";$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Generating List...";Start-Sleep -Milliseconds 250}}
if ($ListPrompt -eq $null) {Add-Content -Path "$ListFolder\`$LIST" -Value "$_" -Encoding UTF8}
}}}

if ($ListMode -eq 'Builder') {
$Label1_PageLBWiz.Text = "💾 Append Items"
$Label2_PageLBWiz.Text = "Select a list"
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();[void]$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
Get-ChildItem -Path "$ListFolder\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($ListMode -eq 'Execute') {if ($REFERENCE -ne 'LIVE') {if ($REFERENCE -ne "Disabled") {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH}}
$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront()}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5GRP {
if ($REFERENCE -ne 'LIVE') {if ($REFERENCE -ne "Disabled") {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH}}
$Label1_PageLBWiz.Text = "💾 Append Items";$Label2_PageLBWiz.Text = "Select a list"
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
$LoadINIX = $LoadINI -replace '\\', '\\\\'
$Settings = $LoadINIX | ConvertFrom-StringData
$global:REFERENCE = $Settings.REFERENCE
if ($REFERENCE -eq "DISABLED") {$global:REFERENCE = "Disabled"}
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
$global:BOOTLOADER = $Settings.BOOTLOADER
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
[DllImport(\"user32.dll\", SetLastError = true)] private static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);
[DllImport(\"user32.dll\", SetLastError = true)] private static extern bool DeleteMenu(IntPtr hMenu, uint uPosition, uint uFlags);
[DllImport(\"kernel32.dll\", SetLastError = true)] private static extern IntPtr GetConsoleWindow();
private const uint SC_CLOSE = 0xF060;private const uint MF_BYCOMMAND = 0x00000000;
public static void DisableCloseButton() {
IntPtr hWnd = GetConsoleWindow();
if (hWnd != IntPtr.Zero) {IntPtr hMenu = GetSystemMenu(hWnd, false);
if (hMenu != IntPtr.Zero) {DeleteMenu(hMenu, SC_CLOSE, MF_BYCOMMAND);}}}
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
if (consoleOutputHandle == IntPtr.Zero) {return false;}
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
[VOID][WinMekanix]::DisableCloseButton()
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
[string]$logo_main=@"
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
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
$PictureBoxSplashX = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($logo_main))
$PictureBoxSplash.Image = $PictureBoxSplashX
$SplashForm.Controls.Add($PictureBoxSplash)
$PictureBoxSplash.Visible = $true;$PictureBoxSplash.BringToFront()
$SplashForm.Show()
Start-Sleep -Milliseconds 350
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
[VOID][WinMekanix]::DisableCloseButton()
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
$Slider1_PageSC = NewSlider -X '500' -Y '120' -W '225' -H '60' -Value "$GUI_SLIDE"
$LabelX_PageSC = NewLabel -X '490' -Y '85' -W '585' -H '35' -Text "GUI Scale Factor $($Slider1_PageSC.Value)%"

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
$Button4_PageSC = NewButton -X '262' -Y '510' -W '225' -H '60' -Text 'About' -Hover_Text 'About' -Add_Click {MessageBoxAbout}

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
$Label7_PageSC = NewLabel -X '530' -Y '505' -W '585' -H '35' -Text 'Bootloader'
$DropBox6_PageSC = NewDropBox -X '530' -Y '540' -W '190' -H '40' -C '0' -Text ""
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
if ($LBWiz_Type -eq 'MENU-SCRIPT') {if ($REFERENCE -ne 'LIVE') {if ($REFERENCE -ne "Disabled") {$Label1_PageLBWiz.Text = "";$Label2_PageLBWiz.Text = "Unmounting Reference Image...";VDISK_DETACH}}}
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
#$FilePathOut = "C:\gif.gif";$Base64String = "x";$FileContent = [Convert]::FromBase64String($Base64String);[System.IO.File]::WriteAllBytes($FilePathOut, $FileContent)
#$FilePathIn = "C:\gif.gif";$FileContent = Get-Content -Path "$FilePathIn" -Encoding Byte;$Base64Out = [System.Convert]::ToBase64String($FileContent);Write-Host "$Base64Out"
#77u/RVhFQy1MSVNU
#$NewBlankList = [Convert]::FromBase64String($EmptyNoneList);[System.IO.File]::WriteAllBytes($ListTar, $NewBlankList)
[string]$EmptyList=@"
77u/
"@
[string]$shazzam_img=@"
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
"@
[string]$splashjpg1=@"
/9j/4gIoSUNDX1BST0ZJTEUAAQEAAAIYAAAAAAQwAABtbnRyUkdCIFhZWiAAAAAAAAAAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAAHRyWFlaAAABZAAAABRnWFlaAAABeAAAABRiWFlaAAABjAAAABRyVFJDAAABoAAAAChnVFJDAAABoAAAAChiVFJDAAABoAAAACh3dHB0AAAByAAAABRjcHJ0AAAB3AAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAFgAAAAcAHMAUgBHAEIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAABvogAAOPUAAAOQWFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAJKAAAA+EAAC2z3BhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABYWVogAAAAAAAA9tYAAQAAAADTLW1sdWMAAAAAAAAAAQAAAAxlblVTAAAAIAAAABwARwBvAG8AZwBsAGUAIABJAG4AYwAuACAAMgAwADEANv/bAEMADQkKCwoIDQsLCw8ODRAUIRUUEhIUKB0eGCEwKjIxLyouLTQ7S0A0OEc5LS5CWUJHTlBUVVQzP11jXFJiS1NUUf/bAEMBDg8PFBEUJxUVJ1E2LjZRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUVFRUf/AABEIAiwBoAMBIgACEQEDEQH/xAAcAAEAAQUBAQAAAAAAAAAAAAAABAECAwUGBwj/xAA9EAABBAEDAwIEBQQABQEJAAABAAIDBBEFEiETMUEGURQiMmEjQlJxgQcVkaEWJDNiwbElNDVDU9Hh8PH/xAAZAQEBAQEBAQAAAAAAAAAAAAAAAQIDBAX/xAApEQEBAAICAgICAgIBBQAAAAAAAQIRAyESMUFRInEEE2GRIzIzQmKB/9oADAMBAAIRAxEAPwDzBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERARFXCCiKvZUQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQFstPZZqxvuNrB7WjhzxwPutcO62dnWp59PZTDWsjaMHHlS7+Gct/DXSyOlkc931OOSrERVoREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBVVEQdJpDtGr6a6Wzh85zlpWlFd9uy/wCFhcWk8ADsoy6jTNfo6dp7GMrkzY+Yrnd49ztwymWG7j3a5iRjo3ljhhwOCFas9yf4m1JNjG85wsC6O0EREUREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQFkgjMszIxwXHCxq+J5jka8d2nKFdda9MRQ6O50YL7AGcrlLFaas4NmjLCRkZXc6P6jj1CeOs6PadnJJ7laz1s+u50LWOaZR3x4XDDLOZeOTwcPJy48n9fJHJoiLu94iIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiINnpGjWNUeemMRju4rJrmiu0ox5kDw9ZNE19+lQvi6Qka457qJqurWNTlDpcBo+lo8LH5eX+HD/k/s/9UKKR8Tw+Nxa4eQqPe+Rxc9xcT5Ko0FxAAySt9pXpue1iSx+FH357lXLKY910zzxwm8mhwcZxwqLuL1KhW0mWFkYALMiQ+SuIPdMcvKbZ4+Sck3FERFp1EREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBEWx0Wky7d2SZ2tG4geUt0lupuqaPXllvxPbGXNa4F3sF1mtak3TWMDsvefmYBwMfdSq8UFSItga0N2Zwfp/krR+sZGyRVCHNcSO7ey83l/ZnHz/Oc3LNzpoL2o2Lr8yvO3w0dgoiIvTrT6EknUEREUREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERARXxxvkcGsaXE+At/p3pp8xIsv6bi3LW+Vm5Se2M+THD/qrnVO0q42lbEjwTGQWuA9lGswur2Hwu7tOFiV9tdZR0P8AxJsd0Y4B8KARsPcrVX777rm5aGsYMNaPAUNEmMnpnHjxx7kERFWxERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBVaNzgB5KostZwbYjc7sHAlCu003TIKlB0nSBcGZLh9WVlkvPY6vZLxFWDfmD/qKtbqb4nTPc1jawZlhz3OFx1mzYvWfmcXFxw0Lz44XK7yfO4+LLkytzU1GcWb80zeznEhRV0+nemxtbNcOQTjaD2/daz1BQbQ1B0cYxGRlq6zKW6j14cuFvhi1aIrmMc9wa0Ek+Atuy1VwVvaHp+R0ZsWyWRt5LR9RWyv6VC/QXSRV+k5hyM9yFi8kl04Xnwl049FVUW3cREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERBkdNI5oa55LR2GV0np3RmOdFbncefmaAOP5XLrqKeoMOn1XusiMQHD2fqCxnvWo480y8dYtzdfWn0yRxsBoifl3T/9Fx2sXxfsh7QQ1o2jPdSL+p/E769KHZFI7JA7uWaj6bnnZvmeI+MhvlYwxmE3XHiwx4ZvOtJGzqSNYO5OF2emafFWlEbK30jL5nft4XIgGrdAcOY3rsYnvfqENx9pra7mja0nz+yvJvXTf8i3x6SKUZEVr4cyOkcOHv8AJ+y1Ysy0KNoX7AdLMMNjzkhZ2zWqmoS2rlhrYQCGtz3H2C5G1KZrEkhcTucSMrGGG725cPFu2310xHklURF6HuEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQFc3kge5VqyVwDOwO7bhlCu30nS4qhhcyJrtzQ5z3f+FPriPqTOEL9vbe7uf2UKS9WqX4Ig2SSRwAHs0LG5s1XVfirtwNjz8kfuD9l48pbe3yMplne/lo/VNVsV/qxj5Hj/a0vUfx85wO3PZdD6vc4yQ7hgHJBHkLm16cO8Y+jwW3jm2SWeWY5ke5x+5WNEW3YREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQFUHByqK5jXPdtaCSfAQddBbnl0aGep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
"@
[string]$splashjpg2=@"
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
"@
$Page = 'PageConsole';$pictureBase64 = $shazzam_img;$PictureBoxConsole = NewPictureBox -X '940' -Y '606' -W '60' -H '60';$PictureBoxConsole.Visible = $false
$Page = 'PageSP';if ($BGIMG -eq 'Dark') {$pictureBase64 = $splashjpg1} else {$pictureBase64 = $splashjpg2}
$PictureBox1_PageMain = NewPictureBox -X '25' -Y '80' -W '700' -H '560';
$Page = 'PageMain';$Button_SP = NewPageButton -X '-5' -Y '630' -W '50' -H '40' -C '0' -Text '';$Button_SPImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($shazzam_img));$Button_SP.Image = $Button_SPImage
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