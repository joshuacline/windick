$haZZam! A native command shell Windows image deployment tool
- Administrate · Develop · Build · Dismantle · Backup · Test · Customize · Automate
- From boot to deploy, the one and only complete Windows image container-based recovery solution.
- ![Alt text](/png/TripleB1.png "W11 VHDX-Boot Menu")
- Windows-To-Go (USB) / Windows-To-Stay (SSD)
- Create a secure-boot compatible W11 22H2 VHDX-Boot USB
- Tutorial: https://social.technet.microsoft.com/wiki/contents/articles/54560.windows-1011-how-to-implement-a-bootable-windows-pe-recovery-deployment-environment-in-command-shell.aspx
- Feedback: https://www.reddit.com/r/ShaZZam/
- Requirements for deploy-mode (Setup) disk: UEFI bios + any SSD or USB
- Requirements for VHDX-boot disk: UEFI bios + any SSD or premium USB
- Package Creator (.$PK) · Driver · Scripted · Storage · Approve/Deny
- List-Base Extract System (.MST) - Generate list-base from · WIM · VHDX · Live
- List Sorting System (.LST) - Create lists to · Enable · Disable · Add · Delete
-      · AppX · Drivers · Features · Components · Packages · Services · Tasks · Updates
- ![Alt text](/png/ListRun1.png "Applying lists to an image")
- ![Alt text](/png/Debloat1.png "W11 22000")
- No dependencies or external applications, just $haZZam.cmd and Windows installation source
- Mount deploy and administrate virtual hard disk images (VHDX) & WIM's from within recovery or live
- Modify your Windows images as VHDX for instant results. Convert back to WIM when ready to finalize image
- Simplified 2 partition system. EFI / Data only. No MSR, no WinRE, no B.S. - Windows is contained in a single VHDX file
- Customize Windows images with packs/lists. Import/Export Drivers
- All imaging operations occur inside of a virtual hard disk image, leaving no garbage folders or files behind
- Clean-room developed. Evolution of my personal deployment scripts
- ![Alt text](/png/MainMenuInfo.png "MenuInfo")
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
Boot Creator (via Diskpart+DISM)
- Provided with a Windows installation source, you can create a simple yet robust bootable WinPE recovery/testing environment.
- The basic environment is absent of explorer shell, start-menu, or other luxuries.
- However since $haZZam uses live off the land commands, you can survive this outback without 3rd-party apps.
- Easy Boot: Stock configuration. VHDX images are stored on partition 2 of the boot-drive
- Spanning Boot: Create a folder named "$" at the base of any other connected NTFS formatted drive. Place bootable VHDX images in folder
- Virtual hard disk images (slot/0-9.vhdx , name/pre-specified) are detected across NTFS drives during boot and added to the boot-list
- In Name-Mode, 1 VHDX-Boot slot is generated in the BCDSTORE which uses the name of the VHDX for the boot-description.
- In Slot-Mode, the user-specified # of VHDX-Boot slots are generated in the BCDSTORE and are available for use.
- In Slot-Mode, any VHDX's between the specified range (max 0-9.VHDX) located in the home folder are bootable and can be swapped when inactive.
- Pick a middle slot, giving you room to move in either direction.
- ![Alt text](/png/BootCreator.png "Boot Creator")
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
Autopilot (via AutoPilot.cmd)
- Automatically reboot to a customizable scripted recovery environment
- Allows for condition/timed VHDX-backup/restore/swap/testing.
- ![Alt text](/png/AutoPilot.png "AutoPilot")
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
Disk Management (via DiskPart) with basic support for:
-      inspect · format · mount · create · delete · wipe · change UID · lock partition · USB unplug
- Toggle between Recovery & VHDX-Boot
- ![Alt text](/png/DiskManagement.png "Disk Managment")
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
File Management (via CMD's) with basic support for:
-      open · duplicate · copy · rename · move · delete · take ownership+grant perm · symbolic link creation
- ![Alt text](/png/FileManagement.png "File Managment")
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
Image Processing (via DISM)  · Backup · Restore · Convert · Isolate  · for archive or active use, with support for:
-      WIM · VHDX 
- ![Alt text](/png/ImageProcessing.png "Image Processing")
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
Image Management (via DISM)
- Two-way (read/write) parse system. Chuck lists like nobody's business.
- ![Alt text](/png/ImageManagement.png "Image Management")
- Create lists to · Enable · Disable · Add · Delete
-     AppX · Features · Components · Services · Tasks · Updates
- ![Alt text](/png/ListCreator.png "List Creator")
- Generate base-list from a Windows source or live with menu option {*}.
- Appx/Components/Features/Services/Tasks list-base generated from a 22H2 image in notepad:
- ![Alt text](/png/MLB_MST1.png "List-Base Extract")
- Combine multiple actions with a list
- ![Alt text](/png/UnifiedList1.png "Unified-list")
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
Package Creator (via DISM) 
- Create $PK packages · All $PK packages are WIM based, with an additional compartment for the package manifest.
- The package manifest determines how the package is treated. It contains the type of package, and optional install conditions.
- Scripted Packages · integration of REG/MSI/EXE/XYZ
- Driver Packages · export/import with a button.
- Storage - Not the best compression ratio, but the option is there.
- ![Alt text](/png/PackageCreatorDriver.png "Driver Package")
- Create optional $PK package installation conditions. (basic approval/denial)
- For now, the condition system is registry query based only. There is a demo example included.
- ![Alt text](/png/PackageCreatorScripted.png "Scripted Package")
- A few of the built-in package examples to get you started:
-      · Strict LSA Rules · UAC Always · Store/OneDrive/Cloud/Wakelocks/Pagefile Disable ·
-      · User/Admin Account Creation · Import/Export Firewall Rules · Unattend.XML · General MSI/Setup.exe examples
- ![Alt text](/png/PackageCreatorExamples.png "Package Example")
- Package installation timing granularity for different use cases:
- ImageApply        ·  Setup Phase 0  ·  Apply directly to image, no user accounts exist, changes are applied to DefaultUser instead.
- SetupComplete     ·  Setup Phase 1  ·  1st boot, machine credentials, installations not requiring an active user.
- RunOnce·Async     ·  Setup Phase 2  ·  1st user logon, user credentials, installations requiring an active user.
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
Command-line parameters 
-        -help                                                    (This menu)
-        -arg                                                     (1st arg=arguement test. Last arg=exec+test)
-        -imagemgr -install -list name.LST                          (Install package list)
- (Image Processing)
-        -imageproc -wim {x.wim} -index {index} -vhdx {z.vhdx} -size {MB}
-        -imageproc -wim  {x.wim} -index {index} -wim {x.wim} -xlvl {fast/max}
-        -imageproc -vhdx {z.vhdx} -index {index} -wim {x.wim} -xlvl {fast/max}
- Examples:
-        -imageproc -wim x.wim -index 1 -vhdx z.vhdx -size 25600
-        -imageproc -wim x.wim -index 1 -wim x.wim -xlvl fast
-        -imageproc -vhdx z.vhdx -index 1 -wim x.wim -xlvl fast
- (Disk Manager)
- You can address disks by static disk-uid or by disk #, since both are parsed together internally.
-        -diskmgr -list                                           (Condensed list of disks)
-        -diskmgr -getdisk -disk {#} /or/ -diskid {id}            (Query disk # / disk id)
-        -diskmgr -inspect -disk {#} /or/ -diskid {id}            (DiskPart inquiry on specified disk)
-        -diskmgr -erase -disk {#} /or/ -diskid {id}              (Delete All partitions on specified disk)
-        -diskmgr -changeid -disk {#} /or/ -diskid {id} {new id}  (Change disk id of specified disk)
-        -diskmgr -create -disk {#} /or/ -diskid {id} -size {MB}  (Create NTFS partition on specified disk)
-        -diskmgr -format -disk {#} /or/ -diskid {id} -part {#}   (Format partition w/NTFS on specified disk)
-        -diskmgr -delete -disk {#} /or/ -diskid {id} -part {#}   (Delete partition on specified disk)
-        -diskmgr -lock -disk {#} /or/ -diskid {id} -part {#}     (Mark partition GUID as "Do Not Mount")
-        -diskmgr -unmount -letter {ltr}                          (Remove drive letter)
-        -diskmgr -mount -disk {#} /or/ -diskid {id} -part {#} -letter {ltr}    (Assign drive letter + unlock)
- Examples:
-        -diskmgr -create -disk 0 -size 25600
-        -diskmgr -mount -disk 0 -part 1 -letter e
-        -diskmgr -mount -diskid 12345678-1234-1234-1234-123456781234 -part 1 -letter e
- (Boot Environment Creator)
-        -bootmaker -create -disk 0 -src boot.wim -vhdx z.vhdx
-        -bootmaker -create -diskid 12345678-1234-1234-1234-123456781234 -src BootMedia.sav -vhdx z.vhdx
- Boot creator cmdline
- ![Alt text](/png/Cmdline.png "Boot Creator")
#     □□□□□□□□□□□□□□□□□□□□□□□□□□
- Code shot
- ![Alt text](/png/CodeShot.png "Code Shot")

