# Windows Deployment Image Customization Kit
A native command shell Windows image deployment tool.

SecureBoot Notice: Yes I'm aware that when bootmgfw_EX.efi located in the EFI_EX folder within boot.wim is used instead of the normal bootmgfw.efi, secureboot has fewer compatibility issues. Currently I am holding out for a move in either direction from Microsoft. If clear direction is not established, then the required changes will be made to begin pulling the bootloader from the alternate EFI_EX folder instead, or possibly choice between the two. There's no use in making changes that may be reverted on a later date. In the meantime, you can manually pull the bootloader from the EFI_EX location, then place into the cache folder, followed by initiating a boot file update within recovery. Additionally, secureboot can be disabled to resume using Windows normally until Microsoft decides which bootloader becomes standardized.

![Alt text](https://raw.githubusercontent.com/joshuacline/documentation/main/windick/png/topbanner.png "topbanner")

[![Download](https://img.shields.io/github/v/release/joshuacline/windick)](https://github.com/joshuacline/windick/archive/refs/heads/main.zip)
# Testimonials
- "It's so much easier than anything I've used before, and that's because I know what I'm doing." -ITPro
- "Never realized those other utilities treated us like complete dummies. Yours' thinks we're genius. Flattering." -Susan
- "Dude it's like Rufus, NTLite, RebootPro, WinUtil, and WinBackup combined, yet even more powerful!" -ComputerLife
- "Now I know who they're competing with. Can't hide it forever, the thing is a total oven." -WindowsGuy
- "It opened my eyes to the state of toolpocalypse. Stupidification isn't synonymous with easier, who knew?." -George
- "You can do literally anything and everything. My experience with similar apps now has me fully dilated for this." -Belim
- "I write code. Been watching the big dawgs poach your updates regularly, and underlying concepts for more than two years...even your slogan. Gross 🤮. Wish there was a way to donate." -MegaManX
- "Edmonton uses it for the groceries, but I'm like 'all rockets on deck tell me what's next.' thanks MenuScript." -Brint
- "Where did all those hoops I've been jumping through go?!" -Carl

# Mirrors
- https://www.majorgeeks.com/files/details/windows_deployment_image_customization_kit.html

- https://www.softpedia.com/get/System/System-Miscellaneous/Windows-Deployment-Image-Customization-Kit.shtml

# Documentation
- https://github.com/joshuacline/documentation/blob/main/windick/readme.md
- https://learn.microsoft.com/en-us/archive/technet-wiki/54560.windows-1011-how-to-implement-a-bootable-windows-pe-recovery-deployment-environment-in-command-shell

- https://youtube.com/@windozedev

![Alt text](https://raw.githubusercontent.com/joshuacline/documentation/main/windick/png/maingui.png "maingui")
![Alt text](https://raw.githubusercontent.com/joshuacline/documentation/main/windick/png/menuscript.jpg "MenuScript")
