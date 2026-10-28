# Check if Antivirus is running

function Test-AntivirusStatus {
    Write-Host "[*] Checking Antivirus Status..." -ForegroundColor Yellow

    $antivirus = Get-CimInstance -Namespace "root/SecurityCenter2" -ClassName "AntiVirusProduct" -ErrorAction SilentlyContinue

    if ($antivirus) {
        foreach ($av in $antivirus) {
            Add-AuditResult -Check "Antivirus" -Item $av.displayName -Status "PASS" -Message "Antivirus Found: $($av.displayName)"
        }
    }
    else {
        Add-AuditResult -Check "Antivirus" -Item "None" -Status "FAIL" -Message "No Antivirus detected!"
    }
}

Test-AntivirusStatus