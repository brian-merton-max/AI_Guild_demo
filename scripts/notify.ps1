# Claude Code — Stop Hook
# Fires a system tray notification when Claude finishes a task.
# Called automatically by the Stop hook in .claude/settings.json

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon    = [System.Drawing.SystemIcons]::Information
$notify.Visible = $true

$notify.BalloonTipTitle = "Claude Code"
$notify.BalloonTipText  = "Task complete"
$notify.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Info

$notify.ShowBalloonTip(5000)

# Keep the process alive long enough for the balloon to display
Start-Sleep -Seconds 4

$notify.Dispose()
