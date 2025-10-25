﻿# Windows Deployment Image Customization Kit v 1211 (c) github.com/joshuacline
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
if ($MessageBoxType -eq 'Choice') {if ($MessageBoxChoices) {$parta, $partb, $partc, $partd, $parte, $partf, $partg, $parth, $parti, $partj, $partk, $partl, $partm, $partn, $parto = $MessageBoxChoices -split '[,]'}}
if ($MessageBoxType -eq 'Picker') {if ($MessageBoxChoices) {$parta1X, $partb1X, $partc1X = $MessageBoxChoices -split '[*]';$parta1 = $parta1X -replace "`"|'", "";$partb1 = $partb1X -replace "`"|'", ""}};#`"
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
if ($parta1 -eq "%LIST_FOLDER%\") {$PartMatch = 1;$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}}
if ($parta1 -eq "%IMAGE_FOLDER%\") {$PartMatch = 1;$PathCheck = "$PSScriptRoot\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}}
if ($parta1 -eq "%PACK_FOLDER%\") {$PartMatch = 1;$PathCheck = "$PSScriptRoot\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}}
if ($parta1 -eq "%CACHE_FOLDER%\") {$PartMatch = 1;$PathCheck = "$PSScriptRoot\cache";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\cache"} else {$FilePath = "$PSScriptRoot"}}
if ($parta1 -eq "%PROG_SOURCE%\") {$PartMatch = 1;$FilePath = "$PSScriptRoot"}
if ($PartMatch -eq $null) {$PathCheck = "$parta1";if (Test-Path -Path $PathCheck) {$FilePath = "$parta1"} else {$FilePath = "$PSScriptRoot"}}
Get-ChildItem -Path "$FilePath\*$partb1" -Name | ForEach-Object {[void]$dropbox.Items.Add($_)}
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
ForEach ($i in @("","GUI_SCALE=$ScaleJ")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($boxresult -eq "OK") {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}
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
if ($Button_W2V.Tag -eq 'Enable') {$PageW2V.Visible = $true;Button_PageW2V;$PageW2V.BringToFront();$Button_V2W.Visible = $true;$Button_W2V.Visible = $false}
if ($Button_V2W.Tag -eq 'Enable') {$PageV2W.Visible = $true;Button_PageV2W;$PageV2W.BringToFront();$Button_W2V.Visible = $true;$Button_V2W.Visible = $false}
if ($Button_LB.Tag -eq 'Enable') {$PageLB.Visible = $true;Button_PageLB;$PageLB.BringToFront();$Button_PB.Visible = $true;$Button_LB.Visible = $false}
if ($Button_PB.Tag -eq 'Enable') {$PagePB.Visible = $true;Button_PagePB;$PagePB.BringToFront();$Button_LB.Visible = $true;$Button_PB.Visible = $false}
if ($Button_SP.Tag -eq 'Enable') {$PageSP.Visible = $true;$PageSP.BringToFront()}
if ($Button_BC.Tag -eq 'Enable') {$PageBC.Visible = $true;Button_PageBC;$PageBC.BringToFront()}
if ($Button_SC.Tag -eq 'Enable') {$PageSC.Visible = $true;Button_PageSC;$PageSC.BringToFront()}
if ($Button_W2V.Tag -ne 'Enable') {$PageW2V.Visible = $false}
if ($Button_V2W.Tag -ne 'Enable') {$PageV2W.Visible = $false}
if ($Button_LB.Tag -ne 'Enable') {$PageLB.Visible = $false}
if ($Button_PB.Tag -ne 'Enable') {$PagePB.Visible = $false}
if ($Button_BC.Tag -ne 'Enable') {$PageBC.Visible = $false}
if ($Button_SC.Tag -ne 'Enable') {$PageSC.Visible = $false}
if ($Button_SP.Tag -ne 'Enable') {$PageSP.Visible = $false}
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
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\`$TEMP";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\`$TEMP" -Force}
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
$PathCheck = "$PSScriptRoot\image\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageV2W {
$PathCheck = "$PSScriptRoot\image\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
if (Test-Path -Path $FilePath\$($DropBox1_PageV2W.SelectedItem)) {$null} else {$DropBox1_PageV2W.SelectedItem = $null}
$ListView1_PageV2W.Items.Clear();#$ListView1_PageW2V.Columns[0].Width = -2
$DropBox1_PageV2W.ResetText();$DropBox1_PageV2W.Items.Clear()
$DropBox2_PageV2W.ResetText();$DropBox2_PageV2W.Items.Clear()
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageV2W.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageV2W.Items.Add($_)}
if ($($TextBox1_PageV2W.Text)) {$null} else {$TextBox1_PageV2W.Text = 'NewFile.wim'}
if ($($DropBox3_PageV2W.SelectedItem)) {$null} else {$DropBox3_PageV2W.Items.Clear();$DropBox3_PageV2W.Items.Add("Fast");$DropBox3_PageV2W.Items.Add("Max");$DropBox3_PageV2W.SelectedItem = "Fast";}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageLB {
$ListView1_PageLB.Items.Clear();$ListView2_PageLB.Items.Clear()
$PathCheck = "$PSScriptRoot\list"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
#Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLB.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.base" -Name | ForEach-Object {[void]$ListView2_PageLB.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PagePB {
$ListView1_PagePB.Items.Clear();$ListView2_PagePB.Items.Clear()
$PathCheck = "$PSScriptRoot\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePB.Items.Add($_)}
$PathCheck = "$PSScriptRoot\project"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\project"
Get-ChildItem -Path "$FilePath" -Name | ForEach-Object {[void]$ListView2_PagePB.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageBC {
$DropBox3_PageBC.Items.Clear();$DropBox3_PageBC.Items.Add("Refresh");$DropBox3_PageBC.Text = "Select Disk"
$PathCheck = "$PSScriptRoot\image\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
if (Test-Path -Path $FilePath\$($DropBox1_PageBC.SelectedItem)) {$null} else {$DropBox1_PageBC.SelectedItem = $null}
$ListView1_PageBC.Items.Clear();Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageBC.Items.Add($_)}
$DropBox1_PageBC.ResetText();$DropBox1_PageBC.Items.Clear();$DropBox1_PageBC.Text = "Select .vhdx"
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageBC.Items.Add($_)}
$PathCheck = "$PSScriptRoot\cache\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\cache"} else {$FilePath = "$PSScriptRoot"}
if (Test-Path -Path $FilePath\$($DropBox2_PageBC.SelectedItem)) {$null} else {$DropBox2_PageBC.SelectedItem = $null}
$empty = $true;
$DropBox2_PageBC.ResetText();$DropBox2_PageBC.Items.Clear()
Get-ChildItem -Path "$FilePath\*.jpg" -Name | ForEach-Object {$empty = $false;[void]$DropBox2_PageBC.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.png" -Name | ForEach-Object {$empty = $false;[void]$DropBox2_PageBC.Items.Add($_)}
[void]$DropBox2_PageBC.Items.Add("Import Wallpaper")
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageSC {
if ($($DropBox1_PageSC.SelectedItem)) {$null} else {$DropBox1_PageSC.ResetText();$DropBox1_PageSC.Items.Clear();
$key = Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont"
#$key.GetValueNames() | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}
$key.GetValueNames() | ForEach-Object {$key.GetValue($_) | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}}
$DropBox1_PageSC.SelectedItem = "$GUI_CONFONT"}
if ($($DropBox2_PageSC.SelectedItem)) {$null} else {$DropBox2_PageSC.ResetText();$DropBox2_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36','40','44','48','52','56','60','64','68','72')) {$DropBox2_PageSC.Items.Add($i)}
$DropBox2_PageSC.SelectedItem = "$GUI_CONFONTSIZE"}
if ($($DropBox3_PageSC.SelectedItem)) {$null} else {$DropBox3_PageSC.ResetText();$DropBox3_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36')) {$DropBox3_PageSC.Items.Add($i)}
$DropBox3_PageSC.SelectedItem = "$GUI_LVFONTSIZE"}
if ($($DropBox4_PageSC.SelectedItem)) {$null} else {$DropBox4_PageSC.ResetText();$DropBox4_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36')) {$DropBox4_PageSC.Items.Add($i)}
$DropBox4_PageSC.SelectedItem = "$GUI_FONTSIZE"}
if ($($DropBox5_PageSC.SelectedItem)) {$null} else {
$DropBox5_PageSC.ResetText();$DropBox5_PageSC.Items.Clear();
$DropBox5_PageSC.Items.Add("🎨 Theme");$DropBox5_PageSC.Items.Add("Button");$DropBox5_PageSC.Items.Add("Highlight");$DropBox5_PageSC.Items.Add("Text Color");$DropBox5_PageSC.Items.Add("Text Canvas");$DropBox5_PageSC.Items.Add("Side Panel");$DropBox5_PageSC.Items.Add("Background")}
$DropBox5_PageSC.SelectedItem = ""
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportBoot {
$PathCheck = "$PSScriptRoot\cache";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\cache"} else {$FilePath = "$PSScriptRoot"}
$PathCheckX = "$FilePath\boot.sav";if (Test-Path -Path $PathCheckX) {$result = [System.Windows.Forms.MessageBox]::Show("Boot media already exists.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK)} else {
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportWim {
$FileFilt = "ISO files (*.iso)|*.iso";PickFile
if ($Pick) {
$Image = Mount-DiskImage -ImagePath "$Pick" -PassThru
$drvLetter = ($Image | Get-Volume).DriveLetter
$PathCheck = "$PSScriptRoot\image"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
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
$PathCheck = "$PSScriptRoot\cache"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\cache"} else {$FilePath = "$PSScriptRoot"}
$source = "$Pick";$target = "$FilePath"
$objShell = New-Object -ComObject "Shell.Application"
$objFolder = $objShell.NameSpace($target)
$objFolder.CopyHere($source)
Dismount-DiskImage -DevicePath $Image.DevicePath}
Button_PageBC
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox3BC {
$ListView1_PageBC.Items.Clear();$ListView1_PageBC.Items.Add("Querying disks...")
$DropBox3_PageBC.Items.Clear();
$disks = Get-Disk | Sort-Object -Property Number
$ListView1_PageBC.Items.Clear();foreach ($disk in $disks) {
#$diskModel = $disk.Model;#$diskID = $disk.UniqueID;#$diskSerialNumber = $disk.SerialNumber
$diskNumber = $disk.Number;$diskSize = $disk.Size / 1073741824;$diskSize = [Math]::Floor($diskSize)
$PathCheck = "$PSScriptRoot\`$DISK";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\`$DISK" -Force}
Add-Content -Path "$PSScriptRoot\`$DISK" -Value "select disk $diskNumber" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\`$DISK" -Value "detail disk" -Encoding UTF8
Add-Content -Path "$PSScriptRoot\`$DISK" -Value "exit" -Encoding UTF8
$diskpart = DISKPART /S "$PSScriptRoot\`$DISK";Remove-Item -Path "$PSScriptRoot\`$DISK" -Force
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox1W2V {
if ($DropBox1_PageW2V.SelectedItem) {if ($DropBox1_PageW2V.SelectedItem -ne 'Import Installation Media') {
$DropBox2_PageW2V.Items.Clear()
$ListView1_PageW2V.Items.Clear()
$PathCheck = "$PSScriptRoot\image\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Dropbox1V2W {
$DropBox2_PageV2W.Items.Clear()
$ListView1_PageV2W.Items.Clear();#$DropBox2_PageV2W.Text = '1'
$PathCheck = "$PSScriptRoot\image\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox1SC {
if ($DropBox1SCChanged -eq '1') {
$global:GUI_CONFONT = "$($DropBox1_PageSC.SelectedItem)";[VOID][WinMekanix]::SetConsoleFont("$GUI_CONFONT", "$CFSIZEX")
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_CONFONT=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8}
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
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_CONFONTSIZE=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8}
$global:DropBox2SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox3SC {
#$global:GUI_LVFONTSIZE = "$($DropBox3_PageSC.SelectedItem)"
if ($DropBox3SCChanged -eq '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_LVFONTSIZE=$($DropBox3_PageSC.SelectedItem)" -Encoding UTF8
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}}
$global:DropBox3SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox4SC {
#$global:GUI_FONTSIZE = "$($DropBox4_PageSC.SelectedItem)"
if ($DropBox4SCChanged -eq '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_FONTSIZE=$($DropBox4_PageSC.SelectedItem)" -Encoding UTF8
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}}
$global:DropBox4SCChanged = '1';
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function DropBox5SC {
if ($($DropBox5_PageSC.SelectedItem) -eq '🎨 Theme') {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Theme' -MessageBoxText 'Select a theme' -MessageBoxChoices "Dark,DarkRed,DarkGreen,DarkBlue,Light,LightRed,LightGreen,LightBlue"
if ($boxoutput -eq "Dark") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF151515';$GUI_BTN_COLORX = 'FF404040';$GUI_HLT_COLORX = 'FF777777';$GUI_BG_COLORX = 'FF252525';$GUI_PAG_COLORX = 'FF151515'}
if ($boxoutput -eq "DarkRed") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF150000';$GUI_BTN_COLORX = 'FF400000';$GUI_HLT_COLORX = 'FF770000';$GUI_BG_COLORX = 'FF250000';$GUI_PAG_COLORX = 'FF150000'}
if ($boxoutput -eq "DarkGreen") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF001500';$GUI_BTN_COLORX = 'FF004000';$GUI_HLT_COLORX = 'FF007700';$GUI_BG_COLORX = 'FF002500';$GUI_PAG_COLORX = 'FF001500'}
if ($boxoutput -eq "DarkBlue") {$GUI_TXT_FOREX = 'FFFFFFFF';$GUI_TXT_BACKX = 'FF000015';$GUI_BTN_COLORX = 'FF000040';$GUI_HLT_COLORX = 'FF000077';$GUI_BG_COLORX = 'FF000025';$GUI_PAG_COLORX = 'FF000015'}
if ($boxoutput -eq "Light") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFFFFFFF';$GUI_BTN_COLORX = 'FFC0C0C0';$GUI_HLT_COLORX = 'FFD5D5D5';$GUI_BG_COLORX = 'FFA0A0A0';$GUI_PAG_COLORX = 'FF555555'}
if ($boxoutput -eq "LightRed") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFFFD0D0';$GUI_BTN_COLORX = 'FFFF8888';$GUI_HLT_COLORX = 'FFFFACAC';$GUI_BG_COLORX = 'FFE06C6C';$GUI_PAG_COLORX = 'FF990000'}
if ($boxoutput -eq "LightGreen") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFD0FFD0';$GUI_BTN_COLORX = 'FF88FF88';$GUI_HLT_COLORX = 'FFACFFAC';$GUI_BG_COLORX = 'FF6CE06C';$GUI_PAG_COLORX = 'FF009900'}
if ($boxoutput -eq "LightBlue") {$GUI_TXT_FOREX = 'FF000000';$GUI_TXT_BACKX = 'FFD0D0FF';$GUI_BTN_COLORX = 'FF8888FF';$GUI_HLT_COLORX = 'FFACACFF';$GUI_BG_COLORX = 'FF6C6CE0';$GUI_PAG_COLORX = 'FF000099'}
ForEach ($i in @("","GUI_TXT_FORE=$GUI_TXT_FOREX","GUI_TXT_BACK=$GUI_TXT_BACKX","GUI_BTN_COLOR=$GUI_BTN_COLORX","GUI_HLT_COLOR=$GUI_HLT_COLORX","GUI_BG_COLOR=$GUI_BG_COLORX","GUI_PAG_COLOR=$GUI_PAG_COLORX")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}
}
if ($($DropBox5_PageSC.SelectedItem) -ne '🎨 Theme') {$colorDialog = New-Object System.Windows.Forms.ColorDialog;$boxresultX = $colorDialog.ShowDialog()}
If ($boxresultX -eq [System.Windows.Forms.DialogResult]::OK) {
$colorSelect = $colorDialog.Color;$colorHex = $($colorSelect.ToArgb().ToString('X'))
if ($($DropBox5_PageSC.SelectedItem) -eq 'Text Color') {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_TXT_FORE=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Text Canvas') {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_TXT_BACK=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Button') {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_BTN_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Highlight') {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_HLT_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Background') {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_BG_COLOR=$colorHex" -Encoding UTF8}
if ($($DropBox5_PageSC.SelectedItem) -eq 'Side Panel') {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "" -Encoding UTF8;Add-Content -Path "$PSScriptRoot\windick.ini" -Value "GUI_PAG_COLOR=$colorHex" -Encoding UTF8}
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}
}
$DropBox5_PageSC.ResetText();$DropBox5_PageSC.Items.Clear();
$DropBox5_PageSC.Items.Add("🎨 Theme");$DropBox5_PageSC.Items.Add("Button");$DropBox5_PageSC.Items.Add("Highlight");$DropBox5_PageSC.Items.Add("Text Color");$DropBox5_PageSC.Items.Add("Text Canvas");$DropBox5_PageSC.Items.Add("Side Panel");$DropBox5_PageSC.Items.Add("Background")
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage1 {$global:PBWiz_Stage = 1;
$Label1_PagePBWiz.Text = "🗳 Pack Builder"
$Label2_PagePBWiz.Text = "Select an option"
$ListView1_PagePBWiz.GridLines = $false
$ListView1_PagePBWiz.CheckBoxes = $false
$ListView1_PagePBWiz.FullRowSelect = $true
$ListView1_PagePBWiz.Items.Clear();
$item1 = New-Object System.Windows.Forms.ListViewItem("💾 Capture Project Folder")
$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🗳 New Package Template")
$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🗳 Restore Package")
$ListView1_PagePBWiz.Items.Add($item1)
$item1 = New-Object System.Windows.Forms.ListViewItem("🔄 Export Drivers")
$ListView1_PagePBWiz.Items.Add($item1)
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage2 {$global:PBWiz_Stage = 2;
if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PagePBWiz.FocusedItem}
$ListView1_PagePBWiz.GridLines = $false;$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]'

if ($ListViewChoiceS2 -eq "💾 Capture Project Folder") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Package' -MessageBoxText 'Enter new .pkx package name' -Check 'PATH'

if ($boxresult -ne "OK") {$global:PBWiz_Stage = 1;}
if ($boxresult -eq "OK") {$ListView1_PagePBWiz.Items.Clear();
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\pack";if (Test-Path -Path $PathCheck) {$FilePathPKX = "$PSScriptRoot\pack\$boxoutput.pkx"} else {$FilePathPKX = "$PSScriptRoot\$boxoutput.pkx"}
$command = @"
DISM /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"$PSScriptRoot\project" /IMAGEFILE:"$FilePathPKX" /COMPRESS:Fast /NAME:"PKX" /CheckIntegrity /Verify
"@
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-CUSTOM","ARG4=`$LIST","ARG5=-LIVE")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
ForEach ($i in @("EXEC-LIST","`❕COMMANDQ`❕ECHO.           %@@%PACKAGE CREATE START`:%`$`$%  %DATE%  %TIME%`❕CMD`❕DX`❕","`❕COMMANDQ`❕$command`❕CMD`❕DX`❕","`❕COMMANDQ`❕ECHO.`❕CMD`❕DX`❕","`❕COMMANDQ`❕ECHO.            %@@%PACKAGE CREATE END`:%`$`$%  %DATE%  %TIME%`❕CMD`❕DX`❕")) {Add-Content -Path "$FilePathLST" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

if ($ListViewChoiceS2 -eq "🗳 New Package Template") {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$global:PBWiz_Stage = 1;}
if ($boxresult -eq "OK") {$PathCheck = "$PSScriptRoot\project";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\project" -Recurse -Force}
New-Item -ItemType Directory -Path "$PSScriptRoot\project\driver"
ForEach ($i in @("EXEC-LIST","Delete the driver list entry below and driver folder if there are not drivers included in the package.",'`❕DRIVER`❕"%PKX_FOLDER%\driver"`❕INSTALL`❕DX`❕',"Delete the command list entry below and package.cmd if a script is not needed.",'`❕COMMAND`❕CMD /C "%PKX_FOLDER%\package.cmd"`❕CMD`❕DX`❕',"Manually add, copy and paste items, or replace this package.list with an existing execution list.","Copy any listed items such as scripts, installers, appx, cab, and msu packages into the project folder before package creation.")) {Add-Content -Path "$PSScriptRoot\project\package.list" -Value "$i" -Encoding UTF8}
ForEach ($i in @("::================================================","::These variables are built in and can help","::keep a script consistant throughout the entire","::process, whether applying to a vhdx or live.","::Add any files to package folder before creating.","::================================================","::Windows folder :    %WINTAR%","::Drive root :        %DRVTAR%","::User or defuser :   %USRTAR%","::HKLM\SOFTWARE :     %HIVE_SOFTWARE","::HKLM\SYSTEM :       %HIVE_SYSTEM%","::HKCU or defuser :   %HIVE_USER%","::DISM target :       %APPLY_TARGET%","::==================START OF PACK=================","","@ECHO OFF",'REM "%PKX_FOLDER%\example.msi" /quiet /noprompt',"","::===================END OF PACK==================")) {Add-Content -Path "$PSScriptRoot\project\package.cmd" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB}}

if ($ListViewChoiceS2 -eq "🗳 Restore Package") {
$Label1_PagePBWiz.Text = "🗳 Restore Package"
$Label2_PagePBWiz.Text = "Select a package"
$ListView1_PagePBWiz.Items.Clear()
$PathCheck = "$PSScriptRoot\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePBWiz.Items.Add($_)}
}
if ($ListViewChoiceS2 -eq "🔄 Export Drivers") {
$Label1_PagePBWiz.Text = "🔄 Export Drivers"
$Label2_PagePBWiz.Text = "Select a source"
$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.Items.Clear();
$global:Show_ENV = $null;$ListView1_PagePBWiz.Items.Add("🪟 Current Environment")
$PathCheck = "$PSScriptRoot\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PagePBWiz.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PBWiz_Stage3 {$global:PBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PagePBWiz.FocusedItem}
$ListView1_PagePBWiz.GridLines = $false;$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
if ($ListViewChoiceS2 -eq "🔄 Export Drivers") {
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-EXPORT","ARG3=-DRIVERS")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
If ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG4=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG4=-VHDX","ARG5=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}

if ($ListViewChoiceS2 -eq "🗳 Restore Package") {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$global:PBWiz_Stage = 2;}
if ($boxresult -eq "OK") {
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\project";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\project" -Recurse -Force}
New-Item -ItemType Directory -Path "$PSScriptRoot\project"
$PathCheck = "$PSScriptRoot\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
$command = @"
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"$FilePath\$ListViewChoiceS3" /INDEX:1 /APPLYDIR:"$PSScriptRoot\project"
"@
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-CUSTOM","ARG4=`$LIST","ARG5=-LIVE")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
ForEach ($i in @("EXEC-LIST","`❕COMMANDQ`❕ECHO.           %@@%PACKAGE EXTRACT START`:%`$`$%  %DATE%  %TIME%`❕CMD`❕DX`❕","`❕COMMANDQ`❕$command`❕CMD`❕DX`❕","`❕COMMANDQ`❕ECHO.`❕CMD`❕DX`❕","`❕COMMANDQ`❕ECHO.            %@@%PACKAGE EXTRACT END`:%`$`$%  %DATE%  %TIME%`❕CMD`❕DX`❕")) {Add-Content -Path "$FilePathLST" -Value "$i" -Encoding UTF8}
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
$PathCheck = "$PSScriptRoot\list"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.base" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage2 {$global:LEWiz_Stage = 2;$global:marked = $null;$global:boxresult = $null
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$global:ListViewSelectS2 = $ListView1_PageLEWiz.FocusedItem
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]';
$global:LBWiz_TypeX = Get-Content -Path "$FilePath\$ListViewChoiceS2" -TotalCount 1
ForEach ($i in @("BASE-LIST","BASE-GROUP")) {if ($LBWiz_TypeX -eq "$i") {LBWiz_Stage2;$PageLBWiz.Visible = $true;$PageLEWiz.Visible = $false;$PageLBWiz.BringToFront()}}
$Label1_PageLEWiz.Text = "🧾 List Execute"
$Label2_PageLEWiz.Text = "Select a target"
$ListView1_PageLEWiz.GridLines = $false;$ListView1_PageLEWiz.CheckBoxes = $false;$ListView1_PageLEWiz.FullRowSelect = $true
ForEach ($i in @("BASE-LIST","BASE-GROUP")) {if ($LBWiz_TypeX -eq "$i") {$global:ListViewChoiceS2 = "`$LIST"}}
$ListView1_PageLEWiz.Items.Clear();
if ($Allow_ENV -eq 'ENABLED') {$ListView1_PageLEWiz.Items.Add("🪟 Current Environment")}
$PathCheck = "$PSScriptRoot\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage3 {$global:LEWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLEWiz.FocusedItem}
$ListView1_PageLEWiz.GridLines = $false;$ListView1_PageLEWiz.CheckBoxes = $false;$ListView1_PageLEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-LIST","ARG4=$ListViewChoiceS2")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}
$global:LEWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLEWiz.Visible = $false;Button_PageLB
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
$PathCheck = "$PSScriptRoot\pack"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage2 {$global:PEWiz_Stage = 2;
$Label1_PagePEWiz.Text = "🗳 Pack Execute"
$Label2_PagePEWiz.Text = "Select a target"
if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PagePEWiz.FocusedItem}
$ListView1_PagePEWiz.GridLines = $false;$ListView1_PagePEWiz.CheckBoxes = $false;$ListView1_PagePEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]'
$ListView1_PagePEWiz.Items.Clear();
if ($Allow_ENV -eq 'ENABLED') {$ListView1_PagePEWiz.Items.Add("🪟 Current Environment")}
$PathCheck = "$PSScriptRoot\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PagePEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage3 {$global:PEWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PagePEWiz.FocusedItem}
$ListView1_PagePEWiz.GridLines = $false;$ListView1_PagePEWiz.CheckBoxes = $false;$ListView1_PagePEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-PACK","ARG4=$ListViewChoiceS2")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}
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
#$item1.SubItems.Add("Description for X")
$ListView1_PageLBWiz.Items.Add($item1)
$PathCheck = "$PSScriptRoot\list"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.base" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage2 {$global:LBWiz_Stage = 2;
$GRP = $null;if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {
if ($ListMode -eq "Builder") {$global:ListViewSelectS2 = $ListView1_PageLBWiz.FocusedItem}}
$parta, $global:BaseFile, $partc = $ListViewSelectS2 -split '[{}]';
$ListView1_PageLBWiz.Items.Clear()
$ListView1_PageLBWiz.GridLines = $false
$ListView1_PageLBWiz.CheckBoxes = $false
$ListView1_PageLBWiz.FullRowSelect = $true
if ($BaseFile -eq "🧾 Miscellaneous") {$global:LBWiz_Type = 'MISC';}
if ($BaseFile -ne "🧾 Miscellaneous") {$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$global:LBWiz_Type = Get-Content -Path "$FilePath\\$BaseFile" -TotalCount 1}
if ($LBWiz_Type -eq 'MISC') {
$Label1_PageLBWiz.Text = "🧾 List $ListMode"
$Label2_PageLBWiz.Text = "Miscellaneous"
ForEach ($i in @("🧾 Create Source Base","🪛 Group Seperator Item","🪛 Prompt TextBox Item","🪛 Choice Menu Item","🪛 File Picker Item","✒ External Package Item","✒ Command Operation Item","🧾 Create Group Base")) {$ListView1_PageLBWiz.Items.Add("$i")}
}
if ($LBWiz_Type -eq 'BASE-GROUP') {
$Label1_PageLBWiz.Text = "🧾 List $ListMode"
$Label2_PageLBWiz.Text = "$BaseFile"
Get-Content "$FilePath\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh = $_ -split "[❕]"

if ($partXb -eq 'GROUP') {if (-not ($partXc -eq $GRP)) {
$GRP = "$partXc";#$item1.SubItems.Add("$partXf")
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXc")
$ListView1_PageLBWiz.Items.Add($item1)}}}}

if ($LBWiz_Type -eq 'BASE-LIST') {
$Label1_PageLBWiz.Text = "🧾 List $ListMode"
$Label2_PageLBWiz.Text = "$BaseFile"
Get-Content "$FilePath\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh = $_ -split "[❕]"

if (-not ($partXb -eq $GRP)) {
$GRP = "$partXb"
if ($partXb -eq 'APPX') {$ListView1_PageLBWiz.Items.Add("AppX")}
if ($partXb -eq 'CAPABILITY') {$ListView1_PageLBWiz.Items.Add("Capability")}
if ($partXb -eq 'FEATURE') {$ListView1_PageLBWiz.Items.Add("Feature")}
if ($partXb -eq 'SERVICE') {$ListView1_PageLBWiz.Items.Add("Service")}
if ($partXb -eq 'TASK') {$ListView1_PageLBWiz.Items.Add("Task")}
if ($partXb -eq 'COMPONENT') {$ListView1_PageLBWiz.Items.Add("Component")}
if ($partXb -eq 'DRIVER') {$ListView1_PageLBWiz.Items.Add("Driver")}
}}}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage3MISC {$global:LBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLBWiz.FocusedItem}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'

if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {
$Label1_PageLBWiz.Text = "🧾 Miscellaneous"
$Label2_PageLBWiz.Text = "Create Source Base"
$ListView1_PageLBWiz.Items.Clear()
ForEach ($i in @("All source items","AppX","Capability","Feature","Service","Task","Component","Driver")) {$ListView1_PageLBWiz.Items.Add("$i")}
}

if ($ListViewChoiceS3 -eq "🪛 Group Seperator Item") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Group Seperator Item' -MessageBoxText 'Enter new group name' -Check 'PATH'
if ($boxresult -eq "OK") {$global:GroupName = "$boxoutput";MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Group Seperator Item' -MessageBoxText 'Enter new subgroup name' -Check 'PATH'}
if ($boxresult -eq "OK") {$global:SubGroupName = "$boxoutput";
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "✒ External Package Item") {
$Label1_PageLBWiz.Text = "🧾 List Builder";
$Label2_PageLBWiz.Text = "Select a package"
$ListView1_PageLBWiz.Items.Clear();$PathCheck = "$PSScriptRoot\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.appx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.appxbundle" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.cab" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.msixbundle" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.msu" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.pkx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}

if ($ListViewChoiceS3 -eq "✒ Command Operation Item") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Command Operation Item' -MessageBoxText 'Enter new command.' -Check 'MOST';$global:CommandItem = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Mount registry during execution?' -MessageBoxText 'Select the command type' -MessageBoxChoices "Normal Command,Registry Command"
if ($boxoutput -eq "Normal Command") {$global:CommandTypeX = "CMD"} else {$global:CommandTypeX = "REG"}
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Run As' -MessageBoxText 'Select an elevation' -MessageBoxChoices "Run As User,Run As System❗,Run As TrustedInstaller❗"
if ($boxoutput -eq "Run As User") {$global:RunAsX = ""}
if ($boxoutput -eq "Run As System❗") {$global:RunAsX = "_RAS"}
if ($boxoutput -eq "Run As TrustedInstaller❗") {$global:RunAsX = "_RATI"}
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Run As' -MessageBoxText 'Select an elevation' -MessageBoxChoices "Announcement Normal,Announcement Quiet"
if ($boxoutput -eq "Announcement Normal") {$global:AnncType = "COMMAND"}
if ($boxoutput -eq "Announcement Quiet") {$global:AnncType = "COMMANDQ"}
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Time of Action' -MessageBoxText 'Select a run time' -MessageBoxChoices "❕DX❕ Default - Immediate execution,❕SC❕ SetupComplete - Scheduled execution,❕RO❕ RunOnce - Scheduled execution"
if ($boxoutput -eq "❕DX❕ Default - Immediate execution") {$global:ExecuteTime = "DX"}
if ($boxoutput -eq "❕SC❕ SetupComplete - Scheduled execution") {$global:ExecuteTime = "SC"}
if ($boxoutput -eq "❕RO❕ RunOnce - Scheduled execution") {$global:ExecuteTime = "RO"}
if ($boxresult -eq "OK") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "🪛 Choice Menu Item") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Choice Item' -MessageBoxText 'Enter message for the choice prompt.' -Check 'PATH';$global:ChoiceMsg = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Select the choice number' -MessageBoxChoices "0,1,2,3,4,5,6,7,8,9";$global:ChoiceNum = "$boxoutput"
if ($boxresult -eq "OK") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "🪛 File Picker Item") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'File Picker Item' -MessageBoxText 'Enter message for the picker prompt.' -Check 'PATH';$global:PickerMsg = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'File Picker Item' -MessageBoxText 'Select the picker number' -MessageBoxChoices "0,1,2,3,4,5,6,7,8,9";$global:PickerNum = "$boxoutput"

if ($boxresult -eq "OK") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "🪛 Prompt TextBox Item") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Prompt Item' -MessageBoxText 'Enter message for the prompt.' -Check 'PATH';$global:PromptMsg = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Select the prompt number' -MessageBoxChoices "0,1,2,3,4,5,6,7,8,9";$global:PromptNum = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Select the character filter type' -MessageBoxChoices "NONE,NUMBER,LETTER,ALPHA,MENU,PATH,MOST";$global:PromptFilt = "$boxoutput"
if ($PromptFilt -eq "NUMBER") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Enter the minimum number' -Check "NUMBER";$global:PromptMin = "$boxoutput"
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Enter the maximum number' -Check "NUMBER";$global:PromptMax = "$boxoutput"}
if ($PromptFilt -ne "NUMBER") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Enter the minimum character length' -Check "NUMBER";$global:PromptMin = "$boxoutput"
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Enter the maximum character length' -Check "NUMBER";$global:PromptMax = "$boxoutput"}
if ($boxresult -eq "OK") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "🧾 Create Group Base") {
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();
$Label1_PageLBWiz.Text = "🧾 Create Group Base";
$Label2_PageLBWiz.Text = "Select a list to convert"
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4MISC {$global:LBWiz_Stage = 4;
if ($marked -ne $null) {$global:ListViewSelectS4 = $marked} else { $global:ListViewSelectS4 = $ListView1_PageLBWiz.FocusedItem}
$parta, $global:ListViewChoiceS4, $partc = $ListViewSelectS4 -split '[{}]'
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
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
if ($boxresult -eq "OK") {$global:ListName = "$boxoutput.base";$ListTarget = "$FilePath\$boxoutput.base";if (Test-Path -Path $ListTarget) {Remove-Item -Path "$ListTarget" -Force}
$Show_ENV = $true;PickEnvironment
$Label1_PageLBWiz.Text = "🧾 Create Source Base"
$Label2_PageLBWiz.Text = "Select a source"
}}

if ($ListViewChoiceS3 -eq "🪛 Group Seperator Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8}
}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
Add-Content -Path "$ListTarget" -Value "`❕Note: Place into a Group Base to begin using.`❕" -Encoding UTF8;Add-Content -Path "$ListTarget" -Value "`❕GROUP`❕$GroupName`❕$SubGroupName`❕" -Encoding UTF8
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName";
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "✒ External Package Item") {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Time of Action' -MessageBoxText 'Select a run time' -MessageBoxChoices "❕DX❕ Default - Immediate execution,❕SC❕ SetupComplete - Scheduled execution,❕RO❕ RunOnce - Scheduled execution"
if ($boxoutput -eq "❕DX❕ Default - Immediate execution") {$global:ExecuteTime = "DX"}
if ($boxoutput -eq "❕SC❕ SetupComplete - Scheduled execution") {$global:ExecuteTime = "SC"}
if ($boxoutput -eq "❕RO❕ RunOnce - Scheduled execution") {$global:ExecuteTime = "RO"}
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$Label1_PageLBWiz.Text = "💾 Append Items";$Label2_PageLBWiz.Text = "Select a list"
$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($ListViewChoiceS3 -eq "✒ Command Operation Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8
}}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
Add-Content -Path "$ListTarget" -Value "`❕$AnncType`❕$CommandItem`❕$CommandTypeX$RunAsX`❕$ExecuteTime`❕" -Encoding UTF8
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "🪛 Choice Menu Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list"
if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8}}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
ForEach ($i in @("`❕Note: Place into a Group Base to begin using.`❕","`❕CHOICE$ChoiceNum`❕$ChoiceMsg`❕Option One,Option Two,Option Three`❕VolaTILE`❕","`❕COMMANDQ`❕ECHO.CHOICE$ChoiceNum`: %CHOICE$ChoiceNum%  STRING$ChoiceNum`: %STRING$ChoiceNum%`❕CMD`❕DX`❕")) {Add-Content -Path "$ListTarget" -Value "$i" -Encoding UTF8}
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "🪛 File Picker Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list"
if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8}}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
ForEach ($i in @("`❕Note: Place into a Group Base to begin using.`❕","`❕Picker accepts %PROG_SOURCE%,%IMAGE_FOLDER%,%LIST_FOLDER%,%PACK_FOLDER%,%CACHE_FOLDER%,%PKX_FOLDER%`❕","`❕PICKER$PickerNum`❕$PickerMsg`❕%LIST_FOLDER%\*.list`❕VolaTILE`❕","`❕COMMANDQ`❕ECHO.PICKER$PickerNum`: %PICKER$PickerNum%`❕CMD`❕DX`❕")) {Add-Content -Path "$ListTarget" -Value "$i" -Encoding UTF8}
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "🪛 Prompt TextBox Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list"
if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8}}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
ForEach ($i in @("`❕Note: Place into a Group Base to begin using.`❕","`❕PROMPT$PromptNum`❕$PromptMsg`❕$PromptFilt`_$PromptMin`-$PromptMax`❕VolaTILE`❕","`❕COMMANDQ`❕ECHO.PROMPT$PromptNum`: %PROMPT$PromptNum%`❕CMD`❕DX`❕")) {Add-Content -Path "$ListTarget" -Value "$i" -Encoding UTF8}
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "🧾 Create Group Base") {$is_group = $null
Get-Content "$FilePath\$ListViewChoiceS4" -Encoding UTF8 | ForEach-Object {$partXa, $partXb, $partXc = $_ -split "[❕]";if ($partXb -eq 'GROUP') {$is_group = 1}}
if ($is_group -eq $null) {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText "List does not contain any groups."}
if ($is_group -eq 1) {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Group Base' -MessageBoxText 'Enter new .base name' -Check 'PATH'
$ListName = "$boxoutput.base";$ListTarget = "$FilePath\$boxoutput.base";
if (Test-Path -Path $ListTarget) {Remove-Item -Path "$ListTarget" -Force}
$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "BASE-GROUP" -Encoding UTF8
Get-Content "$FilePath\$ListViewChoiceS4" -Encoding UTF8 | ForEach-Object {if ($_ -ne "EXEC-LIST") {Add-Content -Path "$ListTarget" -Value "$_" -Encoding UTF8}}
Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5MISC {
if ($marked -ne $null) {$global:ListViewSelectS5 = $marked} else { $global:ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem}
$parta, $ListViewChoiceS5, $partc = $ListViewSelectS5 -split '[{}]'
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}

if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-CREATE","ARG3=-BASE","ARG4=$ListName")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS5 -eq "🪟 Current Environment") {ForEach ($i in @("ARG5=-LIVE","ARG6=$ListViewBase")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}
if ($ListViewChoiceS5 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS5","ARG7=$ListViewBase")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
return}
if ($ListViewChoiceS5 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 4;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8}}}
if ($ListViewChoiceS5 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS5";$ListTarget = "$FilePath\$ListViewChoiceS5"}
Add-Content -Path "$ListTarget" -Value "`❕EXTPACKAGE`❕$ListViewChoiceS4`❕INSTALL`❕$ExecuteTime`❕" -Encoding UTF8
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage3SRC {$global:LBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLBWiz.FocusedItem}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
$ListView1_PageLBWiz.Items.Clear();$Label1_PageLBWiz.Text = "🧾 $BaseFile"

if ($ListViewChoiceS3 -eq 'APPX') {$ListViewChoiceS3 = "AppX";$Label2_PageLBWiz.Text = "$ListViewChoiceS3";$ListView1_PageLBWiz.Items.Add("🚫 Delete")}
if ($ListViewChoiceS3 -eq 'CAPABILITY') {$ListViewChoiceS3 = "Capability";$Label2_PageLBWiz.Text = "$ListViewChoiceS3";$ListView1_PageLBWiz.Items.Add("🚫 Delete")}
if ($ListViewChoiceS3 -eq 'FEATURE') {$ListViewChoiceS3 = "Feature";$Label2_PageLBWiz.Text = "$ListViewChoiceS3";$ListView1_PageLBWiz.Items.Add("✅ Enable");$ListView1_PageLBWiz.Items.Add("❎ Disable")}
if ($ListViewChoiceS3 -eq 'SERVICE') {$ListViewChoiceS3 = "Service";$Label2_PageLBWiz.Text = "$ListViewChoiceS3";$ListView1_PageLBWiz.Items.Add("✅ Auto");$ListView1_PageLBWiz.Items.Add("✅ Manual");$ListView1_PageLBWiz.Items.Add("❎ Disable");$ListView1_PageLBWiz.Items.Add("🚫 Delete")}
if ($ListViewChoiceS3 -eq 'TASK') {$ListViewChoiceS3 = "Task";$Label2_PageLBWiz.Text = "$ListViewChoiceS3";$ListView1_PageLBWiz.Items.Add("🚫 Delete")}
if ($ListViewChoiceS3 -eq 'COMPONENT') {$ListViewChoiceS3 = "Component";$Label2_PageLBWiz.Text = "$ListViewChoiceS3";$ListView1_PageLBWiz.Items.Add("🚫 Delete")}
if ($ListViewChoiceS3 -eq 'DRIVER') {$ListViewChoiceS3 = "Driver";$ListViewChoiceS3 = "$ListViewChoiceS3";$Label2_PageLBWiz.Text = "$ListViewChoiceS3";$ListView1_PageLBWiz.Items.Add("🚫 Delete")}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4SRC {$global:LBWiz_Stage = 4;
if ($marked -ne $null) {$global:ListViewSelectS4 = $marked} else {$global:ListViewSelectS4 = $ListView1_PageLBWiz.FocusedItem}
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$parta, $ListViewActionZ, $partc = $ListViewSelectS4 -split '[{}]';$parta, $ListViewActionX, $partc = $ListViewActionZ -split '[ ]';$global:ListViewAction = $ListViewActionX.ToUpper()
$ListView1_PageLBWiz.Items.Clear();
$Label1_PageLBWiz.Text = "🧾 $BaseFile"
$Label2_PageLBWiz.Text = "$ListViewChoiceS3 $ListViewActionX"
Get-Content "$FilePath\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]"
if ($partXb -eq $ListViewChoiceS3) {
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXc");$item1.SubItems.Add("$partXf");$ListView1_PageLBWiz.Items.Add($item1)}}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.CheckBoxes = $true;$ListView1_PageLBWiz.FullRowSelect = $true
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5SRC {$global:LBWiz_Stage = 5;
$Label1_PageLBWiz.Text = "💾 Append Items"
$Label2_PageLBWiz.Text = "Select a list"
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
if ($ListMode -eq 'Execute') {Add-Content -Path "$FilePathLST" -Value "EXEC-LIST" -Encoding UTF8}
$global:checkedItems = $ListView1_PageLBWiz.CheckedItems | ForEach-Object {
$parta, $ListViewChecked, $partc = $_ -split '[{}]';$ListViewFocusX = $ListViewChoiceS3.ToUpper()
Add-Content -Path "$FilePathLST" -Value "`❕$ListViewFocusX`❕$ListViewChecked`❕$ListViewAction`❕DX`❕" -Encoding UTF8}
if ($ListMode -eq 'Builder') {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($ListMode -eq 'Execute') {$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront()}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage6SRC {$global:LBWiz_Stage = 6;
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem
$parta, $partb, $partc = $ListViewSelectS5 -split '[{}]'

if ($partb -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 5}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}}

if ($partb -ne "🧾 Create New List") {$ListName = "$partb";$ListTarget = "$FilePath\$partb"}
Get-Content "$FilePath\`$LIST" -Encoding UTF8 | ForEach-Object {Add-Content -Path "$ListTarget" -Value "$_" -Encoding UTF8}
Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8
$PathCheck = "$FilePath\`$LIST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePath\`$LIST" -Force}
if ($ListName -ne "$null") {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName"
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage3GRP {$global:LBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLBWiz.FocusedItem}
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
$ListView1_PageLBWiz.Items.Clear();$Label1_PageLBWiz.Text = "🧾 $BaseFile";$Label2_PageLBWiz.Text = "$ListViewChoiceS3"
Get-Content "$FilePath\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]"
if ($partXb -eq 'GROUP') {
if ($partXc -eq $ListViewChoiceS3) {
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXd");$item1.SubItems.Add("$partXe");$ListView1_PageLBWiz.Items.Add($item1)}}}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.CheckBoxes = $true;$ListView1_PageLBWiz.FullRowSelect = $true
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4GRP {$global:LBWiz_Stage = 4;
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
if ($ListMode -eq 'Execute') {Add-Content -Path "$FilePathLST" -Value "EXEC-LIST" -Encoding UTF8}
#$checkedItems = $ListView1_PageLBWiz.CheckedItems | ForEach-Object { $_.Text }
#[System.Windows.Forms.MessageBox]::Show(("Checked Items: " + ($checkedItems -join ", ")), "Checked Items")
$global:checkedItems = $ListView1_PageLBWiz.CheckedItems | ForEach-Object {$ListWrite = 0
$parta, $ListViewChecked, $partc = $_ -split '[{}]'
Get-Content "$FilePath\$BaseFile" -Encoding UTF8 | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[❕]"
if ($partXb -eq 'GROUP') {if ($partXc -ne $ListViewChoiceS3) {$ListWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXd -ne $ListViewChecked) {$ListWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXc -eq $ListViewChoiceS3) {if ($partXd -eq $ListViewChecked) {$ListWrite = 1}}}

if ($ListWrite -eq '1') {$ListPrompt = $null;
$Label1_PageLBWiz.Text = "$ListViewChoiceS3"
$Label2_PageLBWiz.Text = "$ListViewChecked"
ForEach ($i in @("PROMPT0","PROMPT1","PROMPT2","PROMPT3","PROMPT4","PROMPT5","PROMPT6","PROMPT7","PROMPT8","PROMPT9")) {if ($i -eq "$partXb") {$ListPrompt = 1}}
ForEach ($i in @("CHOICE0","CHOICE1","CHOICE2","CHOICE3","CHOICE4","CHOICE5","CHOICE6","CHOICE7","CHOICE8","CHOICE9")) {if ($i -eq "$partXb") {$ListPrompt = 2}}
ForEach ($i in @("PICKER0","PICKER1","PICKER2","PICKER3","PICKER4","PICKER5","PICKER6","PICKER7","PICKER8","PICKER9")) {if ($i -eq "$partXb") {$ListPrompt = 3}}
if ($ListPrompt -eq $null) {Add-Content -Path "$FilePathLST" -Value "$_" -Encoding UTF8}
if ($ListPrompt -eq '1') {$partw1, $partx1 = $partXd -split "_";$party1, $partz1 = $partx1 -split "-";
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle "$ListViewChecked" -MessageBoxText "$partXc" -Check "$partw1" -TextMin "$party1" -TextMax "$partz1"
Add-Content -Path "$FilePathLST" -Value "`❕$partXb`❕$partXc`❕$partXd`❕$boxoutput`❕" -Encoding UTF8}
if ($ListPrompt -eq '2') {MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewChecked" -MessageBoxText "$partXc" -MessageBoxChoices "$partXd"
Add-Content -Path "$FilePathLST" -Value "`❕$partXb`❕$partXc`❕$partXd`❕$boxindex`❕" -Encoding UTF8}
if ($ListPrompt -eq '3') {MessageBox -MessageBoxType 'Picker' -MessageBoxTitle "$ListViewChecked" -MessageBoxText "$partXc" -MessageBoxChoices "$partXd"
Add-Content -Path "$FilePathLST" -Value "`❕$partXb`❕$partXc`❕$partXd`❕$boxoutput`❕" -Encoding UTF8}
}}}
if ($ListMode -eq 'Builder') {
$Label1_PageLBWiz.Text = "💾 Append Items"
$Label2_PageLBWiz.Text = "Select a list"
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($ListMode -eq 'Execute') {$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront()}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5GRP {
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem
$parta, $partb, $partc = $ListViewSelectS5 -split '[{}]'
if ($partb -eq "🧾 Create New List") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";}
if ($boxresult -eq "OK") {
$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";
if (Test-Path -Path $ListTarget) {$null} else {$NewBlankList = [Convert]::FromBase64String($BlankList);[System.IO.File]::WriteAllBytes($ListTarget, $NewBlankList)
Add-Content -Path "$ListTarget" -Value "EXEC-LIST" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
if ($partb -ne "🧾 Create New List") {$ListName = "$partb";$ListTarget = "$FilePath\$partb"}
Get-Content "$FilePath\`$LIST" -Encoding UTF8 | ForEach-Object {
$partxxx, $partyyy, $partzzz = $_ -split '[❕]';if ($partyyy -eq "GROUP") {Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8}
if ($_ -ne "") {Add-Content -Path "$ListTarget" -Value "$_" -Encoding UTF8}}
#Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8
$PathCheck = "$FilePath\`$LIST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePath\`$LIST" -Force}

if ($ListName -ne "$null") {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options have been added to $ListName"
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickEnvironment {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();
if ($Show_ENV -eq $true) {$global:Show_ENV = $null;$ListView1_PageLBWiz.Items.Add("🪟 Current Environment")}
$PathCheck = "$PSScriptRoot\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
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
$LoadINI = Get-Content -Path "$PSScriptRoot\windick.ini" | Select-Object -Skip 1
$Settings = $LoadINI | ConvertFrom-StringData
$global:Allow_ENV = $Settings.ALLOW_ENV
$global:GUI_SCALE = $Settings.GUI_SCALE
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
if (Test-Path -Path "$env:temp\`$CON") {Remove-Item -Path "$env:temp\`$CON" -Force -Recurse}
if (Test-Path -Path "$PSScriptRoot\`$PKX") {Remove-Item -Path "$PSScriptRoot\`$PKX" -Force -Recurse}
if (Test-Path -Path "$PSScriptRoot\`$CAB") {Remove-Item -Path "$PSScriptRoot\`$CAB" -Force -Recurse}
if (Test-Path -Path "$PSScriptRoot\`$DISK") {Remove-Item -Path "$PSScriptRoot\`$DISK" -Force -Recurse}
Add-Content -Path "$env:temp\`$CON" -Value "$PSScriptRoot" -Encoding UTF8
Add-Content -Path "$env:temp\`$CON" -Value "GUI_CONFONT=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$env:temp\`$CON" -Value "GUI_CONFONTSIZE=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$env:temp\`$CON" -Value "GUI_SCALE=$GUI_SCALE" -Encoding UTF8
if ($ButtonRadio1_Group1.Checked -eq $true) {$GUI_CONTYPE = 'Embed'} else {$GUI_CONTYPE = 'Spawn'}
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
[VOID][WinMekanix]::SetConsoleFont('Consolas', 1)
$PSScriptRoot = Get-Content -Path \"$env:temp\`$CON\" -TotalCount 1
$LoadINI = Get-Content -Path \"$env:temp\`$CON\" | Select-Object -Skip 1
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
Start-Process \"$env:comspec\" -Wait -NoNewWindow -ArgumentList "/c", \"$PSScriptRoot\windick.cmd\", "-EXTERNAL"
$PathCheck = \"$env:temp\\`$CON\";if (Test-Path -Path $PathCheck) {Remove-Item -Path \"$env:temp\`$CON\" -Force}
if ($PAUSE_END -eq '1') {pause}}
$CMDHandle = $CMDWindow.MainWindowHandle;#$CMDHandleX = $CMDWindow.Handle;
do {$CMDHandle = $CMDWindow.MainWindowHandle;Start-Sleep -Milliseconds 100} until ($CMDHandle -ne 0)
$global:CMDProcessId = $CMDWindow.Id;$PanelHandle = $PageConsole.Handle
$getproc = Get-ChildProcesses $CMDProcessId | Select ProcessId, Name, ParentProcessId
$part1, $part2, $part3 = $getproc -split ";";$part4 = $part1 -split ";";$global:SubProcessId = $part4 -Split "@{ProcessId="
Write-Host "Starting console PID: $CMDProcessId conhost PID:$SubProcessId"
if ($GUI_CONTYPE -eq 'Embed') {[VOID][WinMekanix.Functions]::SetParent($CMDHandle, $PanelHandle)}
do {Start-Sleep -Milliseconds 100} until (-not (Test-Path -Path "$env:temp\`$CON"))
if ($GUI_CONTYPE -eq 'Embed') {[VOID][WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 1);[VOID][WinMekanix.Functions]::MoveWindow($CMDHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)}
$PageBlank.Visible = $false;$PageConsole.Visible = $true;$PageConsole.BringToFront()
[VOID][WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 3)}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$PSHandle = [WinMekanix.Functions]::GetConsoleWindow()
#[VOID][WinMekanix.Functions]::SetForegroundWindow($PSHandle)
#[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 0)
[VOID][System.Text.Encoding]::Unicode;LoadSettings
[VOID][WinMekanix.Functions]::SetProcessDPIAware()
[VOID][System.Windows.Forms.Application]::EnableVisualStyles()
[VOID][System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)
$sysltr, $nullx = $env:SystemDrive -split '[:]';$progltr, $nullx = $PSScriptRoot -split '[:]'
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
if ($DimScaleX -ge $DimScaleY) {$ScaleRef = $DimScaleY}
if ($DimScaleY -ge $DimScaleX) {$ScaleRef = $DimScaleX}
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
if ($GUI_TXT_BACK.Length -ne 8) {$GUI_TXT_BACK = 'FF151515'}
if ($GUI_PAG_COLOR.Length -ne 8) {$GUI_PAG_COLOR = 'FF151515'}
if ($Allow_ENV) {$null} else {$Allow_ENV = $null}
ForEach ($i in @("$PSScriptRoot\`$PKX","$PSScriptRoot\`$CAB","$PSScriptRoot\list\`$LIST","$PSScriptRoot\`$LIST","$PSScriptRoot\`$DISK")) {if (Test-Path -Path "$i") {Remove-Item -Path "$i" -Recurse -Force}}
if (Test-Path -Path "$env:temp\`$CON") {Remove-Item -Path "$env:temp\`$CON" -Force}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$form = New-Object Windows.Forms.Form
$form.SuspendLayout()
$version = Get-Content -Path "$PSScriptRoot\windick.ps1" -TotalCount 1;
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
if (-not ($NoExitPrompt)) {MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Close' -MessageBoxText 'Are you sure you want to close?'
if ($boxresult -ne "OK") {$action.Cancel = $true}
if ($boxresult -eq "OK") {Stop-Process -Id $SubProcessId -Force -ErrorAction SilentlyContinue;Stop-Process -Id $CMDProcessId -Force -ErrorAction SilentlyContinue}}})
$form.FormBorderStyle = 'FixedDialog';#FixedDialog, FixedSingle, Fixed3D
$form.AutoSize = $true
$form.AutoSizeMode = 'GrowAndShrink';#AutoSizeMode: GrowAndShrink, GrowOnly, and ShrinkOnly.
$form.AutoScale = $true
$form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$form.WindowState = 'Normal'
;#$form.IsMdiContainer = $true
$PageMain = NewPanel -X '0' -Y '0' -W '1000' -H '666' -C 'Yes'
$PageDebug = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageDebug);$PageDebug.Visible = $false;[VOID][WinMekanix.Functions]::SetParent($PSHandle, $PageDebug.Handle)
$PageSP = NewPanel -X '250' -Y '0' -W '750' -H '666';$PageMain.Controls.Add($PageSP)
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
$Page = 'PageSP';$Label0_PageSP = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text 'Welcome to GUI v0.9' -TextAlign 'X'

$Button2_PageSP = NewButton -X '225' -Y '585' -W '300' -H '60' -Text 'About' -Hover_Text 'About' -Add_Click {MessageBoxAbout}
#$ButtonTest_PageSP = NewButton -X '50' -Y '585' -W '150' -H '60' -Text 'TEST' -Hover_Text 'About' -Add_Click {$null}
#$ButtonReload_PageSP = NewButton -X '550' -Y '585' -W '150' -H '60' -Text 'RELOAD' -Hover_Text '' -Add_Click {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageW2V';$Label0_PageW2V = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🔄 Image Processing|WIM" -TextAlign 'X'
$ListView1_PageW2V = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageW2V.Columns.Add("X", $WSIZ)
$Button1_PageW2V = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Convert' -Hover_Text 'Start Image Conversion' -Add_Click {$halt = $null
if ($($DropBox1_PageW2V.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No wim selected.'}
if ($halt -ne '1') {
ForEach ($i in @("","ARG1=-IMAGEPROC","ARG2=-WIM","ARG3=$($DropBox1_PageW2V.SelectedItem)","ARG4=-INDEX","ARG5=$($DropBox2_PageW2V.SelectedItem)","ARG6=-VHDX","ARG7=$($TextBox1_PageW2V.Text)","ARG8=-SIZE","ARG9=$($TextBox2_PageW2V.Text)")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
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
if ($halt -ne '1') {ForEach ($i in @("","ARG1=-IMAGEPROC","ARG2=-VHDX","ARG3=$($DropBox1_PageV2W.SelectedItem)","ARG4=-INDEX","ARG5=$($DropBox2_PageV2W.SelectedItem)","ARG6=-WIM","ARG7=$($TextBox1_PageV2W.Text)","ARG8=-XLVL","ARG9=$($DropBox3_PageV2W.SelectedItem)")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
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
$ListView1_PageLB = NewListView -X '390' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageLB.Columns.Add("X", $WSIZ)
$ListView2_PageLB = NewListView -X '25' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView2_PageLB.Columns.Add("X", $WSIZ)
$Button1_PageLB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🏁 List Execute' -Hover_Text 'List Execute' -Add_Click {LEWiz_Stage1;$PageLEWiz.Visible = $true;$PageMain.Visible = $false;$PageLB.Visible = $false;$PageLEWiz.BringToFront()}
$Button2_PageLB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🏗 List Builder' -Hover_Text 'List Builder' -Add_Click {LBWiz_Stage1;$PageLBWiz.Visible = $true;$PageMain.Visible = $false;$PageLB.Visible = $false;$PageLBWiz.BringToFront()}

$Button3_PageLB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '✏ Edit List' -Hover_Text 'Edit List' -Add_Click {
$PathCheck = "$PSScriptRoot\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$FileFilt = "List files (*.list;*.base)|*.list;*.base";PickFile
if ($Pick) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$Pick"}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PagePB';$Label0_PagePB = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🗳 Image Management" -TextAlign 'X'
$ListView1_PagePB = NewListView -X '390' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PagePB.Columns.Add("X", $WSIZ)
$ListView2_PagePB = NewListView -X '25' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView2_PagePB.Columns.Add("X", $WSIZ)
$Button0_PagePB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🏁 Pack Execute' -Hover_Text 'Pack Execute' -Add_Click {PEWiz_Stage1;$PagePEWiz.Visible = $true;$PageMain.Visible = $false;$PagePB.Visible = $false;$PagePEWiz.BringToFront()}
$Button3_PagePB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🏗 Pack Builder' -Hover_Text 'Pack Builder' -Add_Click {PBWiz_Stage1;$PagePBWiz.Visible = $true;$PageMain.Visible = $false;$PagePB.Visible = $false;$PagePBWiz.BringToFront()}
$Button4_PagePB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '✏ Edit Pack' -Hover_Text 'Edit Pack' -Add_Click {
$PathCheck = "$PSScriptRoot\project\package.list";if (Test-Path -Path $PathCheck) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PathCheck"}
$PathCheck = "$PSScriptRoot\project\package.cmd";if (Test-Path -Path $PathCheck) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PathCheck"}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageBC';$Label0_PageBC = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "💾 BootDisk Creator" -TextAlign 'X'

$ListView1_PageBC = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageBC.Columns.Add("X", $WSIZ)
$Button1_PageBC = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Create' -Hover_Text 'Start BootDisk Creation' -Add_Click {$halt = $null;$nullx, $disknum, $nully = $($DropBox3_PageBC.SelectedItem) -split '[| ]'
$PathCheck = "$PSScriptRoot\cache";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\cache"} else {$FilePath = "$PSScriptRoot"}
$PathCheckX = "$FilePath\boot.sav";if (-not (Test-Path -Path $PathCheckX)) {
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Import Boot Media' -MessageBoxText 'Boot media needs to be imported from a windows .iso before proceeding.';if ($boxresult -eq "OK") {ImportBoot}}
if (-not (Test-Path -Path $PathCheckX)) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No boot media.'}
if ($($DropBox1_PageBC.SelectedItem) -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No vhdx selected.'}
if ($disknum -eq 'Disk') {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No disk selected.'}
if ($disknum -eq $null) {$halt = 1;MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Error' -MessageBoxText 'No disk selected.'}
if ($halt -ne '1') {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Erase' -MessageBoxText "This will erase Disk $disknum. If you've inserted or removed any disks, refresh before proceeding. Are you sure?"
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {ForEach ($i in @("","ARG1=-BOOTMAKER","ARG2=-CREATE","ARG3=-DISK","ARG4=$disknum","ARG5=-VHDX","ARG6=$($DropBox1_PageBC.SelectedItem)","PE_WALLPAPER=$($DropBox2_PageBC.SelectedItem)")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
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

$Button1_PageSC = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🛠 Console Settings' -Hover_Text 'Console Settings' -Add_Click {ForEach ($i in @("","ARG1=-INTERNAL","ARG2=-SETTINGS")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
#$TextPath = "$env:temp\`$CON";$TextWrite = [System.IO.StreamWriter]::new($TextPath, $false, [System.Text.Encoding]::UTF8);#$TextWrite.WriteLine("x");$TextWrite.Close()
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}

$Button2_PageSC = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🐜 Debug' -Hover_Text 'Debug' -Add_Click {
[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 2);[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 1);#0=Hidden,1=Normal,2=Minimized,3=Maximized
$WSIZ = [int](1000 * $ScaleRef * $GUI_SCALE);$HSIZ = [int](575 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE);$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$PageDebug.Visible = $true;$PageMain.Visible = $false;$PageSC.Visible = $false;$PageDebug.BringToFront()
[VOID][WinMekanix.Functions]::MoveWindow($PSHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)}
$Button3_PageSC = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🔄 Switch to CMD' -Hover_Text 'Switch to CMD' -Add_Click {ForEach ($i in @("","GUI_LAUNCH=DISABLED")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}

$GroupBoxName = 'Group1';$GroupBox1_PageSC = NewGroupBox -X '20' -Y '85' -W '260' -H '75' -Text 'Console Window'
#if ($Button_SC.Tag -eq 'Enable') 
$Add_CheckedChanged = {if ($ButtonGroup1Changed -eq '1') {if ($ButtonRadio1_Group1.Checked) {
ForEach ($i in @("","GUI_CONTYPE=Embed")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}}
$global:ButtonGroup1Changed = '1';}
$ButtonRadio1_Group1 = NewRadioButton -X '15' -Y '30' -W '120' -H '35' -Text 'Embed' -GroupName 'Group1'
$Add_CheckedChanged = {if ($ButtonGroup1Changed -eq '1') {if ($ButtonRadio2_Group1.Checked) {
ForEach ($i in @("","GUI_CONTYPE=Spawn")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}}
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
if ($LBWiz_Stage -eq '1') {$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
if ($LBWiz_Stage -eq '2') {
if ($ListMode -eq 'Builder') {LBWiz_Stage1}
if ($ListMode -eq 'Execute') {LEWiz_Stage1;$global:LBWiz_Stage = $null;$PageLEWiz.Visible = $true;$PageLBWiz.Visible = $false;$PageLEWiz.BringToFront();return}}
if ($LBWiz_Stage -eq '3') {$global:marked = $ListViewSelectS2;LBWiz_Stage2}
if ($LBWiz_Type -eq 'BASE-LIST') {if ($LBWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LBWiz_Stage3SRC}
if ($LBWiz_Stage -eq '5') {LBWiz_Stage4SRC}
if ($LBWiz_Stage -eq '6') {LBWiz_Stage5SRC}
}
if ($LBWiz_Type -eq 'BASE-GROUP') {if ($LBWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LBWiz_Stage3GRP}
if ($LBWiz_Stage -eq '5') {LBWiz_Stage4GRP}}
if ($LBWiz_Type -eq 'MISC') {if ($LBWiz_Stage -eq '4') {$global:marked = $ListViewSelectS3;LBWiz_Stage3MISC}
if ($LBWiz_Stage -eq '5') {LBWiz_Stage4MISC}}}

$Button2_PageLBWiz = NewButton -X '520' -Y '585' -W '300' -H '60' -Text 'Next ▶' -Hover_Text 'Next' -Add_Click {
if ($LBWiz_Type -eq 'MISC') {
if ($LBWiz_Stage -eq '4') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage5MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '3') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage4MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '2') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage3MISC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
if ($LBWiz_Type -eq 'BASE-GROUP') {
if ($LBWiz_Stage -eq '4') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage5GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '3') {if ($ListView1_PageLBWiz.CheckedItems) {$global:marked = $null;LBWiz_Stage4GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '2') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage3GRP} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
if ($LBWiz_Type -eq 'BASE-LIST') {
if ($LBWiz_Stage -eq '5') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage6SRC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '4') {if ($ListView1_PageLBWiz.CheckedItems) {$global:marked = $null;LBWiz_Stage5SRC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '3') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage4SRC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}
if ($LBWiz_Stage -eq '2') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage3SRC} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}
if ($LBWiz_Stage -eq '1') {if ($ListView1_PageLBWiz.SelectedItems) {$global:marked = $null;LBWiz_Stage2} else {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText 'Select an option.'}}}

$ListView1_PageLBWiz = NewListView -X '25' -Y '135' -W '950' -H '425';
$WSIZ = [int](940 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageLBWiz.Columns.Add("X", $WSIZ)
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageLEWiz';$Label1_PageLEWiz = NewLabel -X '0' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🧾 List Execute" -TextAlign 'X'
$Label2_PageLEWiz = NewLabel -X '0' -Y '70' -W '1000' -H '50' -TextSize '24' -Text "" -TextAlign 'X'

$Button1_PageLEWiz = NewButton -X '180' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
if ($LEWiz_Stage -eq '1') {$global:LEWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLEWiz.Visible = $false;Button_PageLB}
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
if ($PBWiz_Stage -eq '1') {$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB}
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
if ($PEWiz_Stage -eq '1') {$global:PEWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePEWiz.Visible = $false;Button_PagePB}
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
[string]$splashjpg=@"
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NONPPPPON6gI4ggo4wN9PPPPPPPPPPPPPPPPPAAHyINvMSIwggggggggggg19PPPPPPPPPPPPPPPOQ/qA/LAggggggggggggggggZPPPPPPPPPPPONAaR/ZFnraAgggggiDADBAggggg9PPPPPPPPPOKm72Saf8AH7TI8889/wA88888NPPPPrVk08888888842k08pVIpSWwwwwww8wwwwwwwwopCic888888888s9j8uT8gFCOBUyGwLWhJjLtTnopCDk08888880040a+vz0tCxCnCnDmpXDTKSLSIowCC3D88888+mtYO6g8C8xcaENnCnDpHQNbKSLBoDACEj88826Z8ZCbyx98KZciAlAtCnpXLDoVKSJoDQCR/wAPPiDUPAwh0SzPHlPDgC54bAQ1Wiky9bQKAwyk+/vBrNvpwggg8Mng1/CZECYA9YxUKQUy0/KAwwF//vB7MStIggh4vxAWUKAJECwwS0QECAky1KAwwQ+wvOuLwAQh4XE+EXzh5YwJEC5KRSQECJUWKAwwU/8A3zz0wS412FSsdP0QgK2ACRAupVEkBAiUEAMMgTwPzzf9wpzyAtkf7+7k9zoKLJO5gJKLJKKQgMIBeozzwETLDinIBVyo2jiD7l3DDDTjDDDDDDCgNQLV/wA8tCCkQignUEEf4/8ACiltAN5ylBQAPxcVaAw171PPGgggglAlFUwlDHn6lnTpw5iVw5wki0qKA6Cmt/OKAggglwlFnhlVV/G5/uQpw6R4DLwkiwaAA+VfPDAwgggiwgCNxtBAPAdlSDQp6Vyw7BSkiaC1qLPPFIwggggAgKk3Kxh+AzIks2QgxGgky1SRKKOZXPPOQggggoAhIgP6+APWhdmojLIxUKQEy07KBerfPPHwggggig0wIkyBXvnvfrz1yS0QECAky1KE9XPPPH4wggggwgQOIAVcuMHZesbTKQSQECJXWKD9fPPPN6QggghAlFT4KdeZgwQEBly6lUyQECJQQL/PPPPLbAggggiKBLYwFQKxjhlSKEbAI0wQWQZQFPPPPPBBQgggghEQESylSDfPPPPPPPPPPPPPPPLFPPPPPGHSQgggh4XgxIFaIM888888884AQLCCDDPPPPPPKTuSggqoLTqO6WiV6wwwwgwhIAmPGzfPPPPPPPPPFs7gg0JBKOEwBFGPSAghA0Ahx8cSnPPP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
"@
[string]$shazzam_img=@"
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
"@
[string]$logojpgB64=@"
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
"@
$Page = 'PageConsole';$pictureBase64 = $shazzam_img;$PictureBoxConsole = NewPictureBox -X '910' -Y '576' -W '90' -H '90'
$Page = 'PageSP';$pictureBase64 = $splashjpg;$PictureBox1_PageMain = NewPictureBox -X '120' -Y '75' -W '500' -H '500';
$Page = 'PageMain';$Button_SP = NewPageButton -X '-5' -Y '630' -W '50' -H '40' -C '0' -Text '';$Button_SPImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($logobar));$Button_SP.Image = $Button_SPImage
$form.ResumeLayout()
$form.Add_Shown({$form.Activate()})
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
#Get-ContentNull "$PSScriptRoot\ini.ini" | ForEach-Object {[void]$ListView1_PageSC.Items.Add($_)}
#Get-ItemNull -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Property | ForEach-Object {[void]$DropBox1_PageSC.Items.Add($_)}
#Get-ItemNull | Select-Object Name, Length, Extension
#Get-ItemNull -Path "$FilePath\*.*" -Name | ForEach-Object {[void]$DropBox1_PagePB.Items.Add($_)}
#Remove-ItemNull -Path "$env:temp\`$CON" -Recurse
#GetProcessNull | Select-Object -Property Name, WorkingSet, PeakWorkingSet | Sort-Object -Property WorkingSet -Descending | Out-GridView
#InvokeCommandNull -ComputerName S1, S2, S3 -ScriptBlock {Get-Culture} | Out-GridView
#$Rnd = Get-Random -Minimum 1 -Maximum 100
#If ([string]::IsNullOrEmpty($InitialDirectory) -eq $False) { $FolderBrowserDialog.SelectedPath = $InitialDirectory }
#If ($FolderBrowserDialog.ShowDialog($MainForm) -eq [System.Windows.Forms.DialogResult]::OK) { $return = $($FolderBrowserDialog.SelectedPath) }
#Try { $FolderBrowserDialog.Dispose() } Catch {}
#🗃\🗂\🧾\💾\🗳\🏗\🛠\🪛\✂\🗜\✒\✏\🥾\🪟\🛜\🔄\🌐\🛡\🪪\✅\❎\🚫\⏳\🏁\🎨\❗\🛳\🚽\💥\🚥\🚦\🕸\🐜\🛤\🏞\🌕\🌑\◀\▶\❕#