# Windows Deployment Image Customization Kit v 1205 (c) github.com/joshuacline
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
[DllImport("user32.dll")] public static extern bool DestroyWindow(IntPtr hWnd);
[DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
"@ -Name "Functions" -Namespace "WinMekanix" -PassThru
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
function NewPanel {
param([int]$X,[int]$Y,[int]$H,[int]$W,[int]$C)
$panel = New-Object System.Windows.Forms.Panel
$panel.BackColor = [System.Drawing.Color]::FromArgb($C, $C, $C)
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$panel.Location = New-Object Drawing.Point($XLOC, $YLOC)
$panel.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$panel.Dock = 'Fill'
$form.Controls.Add($panel)
return $panel}
function NewPictureBox {
param([int]$X,[int]$Y,[int]$H,[int]$W)
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureDecrypt = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($pictureBase64))
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$pictureBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$pictureBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$pictureBox.Image = $pictureDecrypt
$pictureBox.SizeMode = 'StretchImage';#Normal, StretchImage, AutoSize, CenterImage, Zoom
$pictureBox.Visible = $true
$element = $pictureBox;AddElement
return $pictureBox}
function NewTextBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$textbox = New-Object System.Windows.Forms.TextBox
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
#$textbox.Bounds = New-Object System.Drawing.Rectangle($XLOC, $YLOC, $WSIZ, $HSIZ)
$textbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$textbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$textbox.Text = "$Text"
$textbox.Visible = $true
$textbox.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$textbox.ForeColor = 'White'
#$textbox.SelectionColor = 'White'
#$textbox.ReadOnly = $true
#$textBox.Multiline = $true
#$textBox.ScrollBars = "Vertical"
#$textBox.Dock = "Fill"
#$textBox.ReadOnly = $true
#$textBox.AppendText = "Option X"
$element = $textbox;AddElement
return $textbox}
function NewRichTextBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$richTextBox = New-Object System.Windows.Forms.RichTextBox
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$richTextBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$richTextBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$richTextBox.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$richTextBox.ForeColor = 'White'
#$richTextBox.Dock = DockStyle.Fill
#$richTextBox.LoadFile("C:\\MyDocument.rtf")
#$richTextBox.Find("Text")
#$richTextBox.SelectionColor = Color.Red
#$richTextBox.SaveFile("C:\\MyDocument.rtf")
$richTextBox.Visible = $true
$element = $richTextBox;AddElement
return $richTextBox}
function NewListView {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Headers,[string]$Text)
$listview = New-Object System.Windows.Forms.ListView
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$listview.Location = New-Object Drawing.Point($XLOC, $YLOC)
$listview.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$listview.View = [System.Windows.Forms.View]::Details # Set to Details view for columns
$listview.View = "Details";#$listview.View = "List"
$listview.MultiSelect = $false
$listview.HideSelection = $true
#$listview.HeaderStyle = 'Clickable';#NonClickable;#None
if ($Headers) {$listview.HeaderStyle = "$Headers"} else {$listview.HeaderStyle = 'None'}
#$listview.Columns[0].Width = -2
#$listview.Columns[1].Width = -2
#$listview.CheckBoxes = true
#$listview.FullRowSelect = true
#$listview.GridLines = true
#$listview.Sorting = SortOrder.Ascending
#$imageListSmall = New-Object System.Windows.Forms.ImageList
#$listview.SmallImageList = $imageListSmall
$listview.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$listview.ForeColor = 'White'
$element = $listview;AddElement
$listview.Visible = $true
#$listViewSelect = $listView.SelectedItems
#$listViewFocused = $listView.FocusedItem
#Write-Host "sel:$listViewSelect  foc:$listViewFocused"
return $listview}
function MessageBox {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxText)
$formbox = New-Object System.Windows.Forms.Form
$formbox.SuspendLayout()
if ($MessageBoxTitle) {$formbox.Text = "$MessageBoxTitle"}
#$formbox.ForeColor = 'White'
$formbox.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$formbox.StartPosition = "CenterScreen"
$formbox.FormBorderStyle = 'FixedDialog'
$formbox.MaximizeBox = $false
$formbox.MinimizeBox = $true
$formbox.ControlBox = $False
$formbox.AutoSizeMode = 'GrowAndShrink'
$formbox.AutoScale = $true
$formbox.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$WindowState = 'Normal'
$WSIZ = [int](350 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](275 * $ScaleRef * $ScaleFactor)
$formbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$fontX = [int](9 * $ScaleFactor);$fontX = [Math]::Floor($fontX);
$formbox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Text = "$MessageBoxText"
$labelbox.ForeColor = 'White'
$labelbox.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
#$labelbox.AutoSize = $true
if ($MessageBoxType -eq 'YesNo') {
$okButton = New-Object System.Windows.Forms.Button
$WSIZ = [int](135 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](45 * $ScaleRef * $ScaleFactor)
$XLOC = [int](15 * $ScaleRef * $ScaleFactor)
$YLOC = [int](140 * $ScaleRef * $ScaleFactor)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.Cursor = 'Hand'
$okButton.ForeColor = 'White'
$okButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$okButton.DialogResult = "OK"
$okButton.Text = "Yes"
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "No"
$WSIZ = [int](135 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](45 * $ScaleRef * $ScaleFactor)
$XLOC = [int](175 * $ScaleRef * $ScaleFactor)
$YLOC = [int](140 * $ScaleRef * $ScaleFactor)
$cancelButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$cancelButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$cancelButton.Cursor = 'Hand'
$cancelButton.ForeColor = 'White'
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$cancelButton.DialogResult = "CANCEL"
$WSIZ = [int](325 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](115 * $ScaleRef * $ScaleFactor)
$XLOC = [int](10 * $ScaleRef * $ScaleFactor)
$YLOC = [int](20 * $ScaleRef * $ScaleFactor)
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($cancelButton)
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Info') {
$okButton = New-Object System.Windows.Forms.Button
$WSIZ = [int](135 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](45 * $ScaleRef * $ScaleFactor)
$XLOC = [int](95 * $ScaleRef * $ScaleFactor)
$YLOC = [int](140 * $ScaleRef * $ScaleFactor)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.Cursor = 'Hand'
$okButton.ForeColor = 'White'
$okButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$okButton.DialogResult = "OK"
$okButton.Text = "OK"
$WSIZ = [int](325 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](110 * $ScaleRef * $ScaleFactor)
$XLOC = [int](10 * $ScaleRef * $ScaleFactor)
$YLOC = [int](25 * $ScaleRef * $ScaleFactor)
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Prompt') {
$WSIZ = [int](300 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](40 * $ScaleRef * $ScaleFactor)
$XLOC = [int](10 * $ScaleRef * $ScaleFactor)
$YLOC = [int](95 * $ScaleRef * $ScaleFactor)
$inputbox = New-Object System.Windows.Forms.TextBox
$inputbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$inputbox.Size = New-Object System.Drawing.Size($WSIZ,$HSIZ)
$inputbox.ForeColor = 'White'
$inputbox.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$WSIZ = [int](135 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](45 * $ScaleRef * $ScaleFactor)
$XLOC = [int](15 * $ScaleRef * $ScaleFactor)
$YLOC = [int](140 * $ScaleRef * $ScaleFactor)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.Cursor = 'Hand'
$okButton.ForeColor = 'White'
$okButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$okButton.DialogResult = "OK"
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$WSIZ = [int](135 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](45 * $ScaleRef * $ScaleFactor)
$XLOC = [int](175 * $ScaleRef * $ScaleFactor)
$YLOC = [int](140 * $ScaleRef * $ScaleFactor)
$cancelButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$cancelButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$cancelButton.Cursor = 'Hand'
$cancelButton.ForeColor = 'White'
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$cancelButton.DialogResult = "CANCEL"
$WSIZ = [int](325 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](75 * $ScaleRef * $ScaleFactor)
$XLOC = [int](10 * $ScaleRef * $ScaleFactor)
$YLOC = [int](20 * $ScaleRef * $ScaleFactor)
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($okButton)
$formbox.Controls.Add($cancelButton)
$formbox.Controls.Add($inputbox)}

