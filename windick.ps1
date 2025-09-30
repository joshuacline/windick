# Windows Deployment Image Customization Kit v 1209 (c) github.com/joshuacline
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
$panel = New-Object System.Windows.Forms.Panel
$panel.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
if ($C) {$panel.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_PAG_COLOR")}
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$panel.Location = New-Object Drawing.Point($XLOC, $YLOC)
$panel.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$panel.Dock = 'Fill'
$form.Controls.Add($panel)
return $panel
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewPictureBox {
param([int]$X,[int]$Y,[int]$H,[int]$W)
$pictureBox = New-Object System.Windows.Forms.PictureBox
$pictureDecrypt = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($pictureBase64))
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$pictureBox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$pictureBox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$pictureBox.Image = $pictureDecrypt
$pictureBox.SizeMode = 'StretchImage';#Normal, StretchImage, AutoSize, CenterImage, Zoom
$pictureBox.Visible = $true
$element = $pictureBox;AddElement
return $pictureBox
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function NewTextBox {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text,[string]$Check)
$textbox = New-Object System.Windows.Forms.TextBox
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
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
$richTextBox = New-Object System.Windows.Forms.RichTextBox
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
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
$listview = New-Object System.Windows.Forms.ListView
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
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
$label = New-Object Windows.Forms.Label
$label.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$fontX = [int]($GUI_SCALE / $DpiCur * $TextSize * $ScaleRef);$fontX = [Math]::Floor($fontX);
if ($Bold -eq 'True') {$FontStyle = 'Bold';$LabelFont = 'Consolas'} else {$FontStyle = 'Regular'}
if ($TextSize) {$label.Font = New-Object System.Drawing.Font("$LabelFont", $fontX,[System.Drawing.FontStyle]::$FontStyle)}
$label.Location = New-Object Drawing.Point($XLOC, $YLOC)
$label.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$label.AutoSize = $true
if ($TextAlign) {$label.AutoSize = $false
$label.Dock = "None";#None, Top, Bottom, Left, Right, Fill
#$label.TextAlign = "CenterScreen";#MiddleCenter, TopLeft, CenterScreen, Center, Fill
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter}
$label.Text = "$Text"
$element = $label;AddElement
return $label
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MessageBox {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxChoices,[string]$MessageBoxText,[string]$Check)
if ($MessageBoxChoices) {$parta, $partb, $partc, $partd, $parte, $partf, $partg, $parth, $parti, $partj, $partk, $partl, $partm, $partn, $parto = $MessageBoxChoices -split '[,]'}
$formbox = New-Object System.Windows.Forms.Form
$formbox.SuspendLayout()
if ($MessageBoxTitle) {$formbox.Text = "$MessageBoxTitle"}
#$formbox.ForeColor = 'White'
$formbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formbox.StartPosition = "CenterScreen"
$formbox.FormBorderStyle = 'FixedDialog'
$formbox.MaximizeBox = $false
$formbox.MinimizeBox = $true
$formbox.ControlBox = $False
$formbox.AutoSizeMode = 'GrowAndShrink'
$formbox.AutoScale = $true
$formbox.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$WindowState = 'Normal'
$WSIZ = [int](500 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](275 * $ScaleRef * $GUI_SCALE)
$formbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formbox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$labelbox = New-Object System.Windows.Forms.Label
$labelbox.Text = "$MessageBoxText"
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
#$labelbox.AutoSize = $true
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
#$label.TextAlign = "MiddleCenter"
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
if ($MessageBoxType -eq 'YesNo') {
$okButton = New-Object System.Windows.Forms.Button
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](185 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](150 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.Cursor = 'Hand'
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.DialogResult = "OK"
$okButton.Text = "Yes"
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "No"
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](325 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](150 * $ScaleRef * $GUI_SCALE)
$cancelButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$cancelButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$cancelButton.Cursor = 'Hand'
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$cancelButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$cancelButton.Add_MouseEnter({$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$cancelButton.Add_MouseLeave({$cancelButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$cancelButton.DialogResult = "CANCEL"
$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](100 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($cancelButton)
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Info') {
$okButton = New-Object System.Windows.Forms.Button
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](325 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](150 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.Cursor = 'Hand'
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.DialogResult = "OK"
$okButton.Text = "OK"
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](100 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($okButton)}
if ($MessageBoxType -eq 'Prompt') {
$WSIZ = [int](430 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](40 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](85 * $ScaleRef * $GUI_SCALE)
$inputbox = New-Object System.Windows.Forms.TextBox
$inputbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$inputbox.Size = New-Object System.Drawing.Size($WSIZ,$HSIZ)
$inputbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$inputbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$inputbox.Add_TextChanged({$charpass = $true
ForEach ($i in @("NUMBER","LETTER","ALPHA","PATH","MENU","MOST")) {if ($Check -eq "$i") {#"[](){}<>!@#$%^&*|;:,.?_~=+-/``\\[]"
if ($Check -eq 'NUMBER') {$allowed = "0-9"}
if ($Check -eq 'LETTER') {$allowed = "a-zA-Z"}
if ($Check -eq 'ALPHA') {$allowed = "a-zA-Z0-9._-"}
if ($Check -eq 'PATH') {$allowed = "a-zA-Z0-9._\\: -"}
if ($Check -eq 'MENU') {$allowed = "a-zA-Z0-9._@#$+=~*-"}
if ($Check -eq 'MOST') {$allowed = "a-zA-Z0-9._@#$+=~\\:`/(){}%* -"}
$global:textX = "$($this.Text)";if (-not ($this.Text -notmatch "[^$allowed]")) {$this.Text = "$textXlast"} else {$global:textXlast = "$textX"}}}
if (-not ($inputbox.Text.Length -gt 0)) {$charpass = $false}
if ($charpass -eq $true) {$okButton.Enabled = $true} else {$okButton.Enabled = $false}
})
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Enabled = $false
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](325 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](150 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.Cursor = 'Hand'
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.DialogResult = "OK"
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](100 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
#$labelbox.AutoSize = $true
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($inputbox)
$formbox.Controls.Add($okButton)
$formbox.Controls.Add($cancelButton)}
if ($MessageBoxType -eq 'Choice') {
$dropbox = New-Object System.Windows.Forms.ComboBox
$WSIZ = [int](430 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](40 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](25 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](85 * $ScaleRef * $GUI_SCALE)
$dropbox.DropDownStyle = 'DropDownList'
$dropbox.FlatStyle = 'Flat'
$dropbox.Location = New-Object Drawing.Point($XLOC, $YLOC)
$dropbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$dropbox.DisplayMember = "$DisplayMember"
$dropbox.Text = "$Text"
$dropbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_BACK")
$dropbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
ForEach ($i in @("$parta","$partb","$partc","$partd","$parte","$partf","$partg","$parth","$parti","$partj","$partk","$partl","$partm","$partn","$parto","$partp","$partq","$partr","$parts","$partt","$partu","$partv","$partw","$partx","$party","$partz")) {if ($i) {$dropbox.Items.Add($i)}}
#$dropbox.Add_TextChanged({$dropbox.Text = "changed"})
$dropbox.SelectedIndex = 0;#$dropbox.SelectedItem = "$parta"
$dropbox.Add_SelectedIndexChanged({$null})
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](325 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](150 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.Cursor = 'Hand'
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.DialogResult = "OK"
$WSIZ = [int](475 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](100 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($dropbox)
$formbox.Controls.Add($okButton)}
$formbox.Controls.Add($labelbox)
$formbox.ResumeLayout();$global:boxresult = $formbox.ShowDialog()
$global:boxoutput = $null;$global:boxindex = $null;
if ($MessageBoxType -eq 'Prompt') {if ($inputbox.Text) {$global:boxoutput = $inputbox.Text} else {$global:boxresult = $null}}
if ($MessageBoxType -eq 'Choice') {if ($dropbox.SelectedItem) {$global:boxoutput = $dropbox.SelectedItem;$global:boxindex = $dropbox.SelectedIndex} else {$global:boxresult = $null}}
$formbox.Dispose()
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function MessageBoxAbout {
param([string]$MessageBoxType,[string]$MessageBoxTitle,[string]$MessageBoxText)
$formbox = New-Object System.Windows.Forms.Form
$formbox.SuspendLayout()
if ($MessageBoxTitle) {$formbox.Text = "$MessageBoxTitle"}
$formbox.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BG_COLOR")
$formbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$formbox.StartPosition = "CenterScreen"
$formbox.FormBorderStyle = 'FixedDialog'
$formbox.MaximizeBox = $false
$formbox.MinimizeBox = $true
$formbox.ControlBox = $False
$formbox.AutoSizeMode = 'GrowAndShrink'
$formbox.AutoScale = $true
$formbox.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::DPI
$WindowState = 'Normal'
$WSIZ = [int](600 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](450 * $ScaleRef * $GUI_SCALE)
$formbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
if ($GUI_FONTSIZE -eq 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * 16 * $ScaleRef);$fontX = [Math]::Floor($fontX);}
if ($GUI_FONTSIZE -ne 'Auto') {$fontX = [int]($GUI_SCALE / $DpiCur * $GUI_FONTSIZE * $ScaleRef);$fontX = [Math]::Floor($fontX)}
$formbox.Font = New-Object System.Drawing.Font("", $fontX,[System.Drawing.FontStyle]::Regular)
$okButton = New-Object System.Windows.Forms.Button
$WSIZ = [int](135 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](45 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](225 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](375 * $ScaleRef * $GUI_SCALE)
$okButton.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$okButton.Size = New-Object Drawing.Size($WSIZ,$HSIZ)
$okButton.Cursor = 'Hand'
$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$okButton.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$okButton.Add_MouseEnter({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_HLT_COLOR")})
$okButton.Add_MouseLeave({$okButton.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")})
$okButton.DialogResult = "OK"
$okButton.Text = "OK"
$labelbox = New-Object System.Windows.Forms.Label
$WSIZ = [int](600 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](110 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0)
$YLOC = [int](290 * $ScaleRef * $GUI_SCALE)
$labelbox.Location = New-Object System.Drawing.Point($XLOC, $YLOC)
$labelbox.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$labelbox.Dock = "None";#None, Top, Bottom, Left, Right, Fill
$labelbox.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$labelbox.Text = "For documentation visit github.com/joshuacline"
$labelbox.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$Page = 'x';$pictureBase64 = $logojpgB64;$PictureBox1_PageSP = NewPictureBox -X '15' -Y '15' -W '565' -H '300';$formbox.Controls.Add($PictureBox1_PageSP);
$pictureBase64 = $logo2;$PictureBox2_PageSP = NewPictureBox -X '255' -Y '200' -W '20' -H '20';$formbox.Controls.Add($PictureBox2_PageSP);$PictureBox2_PageSP.BringToFront()
$formbox.AcceptButton = $okButton
$formbox.Controls.Add($okButton)
$formbox.Controls.Add($labelbox)
$formbox.ResumeLayout()
$formbox.ShowDialog()
$formbox.Dispose()
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
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$slider = New-Object System.Windows.Forms.TrackBar
$slider.Minimum = 0
$slider.Maximum = 100
$slider.TickFrequency = 10
$slider.LargeChange = 10
$slider.SmallChange = 1
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$slider.Width = $WSIZ
$slider.Location = New-Object Drawing.Point($XLOC, $YLOC)
$slider.Add_Scroll({$Add_Scroll})
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
function NewPageButton {
param([int]$X,[int]$Y,[int]$H,[int]$W,[string]$Text)
$button = New-Object Windows.Forms.Button
$WSIZ = [int]($W * $ScaleRef * $GUI_SCALE)
$HSIZ = [int]($H * $ScaleRef * $GUI_SCALE)
$XLOC = [int]($X * $ScaleRef * $GUI_SCALE)
$YLOC = [int]($Y * $ScaleRef * $GUI_SCALE)
$button.Location = New-Object Drawing.Point($XLOC, $YLOC)
$button.Size = New-Object Drawing.Size($WSIZ, $HSIZ)
$button.Text = $Text
$button.Cursor = 'Hand'
#$button.FlatStyle = 'Flat'
#$button.FlatAppearance.BorderSize = '3'
$button.ForeColor = [System.Drawing.Color]::FromArgb("0X$GUI_TXT_FORE")
$button.BackColor = [System.Drawing.Color]::FromArgb("0X$GUI_BTN_COLOR")
$button.Add_Click({
$Button_V2W.Tag = 'Disable'
$Button_W2V.Tag = 'Disable'
$Button_LB.Tag = 'Disable'
$Button_PB.Tag = 'Disable'
$Button_BC.Tag = 'Disable'
$Button_SC.Tag = 'Disable'
$Button_SP.Tag = 'Disable'
$this.Tag = 'Enable'
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageLB {
$ListView1_PageLB.Items.Clear();$ListView2_PageLB.Items.Clear()
$PathCheck = "$PSScriptRoot\\list"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
#Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$DropBox1_PageLB.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLB.Items.Add($_)}
Get-ChildItem -Path "$FilePath\*.base" -Name | ForEach-Object {[void]$ListView2_PageLB.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PagePB {
$ListView1_PagePB.Items.Clear();$ListView2_PagePB.Items.Clear()
$PathCheck = "$PSScriptRoot\\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePB.Items.Add($_)}
$PathCheck = "$PSScriptRoot\\project"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\project"
Get-ChildItem -Path "$FilePath" -Name | ForEach-Object {[void]$ListView2_PagePB.Items.Add($_)}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function Button_PageBC {
$DropBox3_PageBC.Items.Clear();$DropBox3_PageBC.Items.Add("Refresh");$DropBox3_PageBC.Text = "Select Disk"
$PathCheck = "$PSScriptRoot\\image\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\image"} else {$FilePath = "$PSScriptRoot"}
if (Test-Path -Path $FilePath\$($DropBox1_PageBC.SelectedItem)) {$null} else {$DropBox1_PageBC.SelectedItem = $null}
$ListView1_PageBC.Items.Clear();Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PageBC.Items.Add($_)}
$DropBox1_PageBC.ResetText();$DropBox1_PageBC.Items.Clear();$DropBox1_PageBC.Text = "Select .vhdx"
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$DropBox1_PageBC.Items.Add($_)}
$PathCheck = "$PSScriptRoot\\cache\\*"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\cache"} else {$FilePath = "$PSScriptRoot"}
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
if ($($DropBox3_PageSC.SelectedItem)) {$null} else {$DropBox3_PageSC.ResetText();$DropBox3_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36','40','44','48','52','56','60','64','68','72')) {$DropBox3_PageSC.Items.Add($i)}
$DropBox3_PageSC.SelectedItem = "$GUI_LVFONTSIZE"}
if ($($DropBox4_PageSC.SelectedItem)) {$null} else {$DropBox4_PageSC.ResetText();$DropBox4_PageSC.Items.Clear();ForEach ($i in @('Auto','2','4','6','8','10','12','14','16','18','20','22','24','26','28','30','32','36','40','44','48','52','56','60','64','68','72')) {$DropBox4_PageSC.Items.Add($i)}
$DropBox4_PageSC.SelectedItem = "$GUI_FONTSIZE"}
if ($($DropBox5_PageSC.SelectedItem)) {$null} else {
$DropBox5_PageSC.ResetText();$DropBox5_PageSC.Items.Clear();
$DropBox5_PageSC.Items.Add("🎨 Theme");$DropBox5_PageSC.Items.Add("Button");$DropBox5_PageSC.Items.Add("Highlight");$DropBox5_PageSC.Items.Add("Text Color");$DropBox5_PageSC.Items.Add("Text Canvas");$DropBox5_PageSC.Items.Add("Side Panel");$DropBox5_PageSC.Items.Add("Background")}
$DropBox5_PageSC.SelectedItem = ""
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportBoot {
$PathCheck = "$PSScriptRoot\\cache";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\cache"} else {$FilePath = "$PSScriptRoot"}
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportWim {
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function ImportWallpaper {
$DropBox2_PageBC.SelectedItem = $null
$FilePath = $HOME;$FileFilt = "Picture files (*.jpg;*.png)|*.jpg;*.png";PickFile
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
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
$Label2_PagePBWiz.Text = ""
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
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\\pack";if (Test-Path -Path $PathCheck) {$FilePathPKX = "$PSScriptRoot\pack\$boxoutput.pkx"} else {$FilePathPKX = "$PSScriptRoot\$boxoutput.pkx"}
$command = @"
DISM /ENGLISH /CAPTURE-IMAGE /CAPTUREDIR:"$PSScriptRoot\project" /IMAGEFILE:"$FilePathPKX" /COMPRESS:Fast /NAME:"PKX" /CheckIntegrity /Verify
"@
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-CUSTOM","ARG4=`$LIST","ARG5=-LIVE")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
ForEach ($i in @("EXEC-LIST","[COMMANDQ][ECHO.           %@@%PACKAGE CREATE START`:%`$`$%  %DATE%  %TIME%][CMD][DX]","[COMMANDQ][$command][CMD][DX]","[COMMANDQ][ECHO.][CMD][DX]","[COMMANDQ][ECHO.            %@@%PACKAGE CREATE END`:%`$`$%  %DATE%  %TIME%][CMD][DX]")) {Add-Content -Path "$FilePathLST" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB;
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}

if ($ListViewChoiceS2 -eq "🗳 New Package Template") {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Delete' -MessageBoxText 'This will empty the contents of the project folder. Are you sure?'
if ($boxresult -ne "OK") {$global:PBWiz_Stage = 1;}
if ($boxresult -eq "OK") {$PathCheck = "$PSScriptRoot\\project";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\project" -Recurse -Force}
New-Item -ItemType Directory -Path "$PSScriptRoot\project\driver"
ForEach ($i in @("EXEC-LIST","Delete the driver list entry below and driver folder if there are not drivers included in the package.",'[DRIVER]["%PKX_FOLDER%\driver"][INSTALL][DX]',"Delete the command list entry below and package.cmd if a script is not needed.",'[COMMAND][CMD /C "%PKX_FOLDER%\package.cmd"][CMD][DX]',"Manually add, copy and paste items, or replace this package.list with an existing execution list.","Copy any listed items such as scripts, installers, appx, cab, and msu packages into the project folder before package creation.")) {Add-Content -Path "$PSScriptRoot\project\package.list" -Value "$i" -Encoding UTF8}
ForEach ($i in @("::================================================","::These variables are built in and can help","::keep a script consistant throughout the entire","::process, whether applying to a vhdx or live.","::Add any files to package folder before creating.","::================================================","::Windows folder :    %WINTAR%","::Drive root :        %DRVTAR%","::User or defuser :   %USRTAR%","::HKLM\SOFTWARE :     %HIVE_SOFTWARE","::HKLM\SYSTEM :       %HIVE_SYSTEM%","::HKCU or defuser :   %HIVE_USER%","::DISM target :       %APPLY_TARGET%","::==================START OF PACK=================","","@ECHO OFF",'REM "%PKX_FOLDER%\example.msi" /quiet /noprompt',"","::===================END OF PACK==================")) {Add-Content -Path "$PSScriptRoot\project\package.cmd" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB}}

if ($ListViewChoiceS2 -eq "🗳 Restore Package") {
$Label1_PagePBWiz.Text = "🗳 Restore Package"
$Label2_PagePBWiz.Text = "Select a Package"
$ListView1_PagePBWiz.Items.Clear()
$PathCheck = "$PSScriptRoot\\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePBWiz.Items.Add($_)}
}
if ($ListViewChoiceS2 -eq "🔄 Export Drivers") {
$Label1_PagePBWiz.Text = "🔄 Export Drivers"
$Label2_PagePBWiz.Text = "Select a Source"
$ListView1_PagePBWiz.CheckBoxes = $false;$ListView1_PagePBWiz.Items.Clear();
$global:Show_ENV = $null;$ListView1_PagePBWiz.Items.Add("🪟 Current Environment")
$PathCheck = "$PSScriptRoot\\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
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
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\\project";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\project" -Recurse -Force}
New-Item -ItemType Directory -Path "$PSScriptRoot\project"
$PathCheck = "$PSScriptRoot\\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
$command = @"
DISM /ENGLISH /APPLY-IMAGE /IMAGEFILE:"$FilePath\$ListViewChoiceS3" /INDEX:1 /APPLYDIR:"$PSScriptRoot\project"
"@
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-CUSTOM","ARG4=`$LIST","ARG5=-LIVE")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
ForEach ($i in @("EXEC-LIST","[COMMANDQ][ECHO.           %@@%PACKAGE EXTRACT START`:%`$`$%  %DATE%  %TIME%][CMD][DX]","[COMMANDQ][$command][CMD][DX]","[COMMANDQ][ECHO.][CMD][DX]","[COMMANDQ][ECHO.            %@@%PACKAGE EXTRACT END`:%`$`$%  %DATE%  %TIME%][CMD][DX]")) {Add-Content -Path "$FilePathLST" -Value "$i" -Encoding UTF8}
$global:PBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePBWiz.Visible = $false;Button_PagePB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage1 {$global:LEWiz_Stage = 1;
$Label1_PageLEWiz.Text = "🧾 List Execute"
$Label2_PageLEWiz.Text = "Select a List"
$ListView1_PageLEWiz.GridLines = $false
$ListView1_PageLEWiz.CheckBoxes = $false
$ListView1_PageLEWiz.FullRowSelect = $true
$ListView1_PageLEWiz.Items.Clear();
$PathCheck = "$PSScriptRoot\\list"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LEWiz_Stage2 {$global:LEWiz_Stage = 2;
$Label1_PageLEWiz.Text = "🧾 List Execute"
$Label2_PageLEWiz.Text = "Select a Target"
if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PageLEWiz.FocusedItem}
$ListView1_PageLEWiz.GridLines = $false;$ListView1_PageLEWiz.CheckBoxes = $false;$ListView1_PageLEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]'
$ListView1_PageLEWiz.Items.Clear();
if ($Allow_ENV -eq 'ENABLED') {$ListView1_PageLEWiz.Items.Add("🪟 Current Environment")}
$PathCheck = "$PSScriptRoot\\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
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
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage1 {$global:PEWiz_Stage = 1;
$Label1_PagePEWiz.Text = "🗳 Pack Execute"
$Label2_PagePEWiz.Text = "Select a Package"
$ListView1_PagePEWiz.GridLines = $false
$ListView1_PagePEWiz.CheckBoxes = $false
$ListView1_PagePEWiz.FullRowSelect = $true
$ListView1_PagePEWiz.Items.Clear();
$PathCheck = "$PSScriptRoot\\pack"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\pack"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.pkx" -Name | ForEach-Object {[void]$ListView1_PagePEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage2 {$global:PEWiz_Stage = 2;
$Label1_PagePEWiz.Text = "🗳 Pack Execute"
$Label2_PagePEWiz.Text = "Select a Target"
if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PagePEWiz.FocusedItem}
$ListView1_PagePEWiz.GridLines = $false;$ListView1_PagePEWiz.CheckBoxes = $false;$ListView1_PagePEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS2, $partc = $ListViewSelectS2 -split '[{}]'
$ListView1_PagePEWiz.Items.Clear();
if ($Allow_ENV -eq 'ENABLED') {$ListView1_PagePEWiz.Items.Add("🪟 Current Environment")}
$PathCheck = "$PSScriptRoot\\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.vhdx" -Name | ForEach-Object {[void]$ListView1_PagePEWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PEWiz_Stage3 {$global:PEWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PagePEWiz.FocusedItem}
$ListView1_PagePEWiz.GridLines = $false;$ListView1_PagePEWiz.CheckBoxes = $false;$ListView1_PagePEWiz.FullRowSelect = $true
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-RUN","ARG3=-PKX","ARG4=$ListViewChoiceS2")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS3 -eq "🪟 Current Environment") {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "ARG5=-LIVE" -Encoding UTF8}
if ($ListViewChoiceS3 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS3")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}
$global:PEWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PagePB.Visible = $true;$PagePEWiz.Visible = $false;Button_PagePB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage1 {$global:LBWiz_Stage = 1;
$Label1_PageLBWiz.Text = "🧾 List Builder"
$Label2_PageLBWiz.Text = ""
$ListView1_PageLBWiz.GridLines = $false
$ListView1_PageLBWiz.CheckBoxes = $false
$ListView1_PageLBWiz.FullRowSelect = $true
$ListView1_PageLBWiz.Items.Clear();
$item1 = New-Object System.Windows.Forms.ListViewItem("🧾 Miscellaneous")
#$item1.SubItems.Add("Description for X")
$ListView1_PageLBWiz.Items.Add($item1)
$PathCheck = "$PSScriptRoot\\list"
if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.base" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage2 {$global:LBWiz_Stage = 2;
$GRP = $null;if ($marked -ne $null) {$global:ListViewSelectS2 = $marked} else {$global:ListViewSelectS2 = $ListView1_PageLBWiz.FocusedItem}
$parta, $global:BaseFile, $partc = $ListViewSelectS2 -split '[{}]';
$ListView1_PageLBWiz.Items.Clear()
$ListView1_PageLBWiz.GridLines = $false
$ListView1_PageLBWiz.CheckBoxes = $false
$ListView1_PageLBWiz.FullRowSelect = $true
if ($BaseFile -eq "🧾 Miscellaneous") {$global:LBWiz_Type = 'MISC';}
if ($BaseFile -ne "🧾 Miscellaneous") {$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
$global:LBWiz_Type = Get-Content -Path "$FilePath\$BaseFile" -TotalCount 1}
if ($LBWiz_Type -eq 'MISC') {
$Label1_PageLBWiz.Text = "🧾 List Builder"
$Label2_PageLBWiz.Text = "Miscellaneous"
ForEach ($i in @("🧾 Create Source Base","🧾 Create Group Base","🪛 Group Seperator Item","🪛 Prompt TextBox Item","🪛 Choice Menu Item","✒ External Package Item","✒ Command Operation Item","🧾 Create Multi List")) {$ListView1_PageLBWiz.Items.Add("$i")}
}
if ($LBWiz_Type -eq 'BASE-GROUP') {
$Label1_PageLBWiz.Text = "🧾 List Builder"
$Label2_PageLBWiz.Text = "$BaseFile"
Get-Content "$FilePath\$BaseFile" | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh = $_ -split "[][]"
if ($partXb -eq 'GROUP') {if (-not ($partXd -eq $GRP)) {
$GRP = "$partXd"#$item1.SubItems.Add("$partXf")
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXd")
$ListView1_PageLBWiz.Items.Add($item1)}}}}
if ($LBWiz_Type -eq 'BASE-LIST') {
$Label1_PageLBWiz.Text = "🧾 List Builder"
$Label2_PageLBWiz.Text = "$BaseFile"
Get-Content "$FilePath\$BaseFile" | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh = $_ -split "[][]"
if (-not ($partXb -eq $GRP)) {
$add_item = $null;$GRP = "$partXb"
if ($partXb -eq 'APPX') {$add_item = 'AppX'}
if ($partXb -eq 'CAPABILITY') {$add_item = 'Capability'}
if ($partXb -eq 'FEATURE') {$add_item = 'Feature'}
if ($partXb -eq 'SERVICE') {$add_item = 'Service'}
if ($partXb -eq 'TASK') {$add_item = 'Task'}
if ($partXb -eq 'COMPONENT') {$add_item = 'Component'}
if ($partXb -eq 'DRIVER') {$add_item = 'Driver'}
if ($add_item -ne $null) {$ListView1_PageLBWiz.Items.Add("$add_item")
}}}}}
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
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "✒ External Package Item") {
$Label1_PageLBWiz.Text = "🧾 List Builder";
$Label2_PageLBWiz.Text = "Select a Package"
$ListView1_PageLBWiz.Items.Clear();$PathCheck = "$PSScriptRoot\\pack";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\pack"} else {$FilePath = "$PSScriptRoot"}
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
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Time of Action' -MessageBoxText 'Select a run time' -MessageBoxChoices "[DX] Default - Immediate execution,[SC] SetupComplete - Scheduled execution,[RO] RunOnce - Scheduled execution"
if ($boxoutput -eq "[DX] Default - Immediate execution") {$global:ExecuteTime = "DX"}
if ($boxoutput -eq "[SC] SetupComplete - Scheduled execution") {$global:ExecuteTime = "SC"}
if ($boxoutput -eq "[RO] RunOnce - Scheduled execution") {$global:ExecuteTime = "RO"}
if ($boxresult -eq "OK") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "🪛 Choice Menu Item") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Choice Item' -MessageBoxText 'Enter message for the choice prompt.' -Check 'PATH';$global:ChoiceMsg = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Select the choice number' -MessageBoxChoices "0,1,2,3,4,5,6,7,8,9";$global:ChoiceNum = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Choice prompt' -MessageBoxText 'Select the choice type. CHOICE saves the chosen index, STRING saves the string.' -MessageBoxChoices "CHOICE,STRING";$global:ChoiceTypeX = "$boxoutput"
if ($boxresult -eq "OK") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "🪛 Prompt TextBox Item") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Prompt Item' -MessageBoxText 'Enter message for the prompt.' -Check 'PATH';$global:PromptMsg = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Select the prompt number' -MessageBoxChoices "0,1,2,3,4,5,6,7,8,9";$global:PromptNum = "$boxoutput"
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Character Filter' -MessageBoxText 'Select the character filter type' -MessageBoxChoices "NONE,NUMBER,LETTER,ALPHA,MENU,PATH,MOST";$global:PromptFilt = "$boxoutput"
if ($boxresult -eq "OK") {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($boxresult -ne "OK") {$global:LBWiz_Stage = 2}}

if ($ListViewChoiceS3 -eq "🧾 Create Multi List") {
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Multi List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 2;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";
if (Test-Path -Path $ListTarget) {Remove-Item -Path "$ListTarget" -Force}
$EmptyListNew = [Convert]::FromBase64String($EmptyMultiList);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)
ForEach ($i in @("[GROUP][Mount and Unmount VHDX list items][EXAMPLE]","[MOUNT][                      Select the filesystem target][                           This is an example]","[CONFIRM][                    This is a confirmation prompt.][              If not confirmed, progress will be halted.]","[COMMANDQ][ECHO.Recommended to put this at the top of any subgroup.][CMD][DX]","[COMMANDQ][ECHO.Default target is the live system when this item is not used.][CMD][DX]",'[COMMAND][DIR /B "%DRVTAR%\"][CMD][DX]','[COMMAND][REG QUERY "%HIVE_USER%"][REG][DX]',"[UNMOUNT][Unmount VHDX][Detaches virtual disk if it was attached during this instance.]","[COMMANDQ][ECHO.Recommended to put this at the bottomm of any subgroup.][CMD][DX]","[COMMANDQ][ECHO.Target returns to the live system following the usage of this item.][CMD][DX]",'[COMMAND][DIR /B "%DRVTAR%\"][CMD][DX]','[COMMAND][REG QUERY "%HIVE_USER%"][REG][DX]',"[GROUP][Pick file][EXAMPLE]","[PICK][                             Select a file][                           This is an example][%IMAGE_FOLDER%\*.WIM]","[COMMANDQ][ECHO. `$PICK: %`$PICK%  `$CHOICE: %`$CHOICE%][CMD][DX]","[PICK][                             Select a file][                           This is an example][%LIST_FOLDER%\*.BASE]","[COMMANDQ][ECHO. `$PICK: %`$PICK%  `$CHOICE: %`$CHOICE%][CMD][DX]")) {Add-Content -Path "$ListTarget" -Value "$i" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}}

if ($ListViewChoiceS3 -eq "🧾 Create Group Base") {
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create Group Base' -MessageBoxText 'Enter new .base name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 2;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.base";$ListTarget = "$FilePath\$boxoutput.base";
if (Test-Path -Path $ListTarget) {Remove-Item -Path "$ListTarget" -Force}
$EmptyListNew = [Convert]::FromBase64String($EmptyBaseGroup);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)
ForEach ($i in @("[GROUP][🪛 Basic Option][✅ Basic SubOption Enable]","[COMMANDQ][ECHO.✅ Basic SubOption Enable was picked.][CMD][DX]","[GROUP][🪛 Basic Option][❎ Basic SubOption Disable]","[COMMANDQ][ECHO.❎ Basic SubOption Disable was picked.][CMD][DX]","[GROUP][🛠️ Advanced Option][🛠️ Advanced SubOption]","[CHOICE1][Select an option][✅ Advanced SubOption Enable,❎ Advanced SubOption Disable][VolaTILE]",'[COMMANDQ][IF "%CHOICE1%"=="1" ECHO.✅ Advanced SubOption Enable was picked.][CMD][DX]','[COMMANDQ][IF "%CHOICE1%"=="2" ECHO.❎ Advanced SubOption Disable was picked.][CMD][DX]',"[STRING1][Select an option][String1,String2][VolaTILE]","[COMMANDQ][ECHO.%STRING1% was picked.][CMD][DX]","[COMMANDQ][ECHO.COMMAND list items without an IF CHOICE always execute.][CMD][DX]",'[COMMAND][DIR /B "%DRVTAR%\"][CMD][DX]',"[COMMANDQ][ECHO.The 'REG' command list option mounts the registry upon execution.][CMD][DX]",'[COMMAND][REG QUERY "%HIVE_USER%"][REG][DX]',"[COMMANDQ][ECHO.COMMANDQ mutes the command announcement on screen.][CMD][DX]","[COMMANDQ][ECHO.NULL mutes the command execution on screen.][CMD][DX]",'[COMMAND][REG QUERY "%HIVE_USER%" %NULL%][REG][DX]')) {Add-Content -Path "$ListTarget" -Value "$i" -Encoding UTF8}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4MISC {$global:LBWiz_Stage = 4;
if ($marked -ne $null) {$global:ListViewSelectS4 = $marked} else { $global:ListViewSelectS4 = $ListView1_PageLBWiz.FocusedItem}
$parta, $global:ListViewChoiceS4, $partc = $ListViewSelectS4 -split '[{}]'
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
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
$Label2_PageLBWiz.Text = "Select a Source"
}}

if ($ListViewChoiceS3 -eq "🪛 Group Seperator Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$EmptyListNew = [Convert]::FromBase64String($EmptyExecList);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)}
}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
Add-Content -Path "$ListTarget" -Value "[Note: Place into a Group Base to begin using.]" -Encoding UTF8;Add-Content -Path "$ListTarget" -Value "[GROUP][$GroupName][$SubGroupName]" -Encoding UTF8
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options added to $ListName";
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "✒ External Package Item") {
MessageBox -MessageBoxType 'Choice' -MessageBoxTitle 'Time of Action' -MessageBoxText 'Select a run time' -MessageBoxChoices "[DX] Default - Immediate execution,[SC] SetupComplete - Scheduled execution,[RO] RunOnce - Scheduled execution"
if ($boxoutput -eq "[DX] Default - Immediate execution") {$global:ExecuteTime = "DX"}
if ($boxoutput -eq "[SC] SetupComplete - Scheduled execution") {$global:ExecuteTime = "SC"}
if ($boxoutput -eq "[RO] RunOnce - Scheduled execution") {$global:ExecuteTime = "RO"}
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$Label1_PageLBWiz.Text = "💾 Append Items";$Label2_PageLBWiz.Text = "Select a List"
$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}}
if ($ListViewChoiceS3 -eq "✒ Command Operation Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {
MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$EmptyListNew = [Convert]::FromBase64String($EmptyExecList);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)}}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
Add-Content -Path "$ListTarget" -Value "[$AnncType][$CommandItem][$CommandTypeX$RunAsX][$ExecuteTime]" -Encoding UTF8
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "🪛 Choice Menu Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list"
if (Test-Path -Path $ListTarget) {$null} else {$EmptyListNew = [Convert]::FromBase64String($EmptyExecList);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)}}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
ForEach ($i in @("[Note: Place into a Group Base to begin using.]","[$ChoiceTypeX$ChoiceNum][$ChoiceMsg][Option One,Option Two,Option Three][VolaTILE]","[COMMANDQ][ECHO.$ChoiceTypeX$ChoiceNum`: %$ChoiceTypeX$ChoiceNum%][CMD][DX]")) {Add-Content -Path "$ListTarget" -Value "$i" -Encoding UTF8}
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}

if ($ListViewChoiceS3 -eq "🪛 Prompt TextBox Item") {
if ($ListViewChoiceS4 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 3;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list"
if (Test-Path -Path $ListTarget) {$null} else {$EmptyListNew = [Convert]::FromBase64String($EmptyExecList);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)}}}
if ($ListViewChoiceS4 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS4";$ListTarget = "$FilePath\$ListViewChoiceS4"}
ForEach ($i in @("[Note: Place into a Group Base to begin using.]","[PROMPT$PromptNum][$PromptMsg][$PromptFilt][VolaTILE]","[COMMANDQ][ECHO.PROMPT$PromptNum`: %PROMPT$PromptNum%][CMD][DX]")) {Add-Content -Path "$ListTarget" -Value "$i" -Encoding UTF8}
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5MISC {
if ($marked -ne $null) {$global:ListViewSelectS5 = $marked} else { $global:ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem}
$parta, $ListViewChoiceS5, $partc = $ListViewSelectS5 -split '[{}]'
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}

if ($ListViewChoiceS3 -eq "🧾 Create Source Base") {ForEach ($i in @("","ARG1=-IMAGEMGR","ARG2=-CREATE","ARG3=-BASE","ARG4=$ListName")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($ListViewChoiceS5 -eq "🪟 Current Environment") {ForEach ($i in @("ARG5=-LIVE","ARG6=$ListViewBase")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}
if ($ListViewChoiceS5 -ne "🪟 Current Environment") {ForEach ($i in @("ARG5=-VHDX","ARG6=$ListViewChoiceS5","ARG7=$ListViewBase")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'
return}
if ($ListViewChoiceS5 -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 4;}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$EmptyListNew = [Convert]::FromBase64String($EmptyExecList);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)}}}
if ($ListViewChoiceS5 -ne "🧾 Create New List") {$ListName = "$ListViewChoiceS5";$ListTarget = "$FilePath\$ListViewChoiceS5"}
Add-Content -Path "$ListTarget" -Value "[EXTPACKAGE][$ListViewChoiceS4][INSTALL][$ExecuteTime]" -Encoding UTF8
MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options added to $ListName";$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
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
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
$parta, $ListViewActionZ, $partc = $ListViewSelectS4 -split '[{}]';$parta, $ListViewActionX, $partc = $ListViewActionZ -split '[ ]';$global:ListViewAction = $ListViewActionX.ToUpper()
$ListView1_PageLBWiz.Items.Clear();
$Label1_PageLBWiz.Text = "🧾 $BaseFile"
$Label2_PageLBWiz.Text = "$ListViewChoiceS3"
Get-Content "$FilePath\$BaseFile" | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[][]"
if ($partXb -eq $ListViewChoiceS3) {
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXd");$item1.SubItems.Add("$partXg");$ListView1_PageLBWiz.Items.Add($item1)}
}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.CheckBoxes = $true;$ListView1_PageLBWiz.FullRowSelect = $true
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5SRC {$global:LBWiz_Stage = 5;
$Label1_PageLBWiz.Text = "💾 Append Items"
$Label2_PageLBWiz.Text = "Select a List"
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
$global:checkedItems = $ListView1_PageLBWiz.CheckedItems | ForEach-Object {
$parta, $ListViewChecked, $partc = $_ -split '[{}]';$ListViewFocusX = $ListViewChoiceS3.ToUpper()
Add-Content -Path "$FilePathLST" -Value "[$ListViewFocusX][$ListViewChecked][$ListViewAction][DX]" -Encoding UTF8}
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage6SRC {$global:LBWiz_Stage = 6;
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem
$parta, $partb, $partc = $ListViewSelectS5 -split '[{}]'

if ($partb -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";$global:LBWiz_Stage = 5}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$EmptyListNew = [Convert]::FromBase64String($EmptyExecList);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}}
if ($partb -ne "🧾 Create New List") {$ListName = "$partb";$ListTarget = "$FilePath\$partb"}

Get-Content "$FilePath\`$LIST" | ForEach-Object {Add-Content -Path "$ListTarget" -Value "$_" -Encoding UTF8}
Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8
$PathCheck = "$FilePath\`$LIST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePath\`$LIST" -Force}
if ($ListName -ne "$null") {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options added to $ListName"
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage3GRP {$global:LBWiz_Stage = 3;
if ($marked -ne $null) {$global:ListViewSelectS3 = $marked} else {$global:ListViewSelectS3 = $ListView1_PageLBWiz.FocusedItem}
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
$parta, $global:ListViewChoiceS3, $partc = $ListViewSelectS3 -split '[{}]'
$ListView1_PageLBWiz.Items.Clear();$Label1_PageLBWiz.Text = "🧾 $BaseFile";$Label2_PageLBWiz.Text = "$ListViewChoiceS3"
Get-Content "$FilePath\$BaseFile" | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[][]"
if ($partXb -eq 'GROUP') {
if ($partXd -eq $ListViewChoiceS3) {
$item1 = New-Object System.Windows.Forms.ListViewItem("$partXf");$item1.SubItems.Add("$partXg");$ListView1_PageLBWiz.Items.Add($item1)}}}
$ListView1_PageLBWiz.GridLines = $false;$ListView1_PageLBWiz.CheckBoxes = $true;$ListView1_PageLBWiz.FullRowSelect = $true
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage4GRP {$global:LBWiz_Stage = 4;
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePathLST = "$PSScriptRoot\list\`$LIST"} else {$FilePathLST = "$PSScriptRoot\`$LIST"}
$PathCheck = "$FilePathLST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePathLST" -Force}
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\\list"} else {$FilePath = "$PSScriptRoot"}
#$checkedItems = $ListView1_PageLBWiz.CheckedItems | ForEach-Object { $_.Text }
#[System.Windows.Forms.MessageBox]::Show(("Checked Items: " + ($checkedItems -join ", ")), "Checked Items")
$global:checkedItems = $ListView1_PageLBWiz.CheckedItems | ForEach-Object {$listWrite = 0
$parta, $ListViewChecked, $partc = $_ -split '[{}]'
Get-Content "$FilePath\$BaseFile" | ForEach-Object {
$partXa, $partXb, $partXc, $partXd, $partXe, $partXf, $partXg, $partXh, $partXi, $partXj, $partXk, $partXl, $partXm, $partXn = $_ -split "[][]"
if ($partXb -eq 'GROUP') {if ($partXd -ne $ListViewChoiceS3) {$listWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXf -ne $ListViewChecked) {$listWrite = 0}}
if ($partXb -eq 'GROUP') {if ($partXd -eq $ListViewChoiceS3) {if ($partXf -eq $ListViewChecked) {$listWrite = 1}}}

if ($listWrite -eq '1') {$ListPrompt = $null;
$Label1_PageLBWiz.Text = "$ListViewChoiceS3"
$Label2_PageLBWiz.Text = "$ListViewChecked"
ForEach ($i in @("PROMPT0","PROMPT1","PROMPT2","PROMPT3","PROMPT4","PROMPT5","PROMPT6","PROMPT7","PROMPT8","PROMPT9")) {if ($i -eq "$partXb") {$ListPrompt = 1}}
ForEach ($i in @("CHOICE0","CHOICE1","CHOICE2","CHOICE3","CHOICE4","CHOICE5","CHOICE6","CHOICE7","CHOICE8","CHOICE9")) {if ($i -eq "$partXb") {$ListPrompt = 2}}
ForEach ($i in @("STRING0","STRING1","STRING2","STRING3","STRING4","STRING5","STRING6","STRING7","STRING8","STRING9")) {if ($i -eq "$partXb") {$ListPrompt = 3}}
if ($ListPrompt -eq $null) {Add-Content -Path "$FilePathLST" -Value "$_" -Encoding UTF8}
if ($ListPrompt -eq '1') {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle "$ListViewChecked" -MessageBoxText "$partXd" -Check "$partXf"
if ($boxresult -eq "OK") {Add-Content -Path "$FilePathLST" -Value "[$partXb][$partXd][$partXf][$boxoutput]" -Encoding UTF8} else {Add-Content -Path "$FilePathLST" -Value "[$partXb][$partXd][$partXf][ERROR]" -Encoding UTF8}}
if ($ListPrompt -eq '2') {MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewChecked" -MessageBoxText "$partXd" -MessageBoxChoices "$partXf"
$boxindexX = $boxindex + 1;Add-Content -Path "$FilePathLST" -Value "[$partXb][$partXd][$partXf][$boxindexX]" -Encoding UTF8}
if ($ListPrompt -eq '3') {MessageBox -MessageBoxType 'Choice' -MessageBoxTitle "$ListViewChecked" -MessageBoxText "$partXd" -MessageBoxChoices "$partXf"
Add-Content -Path "$FilePathLST" -Value "[$partXb][$partXd][$partXf][$boxoutput]" -Encoding UTF8}
}}}
$Label1_PageLBWiz.Text = "💾 Append Items"
$Label2_PageLBWiz.Text = "Select a List"
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();$ListView1_PageLBWiz.Items.Add("🧾 Create New List")
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
Get-ChildItem -Path "$FilePath\*.list" -Name | ForEach-Object {[void]$ListView1_PageLBWiz.Items.Add($_)}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function LBWiz_Stage5GRP {
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$ListViewSelectS5 = $ListView1_PageLBWiz.FocusedItem
$parta, $partb, $partc = $ListViewSelectS5 -split '[{}]'

if ($partb -eq "🧾 Create New List") {MessageBox -MessageBoxType 'Prompt' -MessageBoxTitle 'Create List' -MessageBoxText 'Enter new .list name' -Check 'PATH'
if ($boxresult -ne "OK") {$ListName = "$null";}
if ($boxresult -eq "OK") {$ListName = "$boxoutput.list";$ListTarget = "$FilePath\$boxoutput.list";if (Test-Path -Path $ListTarget) {$null} else {$EmptyListNew = [Convert]::FromBase64String($EmptyExecList);[System.IO.File]::WriteAllBytes($ListTarget, $EmptyListNew)}
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
if ($partb -ne "🧾 Create New List") {$ListName = "$partb";$ListTarget = "$FilePath\$partb"}
Get-Content "$FilePath\`$LIST" | ForEach-Object {
$partxxx, $partyyy, $partzzz = $_ -split '[][]';if ($partyyy -eq "GROUP") {Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8}
if ($_ -ne "") {Add-Content -Path "$ListTarget" -Value "$_" -Encoding UTF8}}
#Add-Content -Path "$ListTarget" -Value "" -Encoding UTF8
$PathCheck = "$FilePath\`$LIST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$FilePath\`$LIST" -Force}
if ($ListName -ne "$null") {MessageBox -MessageBoxType 'Info' -MessageBoxTitle 'Info' -MessageBoxText "Selected options added to $ListName"
$global:LBWiz_Stage = $null;$global:marked = $null;$PageMain.Visible = $true;$PageLB.Visible = $true;$PageLBWiz.Visible = $false;Button_PageLB}
}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FUNCTION◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
function PickEnvironment {
$ListView1_PageLBWiz.CheckBoxes = $false;$ListView1_PageLBWiz.Items.Clear();
if ($Show_ENV -eq $true) {$global:Show_ENV = $null;$ListView1_PageLBWiz.Items.Add("🪟 Current Environment")}
$PathCheck = "$PSScriptRoot\\image";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\image"} else {$FilePath = "$PSScriptRoot"}
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
$LoadINI = Get-Content -Path "$PSScriptRoot\\windick.ini" | Select-Object -Skip 1
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
$PathCheck = "$env:temp\\`$CON";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$env:temp\`$CON" -Force}
Add-Content -Path "$env:temp\`$CON" -Value "$PSScriptRoot" -Encoding UTF8
Add-Content -Path "$env:temp\`$CON" -Value "GUI_CONFONT=$($DropBox1_PageSC.SelectedItem)" -Encoding UTF8
Add-Content -Path "$env:temp\`$CON" -Value "GUI_CONFONTSIZE=$($DropBox2_PageSC.SelectedItem)" -Encoding UTF8
if ($ButtonRadio1_Group2.Checked) {Add-Content -Path "$env:temp\`$CON" -Value "GUI_SCALE=0.75" -Encoding UTF8}
if ($ButtonRadio2_Group2.Checked) {Add-Content -Path "$env:temp\`$CON" -Value "GUI_SCALE=1.00" -Encoding UTF8}
if ($ButtonRadio3_Group2.Checked) {Add-Content -Path "$env:temp\`$CON" -Value "GUI_SCALE=1.25" -Encoding UTF8}
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
$PSScriptRoot = Get-Content -Path \"$env:temp\\`$CON\" -TotalCount 1
$LoadINI = Get-Content -Path \"$env:temp\\`$CON\" | Select-Object -Skip 1
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
CLS;Write-Host "Console Virtual Dimension: $DimensionX x $DimensionY"
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
do {Start-Sleep -Milliseconds 100} until (-not (Test-Path -Path "$env:temp\\`$CON"))
if ($GUI_CONTYPE -eq 'Embed') {[VOID][WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 1);[VOID][WinMekanix.Functions]::MoveWindow($CMDHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)}
$PageBlank.Visible = $false;$PageConsole.Visible = $true;$PageConsole.BringToFront()
[VOID][WinMekanix.Functions]::ShowWindowAsync($CMDHandle, 3);}
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
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[VOID][System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)
[VOID][System.Windows.Forms.Application]::EnableVisualStyles()
[VOID][System.Text.Encoding]::Unicode;LoadSettings
[VOID][WinMekanix.Functions]::SetProcessDPIAware();#[WinMekanix.Functions]::GetParent($PSProcessId)
$sysltr, $nullx = $env:SystemDrive -split '[:]';$progltr, $nullx = $PSScriptRoot -split '[:]'
$PSHandle = [WinMekanix.Functions]::GetConsoleWindow();[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 2);
$STDOutputHandle = [WinMekanix.Functions]::GetStdHandle([WinMekanix.Functions]::STD_OUTPUT_HANDLE)
$getproc = Get-ChildProcesses $PID | Select ProcessId, Name, ParentProcessId
$part1, $part2, $part3 = $getproc -split ";";$part4 = $part1 -split ";";$SubPSId = $part4 -Split "@{ProcessId="
Write-Host "Main thread PID: $PID conhost PID:$SubPSId"
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
$PathCheck = "$PSScriptRoot\\`$LIST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\`$LIST" -Force}
$PathCheck = "$PSScriptRoot\\list\\`$LIST";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\list\`$LIST" -Force}
$PathCheck = "$PSScriptRoot\\`$DSK";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$PSScriptRoot\`$DSK" -Force}
$PathCheck = "$env:temp\\`$CON";if (Test-Path -Path $PathCheck) {Remove-Item -Path "$env:temp\`$CON" -Force}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$form = New-Object Windows.Forms.Form
$form.SuspendLayout()
$version = Get-Content -Path "$PSScriptRoot\\windick.ps1" -TotalCount 1;
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
$WindowState = 'Normal'
$PageMain = NewPanel -X '0' -Y '0' -W '1000' -H '666' -C 'Yes'
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
$PageDebug = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageDebug);$PageDebug.Visible = $false;
$PageConsole = NewPanel -X '0' -Y '0' -W '1000' -H '666';$form.Controls.Add($PageConsole);$PageConsole.Visible = $false;
$WSIZ = [int](1000 * $ScaleRef * $GUI_SCALE)
$HSIZ = [int](666 * $ScaleRef * $GUI_SCALE)
$XLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$YLOC = [int](0 * $ScaleRef * $GUI_SCALE)
$PSHandle = [WinMekanix.Functions]::GetConsoleWindow();$PanelHandle = $PageDebug.Handle;[VOID][WinMekanix.Functions]::SetParent($PSHandle, $PanelHandle);[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 1);[VOID][WinMekanix.Functions]::MoveWindow($PSHandle, $XLOC, $YLOC, $WSIZ, $HSIZ, $true)

$Button_V2W = NewPageButton -X '10' -Y '70' -W '230' -H '70' -C '0' -Text 'Image Processing';$Button_V2W.Visible = $false
$Button_W2V = NewPageButton -X '10' -Y '70' -W '230' -H '70' -C '0' -Text 'Image Processing'
$Button_LB = NewPageButton -X '10' -Y '225' -W '230' -H '70' -C '0' -Text 'Image Management'
$Button_PB = NewPageButton -X '10' -Y '225' -W '230' -H '70' -C '0' -Text 'Image Management';$Button_PB.Visible = $false
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
$Page = 'PageSP';$Label0_PageSP = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text 'Welcome to GUI v0.8' -TextAlign 'X'

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
$PathCheck = "$PSScriptRoot\\list";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\list"} else {$FilePath = "$PSScriptRoot"}
$FileFilt = "List files (*.list;*.base)|*.list;*.base";PickFile
if ($Pick) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$Pick"}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PagePB';$Label0_PagePB = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "🗳 Image Management" -TextAlign 'X'
$ListView1_PagePB = NewListView -X '390' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PagePB.Columns.Add("X", $WSIZ)
$ListView2_PagePB = NewListView -X '25' -Y '90' -W '335' -H '470';$WSIZ = [int](325 * $ScaleRef * $GUI_SCALE);[void]$ListView2_PagePB.Columns.Add("X", $WSIZ)
$Button0_PagePB = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🏁 Pack Execute' -Hover_Text 'Pack Execute' -Add_Click {PEWiz_Stage1;$PagePEWiz.Visible = $true;$PageMain.Visible = $false;$PagePB.Visible = $false;$PagePEWiz.BringToFront()}
$Button3_PagePB = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🏗 Pack Builder' -Hover_Text 'Pack Builder' -Add_Click {PBWiz_Stage1;$PagePBWiz.Visible = $true;$PageMain.Visible = $false;$PagePB.Visible = $false;$PagePBWiz.BringToFront()}
$Button4_PagePB = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '✏ Edit Pack' -Hover_Text 'Edit Pack' -Add_Click {
$PathCheck = "$PSScriptRoot\\project\package.list";if (Test-Path -Path $PathCheck) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PathCheck"}
$PathCheck = "$PSScriptRoot\\project\package.cmd";if (Test-Path -Path $PathCheck) {Start-Process -FilePath "Notepad.exe" -WindowStyle "Maximized" -ArgumentList "$PathCheck"}}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageBC';$Label0_PageBC = NewLabel -X '-125' -Y '5' -W '1000' -H '60' -Bold 'True' -TextSize '36' -Text "💾 BootDisk Creator" -TextAlign 'X'

$ListView1_PageBC = NewListView -X '25' -Y '90' -W '700' -H '300';$WSIZ = [int](690 * $ScaleRef * $GUI_SCALE);[void]$ListView1_PageBC.Columns.Add("X", $WSIZ)
$Button1_PageBC = NewButton -X '262' -Y '585' -W '225' -H '60' -Text '🏁 Create' -Hover_Text 'Start BootDisk Creation' -Add_Click {$halt = $null;$nullx, $disknum, $nully = $($DropBox3_PageBC.SelectedItem) -split '[| ]'
$PathCheck = "$PSScriptRoot\\cache";if (Test-Path -Path $PathCheck) {$FilePath = "$PSScriptRoot\cache"} else {$FilePath = "$PSScriptRoot"}
$PathCheckX = "$FilePath\\boot.sav";if (-not (Test-Path -Path $PathCheckX)) {
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

$Button1_PageSC = NewButton -X '25' -Y '585' -W '225' -H '60' -Text '🛠 Console Settings' -Hover_Text 'Console Settings' -Add_Click {ForEach ($i in @("","ARG1=-INTERNAL","ARG2=-SETTINGS")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
#$TextPath = "$env:temp\`$CON";$TextWrite = [System.IO.StreamWriter]::new($TextPath, $false, [System.Text.Encoding]::UTF8);#$TextWrite.WriteLine("x");$TextWrite.Close()
Launch-CMD -X '-0' -Y '-0' -W '1000' -H '666'}
$Button2_PageSC = NewButton -X '500' -Y '585' -W '225' -H '60' -Text '🐜 Debug' -Hover_Text 'Debug' -Add_Click {
[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 2);[VOID][WinMekanix.Functions]::ShowWindowAsync($PSHandle, 1);
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

$GroupBoxName = 'Group2';$GroupBox2_PageSC = NewGroupBox -X '310' -Y '85' -W '325' -H '75' -Text 'GUI Scale Factor'
$Add_CheckedChanged = {if ($ButtonGroup2Changed -eq '1') {if ($ButtonRadio1_Group2.Checked) {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
ForEach ($i in @("","GUI_SCALE=0.75")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}}}
$global:ButtonGroup2Changed = '1';}

$ButtonRadio1_Group2 = NewRadioButton -X '15' -Y '30' -W '100' -H '35' -Text '0.75' -GroupBoxName 'Group2'
$Add_CheckedChanged = {if ($ButtonGroup2Changed -eq '1') {if ($ButtonRadio2_Group2.Checked) {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
ForEach ($i in @("","GUI_SCALE=1.00")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}}}
$global:ButtonGroup2Changed = '1';}
$ButtonRadio2_Group2 = NewRadioButton -X '115' -Y '30' -W '100' -H '35' -Text '1.00' -GroupBoxName 'Group2'
$Add_CheckedChanged = {if ($ButtonGroup2Changed -eq '1') {if ($ButtonRadio3_Group2.Checked) {
MessageBox -MessageBoxType 'YesNo' -MessageBoxTitle 'Confirm Reload' -MessageBoxText 'Restart app for changes to take effect. Reload?'
ForEach ($i in @("","GUI_SCALE=1.25")) {Add-Content -Path "$PSScriptRoot\windick.ini" -Value "$i" -Encoding UTF8}
if ($boxresult -ne "OK") {$null}
if ($boxresult -eq "OK") {Start-Process "$env:comspec" -ArgumentList "/c", "$PSScriptRoot\windick.cmd";$NoExitPrompt = 1;$form.Close()}}}
$global:ButtonGroup2Changed = '1';}

$ButtonRadio3_Group2 = NewRadioButton -X '215' -Y '30' -W '100' -H '35' -Text '1.25' -GroupBoxName 'Group2'
if ($GUI_SCALE) {$null} else {$GUI_SCALE = 1.00}
if ($GUI_SCALE -eq '1.25') {$ButtonRadio3_Group2.Checked = $true}
if ($GUI_SCALE -eq '1.00') {$ButtonRadio2_Group2.Checked = $true}
if ($GUI_SCALE -eq '0.75') {$ButtonRadio1_Group2.Checked = $true}
#▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶▶FORM◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀◀
$Page = 'PageConsole';$Button1_PageConsole = NewButton -X '350' -Y '585' -W '300' -H '60' -Text '◀ Back' -Hover_Text 'Back' -Add_Click {
$PageMain.Visible = $true;$PageConsole.Visible = $false;
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
if ($LBWiz_Stage -eq '2') {LBWiz_Stage1}
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

$ListView1_PageLBWiz = NewListView -X '25' -Y '135' -W '950' -H '425';# -Headers 'NonClickable';#$WSIZ = [int](470 * $ScaleRef * $GUI_SCALE);#$ListView1_PageLBWiz.Columns.Add("Item Name", $WSIZ);#$ListView1_PageLBWiz.Columns.Add("Description", $WSIZ)
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
[string]$EmptyExecList=@"
77u/RVhFQy1MSVNUDQo=
"@
[string]$EmptyMultiList=@"
77u/TVVMVEktTElTVA0K
"@
[string]$EmptyBaseList=@"
77u/QkFTRS1MSVNUDQo=
"@
[string]$EmptyBaseGroup=@"
77u/QkFTRS1HUk9VUA0K
"@
[string]$splashjpg=@"
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NONPPPPON6gI4ggo4wN9PPPPPPPPPPPPPPPPPAAHyINvMSIwggggggggggg19PPPPPPPPPPPPPPPOQ/qA/LAggggggggggggggggZPPPPPPPPPPPONAaR/ZFnraAgggggiDADBAggggg9PPPPPPPPPOKm72Saf8AH7TI8889/wA88888NPPPPrVk08888888842k08pVIpSWwwwwww8wwwwwwwwopCic888888888s9j8uT8gFCOBUyGwLWhJjLtTnopCDk08888880040a+vz0tCxCnCnDmpXDTKSLSIowCC3D88888+mtYO6g8C8xcaENnCnDpHQNbKSLBoDACEj88826Z8ZCbyx98KZciAlAtCnpXLDoVKSJoDQCR/wAPPiDUPAwh0SzPHlPDgC54bAQ1Wiky9bQKAwyk+/vBrNvpwggg8Mng1/CZECYA9YxUKQUy0/KAwwF//vB7MStIggh4vxAWUKAJECwwS0QECAky1KAwwQ+wvOuLwAQh4XE+EXzh5YwJEC5KRSQECJUWKAwwU/8A3zz0wS412FSsdP0QgK2ACRAupVEkBAiUEAMMgTwPzzf9wpzyAtkf7+7k9zoKLJO5gJKLJKKQgMIBeozzwETLDinIBVyo2jiD7l3DDDTjDDDDDDCgNQLV/wA8tCCkQignUEEf4/8ACiltAN5ylBQAPxcVaAw171PPGgggglAlFUwlDHn6lnTpw5iVw5wki0qKA6Cmt/OKAggglwlFnhlVV/G5/uQpw6R4DLwkiwaAA+VfPDAwgggiwgCNxtBAPAdlSDQp6Vyw7BSkiaC1qLPPFIwggggAgKk3Kxh+AzIks2QgxGgky1SRKKOZXPPOQggggoAhIgP6+APWhdmojLIxUKQEy07KBerfPPHwggggig0wIkyBXvnvfrz1yS0QECAky1KE9XPPPH4wggggwgQOIAVcuMHZesbTKQSQECJXWKD9fPPPN6QggghAlFT4KdeZgwQEBly6lUyQECJQQL/PPPPLbAggggiKBLYwFQKxjhlSKEbAI0wQWQZQFPPPPPBBQgggghEQESylSDfPPPPPPPPPPPPPPPLFPPPPPGHSQgggh4XgxIFaIM888888884AQLCCDDPPPPPPKTuSggqoLTqO6WiV6wwwwgwhIAmPGzfPPPPPPPPPFs7gg0JBKOEwBFGPSAghA0Ahx8cSnPPP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
"@
[string]$logobar=@"
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
"@
[string]$logo2=@"
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
"@
[string]$logojpgB64=@"
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
"@
$Page = 'PageSP';$pictureBase64 = $splashjpg;$PictureBox1_PageMain = NewPictureBox -X '120' -Y '75' -W '500' -H '500';
$Page = 'PageMain';$Button_SP = NewPageButton -X '-5' -Y '630' -W '50' -H '40' -C '0' -Text '';$Button_SPImage = [System.Drawing.Image]::FromStream([System.IO.MemoryStream][Convert]::FromBase64String($logobar));$Button_SP.Image = $Button_SPImage
$form.ResumeLayout()
$form.Add_Shown({$form.Activate()})
$form.ShowDialog()
$form.Dispose()
#$form.Refresh()
#🗃\🗂\🧾\💾\🗳\🏗\🛠\🪛\✂\🗜\✒\✏\🥾\🪟\🛜\🔄\🌐\🛡\🪪\✅\❎\🚫\⏳\🏁\🎨\❗\🛳\🚽\💥\🚥\🚦\🕸\🐜\🛤\🏞\🌕\🌑\◀\▶#