# Start a timer and output its status every 10 seconds

$timeCounter = 10
$sleepTime = 90

Write-Host "Total sleep time will be $sleeptime seconds"

do {
    Start-Sleep -Seconds 10
    Write-Host "It has been $timeCounter seconds since the sleep timer started."
    $timeCounter = $timeCounter + 10
} while ($timeCounter -ne $sleepTime)
Write-Host "The sleeptimer finished after $sleepTime seconds"