# Windows Deployment Image Customization Kit (c) github.com/joshuacline
[VOID][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[VOID][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[VOID][System.Windows.Forms.Application]::EnableVisualStyles()
[VOID][System.Text.Encoding]::Unicode
Add-Type -MemberDefinition @"
[DllImport("Kernel32.dll")] public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")] public static extern bool SetParent(IntPtr hWndChild, IntPtr hWndNewParent);
[DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
"@ -Name "Win32" -Namespace "API"
$definition = @"
using System;
using System.Runtime.InteropServices;
public class ConsoleFont
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct CONSOLE_FONT_INFOEX
    {
        public uint cbSize;
        public uint nFont;
        public COORD dwFontSize;
        public int FontFamily;
        public int FontWeight;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string FaceName;
    }
    [StructLayout(LayoutKind.Sequential)]
    public struct COORD
    {
        public short X;
        public short Y;
    }
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFOEX lpConsoleCurrentFontEx);
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);
    public const int STD_OUTPUT_HANDLE = -11;
}
"@
Add-Type -TypeDefinition $definition
function NewPanel {param (
[int]$X,
[int]$Y,
[int]$H,
[int]$W,
[int]$C)
$panel = New-Object System.Windows.Forms.Panel
$panel.BackColor = [System.Drawing.Color]::FromArgb($C, $C, $C)
$panel.Location = New-Object Drawing.Point($X, $Y)
$panel.Size = New-Object Drawing.Size($W, $H)
$form.Controls.Add($panel)
return $panel}
function NewRichTextBox {param (
[int]$X,
[int]$Y,
[int]$H,
[int]$W,
[string]$Text)
$richTextBox = New-Object System.Windows.Forms.RichTextBox
$richTextBox.Size = New-Object System.Drawing.Size($W, $H)
$richTextBox.Location = New-Object System.Drawing.Point($X, $Y)
#$richTextBox.Dock = DockStyle.Fill
#$richTextBox.LoadFile("C:\\MyDocument.rtf")
#$richTextBox.Find("Text")
#$richTextBox.SelectionColor = Color.Red
#$richTextBox.SaveFile("C:\\MyDocument.rtf")
$richTextBox.Visible = $true
return $richTextBox}
function NewTextBox {param (
[int]$X,
[int]$Y,
[int]$H,
[int]$W,
[string]$Text)
#$form.Size = New-Object System.Drawing.Size(800, 600)
#$textbox.Bounds = New-Object System.Drawing.Rectangle(10, 10, 760, 540)
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Size = New-Object System.Drawing.Size($W, $H)
$textbox.Location = New-Object System.Drawing.Point($X, $Y)
$textbox.Text = "$Text"
$textbox.Visible = $true
#$textbox.SelectionColor = 'White'
#$textbox.ReadOnly = $true
#$textBox.Multiline = $true
#$textBox.ScrollBars = "Vertical"
#$textBox.Dock = "Fill"
#$textBox.ReadOnly = $true
#$textBox.AppendText = "Option X"
if ($Page -eq 'Page0') {$Page0.Controls.Add($textbox)}
if ($Page -eq 'Page1a') {$Page1a.Controls.Add($textbox)}
if ($Page -eq 'Page1b') {$Page1b.Controls.Add($textbox)}
if ($Page -eq 'Page2') {$Page2.Controls.Add($textbox)}
if ($Page -eq 'Page3') {$Page3.Controls.Add($textbox)}
if ($Page -eq 'Page4') {$Page4.Controls.Add($textbox)}
if ($Page -eq 'Page5') {$Page5.Controls.Add($textbox)}
if ($Page -eq 'Page6') {$Page6.Controls.Add($textbox)}
if ($Page -eq 'PageConsole') {$PageConsole.Controls.Add($textbox)}
return $textbox}
function NewListView {param (
[int]$X,
[int]$Y,
[int]$H,
[int]$W,
[string]$Text)
$listview = New-Object System.Windows.Forms.ListView
$listview.Size = New-Object Drawing.Size($W, $H)
$listview.Location = New-Object Drawing.Point($X, $Y)
$listview.View = "List"
$listview.View = "Details"
$listview.Visible = $true
$listview.MultiSelect = $false
$listview.HideSelection = $true
$listview.Columns.Add("xXx Available:")
#$listview.Columns.Add("Column2:")
$listview.Columns[0].Width = -2
#$listview.Columns[1].Width = -2
#$listview.CheckBoxes = true
#$listview.FullRowSelect = true
#$listview.GridLines = true
#$listview.Sorting = SortOrder.Ascending
#$imageListSmall = New-Object System.Windows.Forms.ImageList
#$listView1.SmallImageList = $imageListSmall
if ($Page -eq 'Page1b') {$Page1b.Controls.Add($listview)}
#Write-Host "Selected Page: $Page"
return $listview}
function PickFolder {
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowserDialog.RootFolder = 'Desktop'
#$FolderBrowserDialog.InitialDirectory = "$Pick"
$FolderBrowserDialog.ShowNewFolderButton = $true
$FolderBrowserDialog.Description = 'Description'
$FolderBrowserDialog.ShowDialog() | Out-Null
$Pick = $FolderBrowserDialog.FileName
Write-Host "Selected file: $Pick"}
#If ([string]::IsNullOrEmpty($InitialDirectory) -eq $False) { $FolderBrowserDialog.SelectedPath = $InitialDirectory }
#If ($FolderBrowserDialog.ShowDialog($MainForm) -eq [System.Windows.Forms.DialogResult]::OK) { $return = $($FolderBrowserDialog.SelectedPath) }
#Try { $FolderBrowserDialog.Dispose() } Catch {}
function PickFolderx {
$shell = New-Object -ComObject Shell.Application
$FolderPicker = $shell.BrowseForFolder(0, "Select a folder:", 0, $null)
$Pick = $FolderPicker.Self.Path
Write-Host "Selected folder: $Pick"}
function PickFile {
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
$OpenFileDialog.InitialDirectory = "$FilePath"
$OpenFileDialog.RestoreDirectory = $true
#$OpenFileDialog.Filter = "Text files (*.txt;*.zip)|*.txt;*.zip"
if ($FileFilt -eq 'wim') {$OpenFileDialog.Filter = "WIM files (*.wim)|*.wim"}
if ($FileFilt -eq 'vhdx') {$OpenFileDialog.Filter = "VHDX files (*.vhdx)|*.vhdx"}
$OpenFileDialog.ShowDialog() | Out-Null
$Pick = $OpenFileDialog.FileName
Write-Host "Selected file: $Pick"}
function ConsoleView {
$command = e:\windick\windick.cmd -diskmgr -list
Foreach ($line in $command) {[void]$ListView.Items.Add($line)}}
function NewDropBox {param (
[int]$X,
[int]$Y,
[int]$H,
[int]$W,
[int]$C,
[string]$Text,
[string]$DisplayMember)
$dropbox = New-Object System.Windows.Forms.ComboBox
$dropbox.Location = New-Object Drawing.Point($X, $Y)
$dropbox.Size = New-Object Drawing.Size($W, $H)
$dropbox.DisplayMember = $DisplayMember
$dropbox.Text = "$Text"
$dropbox.Add_SelectedIndexChanged({
$DropBox1_Page1a.Tag = 'Disable'
$DropBox2_Page1a.Tag = 'Disable'
$DropBox1_Page1b.Tag = 'Disable'
$DropBox2_Page1b.Tag = 'Disable'
$DropBox3_Page1b.Tag = 'Disable'
$this.Tag = 'Enable'
if ($Button1_Main.Tag -eq 'Enable') {if ($DropBox1_Page1a.Tag -eq 'Enable') {$DropBox2_Page1a.Items.Clear()
$ListView1_Page1a.Items.Clear()
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
$command = DISM.EXE /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"$FilePath\$($DropBox1_Page1a.SelectedItem)"
#$files = Get-ChildItemNULL | Select-Object Name, Length, Extension
#Get-ProcessNULL | Select-Object -Property Name, WorkingSet, PeakWorkingSet | Sort-Object -Property WorkingSet -Descending | Out-GridView
#Invoke-CommandNULL -ComputerName S1, S2, S3 -ScriptBlock {Get-Culture} | Out-GridView
Foreach ($line in $command) {
if ($line -match "Index :") {
[void]$ListView1_Page1a.Items.Add($line)
$parts = $line.Split(":", 9)
$column2 = $parts[1].Trim()
[void]$DropBox2_Page1a.Items.Add($column2)}
if ($line -match "Name :") {
$parts = $line.Split(":", 9)
$column1 = $parts[0].Trim()
$column2 = $parts[1].Trim()
#$item = New-Object System.Windows.Forms.ListViewItem
#$item.Text = $file.Name
#$item.SubItems.Add($file.Length)
#$item.SubItems.Add($file.Extension)
#$listView.Items.Add($item)
[void]$ListView1_Page1a.Items.Add($column2)
#Write-Host "$column1 $column2"
}
}
}}
if ($Button_Mode.Tag -eq 'Enable') {if ($DropBox1_Page1b.Tag -eq 'Enable') {$DropBox2_Page1b.Items.Clear()
$ListView1_Page1b.Items.Clear();$DropBox2_Page1b.ResetText()
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
$command = DISM.EXE /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"$FilePath\$($DropBox1_Page1b.SelectedItem)" /INDEX:1
Foreach ($line in $command) {
if ($line -match "Index :") {
[void]$ListView1_Page1b.Items.Add($line)
$parts = $line.Split(":", 9)
$column2 = $parts[1].Trim()
[void]$DropBox2_Page1b.Items.Add($column2)}
if ($line -match "Name :") {
$parts = $line.Split(":", 9)
$column1 = $parts[0].Trim()
$column2 = $parts[1].Trim()
[void]$ListView1_Page1b.Items.Add($column2)
#Write-Host "$column1 $column2"
}
}
}}

})
if ($Page -eq 'Page0') {$Page0.Controls.Add($dropbox)}
if ($Page -eq 'Page1a') {$Page1a.Controls.Add($dropbox)}
if ($Page -eq 'Page1b') {$Page1b.Controls.Add($dropbox)}
if ($Page -eq 'Page2') {$Page2.Controls.Add($dropbox)}
if ($Page -eq 'Page3') {$Page3.Controls.Add($dropbox)}
if ($Page -eq 'Page4') {$Page4.Controls.Add($dropbox)}
if ($Page -eq 'Page5') {$Page5.Controls.Add($dropbox)}
if ($Page -eq 'Page6') {$Page6.Controls.Add($dropbox)}
return $dropbox}
function NewLabel {param (
[int]$X,
[int]$Y,
[int]$H,
[int]$W,
[string]$Text,
[string]$TextSize)
$label = New-Object Windows.Forms.Label
$label.Font = New-Object System.Drawing.Font('Segoe UI', $TextSize, [System.Drawing.FontStyle]::Bold)
$label.ForeColor = 'White'
$label.Location = New-Object Drawing.Point($X, $Y)
$label.Size = New-Object Drawing.Size($W, $H)
$label.Text = $Text
if ($Page -eq 'Page0') {$Page0.Controls.Add($label)}
if ($Page -eq 'Page1a') {$Page1a.Controls.Add($label)}
if ($Page -eq 'Page1b') {$Page1b.Controls.Add($label)}
if ($Page -eq 'Page2') {$Page2.Controls.Add($label)}
if ($Page -eq 'Page3') {$Page3.Controls.Add($label)}
if ($Page -eq 'Page4') {$Page4.Controls.Add($label)}
if ($Page -eq 'Page5') {$Page5.Controls.Add($label)}
if ($Page -eq 'Page6') {$Page6.Controls.Add($label)}
return $label}
function NewButton {param (
[int]$X,
[int]$Y,
[int]$H,
[int]$W,
[string]$Text,
[string]$Hover_Text,
[scriptblock]$Add_Click)
$button = New-Object Windows.Forms.Button
$button.Location = New-Object Drawing.Point($X, $Y)
$button.Size = New-Object Drawing.Size($W, $H)
$button.Add_Click($Add_Click)
$button.Text = $Text
$button.Cursor = 'Hand'
$button.ForeColor = 'White'
$button.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$button.Add_MouseEnter({$this.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)})
$button.Add_MouseLeave({$this.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)})
$hovertext = New-Object System.Windows.Forms.ToolTip
$hovertext.SetToolTip($button, $Hover_Text)
if ($Page -eq 'Page0') {$Page0.Controls.Add($button)}
if ($Page -eq 'Page1a') {$Page1a.Controls.Add($button)}
if ($Page -eq 'Page1b') {$Page1b.Controls.Add($button)}
if ($Page -eq 'Page2') {$Page2.Controls.Add($button)}
if ($Page -eq 'Page3') {$Page3.Controls.Add($button)}
if ($Page -eq 'Page4') {$Page4.Controls.Add($button)}
if ($Page -eq 'Page5') {$Page5.Controls.Add($button)}
if ($Page -eq 'Page6') {$Page6.Controls.Add($button)}
if ($Page -eq 'PageConsole') {$PageConsole.Controls.Add($button)}
if ($Page -eq 'PageConsoleX') {$PageConsoleX.Controls.Add($button)}
return $button}
function NewPageButton {param (
[int]$X,
[int]$Y,
[int]$H,
[int]$W,
[string]$Text)
$button = New-Object Windows.Forms.Button
$button.Location = New-Object Drawing.Point($X, $Y)
$button.Size = New-Object Drawing.Size($W, $H)
$button.Font = New-Object System.Drawing.Font('Segoe UI', 8)
$button.Text = $Text
$button.Cursor = 'Hand'
$button.ForeColor = 'White'
$button.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$button.Add_Click({
$Button_Mode.Tag = 'Disable'
$Button1_Main.Tag = 'Disable'
$Button2_Main.Tag = 'Disable'
$Button3_Main.Tag = 'Disable'
$Button4_Main.Tag = 'Disable'
$Button5_Main.Tag = 'Disable'
$Button6_Main.Tag = 'Disable'
$Active_Page = $Page
$this.Tag = 'Enable'
$Page0.Visible = $false
$Page1a.Visible = $false
$Page1b.Visible = $false
$Page2.Visible = $false
$Page3.Visible = $false
$Page4.Visible = $false
$Page5.Visible = $false
$Page6.Visible = $false
$PageConsole.Visible = $false
$PageConsoleX.Visible = $false
$Button_Mode.Visible = $false
if ($Button1_Main.Tag -eq 'Enable') {$Page = 'Page1a';$Button_Mode.Visible = $true}
if ($Button2_Main.Tag -eq 'Enable') {$Page = 'Page2'}
if ($Button3_Main.Tag -eq 'Enable') {$Page = 'Page3'}
if ($Button4_Main.Tag -eq 'Enable') {$Page = 'Page4'}
if ($Button5_Main.Tag -eq 'Enable') {$Page = 'Page5'}
if ($Button6_Main.Tag -eq 'Enable') {$Page = 'Page6'}
if ($Button_Mode.Tag -eq 'Enable') {$Page = 'Page1b'}
if ($Page -eq 'Page1a') {$Page1a.Visible = $true
$Button_Mode.Visible = $true
$ListView1_Page1a.Items.Clear()
$DropBox1_Page1a.ResetText()
$DropBox2_Page1a.ResetText()
$DropBox1_Page1a.Items.Clear()
$DropBox2_Page1a.Items.Clear()
$TextBox1_Page1a.Text = 'NewFile.vhdx'
$TextBox2_Page1a.Text = 'Enter vhdx size in MB'
$DropBox1_Page1a.Text = 'Select .wim'
$DropBox2_Page1a.Text = 'Select index'
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.wim" -Name | ForEach-Object {[void]$DropBox1_Page1a.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.wim" -Name | ForEach-Object {[void]$ListView1_Page1a.Items.Add($_)}}
if ($Page -eq 'Page1b') {$Page1b.Visible = $true
$ListView1_Page1b.Items.Clear()
$DropBox1_Page1b.ResetText()
$DropBox2_Page1b.ResetText()
$DropBox3_Page1b.ResetText()
$DropBox1_Page1b.Items.Clear()
$DropBox1_Page1b.Text = 'Select .vhdx'
$DropBox3_Page1b.Items.Clear()
$DropBox3_Page1b.Text = 'Select compression'
$DropBox3_Page1b.Items.Add("Fast")
$DropBox3_Page1b.Items.Add("Max")
$TextBox1_Page1b.Text = 'NewFile.wim'
$DropBox2_Page1b.Text = 'Select index'
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_Page1b.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_Page1b.Items.Add($_)}}
if ($Page -eq 'Page2') {$Page2.Visible = $true;$ListView1_Page2.Items.Clear()
$PathCheck = "$PSScriptRoot\\list\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
#Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$DropBox1_Page2.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_Page2.Items.Add($_)}}
if ($Page -eq 'Page3') {$Page3.Visible = $true;$ListView1_Page3.Items.Clear()
$PathCheck = "$PSScriptRoot\\project1"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\project1"
#Get-ChildItem -Path "$FilePath\*.*" -Name | ForEach-Object {[void]$DropBox1_Page3.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.*" -Name | ForEach-Object {[void]$ListView1_Page3.Items.Add($_)}} else {$FilePath = "$PSScriptRoot"}}
if ($Page -eq 'Page4') {
$Page4.Visible = $true;$ListView1_Page4.Items.Clear()
Get-ChildItem -Path "$PSScriptRoot" -Name | ForEach-Object {[void]$ListView1_Page4.Items.Add($_)}}
if ($Page -eq 'Page5') {
$Page5.Visible = $true;$ListView1_Page5.Items.Clear();$ListView1_Page5.Items.Add("PLACEHOLDER")
}
if ($Page -eq 'Page6') {
$Page6.Visible = $true;$ListView1_Page6.Items.Clear();$ListView1_Page6.Items.Add("PLACEHOLDER")
Get-Content "$PSScriptRoot\windick.ini" | ForEach-Object {[void]$ListView1_Page6.Items.Add($_)}}
# foreach ($i in Get-Content "c:\$\test.txt") {[void]$ListView1_Page1a.Items.Add($i)}
#Foreach ($i in @('a','b','c')) {[void]$ListView1_Page1a.Items.Add($i)}
#$dropdown.Items.Add("Option 1")
$this.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)})
$button.Add_MouseEnter({$this.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)})
$button.Add_MouseLeave({if ($this.Tag -eq 'Enable') {$this.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 70)} else {$this.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)}})
$PageMain.Controls.Add($button)
return $button}
[string]$logojpgB64=@"
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
"@
#############################################################################
# Form and panels
$form = New-Object Windows.Forms.Form
$form.Text = 'Windows Deployment Image Customization Kit'
$form.Size = New-Object Drawing.Size(600, 400)
$form.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$form.Font = New-Object System.Drawing.Font('Segoe UI', 9)
$form.StartPosition = 'CenterScreen'
$form.MaximizeBox = $false
$form.MinimizeBox = $true
#FixedDialog, FixedSingle
#$form.FormBorderStyle = 'FixedDialog'
$form.AutoScale = $true
$form.AutoSize = $true
#GrowAndShrink (default), GrowOnly, and ShrinkOnly.
$form.AutoSizeMode = 'GrowAndShrink'
$form.AutoScaleMode = 'DPI'
$WindowState = 'Normal'
$PageMain = NewPanel -C '25' -X '0' -Y '0' -W '600' -H '400'
$Page0 = NewPanel -C '51' -X '150' -Y '0' -W '450' -H '400'
$Page1a = NewPanel -C '51' -X '150' -Y '0' -W '450' -H '400'
$Page1b = NewPanel -C '51' -X '150' -Y '0' -W '450' -H '400'
$Page2 = NewPanel -C '51' -X '150' -Y '0' -W '450' -H '400'
$Page3 = NewPanel -C '51' -X '150' -Y '0' -W '450' -H '400'
$Page4 = NewPanel -C '51' -X '150' -Y '0' -W '450' -H '400'
$Page5 = NewPanel -C '51' -X '150' -Y '0' -W '450' -H '400'
$Page6 = NewPanel -C '51' -X '150' -Y '0' -W '450' -H '400'
$PageConsole = NewPanel -C '25' -X '0' -Y '0' -W '600' -H '400'
$PageConsoleX = NewPanel -C '25' -X '0' -Y '0' -W '600' -H '400'
$PageMain.Controls.Add($Page0)
$PageMain.Controls.Add($Page1a)
$PageMain.Controls.Add($Page1b)
$PageMain.Controls.Add($Page2)
$PageMain.Controls.Add($Page3)
$PageMain.Controls.Add($Page4)
$PageMain.Controls.Add($Page5)
$PageMain.Controls.Add($Page6)
$PageMain.Controls.Add($PageConsole)
$PageMain.Controls.Add($PageConsoleX)
$PageConsole.Visible = $false
$PageConsoleX.Visible = $false
$Page = 'Page1a';$Button_Mode = NewPageButton -X '7' -Y '30' -W '135' -H '40' -C '0' -Text 'Image Processing' 
$Page = 'Page1a';$Button1_Main = NewPageButton -X '7' -Y '30' -W '135' -H '40' -C '0' -Text 'Image Processing'
$Button_Mode.Visible = $false
$Page = 'Page2';$Button2_Main = NewPageButton -X '7' -Y '90' -W '135' -H '40' -C '0' -Text 'Image Management'
$Page = 'Page3';$Button3_Main = NewPageButton -X '7' -Y '150' -W '135' -H '40' -C '0' -Text 'Package Creator' 
$Page = 'Page4';$Button4_Main = NewPageButton -X '7' -Y '210' -W '135' -H '40' -C '0' -Text 'File Management'
$Page = 'Page5';$Button5_Main = NewPageButton -X '7' -Y '270' -W '135' -H '40' -C '0' -Text 'Disk Management'
$Page = 'Page6';$Button6_Main = NewPageButton -X '7' -Y '330' -W '135' -H '40' -C '0' -Text 'Settings'
# Page Configuration
$pictureBox = New-Object System.Windows.Forms.PictureBox
$imagejpg = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($logojpgB64))
$pictureBox.Location = New-Object Drawing.Point(0, 75)
$pictureBox.Size = New-Object Drawing.Size(450, 250)
$pictureBox.Image = $imagejpg
# Normal, StretchImage, AutoSize, CenterImage, Zoom
$pictureBox.SizeMode = 'StretchImage'
$pictureBox.Visible = $true
$Page0.Controls.Add($pictureBox)
#$ListView1_Page1a = NewListView -X '10' -Y '20' -W '400' -H '200'
#$ListView1_Page6 = NewListView -X '100' -Y '20' -W '400' -H '200'
$ListView1_Page1a = New-Object System.Windows.Forms.ListView
$ListView1_Page1a.Size = New-Object Drawing.Size(420, 200)
$ListView1_Page1a.Location = New-Object Drawing.Point(15, 55)
$ListView1_Page1a.View = "List"
$ListView1_Page1a.View = "Details"
$ListView1_Page1a.Visible = $true
$ListView1_Page1a.MultiSelect = $false
$ListView1_Page1a.HideSelection = $true
$ListView1_Page1a.Columns.Add("Available:")
#$ListView1_Page1a.Columns.Add("Column2:")
$ListView1_Page1a.Columns[0].Width = -2
#$ListView1_Page1a.Columns[1].Width = -2
$Page1a.Controls.Add($ListView1_Page1a)
$ListView1_Page1b = New-Object System.Windows.Forms.ListView
$ListView1_Page1b.Size = New-Object Drawing.Size(420, 200)
$ListView1_Page1b.Location = New-Object Drawing.Point(15, 55)
$ListView1_Page1b.View = "List"
$ListView1_Page1b.View = "Details"
$ListView1_Page1b.Visible = $true
$ListView1_Page1b.MultiSelect = $false
$ListView1_Page1b.HideSelection = $true
$ListView1_Page1b.Columns.Add("Available:")
#$ListView1_Page1b.Columns.Add("Column2:")
$ListView1_Page1b.Columns[0].Width = -2
#$ListView1_Page1b.Columns[1].Width = -2
$Page1b.Controls.Add($ListView1_Page1b)
$ListView1_Page2 = New-Object System.Windows.Forms.ListView
$ListView1_Page2.Size = New-Object Drawing.Size(420, 200)
$ListView1_Page2.Location = New-Object Drawing.Point(15, 55)
$ListView1_Page2.View = "List"
$ListView1_Page2.View = "Details"
$ListView1_Page2.Visible = $true
$ListView1_Page2.MultiSelect = $false
$ListView1_Page2.HideSelection = $true
$ListView1_Page2.Columns.Add("Available:")
$ListView1_Page2.Columns[0].Width = -2
$Page2.Controls.Add($ListView1_Page2)
$ListView1_Page3 = New-Object System.Windows.Forms.ListView
$ListView1_Page3.Size = New-Object Drawing.Size(420, 200)
$ListView1_Page3.Location = New-Object Drawing.Point(15, 55)
$ListView1_Page3.View = "List"
$ListView1_Page3.View = "Details"
$ListView1_Page3.Visible = $true
$ListView1_Page3.MultiSelect = $false
$ListView1_Page3.HideSelection = $true
$ListView1_Page3.Columns.Add("Available:")
$ListView1_Page3.Columns[0].Width = -2
$Page3.Controls.Add($ListView1_Page3)
$ListView1_Page4 = New-Object System.Windows.Forms.ListView
$ListView1_Page4.Size = New-Object Drawing.Size(420, 200)
$ListView1_Page4.Location = New-Object Drawing.Point(15, 55)
$ListView1_Page4.View = "List"
$ListView1_Page4.View = "Details"
$ListView1_Page4.Visible = $true
$ListView1_Page4.MultiSelect = $false
$ListView1_Page4.HideSelection = $true
$ListView1_Page4.Columns.Add("Available:")
$ListView1_Page4.Columns[0].Width = -2
$Page4.Controls.Add($ListView1_Page4)
$ListView1_Page5 = New-Object System.Windows.Forms.ListView
$ListView1_Page5.Size = New-Object Drawing.Size(420, 200)
$ListView1_Page5.Location = New-Object Drawing.Point(15, 55)
$ListView1_Page5.View = "List"
$ListView1_Page5.View = "Details"
$ListView1_Page5.Visible = $true
$ListView1_Page5.MultiSelect = $false
$ListView1_Page5.HideSelection = $true
$ListView1_Page5.Columns.Add("Available:")
$ListView1_Page5.Columns[0].Width = -2
$Page5.Controls.Add($ListView1_Page5)
$ListView1_Page6 = New-Object System.Windows.Forms.ListView
$ListView1_Page6.Size = New-Object Drawing.Size(420, 200)
$ListView1_Page6.Location = New-Object Drawing.Point(15, 55)
$ListView1_Page6.View = "List"
$ListView1_Page6.View = "Details"
$ListView1_Page6.Visible = $true
$ListView1_Page6.MultiSelect = $false
$ListView1_Page6.HideSelection = $true
$ListView1_Page6.Columns.Add("Available:")
$ListView1_Page6.Columns[0].Width = -2
$Page6.Controls.Add($ListView1_Page6)

