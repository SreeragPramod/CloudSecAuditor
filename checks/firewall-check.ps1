# Check if Windows Firewall is enabled

function Test-FirewallStatus {
    Write-Host "[*] Checking Firewall Status..." -ForegroundColor Yellow

    $profiles = Get-NetFirewallProfile

    foreach ($profile in $profiles) {
        if ($profile.Enabled -eq $true) {
            Write-Host "[PASS] $($profile.Name) Firewall is ON" -ForegroundColor Green
        }
        else {
            Write-Host "[FAIL] $($profile.Name) Firewall is OFF!" -ForegroundColor Red
        }
    }
}

# Run the function
Test-FirewallStatus