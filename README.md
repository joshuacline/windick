$haZZam! A native command shell Windows image deployment tool
- Administrate · Develop · Build · Dismantle · Backup · Test · Customize · Automate
- From boot to deploy, the one and only complete Windows image container-based recovery solution.
![Alt text](/png/Triple.png "W11 VHDX-Boot Menu")
- Windows-To-Go (USB) / Windows-To-Stay (SSD)
- Create a secure-boot compatible W11 22H2 VHDX-Boot USB in 5 minutes 
- Tutorial: https://social.technet.microsoft.com/wiki/contents/articles/54560.windows-1011-how-to-implement-a-bootable-windows-pe-recovery-deployment-environment-in-command-shell.aspx
- Feedback: https://www.reddit.com/r/ShaZZam/
- Requirements for deploy-mode (Setup) disk: UEFI bios + any SSD or USB
- Requirements for VHDX-boot disk: UEFI bios + any SSD or premium USB
- Package Creator (.$PK) · Driver · Scripted · Storage · Approve/Deny
- List-Base Extract System (.MST) - Generate list-base from · WIM · VHDX · Live
- Advanced List Sorting System (.LST) - Create lists to · Enable · Disable · Add · Delete
-      · AppX · Drivers · Features · Components · Packages · Services · Tasks · Updates
- No dependencies or external applications, just $haZZam.cmd and Windows installation source
- Mount deploy and administrate virtual hard disk images (VHDX) & WIM's from within recovery or live
- Modify your Windows images as VHDX for instant results. Convert back to WIM when ready to finalize image
- Up to 10 Native VHDX-Boot slots are available in Slot-Mode for redundancy
- Simplified 2 partition system. EFI / Data only. No MSR, no WinRE, no B.S. - Windows is contained in a single VHDX file
- Generate a list of registry startup items, services, tasks, appX, features and components
- Customize Windows images with packs/lists. Import/Export Drivers
- All imaging operations occur inside of a virtual hard disk image, leaving no garbage folders or files behind
- Clean-room developed. Evolution of my personal deployment scripts, 7+ years in the making
- To get started: Place $haZZam.cmd in a folder. Mount a Windows ISO, or insert a windows disc, then open $haZZam.cmd
![Alt text](/png/HelpMenu1.png "HelpMenu")
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
Boot Creator (via Diskpart+DISM)
- Provided with a Windows installation source, $haZZam can create a simple yet robust bootable WinPE recovery/testing environment.
- The basic environment is absent of explorer shell, start-menu, or other luxuries.
- However since $haZZam uses live off the land commands, you can survive this outback without 3rd-party apps.
- All is not lost, there are some handy macros located on the main menu and some basic functionalities to help get by.
- Easy Boot: Stock configuration. VHDX images are stored on partition 2 of the boot-drive
- Spanning Boot: Create a folder named "$" at the base of any other connected NTFS formatted drive. Place bootable VHDX images in folder
- Secure-key Boot: Create a bootable USB disk used as a "boot-key" left in the PC during boot, all other connected drives being non-bootable. Place bootable VHDX images on a seperate drive
- Virtual hard disk images (slot/0-9.vhdx , name/pre-specified) are detected across NTFS drives during boot and added to the boot-list
- In Name-Mode, 1 VHDX-Boot slot is generated in the BCDSTORE which uses the name of the VHDX for the boot-description.
- In Slot-Mode, the user-specified # of VHDX-Boot slots are generated in the BCDSTORE and are available for use.
- In Slot-Mode, any VHDX's between the specified range (max 0-9.VHDX) located in the home folder are bootable and can be swapped when inactive.
- Pick a middle slot, giving you room to move in either direction.
![Alt text](/png/BootCreator1.png "Boot Creator")
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
Autopilot (via AutoPilot.cmd)
- Automatically reboot to a customizable scripted recovery environment
- AutoPilot.cmd must be in the main program folder or the operation will fail. 
- Allows for condition/timed VHDX-backup/restore/swap/testing.
![Alt text](/png/AutoPilot.png "AutoPilot")
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
Disk Managment (via DiskPart) with basic support for:
-      inspect · format · mount · create · delete · wipe · change UID · lock partition · USB unplug
- Toggle between Recovery & VHDX-Boot
![Alt text](/png/DiskMgr1.png "Disk Managment")
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
File Managment (via CMD's) with basic support for:
-      open · duplicate · copy · rename · move · delete · take ownership+grant perm · symbolic link creation
![Alt text](/png/FileMgr1.png "File Managment")
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
Image Processing (via DISM)  · Backup · Restore · Convert · Isolate  · for archive or active use, with support for:
-      WIM · VHDX 
![Alt text](/png/ImageProc1.png "Image Processing")
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
Image Managment (via DISM)
- Two-way (read/write) parse system. Chuck lists like nobody's business.
- Create lists to · Enable · Disable · Add · Delete
-     AppX · Features · Components · Services · Tasks · Updates
![Alt text](/png/ImageMgr1.png "Image Managment")
- Create lists to Install: MSU · CAB · $PK - Apply these lists to : WIM · VHDX · LIVE
![Alt text](/png/ListApply1.png "Apply-Lists")
- Appx/Components/Features/Services/Tasks list-base generated from a 22H2 image viewed in notepad.exe:
![Alt text](/png/MLB_MST.png "List-Base Extract")
- New in 1.1.0.6: List parity between .MST & .LST. Alternatively to create a new .LST, you can copy/paste items directly from the .MST.
- Combine multiple actions with a list-of-lists or stacked-lists
![Alt text](/png/Sandwich.png "Sandwich-list")
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
Package Creator (via DISM) 
- Create $PK packages · All $PK packages are WIM based, with an additional compartment for the package manifest.
- The package manifest determines how the package is treated. It contains the type of package, and optional install conditions.
- Scripted Packages · integration of REG/MSI/EXE/XYZ
- Driver Packages · export/import with a button.
- Storage - Not the best compression ratio, but the option is there.
![Alt text](/png/PackDriver1.png "Package Creator")
- Create optional $PK package installation conditions. (basic approval/denial)
- For now, the condition system is registry query based only. There is a demo example included.
![Alt text](/png/PackScripted1.png "Package Creator")
- A few of the built-in package examples to get you started:
-      · Strict LSA Rules · UAC Always · Store/OneDrive/Cloud/Wakelocks/Pagefile Disable ·
-      · User/Admin Account Creation · Import/Export Firewall Rules · Unattend.XML · General MSI/Setup.exe examples
- Package installation timing granularity for different use cases:
- ImageApply        ·  Setup Phase 0  ·  Apply directly to image, no user accounts exist, changes are applied to DefaultUser instead.
- SetupComplete     ·  Setup Phase 1  ·  1st boot, machine credentials, installations not requiring an active user.
- RunOnce·Async     ·  Setup Phase 2  ·  1st user logon, user credentials, installations requiring an active user.
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
$haZZam command-line parameters 
-     $haZZam.cmd -help                                                    (This Menu)
·         (Image Management List Installer)
-      $haZZam.cmd -listmgr -install -list xyz.lst                         (Live-Install Package-List)
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
·         (Image Processing)
- WIM/VHDX Source Images must be placed in their respective folders or the operation will fail.
-     $haZZam.cmd -imageproc -wim {ABC.WIM} -index {INDEX} -vhdx {123.VHDX} -size {MB}
-     $haZZam.cmd -imageproc -wim  {ABC.WIM} -index {INDEX} -wim {ABC.WIM} -xlvl {FAST/MAX}
-     $haZZam.cmd -imageproc -vhdx {123.VHDX} -index {INDEX} -wim {ABC.WIM} -xlvl {FAST/MAX}
·        Examples:
-     $haZZam.cmd -imageproc -wim ABC.WIM -index 1 -vhdx 123.VHDX -size 25600
-     $haZZam.cmd -imageproc -wim ABC.WIM -index 1 -wim ABC.WIM -xlvl fast
-     $haZZam.cmd -imageproc -vhdx 123.VHDX -index 1 -wim ABC.WIM -xlvl fast
·         (Disk Manager)
- You can address disks by static disk-UID or by DISK #,  since both are parsed together internally.
-     $haZZam.cmd -diskmgr -list                                           (Condensed list of Disks)
-     $haZZam.cmd -diskmgr -getdisk -disk {#} /or/ -diskid {ID}            (Query Disk # / Disk ID)
-     $haZZam.cmd -diskmgr -inspect -disk {#} /or/ -diskid {ID}            (Full DiskPart Inquiry on Specified Disk)
-     $haZZam.cmd -diskmgr -erase -disk {#} /or/ -diskid {ID}              (Delete All Partitions on Specified Disk)
-     $haZZam.cmd -diskmgr -changeid -disk {#} /or/ -diskid {ID} {NEW ID}  (Change Disk ID of Specified Disk)
-     $haZZam.cmd -diskmgr -create -disk {#} /or/ -diskid {ID} -size {MB}  (Create NTFS Partition on Specified Disk)
-     $haZZam.cmd -diskmgr -format -disk {#} /or/ -diskid {ID} -part {#}   (Format Partition w/NTFS on Specified Disk)
-     $haZZam.cmd -diskmgr -delete -disk {#} /or/ -diskid {ID} -part {#}   (Delete Partition on Specified Disk)
-     $haZZam.cmd -diskmgr -lock -disk {#} /or/ -diskid {ID} -part {#}     (Mark Partition GUID as "Do Not Mount")
-     $haZZam.cmd -diskmgr -unmount -letter {LTR}                          (Remove Drive Letter)
-     $haZZam.cmd -diskmgr -mount -disk {#} /or/ -diskid {ID} -part {#} -letter {LTR}    (Assign Drive Letter + unlock)
·        Examples:
-     $haZZam.cmd -diskmgr -create -disk 0 -size 25600
-     $haZZam.cmd -diskmgr -mount -disk 0 -part 1 -letter e
-     $haZZam.cmd -diskmgr -mount -diskid 12345678-1234-1234-1234-123456781234 -part 1 -letter e
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
·         (Boot Environment Creator)
-     The specified boot-media and VHDX must be in the main program folder or the operation will fail.
-     $haZZam.cmd -bootmaker -create -disk 0 -src BOOT.WIM -vhdx 123.VHDX
-     $haZZam.cmd -bootmaker -create -diskid 12345678-1234-1234-1234-123456781234 -src BOOT-MEDIA.SAV -vhdx 123.VHDX
![Alt text](/png/Command1.png "Boot Creator")
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■
- Only download from github.com/joshuacline
