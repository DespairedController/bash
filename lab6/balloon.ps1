function ShowBalloon($text) {
  Add-Type -AssemblyName System.Windows.Forms
  $path = Get-Process -id $pid | Select-Object -ExpandProperty Path
  $balloon = New-Object System.Windows.Forms.NotifyIcon
  $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
  $balloon.BalloonTipIcon = "Info"
  $balloon.BalloonTipText = $text
  $balloon.BalloonTipTitle = ":("
  $balloon.Visible = $True
  $balloon.ShowBalloonTip(5000)
}
 
if ($Args.length -ne 2) {
  Write-Host "Usage <COMMAND> <URL>"
  exit 0;
}
 
$command = $Args[0]
$url = $Args[1]
 
if ($command -eq "poll") {
  $text
  while ($true) {
    $response = Invoke-WebRequest $url
    if ($response.Content -ne $text) {
      ShowBalloon($response)
      $text = $response.Content
    }
    Start-Sleep -seconds 1.5
  }
} elseif ($command -eq "register") {
  Start-Process -WindowStyle hidden powershell -argument "./balloon poll $url"
}