$formbox.Controls.Add($labelbox)
$formbox.ResumeLayout()
$global:boxresult = $formbox.ShowDialog()
$global:promptout = $null;if ($boxresult -eq "OK") {$global:promptout = $inputbox.Text}
$formbox.Dispose()}
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
#$CurDir =  $PWD.Path
function PickFolderx {
$shell = New-Object -ComObject Shell.Application
$FolderPicker = $shell.BrowseForFolder(0, "Select a folder:", 0, $null)
$Pick = $FolderPicker.Self.Path
Write-Host "Selected folder: $Pick"}
function PickFile {
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.InitialDirectory = "$FilePath"
$OpenFileDialog.RestoreDirectory = $true
#$OpenFileDialog.Filter = "Text files (*.txt;*.zip)|*.txt;*.zip"
$OpenFileDialog.Filter = $FileFilt
#$OpenFileDialog.Filter = "WIM files (*.wim)|*.wim"
$OpenFileDialog.ShowDialog() | Out-Null
$global:Pick = $OpenFileDialog.FileName
Write-Host "Selected file: $Pick"}
function NewRadioButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$GroupName)
$radio = New-Object System.Windows.Forms.RadioButton
$radio.ForeColor = 'White'
$radio.Text = "$Text"
$radio.Add_CheckedChanged($Add_CheckedChanged)
#$radio.Checked = "$false"
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$radio.Location = New-Object Drawing.Point($XLOC, $YLOC)
$radio.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($GroupName -eq 'Group1') {$GroupBox1_PageSC.Controls.Add($radio)}
if ($GroupName -eq 'Group2') {$GroupBox2_PageSC.Controls.Add($radio)}
return $radio}
function NewGroupBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Checked)
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.ForeColor = 'White'
$groupBox.Text = "$Text"
#$groupBox.Checked = "$false"
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$groupBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$groupBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$element = $groupBox;AddElement
return $groupBox}
function NewSlider {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$slider = New-Object System.Windows.Forms.TrackBar
$slider.Minimum = 0
$slider.Maximum = 100
$slider.TickFrequency = 10
$slider.LargeChange = 10
$slider.SmallChange = 1
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$slider.Width = $WSIZ
$slider.Location = New-Object Drawing.Point($XLOC, $YLOC)
$slider.Add_Scroll({$Add_Scroll})
$element = $slider;AddElement
return $slider}
function NewToggle {
param ([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$toggle = New-Object System.Windows.Forms.CheckBox
$toggle.ForeColor = 'White'
$toggle.Text = "$Text"
$toggle.Add_CheckedChanged($Add_CheckedChanged)
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$toggle.Location = New-Object Drawing.Point($XLOC, $YLOC)
$toggle.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$element = $toggle;AddElement
return $toggle}
function NewDropBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[int]$C,[string]$Text,[string]$DisplayMember)
$dropbox = New-Object System.Windows.Forms.ComboBox
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
#$dropbox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::Simple
$dropbox.DropDownStyle = 'DropDownList'#ReadOnly
$dropbox.FlatStyle = 'Flat'# Flat, Popup, System
$dropbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$dropbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$dropbox.DisplayMember = $DisplayMember
$dropbox.Text = "$Text"
$dropbox.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$dropbox.ForeColor = 'White'
#$dropbox.Items.Add("Option 1")
#$dropbox.Add_TextChanged({$dropbox.Text = "changed"})
#$dropbox.SelectedIndex = 0#$dropbox.SelectedItem = "Option 1"#must be on list
#$dropbox.IsEditable = $false
#$dropbox.IsReadOnly = $true
$dropbox.Add_SelectedIndexChanged({
$DropBox1_PageW2V.Tag = 'Disable'
$DropBox2_PageW2V.Tag = 'Disable'
$DropBox1_PageV2W.Tag = 'Disable'
$DropBox2_PageV2W.Tag = 'Disable'
$DropBox3_PageV2W.Tag = 'Disable'
$DropBox1_PageBC.Tag = 'Disable'
$DropBox2_PageBC.Tag = 'Disable'
$DropBox3_PageBC.Tag = 'Disable'
$DropBox1_PageSC.Tag = 'Disable'
$DropBox2_PageSC.Tag = 'Disable'
$this.Tag = 'Enable'
if ($DropBox1_PageW2V.Tag -eq 'Enable') {if ($DropBox1_PageW2V.SelectedItem -eq 'Import Installation Media') {ImportWim}
if ($DropBox1_PageW2V.SelectedItem) {if ($DropBox1_PageW2V.SelectedItem -ne 'Import Installation Media') {Dropbox1W2V}}}
if ($DropBox2_PageBC.Tag -eq 'Enable') {if ($DropBox2_PageBC.SelectedItem -eq 'Import Wallpaper') {ImportWallpaper}}
if ($DropBox3_PageBC.Tag -eq 'Enable') {if ($DropBox3_PageBC.SelectedItem -eq 'Refresh') {Dropbox3BC}}
if ($DropBox1_PageV2W.Tag -eq 'Enable') {Dropbox1V2W}
if ($DropBox1_PageSC.Tag -eq 'Enable') {Dropbox1SC}
if ($DropBox2_PageSC.Tag -eq 'Enable') {DropBox2SC}
})
$element = $dropbox;AddElement
return $dropbox}
function NewLabel {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Bold,[string]$TextSize,[string]$Text)
$label = New-Object Windows.Forms.Label
#$label.Font = New-Object System.Drawing.Font("Consolas", $TextSize)
#$label.Font = New-Object System.Drawing.Font("Consolas", $TextSize,[System.Drawing.FontStyle]::Bold)
#$label.Font = New-Object System.Drawing.Font("",$TextSize,([System.Drawing.FontStyle]::Regular),[System.Drawing.GraphicsUnit]::Pixel)
$label.ForeColor = 'White'
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$fontX = [int](1 * $TextSize * $ScaleFactor)
$fontX = [Math]::Floor($fontX);
if ($Bold -eq 'True') {$label.Font = "Consolas, $fontX pt, style=Bold"}
$label.Location = New-Object Drawing.Point($XLOC, $YLOC)
#$label.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$label.AutoSize = $true
$label.Text = "$Text"
$element = $label;AddElement
return $label}
function NewButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Hover_Text,[scriptblock]$Add_Click)
$button = New-Object Windows.Forms.Button
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$button.Location = New-Object Drawing.Point($XLOC, $YLOC)
$button.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$button.Add_Click($Add_Click)
$button.Text = $Text
$button.Cursor = 'Hand'
$button.ForeColor = 'White'
$button.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$button.Add_MouseEnter({$this.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)})
$button.Add_MouseLeave({$this.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)})
$hovertext = New-Object System.Windows.Forms.ToolTip
$hovertext.SetToolTip($button, $Hover_Text)
$element = $button;AddElement
return $button}
function NewPageButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$button = New-Object Windows.Forms.Button
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$button.Location = New-Object Drawing.Point($XLOC, $YLOC)
$button.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$button.Text = $Text
$button.Cursor = 'Hand'
$button.ForeColor = 'White'
$button.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$button.Add_Click({
$PageSplash.Visible = $false
$Button_V2W.Tag = 'Disable'
$Button_W2V.Tag = 'Disable'
$Button_LB.Tag = 'Disable'
$Button_PB.Tag = 'Disable'
$Button_BC.Tag = 'Disable'
$Button_SC.Tag = 'Disable'
$this.Tag = 'Enable'
if ($Button_W2V.Tag -eq 'Enable') {$PageW2V.Visible = $true;Button_PageW2V;$PageW2V.BringToFront();$Button_V2W.Visible = $true;$Button_W2V.Visible = $false}
if ($Button_V2W.Tag -eq 'Enable') {$PageV2W.Visible = $true;Button_PageV2W;$PageV2W.BringToFront();$Button_W2V.Visible = $true;$Button_V2W.Visible = $false}
if ($Button_LB.Tag -eq 'Enable') {$PageLB.Visible = $true;Button_PageLB;$PageLB.BringToFront();$Button_PB.Visible = $true;$Button_LB.Visible = $false}
if ($Button_PB.Tag -eq 'Enable') {$PagePB.Visible = $true;Button_PagePB;$PagePB.BringToFront();$Button_LB.Visible = $true;$Button_PB.Visible = $false}
#if ($Button_PB.Tag -eq 'Enable') {$PagePB.Visible = $true;Button_PagePB;$PagePB.BringToFront()}
#if ($Button_LB.Tag -eq 'Enable') {$PageLB.Visible = $true;Button_PageLB;$PageLB.BringToFront()}
if ($Button_BC.Tag -eq 'Enable') {$PageBC.Visible = $true;Button_PageBC;$PageBC.BringToFront()}
if ($Button_SC.Tag -eq 'Enable') {$PageSC.Visible = $true;Button_PageSC;$PageSC.BringToFront()}
if ($Button_W2V.Tag -ne 'Enable') {$PageW2V.Visible = $false}
if ($Button_V2W.Tag -ne 'Enable') {$PageV2W.Visible = $false}
if ($Button_LB.Tag -ne 'Enable') {$PageLB.Visible = $false}
if ($Button_PB.Tag -ne 'Enable') {$PagePB.Visible = $false}
if ($Button_BC.Tag -ne 'Enable') {$PageBC.Visible = $false}
if ($Button_SC.Tag -ne 'Enable') {$PageSC.Visible = $false}
$Button_W2V.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$Button_V2W.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$Button_LB.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$Button_PB.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$Button_BC.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$Button_SC.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
if ($this.Tag -eq 'Enable') {$this.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)}
})
$button.Add_MouseEnter({$this.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)})
$button.Add_MouseLeave({if ($this.Tag -eq 'Enable') {$this.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)} else {$this.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)}
if ($Button_V2W.Tag -eq 'Enable') {$Button_W2V.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)}
if ($Button_W2V.Tag -eq 'Enable') {$Button_V2W.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)}
if ($Button_LB.Tag -eq 'Enable') {$Button_PB.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)}
if ($Button_PB.Tag -eq 'Enable') {$Button_LB.BackColor = [System.Drawing.Color]::FromArgb(90, 90, 90)}
})
$PageMain.Controls.Add($button)
return $button}
function ConsoleView {
$command = e:\windick\windick.cmd -diskmgr -list
Foreach ($line in $command) {[void]$ListView.Items.Add($line)}}
function Get-ChildProcesses ($ParentProcessId) {$filter = "parentprocessid = '$($ParentProcessId)'"
Get-CIMInstance -ClassName win32_process -filter $filter | Foreach-Object {$_
if ($_.ParentProcessId -ne $_.ProcessId) {Get-ChildProcesses $_.ProcessId}}}
function Button_PageW2V {
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
if (Test-Path -Path $FilePath\$($DropBox1_PageW2V.SelectedItem)) {$null} else {$DropBox1_PageW2V.SelectedItem = $null}
$ListView1_PageW2V.Items.Clear();#$ListView1_PageW2V.Columns[0].Width = -2
$DropBox1_PageW2V.ResetText();$DropBox1_PageW2V.Items.Clear()
$DropBox2_PageW2V.ResetText();$DropBox2_PageW2V.Items.Clear()
Get-ChildItem -Path "$FilePath\*.wim" -Name | ForEach-Object {[void]$DropBox1_PageW2V.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.wim" -Name | ForEach-Object {[void]$ListView1_PageW2V.Items.Add($_)}
[void]$DropBox1_PageW2V.Items.Add("Import Installation Media")
if ($($TextBox1_PageW2V.Text)) {$null} else {$TextBox1_PageW2V.Text = 'NewFile.vhdx'}
if ($($TextBox2_PageW2V.Text)) {$null} else {$TextBox2_PageW2V.Text = '25'}
}
function Button_PageV2W {
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
if (Test-Path -Path $FilePath\$($DropBox1_PageV2W.SelectedItem)) {$null} else {$DropBox1_PageV2W.SelectedItem = $null}
$ListView1_PageV2W.Items.Clear();#$ListView1_PageW2V.Columns[0].Width = -2
$DropBox1_PageV2W.ResetText();$DropBox1_PageV2W.Items.Clear()
$DropBox2_PageV2W.ResetText();$DropBox2_PageV2W.Items.Clear()
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageV2W.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageV2W.Items.Add($_)}
if ($($TextBox1_PageV2W.Text)) {$null} else {$TextBox1_PageV2W.Text = 'NewFile.wim'}
if ($($DropBox3_PageV2W.SelectedItem)) {$null} else {$DropBox3_PageV2W.Items.Clear();$DropBox3_PageV2W.Items.Add("Fast");$DropBox3_PageV2W.Items.Add("Max");$DropBox3_PageV2W.SelectedItem = "Fast";}
}
function Button_PageLB {
$ListView1_PageLB.Items.Clear()
$ListView2_PageLB.Items.Clear()
$PathCheck = "$PSScriptRoot\\list"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
#Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLB.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.base" -Name | ForEach-Object {[void]$ListView2_PageLB.Items.Add($_)}
}
function Button_PagePB {
$ListView1_PagePB.Items.Clear()
$ListView2_PagePB.Items.Clear()
$PathCheck = "$PSScriptRoot\\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePB.Items.Add($_)}
$PathCheck = "$PSScriptRoot\\project1"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\project1"
Get-ChildItem -Path "$FilePath" -Name | ForEach-Object {[void]$ListView2_PagePB.Items.Add($_)}}
}
function Button_PageBC {
$DropBox3_PageBC.Items.Clear();$DropBox3_PageBC.Items.Add("Refresh");$DropBox3_PageBC.Text = "Select Disk"
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
if (Test-Path -Path $FilePath\$($DropBox1_PageBC.SelectedItem)) {$null} else {$DropBox1_PageBC.SelectedItem = $null}
$ListView1_PageBC.Items.Clear();Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageBC.Items.Add($_)}
if ($($DropBox1_PageBC.SelectedItem)) {$null} else {
$DropBox1_PageBC.ResetText();$DropBox1_PageBC.Items.Clear();$DropBox1_PageBC.Text = "Select .vhdx"
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageBC.Items.Add($_)}}
$PathCheck = "$PSScriptRoot\\cache\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\cache"} else {$FilePath = "$PSScriptRoot"}
if (Test-Path -Path $FilePath\$($DropBox2_PageBC.SelectedItem)) {$null} else {$DropBox2_PageBC.SelectedItem = $null}
if ($($DropBox2_PageBC.SelectedItem)) {$null} else {$empty = $true;
$DropBox2_PageBC.ResetText();$DropBox2_PageBC.Items.Clear()
Get-ChildItem -Path "$FilePath\*.jpg" -Name | ForEach-Object {$empty = $false;[void]$DropBox2_PageBC.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.png" -Name | ForEach-Object {$empty = $false;[void]$DropBox2_PageBC.Items.Add($_)}}
[void]$DropBox2_PageBC.Items.Add("Import Wallpaper")}
function Button_PageSC {
if ($($DropBox1_PageSC.SelectedItem)) {$null} else {$DropBox1_PageSC.ResetText();$DropBox1_PageSC.Items.Clear();
$key = Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont"
#$key.GetValueNames() | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}
$key.GetValueNames() | ForEach-Object {$key.GetValue($_) | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}}
$DropBox1_PageSC.SelectedItem = "$ConsoleFont"
}
if ($($DropBox2_PageSC.SelectedItem)) {$null} else {$DropBox2_PageSC.ResetText();$DropBox2_PageSC.Items.Clear();
$DropBox2_PageSC.Items.Add("Auto");$DropBox2_PageSC.Items.Add("2");$DropBox2_PageSC.Items.Add("4");$DropBox2_PageSC.Items.Add("6");$DropBox2_PageSC.Items.Add("8");$DropBox2_PageSC.Items.Add("10");$DropBox2_PageSC.Items.Add("12");$DropBox2_PageSC.Items.Add("14");$DropBox2_PageSC.Items.Add("16");$DropBox2_PageSC.Items.Add("18");$DropBox2_PageSC.Items.Add("20");$DropBox2_PageSC.Items.Add("22");$DropBox2_PageSC.Items.Add("24");$DropBox2_PageSC.Items.Add("26");$DropBox2_PageSC.Items.Add("28");$DropBox2_PageSC.Items.Add("30");$DropBox2_PageSC.Items.Add("32");$DropBox2_PageSC.Items.Add("36");$DropBox2_PageSC.Items.Add("40");$DropBox2_PageSC.Items.Add("44");$DropBox2_PageSC.Items.Add("48");$DropBox2_PageSC.Items.Add("52");$DropBox2_PageSC.Items.Add("56");$DropBox2_PageSC.Items.Add("60");$DropBox2_PageSC.Items.Add("64");$DropBox2_PageSC.Items.Add("68");$DropBox2_PageSC.Items.Add("72");}
#$DropBox1_PageSC.Items.Add("Consolas");$DropBox1_PageSC.Items.Add("Courier New");$DropBox1_PageSC.Items.Add("Lucida Console")
$DropBox2_PageSC.SelectedItem = "$ConsoleFontSize"
}
function ImportBoot {
$PathCheck = "$PSScriptRoot\\boot";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\boot"} else {$FilePath = "$PSScriptRoot"}
$PathCheckX = "$FilePath\\boot.sav";if (Test-Path -Path $PathCheckX) {$result = [System.Windows.Forms.MessageBox]::Show("Boot media already exists.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)} else {
$FileFilt = "ISO files (*.iso)|*.iso";PickFile
if ($Pick) {
$Image = Mount-DiskImage -ImagePath "$Pick" -PassThru
$drvLetter = ($Image | Get-Volume).DriveLetter
$PathCheck = "$drvLetter`:\sources\boot.wim";if (Test-Path -Path $PathCheck) {
$source = "$PathCheck";$target = "$FilePath"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Rename-Item -Path "$FilePath\boot.wim" -NewName "boot.sav"}
Dismount-DiskImage -DevicePath $Image.DevicePath} else {$null}}
}
function ImportWim {
$DropBox1_PageW2V.SelectedItem = $null;$DropBox2_PageW2V.SelectedItem = $null;$DropBox2_PageW2V.Items.Clear();$ListView1_PageW2V.Items.Clear();
$FileFilt = "ISO files (*.iso)|*.iso";PickFile
if ($Pick) {
$Image = Mount-DiskImage -ImagePath "$Pick" -PassThru
$drvLetter = ($Image | Get-Volume).DriveLetter
$PathCheck = "$PSScriptRoot\\image"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
$source = "$drvLetter`:\sources\install.wim";$target = "$FilePath"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Dismount-DiskImage -DevicePath $Image.DevicePath}
Button_PageW2V
}
function ImportWallpaper {
$DropBox2_PageBC.SelectedItem = $null
$FileFilt = "Picture files (*.jpg;*.png)|*.jpg;*.png";PickFile
if ($Pick) {
$PathCheck = "$PSScriptRoot\\cache"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\cache"} else {$FilePath = "$PSScriptRoot"}
$source = "$Pick";$target = "$FilePath"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Dismount-DiskImage -DevicePath $Image.DevicePath}
Button_PageBC
}
function Dropbox3BC {
$ListView1_PageBC.Items.Clear();$ListView1_PageBC.Items.Add("Querying disks...")
$DropBox3_PageBC.Items.Clear();
$disks = Get-Disk | Sort-Object -Property Number
$ListView1_PageBC.Items.Clear();foreach ($disk in $disks) {
#$diskModel = $disk.Model;#$diskID = $disk.UniqueID;#$diskSerialNumber = $disk.SerialNumber
$diskNumber = $disk.Number;$diskSize = $disk.Size / 1073741824;$diskSize = [Math]::Floor($diskSize)
$PathCheck = "$PSScriptRoot\\`$DSK";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\`$DSK" -Force}
Add-Content -Path "$PSScriptRoot\`$DSK" -Value "select disk $diskNumber" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\`$DSK" -Value "detail disk" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\`$DSK" -Value "exit" -Encoding UTF8
$diskpart = DISKPART /S "$PSScriptRoot\`$DSK";Remove-Item -Path "$PSScriptRoot\`$DSK" -Force
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
if ($diskreason) {$diskreason = "`|$diskreason"} else {$DropBox3_PageBC.Items.Add("Disk $diskNumber `| $name `| $vols`| $diskSize GB")}
$ListView1_PageBC.Items.Add("Disk $diskNumber `| $name `| $vols`| $diskSize GB $diskreason")}
$DropBox3_PageBC.Items.Add("Refresh");}
function Dropbox1W2V {
if ($DropBox1_PageW2V.SelectedItem) {if ($DropBox1_PageW2V.SelectedItem -ne 'Import Installation Media') {
$DropBox2_PageW2V.Items.Clear()
$ListView1_PageW2V.Items.Clear()
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
$command = DISM.EXE /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"$FilePath\$($DropBox1_PageW2V.SelectedItem)"
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
#$item.SubItems.Add($file.Length)
#$item.SubItems.Add($file.Extension)
#$listView.Items.Add($item)
[void]$ListView1_PageW2V.Items.Add($column2)
}}
if ($column2) {$null} else {$DropBox2_PageW2V.Items.Add("1");[void]$ListView1_PageW2V.Items.Add("Index : 1");[void]$ListView1_PageW2V.Items.Add("<no information>")}
$DropBox2_PageW2V.SelectedItem = "1"
}}
}
function Dropbox1V2W {
$DropBox2_PageV2W.Items.Clear()
$ListView1_PageV2W.Items.Clear();#$DropBox2_PageV2W.Text = '1'
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
$command = DISM.EXE /ENGLISH /GET-IMAGEINFO /IMAGEFILE:"$FilePath\$($DropBox1_PageV2W.SelectedItem)" /INDEX:1
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
if ($column2) {$null} else {$DropBox2_PageV2W.Items.Add("1");[void]$ListView1_PageV2W.Items.Add("Index : 1");[void]$ListView1_PageV2W.Items.Add("<no information>")}
$DropBox2_PageV2W.SelectedItem = "1"
}
function Dropbox1SC {
$global:ConsoleFont = "$($DropBox1_PageSC.SelectedItem)";[WinMekanix]::SetConsoleFont("$ConsoleFont", "$ConsoleFontSizeX");Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_CONFONT=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8}
function Dropbox2SC {
$global:ConsoleFontSize = "$($DropBox2_PageSC.SelectedItem)"
if ($ConsoleFontSize -eq 'Auto') {$ConsoleFontSizeX = $ScaleFont} else {$ConsoleFontSizeX = $ConsoleFontSize}
[WinMekanix]::SetConsoleFont("$ConsoleFont", "$ConsoleFontSizeX");Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_CONFONTSIZE=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8}
function LBX_Stage1 {$global:LBX_Stage = 1;
$ListView1_PageLBX.GridLines = $false
$ListView1_PageLBX.CheckBoxes = $false # Enable checkboxes
$ListView1_PageLBX.FullRowSelect = $true # Select the entire row when an item is selected
$ListView1_PageLBX.Items.Clear();
# Add columns to the ListView1_PageLBX
# Add items to the ListView1_PageLBX
$item1 = New-Object System.Windows.Forms.ListViewItem("Misc")
#$item1.SubItems.Add("Description for Misc")
$ListView1_PageLBX.Items.Add($item1)
$PathCheck = "$PSScriptRoot\\list"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.base" -Name | ForEach-Object {[void]$ListView1_PageLBX.Items.Add($_)}
#$listViewSelect = $listView.SelectedItems
#$listViewFocused = $listView.FocusedItem
#Write-Host "sel:$listViewSelect  foc:$listViewFocused"
}
function LBX_Stage2 {$global:LBX_Stage = 2;
$GRP = $null;if ($marked -ne $null) {$global:listViewSelectS2 = $marked} else {$global:listViewSelectS2 = $ListView1_PageLBX.FocusedItem}
if ($listViewSelectS2 -eq 'Misc') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Selected misc.'}
if ($listViewSelectS2 -ne 'Misc') {
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
$parta, $global:BaseFile, $partc = $listViewSelectS2 -split '[{}]'
$ListView1_PageLBX.Items.Clear();Get-Content "$FilePath\$BaseFile" | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh = $_ -split "[][]"
if ($partXb -eq 'GROUP') {if (-not ($partXd -eq $GRP)) {
$GRP = "$partXd"
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXd")
#$item1.SubItems.Add("$partXf")
$ListView1_PageLBX.Items.Add($item1)}}}
}
$ListView1_PageLBX.GridLines = $false
$ListView1_PageLBX.CheckBoxes = $false # Enable checkboxes
$ListView1_PageLBX.FullRowSelect = $true # Select the entire row when an item is selected
}
function LBX_Stage3 {$global:LBX_Stage = 3;
if ($marked -ne $null) {$global:listViewSelectS3 = $marked} else {$global:listViewSelectS3 = $ListView1_PageLBX.FocusedItem}
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
$parta, $global:listViewFocus, $partc = $listViewSelectS3 -split '[{}]'
$ListView1_PageLBX.Items.Clear();Get-Content "$FilePath\$BaseFile" | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[][]"
if ($partXb -eq 'GROUP') {
if ($partXd -eq $listViewFocus) {
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXf");$item1.SubItems.Add("$partXg");$ListView1_PageLBX.Items.Add($item1)}}}
$ListView1_PageLBX.GridLines = $false;$ListView1_PageLBX.CheckBoxes = $true;$ListView1_PageLBX.FullRowSelect = $true
}
function LBX_Stage4 {$global:LBX_Stage = 4;
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LSTZ"} else {$FilePathLST = "$PSScriptRoot\`$LSTZ"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
#$checkedItems = $ListView1_PageLBX.CheckedItems | ForEach-Object { $_.Text }
#[System.Windows.Forms.MessageBox]::Show(("Checked Items: " + ($checkedItems -join ", ")), "Checked Items")
$global:checkedItems = $ListView1_PageLBX.CheckedItems | ForEach-Object {$listWrite = 0
$parta, $listViewChecked, $partc = $_ -split '[{}]'
Get-Content "$FilePath\$BaseFile" | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[][]"
if ($partXb -eq 'GROUP') {if ($partXd -ne $listViewFocus) {$listWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXf -ne $listViewChecked) {$listWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXd -eq $listViewFocus) {if ($partXf -eq $listViewChecked) {$listWrite = 1}}}
if ($listWrite -eq '1') {Add-Content -Path "$FilePathLST" -Value "$_" -Encoding UTF8}}}
$ListView1_PageLBX.CheckBoxes = $false;$ListView1_PageLBX.Items.Clear();$ListView1_PageLBX.Items.Add("Create New List")
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBX.Items.Add($_)}
}
function LBX_Stage5 {
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$listViewSelectS5 = $ListView1_PageLBX.FocusedItem
$parta, $partb, $partc = $listViewSelectS5 -split '[{}]'
if ($partb -eq 'Create New List') {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name'
if ($boxresult -ne "OK") {$ListName = "$null";}
if ($boxresult -eq "OK") {$ListName = "$promptout.list";$ListTarget = "$FilePath\$promptout.list";if (Test-Path -Path $ListTarget) {$null} else {Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8}}
}
if ($partb -ne 'Create New List') {$ListName = "$partb";$ListTarget = "$FilePath\$partb"}
Get-Content "$FilePath\`$LSTZ" | ForEach-Object {Add-Content -Path "$ListTarget" -Value "$_" -Encoding UTF8}
$PathCheck = "$FilePath\`$LSTZ";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePath\`$LSTZ" -Force}

if ($ListName -ne "$null") {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options added to $ListName"}
$global:LBX_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBX.Visible = $false
}
#Get-Content "$PSScriptRoot\windick.ini" | ForEach-Object {[void]$ListView1_PageSC.Items.Add($_)}
#Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Property | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}
#Get-ChildItem | Select-Object Name, Length, Extension
#Get-ChildItem -Path "$FilePath\*.*" -Name | ForEach-Object {[void]$DropBox1_PagePB.Items.Add($_)}
#GetProcess | Select-Object -Property Name, WorkingSet, PeakWorkingSet | Sort-Object -Property WorkingSet -Descending | Out-GridView
#InvokeCommand -ComputerName S1, S2, S3 -ScriptBlock {Get-Culture} | Out-GridView
#ForEach ($i in Get-Content "c:\$\test.txt") {[void]$listview.Items.Add($i)}
#ForEach ($line in $command) {$textBox.AppendText("$line`r`n")}  
#ForEach ($i in @('a','b','c')) {[void]$listview.Items.Add($i)}
function AddElement {
if ($Page -eq 'PageW2V') {$PageW2V.Controls.Add($element)}
if ($Page -eq 'PageV2W') {$PageV2W.Controls.Add($element)}
if ($Page -eq 'PageLB') {$PageLB.Controls.Add($element)}
if ($Page -eq 'PagePB') {$PagePB.Controls.Add($element)}
if ($Page -eq 'PageBC') {$PageBC.Controls.Add($element)}
if ($Page -eq 'PageSC') {$PageSC.Controls.Add($element)}
if ($Page -eq 'PageSplash') {$PageSplash.Controls.Add($element)}
if ($Page -eq 'PageConsole') {$PageConsole.Controls.Add($element)}
if ($Page -eq 'PageDebug') {$PageDebug.Controls.Add($element)}
if ($Page -eq 'PageLBX') {$PageLBX.Controls.Add($element)}
if ($Page -eq 'PageMain') {$PageMain.Controls.Add($element)}}
function LoadSettings {
$LoadINI = Get-Content -Path "$PSScriptRoot\\windick.ini" | Select-Object -Skip 1
$Settings = $LoadINI | ConvertFrom-StringData
$global:ScaleFactor = $Settings.GUI_SCALE
$global:ConsoleFont = $Settings.GUI_CONFONT
$global:ConsoleType = $Settings.GUI_CONTYPE
$global:ConsoleFontSize = $Settings.GUI_CONFONTSIZE}
function Launch-CMD {
param([int]$X,[int]$Y,[int]$H,[int]$W)
$WSIZ = [int]($W * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($H * $ScaleRef * $ScaleFactor)
$XLOC = [int]($X * $ScaleRef * $ScaleFactor)
$YLOC = [int]($Y * $ScaleRef * $ScaleFactor)
$PageMain.Visible = $false;$PageBlank.Visible = $true;$PageBlank.BringToFront()
$PathCheck = "$env:temp\\`$CON";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$env:temp\`$CON" -Force}
Add-Content -Path "$env:temp\`$CON" -Value "$PSScriptRoot" -Encoding UTF8
Add-Content -Path "$env:temp\`$CON" -Value "ConsoleFont=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$env:temp\`$CON" -Value "ConsoleFontSize=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8
if ($ButtonRadio1_Group2.Checked) {Add-Content -Path "$env:temp\`$CON" -Value "ScaleFactor=0.75" -Encoding UTF8}
if ($ButtonRadio2_Group2.Checked) {Add-Content -Path "$env:temp\`$CON" -Value "ScaleFactor=1.00" -Encoding UTF8}
if ($ButtonRadio3_Group2.Checked) {Add-Content -Path "$env:temp\`$CON" -Value "ScaleFactor=1.25" -Encoding UTF8}
if ($ButtonRadio1_Group1.Checked -eq $true) {$ConsoleType = 'Embed'} else {$ConsoleType = 'Spawn'}
$CMDWindow = Start-Process "PowerShell" -PassThru -ArgumentList "-WindowStyle", "Hidden", "-Command", {
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
[WinMekanix]::SetConsoleFont('Consolas', 1)
$PSScriptRoot = Get-Content -Path \"$env:temp\\`$CON\" -TotalCount 1
$LoadINI = Get-Content -Path \"$env:temp\\`$CON\" | Select-Object -Skip 1
$Settings = $LoadINI | ConvertFrom-StringData
$ScaleFactor = $Settings.ScaleFactor
$ConsoleFont = $Settings.ConsoleFont
$ConsoleFontSize = $Settings.ConsoleFontSize
$DimensionX = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$DimensionY = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$RefX = 1000;$DimScaleX = $DimensionX / $RefX
$RefY = 1000;$DimScaleY = $DimensionY / $RefY
if ($DimScaleX -ge $DimScaleY) {$ScaleRef = $DimScaleY}
if ($DimScaleY -ge $DimScaleX) {$ScaleRef = $DimScaleX}
if ($ScaleFactor) {$null} else {$ScaleFactor = 1.00}
$ScaleFont = 28 * $ScaleRef * $ScaleFactor
$ScaleFontX = [Math]::Floor($ScaleFont);$ScaleFont = $ScaleFontX
if ($ConsoleFont) {$null} else {$ConsoleFont = 'Consolas'}
if ($ConsoleFontSize) {$null} else {$ConsoleFontSize = 'Auto'}
if ($ConsoleFontSize -eq 'Auto') {$ConsoleFontSizeX = $ScaleFont} else {$ConsoleFontSizeX = $ConsoleFontSize}
[WinMekanix]::SetConsoleFont("$ConsoleFont", "$ConsoleFontSizeX")
CLS;Write-Host "$DimensionX x $DimensionY  Ref:$ScaleRef  FontSize:$ConsoleFontSizeX"
Start-Process \"$env:comspec\" -Wait -NoNewWindow -ArgumentList "/c", \"$PSScriptRoot\windick.cmd\", "-EXTERNAL"
$PathCheck = \"$env:temp\\`$CON\";if (Test-Path -Path $PathCheck) {Remove-Item -Path \"$env:temp\`$CON\" -Force}
if ($PAUSE_END -eq '1') {pause}}
#$process = Get-Process xyz.exe;Wait-Process -Id $process.Id
$CMDHandle = $CMDWindow.MainWindowHandle;#$CMDHandleX = $CMDWindow.Handle;
do {$CMDHandle = $CMDWindow.MainWindowHandle;Start-Sleep -Milliseconds 100} until ($CMDHandle -ne 0)
$global:CMDProcessId = $CMDWindow.Id;$PanelHandle = $PageConsole.Handle
#if ($CMDWindow) {$CMDHandle = $CMDWindow.MainWindowHandle;$processId = 0;$threadId = [WinMekanix.Functions]::GetWindowThreadProcessId($CMDHandle, [ref]$processId)
#if ($processId -gt 0) {Write-Host "ProcessId:" $processId} else {Write-Host "ERROR1"}} else {Write-Host "ERROR2"}
$getproc = Get-ChildProcesses $CMDProcessId | Select ProcessId, Name, ParentProcessId
$part1, $part2, $part3 = $getproc -split ";";$part4 = $part1 -split ";";$global:SubProcessId = $part4 -Split "@{ProcessId="
Write-Host "Starting ProcessId: $CMDProcessId SubProcessId:$SubProcessId."
if ($ConsoleType -eq 'Embed') {[WinMekanix.Functions]::SetParent($CMDHandle, $PanelHandle)}
#do {Start-Sleep -Milliseconds 100} until (Test-Path -Path "$env:temp\\`$CON")
do {Start-Sleep -Milliseconds 100} until (-not (Test-Path -Path "$env:temp\\`$CON"))
if ($ConsoleType -eq 'Embed') {[WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 1);[WinMekanix.Functions]::MoveWindow($CMDHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)}
$PageBlank.Visible = $false;$PageConsole.Visible = $true;$PageConsole.BringToFront()
[WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 3);}
#############################################################################
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[VOID][System.Windows.Forms.Application]::EnableVisualStyles()
[VOID][System.Text.Encoding]::Unicode;LoadSettings
[WinMekanix.Functions]::SetProcessDPIAware();#[WinMekanix.Functions]::GetParent($PSProcessId)
$sysltr, $nullx = $env:SystemDrive -split '[:]';$progltr, $nullx = $PSScriptRoot -split '[:]'
$PSHandle = [WinMekanix.Functions]::GetConsoleWindow();[WinMekanix.Functions]::ShowWindowAsync($PSHandle, 2);
$STDOutputHandle = [WinMekanix.Functions]::GetStdHandle([WinMekanix.Functions]::STD_OUTPUT_HANDLE)
Write-Host "ProcessId: $PID Handle: $PSHandle STDOut:$STDOutputHandle";#Write-Host "PS handle: $($PSHandle.ToInt32())"
$DimensionX = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$DimensionY = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
$DimensionVX = [System.Windows.Forms.SystemInformation]::VirtualScreen.Width
$DimensionVY = [System.Windows.Forms.SystemInformation]::VirtualScreen.Height
$RawUIMAX = $host.UI.RawUI.MaxWindowSize
if ($ScaleFactor) {$null} else {$ScaleFactor = 1.00}
$RefX = 1000;$DimScaleX = $DimensionX / $RefX
$RefY = 1000;$DimScaleY = $DimensionY / $RefY
if ($DimScaleX -ge $DimScaleY) {$ScaleRef = $DimScaleY}
if ($DimScaleY -ge $DimScaleX) {$ScaleRef = $DimScaleX}
$ScaleFont = 0 * $ScaleRef * $ScaleFactor
$ScaleFontX = [Math]::Floor($ScaleFont);$ScaleFont = $ScaleFontX
if ($ConsoleFont) {$null} else {$ConsoleFont = 'Consolas'}
if ($ConsoleFontSize) {$null} else {$ConsoleFontSize = 'Auto'}
if ($ConsoleFontSize -eq 'Auto') {$ConsoleFontSizeX = $ScaleFont} else {$ConsoleFontSizeX = $ConsoleFontSize}
#Write-Host "$DimensionX x $DimensionY  Ref:$ScaleRef  FontSize:$ConsoleFontSizeX"
[WinMekanix]::SetConsoleFont("$ConsoleFont", "$ConsoleFontSizeX")
#REG ADD "HKCU\Console" /V "FontSize" /T REG_DWORD /D "$ScaleFont" /F
#Set-ItemProperty -Path "HKCU:\Console" -Name "FontSize" -Value "$ScaleFont"
#$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(100, 1000)
#$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(30, 34)
#Write-Error "ERROR: $([System.Runtime.InteropServices.Marshal]::GetLastWin32Error())"
#Remove-Item -Path "$env:temp\`$CON" -Recurse
$PathCheck = "$PSScriptRoot\\`$LSTZ";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\`$LSTZ" -Force}
$PathCheck = "$PSScriptRoot\\list\\`$LSTZ";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\list\`$LSTZ" -Force}
$PathCheck = "$PSScriptRoot\\`$DSK";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\`$DSK" -Force}
$PathCheck = "$env:temp\\`$CON";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$env:temp\`$CON" -Force}
######################
#Form and panels
$form = New-Object Windows.Forms.Form
$form.SuspendLayout()
$version = Get-Content -Path "$PSScriptRoot\\windick.ps1" -TotalCount 1;
$part1, $part2 = $version -split " v ";$part3, $part4 = $part2 -split " ";
$form.Text = "Windows Deployment Image Customization Kit v$part3"
$WSIZ = [int]($RefX * $ScaleRef * $ScaleFactor)
$HSIZ = [int]($RefY * $ScaleRef * $ScaleFactor)
$fontX = [int](9.5 * $ScaleFactor);$fontX = [Math]::Floor($fontX);

