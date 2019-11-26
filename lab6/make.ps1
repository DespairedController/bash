$dependencies = @{}
$built = @{}
 
$abstractBlock = New-Object -TypeName PsObject -Property @{
  Deps = @();
  Commands = @();
  }
 
function buildTarget($targetName) {
  $target = $dependencies[$targetName]
  foreach ($dep in $target.Deps) {
    if (-Not ($built.ContainsKey($dep))) {
      $built.Add($dep, $true)  
      buildTarget($dep)
    }
  }
  foreach ($cmd in $target.Commands) {
    Invoke-Expression $cmd
  }
}
 
if ($Args.length -ne 1) {
  Write-Host "Usage: ./1 <TARGET NAME>"
  exit 0
}
 
$targetName=$Args[0]
$currentName = ""
$currentObj
 
 
foreach($line in Get-Content .\Makefile) {
  if (($line -ne "") -and ($currentName -eq "")) {
    $a = $line.split(":", 2)
    $currentName=$a[0]
    $deps = $a[1].split()
    $currentObj = $abstractBlock.PsObject.Copy()
    foreach($d in $deps) {
      if ($d) {
        $currentObj.Deps += $d
      }
    }
  } elseif (($line -eq "") -and ($currentName -ne "")) {
    $dependencies.Add($currentName, $currentObj)
    $currentName = ""
  } elseif (($line -ne "") -and ($currentName -ne "")) {
    $currentObj.Commands+=$line
  }
}
$dependencies.Add($currentName, $currentObj)
 
buildTarget($targetName)
 
 
 
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
  Start-Process -WindowStyle hidden powershell -argument "./2 poll $url"
}

