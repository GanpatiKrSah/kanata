# Kanata Tray Launcher
# --------------------
# Starts Kanata hidden and adds a tray icon to manage it.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$kanataExe  = "D:\Kanata\kanata.exe"
$configFile = "D:\Kanata\test.kbd"

# ---- start Kanata silently
$global:proc = Start-Process -FilePath $kanataExe `
    -ArgumentList "-q","-c","$configFile" `
    -WindowStyle Hidden -PassThru

# ---- build tray icon + menu

# ---- load custom icon from same directory
$iconPath = Join-Path (Split-Path $PSCommandPath) "kanata.ico"

if (Test-Path $iconPath) {
    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
} else {
    $icon = [System.Drawing.SystemIcons]::Information  # fallback icon
}



$tray = New-Object System.Windows.Forms.NotifyIcon
$tray.Icon = $icon
$tray.Text = "Kanata running"
$tray.Visible = $true

$menu = New-Object System.Windows.Forms.ContextMenuStrip
$restart = $menu.Items.Add("Restart Kanata")
$exit    = $menu.Items.Add("Exit")

$restart.Add_Click({
    if ($global:proc -and !$global:proc.HasExited) { $global:proc.Kill() }
    $global:proc = Start-Process -FilePath $kanataExe `
        -ArgumentList "-q","-c","$configFile" `
        -WindowStyle Hidden -PassThru
})

$exit.Add_Click({
    if ($global:proc -and !$global:proc.HasExited) { $global:proc.Kill() }
    $tray.Visible = $false
    $tray.Dispose()
    [System.Windows.Forms.Application]::Exit()
})

$tray.ContextMenuStrip = $menu
$tray.ShowBalloonTip(1500,"Kanata","Kanata started and is running in background",[System.Windows.Forms.ToolTipIcon]::Info)

while ($tray.Visible) {
    [System.Windows.Forms.Application]::DoEvents()
    Start-Sleep -Milliseconds 500
}