$form.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
#$form.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$form.ClientSize = New-Object System.Drawing.Size($WSIZ,$HSIZ)
$form.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$form.StartPosition = 'CenterScreen'
#$form.ControlBox = $False
$form.MaximizeBox = $false
$form.MinimizeBox = $true
$form.add_FormClosing({$action = $_
if (-not ($NoExitPrompt)) {MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Close' -MessageBoxText 'Are you sure you want to close?'
if ($boxresult -ne "OK") {$action.Cancel = $true}
if ($boxresult -eq "OK") {Stop-Process -Id $SubProcessId -Force -ErrorAction SilentlyContinue;Stop-Process -Id $CMDProcessId -Force -ErrorAction SilentlyContinue}}})
$form.FormBorderStyle = 'FixedDialog';#FixedDialog, FixedSingle, Fixed3D
$form.AutoSize = $true
$form.AutoSizeMode = 'GrowAndShrink';#AutoSizeMode: GrowAndShrink, GrowOnly, and ShrinkOnly.
$form.AutoScale = $true
#$form.AutoScaleMode = 'DPI';#DPI, Font, and None.
#$form.AutoScaleDimensions =  New-Object System.Drawing.SizeF(96, 96)
#$form.AutoScaleMode = System.Windows.Forms.AutoScaleMode.DPI
$form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$WindowState = 'Normal'
#$form.Add_Resize({[WinMekanix.Functions]::MoveWindow($PanelHandle, 0, 0, $Panel.Width, $Panel.Height, $true) | Out-Null})
$PageMain = NewPanel -C '25' -X '0' -Y '0' -W '1000' -H '666'
$PageSplash = NewPanel -C '51' -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageSplash)
$PageW2V = NewPanel -C '51' -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageW2V);$PageW2V.Visible = $false
$PageV2W = NewPanel -C '51' -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageV2W);$PageV2W.Visible = $false
$PageLB = NewPanel -C '51' -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageLB);$PageLB.Visible = $false
$PagePB = NewPanel -C '51' -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PagePB);$PagePB.Visible = $false
$PageBC = NewPanel -C '51' -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageBC);$PageBC.Visible = $false
$PageSC = NewPanel -C '51' -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageSC);$PageSC.Visible = $false
$PageLBX = NewPanel -C '25' -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageLBX);$PageLBX.Visible = $false;
$PageBlank = NewPanel -C '25' -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageBlank);$PageBlank.Visible = $false
$PageDebug = NewPanel -C '25' -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageDebug);$PageDebug.Visible = $false;
$PageConsole = NewPanel -C '25' -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageConsole);$PageConsole.Visible = $false;
$WSIZ = [int](1000 * $ScaleRef * $ScaleFactor)
$HSIZ = [int](666 * $ScaleRef * $ScaleFactor)
$XLOC = [int](0 * $ScaleRef * $ScaleFactor)
$YLOC = [int](0 * $ScaleRef * $ScaleFactor)
$PSHandle = [WinMekanix.Functions]::GetConsoleWindow();$PanelHandle = $PageDebug.Handle;[WinMekanix.Functions]::SetParent($PSHandle, $PanelHandle);[WinMekanix.Functions]::ShowWindowAsync($PSHandle, 1);[WinMekanix.Functions]::MoveWindow($PSHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)

