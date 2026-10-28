# Check if Windows Firewall is enabled

function Test-FirewallStatus {
    Write-Host "[*] Checking Firewall Status..." -ForegroundColor Yellow

    $profiles = Get-NetFirewallProfile

    foreach ($profile in $profiles) {
        if ($profile.Enabled -eq $true) {
            Add-AuditResult -Check "Firewall" -Item $profile.Name -Status "PASS" -Message "$($profile.Name) Firewall is ON"
        }
        else {
            Add-AuditResult -Check "Firewall" -Item $profile.Name -Status "FAIL" -Message "$($profile.Name) Firewall is OFF!"
        }
    }
}

Test-FirewallStatus