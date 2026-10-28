# Check if Antivirus is running

function Test-AntivirusStatus {
    Write-Host "[*] Checking Antivirus Status..." -ForegroundColor Yellow

    $antivirus = Get-CimInstance -Namespace "root/SecurityCenter2" -ClassName "AntiVirusProduct" -ErrorAction SilentlyContinue

    if ($antivirus) {
        foreach ($av in $antivirus) {
            Write-Host "[PASS] Antivirus Found: $($av.displayName)" -ForegroundColor Green
        }
    }
    else {
        Write-Host "[FAIL] No Antivirus detected!" -ForegroundColor Red
    }
}

# Run the function
Test-AntivirusStatus