$hConsole = [ConsoleFont]::GetStdHandle([ConsoleFont]::STD_OUTPUT_HANDLE)
$font = New-Object ConsoleFont+CONSOLE_FONT_INFOEX
$font.cbSize = [System.Runtime.InteropServices.Marshal]::SizeOf($font)
$font.nFont = 0
$font.dwFontSize = New-Object ConsoleFont+COORD
$font.dwFontSize.X = 5
$font.dwFontSize.Y = 10
$font.FontFamily = 54
$font.FontWeight = 400
$font.FaceName = "Consolas"
[ConsoleFont]::SetCurrentConsoleFontEx($hConsole, $false, [ref]$font)
$consoleHandle = [API.Win32]::GetConsoleWindow();$panelHandle = $PageConsoleX.Handle;[API.Win32]::SetParent($consoleHandle, $panelHandle)
cls
$Page = 'PageConsole';$Button1_PageConsole = NewButton -X '210' -Y '355' -W '180' -H '35' -Text 'Ok' -Hover_Text 'Ok' -Add_Click {$PageConsole.Visible = $false}
#$TextBox1_PageConsole = NewRichTextBox -X '15' -Y '15' -W '575' -H '335' -Text 'Value OverWritten'
#$TextBox1_PageConsole.Font = New-Object System.Drawing.Font('Segoe UI', 7, [System.Drawing.FontStyle]::Regular)
#$TextBox1_PageConsole.Multiline = $true
#$PageConsole.Controls.Add($TextBox1_PageConsole)
#$TextBox1_PageConsole.Dock = 'Fill'
#$TextBox1_PageConsole.ScrollBars = "Vertical"
#$TextBox1_PageConsole.Text = "Option X"
#Foreach ($line in $command) {$TextBox1_PageConsole.AppendText("$line`r`n")}  
#$PageConsole.Controls.Add($ListView1_PageConsole)
#$explorer = New-Object -ComObject Shell.Explorer
#$explorerControl = New-Object System.Windows.Forms.Control
#$explorerControl.Handle = $explorer.HWND
#$explorerControl.Width = $Page4.ClientSize.Width
#$explorerControl.Height = $Page4.ClientSize.Height
#$explorerControl.Anchor = "Top,Bottom,Left,Right"
#$Page4.Controls.Add($explorer)
#$Page4.Controls.Add($explorerControl)
#$explorer.Navigate("C:\") # Specify the initial directory
#$Page4.Add_Shown({$explorerControl.Activate()})
$Page = 'Page0'
$Label0_Page0 = NewLabel -X '10' -Y '10' -W '375' -H '25' -TextSize '12' -Text 'Welcome to GUI v0.1'
$Button1_Page0 = NewButton -X '135' -Y '350' -W '180' -H '35' -Text 'About' -Hover_Text 'PLACEHOLDER' -Add_Click {
$form.Visible = $true;$NULL = [System.Windows.Forms.MessageBox]::Show("github.com/joshuacline", "Message Box", 0);$form.Visible = $true}
#$Button2_Page0 = NewButton -X '225' -Y '275' -W '180' -H '35' -Text 'PLACEHOLDER' -Hover_Text 'PLACEHOLDER' -Add_Click {$form.Visible = $false;$form.Visible = $true}
$Page = 'Page1a'
$Label0_Page1a = NewLabel -X '10' -Y '10' -W '350' -H '30' -TextSize '14' -Text 'Image Processing'
$Button1_Page1a = NewButton -X '135' -Y '350' -W '180' -H '35' -Text 'Go!' -Hover_Text 'PLACEHOLDER' -Add_Click {
$form.Visible = $false;
$TextValue1 = $TextBox1_Page1a.Text
$TextValue2 = $TextBox2_Page1a.Text
#start cmd.exe -wait -a "/c $PSScriptRoot\hello.cmd /y /j"
#$command = "start cmd.exe /c $PSScriptRoot\hello.cmd"
#$command = "/c ""$PSScriptRoot\windick.cmd"" -imageproc -wim ""$PSScriptRoot\$($DropBox1_Page1a.SelectedItem)"" -index ""$($DropBox2_Page1a.SelectedItem)"" -vhdx ""$TextValue1"" -size ""$TextValue2"" "
#Foreach ($line in $command) {Write-Host "$line"}
$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -imageproc -wim ""$($DropBox1_Page1a.SelectedItem)"" -index ""$($DropBox2_Page1a.SelectedItem)"" -vhdx ""$TextValue1"" -size ""$TextValue2"""
Start-Process -wait -FilePath "$env:comspec" -ArgumentList "$ArgumentX" 
$form.Visible = $true}
#$Button2_Page1a = NewButton -X '225' -Y '350' -W '180' -H '35' -Text 'PLACEHOLDER' -Hover_Text 'PLACEHOLDER' -Add_Click {$form.Visible = $false;PickFile;$form.Visible = $true}
$DropBox1_Page1a = NewDropBox -X '15' -Y '270' -W '180' -H '25' -C '0' -DisplayMember 'Name' -Text 'Page 1'
$DropBox2_Page1a = NewDropBox -X '255' -Y '270' -W '180' -H '25' -C '0' -DisplayMember 'Description'
$TextBox1_Page1a = NewTextBox -X '15' -Y '310' -W '180' -H '25' -Text 'Value OverWritten'
$TextBox2_Page1a = NewTextBox -X '255' -Y '310' -W '180' -H '25' -Text 'Value OverWritten'
$Page = 'Page1b'
$Label0_Page1b = NewLabel -X '10' -Y '10' -W '350' -H '30' -TextSize '14' -Text 'Image Processing'
$Button1_Page1b = NewButton -X '135' -Y '350' -W '180' -H '35' -Text 'Go!' -Hover_Text 'PLACEHOLDER' -Add_Click {
$form.Visible = $false
$TextValue1 = $TextBox1_Page1b.Text
$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -imageproc -vhdx ""$($DropBox1_Page1b.SelectedItem)"" -index ""$($DropBox2_Page1b.SelectedItem)"" -wim ""$TextValue1"" -xlvl ""$($DropBox3_Page1b.SelectedItem)"""
Start-Process -wait -FilePath "$env:comspec" -ArgumentList "$ArgumentX"
$form.Visible = $true}
#$Button2_Page1b = NewButton -X '255' -Y '355' -W '180' -H '35' -Text 'PLACEHOLDER' -Hover_Text 'PLACEHOLDER' -Add_Click {$form.Visible = $false;PickFile;$form.Visible = $true}
$DropBox1_Page1b = NewDropBox -X '15' -Y '270' -W '180' -H '25' -C '0' -DisplayMember 'Name' -Text 'Page 1'
$DropBox2_Page1b = NewDropBox -X '255' -Y '270' -W '180' -H '25' -C '0' -DisplayMember 'Description'
$DropBox3_Page1b = NewDropBox -X '255' -Y '310' -W '180' -H '25' -C '0' -DisplayMember 'Description'
$TextBox1_Page1b = NewTextBox -X '15' -Y '310' -W '180' -H '25' -Text 'Value OverWritten'
$Page = 'Page2'
$Label0_Page2 = NewLabel -X '10' -Y '10' -W '350' -H '30' -TextSize '14' -Text 'Image Management'
$Button1_Page2 = NewButton -X '255' -Y '350' -W '180' -H '35' -Text 'List Execute' -Hover_Text 'List Execute' -Add_Click {
$form.Visible = $false;$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -internal -imagemgr ""run"""
Start-Process -wait -FilePath "$env:comspec" -ArgumentList "$ArgumentX";$form.Visible = $true}
$Button2_Page2 = NewButton -X '15' -Y '350' -W '180' -H '35' -Text 'List Builder' -Hover_Text 'List Builder' -Add_Click {
$form.Visible = $false;$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -internal -imagemgr ""new"""
Start-Process -wait -FilePath "$env:comspec" -ArgumentList "$ArgumentX";$form.Visible = $true}
$Button3_Page2 = NewButton -X '15' -Y '300' -W '180' -H '35' -Text 'Edit List' -Hover_Text 'Edit List' -Add_Click {
$form.Visible = $false;$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -internal -imagemgr ""edit"""
Start-Process -wait -FilePath "$env:comspec" -ArgumentList "$ArgumentX";$form.Visible = $true}
$Page = 'Page3'
$Label0_Page3 = NewLabel -X '10' -Y '10' -W '350' -H '30' -TextSize '14' -Text 'Package Creator'
$Button1_Page3 = NewButton -X '135' -Y '350' -W '180' -H '35' -Text 'Package Creator' -Hover_Text 'Package Creator' -Add_Click {
$form.Visible = $false;$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -internal ""-packcreator"""
Start-Process -wait -FilePath "$env:comspec" -ArgumentList "$ArgumentX";$form.Visible = $true}
#$Button2_Page3 = NewButton -X '255' -Y '270' -W '180' -H '35' -Text 'PLACEHOLDER' -Hover_Text 'PLACEHOLDER' -Add_Click {$form.Visible = $false;PickFolder;$form.Visible = $true}
$Page = 'Page4'
$Label0_Page4 = NewLabel -X '10' -Y '10' -W '350' -H '30' -TextSize '14' -Text 'File Management' 
$Button1_Page4 = NewButton -X '135' -Y '350' -W '180' -H '35' -Text 'File Management' -Hover_Text 'File Management' -Add_Click {
$form.Visible = $false;$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -internal ""-filemgr"""
Start-Process -wait -FilePath "$env:comspec" -ArgumentList "$ArgumentX";$form.Visible = $true}
$Page = 'Page5'
$Label0_Page5 = NewLabel -X '10' -Y '10' -W '350' -H '30' -TextSize '14' -Text 'Disk Management' 
$Button1_Page5 = NewButton -X '135' -Y '350' -W '180' -H '35' -Text 'Disk Management' -Hover_Text 'Disk Management' -Add_Click {
$form.Visible = $false;$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -internal ""-diskmgr"""
Start-Process -wait -FilePath "$env:comspec" -ArgumentList "$ArgumentX";$form.Visible = $true}
#$Button2_Page5 = NewButton -X '255' -Y '270' -W '180' -H '35' -Text 'PLACEHOLDER' -Hover_Text 'PLACEHOLDER' -Add_Click {$form.Visible = $false;PickFolder;$form.Visible = $true}
$Page = 'Page6'
$Label0_Page6 = NewLabel -X '10' -Y '10' -W '350' -H '30' -TextSize '14' -Text 'Settings Configuration'
$Button1_Page6 = NewButton -X '135' -Y '350' -W '180' -H '35' -Text 'Settings' -Hover_Text 'Settings' -Add_Click {cls
#[API.Win32]::MoveWindow($consoleHandle, -0, -0, $PageConsoleX.Width, $PageConsoleX.Height, $true)
[API.Win32]::MoveWindow($consoleHandle, -10, -35, 620, 450, $true)
$Page6.Visible = $false
$PageConsoleX.Visible = $true
$PageConsoleX.BringToFront()
$ArgumentX = """/c"" ""$PSScriptRoot\windick.cmd"" -internal ""-settings"""
Start-Process -Wait -NoNewWindow -FilePath "$env:comspec" -ArgumentList "$ArgumentX"
[API.Win32]::MoveWindow($consoleHandle, -10, -35, 620, 400, $true)
#Foreach ($line in $command) {Write-Host "$line"}         
$Button1_PageConsoleX.Visible = $true
$Button1_PageConsoleX.BringToFront()
}

$Page = 'PageConsoleX';$Button1_PageConsoleX = NewButton -X '210' -Y '355' -W '180' -H '35' -Text 'Ok' -Hover_Text 'Ok' -Add_Click {$Button1_PageConsoleX.Visible = $false

$Page6.Visible = $true
$PageConsoleX.Visible = $false}
$Button1_PageConsoleX.Visible = $false
$result = $form.ShowDialog()
       