$Button_V2W = NewPageButton -X '10' -Y '60' -W '230' -H '65' -C '0' -Text 'Image Processing';$Button_V2W.Visible = $false
$Button_W2V = NewPageButton -X '10' -Y '60' -W '230' -H '65' -C '0' -Text 'Image Processing'
$Button_LB = NewPageButton -X '10' -Y '180' -W '230' -H '65' -C '0' -Text 'Image Management'
$Button_PB = NewPageButton -X '10' -Y '180' -W '230' -H '65' -C '0' -Text 'Image Management';$Button_PB.Visible = $false
$Button_BC = NewPageButton -X '10' -Y '420' -W '230' -H '65' -C '0' -Text 'Boot Creator'
$Button_SC = NewPageButton -X '10' -Y '540' -W '230' -H '65' -C '0' -Text 'Settings'

#$explorer = New-Object -ComObject Shell.Explorer
#$explorerControl = New-Object System.Windows.Forms.Control
#$explorerControl.Handle = $explorer.HWND
#$explorerControl.Width = $PageBC.ClientSize.Width
#$explorerControl.Height = $PageBC.ClientSize.Height
#$explorerControl.Anchor = "Top,Bottom,Left,Right"
#$PageBC.Controls.Add($explorer)
#$PageBC.Controls.Add($explorerControl)
#$explorer.Navigate("C:\") # Specify the initial directory
#$PageBC.Add_Shown({$explorerControl.Activate()})

