::Windows Deployment Image Customization Kit v 1215 (c) github.com/joshuacline
::Build, administrate and backup your Windows in a native WinPE recovery environment.
@ECHO OFF&&SETLOCAL ENABLEDELAYEDEXPANSION&&SET "ARGS=%*"
FOR %%1 in (0 1 2 3 4 5 6 7 8 9) DO (CALL SET "ARG%%1=%%%%1%%")
GOTO:GET_INIT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:MAIN_MENU
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "MOUNT="&&IF NOT DEFINED MENU_MODE SET "MENU_MODE=NORMAL"
IF "%PROG_MODE%"=="RAMDISK" FOR %%a in (BASIC CUSTOM) DO (IF "%MENU_MODE%"=="%%a" GOTO:%MENU_MODE%_MODE)
IF EXIST "%PROG_FOLDER%\windick.ps1" IF NOT "%GUI_LAUNCH%"=="DISABLED" IF NOT "%WINPE_BOOT%"=="1" START powershell -WindowStyle Hidden -executionpolicy bypass "%PROG_FOLDER%\windick.ps1"&GOTO:QUIT
IF EXIST "%PROG_SOURCE%\$PKX" ECHO.Cleaning up pkx folder from previous session...&&SET "FOLDER_DEL=%PROG_SOURCE%\$PKX"&&CALL:FOLDER_DEL
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:GET_SPACE_ENV&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.              Windows Deployment Image Customization Kit&&ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% 0 %$$%) %U09% Change Boot Order
ECHO. (%##% 1 %$$%) %U07% Image Processing&&ECHO. (%##% 2 %$$%) %U08% Image Management&&ECHO. (%##% 3 %$$%) %U11% Other Management&&ECHO. (%##% 4 %$$%) %U04% BootDisk Creator&&ECHO. (%##% 5 %$$%) %U03% Settings
ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" IF "%PROG_SOURCE%"=="Z:\%HOST_FOLDERX%" ECHO.          ^< Disk %@@%%HOST_NUMBER%%$$% UID %@@%%HOST_TARGET%%$$% ^>
IF "%PROG_MODE%"=="RAMDISK" IF "%PROG_SOURCE%"=="X:\$" ECHO.        ^< Disk %COLOR2%ERROR%$$% UID %COLOR2%%HOST_TARGET%%$$% ^>
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&TITLE Windows Deployment Image Customization Kit v%VER_CUR%  (%PROG_SOURCE%)
IF "%PROG_MODE%"=="RAMDISK" ECHO.  (%##%Q%$$%)uit  (%##%*%$$%) Basic Menu                                    %@@%%FREE%GB%$$% Free
IF "%PROG_MODE%"=="PORTABLE" IF "%WINPE_BOOT%"=="1" ECHO.  (%##%Q%$$%)uit                                                   %@@%%FREE%GB%$$% Free
IF "%PROG_MODE%"=="PORTABLE" IF NOT "%WINPE_BOOT%"=="1" IF EXIST "%PROG_FOLDER%\windick.ps1" ECHO.  (%##%Q%$$%)uit  (%##%*%$$%) %U06% Switch to GUI                            %@@%%FREE%GB%$$% Free
IF "%PROG_MODE%"=="PORTABLE" IF NOT "%WINPE_BOOT%"=="1" IF NOT EXIST "%PROG_FOLDER%\windick.ps1" ECHO.  (%##%Q%$$%)uit                                                   %@@%%FREE%GB%$$% Free
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
:BASIC_MODE
@ECHO OFF&&SET "MOUNT="&&CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:GET_SPACE_ENV&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.              Windows Deployment Image Customization Kit&&ECHO.&&ECHO.&&ECHO. (%##% 0 %$$%) %U09% Change Boot Order&&ECHO. (%##% 1 %$$%) %U07% Backup&&ECHO. (%##% 2 %$$%) %U07% Restore
ECHO.&&ECHO.&&IF "%PROG_MODE%"=="RAMDISK" IF "%PROG_SOURCE%"=="Z:\%HOST_FOLDERX%" ECHO.          ^< Disk %@@%%HOST_NUMBER%%$$% UID %@@%%HOST_TARGET%%$$% ^>
IF "%PROG_MODE%"=="RAMDISK" IF "%PROG_SOURCE%"=="X:\$" ECHO.        ^< Disk %COLOR2%ERROR%$$% UID %COLOR2%%HOST_TARGET%%$$% ^>
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&TITLE Windows Deployment Image Customization Kit v%VER_CUR%  (%PROG_SOURCE%)
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
IF NOT EXIST "%LIST_FOLDER%\%MENU_LIST%" SET "MENU_LIST="&&GOTO:MAIN_MENU
SET "$HEAD_CHECK=%LIST_FOLDER%\%MENU_LIST%"&&CALL:GET_HEADER
IF NOT "%$HEAD%"=="MENU-SCRIPT" ECHO.&&ECHO.%COLOR4%ERROR:%$$% %MENU_LIST% is not a base or execution list. Leaving custom menu.&&ECHO.&&CALL:PAUSED&GOTO:MAIN_MENU
SET "TIMER_MSG= %$$%Executing %@@%%MENU_LIST%%$$% in [ %COLOR4%%%TIMER%%%$$% ] seconds. %##%Close window to abort.%$$%"&&SET "TIMER=10"&&CALL:TIMER&&SET "MENU_MODE=CUSTOM"&&CALL:SETS_HANDLER
CLS&&CALL %CMD% /C ""%PROG_SOURCE%\windick.cmd" -IMAGEMGR -RUN -LIST "%MENU_LIST%" -MENU"
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
IF NOT "%ALLOW_ENV%"=="ENABLED" SET "ALLOW_ENVO=1"&&SET "ALLOW_ENV=ENABLED"
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
IF "%ARG1%"=="-IMAGEPROC" CALL:COMMAND_IMAGEPROC
IF DEFINED ALLOW_ENVO SET "ALLOW_ENV="
GOTO:QUIT
:COMMAND_IMAGEPROC
IF "%ARG2%"=="-WIM" IF DEFINED ARG3 IF NOT EXIST "%IMAGE_FOLDER%\%ARG3%" ECHO.%COLOR4%ERROR:%$$% WIM %IMAGE_FOLDER%\%ARG3% doesn't exist&&EXIT /B
IF "%ARG2%"=="-VHDX" IF DEFINED ARG3 IF NOT EXIST "%IMAGE_FOLDER%\%ARG3%" ECHO.%COLOR4%ERROR:%$$% VHDX %IMAGE_FOLDER%\%ARG3% doesn't exist&&EXIT /B
IF "%ARG2%"=="-WIM" IF DEFINED ARG3 IF EXIST "%IMAGE_FOLDER%\%ARG3%" IF "%ARG4%"=="-INDEX" IF DEFINED ARG5 IF "%ARG6%"=="-VHDX" IF DEFINED ARG7 IF "%ARG8%"=="-SIZE" IF DEFINED ARG9 SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"&&SET "WIM_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "VHDX_TARGET=%ARG7%"&&SET "VHDX_SIZE=%ARG9%"&&CALL:IMAGEPROC_START
SET "$IDX="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25) DO (IF "%ARG5%"=="%%a" SET "$IDX=X")
FOR %%■ in (WIM VHDX) DO (IF "%ARG2%"=="-%%■" IF DEFINED ARG3 IF EXIST "%IMAGE_FOLDER%\%ARG3%" IF NOT DEFINED $IDX ECHO.%COLOR4%ERROR:%$$% Invalid index, trying index 1.&&SET "ARG5=1")
IF "%ARG2%"=="-VHDX" IF DEFINED ARG3 IF EXIST "%IMAGE_FOLDER%\%ARG3%" IF "%ARG4%"=="-INDEX" IF DEFINED ARG5 IF "%ARG6%"=="-WIM" IF DEFINED ARG7 IF "%ARG8%"=="-XLVL" IF DEFINED ARG9 SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"&&SET "VHDX_SOURCE=%ARG3%"&&SET "WIM_INDEX=%ARG5%"&&SET "WIM_TARGET=%ARG7%"&&SET "COMPRESS=%ARG9%"&&CALL:IMAGEPROC_START
EXIT /B
:COMMAND_IMAGEMGR
SET "$PASS="&&SET "$LISTPACK="&&FOR %%▓ in (NEWPACK EXAMPLE EXPORT CREATE RUN) DO (IF "%ARG2%"=="-%%▓" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.ERROR: ARG2 not -NEWPACK, -EXPORT, -EXAMPLE, -CREATE, or -RUN&&EXIT /B
IF "%ARG2%"=="-NEWPACK" SET "MENU_SKIP=1"&&CALL:PROJ_NEW
IF "%ARG2%"=="-EXAMPLE" IF DEFINED ARG3 SET "NEW_NAME=%ARG3%"&&SET "MENU_SKIP=1"&&CALL:BASE_TEMPLATE
IF "%ARG2%"=="-EXPORT" IF "%ARG3%"=="-DRIVERS" IF "%ARG4%"=="-LIVE" SET "LIVE_APPLY=1"&&CALL:DRVR_EXPORT_SKIP
IF "%ARG2%"=="-EXPORT" IF "%ARG3%"=="-DRIVERS" IF "%ARG4%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG5 IF EXIST "%IMAGE_FOLDER%\%ARG5%" SET "$PICK=%IMAGE_FOLDER%\%ARG5%"&&CALL:DRVR_EXPORT_SKIP
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-BASE" IF DEFINED ARG4 SET "NEW_NAME=%ARG4%"&&IF "%ARG5%"=="-LIVE" SET "LIVE_APPLY=1"&&SET "BASE_CHOICE=%ARG6%"&&CALL:LIST_BASE_CREATE_CMD
IF "%ARG2%"=="-CREATE" IF "%ARG3%"=="-BASE" IF DEFINED ARG4 SET "NEW_NAME=%ARG4%"&&IF "%ARG5%"=="-VHDX" SET "LIVE_APPLY="&&IF DEFINED ARG6 IF EXIST "%IMAGE_FOLDER%\%ARG6%" SET "$PICK=%IMAGE_FOLDER%\%ARG6%"&&SET "BASE_CHOICE=%ARG7%"&&CALL:LIST_BASE_CREATE_CMD
IF "%ARG2%"=="-RUNEXT" IF DEFINED ARG3 IF DEFINED ARG4 IF EXIST "%ARG4%" SET "INPUT=%ARG4%"&&CALL:GET_FILEEXT
IF "%ARG2%"=="-RUNEXT" IF DEFINED ARG3 IF DEFINED ARG4 IF EXIST "%ARG4%" SET "INPUT=%$PATH_X%"&&SET "OUTPUT=$PATH_X"&&CALL:SLASHER&&FOR /F "TOKENS=1 DELIMS=." %%a IN ("%EXT_UPPER%") DO (SET "ARG3=-%%a")
IF "%ARG2%"=="-RUNEXT" IF "%ARG3%"=="-LIST" IF EXIST "%ARG4%" SET "ARG2=-RUN"&&SET "LIST_FOLDER=%$PATH_X%"&&SET "ARG4=%$FILE_X%%$EXT_X%"
IF "%ARG2%"=="-RUNEXT" IF "%ARG3%"=="-PACK" IF EXIST "%ARG4%" SET "PACK_FOLDER=%$PATH_X%"&&SET "ARG4=%$FILE_X%%$EXT_X%"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-CUSTOM" SET "CUSTOM_SESSION=1"&&SET "DELETE_DONE=%ARG4%"&&SET "ARG3=-LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-PACK" IF DEFINED ARG4 IF NOT EXIST "%PACK_FOLDER%\%ARG4%" ECHO.%COLOR4%ERROR:%$$% pack %PACK_FOLDER%\%ARG4% doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ARG4 IF NOT EXIST "%LIST_FOLDER%\%ARG4%" ECHO.%COLOR4%ERROR:%$$% list %LIST_FOLDER%\%ARG4% doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-VHDX" IF DEFINED ARG6 IF NOT EXIST "%IMAGE_FOLDER%\%ARG6%" ECHO.%COLOR4%ERROR:%$$% vhdx %IMAGE_FOLDER%\%ARG6% doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF NOT DEFINED ARG6 ECHO.%COLOR4%ERROR:%$$% path [%ARG6%] is not defined&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF DEFINED ARG6 IF NOT EXIST "%ARG6%\*" ECHO.%COLOR4%ERROR:%$$% path %ARG6% doesn't exist&&EXIT /B
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 SET "PARSE_X="&&FOR /F "TOKENS=1-9* DELIMS=%U00%" %%a in ('ECHO.%ARGS%') DO (IF "%%b"=="COMMAND" SET "PARSE_X=1"&&SET "ARG4=%U00%%%b%U00%%%c%U00%%%d%U00%%%e%U00%"&&SET "ARGZ=5"&&CALL SET "ARGX=%%f"&&CALL:GET_ARGS)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED PARSE_X FOR /F "TOKENS=1-6* DELIMS= " %%a in ('ECHO.%ARG5%') DO (SET "ARG5=%%a"&&SET "ARG6=%%b"&&SET "ARG7=%%c"&&SET "ARG8=%%d"&&SET "ARG9=%%e")
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED PARSE_X SET "PARSE_X="&&FOR %%a in (5 6 7 8 9) DO (SET "CAPS_SET=ARG%%a"&&CALL SET "CAPS_VAR=%%ARG%%a%%"&&CALL:CAPS_SET)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 SET "DELETE_DONE=1"&&SET "ARG3=-LIST"&&SET "ARG4=$LIST"&&ECHO.MENU-SCRIPT>"%LIST_FOLDER%\$LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-ITEM" IF DEFINED ARG4 ECHO.%ARG4%>"%LIST_FOLDER%\$LIST"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-PACK" IF DEFINED ARG4 IF EXIST "%PACK_FOLDER%\%ARG4%" SET "$PACK_FILE=%PACK_FOLDER%\%ARG4%"&&SET "$LISTPACK=%ARG4%"
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ARG4 IF EXIST "%LIST_FOLDER%\%ARG4%" SET "$LIST_FILE=%LIST_FOLDER%\%ARG4%"&&SET "$LISTPACK=%ARG4%"
IF NOT DEFINED $LISTPACK GOTO:COMMAND_IMAGEMGR_END
IF "%ARG2%"=="-RUN" FOR %%G in ("%$LISTPACK%") DO (SET "CAPS_SET=IMAGEMGR_EXT"&&SET "CAPS_VAR=%%~xG"&&CALL:CAPS_SET)
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF "%IMAGEMGR_EXT%"==".BASE" SET "BASE_EXEC=1"&&CALL:LIST_VIEWER&SET "IMAGEMGR_EXT=.LIST"&SET "$HEAD=MENU-SCRIPT"&SET "$LISTPACK=$LIST"&SET "$LIST_FILE=%LIST_FOLDER%\$LIST"&IF "%FOLDER_MODE%"=="ISOLATED" MOVE /Y "$LIST" "%LIST_FOLDER%">NUL 2>&1
IF "%ARG2%"=="-RUN" IF "%ARG3%"=="-LIST" IF DEFINED ERROR GOTO:COMMAND_IMAGEMGR_END
IF "%ARG2%"=="-RUN" IF DEFINED MENU_SESSION SET "ARG5=-MENU"
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-LIVE" SET "CURR_TARGET=LIVE_APPLY"&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-MENU" SET "CURR_TARGET=LIVE_APPLY"&&SET "MENU_SESSION=1"&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-PATH" IF DEFINED ARG6 IF EXIST "%ARG6%" SET "CURR_TARGET=PATH_APPLY"&&SET "INPUT=%ARG6%"&&SET "OUTPUT=TARGET_PATH"&&CALL:SLASHER&&CALL:IMAGEMGR_EXECUTE_COMMAND
IF "%ARG2%"=="-RUN" IF "%ARG5%"=="-VHDX" IF DEFINED ARG6 IF EXIST "%IMAGE_FOLDER%\%ARG6%" SET "CURR_TARGET=VDISK_APPLY"&&SET "$VDISK_FILE=%IMAGE_FOLDER%\%ARG6%"&&CALL:IMAGEMGR_EXECUTE_COMMAND
:COMMAND_IMAGEMGR_END
IF DEFINED DELETE_DONE DEL /Q /F "%LIST_FOLDER%\%DELETE_DONE%">NUL 2>&1
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
IF "%ARG2%"=="-MOUNT" IF "%ARG3%"=="-VHDX" IF EXIST "%IMAGE_FOLDER%\%ARG4%" SET "$VDISK_FILE=%IMAGE_FOLDER%\%ARG4%"&&IF "%ARG5%"=="-LETTER" IF DEFINED ARG6 SET "VDISK_LTR=%ARG6%"&&CALL:VDISK_ATTACH
IF "%ARG2%"=="-UNMOUNT" IF "%ARG3%"=="-LETTER" IF DEFINED ARG4 SET "$LTR=%ARG4%"&&CALL:DISKMGR_UNMOUNT
EXIT /B
:COMMAND_BOOTCREATOR
IF "%ARG2%"=="-CREATE" IF NOT EXIST "%CACHE_FOLDER%\BOOT.SAV" ECHO.%COLOR4%ERROR:%$$% Boot media %CACHE_FOLDER%\boot.sav doesn't exist&&EXIT /B
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
ECHO.❗* BUILDER INTERACTIVE LIST ITEMS *❗
ECHO.
ECHO.❕GROUP❕🪟 Builder interactive items❕🪛 Choice item❕NORMAL❕
ECHO.Note: Choice Item. CHOICE1-9 are valid. Up to 9 choices seperated by '❗'
ECHO.❕CHOICE1❕Select an option❕✅ Choice option 1 selected❗❎ Choice option 2 selected❗❎ Choice option 3 selected❕VolaTILE❕
ECHO.❕@TEXTHOST❕Choice1-S:◁CHOICE1[S]▷ Choice1-I:◁CHOICE1[I]▷ Choice1-1:◁CHOICE1[1]▷ Choice1-2:◁CHOICE1[2]▷ Choice1-3:◁CHOICE1[3]▷❕SCREEN❕DX❕
ECHO.❕@TEXTHOST❕Group:◁GROUP▷ SubGroup:◁SUBGROUP▷❕SCREEN❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Builder interactive items❕🪛 Prompt item❕NORMAL❕
ECHO.Note: Prompt Item. PROMPT1-9 are valid. Prompt filter NUMBER, LETTER, ALPHA, MENU, MOST, and NONE are usable options. Minimum and maximum character limit are optional.
ECHO.❕PROMPT1❕Enter text❕ALPHA_3-20❕VolaTILE❕
ECHO.❕@TEXTHOST❕Prompt1-S:◁PROMPT1[S]▷ Prompt1-I:◁PROMPT1[I]▷ Prompt1-1:◁PROMPT1[1]▷❕SCREEN❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Builder interactive items❕🪛 Picker item❕NORMAL❕
ECHO.Note: Picker Item. PICKER1-9 are valid. ◁IMAGE_FOLDER▷, ◁LIST_FOLDER▷, ◁PACK_FOLDER▷, ◁CACHE_FOLDER▷, and ◁PROG_SOURCE▷ are usable options.
ECHO.❕PICKER1❕Select a file❕"◁IMAGE_FOLDER▷\*.*"❕VolaTILE❕
ECHO.❕@TEXTHOST❕Picker1-S:◁PICKER1[S]▷ Picker1-I:◁PICKER1[I]▷ Picker1-1:◁PICKER1[1]▷❕SCREEN❕DX❕
ECHO.
ECHO.❗* BUILDER NON-INTERACTIVE LIST ITEMS *❗
ECHO.
ECHO.❕GROUP❕🪟 Builder non-interactive items❕🪛 Condit item❕NORMAL❕
ECHO.Note: Condit Item. CONDIT1-9 are valid. DEFINED, NDEFINED, EXIST, NEXIST, EQ, NE, GE, LE, LT, and GT are usable options. Enter ◁NULL▷ into the 4th column if 'else' is not needed.
ECHO.❕CONDIT1❕◁WINTAR▷❗EXIST❕WinTar Exists❕◁NULL▷❕
ECHO.❕CONDIT2❕◁CHOICE1[I]▷❗EQ❗1❕Choice 1 index equals 1❕Choice 1 index does not equal 1❕
ECHO.❕@TEXTHOST❕Condit1-S:◁CONDIT1[S]▷ Condit1-I:◁CONDIT1[I]▷ Condit1-1:◁CONDIT1[1]▷ Condit1-2:◁CONDIT1[2]▷❕SCREEN❕DX❕
ECHO.❕@TEXTHOST❕Condit2-S:◁CONDIT2[S]▷ Condit2-I:◁CONDIT2[I]▷ Condit2-1:◁CONDIT2[1]▷ Condit2-2:◁CONDIT2[2]▷❕SCREEN❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Builder non-interactive items❕🪛 Array item❕NORMAL❕
ECHO.Note: Array items are similar to a condit item, except it's always 'EQ' and is an array of IF's. Optional 5th colum adds 'else' function.
ECHO.❕ARRAY1❕a❕a❗b❗c❕✅ Array1  option 1 selected❗✅ Array1  option 2 selected❗✅ Array1  option 3 selected❕
ECHO.❕ARRAY2❕1❕1❗2❗3❕✅ Array2  option 1 selected❗✅ Array2  option 2 selected❗✅ Array2  option 3 selected❕✅ Array2  option 1 else selected❗✅ Array2  option 2 else selected❗✅ Array2  option 3 else selected❕
ECHO.❕@TEXTHOST❕Array1-S:◁ARRAY1[S]▷ Array1-I:◁ARRAY1[I]▷ Array1-1:◁ARRAY1[1]▷ Array1-2:◁ARRAY1[2]▷ Array1-3:◁ARRAY1[3]▷❕SCREEN❕DX❕
ECHO.❕@TEXTHOST❕Array2-S:◁ARRAY2[S]▷ Array2-I:◁ARRAY2[I]▷ Array2-1:◁ARRAY2[1]▷ Array2-2:◁ARRAY2[2]▷ Array2-3:◁ARRAY2[3]▷❕SCREEN❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Builder non-interactive items❕🪛 Math item❕NORMAL❕
ECHO.Note: Math item. MATH1-9 are valid. +, -, /, and * are usable options.
ECHO.❕MATH1❕1❕*❕5❕
ECHO.❕@TEXTHOST❕Math1-S:◁MATH1[S]▷ Math1-I:◁MATH1[I]▷ Math1-1:◁MATH1[1]▷❕SCREEN❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Builder non-interactive items❕🪛 String item❕NORMAL❕
ECHO.Note: String item. STRING1-9 are valid. STRING and INTEGER are usable options.
ECHO.❕STRING1❕10❗20❗30❗40❗50❕INTEGER❕3❕
ECHO.❕STRING2❕A❗B❗C❗D❗E❕STRING❕2❕
ECHO.❕@TEXTHOST❕String1-S:◁STRING1[S]▷ String1-I:◁STRING1[I]▷ String1-1:◁STRING1[1]▷ String1-2:◁STRING1[2]▷ String1-3:◁STRING1[3]▷ String1-4:◁STRING1[4]▷ String1-5:◁STRING1[5]▷❕SCREEN❕DX❕
ECHO.❕@TEXTHOST❕String2-S:◁STRING2[S]▷ String2-I:◁STRING2[I]▷ String2-1:◁STRING2[1]▷ String2-2:◁STRING2[2]▷ String2-3:◁STRING2[3]▷ String2-4:◁STRING2[4]▷ String2-5:◁STRING2[5]▷❕SCREEN❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Builder non-interactive items❕🪛 Routine item❕NORMAL❕
ECHO.Note: Routine items are loop based. ROUTINE1-9 are valid. COMMAND and SPLIT are usable options. Optional column# match seperated by '❗'.
ECHO.❕ROUTINE1❕^<^>:❗DIR /B C:\❗1❗Program Files❕COMMAND❕1❕
ECHO.❕ROUTINE2❕:❗A:B:C❗3❗C❕SPLIT❕2❕
ECHO.X❕ROUTINE1❕^<^>:❗DIR /B C:\❕COMMAND❕1❕
ECHO.X❕ROUTINE2❕:❗A:B:C❕SPLIT❕2❕
ECHO.❕@TEXTHOST❕Routine1-S:◁ROUTINE1[S]▷ Routine1-I:◁ROUTINE1[I]▷  Routine1-1:◁ROUTINE1[1]▷ Routine1-2:◁ROUTINE1[2]▷ Routine1-3:◁ROUTINE1[3]▷❕SCREEN❕DX❕
ECHO.❕@TEXTHOST❕Routine2-S:◁ROUTINE2[S]▷ Routine2-I:◁ROUTINE2[I]▷  Routine2-1:◁ROUTINE2[1]▷ Routine2-2:◁ROUTINE2[2]▷ Routine2-3:◁ROUTINE2[3]▷❕SCREEN❕DX❕
ECHO.
ECHO.❗* EXECUTION LIST ITEMS *❗
ECHO.
ECHO.❕GROUP❕🪟 Execution items❕🪛 Command item❕NORMAL❕
ECHO.Note: Command item. 'NORMAL', 'NOMOUNT', 'NORMAL❗RAU', 'NORMAL❗RAS', 'NORMAL❗RATI', 'NOMOUNT❗RAU', 'NOMOUNT❗RAS', or 'NOMOUNT❗RATI' are usable options.
ECHO.❕@TEXTHOST❕testing 1 2 3.❕SCREEN❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Execution items❕🪛 Registry create item❕NORMAL❕
ECHO.Note: Registry item. 'CREATE', 'DELETE', 'CREATE❗RAU', 'CREATE❗RAS', 'CREATE❗RATI', 'DELETE❗RAU', 'DELETE❗RAS', or 'DELETE❗RATI' are usable options. DWORD, QWORD, BINARY, STRING, EXPAND, and MULTI are usable options.
ECHO.
ECHO.Note: Registry item create 'key'.
ECHO.❕@REGISTRY❕◁HIVE_USER▷\Test❕CREATE❕DX❕
ECHO.Note: Registry item create 'value'.
ECHO.❕@REGISTRY❕◁HIVE_USER▷\Test❗◁NULL▷❗TestData❗STRING❕CREATE❕DX❕
ECHO.❕@REGISTRY❕◁HIVE_USER▷\Test❗TestValue❗◁NULL▷❗STRING❕CREATE❕DX❕
ECHO.Note: Registry item delete 'value'.
ECHO.❕@REGISTRY❕◁HIVE_USER▷\Test❗TestValue❕DELETE❕DX❕
ECHO.Note: Registry item delete 'key'.
ECHO.❕@REGISTRY❕◁HIVE_USER▷\Test❕DELETE❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Execution items❕🪛 FileOper item❕NORMAL❕
ECHO.Note: FileOper item. CREATE, DELETE, RENAME, COPY, MOVE, and TAKEOWN are usable options.
ECHO.Note: FileOper item create 'folder'.
ECHO.❕@FILEOPER❕c:\test❕CREATE❕DX❕
ECHO.Note: FileOper item move.
ECHO.❕@TEXTHOST❕test❕FILE❗c:\testmove.txt❕DX❕
ECHO.❕@FILEOPER❕testmove.txt❗c:\test❕MOVE❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Execution items❕🪛 Session item + TextHost item❕NORMAL❕
ECHO.❕@TEXTHOST❕MENU-SCRIPT❕FILE❗◁LIST_FOLDER▷\testlist.list❕DX❕
ECHO.❕@TEXTHOST❕◁U00▷@TEXTHOST◁U00▷testing 1 2 3◁U00▷SCREEN◁U00▷DX◁U00▷❕FILE❗◁LIST_FOLDER▷\testlist.list❕DX❕
ECHO.Note: Using the '-PATH "◁DRVTAR▷"' parameter during an active session will reuse the active session's target.
ECHO.❕SESSION❕-IMAGEMGR -RUN -LIST "testlist.list" -PATH "◁DRVTAR▷"❕◁NULL▷❕DX❕
ECHO.❕@FILEOPER❕◁LIST_FOLDER▷\testlist.list❕DELETE❕DX❕
ECHO.
ECHO.❕GROUP❕🪟 Example❕Items being used in conjunction❕NORMAL❕
ECHO.❕CHOICE1❕Select an option❕🪛 Choice A❗🪛 Choice B❗🪛 Choice C❗❕VolaTILE❕
ECHO.❕ARRAY1❕◁CHOICE1[I]▷❕1❗2❗3❕A❗B❗C❕
ECHO.❕ARRAY2❕◁ARRAY1[S]▷❕A❗B❗C❕DX❗DX❗DX❕
ECHO.❕@TEXTHOST❕Choice ◁ARRAY2[S]▷ picked.❕SCREEN❕◁ARRAY2[1]▷❕
ECHO.❕@TEXTHOST❕Choice ◁ARRAY2[S]▷ picked.❕SCREEN❕◁ARRAY2[2]▷❕
ECHO.❕@TEXTHOST❕Choice ◁ARRAY2[S]▷ picked.❕SCREEN❕◁ARRAY2[3]▷❕
EXIT /B
:MENU_EXAMPLE_BASE
ECHO.MENU-SCRIPT
ECHO.❗* This is an example of a custom menu for recovery *❗
ECHO.
ECHO.❕GROUP❕Recovery Operation Example❕Backup picked vhdx to backup.wim❕NORMAL❕
ECHO.❕PICKER1❕Select a vhdx to backup❕"◁PROG_SOURCE▷\*.vhdx"❕VolaTILE❕
ECHO.❕CONDIT1❕◁PROG_SOURCE▷\◁PICKER1[S]▷❗EXIST❕DX❕DX❕
ECHO.❕@TEXTHOST❕◁PROG_SOURCE▷\◁PICKER1[S]▷ does not exist.❕SCREEN❕◁CONDIT1[2]▷❕
ECHO.❕@TEXTHOST❕Deleting backup.wim❕SCREEN❕◁CONDIT1[1]▷❕
ECHO.❕@FILEOPER❕◁IMAGE_FOLDER▷\backup.wim❕DELETE❕◁CONDIT1[1]▷❕
ECHO.❕SESSION❕-imageproc -vhdx "◁PICKER1[S]▷" -index 1 -wim "backup.wim" -size 25❕◁NULL▷❕◁CONDIT1[1]▷❕
ECHO.❕@COMMAND❕PAUSE❕NORMAL❕DX❕
ECHO.
ECHO.❕GROUP❕Recovery Operation Example❕Restore picked wim to current.vhdx❕NORMAL❕
ECHO.❕PICKER1❕Select a wim to restore❕"◁IMAGE_FOLDER▷\*.wim"❕VolaTILE❕
ECHO.❕CONDIT1❕◁PROG_SOURCE▷\◁PICKER1[S]▷❗EXIST❕DX❕DX❕
ECHO.❕@TEXTHOST❕◁IMAGE_FOLDER▷\◁PICKER1[S]▷ does not exist.❕SCREEN❕◁CONDIT1[2]▷❕
ECHO.❕@TEXTHOST❕Deleting current.vhdx❕SCREEN❕◁CONDIT1[1]▷❕
ECHO.❕@FILEOPER❕◁PROG_SOURCE▷\current.vhdx❕DELETE❕◁CONDIT1[1]▷❕
ECHO.❕SESSION❕-imageproc -wim "◁PICKER1[S]▷" -index 1 -vhdx "current.vhdx" -size 25❕◁NULL▷❕◁CONDIT1[1]▷❕
ECHO.❕@COMMAND❕PAUSE❕NORMAL❕DX❕
EXIT /B
:MENU_EXAMPLE_EXEC
ECHO.MENU-SCRIPT
ECHO.❗* This is an example of a reboot to restore scenerio as an execution list *❗
ECHO.
ECHO.❕CONDIT1❕◁IMAGE_FOLDER▷\backup.wim❗EXIST❕DX❕DX❕
ECHO.❕@TEXTHOST❕ECHO.◁IMAGE_FOLDER▷\backup.wim does not exist.❕SCREEN❕◁CONDIT1[2]▷❕
ECHO.❕@COMMAND❕ECHO.Deleting current.vhdx.❕NORMAL❕◁CONDIT1[1]▷❕
ECHO.❕@COMMAND❕DEL /Q /F "◁PROG_SOURCE▷\current.vhdx"❕NORMAL❕◁CONDIT1[1]▷❕
ECHO.❕SESSION❕-imageproc -wim "backup.wim" -index 1 -vhdx "current.vhdx" -size 25❕◁NULL▷❕◁CONDIT1[1]▷❕
ECHO.❕@COMMAND❕PAUSE❕NORMAL❕DX❕
EXIT /B
:GET_INIT
SET "CMD=CMD.EXE"&&SET "DISM=DISM.EXE"&&SET "REG=REG.EXE"&&SET "BCDEDIT=BCDEDIT.EXE"
SET "ERROR="&&SET "MENU_EXIT="&&SET "SETS_LOAD="&&SET "GUI_ACTIVE="&&SET "ALLOW_ENVO="
SET "VER_GET=%~DP0windick.cmd"&&CALL:GET_PROGVER&&CD /D "%~DP0"&&CHCP 65001>NUL
IF EXIST "%TEMP%\$CON" SET "GUI_ACTIVE=1"&DEL /F /Q "%TEMP%\$CON">NUL 2>&1
SET "ORIG_CD=%CD%"&&FOR /F "TOKENS=*" %%a in ("%CD%") DO (SET "CAPS_SET=PROG_FOLDER"&&SET "CAPS_VAR=%%a"&&CALL:CAPS_SET)
FOR /F "TOKENS=1-2 DELIMS=:" %%a IN ("%PROG_FOLDER%") DO (SET "CHAR_STR=%%b"&&SET "CHAR_CHK= "&&CALL:CHAR_CHK&&IF "%%b"=="\" SET "PROG_FOLDER=%%a:")
IF DEFINED CHAR_FLG SET "ERROR=Remove the space from the path or folder name, then launch again."
IF NOT EXIST "%PROG_FOLDER%" SET "ERROR=Invalid path or folder name. Relocate, then launch again."
IF "%PROG_FOLDER%"=="X:\$" IF NOT "%SYSTEMDRIVE%"=="X:" SET "ERROR=Relocate to path other than X:\$."
IF "%PROG_FOLDER%"=="%SYSTEMDRIVE%\WINDOWS\SYSTEM32" SET "ERROR=Invalid path or folder name. Relocate, then launch again."
SET "PATH_TEMP="&&FOR /F "TOKENS=1-9 DELIMS=\" %%a IN ("%PROG_FOLDER%") DO (IF "%%a\%%b\%%c"=="%SystemDrive%\WINDOWS\TEMP" SET "PATH_TEMP=1"
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
IF NOT "%PROG_FOLDER%"=="X:\$" SET "PROG_MODE=PORTABLE"&&CALL:SETS_HANDLER&&GOTO:MAIN_MENU
IF "%PROG_FOLDER%"=="X:\$" IF "%SystemDrive%"=="X:" SET "PROG_MODE=RAMDISK"
IF EXIST "%PROG_FOLDER%\RECOVERY_LOCK" CALL:RECOVERY_LOCK
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
SET "FREE="&&FOR /F "TOKENS=1-5 DELIMS= " %%a IN ('DIR "%PROG_SOURCE%\"') DO (SET "FREE=%%c")
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
FOR /F "TOKENS=2* SKIP=1 DELIMS=:\. " %%a in ('%REG% QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUser 2^>NUL') do (IF "%%a"=="REG_SZ" SET "USER_NAM=%%b")
FOR /F "TOKENS=2* SKIP=1 DELIMS=:\. " %%a in ('%REG% QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUserSID 2^>NUL') do (IF "%%a"=="REG_SZ" SET "USER_SID=%%b")
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
SET "%VER_SET%="&&FOR /F "TOKENS=1-9 DELIMS= " %%A IN ("%VER_CHK%") DO (SET "%VER_SET%=%%G")
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
IF EXIST "%LIST_FOLDER%\$LIST" DEL /Q /F "%LIST_FOLDER%\$LIST">NUL 2>&1
IF NOT EXIST "$*" EXIT /B
IF EXIST "%IMAGE_FOLDER%\$TEMP.vhdx" CALL:VTEMP_DELETE>NUL 2>&1
IF EXIST "%IMAGE_FOLDER%\$TEMP.wim" DEL /Q /F "%IMAGE_FOLDER%\$TEMP.wim">NUL 2>&1
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
:DISCLAIMER
SET "$HEADERS=                              %COLOR2%DISCLAIMER%$$%%U01% %U01%    It's recommended to backup your data before making any changes%U01%     to the live operating system or performing disk partitioning.%U01%      Running this tool on a host-OS language other than english%U01%        can cause serious malfunctions and is not recommended.%U01% The user assumes liability for loss relating to the use of this tool.%U01% %U01%                          Do You Agree? (%##%Y%$$%/%##%N%$$%)"
SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF "%CONFIRM%"=="Y" SET "DISCLAIMER=ACCEPTED"
IF NOT "%DISCLAIMER%"=="ACCEPTED" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.&&ECHO.     The ( %##%0%$$% ) %##%Current Environment%$$% option ^& disk management area&&ECHO.         are the 'caution zones' and can be avoided if unsure.&&ECHO.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED
EXIT /B
:RECOVERY_LOCK
SET "LOCKOUT="&&SET "$HEADERS= %U01% %U01% %U01% %U01%                       Enter recovery password%U01% %U01% %U01% "&&SET "$NO_ERRORS=1"&&SET "$SELECT=RECOVERY_PROMPT"&&SET "$CHECK=MOST"&&CALL:PROMPT_BOX
SET /P RECOVERY_LOCK=<"%PROG_FOLDER%\RECOVERY_LOCK"
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
IF NOT DEFINED ERROR IF "%$CASE%"=="ANY" SET "%$SELECT%=%SELECT_VAR%"
IF NOT DEFINED ERROR FOR %%■ in (UPPER LOWER) DO (IF "%%■"=="%$CASE%" SET "CAPS_SET=%$SELECT%"&&SET "CAPS_VAR=%SELECT_VAR%"&&CALL:CAPS_SET)
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
IF "%$CASE%"=="LOWER" FOR %%G in (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO (CALL SET "CAPS_VAR=%%CAPS_VAR:%%G=%%G%%")
IF "%$CASE%"=="UPPER" FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "CAPS_VAR=%%CAPS_VAR:%%G=%%G%%")
IF "%CAPS_VAR%"=="=" SET "CAPS_VAR="
IF "%CAPS_VAR%"=="a=a" SET "CAPS_VAR="
IF "%CAPS_VAR%"=="A=A" SET "CAPS_VAR="
CALL SET "%CAPS_SET%=%CAPS_VAR%"
SET "CAPS_SET="&&SET "CAPS_VAR="&&SET "$CASE="
EXIT /B
:CHECK
IF "%DEBUG%"=="ENABLED" ECHO.$CHECK[%$CHECK%]&&CALL:DEBUG
SET "$CHECK_LAST=%$CHECK%"&&FOR /F "TOKENS=1-3 DELIMS=_-" %%a IN ("%$CHECK%") DO (SET "$CHECK=%%a"&&SET "TEXTMIN=%%b"&&SET "TEXTMAX=%%c")
IF NOT DEFINED CHECK_VAR SET "ERROR=CHECK"
IF "%$CHECK%"=="NONE" GOTO:TEXTMINMAXCHK
SET "NUMBERS=0 1 2 3 4 5 6 7 8 9"&&SET "LETTERS=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z"
IF "%$CHECK%"=="NUMBER" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% ^""
IF "%$CHECK%"=="LETTER" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%LETTERS% ^""
IF "%$CHECK%"=="ALPHA" SET "NO_SPACE=1"&&SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% . - _ ^""
IF "%$CHECK%"=="PATH" SET "NO_ASTRK=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% . - _ ^\ ^: ^""
IF "%$CHECK%"=="MENU" SET "NO_SPACE=1"&&SET "CHECK_FLT=%NUMBERS% %LETTERS% @ # $ . - _ + = ~ ^* ^""
IF "%$CHECK%"=="MOST" SET "CHECK_FLT=%NUMBERS% %LETTERS% @ # $ ^\ ^/ ^: ^( ^) ^[ ^] ^{ ^} ^. ^- ^_ ^+ ^= ^~ ^* ^%% ^""
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
IF "%$CHECK%"=="NUMBER" SET /A "TEXTMIN=%TEXTMIN%"&&SET /A "CHECK_VAR=%CHECK_VAR%"
IF "%$CHECK%"=="NUMBER" IF %CHECK_VAR% LSS %TEXTMIN% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %CHECK_VAR% LSS %TEXTMIN%)
IF NOT "%$CHECK%"=="NUMBER" IF %$XNT% LSS %TEXTMIN% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %$XNT% LSS %TEXTMIN%)
EXIT /B
:TEXTMAX
IF "%$CHECK%"=="NUMBER" SET /A "TEXTMAX=%TEXTMAX%"&&SET /A "CHECK_VAR=%CHECK_VAR%"
IF "%$CHECK%"=="NUMBER" IF %CHECK_VAR% GTR %TEXTMAX% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %CHECK_VAR% GTR %TEXTMAX%)
IF NOT "%$CHECK%"=="NUMBER" IF %$XNT% GTR %TEXTMAX% (SET "ERROR=CHECK"&&IF "%DEBUG%"=="ENABLED" ECHO.$CHECK %$CHECK%: %$XNT% GTR %TEXTMAX%)
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
SET SETS_LIST=GUI_LAUNCH GUI_RESUME GUI_SCALE GUI_CONFONT GUI_CONFONTSIZE GUI_CONTYPE GUI_FONTSIZE GUI_LVFONTSIZE GUI_TXT_FORE GUI_TXT_BACK GUI_BTN_COLOR GUI_HLT_COLOR GUI_BG_COLOR GUI_PAG_COLOR PAD_BOX PAD_TYPE PAD_SIZE PAD_SEQ TXT_COLOR ACC_COLOR BTN_COLOR COMPRESS SAFE_EXCLUDE HOST_HIDE PE_WALLPAPER BOOT_TIMEOUT VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5 ADDFILE_0 ADDFILE_1 ADDFILE_2 ADDFILE_3 ADDFILE_4 ADDFILE_5 ADDFILE_6 ADDFILE_7 ADDFILE_8 ADDFILE_9 HOTKEY_1 SHORT_1 HOTKEY_2 SHORT_2 HOTKEY_3 SHORT_3 RECOVERY_LOGO MENU_MODE MENU_LIST DISCLAIMER ALLOW_ENV APPX_SKIP COMP_SKIP SVC_SKIP SXS_SKIP DEBUG
EXIT /B
:SETS_LOAD
IF EXIST "windick.ini" FOR /F "TOKENS=1-1* DELIMS==" %%a in (windick.ini) DO (IF NOT "%%a"=="   " SET "%%a=%%b")
EXIT /B
:SETS_CLEAR
CALL:SETS_LIST
FOR %%a in (%SETS_LIST%) DO (SET %%a=)
SET "SETS_LIST="&&EXIT /B
:SETS_HANDLER
IF NOT "%PROG_MODE%"=="RAMDISK" SET "PROG_SOURCE=%PROG_FOLDER%"
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%PROG_SOURCE%" SET "PROG_SOURCE=%PROG_FOLDER%"
CD /D "%PROG_FOLDER%"&&IF EXIST "windick.ini" IF NOT DEFINED SETS_LOAD SET "SETS_LOAD=1"&&CALL:SETS_LOAD
CALL:SETS_LIST&&ECHO.Windows Deployment Image Customization Kit v %VER_CUR% Settings>"windick.ini"
FOR %%a in (%SETS_LIST%) DO (CALL ECHO.%%a=%%%%a%%>>"windick.ini")
SET "SETS_LIST="&&IF "%PROG_MODE%"=="RAMDISK" IF "%PROG_SOURCE%"=="X:\$" SET "HOST_GET=1"
IF "%PROG_MODE%"=="RAMDISK" IF NOT "%DISK_TARGET%"=="%HOST_TARGET%" SET "HOST_GET=1"
IF DEFINED HOST_GET SET "HOST_GET="&&CALL:HOST_AUTO
IF "%PROG_MODE%"=="RAMDISK" IF EXIST "Z:\%HOST_FOLDERX%" COPY /Y "windick.ini" "Z:\%HOST_FOLDERX%">NUL
:SETS_MAIN
IF NOT DEFINED PAD_TYPE SET "PAD_TYPE=1"
IF NOT DEFINED ACC_COLOR SET "ACC_COLOR=6"
IF NOT DEFINED BTN_COLOR SET "BTN_COLOR=7"
IF NOT DEFINED TXT_COLOR SET "TXT_COLOR=0"
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25"
IF NOT DEFINED PAD_SIZE SET "PAD_SIZE=LARGE"
IF NOT DEFINED PAD_BOX SET "PAD_BOX=ENABLED"
IF NOT DEFINED PAD_SEQ SET "PAD_SEQ=0000000000"
IF NOT DEFINED HOST_FOLDER SET "HOST_FOLDER=$"
IF NOT DEFINED HOST_HIDE SET "HOST_HIDE=DISABLED"
IF NOT DEFINED ALLOW_ENV SET "ALLOW_ENV=DISABLED"
IF NOT DEFINED SAFE_EXCLUDE SET "SAFE_EXCLUDE=ENABLED"
IF NOT DEFINED ADDFILE_0 SET "ADDFILE_0=list\tweaks.base"
IF NOT DEFINED HOTKEY_1 SET "HOTKEY_1=CMD"&&SET "SHORT_1=CMD.EXE"
IF NOT DEFINED HOTKEY_2 SET "HOTKEY_2=NOTE"&&SET "SHORT_2=NOTEPAD.EXE"
IF NOT DEFINED HOTKEY_3 SET "HOTKEY_3=REG"&&SET "SHORT_3=REGEDIT.EXE"
IF NOT DEFINED APPX_SKIP SET "APPX_SKIP=Microsoft.DesktopAppInstaller Microsoft.VCLibs.140.00"
IF NOT "%PROG_MODE%"=="RAMDISK" SET "PROG_SOURCE=%PROG_FOLDER%"
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%PROG_SOURCE%" SET "PROG_SOURCE=%PROG_FOLDER%"
SET "FOLDER_MODE=UNIFIED"&&IF NOT "%COMPRESS%"=="FAST" IF NOT "%COMPRESS%"=="MAX" SET "COMPRESS=FAST"
IF EXIST "%PROG_SOURCE%\CACHE" IF EXIST "%PROG_SOURCE%\IMAGE" IF EXIST "%PROG_SOURCE%\PACK" IF EXIST "%PROG_SOURCE%\LIST" SET "FOLDER_MODE=ISOLATED"
IF "%FOLDER_MODE%"=="ISOLATED" FOR %%a in (CACHE IMAGE PACK LIST) DO (SET "%%a_FOLDER=%PROG_SOURCE%\%%a")
IF "%FOLDER_MODE%"=="UNIFIED" FOR %%a in (CACHE IMAGE PACK LIST) DO (SET "%%a_FOLDER=%PROG_SOURCE%")
FOR %%a in (MOUNT TARGET_PATH PATH_APPLY LIVE_APPLY VDISK_APPLY ERROR $NO_MOUNT $HALT $ONLY1 $ONLY2 $ONLY3 $VERBOSE $VHDX VDISK VDISK_LTR MENU_SESSION CUSTOM_SESSION MENU_SKIP DELETE_DONE FEAT_QRY DRVR_QRY SC_PREPARE RO_PREPARE) DO (SET "%%a=")
CHCP 65001>NUL&IF NOT DEFINED U00 SET "U00=❕"&&SET "U01=❗"&&SET "U02=🗂 "&&SET "U03=🛠️"&&SET "U04=💾"&&SET "U05=🗳 "&&SET "U06=🪟"&&SET "U07=🔄"&&SET "U08=🪛"&&SET "U09=🥾"&&SET "U10=✒ "&&SET "U11=🗃 "&&SET "U12=🎨"&&SET "U13=🧾"&&SET "U14=⏳"&&SET "U15=✅"&&SET "U16=❎"&&SET "U17=🚫"&&SET "U18=🗜 "&&SET "U19=🛡 "&&SET "U0L=◁"&&SET "U0R=▷"&&SET "COLOR0=[97m"&&SET "COLOR1=[31m"&&SET "COLOR2=[91m"&&SET "COLOR3=[33m"&&SET "COLOR4=[93m"&&SET "COLOR5=[92m"&&SET "COLOR6=[96m"&&SET "COLOR7=[94m"&&SET "COLOR8=[34m"&&SET "COLOR9=[95m"
CALL SET "@@=%%COLOR%ACC_COLOR%%%"&&CALL SET "##=%%COLOR%BTN_COLOR%%%"&&CALL SET "$$=%%COLOR%TXT_COLOR%%%"
SET "COLORA=%@@%"&&SET "COLORB=%##%"&&SET "COLORT=%$$%"
FOR %%a in (COMMAND GUI) DO (IF "%PROG_MODE%"=="%%a" EXIT /B)
FOR %%a in (MENU_LIST) DO (SET "OBJ_FLD=%LIST_FOLDER%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (PE_WALLPAPER) DO (SET "OBJ_FLD=%CACHE_FOLDER%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (VHDX_SLOTX WIM_SOURCE VHDX_SOURCE) DO (SET "OBJ_FLD=%IMAGE_FOLDER%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (SET "ADDFILE_NUM=%%a"&&CALL SET "ADDFILE_CHK=%%ADDFILE_%%a%%"&&CALL:ADDFILE_CHK)
IF "%PROG_MODE%"=="RAMDISK" FOR %%a in (VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5) DO (SET "OBJ_FLD=%PROG_SOURCE%"&&CALL SET "OBJ_CHK=%%a"&&CALL:OBJ_CLEAR)
FOR %%a in (MENU_LIST PE_WALLPAPER PATH_SOURCE PATH_TARGET WIM_SOURCE VHDX_SOURCE WIM_TARGET VHDX_TARGET VHDX_SLOTX VHDX_SLOT0 VHDX_SLOT1 VHDX_SLOT2 VHDX_SLOT3 VHDX_SLOT4 VHDX_SLOT5) DO (IF NOT DEFINED %%a SET "%%a=SELECT")
IF NOT EXIST "%PATH_SOURCE%\" SET "PATH_SOURCE=SELECT"
IF NOT EXIST "%PATH_TARGET%\" SET "PATH_TARGET=SELECT"
FOR %%a in (ADDFILE_CHK ADDFILE_NUM OBJ_FLD OBJ_CHK OBJ_CHKX) DO (SET "%%a=")
EXIT /B
:ADDFILE_CHK
IF NOT DEFINED ADDFILE_%ADDFILE_NUM% SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%ADDFILE_CHK%"=="SELECT" EXIT /B
FOR /F "TOKENS=1-9 DELIMS=\" %%a in ("%ADDFILE_CHK%") DO (
IF "%%a"=="pack" IF NOT EXIST "%PACK_FOLDER%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="list" IF NOT EXIST "%LIST_FOLDER%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="image" IF NOT EXIST "%IMAGE_FOLDER%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="cache" IF NOT EXIST "%CACHE_FOLDER%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT"
IF "%%a"=="main" IF NOT EXIST "%PROG_SOURCE%\%%b" SET "ADDFILE_%ADDFILE_NUM%=SELECT")
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
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%PROG_SOURCE%\%%a" MOVE /Y "%PROG_SOURCE%\%%a\*.*" "%PROG_SOURCE%">NUL 2>&1)
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%PROG_SOURCE%\%%a" XCOPY /S /C /Y "%PROG_SOURCE%\%%a" "%PROG_SOURCE%">NUL 2>&1)
FOR %%a in (CACHE IMAGE PACK LIST) DO (IF EXIST "%PROG_SOURCE%\%%a" RD /Q /S "\\?\%PROG_SOURCE%\%%a">NUL 2>&1)
EXIT /B
:FOLDER_ISOLATED
FOR %%a in (cache image pack list) DO (IF NOT EXIST "%PROG_SOURCE%\%%a" MD "%PROG_SOURCE%\%%a">NUL 2>&1)
FOR %%a in (XML JPG PNG REG EFI SDI SAV) DO (IF EXIST "%PROG_SOURCE%\*.%%a" MOVE /Y "%PROG_SOURCE%\*.%%a" "%PROG_SOURCE%\CACHE">NUL 2>&1)
FOR %%a in (LIST BASE) DO (IF EXIST "%PROG_SOURCE%\*.%%a" MOVE /Y "%PROG_SOURCE%\*.%%a" "%PROG_SOURCE%\LIST">NUL 2>&1)
FOR %%a in (ISO VHDX WIM) DO (IF EXIST "%PROG_SOURCE%\*.%%a" MOVE /Y "%PROG_SOURCE%\*.%%a" "%PROG_SOURCE%\IMAGE">NUL 2>&1)
FOR %%a in (PKX CAB MSU APPX APPXBUNDLE MSIXBUNDLE) DO (IF EXIST "%PROG_SOURCE%\*.%%a" MOVE /Y "%PROG_SOURCE%\*.%%a" "%PROG_SOURCE%\PACK">NUL 2>&1)
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:FILE_VIEWER
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&CALL:BOX_HEADERS&&SET "$FOLDFILT=%$FOLDFILT:"=%"
FOR /F "TOKENS=1-1* DELIMS=^*" %%a IN ("%$FOLDFILT%") DO (SET "$FOLD=%%a"&&SET "$FILT=*%%b")
CALL SET "$FOLD=%$FOLD%"&&CALL SET "$FILT=%$FILT%"
SET "INPUT=%$FOLD%"&&SET "OUTPUT=$FOLD"&&CALL:SLASHER
ECHO.&&ECHO.  %@@%AVAILABLE %$FILT%s:%$$%&&ECHO.&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
IF NOT DEFINED $NO_ERRORS CALL:PAD_PREV
IF DEFINED $CHOICEMINO SET "$CHOICEMIN=0"
IF NOT DEFINED $CHOICEMINO SET "$CHOICEMIN=1"
IF DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$CHOICEMAXO%"
IF NOT DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$XNT%"
IF DEFINED $CHECKO SET "$CHECK=%$CHECKO%"
IF NOT DEFINED $CHECKO SET "$CHECK=NUMBER_%$CHOICEMIN%-%$CHOICEMAX%"
CALL:MENU_SELECT
IF NOT DEFINED $CHOICE IF NOT DEFINED ERROR SET "$CHOICE=%SELECT%"
IF DEFINED $NO_ERRORS IF NOT DEFINED $CHOICE IF DEFINED $ITEM1 GOTO:FILE_VIEWER
FOR %%a in ($FOLDFILT $CHOICEMINO $CHOICEMAXO $CHECKO $CENTERED $HEADERS $NO_ERRORS $VERBOSE) DO (SET "%%a=")
EXIT /B
:FILE_LIST
FOR %%a in ($FOLD $FILT) DO (IF NOT DEFINED %%a GOTO:FILE_LIST_SKIP)
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEM%%a SET "$ITEM%%a=")
IF NOT DEFINED $DISP SET "$DISP=NUM"
IF "%$DISP%"=="NUM" SET "$PICKER=1"
::CALL SET "$ITEMSTOP=%$ITEMSTOP%"&&CALL SET "$ITEMSBTM=%$ITEMSBTM%"
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
IF EXIST "%$FOLD%" FOR /F "TOKENS=1-9 DELIMS= " %%a IN ("%$FILT%") DO (IF NOT "%%a"=="" SET "$FILTARG=%%a"&&CALL:FILTARG&&IF NOT "%%b"=="" SET "$FILTARG=%%b"&&CALL:FILTARG&&IF NOT "%%c"=="" SET "$FILTARG=%%c"&&CALL:FILTARG&&IF NOT "%%d"=="" SET "$FILTARG=%%d"&&CALL:FILTARG&&IF NOT "%%e"=="" SET "$FILTARG=%%e"&&CALL:FILTARG&&IF NOT "%%f"=="" SET "$FILTARG=%%f"&&CALL:FILTARG&&IF NOT "%%g"=="" SET "$FILTARG=%%g"&&CALL:FILTARG&&IF NOT "%%h"=="" SET "$FILTARG=%%h"&&CALL:FILTARG&&IF NOT "%%i"=="" SET "$FILTARG=%%i"&&CALL:FILTARG)
IF NOT DEFINED $ITEM1 ECHO.&&ECHO.   Empty.&&ECHO.
IF DEFINED $ITEMSBTM CALL:ITEMSBTM
:FILE_LIST_SKIP
FOR %%a in ($DISP $ITEMSTOP $ITEMSBTM $FILTARG) DO (SET "%%a=")
EXIT /B
:FILTARG
IF NOT EXIST "%$FOLD%\%$FILTARG%" EXIT /B
FOR /F "TOKENS=*" %%■ in ('DIR /A: /B /O:GN "%$FOLD%\%$FILTARG%"') DO (CALL SET /A "$XNT+=1"&&CALL SET "$VCLM$=%%■"&&CALL:FILE_LISTX)
EXIT /B
:FILE_LISTX
SET "$ITEM%$XNT%=%$VCLM$%"
IF EXIST "%$FOLD%\%$VCLM$%\*" (SET "$LCLR1=%@@%"&&SET "$LCLR2=%$$%") ELSE (SET "$LCLR1="&&SET "$LCLR2=")
IF "%$DISP%"=="NUM" FOR /F "TOKENS=*" %%● in ("%$VCLM$%") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %$LCLR1%%%●%$LCLR2%)
IF "%$DISP%"=="BAS" FOR /F "TOKENS=*" %%● in ("%$VCLM$%") DO (ECHO.   %$LCLR1%%%●%$LCLR2%)
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:LIST_VIEWER
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
SET "INPUT=%$LIST_FILE%"&&CALL:GET_FILEEXT
IF DEFINED BASE_EXEC (SET "$LIST_MODE=Execute") else (SET "$LIST_MODE=Builder")
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&SET "$CENTERED=1"&&SET "$HEADERS=%U13% List %$LIST_MODE%%U01% %U01%  %$FILE_X%%$EXT_X%%U01% %U01%"&&CALL:BOX_HEADERS&SET "$ONLY1=GROUP"&&CALL:LIST_FILE
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&IF NOT DEFINED ERROR CALL:PAD_PREV
IF DEFINED ERROR SET "TIMER=1"&&CALL:TIMER&&GOTO:LIST_VIEWER_END
SET "$VERBOSE=1"&&SET "$CHECK=NUMBER_1-%$XNT%"&&CALL:MENU_SELECT
IF NOT DEFINED ERROR FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 IN ("%$CHOICE%") DO (SET "$ONLY2=%%2")
IF DEFINED ERROR SET "$ONLY1="&&GOTO:LIST_VIEWER_END
:SUBGROUP_BOX
SET "INPUT=%$LIST_FILE%"&&CALL:GET_FILEEXT
IF DEFINED BASE_EXEC (SET "$LIST_MODE=Execute") else (SET "$LIST_MODE=Builder")
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&SET "$CENTERED=1"&&SET "$HEADERS=%U13% %$FILE_X%%$EXT_X%%U01% %U01%%$ONLY2%%U01% %U01%"&&CALL:BOX_HEADERS&&SET "$ONLY1=GROUP"&&CALL:LIST_FILE
ECHO.&&ECHO.                        Multiples OK ( %##%1 2 3%$$% )
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV
SET "$VERBOSE=1"&&SET "LIST_START="&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF NOT DEFINED ERROR FOR %%a in (%SELECT%) DO (CALL SET "FULL_TARGET=%%$ITEM%%a%%"&&CALL:UNIFIED_PARSE_BUILDER)
IF NOT DEFINED LIST_START IF DEFINED SELECT SET "ERROR=1"&&FOR /F "TOKENS=*" %%■ in ("%SELECT_LAST% ") DO (ECHO.%COLOR4%ERROR:%$$% input [ %COLOR4%%%■%$$%] is invalid)
IF DEFINED ERROR SET "ERROR="&&SET "$ONLY2="&&GOTO:LIST_VIEWER
:LIST_VIEWER_APPEND
IF DEFINED BASE_EXEC SET "$LIST_FILE=%LIST_FOLDER%\$LIST"&&GOTO:LIST_VIEWER_END
SET "$CENTERED="&&SET "$HEADERS=                            %U04% Append Items%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new list"&&SET "$FOLDFILT=%LIST_FOLDER%\*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MAKE
IF "%SELECT%"=="0" IF NOT DEFINED ERROR MOVE /Y "$LIST" "%$PICK%">NUL&GOTO:LIST_VIEWER_END
IF DEFINED ERROR SET "ERROR="&&SET "$ONLY3="&&GOTO:SUBGROUP_BOX
SET "$LIST_FILE=%$PICK%"&&CALL:LIST_COMBINE&&CALL:APPEND_SCREEN
:LIST_VIEWER_END
FOR %%▓ in (BASE_EXEC GROUP_TYPE $ONLY1 $ONLY2 $ONLY3 $CENTERED $HEADERS $NO_ERRORS $VERBOSE) DO (SET "%%▓=")
EXIT /B
:UNIFIED_PARSE_BUILDER
IF NOT DEFINED FULL_TARGET EXIT /B
SET "FULL_TARGETQ=%FULL_TARGET:"=%"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 in ("%FULL_TARGETQ%") DO (
SET "GROUP_TARGET=%%2"&&SET "SUB_TARGET=%%3"&&SET "GROUP_TYPE=%%4"&&SET "GROUP_MSG=%%5"&&SET "GROUP_CHOICES=%%6"&&SET "GROUP_CHOICE=%%7"
IF NOT "%%1"=="" SET "COLUMN_XNT=1"&&IF NOT "%%2"=="" SET "COLUMN_XNT=2"&&IF NOT "%%3"=="" SET "COLUMN_XNT=3"&&IF NOT "%%4"=="" SET "COLUMN_XNT=4"&&IF NOT "%%5"=="" SET "COLUMN_XNT=5"&&IF NOT "%%6"=="" SET "COLUMN_XNT=6"&&IF NOT "%%7"=="" SET "COLUMN_XNT=7")
FOR /F "TOKENS=*" %%░ IN ("%GROUP_TYPE%") DO (IF NOT "%%░"=="NORMAL" IF NOT "%%░"=="DRAWER" IF NOT "%%░"=="SCOPED" SET "GROUP_TYPE=NORMAL")
IF "%GROUP_TYPE%"=="NORMAL" CALL:NORMAL_LIST
IF "%GROUP_TYPE%"=="DRAWER" CALL:DRAWER_BOX
IF "%GROUP_TYPE%"=="SCOPED" CALL:DRAWER_BOX
EXIT /B
:LIST_FILE
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEM%%a SET "$ITEM%%a=")
IF NOT EXIST "%$LIST_FILE%" GOTO:LIST_FILE_SKIP
SET "$HEAD_CHECK=%$LIST_FILE%"&&CALL:GET_HEADER
IF DEFINED ERROR GOTO:LIST_FILE_SKIP
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
COPY /Y "%$LIST_FILE%" "$TEMP">NUL 2>&1
SET "$VCLM2_LAST="&&IF EXIST "$TEMP" FOR /F "TOKENS=1-9 SKIP=1 DELIMS=%U00%" %%1 in ($TEMP) DO (SET "$LIST_FILEX=1"
IF DEFINED $ONLY1 IF NOT "%%1"=="%$ONLY1%" SET "$LIST_FILEX="
IF DEFINED $ONLY2 IF NOT "%%2"=="%$ONLY2%" SET "$LIST_FILEX="
IF DEFINED $LIST_FILEX CALL SET "$VCLM1=%%1"&&CALL SET "$VCLM2=%%2"&&CALL SET "$VCLM3=%%3"&&CALL SET "$VCLM4=%%4"&&CALL SET "$VCLM5=%%5"&&CALL SET "$VCLM6=%%6"&&CALL SET "$VCLM7=%%7"&&CALL:LIST_FILEX)
IF NOT DEFINED $ITEM1 ECHO.&&ECHO.   Empty.&&ECHO.
IF DEFINED $ITEMSBTM CALL:ITEMSBTM
:LIST_FILE_SKIP
FOR %%a in ($VCLM1 $VCLM2 $VCLM3 $VCLM4 $VCLM5 $VCLM6 $VCLM7 $VCLM2_LAST $ITEMSTOP $ITEMSBTM) DO (SET "%%a=")
EXIT /B
:LIST_FILEX
IF DEFINED $VCLM2 SET "$VCLM2=!$VCLM2:"=!"
IF DEFINED $VCLM3 SET "$VCLM3=!$VCLM3:"=!"
IF NOT DEFINED $ONLY2 IF DEFINED $VCLM2 FOR /F "TOKENS=*" %%░ IN ("!$VCLM2!") DO (IF "%%░"=="!$VCLM2_LAST!" EXIT /B
SET "$VCLM2_LAST=%%░")
SET /A "$XNT+=1"
IF NOT DEFINED $ONLY2 IF DEFINED $VCLM2 FOR /F "TOKENS=*" %%░ IN ("!$VCLM2!") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %%░%$$%)
IF DEFINED $ONLY2 FOR /F "TOKENS=*" %%░ IN ("!$VCLM3!") DO (ECHO. %$$%^( %##%%$XNT%%$$% ^) %%░%$$%)
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
IF "%%a"=="GROUP" IF "%%b"=="!GROUP_TARGET!" IF "%%c"=="!SUB_TARGET!" SET "NORMAL_LISTX=1"&&SET "WRITEZ=1"
IF "%%a"=="GROUP" IF NOT "%%b"=="!GROUP_TARGET!" SET "NORMAL_LISTX="
IF "%%a"=="GROUP" IF NOT "%%c"=="!SUB_TARGET!" SET "NORMAL_LISTX="
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
:NORMAL_LISTX
SET "$VCLM1=!$VCLM1:"=!"
SET "@QUIET="&&FOR /F "TOKENS=* DELIMS=@" %%● IN ("!$VCLM1!") DO (IF NOT "%%●"=="!$VCLM1!" SET "@QUIET=1")
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
IF DEFINED WRITEZ SET "WRITEZ="&&ECHO.>>"$LIST"
IF NOT DEFINED @QUIET FOR %%@ in (PROMPT CHOICE PICKER) DO (FOR %%▓ in (0 1 2 3 4 5 6 7 8 9) DO (IF "!$VCLM1!"=="%%@%%▓" CALL:NORMAL_LIST_%%@))
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
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!SELECT!%U00%"
EXIT /B
:NORMAL_LIST_PICKER
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01%!$VCLM2!"
SET "$FOLDFILT=%$VCLM3%"&&SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:FILE_VIEWER
SET "$NORMAL_ITEM=%U00%!$VCLM1!%U00%!$VCLM2!%U00%!$VCLM3!%U00%!$CHOICE!%U00%"
EXIT /B
:NORMAL_LIST_PROMPT
SET "$CHOICEMINO="&&SET "$CHOICEMAXO="&&SET "$CHECKO="
SET "$HEADERS=!GROUP_TARGET!%U01% %U01%!SUB_TARGET!%U01% %U01% %U01% %U01%!$VCLM2!%U01% %U01% "
SET "$CHECK=!$VCLM3!"&&SET "$VERBOSE=1"&&SET "$NO_ERRORS=1"&&SET "$CENTERED=1"&&CALL:PROMPT_BOX
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
IF "%%a"=="GROUP" IF "%%b"=="!GROUP_TARGET!" IF "%%c"=="!SUB_TARGET!" SET "DRAWER_LISTX=1"
IF "%%a"=="GROUP" IF NOT "%%b"=="!GROUP_TARGET!" SET "DRAWER_LISTX="
IF "%%a"=="GROUP" IF NOT "%%c"=="!SUB_TARGET!" SET "DRAWER_LISTX="
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
IF "!GROUP_TYPE!"=="DRAWER" FOR /F "TOKENS=*" %%□ IN ("!$DRAWER_ITEM!") DO (SET "$ITEMD%$XNT%=%%□"&&ECHO. %$$%^( %##%%$XNT%%$$% ^) %%□%$$%)
IF "!GROUP_TYPE!"=="SCOPED" FOR /F "TOKENS=*" %%□ IN ("!$DRAWER_ITEM!") DO (SET "$ITEMD%$XNT%=%%□"&&ECHO. %$$%^( %##%%$XNT%%$$% ^) %%b%$$%)
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
::CALL SET "$CHOICE_LIST=%$CHOICE_LIST%"&&CALL SET "$ITEMSTOP=%$ITEMSTOP%"&&CALL SET "$ITEMSBTM=%$ITEMSBTM%"
CALL:CHOICE_LIST
IF NOT DEFINED $ITEMC1 ECHO.   Empty.
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&IF NOT DEFINED $NO_ERRORS CALL:PAD_PREV
IF DEFINED $CHOICEMINO SET "$CHOICEMIN=0"
IF NOT DEFINED $CHOICEMINO SET "$CHOICEMIN=1"
IF DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$CHOICEMAXO%"
IF NOT DEFINED $CHOICEMAXO SET "$CHOICEMAX=%$XNT%"
IF DEFINED $CHECKO SET "$CHECK=%$CHECKO%"
IF NOT DEFINED $CHECKO SET "$CHECK=NUMBER_%$CHOICEMIN%-%$CHOICEMAX%"
SET "$VERBOSE=1"&&CALL:MENU_SELECT
IF DEFINED $NO_ERRORS IF NOT DEFINED $ITEMC1 SET "ERROR="
IF DEFINED $NO_ERRORS IF DEFINED ERROR IF DEFINED $ITEMC1 GOTO:CHOICE_BOX
FOR %%a in ($NO_ERRORS $CHOICE_LIST $ITEMSTOP $ITEMSBTM $CHOICEMINO $CHOICEMAXO $CHECKO $HEADERS $CENTERED) DO (SET "%%a=")
EXIT /B
:CHOICE_LIST
FOR %%a in ($CHOICE_LIST) DO (IF NOT DEFINED %%a GOTO:CHOICE_LIST_SKIP)
SET "$XNT="&&FOR %%a in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (IF DEFINED $ITEMC%%a SET "$ITEMC%%a=")
::CALL SET "$ITEMSTOP=%$ITEMSTOP%"&&CALL SET "$ITEMSBTM=%$ITEMSBTM%"
IF DEFINED $ITEMSTOP CALL:ITEMSTOP
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
SET "$HEADERS_LAST=%$HEADERS%"
IF NOT DEFINED $CENTERED FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$HEADERS!") DO (IF NOT "%%a"=="" ECHO.%%a&&IF NOT "%%b"=="" ECHO.%%b&&IF NOT "%%c"=="" ECHO.%%c&&IF NOT "%%d"=="" ECHO.%%d&&IF NOT "%%e"=="" ECHO.%%e&&IF NOT "%%f"=="" ECHO.%%f&&IF NOT "%%g"=="" ECHO.%%g&&IF NOT "%%h"=="" ECHO.%%h&&IF NOT "%%i"=="" ECHO.%%i)
IF DEFINED $CENTERED FOR /F "TOKENS=1-9 DELIMS=%U01%" %%a IN ("!$HEADERS!") DO (IF NOT "%%a"=="" SET "$CENTERED_MSG=%%a"&&CALL:TXT_CENTER&&IF NOT "%%b"=="" SET "$CENTERED_MSG=%%b"&&CALL:TXT_CENTER&&IF NOT "%%c"=="" SET "$CENTERED_MSG=%%c"&&CALL:TXT_CENTER&&IF NOT "%%d"=="" SET "$CENTERED_MSG=%%d"&&CALL:TXT_CENTER&&IF NOT "%%e"=="" SET "$CENTERED_MSG=%%e"&&CALL:TXT_CENTER&&IF NOT "%%f"=="" SET "$CENTERED_MSG=%%f"&&CALL:TXT_CENTER&&IF NOT "%%g"=="" SET "$CENTERED_MSG=%%g"&&CALL:TXT_CENTER&&IF NOT "%%h"=="" SET "$CENTERED_MSG=%%h"&&CALL:TXT_CENTER&&IF NOT "%%i"=="" SET "$CENTERED_MSG=%%i"&&CALL:TXT_CENTER)
SET "$HEADERS=%$HEADERS_LAST%"
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
ECHO. (%##% 5 %$$%) %U06% Current Environment  %@@%%ALLOW_ENV%%$$%&&IF "%PROG_MODE%"=="RAMDISK" ECHO. (%##% 6 %$$%) %U19% Host Hide            %@@%%HOST_HIDE%%$$%&&ECHO. (%##% 7 %$$%) %U07% Update
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
IF "%SELECT%"=="5" IF NOT "%DISCLAIMER%"=="ACCEPTED" CALL:DISCLAIMER
IF "%SELECT%"=="5" IF "%DISCLAIMER%"=="ACCEPTED" IF NOT "%ALLOW_ENV%"=="ENABLED" SET "ALLOW_ENV=ENABLED"&&SET "SELECT="&&IF "%PROG_MODE%"=="GUI" ECHO.Restart app for changes to take effect.&&CALL:PAUSED
IF "%SELECT%"=="5" IF "%DISCLAIMER%"=="ACCEPTED" IF NOT "%ALLOW_ENV%"=="DISABLED" SET "ALLOW_ENV=DISABLED"&&SET "SELECT="&&IF "%PROG_MODE%"=="GUI" ECHO.Restart app for changes to take effect.&&CALL:PAUSED
IF "%SELECT%"=="6" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="DISABLED" SET "HOST_HIDE=ENABLED"&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.           The vhdx host partition will be hidden upon exit.&&ECHO.                     Boot into recovery to revert.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED&SET "SELECT="
IF "%SELECT%"=="6" IF "%PROG_MODE%"=="RAMDISK" IF "%HOST_HIDE%"=="ENABLED" SET "HOST_HIDE=DISABLED"&&SET "SELECT="
IF "%SELECT%"=="7" IF "%PROG_MODE%"=="RAMDISK" GOTO:UPDATE_RECOVERY
GOTO:SETTINGS_MENU
:MENU_LIST
SET "$HEADERS=                        %U01% Custom Main Menu %U01%%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new template"&&SET "$FOLDFILT=%LIST_FOLDER%\*.LIST *.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
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
IF "%SELECTX%"=="1" CALL:MENU_EXAMPLE_BASE>"%LIST_FOLDER%\%NEW_NAME%.%REC_LIST%"
IF "%SELECTX%"=="2" CALL:MENU_EXAMPLE_EXEC>"%LIST_FOLDER%\%NEW_NAME%.%REC_LIST%"
START NOTEPAD.EXE "%LIST_FOLDER%\%NEW_NAME%.%REC_LIST%"
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
SET "$HEADERS=                             %U12% Appearance%U01% %U01%                           Select a pad type%U01% %U01% %U01% (%##%0%$$%) %@@%None%$$%  (%##%1%$$%) %@@%─%$$%  (%##%2%$$%) %@@%━%$$%  (%##%3%$$%) %@@%◌%$$%  (%##%4%$$%) %@@%○%$$%  (%##%5%$$%) %@@%●%$$%  (%##%6%$$%) %@@%❍%$$%  (%##%7%$$%) %@@%□%$$%  (%##%8%$$%) %@@%■%$$%%U01% %U01%    (%##%9%$$%) %@@%☰%$$%  (%##%10%$$%) %@@%☲%$$%  (%##%11%$$%) %@@%░%$$%  (%##%12%$$%) %@@%▒%$$%  (%##%13%$$%) %@@%▓%$$%   (%##%14%$$%) %@@%~%$$%  (%##%15%$$%) %@@%=%$$%  (%##%16%$$%) %@@%#%$$%%U01% "&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER_0-16"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR SET "PAD_TYPE=%SELECTX%"
EXIT /B
:COLOR_CHOICE
SET "$HEADERS=                             %U12% Appearance%U01% %U01%                             Select a color%U01% %U01% %U01% %U01%                  [ %COLOR0% 0 %COLOR1% 1 %COLOR2% 2 %COLOR3% 3 %COLOR4% 4 %COLOR5% 5 %COLOR6% 6 %COLOR7% 7 %COLOR8% 8 %COLOR9% 9 %$$% ]%U01% %U01% "&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER_0-9"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
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
IF "%COMPRESS%"=="FAST" SET "COMPRESS=MAX"&&EXIT /B
IF "%COMPRESS%"=="MAX" SET "COMPRESS=FAST"&&EXIT /B
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
IF "%SELECT%"=="*" IF EXIST "%PROG_SOURCE%\windick.cmd" SET "VER_GET=%PROG_SOURCE%\windick.cmd"&&CALL:GET_PROGVER&&COPY /Y "%PROG_SOURCE%\windick.cmd" "%PROG_FOLDER%"&GOTO:MAIN_MENU
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
IF "%UPDATE_TYPE%"=="CONFIG" IF NOT EXIST "%PROG_SOURCE%\windick.ini" ECHO.%COLOR4%ERROR:%$$% File windick.ini is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="EFI" IF NOT EXIST "%CACHE_FOLDER%\boot.sdi" IF NOT EXIST "%CACHE_FOLDER%\bootmgfw.efi" ECHO.%COLOR4%ERROR:%$$% Files boot.sdi and bootmgfw.efi are not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%CACHE_FOLDER%\boot.sav" ECHO.%COLOR4%ERROR:%$$% File boot.sav is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PROG" IF NOT EXIST "%PROG_SOURCE%\windick.cmd" ECHO.%COLOR4%ERROR:%$$% File windick.cmd is not located in folder. Abort.&&SET "ERROR=UPDATE_RECOVERY"&&CALL:PAUSED&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="PROG" SET "VER_GET=%PROG_SOURCE%\windick.cmd"&&SET "VER_SET=VER_X"&&CALL:GET_PROGVER
IF "%UPDATE_TYPE%"=="PROG" SET "VER_GET=%PROG_FOLDER%\windick.cmd"&&SET "VER_SET=VER_Y"&&CALL:GET_PROGVER
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
IF "%UPDATE_TYPE%"=="BOOT" SET "$PATH_X=%SYSTEMDRIVE%"&&CALL:GET_PATHINFO&MOVE /Y "%CACHE_FOLDER%\boot.sav" "%CACHE_FOLDER%\$BOOT.wim">NUL
IF "%UPDATE_TYPE%"=="BOOT" SET "INDEX_WORD=Setup"&&SET "$IMAGE_X=%CACHE_FOLDER%\$BOOT.wim"&&CALL:GET_WIMINDEX
IF "%UPDATE_TYPE%"=="BOOT" IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
IF "%UPDATE_TYPE%"=="BOOT" SET "$IMAGE_X=%CACHE_FOLDER%\$BOOT.wim"&&SET "INDEX_X=%INDEX_Z%"&&CALL:GET_IMAGEINFO
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CACHE_FOLDER%\$BOOT.wim" "%CACHE_FOLDER%\boot.sav">NUL
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
IF "%UPDATE_TYPE%"=="EFI" IF EXIST "%CACHE_FOLDER%\boot.sdi" ECHO.Using boot.sdi located in folder, for efi image boot support.&&COPY /Y "%CACHE_FOLDER%\boot.sdi" "%EFI_LETTER%:\Boot">NUL
IF "%UPDATE_TYPE%"=="EFI" IF EXIST "%CACHE_FOLDER%\bootmgfw.efi" ECHO.Using bootmgfw.efi located in folder, for the efi bootloader.&&COPY /Y "%CACHE_FOLDER%\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL
IF "%UPDATE_TYPE%"=="EFI" FOR %%a in (boot.sdi bootmgfw.efi) DO (IF NOT EXIST "%CACHE_FOLDER%\%%a" ECHO.File %%a is not located in folder, skipping.)
IF "%UPDATE_TYPE%"=="EFI" ECHO.Unmounting EFI...&&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
CALL:VTEMP_CREATE
IF DEFINED ERROR CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
ECHO.Extracting boot-media...
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CACHE_FOLDER%\boot.sav" "%CACHE_FOLDER%\$BOOT.wim">NUL
IF "%UPDATE_TYPE%"=="BOOT" SET "INDEX_WORD=Setup"&&SET "$IMAGE_X=%CACHE_FOLDER%\$BOOT.wim"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
IF NOT "%UPDATE_TYPE%"=="BOOT" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%EFI_LETTER%:\$.WIM" /INDEX:1 /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF "%UPDATE_TYPE%"=="BOOT" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%CACHE_FOLDER%\$BOOT.wim" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF "%UPDATE_TYPE%"=="BOOT" MOVE /Y "%CACHE_FOLDER%\$BOOT.wim" "%CACHE_FOLDER%\boot.sav">NUL
IF NOT EXIST "%VDISK_LTR%:\Windows" ECHO.%COLOR2%ERROR:%$$% BOOT MEDIA&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
IF "%UPDATE_TYPE%"=="BOOT" MD "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%PROG_FOLDER%\windick.cmd" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%PROG_FOLDER%\HOST_TARGET" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%PROG_FOLDER%\HOST_FOLDER" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" COPY /Y "%WINDIR%\System32\setup.bmp" "%VDISK_LTR%:\Windows\System32">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%PROG_FOLDER%\SETTINGS_INI" DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF NOT EXIST "%PROG_FOLDER%\RECOVERY_LOCK" DEL /Q /F "\\?\%VDISK_LTR%:\$\RECOVERY_LOCK">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%PROG_FOLDER%\SETTINGS_INI" COPY /Y "%PROG_FOLDER%\SETTINGS_INI" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%PROG_FOLDER%\RECOVERY_LOCK" COPY /Y "%PROG_FOLDER%\RECOVERY_LOCK" "%VDISK_LTR%:\$">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" IF EXIST "%VDISK_LTR%:\setup.exe" DEL /Q /F "\\?\%VDISK_LTR%:\setup.exe">NUL 2>&1
IF "%UPDATE_TYPE%"=="BOOT" (ECHO.[LaunchApp]&&ECHO.AppPath=X:\$\windick.cmd)>"%VDISK_LTR%:\Windows\System32\winpeshl.ini"
IF "%UPDATE_TYPE%"=="BOOT" ECHO.Updating boot media %@@%v%$PATHVER%%$$% to %@@%v%$IMGVER%%$$%.
IF "%UPDATE_TYPE%"=="DEL_CONFIG" ECHO.Removing default windick.ini file.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="CONFIG" ECHO.Updating default windick.ini file.&&COPY /Y "%PROG_SOURCE%\windick.ini" "%VDISK_LTR%:\$\SETTINGS_INI">NUL
IF "%UPDATE_TYPE%"=="PROG" ECHO.Updating windick.cmd %@@%v%VER_Y%%$$% to %@@%v%VER_X%%$$%.&&COPY /Y "%PROG_SOURCE%\windick.cmd" "%VDISK_LTR%:\$">NUL
IF "%UPDATE_TYPE%"=="PROG" ECHO.Removing default windick.ini file to ensure compatibility.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\SETTINGS_INI">NUL 2>&1
IF "%UPDATE_TYPE%"=="PASS" IF DEFINED RECOVERY_LOCK ECHO.Recovery password will be changed to %@@%%RECOVERY_LOCK%%$$%.&&ECHO.%RECOVERY_LOCK%>"%VDISK_LTR%:\$\RECOVERY_LOCK"
IF "%UPDATE_TYPE%"=="PASS" IF NOT DEFINED RECOVERY_LOCK ECHO.Recovery password will be cleared.&&DEL /Q /F "\\?\%VDISK_LTR%:\$\RECOVERY_LOCK">NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" ECHO.Using %PE_WALLPAPER% located in folder for the recovery wallpaper.
IF "%UPDATE_TYPE%"=="WALL" TAKEOWN /F "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" ICACLS "%VDISK_LTR%:\Windows\System32\setup.bmp" /grant %USERNAME%:F>NUL 2>&1
IF "%UPDATE_TYPE%"=="WALL" COPY /Y "%CACHE_FOLDER%\%PE_WALLPAPER%" "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
IF "%UPDATE_TYPE%"=="HOST" ECHO.Host folder will be changed to %@@%%HOST_FOLDER%%$$%.&&ECHO.%HOST_FOLDER%>"%VDISK_LTR%:\$\HOST_FOLDER"
ECHO.Saving boot-media...&&%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%VDISK_LTR%:" /IMAGEFILE:"%IMAGE_FOLDER%\$TEMP.wim" /COMPRESS:%COMPRESS% /NAME:"WindowsPE" /CheckIntegrity /Verify /Bootable&ECHO.
SET "$IMAGE_X=%IMAGE_FOLDER%\$TEMP.wim"&&SET "INDEX_X=1"&&CALL:GET_IMAGEINFO
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% File boot.sav is corrupt. Abort.&&ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
SET "GET_BYTES=MB"&&SET "INPUT=%IMAGE_FOLDER%\$TEMP.wim"&&SET "OUTPUT=BOOT_X"&&CALL:GET_FILESIZE
IF DEFINED ERROR ECHO.%COLOR2%ERROR:%$$% Unable to get file size or free space. Abort.&&ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
CALL:GET_SPACE_ENV&&FOR %%a in (EFI_FREE BOOT_X) DO (IF NOT DEFINED %%a SET "%%a=0")
IF %EFI_FREE% LEQ %BOOT_X% ECHO.%COLOR2%ERROR:%$$% File boot.sav %BOOT_X%MB exceeds %EFI_FREE%MB. Abort.&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END
FOR %%a in (0 ERROR) DO (IF "%FREE%"=="%%a" ECHO.%COLOR2%ERROR:%$$% Not enough free space. Clear some space and try again. Abort.&&ECHO.Unmounting EFI...&&SET "ERROR=UPDATE_RECOVERY"&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT&GOTO:UPDATE_END)
DEL /Q /F "%EFI_LETTER%:\$.WIM">NUL 2>&1
MOVE /Y "%IMAGE_FOLDER%\$TEMP.wim" "%EFI_LETTER%:\$.WIM">NUL
ECHO.Unmounting EFI...&&CALL:VTEMP_DELETE&CALL:EFI_UNMOUNT
:UPDATE_END
IF EXIST "%IMAGE_FOLDER%\$TEMP.wim" DEL /Q /F "%IMAGE_FOLDER%\$TEMP.wim">NUL 2>&1
IF "%UPDATE_TYPE%"=="HOST" IF NOT DEFINED ERROR REN "Z:\%HOST_FOLDERX%" "%HOST_FOLDER%">NUL 2>&1
IF NOT DEFINED ERROR FOR %%a in (Z:\%HOST_FOLDER% Z:) DO (ICACLS "%%a" /deny everyone:^(DE,WA,WDAC^)>NUL 2>&1)
IF DEFINED REBOOT_MAN ECHO.&&ECHO.                       THE SYSTEM WILL NOW RESTART.&&ECHO.&&ECHO.              %@@%UPDATE FINISH:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED&GOTO:QUIT
SET "RECOVERY_LOCK="&&GOTO:UPDATE_RECOVERY
:VTEMP_CREATE
IF DEFINED ERROR EXIT /B
IF EXIST "%IMAGE_FOLDER%\$TEMP.vhdx" CALL:VTEMP_DELETE>NUL 2>&1
ECHO.Mounting temporary vdisk...&&SET "$VDISK_FILE=%IMAGE_FOLDER%\$TEMP.vhdx"&&SET "VDISK_LTR=ANY"&&SET "VHDX_SIZE=50"&&CALL:VDISK_CREATE>NUL 2>&1
IF NOT EXIST "%VDISK_LTR%:\" SET "ERROR=VTEMP_CREATE"&&CALL:DEBUG
EXIT /B
:VTEMP_DELETE
IF EXIST "%IMAGE_FOLDER%\$TEMP.vhdx" ECHO.Unmounting temporary vdisk...&&SET "$VDISK_FILE=%IMAGE_FOLDER%\$TEMP.vhdx"&&CALL:VDISK_DETACH>NUL 2>&1
IF EXIST "%IMAGE_FOLDER%\$TEMP.vhdx" DEL /Q /F "%IMAGE_FOLDER%\$TEMP.vhdx">NUL 2>&1
EXIT /B
:PE_WALLPAPER
SET "$HEADERS=                          Recovery Wallpaper"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLDFILT=%CACHE_FOLDER%\*.JPG *.PNG"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=WALL"&&CALL:BASIC_FILE&EXIT /B
IF DEFINED $PICK SET "PE_WALLPAPER=%$CHOICE%"
IF NOT DEFINED $PICK SET "PE_WALLPAPER=SELECT"
EXIT /B
:HOST_FOLDER
SET "$HEADERS= %U01% %U01% %U01% %U01%                      Enter the host folder name%U01% %U01% %U01% "&&SET "$CHECK=ALPHA_1-20"&&SET "$VERBOSE=1"&&SET "$SELECT=SELECTX"&&CALL:PROMPT_BOX
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
IF NOT EXIST "%IMAGE_FOLDER%\*.WIM" ECHO.        %@@%Insert a Windows Disc/ISO to import installation media%$$%&&ECHO.
IF NOT EXIST "%CACHE_FOLDER%\BOOT.SAV" ECHO.            %@@%Insert a Windows Disc/ISO to import boot media%$$%&&ECHO.
IF "%SOURCE_TYPE%"=="WIM" IF "%WIM_SOURCE%"=="SELECT" SET "WIM_INDEX=1"&&SET "$IMGEDIT="
IF NOT DEFINED $IMGEDIT SET "$IMGEDIT=SELECT"&&SET "WIM_INDEX=1"
FOR %%G in (%SOURCE_TYPE% %TARGET_TYPE%) DO (IF "%%G"=="VHDX" SET "PROC_DISPLAY=1")
FOR %%G in (%SOURCE_TYPE% %TARGET_TYPE%) DO (IF "%%G"=="PATH" SET "PROC_DISPLAY=2")
IF "%PROC_DISPLAY%"=="1" ECHO.  %@@%AVAILABLE %@@%%SOURCE_TYPE%s%$$% (%##%X%$$%) %@@%%TARGET_TYPE%s%$$%:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.WIM *.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST
IF "%PROC_DISPLAY%"=="2" ECHO.  %@@%AVAILABLE %@@%%SOURCE_TYPE%s%$$% (%##%X%$$%) %@@%%TARGET_TYPE%s%$$%:%$$%&&ECHO.&&FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (IF EXIST "%%G:\" ECHO.   %%G:)
IF "%PROC_DISPLAY%"=="2" SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.WIM"&&SET "$DISP=BAS"&&CALL:FILE_LIST
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
IF "%TARGET_TYPE%"=="WIM" IF EXIST "%IMAGE_FOLDER%\%WIM_TARGET%" ECHO.&&ECHO. %COLOR4%Target %WIM_TARGET% exists. Try another name or delete the existing file.%$$%&&GOTO:IMAGEPROC_END
IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" SET "$HEADERS= %U01% %U01%                  File %@@%%VHDX_TARGET%%$$% already exists.%U01% %U01%  %COLOR2%Note:%$$% Updating can cause loss of data. Create a backup beforehand.%U01% %U01%                         Press (%##%X%$$%) to proceed%U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF "%TARGET_TYPE%"=="VHDX" IF EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" IF NOT "%CONFIRM%"=="X" ECHO.&&ECHO. %##%Abort.%$$%&&GOTO:IMAGEPROC_END
IF NOT DEFINED WIM_INDEX SET "WIM_INDEX=1"
IF NOT DEFINED VHDX_SIZE SET "VHDX_SIZE=25"
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="VHDX" CALL:WIM2VHDX
IF "%SOURCE_TYPE%"=="VHDX" IF "%TARGET_TYPE%"=="WIM" CALL:VHDX2WIM
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" SET "$PATH_X=%PATH_SOURCE%"&&CALL:GET_PATHINFO
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" IF NOT DEFINED $PATHEDIT SET "$PATHEDIT=Index_1"
IF "%SOURCE_TYPE%"=="PATH" IF "%TARGET_TYPE%"=="WIM" ECHO.Capturing %PATH_SOURCE% to target image %WIM_TARGET%...&&%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%PATH_SOURCE%" /IMAGEFILE:"%IMAGE_FOLDER%\%WIM_TARGET%" /COMPRESS:%COMPRESS% /NAME:"%$PATHEDIT%"
IF "%SOURCE_TYPE%"=="WIM" IF "%TARGET_TYPE%"=="PATH" ECHO.Applying image %WIM_SOURCE% index %WIM_INDEX% to %PATH_TARGET%...&&%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%IMAGE_FOLDER%\%WIM_SOURCE%" /INDEX:%WIM_INDEX% /APPLYDIR:"%PATH_TARGET%"
:IMAGEPROC_END
ECHO.&&ECHO.          %@@%IMAGE PROCESSING END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:WIM2VHDX
ECHO.&&IF EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" SET "$VDISK_FILE=%IMAGE_FOLDER%\%VHDX_TARGET%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" SET "$VDISK_FILE=%IMAGE_FOLDER%\%VHDX_TARGET%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_CREATE
IF NOT EXIST "%VDISK_LTR%:\" ECHO.&&ECHO.          %COLOR4%Vdisk Error. If VHDX refuses mounting, try another.%$$%
IF EXIST "%VDISK_LTR%:\" ECHO.Applying image %WIM_SOURCE% index %WIM_INDEX% to %VDISK_LTR%:...
IF EXIST "%VDISK_LTR%:\" %DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%IMAGE_FOLDER%\%WIM_SOURCE%" /INDEX:%WIM_INDEX% /APPLYDIR:"%VDISK_LTR%:"
ECHO.&&CALL:VDISK_DETACH
EXIT /B
:VHDX2WIM
ECHO.&&SET "$VDISK_FILE=%IMAGE_FOLDER%\%VHDX_SOURCE%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_ATTACH
IF NOT EXIST "%VDISK_LTR%:\" ECHO.&&ECHO.          %COLOR4%Vdisk Error. If VHDX refuses mounting, try another.%$$%
IF EXIST "%VDISK_LTR%:\" SET "$PATH_X=%VDISK_LTR%:"&&CALL:GET_PATHINFO
IF EXIST "%VDISK_LTR%:\" IF NOT DEFINED $PATHEDIT SET "$PATHEDIT=Index_1"
IF EXIST "%VDISK_LTR%:\" ECHO.Capturing %VDISK_LTR%: to target image %WIM_TARGET%...
IF EXIST "%VDISK_LTR%:\" %DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%VDISK_LTR%:" /IMAGEFILE:"%IMAGE_FOLDER%\%WIM_TARGET%" /COMPRESS:%COMPRESS% /NAME:"%$PATHEDIT%"
ECHO.&&CALL:VDISK_DETACH
EXIT /B
:BASIC_BACKUP
SET "$HEADERS=                          %U07% Image Processing%U01% %U01%              Select a virtual hard disk image to backup"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLDFILT=%IMAGE_FOLDER%\*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=VHDX"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "VHDX_SOURCE=%$BODY%%$EXT%"
SET "SOURCE_TYPE=VHDX"&&SET "TARGET_TYPE=WIM"&&CALL:IMAGEPROC_TARGET
IF NOT DEFINED WIM_TARGET EXIT /B
IF EXIST "%IMAGE_FOLDER%\%WIM_TARGET%" ECHO.&&ECHO.%COLOR2%ERROR:%$$% File already exists.&&EXIT /B
SET "WIM_INDEX=1"&&CALL:IMAGEPROC_START
EXIT /B
:BASIC_RESTORE
SET "$HEADERS=                          %U07% Image Processing%U01% %U01%                      Select an image to restore"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLDFILT=%IMAGE_FOLDER%\*.WIM"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=WIM"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "WIM_SOURCE=%$BODY%%$EXT%"
CALL:WIM_INDEX_MENU
IF DEFINED ERROR EXIT /B
SET "SOURCE_TYPE=WIM"&&SET "TARGET_TYPE=VHDX"&&CALL:IMAGEPROC_TARGET
IF NOT DEFINED VHDX_TARGET EXIT /B
IF EXIST "%IMAGE_FOLDER%\%VHDX_TARGET%" ECHO.&&ECHO.%COLOR2%ERROR:%$$% File already exists.&&EXIT /B
CALL:IMAGEPROC_VSIZE
IF DEFINED ERROR EXIT /B
CALL:IMAGEPROC_START
EXIT /B
:BOOT_IMPORT
IF EXIST "%CACHE_FOLDER%\boot.sav" SET "$HEADERS= %U01% %U01% %U01% %U01%         File boot.sav already exists. Press (%##%X%$$%) to overwrite%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF EXIST "%CACHE_FOLDER%\boot.sav" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%SOURCE_LOCATION%\boot.wim" ECHO.Importing %@@%boot.wim%$$% to boot.sav...&&COPY /Y "%SOURCE_LOCATION%\boot.wim" "%CACHE_FOLDER%\boot.sav"
EXIT /B
:SOURCE_IMPORT
SET "WIM_EXT="&&FOR %%G in (wim esd) DO (IF EXIST "%SOURCE_LOCATION%\install.%%G" SET "WIM_EXT=%%G")
IF EXIST "%CACHE_FOLDER%\boot.sav" SET "$HEADERS= %U01% %U01% %U01% %U01%                        Enter name of new .WIM%U01% %U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT DEFINED NEW_NAME EXIT /B
IF EXIST "%IMAGE_FOLDER%\%NEW_NAME%.wim" SET "$HEADERS= %U01% %U01% %U01% %U01%         File %NEW_NAME%.wim already exists. Press (%##%X%$$%) to overwrite.%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:PROMPT_BOX
IF EXIST "%IMAGE_FOLDER%\%NEW_NAME%.wim" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED NEW_NAME ECHO.Copying install.%WIM_EXT% to %@@%%NEW_NAME%.wim%$$%...&&COPY /Y "%SOURCE_LOCATION%\install.%WIM_EXT%" "%IMAGE_FOLDER%\%NEW_NAME%.wim"&&SET "NEW_NAME="
EXIT /B
:IMAGEPROC_VSIZE
SET "$HEADERS=                          %U07% Image Processing%U01% %U01% %U01% %U01%                       Enter new VHDX size in GB%U01% %U01% %U01% %U01%                 Note: 25GB or greater is recommended"&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER_1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
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
IF NOT "%SOURCE_TYPE%"=="PATH" SET "$HEADERS=                          %U07% Image Processing%U01% %U01%                          Select a %SOURCE_TYPE% source"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %U13% File Operation"&&SET "$FOLDFILT=%IMAGE_FOLDER%\*.%SOURCE_TYPE%"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT "%SOURCE_TYPE%"=="PATH" IF "%SELECT%"=="0" SET "FILE_TYPE=%SOURCE_TYPE%"&&CALL:BASIC_FILE&EXIT /B
IF NOT "%SOURCE_TYPE%"=="PATH" CALL SET "%SOURCE_TYPE%_SOURCE=%$CHOICE%"
EXIT /B
:WIM_INDEX_MENU
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U07% Image Processing&&ECHO.&&ECHO.                            Select an index&&ECHO.&&ECHO.  %@@%AVAILABLE INDEXs:%$$%&&ECHO.
SET "INDEX_DSP="&&SET "NAME_DSP="&&FOR /F "TOKENS=1-7 SKIP=5 DELIMS=:<> " %%a in ('%DISM% /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"%IMAGE_FOLDER%\%WIM_SOURCE%" 2^>NUL') DO (
IF "%%a"=="Index" SET "INDEX_DSP=%%b"
IF "%%a"=="Name" SET "NAME_DSP=%%b %%c %%d %%e %%f %%g"&&CALL:WIM_INDEX_LIST)
IF NOT DEFINED INDEX_DSP ECHO.%COLOR2%ERROR%$$%&&SET "ERROR=WIM_INDEX_MENU"&&CALL:DEBUG&&EXIT /B
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT SET "ERROR=WIM_INDEX_MENU"&&CALL:DEBUG&&EXIT /B
SET "$IMAGE_X=%IMAGE_FOLDER%\%WIM_SOURCE%"&&SET "INDEX_X=%SELECT%"&&CALL:GET_IMAGEINFO
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
ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%LIST_FOLDER%"&&SET "$FILT=*.LIST *.BASE"&&SET "$DISP=BAS"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&ECHO. %@@%%U13%LIST%$$%(%##%X%$$%)PACK%U05%%$$%     (%##%B%$$%)uild List     (%##%E%$$%)dit List     (%##%R%$$%)un List&&CALL:PAD_LINE
IF DEFINED ADV_IMGM ECHO. [%@@%OPTIONS%$$%] (%##%S%$$%)afe Exclude %@@%%SAFE_EXCLUDE%%$$%&&CALL:PAD_LINE
CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="X" GOTO:PACKAGE_MANAGEMENT
IF "%SELECT%"=="R" SET "IMAGEMGR_TYPE=LIST"&&CALL:IMAGEMGR_EXECUTE&SET "SELECT="
IF "%SELECT%"=="B" CALL:IMAGEMGR_BUILDER&SET "SELECT="
IF "%SELECT%"=="O" IF DEFINED ADV_IMGM SET "ADV_IMGM="&SET "SELECT="
IF "%SELECT%"=="O" IF NOT DEFINED ADV_IMGM SET "ADV_IMGM=1"&SET "SELECT="
IF "%SELECT%"=="E" CALL:LIST_EDIT&&SET "SELECT="
IF "%SELECT%"=="S" IF "%SAFE_EXCLUDE%"=="DISABLED" SET "SAFE_EXCLUDE=ENABLED"&SET "SELECT="
IF "%SELECT%"=="S" IF "%SAFE_EXCLUDE%"=="ENABLED" SET "SAFE_EXCLUDE=DISABLED"&SET "SELECT="
GOTO:IMAGE_MANAGEMENT
:LIST_EDIT
SET "$HEADERS=                             %U13% Edit List%U01% %U01%                             Select a list"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLDFILT=%LIST_FOLDER%\*.LIST *.BASE"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=LISTS"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
START NOTEPAD "%$PICK%"
EXIT /B
:IMAGEMGR_EXECUTE
IF "%IMAGEMGR_TYPE%"=="LIST" SET "$HEADERS=                            %U13% List Execute%U01% %U01%                            Select an option"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLDFILT=%LIST_FOLDER%\*.LIST *.BASE"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF DEFINED ERROR EXIT /B
IF "%IMAGEMGR_TYPE%"=="PACK" SET "$HEADERS=                            %U05% Pack Execute%U01% %U01%                            Select an option"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLDFILT=%PACK_FOLDER%\*.PKX"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" IF "%IMAGEMGR_TYPE%"=="PACK" SET "FILE_TYPE=PKX"&&CALL:BASIC_FILE&EXIT /B
IF "%SELECT%"=="0" IF "%IMAGEMGR_TYPE%"=="LIST" SET "FILE_TYPE=LISTS"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
SET "$LISTPACK=%$CHOICE%"&&FOR %%G in ("%$PICK%") DO (SET "CAPS_SET=IMAGEMGR_EXT"&&SET "CAPS_VAR=%%~xG"&&CALL:CAPS_SET)
IF "%IMAGEMGR_EXT%"==".BASE" SET "$LIST_FILE=%$PICK%"&SET "BASE_EXEC=1"&&CALL:LIST_VIEWER&SET "IMAGEMGR_EXT=.LIST"&SET "$HEAD=MENU-SCRIPT"&SET "$LISTPACK=$LIST"&IF "%FOLDER_MODE%"=="ISOLATED" MOVE /Y "$LIST" "%LIST_FOLDER%">NUL 2>&1
IF DEFINED ERROR EXIT /B
IF DEFINED MENU_SESSION CLS&&CALL %CMD% /C ""%PROG_SOURCE%\windick.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -MENU"&CALL:PAUSED&EXIT /B
IF "%IMAGEMGR_EXT%"==".PKX" SET "$IMGMGRX=                           %U05% Pack Execute"
IF "%IMAGEMGR_EXT%"==".LIST" SET "$IMGMGRX=                           %U13% List Execute"
SET "$ITEMSTOP="&&IF "%ALLOW_ENV%"=="ENABLED" SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"
SET "$HEADERS=%$IMGMGRX%%U01% %U01%                            Select a target"&&SET "$FOLDFILT=%IMAGE_FOLDER%\*.VHDX"&&SET "$CHOICEMINO=1"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF DEFINED ERROR EXIT /B
IF "%SELECT%"=="0" SET "LIVE_APPLY=1"
IF DEFINED LIVE_APPLY IF NOT "%ALLOW_ENV%"=="ENABLED" ECHO.&&ECHO.%COLOR4%ERROR:%$$% Enable the current environment as a target in settings.&&ECHO.&&CALL:PAUSED&EXIT /B
IF NOT DEFINED LIVE_APPLY CLS&&CALL %CMD% /C ""%PROG_SOURCE%\windick.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -vhdx "%$CHOICE%""&&CALL:PAUSED&EXIT /B
IF DEFINED LIVE_APPLY CLS&&CALL %CMD% /C ""%PROG_SOURCE%\windick.cmd" -IMAGEMGR -RUN -%IMAGEMGR_TYPE% "%$LISTPACK%" -live"&CALL:PAUSED&EXIT /B
EXIT /B
:LIST_EXEC
IF NOT DEFINED $LIST_FILE EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" IF NOT "%PROG_MODE%"=="GUI" IF NOT EXIST "%PROG_SOURCE%\$PKX" CLS
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
IF NOT EXIST "%PROG_SOURCE%\$PKX" CALL:CLEAN
FOR %%a in (LIST_ITEMS_EXECUTE LIST_ITEMS_BUILDER DRVR_QRY FEAT_QRY SC_PREPARE RO_PREPARE) DO (SET "%%a=")
EXIT /B
:UNIFIED_PARSE_EXECUTE
CALL:EXPAND_COLUMN
FOR %%● in (QCLM1 QCLM2 QCLM3) DO (IF NOT DEFINED %%● EXIT /B)
SET "$RAS="&&SET "$ITEM_TYPE="&&IF NOT DEFINED LIST_ITEMS_EXECUTE CALL:LIST_ITEMS
FOR %%● in (%LIST_ITEMS_EXECUTE%) DO (IF "%%●"=="!$QCLM1$!" SET "$ITEM_TYPE=EXECUTE")
FOR %%● in (%LIST_ITEMS_BUILDER%) DO (IF "%%●"=="!$QCLM1$!" SET "$ITEM_TYPE=BUILDER")
IF NOT DEFINED $ITEM_TYPE EXIT /B
IF "!$QCLM1$!"=="GROUP" CALL:SESSION_CLEAR
IF NOT DEFINED $QCLM4$ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! one of the four columns is not specified.&&EXIT /B
IF "!$ITEM_TYPE!"=="BUILDER" CALL:SCRO_QUEUE&&FOR %%○ in (1 2 3 4 5 6 7 8 9 I S) DO (SET "!$QCLM1$![%%○]=")
IF "!$ITEM_TYPE!"=="BUILDER" FOR /F "TOKENS=1 DELIMS=123456789" %%● IN ("!$QCLM1$!") DO (CALL:%%●_ITEM)
IF "!$ITEM_TYPE!"=="EXECUTE" FOR /F "TOKENS=*" %%● in ("!$QCLM4$!") DO (IF "%%●"=="DX" CALL:!$QCLM1$!_ITEM
FOR %%○ in (SC RO) DO (IF "%%●"=="%%○" CALL:SCRO_CREATE))
CD /D "%PROG_FOLDER%">NUL 2>&1
EXIT /B
:TEXTHOST_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!"&&SET "$OUTPUT=ZCLM"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (FILE SCREEN) DO (IF "!$ZCLM1$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not valid. Example: 'SCREEN' or 'FILE❗C:\TEXT.TXT'&&EXIT /B
IF "!$ZCLM1$!"=="FILE" IF EXIST "!$ZCLM2$!\*" ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not valid. Textfile target is a folder.&&EXIT /B
IF NOT DEFINED @QUIET ECHO.Executing %@@%texthost%$$% to !$ZCLM1$!
IF "!$ZCLM1$!"=="FILE" FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (ECHO.%%●>>"!$ZCLM2$!")
IF "!$ZCLM1$!"=="SCREEN" FOR /F "TOKENS=* DELIMS=" %%● in ("!$QCLM2$!") DO (ECHO.%%●)
EXIT /B
:SESSION_ITEM
CALL:IF_LIVE_EXT
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
CALL %CMD% /C ""%PROG_SOURCE%\windick.cmd" !$QCLM2$!"
EXIT /B
:GROUP_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 in ("!$QCLM2$!%U01%!$QCLM3$!") DO (SET "GROUP=%%1"&&SET "SUBGROUP=%%2")
IF DEFINED $QCLM7$ FOR /F "TOKENS=*" %%● IN ("!$QCLM7$!") DO (SET "CHOICE0[I]=%%●"
FOR %%○ in (1 2 3 4 5 6 7 8 9) DO (IF "%%●"=="%%○" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM6$!") DO (SET "CHOICE0[S]=%%%$QCLM7$%"&&SET "CHOICE0[%%●]=%%%$QCLM7$%")))
FOR %%● in (S I) DO (IF NOT DEFINED CHOICE0[%%●] SET "CHOICE0[I]="&&SET "CHOICE0[S]=")
EXIT /B
:PICKER_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=*" %%○ in ("!$QCLM4$!") DO (SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=%%○"&&SET "!$QCLM1$![S]=%%○")
EXIT /B
:PROMPT_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=*" %%○ in ("!$QCLM4$!") DO (SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=%%○"&&SET "!$QCLM1$![S]=%%○")
EXIT /B
:CHOICE_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=*" %%○ IN ("!$QCLM4$!") DO (SET "!$QCLM1$![I]=%%○"
FOR %%◌ in (1 2 3 4 5 6 7 8 9) DO (IF "%%○"=="%%◌" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM3$!") DO (SET "!$QCLM1$![S]=%%%$QCLM4$%"&&SET "!$QCLM1$![%%◌]=%%%$QCLM4$%")))
FOR %%○ in (S I) DO (IF NOT DEFINED !$QCLM1$![%%○] SET "!$QCLM1$![I]="&&SET "!$QCLM1$![S]=")
EXIT /B
:STRING_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM2$!") DO (
IF "!$QCLM3$!"=="STRING" IF NOT "%%1"=="" SET "!$QCLM1$![1]=%%1"&&IF NOT "%%2"=="" SET "!$QCLM1$![2]=%%2"&&IF NOT "%%3"=="" SET "!$QCLM1$![3]=%%3"&&IF NOT "%%4"=="" SET "!$QCLM1$![4]=%%4"&&IF NOT "%%5"=="" SET "!$QCLM1$![5]=%%5"&&IF NOT "%%6"=="" SET "!$QCLM1$![6]=%%6"&&IF NOT "%%7"=="" SET "!$QCLM1$![7]=%%7"&&IF NOT "%%8"=="" SET "!$QCLM1$![8]=%%8"&&IF NOT "%%9"=="" SET "!$QCLM1$![9]=%%9"
IF "!$QCLM3$!"=="INTEGER" IF NOT "%%1"=="" SET /A "!$QCLM1$![1]=%%1"&&IF NOT "%%2"=="" SET /A "!$QCLM1$![2]=%%2"&&IF NOT "%%3"=="" SET /A "!$QCLM1$![3]=%%3"&&IF NOT "%%4"=="" SET /A "!$QCLM1$![4]=%%4"&&IF NOT "%%5"=="" SET /A "!$QCLM1$![5]=%%5"&&IF NOT "%%6"=="" SET /A "!$QCLM1$![6]=%%6"&&IF NOT "%%7"=="" SET /A "!$QCLM1$![7]=%%7"&&IF NOT "%%8"=="" SET /A "!$QCLM1$![8]=%%8"&&IF NOT "%%9"=="" SET /A "!$QCLM1$![9]=%%9")
FOR /F "TOKENS=*" %%○ IN ("!$QCLM4$!") DO (SET "!$QCLM1$![I]=%%○"
FOR %%◌ in (1 2 3 4 5 6 7 8 9) DO (IF "%%○"=="%%◌" FOR /F "TOKENS=1-9 DELIMS=%U01%" %%1 IN ("!$QCLM2$!") DO (
IF "!$QCLM3$!"=="STRING" SET "!$QCLM1$![S]=%%%$QCLM4$%"
IF "!$QCLM3$!"=="INTEGER" SET /A "!$QCLM1$![S]=%%%$QCLM4$%"
)))
FOR %%○ in (S I) DO (IF NOT DEFINED !$QCLM1$![%%○] SET "!$QCLM1$![I]="&&SET "!$QCLM1$![S]=")
EXIT /B
:EXPAND_COLUMN
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&SET "$NO_QUOTE=1"&&CALL:EXPANDOFLEX
SET "@QUIET="&&FOR /F "TOKENS=* DELIMS=@" %%● IN ("!$QCLM1$!") DO (IF NOT "%%●"=="!$QCLM1$!" SET "@QUIET=1"&&SET "$QCLM1$=!$QCLM1$:@=!")
IF DEFINED $QCLM4$ FOR /F "TOKENS=*" %%● in ("!$QCLM4$!") DO (
IF "%%●"=="%U0L%HALT%U0R%" SET "$HALT=1"&&FOR %%○ in (1 2 3 4 5 6 7 8 9) DO (SET "$QCLM%%○="&&SET "$QCLM%%○$="))
EXIT /B
:EXPANDOFLEX
IF DEFINED $NO_QUOTE SET "$INPUT=!$INPUT:"=!"
SET "$NO_QUOTE="&&SET "!$OUTPUT!0=!$INPUT!"&&FOR /F "TOKENS=1-9 DELIMS=%DELIMS%" %%a in ("!$INPUT!") DO (SET "PART1=%%a"&&SET "PART2=%%b"&&SET "PART3=%%c"&&SET "PART4=%%d"&&SET "PART5=%%e"&&SET "PART6=%%f"&&SET "PART7=%%g"&&SET "PART8=%%h"&&SET "PART9=%%i")
FOR %%● in (1 2 3 4 5 6 7 8 9) DO (SET "$PART%%●="&&SET "!$OUTPUT!%%●="&&SET "$!$OUTPUT!%%●="&&SET "$!$OUTPUT!%%●$="&&IF DEFINED PART%%● SET "!$OUTPUT!%%●=!PART%%●!"&&SET "$PART%%●=!PART%%●:◁=%%!"&&SET "$PART%%●=!$PART%%●:▷=%%!"&&SET "$!$OUTPUT!%%●=!$PART%%●!"&&CALL SET "$!$OUTPUT!%%●$=!$PART%%●!"
IF DEFINED PART%%● IF NOT DEFINED $!$OUTPUT!%%●$ SET "$!$OUTPUT!%%●$=!PART%%●!")
EXIT /B
:RASTI_CREATE
IF NOT "%WINPE_BOOT%"=="1" SET "SRV_X="&&FOR /F "TOKENS=1-2* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SET "SRV_X=1"&&IF NOT "%%c"=="%CMD% /C START %PROG_FOLDER%\$RAS.cmd" %REG% add "HKLM\SYSTEM\ControlSet001\Services\$RAS" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %PROG_FOLDER%\$RAS.cmd" /f)
IF NOT "%WINPE_BOOT%"=="1" IF NOT DEFINED SRV_X SC CREATE $RAS BINPATH="%CMD% /C START "%PROG_FOLDER%\$RAS.cmd"" START=DEMAND>NUL 2>&1
IF "%$RAS%"=="RATI" ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %PROG_FOLDER%\$RATI.cmd" /f^>NUL 2^>^&^1>"%PROG_FOLDER%\$RAS.cmd"
IF "%$RAS%"=="RATI" ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>>"%PROG_FOLDER%\$RAS.cmd"
IF "%$RAS%"=="RATI" ECHO.NET START TrustedInstaller^>NUL 2^>^&^1>>"%PROG_FOLDER%\$RAS.cmd"
IF "%$RAS%"=="RATI" ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>>"%PROG_FOLDER%\$RAS.cmd"
IF "%$RAS%"=="RATI" ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%%%%SystemRoot%%%%\servicing\TrustedInstaller.exe" /f^>NUL 2^>^&^1>>"%PROG_FOLDER%\$RAS.cmd"
IF "%$RAS%"=="RATI" ECHO.DEL /Q /F "%PROG_FOLDER%\$RAS.cmd"^>NUL^&EXIT>>"%PROG_FOLDER%\$RAS.cmd"
ECHO.@ECHO OFF^&CD /D "%PROG_FOLDER%">"%PROG_FOLDER%\$%$RAS%.cmd"
IF NOT DEFINED VAR_ITEMS CALL:VAR_ITEMS
FOR %%■ in (DRVTAR WINTAR USRTAR HIVE_SOFTWARE HIVE_SYSTEM HIVE_USER PROG_SOURCE IMAGE_FOLDER LIST_FOLDER PACK_FOLDER CACHE_FOLDER PKX_FOLDER APPLY_TARGET USER_NAM USER_SID %VAR_ITEMS%) DO (IF DEFINED %%■ ECHO.SET "%%■=!%%■!">>"%PROG_FOLDER%\$%$RAS%.cmd")
ECHO.CALL:ROUTINE^>"%PROG_FOLDER%\$LOG">>"%PROG_FOLDER%\$%$RAS%.cmd"
ECHO.DEL /Q /F "%PROG_FOLDER%\$%$RAS%.cmd"^>NUL^&EXIT>>"%PROG_FOLDER%\$%$RAS%.cmd"
ECHO.:ROUTINE>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF "%$QCLM1$%"=="COMMAND" IF EXIST "$LIST" ECHO.FOR /F "TOKENS=*" %%%%@ in ($LIST) DO (%CMD% /C %%%%@)>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF "%$QCLM1$%:%$QCLM3$%"=="SERVICE:DELETE" ECHO.%REG% DELETE "%HIVE_SYSTEM%\ControlSet001\Services\%$QCLM2$%" /F^>NUL 2^>^&^1>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF "%$QCLM1$%:%$QCLM3$%"=="SERVICE:AUTO" ECHO.%REG% ADD "%HIVE_SYSTEM%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "2" /F^>NUL 2^>^&^1>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF "%$QCLM1$%:%$QCLM3$%"=="SERVICE:MANUAL" ECHO.%REG% ADD "%HIVE_SYSTEM%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "3" /F^>NUL 2^>^&^1>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF "%$QCLM1$%:%$QCLM3$%"=="SERVICE:DISABLE" ECHO.%REG% ADD "%HIVE_SYSTEM%\ControlSet001\Services\%$QCLM2$%" /V "Start" /T REG_DWORD /D "4" /F^>NUL 2^>^&^1>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF "%$QCLM1$%"=="TASK" ECHO.%REG% DELETE "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /F^>NUL 2^>^&^1>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF "%$QCLM1$%"=="TASK" ECHO.%REG% DELETE "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{%TASKID%}" /F^>NUL 2^>^&^1>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF "%$QCLM1$%"=="TASK" ECHO.DEL /Q /F "%WINTAR%\System32\Tasks\%$QCLM2$%"^>NUL 2^>^&^1>>"%PROG_FOLDER%\$%$RAS%.cmd"
SET "XNT="&&ECHO.EXIT /B>>"%PROG_FOLDER%\$%$RAS%.cmd"
IF NOT "%WINPE_BOOT%"=="1" NET START $RAS>NUL 2>&1
IF "%WINPE_BOOT%"=="1" IF "%$RAS%"=="RAS" CALL %CMD% /C "%PROG_FOLDER%\$RAS.cmd"
IF "%WINPE_BOOT%"=="1" IF "%$RAS%"=="RATI" CALL %CMD% /C "%PROG_FOLDER%\$RAS.cmd">NUL 2>&1
:RASTI_WAIT
SET /A "XNT+=1"&&FOR %%■ in (SERVICE TASK) DO (IF "%$QCLM1$%"=="%%■" FOR %%□ in (RAS RATI) DO (
IF EXIST "%PROG_FOLDER%\$%%□.cmd" CALL:TIMER_POINT3
IF EXIST "%PROG_FOLDER%\$%%□.cmd" IF "%XNT%"=="10" IF NOT DEFINED RETRY SET "RETRY=1"&&GOTO:RASTI_CREATE
IF EXIST "%PROG_FOLDER%\$%%□.cmd" IF "%XNT%"=="10" IF DEFINED RETRY CALL:RASTI_CHECK&DEL /Q /F "%PROG_FOLDER%\$%%□.cmd">NUL 2>&1))
FOR %%□ in (RAS RATI) DO (IF EXIST "%PROG_FOLDER%\$%%□.cmd" GOTO:RASTI_WAIT)
IF EXIST "%PROG_FOLDER%\$LOG" IF NOT "%$QCLM1$%"=="SERVICE" IF NOT "%$QCLM1$%"=="TASK" FOR /F "TOKENS=* DELIMS=" %%□ in (%PROG_FOLDER%\$LOG) DO (ECHO.%%□)
IF EXIST "%PROG_FOLDER%\$LOG" DEL /Q /F "%PROG_FOLDER%\$LOG">NUL 2>&1
SET "RETRY="&&SET "XNT="&&EXIT /B
:RASTI_CHECK
SET "$GO="&&FOR /F "TOKENS=1-3* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" IF "%%c"=="%CMD%" SET "$GO=1")
IF NOT DEFINED $GO EXIT /B
IF NOT "%WINPE_BOOT%"=="1" SET "SRV_X="&&FOR /F "TOKENS=1-2* DELIMS= " %%a in ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\Services\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SET "SRV_X=1"&&IF NOT "%%c"=="%CMD% /C START %PROG_FOLDER%\$RAS.cmd" %REG% add "HKLM\SYSTEM\ControlSet001\Services\$RAS" /v "ImagePath" /t REG_EXPAND_SZ /d "%CMD% /C START %PROG_FOLDER%\$RAS.cmd" /f)
IF NOT "%WINPE_BOOT%"=="1" IF NOT DEFINED SRV_X SC CREATE $RAS BINPATH="%CMD% /C START "%PROG_FOLDER%\$RAS.cmd"" START=DEMAND>NUL 2>&1
ECHO.NET STOP TrustedInstaller^>NUL 2^>^&^1>"%PROG_FOLDER%\$RAS.cmd"
ECHO.%REG% add "HKLM\SYSTEM\ControlSet001\Services\TrustedInstaller" /v "ImagePath" /t REG_EXPAND_SZ /d "%%%%SystemRoot%%%%\servicing\TrustedInstaller.exe" /f^>NUL 2^>^&^1>>"%PROG_FOLDER%\$RAS.cmd"
ECHO.DEL /Q /F "%PROG_FOLDER%\$RAS.cmd"^>NUL^&EXIT>>"%PROG_FOLDER%\$RAS.cmd"
IF NOT "%WINPE_BOOT%"=="1" NET START $RAS>NUL 2>&1
IF "%WINPE_BOOT%"=="1" CALL %CMD% /C "%PROG_FOLDER%\$RAS.cmd"
EXIT /B
:RAS_DELETE
IF "%WINPE_BOOT%"=="1" EXIT /B
FOR /F "TOKENS=1 DELIMS= " %%a IN ('%REG% QUERY "HKLM\SYSTEM\ControlSet001\SERVICES\$RAS" /V ImagePath 2^>NUL') DO (IF "%%a"=="ImagePath" SC DELETE $RAS>NUL 2>&1)
EXIT /B
:ARRAY_ITEM
SET "$IFELSE="
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM4!"&&SET "$OUTPUT=ACTN"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!"&&SET "$OUTPUT=MATCH"&&CALL:EXPANDOFLEX
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH1$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![S]=!$ACTN1$!"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "$IFELSE=1"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH2$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![S]=!$ACTN2$!"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "$IFELSE=2"
IF NOT "!ACTN3!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH3$!" SET "!$QCLM1$![I]=3"&&SET "!$QCLM1$![S]=!$ACTN3$!"&&SET "!$QCLM1$![3]=!$ACTN3$!"&&SET "$IFELSE=3"
IF NOT "!ACTN4!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH4$!" SET "!$QCLM1$![I]=4"&&SET "!$QCLM1$![S]=!$ACTN4$!"&&SET "!$QCLM1$![4]=!$ACTN4$!"&&SET "$IFELSE=4"
IF NOT "!ACTN5!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH5$!" SET "!$QCLM1$![I]=5"&&SET "!$QCLM1$![S]=!$ACTN5$!"&&SET "!$QCLM1$![5]=!$ACTN5$!"&&SET "$IFELSE=5"
IF NOT "!ACTN6!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH6$!" SET "!$QCLM1$![I]=6"&&SET "!$QCLM1$![S]=!$ACTN6$!"&&SET "!$QCLM1$![6]=!$ACTN6$!"&&SET "$IFELSE=6"
IF NOT "!ACTN7!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH7$!" SET "!$QCLM1$![I]=7"&&SET "!$QCLM1$![S]=!$ACTN7$!"&&SET "!$QCLM1$![7]=!$ACTN7$!"&&SET "$IFELSE=7"
IF NOT "!ACTN8!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH8$!" SET "!$QCLM1$![I]=8"&&SET "!$QCLM1$![S]=!$ACTN8$!"&&SET "!$QCLM1$![8]=!$ACTN8$!"&&SET "$IFELSE=8"
IF NOT "!ACTN9!"=="◁NULL▷" IF "!$QCLM2$!"=="!$MATCH9$!" SET "!$QCLM1$![I]=9"&&SET "!$QCLM1$![S]=!$ACTN9$!"&&SET "!$QCLM1$![9]=!$ACTN9$!"&&SET "$IFELSE=9"
IF NOT DEFINED $QCLM5$ EXIT /B
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM5!"&&SET "$OUTPUT=ELSE"&&CALL:EXPANDOFLEX
IF NOT "!ELSE1!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH1$!" SET "!$QCLM1$![1]=!$ELSE1$!"&&IF "!$IFELSE!"=="1" SET "!$QCLM1$![S]=!$ELSE1$!"
IF NOT "!ELSE2!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH2$!" SET "!$QCLM1$![2]=!$ELSE2$!"&&IF "!$IFELSE!"=="2" SET "!$QCLM1$![S]=!$ELSE2$!"
IF NOT "!ELSE3!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH3$!" SET "!$QCLM1$![3]=!$ELSE3$!"&&IF "!$IFELSE!"=="3" SET "!$QCLM1$![S]=!$ELSE3$!"
IF NOT "!ELSE4!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH4$!" SET "!$QCLM1$![4]=!$ELSE4$!"&&IF "!$IFELSE!"=="4" SET "!$QCLM1$![S]=!$ELSE4$!"
IF NOT "!ELSE5!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH5$!" SET "!$QCLM1$![5]=!$ELSE5$!"&&IF "!$IFELSE!"=="5" SET "!$QCLM1$![S]=!$ELSE5$!"
IF NOT "!ELSE6!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH6$!" SET "!$QCLM1$![6]=!$ELSE6$!"&&IF "!$IFELSE!"=="6" SET "!$QCLM1$![S]=!$ELSE6$!"
IF NOT "!ELSE7!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH7$!" SET "!$QCLM1$![7]=!$ELSE7$!"&&IF "!$IFELSE!"=="7" SET "!$QCLM1$![S]=!$ELSE7$!"
IF NOT "!ELSE8!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH8$!" SET "!$QCLM1$![8]=!$ELSE8$!"&&IF "!$IFELSE!"=="8" SET "!$QCLM1$![S]=!$ELSE8$!"
IF NOT "!ELSE9!"=="◁NULL▷" IF NOT "!$QCLM2$!"=="!$MATCH9$!" SET "!$QCLM1$![9]=!$ELSE9$!"&&IF "!$IFELSE!"=="9" SET "!$QCLM1$![S]=!$ELSE9$!"
EXIT /B
:ROUTINE_ITEM
SET "$PASS="&&FOR %%□ IN (SPLIT COMMAND) DO (IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not SPLIT or COMMAND.&&EXIT /B
CALL:IF_LIVE_EXT
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=ROUT"&&CALL:EXPANDOFLEX
IF "!$QCLM4$!"=="COMMAND" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: '^<^>❗DIR C:\ /B❗1❗TEST.TXT' or '^<^>❗DIR C:\ /B'&&EXIT /B)
IF "!$QCLM4$!"=="SPLIT" FOR %%□ IN ($ROUT1$ $ROUT2$) DO (IF NOT DEFINED %%□ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 is not valid. Example: ':❗A:B:C❗3❗C' or ':❗A:B:C'&&EXIT /B)
IF "!$QCLM3$!"=="COMMAND" FOR /F "TOKENS=1-9 DELIMS=%$ROUT1$%" %%1 in ('!$ROUT2$!') DO (
IF NOT DEFINED $ROUT3$ SET "!$QCLM1$![S]=%%%$QCLM4$%"&&SET "!$QCLM1$![1]=%%%$QCLM4$%"&&SET /A "!$QCLM1$![I]=1"
IF DEFINED $ROUT3$ IF "!$ROUT4$!"=="%%%$ROUT3$%" SET "!$QCLM1$![S]=%%%$QCLM4$%"&&SET "!$QCLM1$![1]=%%%$QCLM4$%"&&SET "!$QCLM1$![I]=1")
IF "!$QCLM3$!"=="SPLIT" FOR /F "TOKENS=1-9 DELIMS=%$ROUT1$%" %%1 in ("!$ROUT2$!") DO (
IF NOT "%%1"=="" SET "!$QCLM1$![1]=%%1"&&IF NOT "%%2"=="" SET "!$QCLM1$![2]=%%2"&&IF NOT "%%3"=="" SET "!$QCLM1$![3]=%%3"&&IF NOT "%%4"=="" SET "!$QCLM1$![4]=%%4"&&IF NOT "%%5"=="" SET "!$QCLM1$![5]=%%5"&&IF NOT "%%6"=="" SET "!$QCLM1$![6]=%%6"&&IF NOT "%%7"=="" SET "!$QCLM1$![7]=%%7"&&IF NOT "%%8"=="" SET "!$QCLM1$![8]=%%8"&&IF NOT "%%9"=="" SET "!$QCLM1$![9]=%%9"
IF NOT DEFINED $ROUT3$ SET "!$QCLM1$![S]=%%%$QCLM4$%"&&SET /A "!$QCLM1$![I]=!$QCLM4$!"
IF DEFINED $ROUT3$ IF "!$ROUT4$!"=="%%%$ROUT3$%" SET "!$QCLM1$![S]=%%%$QCLM4$%"&&SET "!$QCLM1$![I]=!$QCLM4$!")
EXIT /B
:MATH_ITEM
SET "$PASS="&&FOR %%□ IN (+ - /) DO (IF "!$QCLM3$!"=="*" SET "$PASS=1"
IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 OPERATION is not *, /, +, or -.&&EXIT /B
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET /A "!$QCLM1$![I]=1"&&SET /A "!$QCLM1$![S]=!$QCLM2$!"&&SET /A "!$QCLM1$![S]!$QCLM3$!=!$QCLM4$!"&&SET /A "!$QCLM1$![1]=!$QCLM1$![S]!"
EXIT /B
:CONDIT_ITEM
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_EXT
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=COND"&&CALL:EXPANDOFLEX
SET "$PASS="&&FOR %%□ IN (EXIST NEXIST DEFINED NDEFINED EQ NE LE GE GT LT) DO (IF "!$COND2$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 CONDITION is not EQ, NE, LE, GE, GT, LT, EXIST, NEXIST, DEFINED or NDEFINED. Example: 'c:\❗EXIST' or '1❗EQ❗1' or 'CHOICE1❗DEFINED'&&EXIT /B
FOR %%□ IN (EQ NE LE GE GT LT) DO (IF "!$COND2$!"=="%%□" IF NOT DEFINED $COND3$ ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 3 COMPARE is not specified. Example: '1❗EQ❗1'&&EXIT /B)
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM3!%U01%!QCLM4!"&&SET "$OUTPUT=ACTN"&&CALL:EXPANDOFLEX
IF DEFINED $ACTN2$ FOR %%□ IN (EQ NE LE GE GT LT) DO (IF "!$COND2$"=="%%□" SET /A "$COND1$=!$COND1$!"&&SET /A "$COND3$=!$COND3$!")
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="DEFINED" IF DEFINED !$COND1$! SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="DEFINED" IF NOT DEFINED !$COND1$! SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="NDEFINED" IF NOT DEFINED !$COND1$! SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="NDEFINED" IF DEFINED !$COND1$! SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="EXIST" IF EXIST "!$COND1$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="EXIST" IF NOT EXIST "!$COND1$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="NEXIST" IF NOT EXIST "!$COND1$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="NEXIST" IF EXIST "!$COND1$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="EQ" IF "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="EQ" IF NOT "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="NE" IF NOT "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="NE" IF "!$COND1$!"=="!$COND3$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="LE" IF "!$COND1$!" LEQ "!$COND3$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="LE" IF NOT "!$COND1$!" LEQ "!$COND3$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="GE" IF "!$COND1$!" GEQ "!$COND3$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="GE" IF NOT "!$COND1$!" GEQ "!$COND3$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="GT" IF "!$COND1$!" GTR "!$COND3$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="GT" IF NOT "!$COND1$!" GTR "!$COND3$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
IF NOT "!ACTN1!"=="◁NULL▷" IF "!$COND2$!"=="LT" IF "!$COND1$!" LSS "!$COND3$!" SET "!$QCLM1$![I]=1"&&SET "!$QCLM1$![1]=!$ACTN1$!"&&SET "!$QCLM1$![S]=!$ACTN1$!"
IF NOT "!ACTN2!"=="◁NULL▷" IF "!$COND2$!"=="LT" IF NOT "!$COND1$!" LSS "!$COND3$!" SET "!$QCLM1$![I]=2"&&SET "!$QCLM1$![2]=!$ACTN2$!"&&SET "!$QCLM1$![S]=!$ACTN2$!"
EXIT /B
:FILEOPER_ITEM
SET "$FILE_OBJ="&&SET "$PASS="&&FOR %%□ IN (CREATE DELETE RENAME COPY MOVE TAKEOWN) DO (IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not CREATE, DELETE, RENAME, COPY, MOVE, or TAKEOWN.&&EXIT /B
IF NOT "%MOUNT%"=="EXT" CALL:IF_LIVE_MIX
FOR /F "TOKENS=*" %%a in ("!$QCLM3$!") DO (SET "$FILEOPER=%%a"&&SET "$RAS=%%b")
FOR /F "TOKENS=1-4 DELIMS=%U01%" %%a in ("!$QCLM2$!") DO (SET "$OBJONE=%%a"&&SET "$OBJTWO=%%b")
IF "%$FILEOPER%"=="COPY" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
IF "%$FILEOPER%"=="MOVE" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
IF "%$FILEOPER%"=="RENAME" IF NOT DEFINED $OBJTWO ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 OBJ_TAR is not specified.&&EXIT /B
SET "$EXIT="&&FOR %%□ IN (DELETE RENAME COPY MOVE TAKEOWN) DO (IF "%$FILEOPER%"=="%%□" IF NOT EXIST "!$OBJONE!" SET "$EXIT=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR4%ERROR:%$$% !$OBJONE! doesn't exist.)
IF "%$FILEOPER%"=="CREATE" IF EXIST "!$OBJONE!" SET "$EXIT=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR4%ERROR:%$$% !$OBJONE! already exists.
IF DEFINED $EXIT EXIT /B
IF EXIST "!$OBJONE!\*" SET "$FILE_OBJ=FOLD"
IF NOT EXIST "!$OBJONE!\*" SET "$FILE_OBJ=FILE"
IF "%$FILEOPER%"=="CREATE" SET "$FILE_OBJ=FOLD"
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF "!$RAS!"=="RAS" SET "RUN_AS=system"
IF "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
IF NOT DEFINED @QUIET ECHO.Executing %@@%fileoper%$$% !$FILEOPER! !$FILE_OBJ! !$OBJONE! as %##%%RUN_AS%%$$%!
IF "%$FILEOPER%"=="CREATE" IF "%$FILE_OBJ%"=="FOLD" MD "\\?\!$OBJONE!">NUL 2>&1
IF "%$FILEOPER%"=="DELETE" IF "%$FILE_OBJ%"=="FOLD" IF EXIST "!$OBJONE!" RD /S /Q "\\?\!$OBJONE!"
IF "%$FILEOPER%"=="DELETE" IF "%$FILE_OBJ%"=="FILE" IF EXIST "!$OBJONE!" DEL /Q /F "\\?\!$OBJONE!"
IF "%$FILEOPER%"=="RENAME" IF "%$FILE_OBJ%"=="FILE" REN "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF "%$FILEOPER%"=="RENAME" IF "%$FILE_OBJ%"=="FOLD" REN "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF "%$FILEOPER%"=="COPY" IF "%$FILE_OBJ%"=="FILE" XCOPY "!$OBJONE!" "!$OBJTWO!" /C /Y>NUL 2>&1
IF "%$FILEOPER%"=="COPY" IF "%$FILE_OBJ%"=="FOLD" XCOPY "!$OBJONE!" "!$OBJTWO!\" /E /C /I /Y>NUL 2>&1
IF "%$FILEOPER%"=="MOVE" IF "%$FILE_OBJ%"=="FILE" MOVE /Y "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF "%$FILEOPER%"=="MOVE" IF "%$FILE_OBJ%"=="FOLD" MOVE /Y "!$OBJONE!" "!$OBJTWO!">NUL 2>&1
IF "%$FILEOPER%"=="TAKEOWN" IF "%$FILE_OBJ%"=="FILE" TAKEOWN /F "!$OBJONE!">NUL 2>&1
IF "%$FILEOPER%"=="TAKEOWN" IF "%$FILE_OBJ%"=="FOLD" TAKEOWN /F "!$OBJONE!" /R /D Y>NUL 2>&1
IF "%$FILEOPER%"=="TAKEOWN" IF DEFINED $FILE_OBJ ICACLS "!$OBJONE!" /grant %USERNAME%:F /T>NUL 2>&1
EXIT /B
:REGISTRY_ITEM
SET "$REG_OBJ="&&SET "$PASS="&&FOR %%□ IN (CREATE DELETE IMPORT EXPORT IMPORT%U01%RAS IMPORT%U01%RATI EXPORT%U01%RAS EXPORT%U01%RATI CREATE%U01%RAS CREATE%U01%RATI DELETE%U01%RAS DELETE%U01%RATI) DO (IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not CREATE, DELETE, IMPORT, EXPORT, CREATE%U01%RAS, CREATE%U01%RATI, DELETE%U01%RAS, or DELETE%U01%RATI.&&EXIT /B
CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$QCLM3$!") DO (SET "$QCLM3$=%%a"&&SET "$REG_OPER=%%a"&&SET "$RAS=%%b")
SET "DELIMS=%U00%"&&SET "$INPUT=!COLUMN0!"&&SET "$OUTPUT=QCLM"&&CALL:EXPANDOFLEX
SET "DELIMS=%U01%"&&SET "$INPUT=!QCLM2!"&&SET "$OUTPUT=RCLM"&&CALL:EXPANDOFLEX
SET "$REG_KEY=!$RCLM1$!"&&SET "$REG_VAL=!$RCLM2$!"&&SET "$REG_DAT=!$RCLM3$!"&&SET "$REG_TYPE=!$RCLM4$!"
IF "%$REG_OPER%"=="IMPORT" IF DEFINED $REG_KEY IF NOT EXIST "!$REG_KEY!" ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg file does not exist.&&EXIT /B
IF "%$REG_OPER%"=="IMPORT" IF NOT DEFINED $REG_KEY ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg file location is not specified.&&EXIT /B
IF "%$REG_OPER%"=="EXPORT" IF DEFINED $REG_KEY IF NOT DEFINED $REG_VAL ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 2 "REG KEY" is not specified.&&EXIT /B
IF "%$REG_OPER%"=="EXPORT" IF NOT DEFINED $REG_KEY ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 .reg "file location" is not specified.&&EXIT /B
IF "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL IF NOT DEFINED $REG_DAT ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 3 "registry value data" is not specified.&&EXIT /B
IF "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL SET "$PASS="&&FOR %%□ IN (DWORD QWORD BINARY STRING EXPAND MULTI) DO (IF "!$REG_TYPE!"=="%%□" SET "$PASS=1")
IF "%$REG_OPER%"=="CREATE" IF DEFINED $REG_VAL IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 2 object 4 "registry value type" is not DWORD, QWORD, BINARY, STRING, EXPAND, or MULTI.&&EXIT /B
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF "!$RAS!"=="RAS" SET "RUN_AS=system"
IF "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
IF "%$REG_OPER%"=="IMPORT" GOTO:REGISTRY_ITEM_END
IF "%$REG_OPER%"=="EXPORT" GOTO:REGISTRY_ITEM_END
IF DEFINED $REG_VAL SET "$REG_OBJ=VAL"
IF NOT DEFINED $REG_VAL SET "$REG_OBJ=KEY"
IF "%$REG_TYPE%"=="DWORD" SET "$REG_TYPEX=REG_DWORD"
IF "%$REG_TYPE%"=="QWORD" SET "$REG_TYPEX=REG_QWORD"
IF "%$REG_TYPE%"=="BINARY" SET "$REG_TYPEX=REG_BINARY"
IF "%$REG_TYPE%"=="STRING" SET "$REG_TYPEX=REG_SZ"
IF "%$REG_TYPE%"=="EXPAND" SET "$REG_TYPEX=REG_EXPAND_SZ"
IF "%$REG_TYPE%"=="MULTI" SET "$REG_TYPEX=REG_MULTI_SZ"
IF "!$REG_DAT!"=="◁NULL▷" SET "$REG_DAT="
IF "!$REG_VAL!"=="◁NULL▷" SET "$REG_VAL="&&SET "$REG_TYPEX=REG_SZ"
IF NOT DEFINED @QUIET IF "%$REG_OBJ%"=="KEY" ECHO.Executing %@@%registry%$$% !$REG_OPER! as %##%%RUN_AS%%$$% key !$REG_KEY!
IF NOT DEFINED @QUIET IF "%$REG_OBJ%"=="VAL" ECHO.Executing %@@%registry%$$% !$REG_OPER! as %##%%RUN_AS%%$$% key !$REG_KEY! value !$REG_VAL!
IF "%$REG_OPER%"=="DELETE" IF "%$REG_OBJ%"=="KEY" IF NOT DEFINED $RAS %CMD% /C %REG% DELETE "!$REG_KEY!" /f>NUL
IF "%$REG_OPER%"=="DELETE" IF "%$REG_OBJ%"=="VAL" IF NOT DEFINED $RAS %CMD% /C %REG% DELETE "!$REG_KEY!" /v "!$REG_VAL!" /f>NUL
IF "%$REG_OPER%"=="CREATE" IF "%$REG_OBJ%"=="KEY" IF NOT DEFINED $RAS %CMD% /C %REG% ADD "!$REG_KEY!" /f>NUL
IF "%$REG_OPER%"=="CREATE" IF "%$REG_OBJ%"=="VAL" IF NOT DEFINED $RAS %CMD% /C %REG% ADD "!$REG_KEY!" /v "!$REG_VAL!" /t "!$REG_TYPEX!" /d "!$REG_DAT!" /f>NUL
IF "%$REG_OPER%"=="DELETE" IF "%$REG_OBJ%"=="KEY" IF DEFINED $RAS ECHO.%CMD% /C %REG% DELETE "!$REG_KEY!" /f ^>NUL>"$LIST"
IF "%$REG_OPER%"=="DELETE" IF "%$REG_OBJ%"=="VAL" IF DEFINED $RAS ECHO.%CMD% /C %REG% DELETE "!$REG_KEY!" /v "!$REG_VAL!" /f ^>NUL>"$LIST"
IF "%$REG_OPER%"=="CREATE" IF "%$REG_OBJ%"=="KEY" IF DEFINED $RAS ECHO.%CMD% /C %REG% ADD "!$REG_KEY!" /f ^>NUL>"$LIST"
IF "%$REG_OPER%"=="CREATE" IF "%$REG_OBJ%"=="VAL" IF DEFINED $RAS ECHO.%CMD% /C %REG% ADD "!$REG_KEY!" /v "!$REG_VAL!" /t "!$REG_TYPEX!" /d "!$REG_DAT!" /f ^>NUL>"$LIST"
:REGISTRY_ITEM_END
IF "%$REG_OPER%"=="IMPORT" IF NOT DEFINED @QUIET ECHO.Executing %@@%registry%$$% !$REG_OPER! as %##%%RUN_AS%%$$%
IF "%$REG_OPER%"=="EXPORT" IF NOT DEFINED @QUIET ECHO.Executing %@@%registry%$$% !$REG_OPER! as %##%%RUN_AS%%$$%
IF "%$REG_OPER%"=="IMPORT" IF NOT DEFINED $RAS %CMD% /C %REG% IMPORT "!$REG_KEY!" >NUL 2>&1
IF "%$REG_OPER%"=="IMPORT" IF DEFINED $RAS ECHO.%CMD% /C %REG% IMPORT "!$REG_KEY!" ^>NUL>"$LIST"
IF "%$REG_OPER%"=="EXPORT" IF NOT DEFINED $RAS %CMD% /C %REG% EXPORT "!$REG_KEY!" "!$REG_VAL!" /Y>NUL 2>&1
IF "%$REG_OPER%"=="EXPORT" IF DEFINED $RAS ECHO.%CMD% /C %REG% EXPORT "!$REG_KEY!" "!$REG_VAL!" /Y^>NUL>"$LIST"
IF DEFINED $RAS SET "$QCLM1$=COMMAND"&&SET "$QCLM3$=NORMAL"&&CALL:RASTI_CREATE
EXIT /B
:COMMAND_ITEM
SET "$PASS="&&FOR %%□ IN (NORMAL NOMOUNT NORMAL%U01%RAU NORMAL%U01%RAS NORMAL%U01%RATI NOMOUNT%U01%RAU NOMOUNT%U01%RAS NOMOUNT%U01%RATI) DO (IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not NORMAL, NOMOUNT, NORMAL%U01%RAU, NORMAL%U01%RAS, NORMAL%U01%RATI, NOMOUNT%U01%RAU, NOMOUNT%U01%RAS, or NOMOUNT%U01%RATI.&&EXIT /B
IF "!$QCLM3$!"=="NOMOUNT" CALL:IF_LIVE_MIX
IF "!$QCLM3$!"=="NORMAL" CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-2 DELIMS=%U01%" %%a in ("!$QCLM3$!") DO (SET "$QCLM3$=%%a"&&SET "$RAS=%%b")
IF NOT DEFINED $RAS SET "RUN_AS=user"
IF "!$RAS!"=="RAU" SET "RUN_AS=user"&&SET "$RAS="
IF "!$RAS!"=="RAS" SET "RUN_AS=system"
IF "!$RAS!"=="RATI" SET "RUN_AS=trustedinstaller"
SET "$COLUMN0=!COLUMN0:◁=%%!"&&SET "$COLUMN0=!$COLUMN0:▷=%%!"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ("!$COLUMN0!") DO (SET "$COLUMN2=%%b")
IF NOT DEFINED @QUIET ECHO.Executing %@@%command%$$% as %##%%RUN_AS%%$$% !$COLUMN2!
IF DEFINED $RAS ECHO.!$COLUMN2!>"$LIST"
IF DEFINED $RAS CALL:RASTI_CREATE
IF NOT DEFINED $RAS %CMD% /C !$COLUMN2!
SET "$COLUMN0="&&SET "$COLUMN2="
EXIT /B
:EXTPACKAGE_ITEM
SET "$PASS="&&FOR %%□ IN (INSTALL) DO (IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not INSTALL.&&EXIT /B
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (SET "EXTPACKAGE=%PACK_FOLDER%\%%□"
IF NOT EXIST "%PACK_FOLDER%\%%□" ECHO.%COLOR4%ERROR:%$$% %PACK_FOLDER%\%%□ doesn't exist.&&EXIT /B)
SET "PACK_GOOD=The operation completed successfully"
FOR %%G in ("%EXTPACKAGE%") DO (SET "PACKFULL=%%~nG%%~xG"&&SET "PACKEXT=%%~xG")
FOR %%G in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (CALL SET "PACKEXT=%%PACKEXT:%%G=%%G%%")
IF "%PACKEXT%"==".PKX" CALL %CMD% /C ""%PROG_SOURCE%\windick.cmd" -IMAGEMGR -RUN -PACK "%$QCLM2$%" -path "%DRVTAR%""&EXIT /B
FOR %%G in (APPXBUNDLE MSIXBUNDLE) DO (IF "%PACKEXT%"==".%%G" SET "PACKEXT=.APPX")
IF NOT DEFINED @QUIET ECHO.Installing %@@%%PACKFULL%%$$%...
CALL:IF_LIVE_MIX
IF "%PACKEXT%"==".APPX" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /ADD-PROVISIONEDAPPXPACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" ECHO.%COLOR5%%PACK_GOOD%.%$$%&&EXIT /B)
IF "%PACKEXT%"==".APPX" FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /ADD-PROVISIONEDAPPXPACKAGE /PACKAGEPATH:"%EXTPACKAGE%" /SKIPLICENSE 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF "%PACKEXT%"==".APPX" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF "%PACKEXT%"==".CAB" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /ADD-PACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF "%PACKEXT%"==".CAB" GOTO:CAB_EXEC
IF "%PACKEXT%"==".MSU" SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /ADD-PACKAGE /PACKAGEPATH:"%EXTPACKAGE%" 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF "%%1"=="%PACK_GOOD%" EXIT /B)
IF "%PACKEXT%"==".MSU" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
EXIT /B
:PKX_EXEC
IF EXIST "%PROG_SOURCE%\$PKX" ECHO.%COLOR4%ERROR:%$$% A package is already in session. Delete the $PKX folder before proceeding.&&EXIT /B
FOR %%G in ("%$PACK_FILE%") DO (SET "PKX_NAME=%%~nG%%~xG")
SET "PKX_FOLDER=%PROG_SOURCE%\$PKX"&&MD "%PROG_SOURCE%\$PKX">NUL 2>&1
FOR /F "TOKENS=*" %%□ IN ("%PKX_NAME%") DO (ECHO.Extracting %@@%%%□%$$%...)
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%$PACK_FILE%" /INDEX:1 /APPLYDIR:"%PROG_SOURCE%\$PKX">NUL 2>&1
IF NOT EXIST "%PROG_SOURCE%\$PKX\package.list" ECHO.%COLOR2%ERROR:%$$% Package is either missing package.list or unable to extract.
SET "LIST_FOLDER=%PROG_SOURCE%\$PKX"&&SET "PACK_FOLDER=%PROG_SOURCE%\$PKX"&&SET "CACHE_FOLDER=%PROG_SOURCE%\$PKX"&&IF EXIST "%PROG_SOURCE%\$PKX\package.list" SET "$LIST_FILE=%PROG_SOURCE%\$PKX\package.list"&&CALL:LIST_EXEC
CD /D "%PROG_FOLDER%">NUL
FOR %%a in ($PACK_FILE PKX_FOLDER PKX_NAME) DO (SET "%%a=")
IF EXIST "%PROG_SOURCE%\$PKX" SET "FOLDER_DEL=%PROG_SOURCE%\$PKX"&&CALL:FOLDER_DEL
IF EXIST "%PROG_SOURCE%\$PKX" ECHO.%COLOR4%ERROR:%$$% Unable to complete package cleanup as the package is still active. Do not spawn commands asynchronously.
IF NOT EXIST "%PROG_SOURCE%\$PKX" CALL:CLEAN
EXIT /B
:CAB_EXEC
IF EXIST "%PROG_SOURCE%\$CAB" ECHO.%COLOR4%ERROR:%$$% A package is already in session. Delete the $CAB folder before proceeding.&&EXIT /B
IF EXIST "%PROG_SOURCE%\$CAB" SET "FOLDER_DEL=%PROG_SOURCE%\$CAB"&&CALL:FOLDER_DEL
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%PACKFULL%") DO (ECHO.Extracting %@@%%%□%$$%...)
MD "%PROG_SOURCE%\$CAB">NUL 2>&1
EXPAND "%EXTPACKAGE%" -F:* "%PROG_SOURCE%\$CAB">NUL 2>&1
SET "$QCLM2$=%PROG_SOURCE%\$CAB"&&CALL:DRVR_INSTALL
IF EXIST "%PROG_SOURCE%\$CAB" SET "FOLDER_DEL=%PROG_SOURCE%\$CAB"&&CALL:FOLDER_DEL
EXIT /B
:APPX_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing AppX %@@%%%□%$$%...)
CALL:IF_LIVE_EXT
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
IF DEFINED APPX_SKIP SET "CAPS_SET=APPX_SKIPX"&&SET "CAPS_VAR=%APPX_SKIP%"&&CALL:CAPS_SET
IF DEFINED APPX_SKIP FOR %%1 in (%APPX_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&GOTO:APPX_END)
FOR /F "TOKENS=1-1* DELIMS=\" %%a IN ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" /F "%$QCLM2$%" 2^>NUL') DO (IF "%%a"=="HKEY_LOCAL_MACHINE" SET "APPX_KEY=%%a\%%b"&&CALL:APPX_NML)
IF NOT DEFINED APPX_KEY FOR /F "TOKENS=1-1* DELIMS=\" %%a IN ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" /F "%$QCLM2$%" 2^>NUL') DO (IF "%%a"=="HKEY_LOCAL_MACHINE" SET "APPX_KEY=%%a\%%b"&&CALL:APPX_IBX)
IF NOT DEFINED APPX_KEY IF NOT DEFINED APPX_DONE FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% AppX %%□ doesn't exist.)
IF DEFINED APPX_KEY IF NOT DEFINED APPX_DONE FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR2%ERROR:%$$% AppX %%□ is a stub or unable to remove.)
:APPX_END
FOR %%a in (APPX_DONE APPX_PATH APPX_VER APPX_KEY) DO (SET "%%a=")
EXIT /B
:APPX_NML
FOR /F "TOKENS=1-9 SKIP=2 DELIMS=\ " %%a in ('%REG% QUERY "%APPX_KEY%" /V Path 2^>NUL') DO (IF "%%a"=="Path" SET "APPX_PATH=%DRVTAR%\Program Files\WindowsApps\%%g")
FOR /F "TOKENS=1-3* DELIMS=_" %%a IN ("%APPX_KEY%") DO (SET "APPX_VER=%%d")
IF DEFINED APPX_PATH IF DEFINED APPX_VER CALL:IF_LIVE_MIX
IF DEFINED APPX_PATH IF DEFINED APPX_VER FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /REMOVE-Provisionedappxpackage /PACKAGENAME:"%$QCLM2$%_%APPX_VER%" 2^>NUL') DO (
IF "%%1"=="The operation completed successfully" SET "APPX_DONE=1"&&IF NOT DEFINED @QUIET ECHO.%COLOR5%%%1.%$$%
IF "%%1"=="The operation completed successfully" IF EXIST "%APPX_PATH%\*" SET "FOLDER_DEL=%APPX_PATH%"&&CALL:FOLDER_DEL)
IF DEFINED APPX_DONE CALL:IF_LIVE_EXT
IF DEFINED APPX_DONE %REG% ADD "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%$QCLM2$%_%APPX_VER%" /f>NUL 2>&1
EXIT /B
:APPX_IBX
CALL:IF_LIVE_EXT
FOR /F "TOKENS=1-9 SKIP=2 DELIMS=\ " %%a in ('%REG% QUERY "%APPX_KEY%" /V Path 2^>NUL') DO (IF "%%a"=="Path" SET "APPX_PATH=%DRVTAR%\Windows\SystemApps\%%f")
FOR /F "TOKENS=1-3* DELIMS=_" %%a IN ("%APPX_KEY%") DO (SET "APPX_VER=%%d")
IF DEFINED APPX_PATH IF DEFINED APPX_VER FOR /F "TOKENS=1 DELIMS=." %%1 in ('%REG% DELETE "%APPX_KEY%" /F 2^>NUL') DO (IF "%%1"=="The operation completed successfully" SET "APPX_DONE=1"&&ECHO. %COLOR5%%%1.%$$%&&IF EXIST "%APPX_PATH%\*" SET "FOLDER_DEL=%APPX_PATH%"&&CALL:FOLDER_DEL&%REG% ADD "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned\%$QCLM2$%_%APPX_VER%" /f>NUL 2>&1)
EXIT /B
:CAPABILITY_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Capability %@@%%%□%$$%...)
CALL:IF_LIVE_MIX
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /REMOVE-CAPABILITY /CAPABILITYNAME:"%$QCLM2$%" 2^>NUL') DO (IF "%%1"=="The operation completed successfully" CALL ECHO.%COLOR5%%%1.%$$%&&EXIT /B)
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Capability %%□ doesn't exist.)
EXIT /B
:COMPONENT_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Component %@@%%%□%$$%...)
CALL:IF_LIVE_EXT
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
IF DEFINED COMP_SKIP SET "CAPS_SET=COMP_SKIPX"&&SET "CAPS_VAR=%COMP_SKIP%"&&CALL:CAPS_SET
IF DEFINED COMP_SKIP FOR %%1 in (%COMP_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&EXIT /B)
SET "X0Z="&&SET "COMP_XNT="&&SET "FNL_XNT="&&FOR /F "TOKENS=1* DELIMS=:~" %%a IN ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /F "%$QCLM2$%" 2^>NUL') DO (IF NOT "%%a"=="" CALL SET /A "COMP_XNT+=1"&&CALL SET /A "FNL_XNT+=1"&&CALL SET "TX1=%%a"&&CALL SET "TX2=%%b"&&CALL:COMP_ITEM2)
EXIT /B
:COMP_ITEM2
IF "%X0Z%"=="%TX1%" EXIT /B
IF "%COMP_XNT%" GTR "1" EXIT /B
IF "%TX1%"=="End of search" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Component %%□ doesn't exist.&&EXIT /B)
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
FOR %%a in (1 2 3 4 5 6 7 8 9) DO (CALL SET "COMP_Z%%a=")
SET "X0Z="&&SET "SUB_XNT="&&SET "COMP_FLAG="&&FOR /F "TOKENS=1* DELIMS=:~" %%1 IN ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /F "%$QCLM2$%" 2^>NUL') DO (IF NOT "%%1"=="" CALL SET /A "SUB_XNT+=1"&&CALL SET "X1=%%1"&&CALL SET "X2=%%2"&&CALL:COMP_DELETE)
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
SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /REMOVE-PACKAGE /PACKAGENAME:"%$QCLM2$%~%X2%" 2^>NUL') DO (SET "DISMSG="&&IF "%%1"=="The operation completed successfully" CALL SET "DISMSG=%%1.")
IF NOT DEFINED DISMSG FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR2%ERROR:%$$% Component %%□ is a stub or unable to remove.)
IF DEFINED DISMSG IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%DISMSG%") DO (ECHO.%COLOR5%%%□%$$%)
EXIT /B
:DRIVER_ITEM
SET "$PASS="&&FOR %%□ IN (INSTALL DELETE) DO (IF "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not INSTALL or DELETE.&&EXIT /B)
IF "%$QCLM1$%:%$QCLM3$%:%$QCLM4$%"=="DRIVER:INSTALL:DX" CALL:DRVR_INSTALL
IF "%$QCLM1$%:%$QCLM3$%:%$QCLM4$%"=="DRIVER:DELETE:DX" CALL:DRVR_REMOVE
EXIT /B
:DRVR_INSTALL
SET "PACK_GOOD=The operation completed successfully"&&SET "PACK_BAD=The operation did not complete successfully"&&CALL:IF_LIVE_MIX
FOR /F "TOKENS=*" %%a in ('DIR/S/B "%$QCLM2$%\*.INF" 2^>NUL') DO (
IF NOT EXIST "%%a\*" FOR %%G in ("%%a") DO (IF NOT DEFINED @QUIET CALL ECHO.Installing %@@%%%~nG.inf%$$%...)
IF NOT EXIST "%%a\*" IF DEFINED LIVE_APPLY SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('pnputil.exe /add-driver "%%a" /install 2^>NUL') DO (IF "%%1"=="Driver package added successfully" CALL SET "DISMSG=%PACK_GOOD%")
IF NOT EXIST "%%a\*" IF NOT DEFINED LIVE_APPLY SET "DISMSG="&&FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /ADD-DRIVER /DRIVER:"%%a" /ForceUnsigned 2^>NUL') DO (IF "%%1"=="%PACK_GOOD%" CALL SET "DISMSG=%PACK_GOOD%")
IF NOT EXIST "%%a\*" IF DEFINED DISMSG IF NOT DEFINED @QUIET ECHO.%COLOR5%%PACK_GOOD%.%$$%
IF NOT EXIST "%%a\*" IF NOT DEFINED DISMSG ECHO.%COLOR2%ERROR:%$$% %PACK_BAD%.)
EXIT /B
:DRVR_REMOVE
SET "FILE_OUTPUT=$DRVR"&&CALL:IF_LIVE_MIX
IF NOT DEFINED DRVR_QRY IF EXIST "$DRVR" DEL /Q /F "$DRVR">NUL 2>&1
FOR /F "TOKENS=1 DELIMS= " %%# in ("%$QCLM3$%") DO (CALL SET "$QCLM3$=%%#")
IF NOT EXIST "$DRVR" IF NOT DEFINED @QUIET ECHO.Getting driver listing...
IF NOT EXIST "$DRVR" SET "DRVR_QRY=1"&&FOR /F "TOKENS=1-9 DELIMS=|" %%a in ('%DISM% /ENGLISH /%APPLY_TARGET% /GET-DRIVERS /FORMAT:TABLE 2^>NUL') DO (FOR /F "TOKENS=1 DELIMS= " %%# in ("%%a") DO (SET "X1=%%#")
FOR /F "TOKENS=1 DELIMS= " %%# in ("%%g") DO (SET "X3=%%#")
FOR /F "TOKENS=1 DELIMS= " %%# in ("%%b") DO (SET "CAPS_SET=X2"&&SET "CAPS_VAR=%%#"&&CALL:CAPS_SET&&CALL:FILE_OUTPUT))
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Driver %@@%%%□%$$%...)
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%$QCLM2$%"&&CALL:CAPS_SET
SET "DISMSG="&&IF EXIST "$DRVR" FOR /F "TOKENS=1-3 DELIMS=%U00%" %%a in ($DRVR) DO (IF NOT DEFINED @QUIET IF "%%b"=="%$QCLM2$%" ECHO.Uninstalling %@@%%%a%$$% v%%c...
IF "%%b"=="%$QCLM2$%" IF DEFINED LIVE_APPLY FOR /F "TOKENS=1 DELIMS=." %%1 in ('PNPUTIL.EXE /DELETE-DRIVER "%%a" /UNINSTALL /FORCE 2^>NUL') DO (IF "%%1"=="Driver package deleted successfully" SET "DISMSG=The operation completed successfully.")
IF "%%b"=="%$QCLM2$%" IF NOT DEFINED LIVE_APPLY FOR /F "TOKENS=1 DELIMS=." %%1 in ('%DISM% /ENGLISH /%APPLY_TARGET% /REMOVE-DRIVER /DRIVER:"%%a" 2^>NUL') DO (IF "%%1"=="The operation completed successfully" SET "DISMSG=%%1."))
IF NOT DEFINED DISMSG FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Driver %%□ doesn't exist.)
IF DEFINED DISMSG IF NOT DEFINED @QUIET ECHO.%COLOR5%%DISMSG%%$$%
EXIT /B
:FILE_OUTPUT
IF "%FILE_OUTPUT%"=="$FEAT" ECHO.%X1%%U00%%X2%>>"$FEAT"
IF "%FILE_OUTPUT%"=="$DRVR" ECHO.%X1%%U00%%X2%%U00%%X3%>>"$DRVR"
EXIT /B
:FEATURE_ITEM
SET "$PASS="&&FOR %%□ IN (ENABLE DISABLE) DO (IF "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not ENABLE or DISABLE.&&EXIT /B)
SET "FILE_OUTPUT=$FEAT"&&CALL:IF_LIVE_MIX
IF NOT DEFINED FEAT_QRY IF EXIST "$FEAT" DEL /Q /F "$FEAT">NUL 2>&1
IF NOT EXIST "$FEAT" IF NOT DEFINED @QUIET ECHO.Getting feature listing...
IF NOT EXIST "$FEAT" SET "FEAT_QRY=1"&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=| " %%a in ('%DISM% /ENGLISH /%APPLY_TARGET% /GET-FEATURES /FORMAT:TABLE 2^>NUL') DO (FOR %%X in (Enabled Disabled) DO (IF "%%b"=="%%X" SET "CAPS_SET=X1"&&SET "CAPS_VAR=%%a"&&SET "X2=%%b"&&CALL:CAPS_SET&&CALL:FILE_OUTPUT))
IF "%$QCLM3$%"=="ENABLE" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (IF NOT DEFINED @QUIET ECHO.Enabling Feature %@@%%%□%$$%... 
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%□"&&CALL:CAPS_SET)
IF "%$QCLM3$%"=="DISABLE" FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (IF NOT DEFINED @QUIET ECHO.Disabling Feature %@@%%%□%$$%...
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%□"&&CALL:CAPS_SET)
SET "FEAT="&&IF EXIST "$FEAT" FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ($FEAT) DO (IF "%%a"=="%$QCLM2$%" SET "FEAT=1"&&SET "X1=%%a"&&SET "X2=%%b")
IF NOT DEFINED FEAT FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Feature %%□ doesn't exist.&&EXIT /B)
IF "%$QCLM3$%"=="ENABLE" IF "%X2%"=="Enabled" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF "%$QCLM3$%"=="ENABLE" IF "%X2%"=="Enabled" EXIT /B
IF "%$QCLM3$%"=="DISABLE" IF "%X2%"=="Disabled" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF "%$QCLM3$%"=="DISABLE" IF "%X2%"=="Disabled" EXIT /B
IF "%$QCLM3$%"=="ENABLE" FOR /F "TOKENS=1 DELIMS=." %%■ in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /ENABLE-FEATURE /FEATURENAME:"%$QCLM2$%" /ALL 2^>NUL') DO (
IF "%%■"=="The operation completed successfully" IF NOT DEFINED @QUIET ECHO.%COLOR5%%%■.%$$%
IF "%%■"=="The operation completed successfully" SET "X2=Enabled"&&CALL:FILE_OUTPUT&&EXIT /B)
IF "%$QCLM3$%"=="DISABLE" FOR /F "TOKENS=1 DELIMS=." %%■ in ('%DISM% /ENGLISH /%APPLY_TARGET% /NORESTART /DISABLE-FEATURE /FEATURENAME:"%$QCLM2$%" /REMOVE 2^>NUL') DO (
IF "%%■"=="The operation completed successfully" IF NOT DEFINED @QUIET ECHO.%COLOR5%%%$.%$$%
IF "%%■"=="The operation completed successfully" SET "X2=Disabled"&&CALL:FILE_OUTPUT&&EXIT /B)
FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Feature %%□ is a stub or unable to change.)
EXIT /B
:SERVICE_ITEM
SET "$PASS="&&FOR %%□ IN (AUTO MANUAL DISABLE DELETE) DO (IF "!$QCLM3$!"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not AUTO, MANUAL, DISABLE, or DELETE.&&EXIT /B
CALL:IF_LIVE_EXT
FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (FOR /F "TOKENS=*" %%■ IN ("%$QCLM2$%") DO (
IF "%%□"=="DELETE" IF NOT DEFINED @QUIET ECHO.Removing Service %@@%%%■%$$%...
IF NOT "%%□"=="DELETE" IF NOT DEFINED @QUIET ECHO.Changing start to %@@%%%□%$$% for Service %@@%%%■%$$%...
SET "CAPS_SET=$QCLM2$"&&SET "CAPS_VAR=%%■"&&CALL:CAPS_SET))
IF DEFINED SVC_SKIP SET "CAPS_SET=SVC_SKIPX"&&SET "CAPS_VAR=%SVC_SKIP%"&&CALL:CAPS_SET
IF DEFINED SVC_SKIP FOR %%1 in (%SVC_SKIPX%) DO (IF "%$QCLM2$%"=="%%1" ECHO.%COLOR4%The operation has been skipped.%$$%&&EXIT /B)
SET "$GO="&&FOR /F "TOKENS=1-3 DELIMS= " %%a IN ('%REG% QUERY "%HIVE_SYSTEM%\ControlSet001\Services\%$QCLM2$%" /V Start 2^>NUL') DO (
IF "%%a"=="Start" SET "$GO=1"
IF "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF "%%c"=="0x2" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF "%%c"=="0x2" EXIT /B
IF "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF "%%c"=="0x3" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF "%%c"=="0x3" EXIT /B
IF "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF "%%c"=="0x4" IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
IF "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF "%%c"=="0x4" EXIT /B)
IF NOT DEFINED $GO FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Service %%□ doesn't exist.&&EXIT /B)
IF "%$QCLM3$%"=="DELETE" SET "$RAS=RATI"&&CALL:RASTI_CREATE
IF NOT "%$QCLM3$%"=="DELETE" SET "$RAS=RAS"&&CALL:RASTI_CREATE
FOR /F "TOKENS=1-3 DELIMS= " %%a IN ('%REG% QUERY "%HIVE_SYSTEM%\ControlSet001\Services\%$QCLM2$%" /V Start 2^>NUL') DO (
IF "%$QCLM3$%"=="AUTO" IF "%%a"=="Start" IF NOT "%%c"=="0x2" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF "%$QCLM3$%"=="MANUAL" IF "%%a"=="Start" IF NOT "%%c"=="0x3" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF "%$QCLM3$%"=="DISABLE" IF "%%a"=="Start" IF NOT "%%c"=="0x4" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B
IF "%$QCLM3$%"=="DELETE" IF "%%a"=="Start" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
EXIT /B
:TASK_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.Removing Task %@@%%%□%$$%...)
CALL:IF_LIVE_EXT
SET "TASKID="&&FOR /F "TOKENS=1-4 DELIMS={} " %%a IN ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /V Id 2^>NUL') DO (IF "%%a"=="Id" SET "TASKID=%%c")
IF NOT DEFINED TASKID FOR /F "TOKENS=*" %%□ IN ("%$QCLM2$%") DO (ECHO.%COLOR4%ERROR:%$$% Task %%□ doesn't exist.&&EXIT /B)
SET "$RAS=RAS"&&CALL:RASTI_CREATE
FOR /F "TOKENS=1 DELIMS= " %%a IN ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%$QCLM2$%" /V Id 2^>NUL') DO (IF "%%a"=="Id" ECHO.%COLOR2%ERROR:%$$% The operation did not complete successfully.&&EXIT /B)
IF NOT DEFINED @QUIET ECHO.%COLOR5%The operation completed successfully.%$$%
EXIT /B
:WINSXS_ITEM
SET "$PASS="&&FOR %%□ IN (DELETE) DO (IF "%$QCLM3$%"=="%%□" SET "$PASS=1")
IF NOT DEFINED $PASS FOR /F "TOKENS=*" %%□ IN ("%$QCLM3$%") DO (ECHO.%COLOR4%ERROR:%$$% !$QCLM1$! column 3 is not DELETE.&&EXIT /B)
IF DEFINED LIVE_APPLY ECHO.%COLOR4%ERROR:%$$% OFFLINE IMAGE ONLY&&EXIT /B
CALL:IF_LIVE_EXT
IF NOT DEFINED SXS_SKIP SET "SXS_SKIP=amd64_microsoft-windows-s..cingstack.resources amd64_microsoft-windows-servicingstack amd64_microsoft.vc80.crt amd64_microsoft.vc90.crt amd64_microsoft.windows.c..-controls.resources amd64_microsoft.windows.common-controls amd64_microsoft.windows.gdiplus x86_microsoft.vc80.crt x86_microsoft.vc90.crt x86_microsoft.windows.c..-controls.resources x86_microsoft.windows.common-controls x86_microsoft.windows.gdiplus"
ECHO.&&ECHO.Removing %@@%WinSxS folder%$$%...&&SET "SUBZ="&&SET "SUBXNT="&&FOR /F "TOKENS=1-2* DELIMS=_" %%a IN ('DIR "%WINTAR%\WinSxS" /A: /B /O:GN') DO (IF NOT "%%a"=="" SET "QUERYX=%%a_%%b"&&SET "SUBX=%%c"&&SET /A "SUBXNT+=1"&&CALL:LATERS_WINSXS)
EXIT /B
:LATERS_WINSXS
IF "%QUERYX%_%SUBX%"=="%SUBZ%" EXIT /B
FOR %%1 in (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) DO (IF %SUBXNT% EQU %%1500 CALL ECHO.WinSxS folder queue item %##%%%1500%$$%...
IF "%SUBXNT%"=="%%1000" CALL ECHO.WinSxS folder queue item %##%%%1000%$$%...)
SET "DNTX="&&FOR %%a in (%SXS_SKIP%) DO (IF "%QUERYX%"=="%%a" SET "DNTX=1")
SET "SUBZ=%QUERYX%_%SUBX%"&&SET "DNTX="&&FOR %%a in (%SXS_SKIP%) DO (IF "%QUERYX%"=="%%a" SET "DNTX=1")
IF NOT DEFINED DNTX (TAKEOWN /F "%WINTAR%\WinSxS\%QUERYX%_%SUBX%" /R /D Y>NUL 2>&1
ICACLS "%WINTAR%\WinSxS\%QUERYX%_%SUBX%" /grant %USERNAME%:F /T>NUL 2>&1
RD /Q /S "\\?\%WINTAR%\WinSxS\%QUERYX%_%SUBX%" >NUL 2>&1) ELSE (ECHO.Keeping %@@%%QUERYX%_%SUBX%%$$%)
EXIT /B
:SCRO_CREATE
CALL:IF_LIVE_EXT
IF "%$QCLM4$%"=="SC" SET "SCRO=SetupComplete"
IF "%$QCLM4$%"=="RO" SET "SCRO=RunOnce"
IF NOT DEFINED %$QCLM4$%_PREPARE SET "%$QCLM4$%_PREPARE=1"&&CALL:SCRO_PREPARE
IF NOT DEFINED @QUIET FOR /F "TOKENS=*" %%□ IN ("!$QCLM2$!") DO (ECHO.Scheduling %@@%%%□%$$% for %@@%%SCRO%%$$%...)
CALL:SCRO_DISPATCH
IF NOT "!$QCLM1$!"=="EXTPACKAGE" GOTO:SCRO_CREATE_SKIP
FOR /F "TOKENS=*" %%░ in ("!$QCLM2$!") DO (
IF EXIST "%PACK_FOLDER%\%%░" IF NOT DEFINED @QUIET ECHO.Copying Package %@@%%%░ for %##%%SCRO%%$$%...
IF EXIST "%PACK_FOLDER%\%%░" COPY /Y "%PACK_FOLDER%\%%░" "%DRVTAR%\$">NUL
IF EXIST "%PACK_FOLDER%\%%░" ECHO.%U00%EXTPACKAGE%U00%%%░%U00%INSTALL%U00%DX%U00%>>"%DRVTAR%\$\%SCRO%.list"
IF NOT EXIST "%PACK_FOLDER%\%%░" ECHO.%COLOR4%ERROR:%$$% %PACK_FOLDER%\%%░ doesn't exist.)
EXIT /B
:SCRO_CREATE_SKIP
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%a in ("!COLUMN0!") DO (ECHO.%U00%%%a%U00%%%b%U00%%%c%U00%DX%U00%>>"%DRVTAR%\$\%SCRO%.list")
EXIT /B
:SCRO_PREPARE
IF NOT EXIST "%DRVTAR%\$" MD "%DRVTAR%\$">NUL 2>&1
COPY /Y "%PROG_FOLDER%\windick.cmd" "%DRVTAR%\$">NUL 2>&1
IF NOT EXIST "%DRVTAR%\$\%SCRO%.LIST" ECHO.MENU-SCRIPT>"%DRVTAR%\$\%SCRO%.list"
IF "%SCRO%"=="RunOnce" %REG% add "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\RunOnce" /v "Runonce" /t REG_EXPAND_SZ /d "%%WINDIR%%\Setup\Scripts\RunOnce.cmd" /f>NUL 2>&1
IF NOT EXIST "%WINTAR%\Setup\Scripts" MD "%WINTAR%\Setup\Scripts">NUL 2>&1
ECHO.%%SYSTEMDRIVE%%\$\windick.cmd -imagemgr -run -list %SCRO%.list -live>"%WINTAR%\Setup\Scripts\%SCRO%.cmd"
ECHO.EXIT 0 >>"%WINTAR%\Setup\Scripts\%SCRO%.cmd"
EXIT /B
:SESSION_CLEAR
SET "SCROXNT="&&CALL:VAR_CLEAR&&FOR %%▓ in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (FOR %%▒ in (SC RO) DO (IF DEFINED SESSION%%▒[%%▓] SET "SESSION%%▒[%%▓]="))
EXIT /B
:SCRO_DISPATCH
FOR %%● in (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99) DO (
IF DEFINED SESSION%$QCLM4$%[%%●] ECHO.!SESSION%$QCLM4$%[%%●]!>>"%DRVTAR%\$\%SCRO%.list"
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
SET "$HEADERS=                            %U13% List Builder%U01% %U01%                            Select an option"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %U13% Miscellaneous"&&SET "$FOLDFILT=%LIST_FOLDER%\*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MISCELLANEOUS&GOTO:IMAGEMGR_BUILDER
IF NOT DEFINED SELECT EXIT /B
IF NOT DEFINED $PICK GOTO:IMAGEMGR_BUILDER
SET "$LIST_FILE=%$PICK%"&&CALL:LIST_VIEWER
GOTO:IMAGEMGR_BUILDER
:LIST_COMBINE
IF EXIST "$LIST" FOR /F "TOKENS=1-1* SKIP=1 DELIMS=%U00%" %%a in ($LIST) DO (IF "%%a"=="GROUP" ECHO.>>"%$LIST_FILE%"
ECHO.%U00%%%a%U00%%%b>>"%$LIST_FILE%")
SET "$LIST_FILE="
EXIT /B
:LIST_MAKE
SET "$HEADERS=                            %U13% List Builder%U01% %U01%                            Create new list%U01% %U01% %U01% %U01%                        Enter name of new .LIST%U01% %U01% "&&SET "$SELECT=$LIST_NAME"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR SET "ERROR=LIST_MAKE"&&CALL:DEBUG&&EXIT /B
SET "$CHOICE=%$LIST_NAME%.list"&&ECHO.MENU-SCRIPT>"%LIST_FOLDER%\%$LIST_NAME%.list"
IF EXIST "%LIST_FOLDER%\%$CHOICE%" SET "$PICK=%LIST_FOLDER%\%$CHOICE%"
EXIT /B
:LIST_MISCELLANEOUS
CLS&&SET "IMAGE_LAST=IMAGE"&&CALL:SETS_MAIN&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP
ECHO.                            %U13% List Builder&&ECHO.&&ECHO.                             Miscellaneous&&ECHO.&&ECHO. (%##% 1 %$$%) %U13% Create Source Base&&ECHO. (%##% 2 %$$%) %U08% Generate Example Base&&ECHO. (%##% 3 %$$%) %U13% Convert Group Base&&ECHO. (%##% 4 %$$%) %U10% External Package Item&&ECHO.
SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV
SET "$CHECK=NUMBER_0-4"&&SET "$VERBOSE=1"&&SET "$SELECT=SELECTX"&&CALL:MENU_SELECT
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
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%EXAMPLE-BASE START:%$$%  %DATE%  %TIME%&&ECHO.&&ECHO.&&CALL:BASE_EXAMPLE>"%LIST_FOLDER%\%NEW_NAME%"
ECHO.                   Example base created successfully.&&ECHO.&&ECHO.&&ECHO.            %@@%EXAMPLE-BASE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:LIST_PACK_CREATE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                           %U13% Miscellaneous&&ECHO.&&ECHO.                         External Package Item&&ECHO.&&ECHO.  %@@%AVAILABLE *.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLEs:%$$%&&ECHO.&&SET "$FOLD=%PACK_FOLDER%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST&&ECHO.&&ECHO.                        Multiples OK ( %##%1 2 3%$$% )&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=PATH"&&CALL:MENU_SELECT
IF DEFINED ERROR EXIT /B
IF "%SELECT%"=="0" SET "FILE_TYPE=PACK"&&CALL:BASIC_FILE&EXIT /B
CALL:LIST_TIME
IF NOT DEFINED $BCLM4 EXIT /B
SET "$BCLM1=EXTPACKAGE"&&SET "$BCLM3=INSTALL"&&SET "LIST_START="&&FOR %%a in (%SELECT%) DO (CALL SET "ITEMX=%%$ITEM%%a%%"&&CALL SET "LIST_WRITE=%U00%%%$ITEM%%a%%%U00%"&&CALL:LIST_WRITE)
IF NOT DEFINED LIST_START SET "ERROR=1"&&EXIT /B
SET "$BCLM1="&&SET "$BCLM3="&&SET "$HEADERS=                            %U04% Append Items%U01% %U01%                             Select a list"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) Create new list"&&SET "$FOLDFILT=%LIST_FOLDER%\*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" CALL:LIST_MAKE
IF NOT DEFINED $PICK EXIT /B
SET "$LIST_FILE=%$PICK%"&&CALL:LIST_COMBINE&&CALL:APPEND_SCREEN
EXIT /B
:LIST_WRITE
IF NOT DEFINED ITEMX EXIT /B
IF NOT DEFINED LIST_START SET "LIST_START=1"&&(ECHO.MENU-SCRIPT)>"$LIST"
FOR /F "TOKENS=1-9 DELIMS=%U00%" %%1 IN ("%LIST_WRITE%") DO (CALL ECHO.%U00%EXTPACKAGE%U00%%%1%U00%%$BCLM3%%U00%%$BCLM4%%U00%>>"$LIST")
EXIT /B
:LIST_CONVERT
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                            Create Base-List%U01% %U01%                       Select a list to convert"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) File Operation"&&SET "$FOLDFILT=%LIST_FOLDER%\*.LIST"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=LIST"&&CALL:BASIC_FILE&GOTO:LIST_CONVERT_END
IF DEFINED $PICK SET "$HEAD_CHECK=%$PICK%"&&CALL:GET_HEADER
IF DEFINED ERROR GOTO:LIST_CONVERT_END
::SET "INPUT=%$PICK%"&&CALL:GET_FILEEXT
COPY /Y "%$PICK%" "$TEMP">NUL
IF EXIST "$TEMP" SET "ISGROUP="&&FOR /F "TOKENS=1 SKIP=1 DELIMS=%U00%" %%1 in ($TEMP) DO (IF "%%1"=="GROUP" SET "ISGROUP=1"&&GOTO:LIST_CONVERT_SKIP)
:LIST_CONVERT_SKIP
IF NOT DEFINED ISGROUP ECHO.%COLOR4%ERROR:%$$% List does not contain any groups.&&SET "ERROR=1"&&CALL:PAUSED&GOTO:LIST_CONVERT_END
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                            Create Base-List%U01% %U01% %U01% %U01%                        Enter name of new .BASE%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR GOTO:LIST_CONVERT_END
IF DEFINED ISGROUP MOVE /Y "$TEMP" "%LIST_FOLDER%\%SELECT%.base">NUL
IF DEFINED ISGROUP CALL:APPEND_SCREEN
:LIST_CONVERT_END
SET "$LIST_FILE="&&CALL:CLEAN
EXIT /B
:LIST_DIFFERENCER
SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                             Select base 1"&&SET "$FOLDFILT=%LIST_FOLDER%\*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT DEFINED $PICK EXIT /B
SET "$LIST1=%$PICK%"&&SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                             Select base 2"&&SET "$FOLDFILT=%LIST_FOLDER%\*.BASE"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF NOT DEFINED $PICK EXIT /B
SET "$LIST2=%$PICK%"&&CALL:PAD_SAME
IF "%$LIST1%"=="%$LIST2%" EXIT /B
SET "$HEADERS=                          %U13% Base Difference%U01% %U01%                        Enter name of new list"&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=NEW_NAME"&&CALL:PROMPT_BOX
IF NOT DEFINED NEW_NAME EXIT /B
CALL:PAD_LINE&&ECHO.Differencing %$LIST1% and %$LIST2%...&&CALL:PAD_LINE
COPY /Y "%$LIST1%" "$LIST">NUL
COPY /Y "%$LIST2%" "$TEMP">NUL
ECHO.MENU-SCRIPT>"%LIST_FOLDER%\%NEW_NAME%.list"
SET "XXX1=IF NOT DEFINED $X0$"&&SET "XXX2=%LIST_FOLDER%\%NEW_NAME%.list"
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
SET "$HEADERS=                           %U13% Miscellaneous%U01% %U01%                          Create Source Base%U01% %U01%                   Select a source to generate base"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"&&SET "$FOLDFILT=%IMAGE_FOLDER%\*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
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
SET "INFO_E="&&SET "INFO_V="&&ECHO.MENU-SCRIPT>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR /F "TOKENS=1-9 DELIMS=: " %%a in ('%DISM% /ENGLISH /%APPLY_TARGET% /GET-CURRENTEDITION 2^>NUL') DO (
IF "%%a %%b"=="Image Version" SET "INFO_V=%%c"
IF "%%a %%b"=="Current Edition" IF NOT "%%c"=="is" SET "INFO_E=%%c")
FOR %%a in (INFO_V INFO_E) DO (IF NOT DEFINED %%a SET "%%a=Unavailable")
ECHO.Version:%@@%%INFO_V%%$$% Edition:%@@%%INFO_E%%$$% Source:%@@%%DISP_NAME%%$$%&&ECHO.Version:%INFO_V% Edition:%INFO_E% Source:%DISP_NAME%>>"%LIST_FOLDER%\%NEW_NAME%.base"
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
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
ECHO.&&ECHO. %@@%GETTING APPX LISTING%$$%..&&ECHO.&&SET "$BCLM1=APPX"&&SET "$BCLM3=%U0L%CHOICE0[S]%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕GROUP❕%$BASE_GROUP%❕%U08% AppX❕SCOPED❕Select an option❕DELETE❕VolaTILE❕>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR /F "TOKENS=9* DELIMS=\" %%a in ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
SET "$BCLM3=%U0L%CHOICE0[S]%U0R%"&&FOR /F "TOKENS=9* DELIMS=\" %%a in ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=_" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_FEATURE
ECHO.&&ECHO. %@@%GETTING FEATURE LISTING%$$%..&&ECHO.&&SET "$BCLM1=FEATURE"&&SET "$BCLM3=%U0L%CHOICE0[S]%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕GROUP❕%$BASE_GROUP%❕%U08% Feature❕SCOPED❕Select an option❕ENABLE❗DISABLE❕VolaTILE❕>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR /F "TOKENS=1-9 DELIMS=|: " %%a in ('%DISM% /ENGLISH /%APPLY_TARGET% /GET-FEATURES /FORMAT:TABLE 2^>NUL') DO (
IF "%%b"=="Enabled" SET "$BASE_CHOICE=Default is ENABLE"&&SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE
IF "%%b"=="Disabled" SET "$BASE_CHOICE=Default is DISABLE"&&SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE)
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_COMPONENT
ECHO.&&ECHO. %@@%GETTING COMPONENT LISTING%$$%..&&ECHO.&&SET "$BCLM1=COMPONENT"&&SET "$BCLM3=%U0L%CHOICE0[S]%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕GROUP❕%$BASE_GROUP%❕%U08% Component❕SCOPED❕Select an option❕DELETE❕VolaTILE❕>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR /F "TOKENS=8* DELIMS=\" %%a in ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" 2^>NUL') DO (FOR /F "TOKENS=1-1* DELIMS=~" %%1 in ("%%a") DO (SET "BASE_WRITE=%%1"&&SET "$GROUP_CLM2=%%1"&&CALL:BASE_WRITE))
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_CAPABILITY
ECHO.&&ECHO. %@@%GETTING CAPABILITY LISTING%$$%..&&ECHO.&&SET "$BCLM1=CAPABILITY"&&SET "$BCLM3=%U0L%CHOICE0[S]%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕GROUP❕%$BASE_GROUP%❕%U08% Capability❕SCOPED❕Select an option❕DELETE❕VolaTILE❕>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR /F "TOKENS=1-2 DELIMS=|: " %%a in ('%DISM% /ENGLISH /%APPLY_TARGET% /GET-CAPABILITIES /FORMAT:TABLE 2^>NUL') DO (
IF "%%b"=="Installed" SET "BASE_WRITE=%%a"&&SET "$GROUP_CLM2=%%a"&&CALL:BASE_WRITE)
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_SERVICE
ECHO.&&ECHO. %@@%GETTING SERVICE LISTING%$$%..&&ECHO.&&SET "$BCLM1=SERVICE"&&SET "$BCLM3=%U0L%CHOICE0[S]%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕GROUP❕%$BASE_GROUP%❕%U08% Service❕SCOPED❕Select an option❕AUTO%U01%MANUAL%U01%DISABLE%U01%DELETE❕VolaTILE❕>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR /F "TOKENS=1-4* DELIMS=\" %%a in ('%REG% QUERY "%HIVE_SYSTEM%\ControlSet001\Services" 2^>NUL') DO (FOR /F "TOKENS=1-9 DELIMS= " %%1 in ('%REG% QUERY "%HIVE_SYSTEM%\ControlSet001\Services\%%e" 2^>NUL') DO (SET "BASE_WRITE=%%e"
IF "%%1"=="Start" IF "%%3"=="0x2" SET "$BASE_CHOICE=Default is AUTO"
IF "%%1"=="Start" IF "%%3"=="0x3" SET "$BASE_CHOICE=Default is MANUAL"
IF "%%1"=="Start" IF "%%3"=="0x4" SET "$BASE_CHOICE=Default is DISABLE"
IF "%%1"=="Type" IF "%%3"=="0x10" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x20" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x60" CALL:BASE_WRITE
IF "%%1"=="Type" IF "%%3"=="0x110" CALL:BASE_WRITE))
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_TASK
ECHO.&&ECHO. %@@%GETTING TASK LISTING%$$%..&&ECHO.&&SET "$BCLM1=TASK"&&SET "$BCLM3=%U0L%CHOICE0[S]%U0R%"&&CALL:IF_LIVE_EXT
ECHO.❕GROUP❕%$BASE_GROUP%❕%U08% Task❕SCOPED❕Select an option❕DELETE❕VolaTILE❕>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR /F "TOKENS=1-3* DELIMS= " %%a in ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree" /f ID /e /s 2^>NUL') DO (IF "%%b"=="REG_SZ" IF NOT "%%c"=="" FOR /F "TOKENS=2* DELIMS=\ " %%1 in ('%REG% QUERY "%HIVE_SOFTWARE%\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\%%c" /f PATH /e /s 2^>NUL') DO (IF "%%1"=="REG_SZ" IF NOT "%%2"=="" SET "BASE_WRITE=%%2"&&CALL:BASE_WRITE))
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:GET_BASE_DRIVER
ECHO.&&ECHO. %@@%GETTING DRIVER LISTING%$$%..&&ECHO.&&SET "$BCLM1=DRIVER"&&SET "$BCLM3=%U0L%CHOICE0[S]%U0R%"&&CALL:IF_LIVE_MIX
ECHO.❕GROUP❕%$BASE_GROUP%❕%U08% Driver❕SCOPED❕Select an option❕DELETE❕VolaTILE❕>>"%LIST_FOLDER%\%NEW_NAME%.base"
SET "DRIVER_NAME="&&FOR /F "TOKENS=1-9 SKIP=6 DELIMS=: " %%a in ('%DISM% /ENGLISH /%APPLY_TARGET% /GET-DRIVERS 2^>NUL') DO (
IF "%%a %%b"=="Published Name" SET "DRIVER_INF=%%c"
IF "%%a %%b %%c"=="Original File Name" SET "DRIVER_NAME=%%d"&&SET "BASE_WRITE=%%d"
IF "%%a %%b"=="Class Name" SET "DRIVER_CLS=%%c"
IF "%%a"=="Version" SET "DRIVER_VER=%%b"&&CALL:BASE_WRITE)
IF NOT DEFINED DRIVER_NAME ECHO.No 3rd party drivers installed.
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
ECHO.>>"%LIST_FOLDER%\%NEW_NAME%.base"
FOR %%X IN ($BCLM1 $BCLM3 $BASE_CHOICE BASE_WRITELAST) DO (SET "%%X=")
EXIT /B
:BASE_WRITE
IF DEFINED BASE_WRITE IF DEFINED BASE_WRITELAST IF "%BASE_WRITE%"=="%BASE_WRITELAST%" EXIT /B
SET "BASE_WRITELAST=%BASE_WRITE%"
ECHO.%@@%%$BCLM1%%$$% %BASE_WRITE%%$$%
ECHO.%U00%%$BCLM1%%U00%%BASE_WRITE%%U00%%$BCLM3%%U00%DX%U00%%$BASE_CHOICE%>>"%LIST_FOLDER%\%NEW_NAME%.base"
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
SET VAR_ITEMS=PROMPT0[I] PROMPT1[I] PROMPT2[I] PROMPT3[I] PROMPT4[I] PROMPT5[I] PROMPT6[I] PROMPT7[I] PROMPT8[I] PROMPT9[I] PROMPT0[S] PROMPT1[S] PROMPT2[S] PROMPT3[S] PROMPT4[S] PROMPT5[S] PROMPT6[S] PROMPT7[S] PROMPT8[S] PROMPT9[S] PROMPT0[1] PROMPT1[1] PROMPT2[1] PROMPT3[1] PROMPT4[1] PROMPT5[1] PROMPT6[1] PROMPT7[1] PROMPT8[1] PROMPT9[1] STRING0[I] STRING1[I] STRING2[I] STRING3[I] STRING4[I] STRING5[I] STRING6[I] STRING7[I] STRING8[I] STRING9[I] STRING0[S] STRING1[S] STRING2[S] STRING3[S] STRING4[S] STRING5[S] STRING6[S] STRING7[S] STRING8[S] STRING9[S] STRING0[1] STRING1[1] STRING2[1] STRING3[1] STRING4[1] STRING5[1] STRING6[1] STRING7[1] STRING8[1] STRING9[1] STRING0[2] STRING1[2] STRING2[2] STRING3[2] STRING4[2] STRING5[2] STRING6[2] STRING7[2] STRING8[2] STRING9[2] STRING0[3] STRING1[3] STRING2[3] STRING3[3] STRING4[3] STRING5[3] STRING6[3] STRING7[3] STRING8[3] STRING9[3] STRING0[4] STRING1[4] STRING2[4] STRING3[4] STRING4[4] STRING5[4] STRING6[4] STRING7[4] STRING8[4] STRING9[4] STRING0[5] STRING1[5] STRING2[5] STRING3[5] STRING4[5] STRING5[5] STRING6[5] STRING7[5] STRING8[5] STRING9[5] STRING0[6] STRING1[6] STRING2[6] STRING3[6] STRING4[6] STRING5[6] STRING6[6] STRING7[6] STRING8[6] STRING9[6] STRING0[7] STRING1[7] STRING2[7] STRING3[7] STRING4[7] STRING5[7] STRING6[7] STRING7[7] STRING8[7] STRING9[7] STRING0[8] STRING1[8] STRING2[8] STRING3[8] STRING4[8] STRING5[8] STRING6[8] STRING7[8] STRING8[8] STRING9[8] STRING0[9] STRING1[9] STRING2[9] STRING3[9] STRING4[9] STRING5[9] STRING6[9] STRING7[9] STRING8[9] STRING9[9] PICKER0[I] PICKER1[I] PICKER2[I] PICKER3[I] PICKER4[I] PICKER5[I] PICKER6[I] PICKER7[I] PICKER8[I] PICKER9[I] PICKER0[S] PICKER1[S] PICKER2[S] PICKER3[S] PICKER4[S] PICKER5[S] PICKER6[S] PICKER7[S] PICKER8[S] PICKER9[S] PICKER0[1] PICKER1[1] PICKER2[1] PICKER3[1] PICKER4[1] PICKER5[1] PICKER6[1] PICKER7[1] PICKER8[1] PICKER9[1] CHOICE0[I] CHOICE1[I] CHOICE2[I] CHOICE3[I] CHOICE4[I] CHOICE5[I] CHOICE6[I] CHOICE7[I] CHOICE8[I] CHOICE9[I] CHOICE0[S] CHOICE1[S] CHOICE2[S] CHOICE3[S] CHOICE4[S] CHOICE5[S] CHOICE6[S] CHOICE7[S] CHOICE8[S] CHOICE9[S] CHOICE0[1] CHOICE1[1] CHOICE2[1] CHOICE3[1] CHOICE4[1] CHOICE5[1] CHOICE6[1] CHOICE7[1] CHOICE8[1] CHOICE9[1] CHOICE0[2] CHOICE1[2] CHOICE2[2] CHOICE3[2] CHOICE4[2] CHOICE5[2] CHOICE6[2] CHOICE7[2] CHOICE8[2] CHOICE9[2] CHOICE0[3] CHOICE1[3] CHOICE2[3] CHOICE3[3] CHOICE4[3] CHOICE5[3] CHOICE6[3] CHOICE7[3] CHOICE8[3] CHOICE9[3] CHOICE0[4] CHOICE1[4] CHOICE2[4] CHOICE3[4] CHOICE4[4] CHOICE5[4] CHOICE6[4] CHOICE7[4] CHOICE8[4] CHOICE9[4] CHOICE0[5] CHOICE1[5] CHOICE2[5] CHOICE3[5] CHOICE4[5] CHOICE5[5] CHOICE6[5] CHOICE7[5] CHOICE8[5] CHOICE9[5] CHOICE0[6] CHOICE1[6] CHOICE2[6] CHOICE3[6] CHOICE4[6] CHOICE5[6] CHOICE6[6] CHOICE7[6] CHOICE8[6] CHOICE9[6] CHOICE0[7] CHOICE1[7] CHOICE2[7] CHOICE3[7] CHOICE4[7] CHOICE5[7] CHOICE6[7] CHOICE7[7] CHOICE8[7] CHOICE9[7] CHOICE0[8] CHOICE1[8] CHOICE2[8] CHOICE3[8] CHOICE4[8] CHOICE5[8] CHOICE6[8] CHOICE7[8] CHOICE8[8] CHOICE9[8] CHOICE0[9] CHOICE1[9] CHOICE2[9] CHOICE3[9] CHOICE4[9] CHOICE5[9] CHOICE6[9] CHOICE7[9] CHOICE8[9] CHOICE9[9] CONDIT0[I] CONDIT1[I] CONDIT2[I] CONDIT3[I] CONDIT4[I] CONDIT5[I] CONDIT6[I] CONDIT7[I] CONDIT8[I] CONDIT9[I] CONDIT0[S] CONDIT1[S] CONDIT2[S] CONDIT3[S] CONDIT4[S] CONDIT5[S] CONDIT6[S] CONDIT7[S] CONDIT8[S] CONDIT9[S] CONDIT0[1] CONDIT1[1] CONDIT2[1] CONDIT3[1] CONDIT4[1] CONDIT5[1] CONDIT6[1] CONDIT7[1] CONDIT8[1] CONDIT9[1] CONDIT0[2] CONDIT1[2] CONDIT2[2] CONDIT3[2] CONDIT4[2] CONDIT5[2] CONDIT6[2] CONDIT7[2] CONDIT8[2] CONDIT9[2] CONDIT0[3] CONDIT1[3] CONDIT2[3] CONDIT3[3] CONDIT4[3] CONDIT5[3] CONDIT6[3] CONDIT7[3] CONDIT8[3] CONDIT9[3] CONDIT0[4] CONDIT1[4] CONDIT2[4] CONDIT3[4] CONDIT4[4] CONDIT5[4] CONDIT6[4] CONDIT7[4] CONDIT8[4] CONDIT9[4] CONDIT0[5] CONDIT1[5] CONDIT2[5] CONDIT3[5] CONDIT4[5] CONDIT5[5] CONDIT6[5] CONDIT7[5] CONDIT8[5] CONDIT9[5] CONDIT0[6] CONDIT1[6] CONDIT2[6] CONDIT3[6] CONDIT4[6] CONDIT5[6] CONDIT6[6] CONDIT7[6] CONDIT8[6] CONDIT9[6] CONDIT0[7] CONDIT1[7] CONDIT2[7] CONDIT3[7] CONDIT4[7] CONDIT5[7] CONDIT6[7] CONDIT7[7] CONDIT8[7] CONDIT9[7] CONDIT0[8] CONDIT1[8] CONDIT2[8] CONDIT3[8] CONDIT4[8] CONDIT5[8] CONDIT6[8] CONDIT7[8] CONDIT8[8] CONDIT9[8] CONDIT0[9] CONDIT1[9] CONDIT2[9] CONDIT3[9] CONDIT4[9] CONDIT5[9] CONDIT6[9] CONDIT7[9] CONDIT8[9] CONDIT9[9] ARRAY0[I] ARRAY1[I] ARRAY2[I] ARRAY3[I] ARRAY4[I] ARRAY5[I] ARRAY6[I] ARRAY7[I] ARRAY8[I] ARRAY9[I] ARRAY0[S] ARRAY1[S] ARRAY2[S] ARRAY3[S] ARRAY4[S] ARRAY5[S] ARRAY6[S] ARRAY7[S] ARRAY8[S] ARRAY9[S] ARRAY0[1] ARRAY1[1] ARRAY2[1] ARRAY3[1] ARRAY4[1] ARRAY5[1] ARRAY6[1] ARRAY7[1] ARRAY8[1] ARRAY9[1] ARRAY0[2] ARRAY1[2] ARRAY2[2] ARRAY3[2] ARRAY4[2] ARRAY5[2] ARRAY6[2] ARRAY7[2] ARRAY8[2] ARRAY9[2] ARRAY0[3] ARRAY1[3] ARRAY2[3] ARRAY3[3] ARRAY4[3] ARRAY5[3] ARRAY6[3] ARRAY7[3] ARRAY8[3] ARRAY9[3] ARRAY0[4] ARRAY1[4] ARRAY2[4] ARRAY3[4] ARRAY4[4] ARRAY5[4] ARRAY6[4] ARRAY7[4] ARRAY8[4] ARRAY9[4] ARRAY0[5] ARRAY1[5] ARRAY2[5] ARRAY3[5] ARRAY4[5] ARRAY5[5] ARRAY6[5] ARRAY7[5] ARRAY8[5] ARRAY9[5] ARRAY0[6] ARRAY1[6] ARRAY2[6] ARRAY3[6] ARRAY4[6] ARRAY5[6] ARRAY6[6] ARRAY7[6] ARRAY8[6] ARRAY9[6] ARRAY0[7] ARRAY1[7] ARRAY2[7] ARRAY3[7] ARRAY4[7] ARRAY5[7] ARRAY6[7] ARRAY7[7] ARRAY8[7] ARRAY9[7] ARRAY0[8] ARRAY1[8] ARRAY2[8] ARRAY3[8] ARRAY4[8] ARRAY5[8] ARRAY6[8] ARRAY7[8] ARRAY8[8] ARRAY9[8] ARRAY0[9] ARRAY1[9] ARRAY2[9] ARRAY3[9] ARRAY4[9] ARRAY5[9] ARRAY6[9] ARRAY7[9] ARRAY8[9] ARRAY9[9] MATH0[I] MATH1[I] MATH2[I] MATH3[I] MATH4[I] MATH5[I] MATH6[I] MATH7[I] MATH8[I] MATH9[I] MATH0[S] MATH1[S] MATH2[S] MATH3[S] MATH4[S] MATH5[S] MATH6[S] MATH7[S] MATH8[S] MATH9[S] MATH0[1] MATH1[1] MATH2[1] MATH3[1] MATH4[1] MATH5[1] MATH6[1] MATH7[1] MATH8[1] MATH9[1] ROUTINE0[I] ROUTINE1[I] ROUTINE2[I] ROUTINE3[I] ROUTINE4[I] ROUTINE5[I] ROUTINE6[I] ROUTINE7[I] ROUTINE8[I] ROUTINE9[I] ROUTINE0[S] ROUTINE1[S] ROUTINE2[S] ROUTINE3[S] ROUTINE4[S] ROUTINE5[S] ROUTINE6[S] ROUTINE7[S] ROUTINE8[S] ROUTINE9[S] ROUTINE0[1] ROUTINE1[1] ROUTINE2[1] ROUTINE3[1] ROUTINE4[1] ROUTINE5[1] ROUTINE6[1] ROUTINE7[1] ROUTINE8[1] ROUTINE9[1] ROUTINE0[2] ROUTINE1[2] ROUTINE2[2] ROUTINE3[2] ROUTINE4[2] ROUTINE5[2] ROUTINE6[2] ROUTINE7[2] ROUTINE8[2] ROUTINE9[2] ROUTINE0[3] ROUTINE1[3] ROUTINE2[3] ROUTINE3[3] ROUTINE4[3] ROUTINE5[3] ROUTINE6[3] ROUTINE7[3] ROUTINE8[3] ROUTINE9[3] ROUTINE0[4] ROUTINE1[4] ROUTINE2[4] ROUTINE3[4] ROUTINE4[4] ROUTINE5[4] ROUTINE6[4] ROUTINE7[4] ROUTINE8[4] ROUTINE9[4] ROUTINE0[5] ROUTINE1[5] ROUTINE2[5] ROUTINE3[5] ROUTINE4[5] ROUTINE5[5] ROUTINE6[5] ROUTINE7[5] ROUTINE8[5] ROUTINE9[5] ROUTINE0[6] ROUTINE1[6] ROUTINE2[6] ROUTINE3[6] ROUTINE4[6] ROUTINE5[6] ROUTINE6[6] ROUTINE7[6] ROUTINE8[6] ROUTINE9[6] ROUTINE0[7] ROUTINE1[7] ROUTINE2[7] ROUTINE3[7] ROUTINE4[7] ROUTINE5[7] ROUTINE6[7] ROUTINE7[7] ROUTINE8[7] ROUTINE9[7] ROUTINE0[8] ROUTINE1[8] ROUTINE2[8] ROUTINE3[8] ROUTINE4[8] ROUTINE5[8] ROUTINE6[8] ROUTINE7[8] ROUTINE8[8] ROUTINE9[8] ROUTINE0[9] ROUTINE1[9] ROUTINE2[9] ROUTINE3[9] ROUTINE4[9] ROUTINE5[9] ROUTINE6[9] ROUTINE7[9] ROUTINE8[9] ROUTINE9[9]
EXIT /B
:VAR_CLEAR
IF NOT DEFINED VAR_ITEMS CALL:VAR_ITEMS
FOR %%a in (%VAR_ITEMS%) DO (SET "%%a=")
EXIT /B
:IF_LIVE_EXT
IF DEFINED LIVE_APPLY CALL:MOUNT_INT
IF DEFINED LIVE_APPLY IF NOT DEFINED USER_SID IF "%PROG_MODE%"=="COMMAND" CALL:MOUNT_USR
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_EXT
EXIT /B
:IF_LIVE_MIX
IF DEFINED LIVE_APPLY CALL:MOUNT_INT
IF NOT DEFINED LIVE_APPLY CALL:MOUNT_MIX
EXIT /B
:MOUNT_USR
SET "$GO="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKU\$ALLUSER" /VE 2^>NUL') DO (IF "%%X"=="HKEY_USERS" SET "$GO=1")
IF NOT DEFINED $GO SET "MOUNT="
IF "%MOUNT%"=="USR" EXIT /B
SET "MOUNT=USR"&&SET "HIVE_USER=HKEY_USERS\$ALLUSER"&&SET "USRTAR=%DRVTAR%\Users\Default"
%REG% UNLOAD HKU\$ALLUSER>NUL 2>&1
%REG% LOAD HKU\$ALLUSER "%DRVTAR%\Users\Default\Ntuser.dat">NUL 2>&1
EXIT /B
:MOUNT_INT
FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\$SOFTWARE" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Unmounting external registry hives..)
IF "%MOUNT%"=="INT" EXIT /B
SET "MOUNT=INT"&&SET "HIVE_USER=HKEY_CURRENT_USER"&&SET "HIVE_SOFTWARE=HKEY_LOCAL_MACHINE\SOFTWARE"&&SET "HIVE_SYSTEM=HKEY_LOCAL_MACHINE\SYSTEM"&&SET "APPLY_TARGET=ONLINE"&&SET "DRVTAR=%SYSTEMDRIVE%"&&SET "WINTAR=%WINDIR%"&&SET "USRTAR=%USERPROFILE%"
IF DEFINED USER_SID SET "HIVE_USER=HKEY_USERS\%USER_SID%"
%REG% UNLOAD HKU\$ALLUSER>NUL 2>&1
%REG% UNLOAD HKLM\$SOFTWARE>NUL 2>&1
%REG% UNLOAD HKLM\$SYSTEM>NUL 2>&1
EXIT /B
:MOUNT_EXT
SET "$GO="&&FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\$SOFTWARE" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "$GO=1")
IF NOT DEFINED $GO SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Mounting external registry hives..
IF "%MOUNT%"=="EXT" EXIT /B
SET "MOUNT=EXT"&&SET "HIVE_USER=HKEY_USERS\$ALLUSER"&&SET "HIVE_SOFTWARE=HKEY_LOCAL_MACHINE\$SOFTWARE"&&SET "HIVE_SYSTEM=HKEY_LOCAL_MACHINE\$SYSTEM"&&SET "APPLY_TARGET=IMAGE:%TARGET_PATH%"&&SET "DRVTAR=%TARGET_PATH%"&&SET "WINTAR=%TARGET_PATH%\Windows"&&SET "USRTAR=%TARGET_PATH%\Users\Default"
%REG% UNLOAD HKU\$ALLUSER>NUL 2>&1
%REG% UNLOAD HKLM\$SOFTWARE>NUL 2>&1
%REG% UNLOAD HKLM\$SYSTEM>NUL 2>&1
%REG% LOAD HKU\$ALLUSER "%TARGET_PATH%\Users\Default\Ntuser.dat">NUL 2>&1
%REG% LOAD HKLM\$SOFTWARE "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SOFTWARE">NUL 2>&1
%REG% LOAD HKLM\$SYSTEM "%TARGET_PATH%\WINDOWS\SYSTEM32\Config\SYSTEM">NUL 2>&1
EXIT /B
:MOUNT_MIX
FOR /F "TOKENS=1 DELIMS=\" %%X in ('%REG% QUERY "HKLM\$SOFTWARE" /VE 2^>NUL') DO (IF "%%X"=="HKEY_LOCAL_MACHINE" SET "MOUNT="&&IF "%DEBUG%"=="ENABLED" ECHO.Unmounting external registry hives..)
IF "%MOUNT%"=="MIX" EXIT /B
SET "MOUNT=MIX"&&SET "HIVE_USER=HKEY_CURRENT_USER"&&SET "HIVE_SOFTWARE=HKEY_LOCAL_MACHINE\SOFTWARE"&&SET "HIVE_SYSTEM=HKEY_LOCAL_MACHINE\SYSTEM"&&SET "APPLY_TARGET=IMAGE:%TARGET_PATH%"&&SET "DRVTAR=%TARGET_PATH%"&&SET "WINTAR=%TARGET_PATH%\Windows"&&SET "USRTAR=%TARGET_PATH%\Users\Default"
%REG% UNLOAD HKU\$ALLUSER>NUL 2>&1
%REG% UNLOAD HKLM\$SOFTWARE>NUL 2>&1
%REG% UNLOAD HKLM\$SYSTEM>NUL 2>&1
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:PACKAGE_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "IMAGE_LAST=PACKAGE"&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U05% Image Management&&ECHO.&&ECHO.  %@@%PACKAGE CONTENTS:%$$%&&ECHO.&&SET "$FOLD=%PROG_SOURCE%\project"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U05%PACK%$$%(%##%X%$$%)LIST%U13%     (%##%B%$$%)uild Pack     (%##%E%$$%)dit Pack     (%##%R%$$%)un Pack&&CALL:PAD_LINE
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
SET "$HEADERS=                             Driver Export%U01% %U01%                   Select a source to export drivers"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%Current Environment%$$%"&&SET "$FOLDFILT=%IMAGE_FOLDER%\*.VHDX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
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
IF NOT EXIST "%PROG_SOURCE%\project\driver" MD "%PROG_SOURCE%\project\driver">NUL 2>&1
IF EXIST "%PROG_SOURCE%\project\driver" ECHO.Exporting drivers to %PROG_SOURCE%\project\driver...
IF EXIST "%PROG_SOURCE%\project\driver" %DISM% /ENGLISH /%APPLY_TARGET% /EXPORT-DRIVER /destination:"%PROG_SOURCE%\project\driver"
FOR %%a in (CMD LIST) DO (IF NOT EXIST "%PROG_SOURCE%\project\PACKAGE.%%a" CALL:NEW_PACKAGE%%a)
IF NOT DEFINED LIVE_APPLY CALL:VDISK_DETACH
ECHO.&&ECHO.            %@@%DRIVER-EXPORT END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:PROJ_EDIT
FOR %%a in (package.cmd package.list) DO (IF EXIST "%PROG_SOURCE%\project\%%a" START NOTEPAD.EXE "%PROG_SOURCE%\project\%%a")
EXIT /B
:PROJ_RESTORE
SET "$HEADERS=                          %U05% Package Extract"&&SET "$CHOICEMINO=1"&&SET "$ITEMSTOP= ( %##%0%$$% ) %##%File Operation%$$%"&&SET "$FOLDFILT=%PACK_FOLDER%\*.PKX"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER
IF "%SELECT%"=="0" SET "FILE_TYPE=PKX"&&CALL:BASIC_FILE&EXIT /B
IF NOT DEFINED $PICK EXIT /B
CALL:PROJ_CLEAR
IF DEFINED ERROR EXIT /B
CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.          %@@%PACKAGE RESTORE START:%$$%  %DATE%  %TIME%
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%$PICK%" /INDEX:1 /APPLYDIR:"%PROG_SOURCE%\project"
IF NOT EXIST "%PROG_SOURCE%\project\package.list" ECHO.%COLOR2%ERROR:%$$% Package is either missing package.list or unable to extract.&&RD /S /Q "%PROG_SOURCE%\project">NUL 2>&1
ECHO.&&ECHO.           %@@%PACKAGE RESTORE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED
EXIT /B
:PROJ_CREATE
IF NOT EXIST "%PROG_SOURCE%\project\*" ECHO.&&ECHO.%COLOR4%ERROR:%$$% Package folder is empty.&&ECHO.&IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
IF NOT EXIST "%PROG_SOURCE%\project\*" EXIT /B
SET "$HEADERS=                           %U05% Pack Builder%U01% %U01%                        Capture Project Folder%U01% %U01% %U01% %U01%                      Enter new .PKX package name%U01% %U01% "&&SET "$CHECK=PATH"&&SET "$VERBOSE=1"&&SET "$SELECT=PACKNAME"&&CALL:PROMPT_BOX
IF NOT DEFINED PACKNAME EXIT /B
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%PACKAGE CREATE START:%$$%  %DATE%  %TIME%
%DISM% /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"%PROG_SOURCE%\project" /IMAGEFILE:"%PACK_FOLDER%\%PACKNAME%.pkx" /COMPRESS:%COMPRESS% /NAME:"PKX" /CheckIntegrity /Verify
ECHO.&&ECHO.            %@@%PACKAGE CREATE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:PROJ_NEW
IF NOT "%PROG_MODE%"=="COMMAND" CLS
SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.           %@@%PACK-TEMPLATE START:%$$%  %DATE%  %TIME%&&ECHO.&&ECHO.
CALL:PROJ_CLEAR
IF DEFINED ERROR EXIT /B
IF NOT EXIST "%PROG_SOURCE%\project\driver" MD "%PROG_SOURCE%\project\driver">NUL 2>&1
CALL:NEW_PACKAGELIST&CALL:NEW_PACKAGECMD
ECHO.               New package template created successfully.&&ECHO.&&ECHO.&&ECHO.            %@@%PACK-TEMPLATE END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP
IF NOT "%PROG_MODE%"=="COMMAND" CALL:PAUSED
EXIT /B
:NEW_PACKAGELIST
SET "PKX_FOLDER="
SET "PKX_FOLDER=%PKX_FOLDER%"&&(ECHO.MENU-SCRIPT&&ECHO.&&ECHO.Delete the driver list entry below and driver folder if there aren't drivers included in the package.&&ECHO.%U00%DRIVER%U00%"%%PKX_FOLDER%%\driver"%U00%INSTALL%U00%DX%U00%&&ECHO.&&ECHO.Delete the command list entry below and package.cmd if a script is not needed.&&ECHO.%U00%COMMAND%U00%%CMD% /C "%%PKX_FOLDER%%\package.cmd"%U00%NORMAL%U00%DX%U00%&&ECHO.&&ECHO.Manually add, copy and paste items, or replace this package.list with an existing execution list.&&ECHO.Copy any listed items such as scripts, installers, appx, cab, and msu packages into the project folder before package creation.)>"%PROG_SOURCE%\project\package.list"
EXIT /B
:NEW_PACKAGECMD
SET "PKX_FOLDER="
SET "PKX_FOLDER=%PKX_FOLDER%"&&(ECHO.::================================================&&ECHO.::These variables are built in and can help&&ECHO.::keep a script consistant throughout the entire&&ECHO.::process, whether applying to a vhdx or live.&&ECHO.::Add any files to package folder before creating.&&ECHO.::================================================&&ECHO.::Windows folder :    %%WINTAR%%&&ECHO.::Drive root :        %%DRVTAR%%&&ECHO.::User or defuser :   %%USRTAR%%&&ECHO.::HKLM\SOFTWARE :     %%HIVE_SOFTWARE%%&&ECHO.::HKLM\SYSTEM :       %%HIVE_SYSTEM%%&&ECHO.::HKCU or defuser :   %%HIVE_USER%%&&ECHO.::DISM target :       %%APPLY_TARGET%%&&ECHO.::==================START OF PACK=================&&ECHO.&&ECHO.@ECHO OFF&&ECHO.REM "%%PKX_FOLDER%%\example.msi" /quiet /noprompt&&ECHO.&&ECHO.::===================END OF PACK==================)>"%PROG_SOURCE%\project\package.cmd"
EXIT /B
:PROJ_CLEAR
IF DEFINED MENU_SKIP GOTO:PROJ_CLEAR_SKIP
SET "$HEADERS= %U01% %U01% %U01% %U01%         Project folder will be cleared. Press (%##%X%$$%) to proceed%U01% %U01% %U01% "&&SET "$CASE=UPPER"&&SET "$SELECT=CONFIRM"&&SET "$CHECK=LETTER"&&CALL:PROMPT_BOX
IF NOT "%CONFIRM%"=="X" SET "ERROR=PROJ_CLEAR"&&CALL:DEBUG&&EXIT /B
:PROJ_CLEAR_SKIP
IF EXIST "%PROG_SOURCE%\project" SET "FOLDER_DEL=%PROG_SOURCE%\project"&&CALL:FOLDER_DEL
IF NOT EXIST "%PROG_SOURCE%\project" MD "%PROG_SOURCE%\project">NUL 2>&1
EXIT /B
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
:FILE_MANAGEMENT
::▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶MENU◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
@ECHO OFF&&CLS&&SET "MISC_LAST=FILE"&&CALL:SETS_HANDLER&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Management&&ECHO.
IF NOT DEFINED FMGR_DUAL SET "FMGR_DUAL=DISABLED"
IF NOT DEFINED FMGR_SOURCE SET "FMGR_SOURCE=%PROG_SOURCE%"&&SET "FMGR_TARGET=%PROG_SOURCE%"
IF NOT EXIST "%FMGR_SOURCE%\*" SET "FMGR_SOURCE=%PROG_SOURCE%"&&SET "FMGR_TARGET=%PROG_SOURCE%"
IF "%FMGR_DUAL%"=="ENABLED" ECHO.                           %@@%SOURCE%$$% (%##%S%$$%) %@@%TARGET%$$%&&ECHO.&&ECHO.  %@@%TARGET FOLDER:%$$% %FMGR_TARGET%&&ECHO.&&SET "$FOLD=%FMGR_TARGET%"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.
ECHO.  %@@%SOURCE FOLDER:%$$% %FMGR_SOURCE%&&ECHO.&&ECHO.  (%##%..%$$%)&&SET "$FOLD=%FMGR_SOURCE%"&&SET "$FILT=*.*"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE
ECHO. %@@%%U02%FILE%$$%(%##%X%$$%)DISK%U04% (%##%.%$$%) (%##%N%$$%)ew (%##%O%$$%)pen (%##%C%$$%)opy (%##%M%$$%)ove (%##%R%$$%)en (%##%D%$$%)el (%##%#%$$%)Own (%##%V%$$%)&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED HOST_ERROR GOTO:MAIN_MENU
IF NOT DEFINED SELECT GOTO:MAIN_MENU
IF "%SELECT%"=="S" CALL:FMGR_SWAP&SET "SELECT="
IF "%SELECT%"=="X" IF NOT DEFINED DISCLAIMER CALL:DISCLAIMER
IF "%SELECT%"=="X" IF DEFINED DISCLAIMER GOTO:DISK_MANAGEMENT
IF "%SELECT%"=="N" CALL:FMGR_NEW&SET "SELECT="
IF "%SELECT%"=="." CALL:FMGR_EXPLORE&SET "SELECT="
IF "%SELECT%"=="C" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Copy"&&SET "$FOLDFILT=%FMGR_SOURCE%\*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_COPY&SET "SELECT="
IF "%SELECT%"=="O" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Open"&&SET "$FOLDFILT=%FMGR_SOURCE%\*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_OPEN&SET "SELECT="
IF "%SELECT%"=="M" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                 Move"&&SET "$FOLDFILT=%FMGR_SOURCE%\*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_MOVE&SET "SELECT="
IF "%SELECT%"=="R" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Rename"&&SET "$FOLDFILT=%FMGR_SOURCE%\*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_REN&SET "SELECT="
IF "%SELECT%"=="#" SET "$HEADERS=                          %U02% File Management%U01% %U01%                            Take Ownership"&&SET "$FOLDFILT=%FMGR_SOURCE%\*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_OWN&SET "SELECT="
IF "%SELECT%"=="D" SET "$HEADERS=                          %U02% File Management%U01% %U01%                                Delete"&&SET "$FOLDFILT=%FMGR_SOURCE%\*.*"&&SET "$VERBOSE=1"&&CALL:FILE_VIEWER&CALL:FMGR_DEL&SET "SELECT="
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
FOR %%X in (WIM VHDX ISO) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
FOR %%X in (LIST BASE) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%LIST_FOLDER%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
FOR %%X in (CAB MSU PKX APPX APPXBUNDLE MSIXBUNDLE) DO (IF "%%X"=="%FILE_TYPE%" ECHO.  %@@%AVAILABLE %%Xs:%$$%&&ECHO.&&SET "$FOLD=%PACK_FOLDER%"&&SET "$FILT=*.%%X"&&CALL:FILE_LIST)
IF "%FILE_TYPE%"=="WALL" ECHO.  %@@%AVAILABLE JPGs/PNGs:%$$%&&ECHO.&&SET "$FOLD=%CACHE_FOLDER%"&&SET "$FILT=*.JPG *.PNG"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="MAIN" ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%PROG_SOURCE%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="IMAGE" ECHO.  %@@%AVAILABLE WIMs/VHDXs:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.WIM *.VHDX"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="LISTS" ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%LIST_FOLDER%"&&SET "$FILT=*.LIST *.BASE"&&CALL:FILE_LIST
IF "%FILE_TYPE%"=="PACK" ECHO.  %@@%AVAILABLE PACKAGEs:%$$%&&ECHO.&&SET "$FOLD=%PACK_FOLDER%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST
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
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                       Move VHDX between folders&&ECHO.&&ECHO.  %@@%IMAGE FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&ECHO.                               ( %##%-%$$% / %##%+%$$% )&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%PROG_SOURCE%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF NOT DEFINED SELECT EXIT /B
IF "%SELECT%"=="-" CALL:MOVE2IMAGE
IF "%SELECT%"=="+" CALL:MOVE2MAIN
GOTO:VHDX_MOVE
:MOVE2IMAGE
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                         Move to image folder&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%PROG_SOURCE%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%IMAGE_FOLDER%\%$CHOICE%" CALL:PAD_LINE&&ECHO. File already exists in IMAGE folder. Press (%##%X%$$%) to overwrite %@@%%$CHOICE%%$$%.&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&SET "$SELECT=CONFIRM"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%IMAGE_FOLDER%\%$CHOICE%" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED $PICK MOVE /Y "%$PICK%" "%IMAGE_FOLDER%\">NUL
EXIT /B
:MOVE2MAIN
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U02% File Operation&&ECHO.&&ECHO.                          Move to main folder&&ECHO.&&ECHO.  %@@%IMAGE FOLDER VHDXs:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%PROG_SOURCE%\%$CHOICE%" CALL:PAD_LINE&&ECHO. File already exists in MAIN folder. Press (%##%X%$$%) to overwrite %@@%%$CHOICE%%$$%.&&CALL:PAD_LINE&&CALL:PAD_PREV&&CALL SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF DEFINED $PICK IF EXIST "%PROG_SOURCE%\%$CHOICE%" IF NOT "%CONFIRM%"=="X" EXIT /B
IF DEFINED $PICK MOVE /Y "%$PICK%" "%PROG_SOURCE%\">NUL
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
IF "%SELECT%"=="." CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.  %@@%AVAILABLE ISOs:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.ISO"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT&&CALL:ISO_MOUNT&SET "SELECT="
IF "%SELECT%"=="V" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT&&CALL:VHDX_MOUNT&SET "SELECT="
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
IF EXIST "%IMAGE_FOLDER%\%VHDX_NAME%" SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG&&SET "VHDX_NAME="&&ECHO.&&ECHO.ERROR&&EXIT /B
SET "$HEADERS=                          %U04% Disk Management%U01% %U01% %U01% %U01%                       Enter new VHDX size in GB%U01% %U01% %U01% %U01%                 Note: 25GB or greater is recommended"&&SET "$SELECT=SELECTX"&&SET "$CHECK=NUMBER_1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF DEFINED ERROR EXIT /B
IF %SELECTX% LSS 1 SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF %SELECTX% GTR 9999 SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF NOT DEFINED ERROR IF %SELECTX% LSS 25 CALL:CONFIRM
IF NOT DEFINED ERROR IF %SELECTX% LSS 25 IF NOT "%CONFIRM%"=="X" SET "ERROR=VHDX_NEW_PROMPT"&&CALL:DEBUG
IF NOT DEFINED ERROR SET "VHDX_SIZE=%SELECTX%"
IF DEFINED ERROR EXIT /B
SET "$VDISK_FILE=%IMAGE_FOLDER%\%VHDX_NAME%"&&SET "VDISK_LTR=ANY"&&CALL:VDISK_CREATE
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
ECHO.Copying %@@%boot.sav%$$%...&&COPY /Y "%EFI_LETTER%:\$.WIM" "%CACHE_FOLDER%\boot.sav">NUL 2>&1
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
ECHO.Mounting vdisk %VHDX_123% letter %VDISK_LTR%...&&SET "VHDX_123="
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
ECHO.Mounting vdisk %VHDX_123% letter %VDISK_LTR%...
:VDISK_RETRY
(ECHO.Select vdisk file="%$VDISK_FILE%"&&ECHO.attach vdisk&&ECHO.list vdisk&&ECHO.Exit)>"$DISK"
IF NOT EXIST "%VDISK_LTR%:\" IF NOT DEFINED VRETRY CALL:VDISK_DETACH>NUL 2>&1
IF NOT EXIST "%VDISK_LTR%:\" IF NOT DEFINED VRETRY SET "VRETRY=1"&&GOTO:VDISK_RETRY
FOR /F "TOKENS=1-8* DELIMS=* " %%a IN ('DISKPART /s "$DISK"') DO (SET "DISK_NUM="&&IF "%%a"=="VDisk" IF EXIST "%%i" SET "DISK_NUM=%%d"&&SET "CAPS_SET=VDISK_QRY"&&SET "CAPS_VAR=%%i"&&CALL:CAPS_SET&&CALL:VDISK_CAPS)
SET "VRETRY="&&SET "VHDX_123="&&SET "VDISK_PART="&&SET "VDISK_QRY="&&SET "DISK_NUM="&&IF EXIST "$DISK" DEL /Q /F "$DISK">NUL 2>&1
EXIT /B
:VDISK_CAPS
SET "CAPS_SET=VDISK"&&SET "CAPS_VAR=%$VDISK_FILE%"&&CALL:CAPS_SET
IF NOT "%VDISK_QRY%"=="%$VDISK_FILE%" EXIT /B
(ECHO.select disk %DISK_NUM%&&ECHO.list partition&&ECHO.Exit)>"$DISK"&&FOR /F "TOKENS=1-8* DELIMS=* " %%1 IN ('DISKPART /s "$DISK"') DO (IF "%%1"=="Partition" IF NOT "%%2"=="" IF NOT "%%2"=="###" SET "VDISK_PART=%%2")
IF DEFINED VDISK_PART (ECHO.Select vdisk file="%$VDISK_FILE%"&&ECHO.select partition %VDISK_PART%&&ECHO.assign letter=%VDISK_LTR% noerr&&ECHO.Exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
EXIT /B
:VDISK_DETACH
IF NOT DEFINED $VDISK_FILE EXIT /B
FOR %%G in ("%$VDISK_FILE%") DO (SET "VHDX_123=%%~nG%%~xG")
ECHO.Unmounting vdisk %VHDX_123% letter %VDISK_LTR%...&&SET "VHDX_123="
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
ECHO.Hiding the vhdx host partition...&&SET /P DISK_TARGET=<"%PROG_FOLDER%\HOST_TARGET"&&CALL:DISK_DETECT>NUL 2>&1
IF NOT DEFINED DISK_DETECT EXIT /B
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&SET "LETT_X=Z"&&CALL:PART_REMOVE&&SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&CALL:PART_4000
EXIT /B
:HOST_AUTO
SET "HOST_ERROR="&&IF NOT DEFINED ARBIT_FLAG CLS&&ECHO.Querying disks...
IF EXIST "Z:\" (ECHO.select volume Z&&ECHO.remove letter=Z noerr&&ECHO.exit)>"$DISK"&&DISKPART /s "$DISK">NUL 2>&1
IF EXIST "%PROG_FOLDER%\HOST_FOLDER" SET /P HOST_FOLDERX=<"%PROG_FOLDER%\HOST_FOLDER"
IF NOT DEFINED HOST_FOLDERX SET "HOST_FOLDERX=$"
SET /P HOST_TARGET=<"%PROG_FOLDER%\HOST_TARGET"
SET "DISK_TARGET=%HOST_TARGET%"
IF DEFINED ARBIT_FLAG CALL:DISK_DETECT>NUL 2>&1
IF NOT DEFINED ARBIT_FLAG SET "QUERY_X=1"&&CALL:DISK_DETECT
SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&CALL:PART_8000&&SET "DISK_X=%DISK_DETECT%"&&SET "PART_X=2"&&SET "LETT_X=Z"&&CALL:PART_ASSIGN
IF EXIST "Z:\" IF NOT EXIST "Z:\%HOST_FOLDERX%" MD "Z:\%HOST_FOLDERX%">NUL 2>&1
IF EXIST "Z:\%HOST_FOLDERX%" IF NOT EXIST "Z:\%HOST_FOLDERX%\windick.cmd" COPY /Y "%PROG_FOLDER%\windick.cmd" "Z:\%HOST_FOLDERX%">NUL 2>&1
IF EXIST "Z:\%HOST_FOLDERX%\windick.ini" COPY /Y "Z:\%HOST_FOLDERX%\windick.ini" "%PROG_FOLDER%">NUL 2>&1
IF NOT DEFINED SETS_LOAD IF EXIST "%PROG_FOLDER%\SETTINGS_INI" COPY /Y "%PROG_FOLDER%\SETTINGS_INI" "%PROG_FOLDER%\windick.ini">NUL 2>&1
IF NOT EXIST "Z:\%HOST_FOLDERX%" IF NOT DEFINED ARBIT_FLAG SET "ARBIT_FLAG=1"&&GOTO:HOST_AUTO
SET "ARBIT_FLAG="&&IF EXIST "Z:\%HOST_FOLDERX%" SET "PROG_SOURCE=Z:\%HOST_FOLDERX%"&&SET "HOST_NUMBER=%DISK_DETECT%"
IF NOT DEFINED DISK_DETECT SET "HOST_ERROR=1"&&SET "DISK_TARGET="
EXIT /B
:EFI_MOUNT
IF NOT DEFINED DISK_TARGET SET "EFI_LETTER="&&EXIT /B
SET "$GET=EFI_LETTER"&&CALL:LETTER_ANY
SET /P HOST_TARGET=<"%PROG_FOLDER%\HOST_TARGET"
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
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%PROG_SOURCE%") DO (SET "PROG_VOLUME=%%G")
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
FOR /F "TOKENS=1 DELIMS=:" %%G in ("%PROG_SOURCE%") DO (SET "PROG_VOLUME=%%G")
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
CLS&&CALL:SETS_HANDLER&&CALL:CLEAN&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                          %U04% BootDisk Creator&&ECHO.&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.VHDX"&&SET "$DISP=BAS"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&ECHO. (%##%O%$$%)ptions                     (%##%C%$$%)reate        (%##%V%$$%)HDX %@@%%VHDX_SLOTX%%$$%&&CALL:PAD_LINE
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
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.&&ECHO. (%##%1%$$%) Package&&ECHO. (%##%2%$$%) List&&CALL ECHO. (%##%3%$$%) Image&&ECHO. (%##%4%$$%) Cache&&ECHO. (%##%5%$$%) Main&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=NUMBER_1-5"&&SET "$SELECT=SELECTX"&&CALL:MENU_SELECT
IF NOT "%SELECTX%"=="1" IF NOT "%SELECTX%"=="2" IF NOT "%SELECTX%"=="3" IF NOT "%SELECTX%"=="4" IF NOT "%SELECTX%"=="5" EXIT /B
CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             %U02% Add File&&ECHO.
IF "%SELECTX%"=="1" SET "ADDFILEZ=pack" ECHO.  %@@%AVAILABLE PACKAGEs:%$$%&&ECHO.&&SET "$FOLD=%PACK_FOLDER%"&&SET "$FILT=*.PKX *.CAB *.MSU *.APPX *.APPXBUNDLE *.MSIXBUNDLE"&&CALL:FILE_LIST
IF "%SELECTX%"=="2" SET "ADDFILEZ=list"&&ECHO.  %@@%AVAILABLE LISTs/BASEs:%$$%&&ECHO.&&SET "$FOLD=%LIST_FOLDER%"&&SET "$FILT=*.LIST *.BASE"&&CALL:FILE_LIST
IF "%SELECTX%"=="3" SET "ADDFILEZ=image"&&ECHO.  %@@%AVAILABLE IMAGEs:%$$%&&ECHO.&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.WIM *.VHDX *.ISO"&&CALL:FILE_LIST
IF "%SELECTX%"=="4" SET "ADDFILEZ=cache"&&ECHO.  %@@%AVAILABLE CACHE FILEs:%$$%&&ECHO.&&SET "$FOLD=%CACHE_FOLDER%"&&SET "$FILT=*.*"&&CALL:FILE_LIST
:ADDFILE_JUMP
IF "%SELECTX%"=="5" SET "ADDFILEZ=main"&&ECHO.  %@@%AVAILABLE MAIN FILEs:%$$%&&ECHO.&&SET "$FOLD=%PROG_SOURCE%"&&SET "$FILT=*.*"&&CALL:FILE_LIST
ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHECK=MENU"&&CALL:MENU_SELECT
IF DEFINED ADDFILEZ IF DEFINED $PICK IF EXIST "%$PICK%" IF NOT EXIST "%$PICK%\*" SET "ADDFILE_%ADDFILEX%=%ADDFILEZ%\%$CHOICE%"
IF DEFINED ADDFILEZ IF NOT DEFINED $PICK SET "ADDFILE_%ADDFILEX%=SELECT"
EXIT /B
:EFI_FETCH
CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.        EFI boot files will be extracted from the boot media.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:CONFIRM
IF NOT "%CONFIRM%"=="X" EXIT /B
CLS&&IF EXIST "%CACHE_FOLDER%\boot.sdi" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.         File boot.sdi already exists. Press (%##%X%$$%) to overwrite&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF EXIST "%CACHE_FOLDER%\boot.sdi" IF NOT "%CONFIRM%"=="X" EXIT /B
IF EXIST "%CACHE_FOLDER%\bootmgfw.efi" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.       File bootmgfw.efi already exists. Press (%##%X%$$%) to overwrite&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$SELECT=CONFIRM"&&SET "$CASE=UPPER"&&SET "$CHECK=LETTER"&&CALL:MENU_SELECT
IF EXIST "%CACHE_FOLDER%\bootmgfw.efi" IF NOT "%CONFIRM%"=="X" EXIT /B
CLS&&SET "$BOX=ST"&&CALL:BOX_DISP&&ECHO.            %@@%EFI EXPORT START:%$$%  %DATE%  %TIME%&&ECHO.&&CALL:VTEMP_CREATE&ECHO.Extracting boot-media. Using boot.sav located in folder...
SET "$IMAGE_X=%CACHE_FOLDER%\boot.sav"&&SET "INDEX_WORD=Setup"&&CALL:GET_WIMINDEX
IF NOT DEFINED INDEX_Z SET "INDEX_Z=1"
%DISM% /ENGLISH /APPLY-IMAGE /IMAGEFILE:"%CACHE_FOLDER%\boot.sav" /INDEX:%INDEX_Z% /APPLYDIR:"%VDISK_LTR%:"&ECHO.&SET "INDEX_Z="
IF EXIST "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" ECHO.File boot.sdi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" "%CACHE_FOLDER%">NUL 2>&1
IF EXIST "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" ECHO.File bootmgfw.efi was found. Copying to folder.&&COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" "%CACHE_FOLDER%">NUL 2>&1
ECHO.&&ECHO.EFI boot files will be used during boot creation when present.&&ECHO.&&CALL:VTEMP_DELETE&&ECHO.&&ECHO.             %@@%EFI EXPORT END:%$$%  %DATE%  %TIME%&&SET "$BOX=SB"&&CALL:BOX_DISP&&CALL:PAUSED
EXIT /B
:BOOT_CREATOR_PROMPT
IF "%PROG_MODE%"=="RAMDISK" IF NOT EXIST "%CACHE_FOLDER%\boot.sav" CALL:BOOT_FETCH
IF NOT EXIST "%CACHE_FOLDER%\boot.sav" CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.&&ECHO.   Import boot media from within image processing before proceeding.&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAUSED&&EXIT /B
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
IF EXIST "%CACHE_FOLDER%\BOOT.SAV" ECHO.Extracting boot-media. Using boot.sav located in folder...&&COPY /Y "%CACHE_FOLDER%\boot.sav" "%PRI_LETTER%:\%HOST_FOLDER%\boot.wim">NUL 2>&1
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
COPY /Y "%PROG_FOLDER%\windick.cmd" "%VDISK_LTR%:\$">NUL&COPY /Y "%PROG_FOLDER%\windick.cmd" "%PRI_LETTER%:\%HOST_FOLDER%">NUL&COPY /Y "%PROG_SOURCE%\windick.ini" "%PRI_LETTER%:\%HOST_FOLDER%">NUL
FOR %%a in (Boot EFI\Boot EFI\Microsoft\Boot) DO (MD %EFI_LETTER%:\%%a>NUL 2>&1)
IF EXIST "%CACHE_FOLDER%\boot.sdi" ECHO.Using boot.sdi located in folder, for efi image boot support.&&COPY /Y "%CACHE_FOLDER%\boot.sdi" "%EFI_LETTER%:\Boot">NUL
IF NOT EXIST "%CACHE_FOLDER%\boot.sdi" COPY /Y "%VDISK_LTR%:\Windows\Boot\DVD\EFI\boot.sdi" "%EFI_LETTER%:\Boot">NUL 2>&1
IF NOT EXIST "%EFI_LETTER%:\Boot\boot.sdi" ECHO.%COLOR2%ERROR:%$$% boot.sdi missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
IF EXIST "%CACHE_FOLDER%\bootmgfw.efi" ECHO.Using bootmgfw.efi located in folder, for the efi bootloader.&&COPY /Y "%CACHE_FOLDER%\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL
IF NOT EXIST "%CACHE_FOLDER%\bootmgfw.efi" COPY /Y "%VDISK_LTR%:\Windows\Boot\EFI\bootmgfw.efi" "%EFI_LETTER%:\EFI\Boot\bootx64.efi">NUL 2>&1
IF NOT EXIST "%EFI_LETTER%:\EFI\Boot\bootx64.efi" ECHO.%COLOR2%ERROR:%$$% bootmgfw.efi missing. Abort.&&SET "ERROR=BOOT_CREATOR_START"&&GOTO:BOOT_CLEANUP
IF DEFINED PE_WALLPAPER IF EXIST "%CACHE_FOLDER%\%PE_WALLPAPER%" (ECHO.Using %PE_WALLPAPER% for the recovery wallpaper.
TAKEOWN /F "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1
ICACLS "%VDISK_LTR%:\Windows\System32\setup.bmp" /grant %USERNAME%:F>NUL 2>&1
COPY /Y "%CACHE_FOLDER%\%PE_WALLPAPER%" "%VDISK_LTR%:\Windows\System32\setup.bmp">NUL 2>&1)
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
IF EXIST "%PROG_SOURCE%\windick.ps1" ECHO.Copying windick.ps1... &&COPY /Y "%PROG_SOURCE%\windick.ps1" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
IF EXIST "%CACHE_FOLDER%\boot.sdi" ECHO.Copying boot.sdi...&&COPY /Y "%CACHE_FOLDER%\boot.sdi" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
IF EXIST "%CACHE_FOLDER%\bootmgfw.efi" ECHO.Copying bootmgfw.efi...&&COPY /Y "%CACHE_FOLDER%\bootmgfw.efi" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
IF DEFINED PE_WALLPAPER IF EXIST "%CACHE_FOLDER%\%PE_WALLPAPER%" ECHO.Copying %PE_WALLPAPER%... &&COPY /Y "%CACHE_FOLDER%\%PE_WALLPAPER%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1
FOR %%a in (0 1 2 3 4 5 6 7 8 9) DO (CALL SET "ADDFILE_CHK=%%ADDFILE_%%a%%"&&CALL:ADDFILE_COPY)
IF DEFINED VHDX_SLOTX IF EXIST "%IMAGE_FOLDER%\%VHDX_SLOTX%" IF EXIST "%PRI_LETTER%:\%HOST_FOLDER%" ECHO.Copying %VHDX_SLOTX%......&&COPY /Y "%IMAGE_FOLDER%\%VHDX_SLOTX%" "%PRI_LETTER%:\%HOST_FOLDER%">NUL 2>&1)
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
IF "%%a"=="pack" SET "PATH_TEMP=%PACK_FOLDER%"&&SET "PATH_FILE=%%b"
IF "%%a"=="list" SET "PATH_TEMP=%LIST_FOLDER%"&&SET "PATH_FILE=%%b"
IF "%%a"=="image" SET "PATH_TEMP=%IMAGE_FOLDER%"&&SET "PATH_FILE=%%b"
IF "%%a"=="cache" SET "PATH_TEMP=%CACHE_FOLDER%"&&SET "PATH_FILE=%%b"
IF "%%a"=="main" SET "PATH_TEMP=%PROG_SOURCE%"&&SET "PATH_FILE=%%b")
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
SET "$HEADERS=                           %U09% Boot Menu Editor%U01% %U01%                  Enter boot menu timeout in seconds"&&SET "$CHECK=NUMBER_1-9999"&&SET "$VERBOSE=1"&&CALL:PROMPT_BOX
IF NOT DEFINED ERROR IF NOT "%SELECT%"=="0" SET "BOOT_TIMEOUT=%SELECT%"
IF DEFINED ERROR SET "BOOT_TIMEOUT="
EXIT /B
:VHDX_CHECK
IF "%$VHDX%"=="X" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                             Boot Creator&&ECHO.&&ECHO.  %@@%AVAILABLE VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) File Operation&&SET "$FOLD=%IMAGE_FOLDER%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHOICEMINO=1"&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
IF "%$VHDX%"=="X" IF "%SELECT%"=="0" SET "FILE_TYPE=VHDX"&&CALL:BASIC_FILE&SET "ERROR=NONE"&&CALL:DEBUG&EXIT /B
IF NOT "%$VHDX%"=="X" CLS&&CALL:PAD_LINE&&SET "$BOX=RT"&&CALL:BOX_DISP&&ECHO.                           Boot Menu Editor&&ECHO.&&ECHO.  %@@%MAIN FOLDER VHDXs:%$$%&&ECHO.&&ECHO. ( %##%0%$$% ) File Operation&&SET "$FOLD=%PROG_SOURCE%"&&SET "$FILT=*.VHDX"&&CALL:FILE_LIST&&ECHO.&&SET "$BOX=RB"&&CALL:BOX_DISP&&CALL:PAD_LINE&&CALL:PAD_PREV&&SET "$CHOICEMINO=1"&&SET "$CHECK=NUMBER"&&CALL:MENU_SELECT
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