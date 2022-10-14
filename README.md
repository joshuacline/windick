#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
#   $-h-@-Z-Z-@-m! 
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· A native command shell Windows image deployment tool.
- Administrate · Develop · Build · Dismantle · Backup · Test · Customize
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· To get started: Place $haZZam.cmd in any folder without spaces in the name. Mount a Windows ISO, or insert a windows disc to get started.
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· Boot Creator (via Diskpart+DISM)
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· Provided with a Windows installation source, $haZZam can create a simple yet robust bootable WinPE recovery/testing environment.
- The basic environment is absent of explorer shell, start-menu, or other luxuries.
- However since $haZZam uses live off the land commands, you can survive this outback without 3rd-party apps.
- All is not lost, there are some handy macros located on the main menu and some basic functionalities to help get by.
- After the boot-media is applied to a drive, 10 VHDX boot slots are generated in the BCDSTORE and are available for use.
- By default VHDX's named between 0-9.VHDX located in the home folder are bootable.
- If you need redundancy I suggest starting with slot 5 first, giving you room to move in either direction.
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· Disk Managment (via DiskPart) with basic support for:
-      inspect · format · mount · create · delete · wipe · change UID · lock partition · USB unplug
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· File Managment (via CMD's) with basic support for:
-      open · duplicate · copy · rename · move · delete · take ownership+grant perm · symbolic link creation
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· Image Processing (via DISM)  · Backup · Restore · Convert · Isolate  · for archive or active use, with support for:
-      WIM · VHDX 
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· Image Managment (via DISM)
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
- Express Image Forensics of:
-      VHDX · WIM · LIVE
- Create lists to · Enable · Disable · Add · Delete
-     Features · Components · Services · Tasks · Updates           
- Create lists to Install:
-      MSU · CAB · $PK
- Apply these batch lists to :
-      WIM · VHDX · LIVE
- A List-of-Lists to combine multiple batch actions
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· Package Creator (via DISM) 
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
- Create $PK packages · All $PK packages are WIM based, with an additional compartment for the package manifest.
- The package manifest determines how the package is treated. It contains the type of package, and optional install conditions.
- Scripted Packages · integration of REG/MSI/EXE/XYZ
- Driver Packages · export/import with a button.
- Storage - Not the best compression ratio, but the option is there.
- Create optional $PK package installation conditions. (basic approval/denial)
- For now, the condition system is registry query based only. There is a demo example included.
- A few of the built-in package examples to get you started:
-      · Strict LSA Rules · UAC Always · Store/OneDrive/Cloud/Wakelocks/Pagefile Disable ·
-      · User/Admin Account Creation · Import/Export Firewall Rules · Unattend.XML · General MSI/Setup.exe examples
· Package installation timing granularity for different use cases:
- ImageApply        ·  Setup Phase 0  ·  Apply directly to image, no user accounts exist, changes are applied to DefaultUser instead.
- SetupComplete     ·  Setup Phase 1  ·  1st boot, machine credentials, installations not requiring an active user.
- RunOnce·Async     ·  Setup Phase 2  ·  1st user logon, user credentials, installations requiring an active user.
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
·    $haZZam command-line parameters 
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
-     $haZZam.cmd -help                                                    (This Menu)
·         (Image Management List Installer)
-      $haZZam.cmd -listmgr -install -list xyz.lst                         (Live-Install Package-List)
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
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
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
·         (Boot Environment Creator)
-     The specified boot-media must be in the main program folder or the operation will fail.
-     $haZZam.cmd -bootmaker -create -disk 0 -src BOOT.WIM
-     $haZZam.cmd -bootmaker -create -diskid 12345678-1234-1234-1234-123456781234 -src BOOT-MEDIA.SAV
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
- Customize with classic ascii themes straight from the 1970's, RGB or even the cha-cha!
- No dependencies, Just $haZZam.cmd.
- Recommended to use windows ISO's build 22000+. Always use official sources, unless you're trying to analyze malware. (vhdx-boot w/host-partition-lock is a great way to do this...)
- Currently $haZZam is made of 100% batch, no embedded scripts of any kind. That mean no embedded:
-      · powershell · visualbasic · java · any type of encoding or obfuscation. 
- This program should always be in its raw and readable form, a .CMD file.  Which can be easily viewed and edited in notepad.
- The possibility exists for malacious entities to modify this program into something truly nightmarish.
- So don't be dumb. Download only from github.com/joshuacline. Or be part of a botnet or worse, that's on you.
#     ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
· I am learning github, please excuse anything incorrect in advance, thanks