$Page = 'PageSplash';$Label0_PageSplash = NewLabel -X '75' -Y '35' -W '625' -H '50' -Bold 'True' -TextSize '24' -Text 'Welcome to GUI v0.4'
$Button1_PageSplash = NewButton -X '425' -Y '585' -W '300' -H '60' -Text 'About' -Hover_Text 'About' -Add_Click {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Documentation' -MessageBoxText '     github.com/joshuacline'}
$Button2_PageSplash = NewButton -X '25' -Y '585' -W '300' -H '60' -Text 'Switch to CMD' -Hover_Text 'Switch to CMD' -Add_Click {
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_LAUNCH=DISABLED" -Encoding UTF8
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}

$Page = 'PageW2V';$Label0_PageW2V = NewLabel -X '15' -Y '10' -W '625' -H '50' -Bold 'True' -TextSize '24' -Text 'Image Processing'
$ListView1_PageW2V = NewListView -X '25' -Y '85' -W '700' -H '325';$WSIZ = [int](690 * $ScaleRef * $ScaleFactor);$ListView1_PageW2V.Columns.Add("X", $WSIZ)
$Button1_PageW2V = NewButton -X '225' -Y '585' -W '300' -H '60' -Text 'Convert' -Hover_Text 'Start Image Conversion' -Add_Click {$halt = $null
if ($($DropBox1_PageW2V.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No wim selected.'}
if ($halt -ne '1') {
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-IMAGEPROC" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-WIM" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=$($DropBox1_PageW2V.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG4=-INDEX" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=$($DropBox2_PageW2V.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG6=-VHDX" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG7=$($TextBox1_PageW2V.Text)" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG8=-SIZE" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG9=$($TextBox2_PageW2V.Text)" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

$Label1_PageW2V = NewLabel -X '100' -Y '420' -W '175' -H '30' -Text 'Source Image'
$DropBox1_PageW2V = NewDropBox -X '25' -Y '455' -W '300' -H '40' -C '0' -DisplayMember 'Name' -Text 'Page 1'
$Label2_PageW2V = NewLabel -X '500' -Y '420' -W '175' -H '30' -Text 'Source Index'
$DropBox2_PageW2V = NewDropBox -X '425' -Y '455' -W '300' -H '40' -C '0' -DisplayMember 'Description'
$Label3_PageW2V = NewLabel -X '100' -Y '500' -W '175' -H '30' -Text 'Target Image'
$TextBox1_PageW2V = NewTextBox -X '25' -Y '535' -W '300' -H '40'
$Label4_PageW2V = NewLabel -X '485' -Y '500' -W '205' -H '30' -Text 'VHDX Size (GB)'
$TextBox2_PageW2V = NewTextBox -X '425' -Y '535' -W '300' -H '40'

$Page = 'PageV2W';$Label0_PageV2W = NewLabel -X '15' -Y '10' -W '625' -H '50' -Bold 'True' -TextSize '24' -Text 'Image Processing'
$ListView1_PageV2W = NewListView -X '25' -Y '85' -W '700' -H '325';$WSIZ = [int](690 * $ScaleRef * $ScaleFactor);$ListView1_PageV2W.Columns.Add("X", $WSIZ)
$Button1_PageV2W = NewButton -X '225' -Y '585' -W '300' -H '60' -Text 'Convert' -Hover_Text 'Start Image Conversion' -Add_Click {$halt = $null
if ($($DropBox1_PageV2W.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No vhdx selected.'}
if ($halt -ne '1') {
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-IMAGEPROC" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-VHDX" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=$($DropBox1_PageV2W.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG4=-INDEX" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=$($DropBox2_PageV2W.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG6=-WIM" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG7=$($TextBox1_PageV2W.Text)" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG8=-XLVL" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG9=$($DropBox3_PageV2W.SelectedItem)" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

$Label1_PageV2W = NewLabel -X '100' -Y '420' -W '175' -H '30' -Text 'Source Image'
$DropBox1_PageV2W = NewDropBox -X '25' -Y '455' -W '300' -H '40' -C '0' -DisplayMember 'Name'
$Label2_PageV2W = NewLabel -X '500' -Y '420' -W '175' -H '30' -Text 'Source Index'
$DropBox2_PageV2W = NewDropBox -X '425' -Y '455' -W '300' -H '40' -DisplayMember 'Description'
$Label3_PageV2W = NewLabel -X '100' -Y '500' -W '175' -H '30' -Text 'Target Image'
$TextBox1_PageV2W = NewTextBox -X '25' -Y '535' -W '300' -H '40'
$Label4_PageV2W = NewLabel -X '485' -Y '500' -W '205' -H '30' -Text '   Compression'
$DropBox3_PageV2W = NewDropBox -X '425' -Y '535' -W '300' -H '40' -C '0' -DisplayMember 'Description'

$Page = 'PageLB';$Label0_PageLB = NewLabel -X '15' -Y '10' -W '625' -H '50' -Bold 'True' -TextSize '24' -Text 'Image Management'
$ListView1_PageLB = NewListView -X '25' -Y '85' -W '335' -H '400';$WSIZ = [int](330 * $ScaleRef * $ScaleFactor);$ListView1_PageLB.Columns.Add("X", $WSIZ)
$ListView2_PageLB = NewListView -X '390' -Y '85' -W '335' -H '400';$WSIZ = [int](330 * $ScaleRef * $ScaleFactor);$ListView2_PageLB.Columns.Add("X", $WSIZ)
$Button1_PageLB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text 'List Execute' -Hover_Text 'List Execute' -Add_Click {
#$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
#$FileFilt = "List files (*.list)|*.list";PickFile;if ($Pick) {
#Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
#Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-IMAGEMGR" -Encoding UTF8
#Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-RUNEXT" -Encoding UTF8
#Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=-LIST" -Encoding UTF8
#Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG4=$Pick" -Encoding UTF8
#Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=-LIVE" -Encoding UTF8
#Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-INTERNAL" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-IMAGEMGR" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=-RUN" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}
$Button2_PageLB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text 'List Builder' -Hover_Text 'List Builder' -Add_Click {LBX_Stage1;$PageLBX.Visible = $true;$PageMain.Visible = $false;$PageLB.Visible = $false;$PageLBX.BringToFront()}

$Button3_PageLB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text 'Edit List' -Hover_Text 'Edit List' -Add_Click {
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$FileFilt = "List files (*.list;*.base)|*.list;*.base";PickFile
if ($Pick) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$Pick"}}

$Page = 'PagePB';$Label0_PagePB = NewLabel -X '15' -Y '10' -W '625' -H '50' -Bold 'True' -TextSize '24' -Text 'Image Management'
$ListView1_PagePB = NewListView -X '25' -Y '85' -W '335' -H '400';$WSIZ = [int](330 * $ScaleRef * $ScaleFactor);$ListView1_PagePB.Columns.Add("X", $WSIZ)
$ListView2_PagePB = NewListView -X '390' -Y '85' -W '335' -H '400';$WSIZ = [int](330 * $ScaleRef * $ScaleFactor);$ListView2_PagePB.Columns.Add("X", $WSIZ)
$Button0_PagePB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text 'Pack Execute' -Hover_Text 'Pack Execute' -Add_Click {
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-INTERNAL" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-IMAGEMGR" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=-RUN" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}
$Button1_PagePB = NewButton -X '500' -Y '510' -W '225' -H '60' -Text 'New' -Hover_Text 'New' -Add_Click {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$null}
if ($boxresult  -eq "OK") {
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "MENU_SKIP=1" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "EDIT_SKIP=1" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-INTERNAL" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-PACKCREATOR" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=-NEW" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}
$Button2_PagePB = NewButton -X '25' -Y '510' -W '225' -H '60' -Text 'Restore' -Hover_Text 'Restore' -Add_Click {
$PathCheck = "$PSScriptRoot\\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
$FileFilt = "PKX files (*.pkx)|*.pkx";PickFile
if ($Pick) {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$null}
if ($boxresult  -eq "OK") {
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LSTZ"} else {$FilePathLST = "$PSScriptRoot\`$LSTZ"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\\Project1";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\Project1" -Recurse -Force}
New-Item -ItemType Directory -Path "$PSScriptRoot\Project1"
$command = @"
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"$Pick" /INDEX:1 /APPLYDIR:"$PSScriptRoot\Project1"
"@
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-IMAGEMGR" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-RUN" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=-CUSTOM" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG4=`$LSTZ" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=-LIVE" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "EXEC-LIST" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][ECHO.           %@@%PACKAGE EXTRACT START`:%`$`$%  %DATE%  %TIME%][CMD][IA]" -Encoding UTF8
#Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][ECHO.][CMD][IA]" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][$command][CMD][IA]" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][ECHO.][CMD][IA]" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][ECHO.            %@@%PACKAGE EXTRACT END`:%`$`$%  %DATE%  %TIME%][CMD][IA]" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}}
$Button3_PagePB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text 'Build Pack' -Hover_Text 'Build Pack' -Add_Click {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Package' -MessageBoxText 'Enter new .pkx package name'
if ($boxresult -ne "OK") {$action.Cancel = $true}
if ($boxresult -eq "OK") {
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LSTZ"} else {$FilePathLST = "$PSScriptRoot\`$LSTZ"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\\pack";if (Test-Path -Path $PathCheck) {$FilePathPKX = "$PSScriptRoot\pack\$promptout.pkx"} else {$FilePathPKX = "$PSScriptRoot\$promptout.pkx"}
$command = @"
DISM /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"$PSScriptRoot\Project1" /IMAGEFILE:"$FilePathPKX" /COMPRESS:Fast /NAME:"PKX" /CheckIntegrity /Verify
"@
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-IMAGEMGR" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-RUN" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=-CUSTOM" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG4=`$LSTZ" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=-LIVE" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "EXEC-LIST" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][ECHO.           %@@%PACKAGE CREATE START`:%`$`$%  %DATE%  %TIME%][CMD][IA]" -Encoding UTF8
#Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][ECHO.][CMD][IA]" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][$command][CMD][IA]" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][ECHO.][CMD][IA]" -Encoding UTF8
Add-Content -Path "$FilePathLST" -Value "[COMMANDQ][ECHO.            %@@%PACKAGE CREATE END`:%`$`$%  %DATE%  %TIME%][CMD][IA]" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}
$Button4_PagePB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text 'Edit Pack' -Hover_Text 'Edit Pack' -Add_Click {
$PathCheck = "$PSScriptRoot\\Project1\package.list";if (Test-Path -Path $PathCheck) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PathCheck"}
$PathCheck = "$PSScriptRoot\\Project1\package.cmd";if (Test-Path -Path $PathCheck) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PathCheck"}}

$Button5_PagePB = NewButton -X '275' -Y '510' -W '200' -H '60' -Text 'Export Drivers' -Hover_Text 'Export Drivers' -Add_Click {
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "MENU_SKIP=1" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-INTERNAL" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-PACKCREATOR" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=-EXPORT" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}

$Page = 'PageBC';$Label0_PageBC = NewLabel -X '15' -Y '10' -W '625' -H '50' -Bold 'True' -TextSize '24' -Text 'Boot Creator'
$ListView1_PageBC = NewListView -X '25' -Y '85' -W '700' -H '325';$WSIZ = [int](690 * $ScaleRef * $ScaleFactor);$ListView1_PageBC.Columns.Add("X", $WSIZ)
$Button1_PageBC = NewButton -X '225' -Y '585' -W '300' -H '60' -Text 'Start' -Hover_Text 'Start Boot Disk Creation' -Add_Click {$halt = $null;$nullx, $disknum, $nully = $($DropBox3_PageBC.SelectedItem) -split '[| ]'
$PathCheck = "$PSScriptRoot\\boot";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\boot"} else {$FilePath = "$PSScriptRoot"}
$PathCheckX = "$FilePath\\boot.sav";if (-not (Test-Path -Path $PathCheckX)) {ImportBoot}
if (-not (Test-Path -Path $PathCheckX)) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No boot media.'}
if ($($DropBox1_PageBC.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No vhdx selected.'}
if ($disknum -eq 'Disk') {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No disk selected.'}
if ($disknum -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No disk selected.'}
if ($halt -ne '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Erase' -MessageBoxText "This will erase Disk $disknum. If you've inserted or removed any disks, refresh before proceeding. Are you sure?"
if ($boxresult -ne "OK") {$null}
if ($boxresult  -eq "OK") {
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-BOOTMAKER" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-CREATE" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG3=-DISK" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG4=$disknum" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=-VHDX" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG6=$($DropBox1_PageBC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "PE_WALLPAPER=$($DropBox2_PageBC.SelectedItem)" -Encoding UTF8
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}}

$Label1_PageBC = NewLabel -X '100' -Y '420' -W '175' -H '30' -Text 'Active VHDX'
$DropBox1_PageBC = NewDropBox -X '25' -Y '455' -W '300' -H '40' -C '0' -DisplayMember 'Name'
$Label2_PageBC = NewLabel -X '500' -Y '420' -W '210' -H '30' -Text 'PE Wallpaper'
$DropBox2_PageBC = NewDropBox -X '425' -Y '455' -W '300' -H '40' -DisplayMember 'Description'
$Label3_PageBC = NewLabel -X '315' -Y '500' -W '175' -H '30' -Text 'Target Disk'
$DropBox3_PageBC = NewDropBox -X '25' -Y '535' -W '700' -H '40' -Text 'Select Disk'

$Page = 'PageSC';$Label0_PageSC = NewLabel -X '15' -Y '10' -W '725' -H '50' -Bold 'True' -TextSize '24' -Text 'Settings Configuration'
$Button1_PageSC = NewButton -X '25' -Y '585' -W '300' -H '60' -Text 'Console Settings' -Hover_Text 'Console Settings' -Add_Click {
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG1=-INTERNAL" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG2=-SETTINGS" -Encoding UTF8
#$TextPath = "$env:temp\`$CON";$TextWrite = [System.IO.StreamWriter]::new($TextPath, $false, [System.Text.Encoding]::UTF8);#$TextWrite.WriteLine("x");$TextWrite.Close()
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}

$Button2_PageSC = NewButton -X '425' -Y '585' -W '300' -H '60' -Text 'Debug' -Hover_Text 'Debug' -Add_Click {
$WSIZ = [int](1000 * $ScaleRef * $ScaleFactor);$HSIZ = [int](575 * $ScaleRef * $ScaleFactor)
$XLOC = [int](0 * $ScaleRef * $ScaleFactor);$YLOC = [int](0 * $ScaleRef * $ScaleFactor)
$PageDebug.Visible = $true;$PageMain.Visible = $false;$PageSC.Visible = $false;$PageDebug.BringToFront()
[WinMekanix.Functions]::ShowWindowAsync($PSHandle, 1);[WinMekanix.Functions]::MoveWindow($PSHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true);}

$GroupName = 'Group1';$GroupBox1_PageSC = NewGroupBox -X '15' -Y '85' -W '260' -H '75' -Text 'Console Window'
$Add_CheckedChanged = {if ($ButtonRadio1_Group1.Checked) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_CONTYPE=Embed" -Encoding UTF8;}}
$ButtonRadio1_Group1 = NewRadioButton -X '15' -Y '30' -W '120' -H '35' -Text 'Embed' -GroupName 'Group1'
$Add_CheckedChanged = {if ($ButtonRadio2_Group1.Checked) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_CONTYPE=Spawn" -Encoding UTF8;}}
$ButtonRadio2_Group1 = NewRadioButton -X '135' -Y '30' -W '120' -H '35' -Text 'Spawn' -GroupName 'Group1'

if ($ConsoleType) {$null} else {$ConsoleType = 'Embed'}
if ($ConsoleType -eq 'Embed') {$ButtonRadio1_Group1.Checked = $true}
if ($ConsoleType -eq 'Spawn') {$ButtonRadio2_Group1.Checked = $true}

$Label2_PageSC = NewLabel -X '25' -Y '165' -W '585' -H '35' -Text 'Console Font'
$DropBox1_PageSC = NewDropBox -X '25' -Y '200' -W '165' -H '40' -C '0' -Text "$ConsoleFont"
$Label3_PageSC = NewLabel -X '25' -Y '250' -W '585' -H '35' -Text 'Console FontSize'
$DropBox2_PageSC = NewDropBox -X '25' -Y '285' -W '165' -H '40' -C '0' -Text "$ConsoleFontSize"
#$Add_CheckedChanged = {if ($Toggle1_PageSC.Checked) {$ConsoleType = 'Spawn';$Toggle1_PageSC.Text = "Enabled";} else {$ConsoleType = 'Embed';$Toggle1_PageSC.Text = "";}}

$GroupName = 'Group2';$GroupBox2_PageSC = NewGroupBox -X '15' -Y '335' -W '325' -H '75' -Text 'GUI Scale Factor'
$Add_CheckedChanged = {if ($ButtonRadio1_Group2.Checked) {
if ($Button_SC.Tag -eq 'Enable') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Restart app for scaling changes to take effect.'}
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_SCALE=0.75" -Encoding UTF8;}}
$ButtonRadio1_Group2 = NewRadioButton -X '15' -Y '30' -W '100' -H '35' -Text '0.75' -GroupName 'Group2'
$Add_CheckedChanged = {if ($ButtonRadio2_Group2.Checked) {
if ($Button_SC.Tag -eq 'Enable') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Restart app for scaling changes to take effect.'}
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_SCALE=1.00" -Encoding UTF8;}}
$ButtonRadio2_Group2 = NewRadioButton -X '115' -Y '30' -W '100' -H '35' -Text '1.00' -GroupName 'Group2'
$Add_CheckedChanged = {if ($ButtonRadio3_Group2.Checked) {
if ($Button_SC.Tag -eq 'Enable') {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Restart app for scaling changes to take effect.'}
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_SCALE=1.25" -Encoding UTF8;}}
$ButtonRadio3_Group2 = NewRadioButton -X '215' -Y '30' -W '100' -H '35' -Text '1.25' -GroupName 'Group2'

if ($ScaleFactor) {$null} else {$ScaleFactor = 1.00}
if ($ScaleFactor -eq '1.25') {$ButtonRadio3_Group2.Checked = $true}
if ($ScaleFactor -eq '1.00') {$ButtonRadio2_Group2.Checked = $true}
if ($ScaleFactor -eq '0.75') {$ButtonRadio1_Group2.Checked = $true}

$Page = 'PageConsole';$Button1_PageConsole = NewButton -X '350' -Y '585' -W '300' -H '60' -Text 'Back' -Hover_Text 'Back' -Add_Click {
$PageMain.Visible = $true;$PageConsole.Visible = $false;
if ($Button_LB.Tag -eq 'Enable') {Button_PageLB}
if ($Button_PB.Tag -eq 'Enable') {Button_PagePB}
if ($Button_BC.Tag -eq 'Enable') {Button_PageBC}
if ($Button_SC.Tag -eq 'Enable') {Button_PageSC}
if ($Button_V2W.Tag -eq 'Enable') {Button_PageV2W}
if ($Button_W2V.Tag -eq 'Enable') {Button_PageW2V}
Write-Host "Stopping ProcessId: $CMDProcessId SubProcessId:$SubProcessId.";Stop-Process -Id $SubProcessId -Force -ErrorAction SilentlyContinue;Stop-Process -Id $CMDProcessId -Force -ErrorAction SilentlyContinue}

$Page = 'PageDebug';$Button1_PageDebug = NewButton -X '350' -Y '585' -W '300' -H '60' -Text 'Back' -Hover_Text 'Back' -Add_Click {$PageMain.Visible = $true;$PageSC.Visible = $true;$PageDebug.Visible = $false}

$Page = 'PageLBX';$Label1_PageLBX = NewLabel -X '325' -Y '15' -W '625' -H '50' -Bold 'True' -TextSize '24' -Text 'List Builder'
$Button1_PageLBX = NewButton -X '180' -Y '585' -W '300' -H '60' -Text 'Back' -Hover_Text 'Back' -Add_Click {
if ($LBX_Stage -eq '1') {$global:LBX_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBX.Visible = $false}
if ($LBX_Stage -eq '2') {LBX_Stage1}
if ($LBX_Stage -eq '3') {$global:marked = $listViewSelectS2;LBX_Stage2}
if ($LBX_Stage -eq '4') {$global:marked = $listViewSelectS3;LBX_Stage3}
if ($LBX_Stage -eq '5') {LBX_Stage4}}
$Button2_PageLBX = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next' -Hover_Text 'Next' -Add_Click {
if ($LBX_Stage -eq '4') {if ($ListView1_PageLBX.SelectedItems) {$global:marked = $null;LBX_Stage5} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBX_Stage -eq '3') {if ($ListView1_PageLBX.CheckedItems) {$global:marked = $null;LBX_Stage4} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBX_Stage -eq '2') {if ($ListView1_PageLBX.SelectedItems) {$global:marked = $null;LBX_Stage3} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBX_Stage -eq '1') {if ($ListView1_PageLBX.SelectedItems) {$global:marked = $null;LBX_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
$ListView1_PageLBX = NewListView -X '25' -Y '90' -W '950' -H '475';# -Headers 'NonClickable';#$WSIZ = [int](470 * $ScaleRef * $ScaleFactor);#$ListView1_PageLBX.Columns.Add("Item Name", $WSIZ);#$ListView1_PageLBX.Columns.Add("Description", $WSIZ)
$WSIZ = [int](940 * $ScaleRef * $ScaleFactor);$ListView1_PageLBX.Columns.Add("X", $WSIZ)
#$FilePath = "C:\gif.gif";$FileContent = Get-Content -Path "$FilePath" -Encoding Byte;$Base64Out = [System.Convert]::ToBase64String($FileContent);Write-Host "$Base64Out"#Convert
[string]$logomain=@"
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
"@

[string]$logo3=@"
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
"@
[string]$logo2=@"
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
"@
[string]$logojpgB64=@"
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
"@
$Page = 'PageMain';$pictureBase64 = $logo3;$PictureBox2_PageMain = NewPictureBox -X '15' -Y '260' -W '220' -H '145'
$Page = 'PageMain';$pictureBase64 = $logomain;$PictureBox1_PageMain = NewPictureBox -X '15' -Y '260' -W '220' -H '145'
$bgimage = Get-Random -Minimum 1 -Maximum 100;if ($bgimage -le 99) {$PictureBox1_PageMain.BringToFront()};if ($bgimage -eq 100) {$PictureBox2_PageMain.BringToFront()}
$Page = 'PageSplash';$pictureBase64 = $logojpgB64;$PictureBox1_PageSplash = NewPictureBox -X '2' -Y '125' -W '750' -H '420'
$pictureBase64 = $logo2;$PictureBox2_PageSplash = NewPictureBox -X '320' -Y '385' -W '20' -H '20';$PictureBox2_PageSplash.BringToFront()
$form.ResumeLayout()
$form.Add_Shown({$form.Activate()})
$form.ShowDialog()
$form.Dispose()
#$form.Refresh()
