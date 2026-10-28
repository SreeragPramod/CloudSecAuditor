# Check for risky user accounts

function Test-UserAccounts {
    Write-Host "[*] Checking User Accounts..." -ForegroundColor Yellow

    # Check 1: Is Guest account enabled?
    $guest = Get-LocalUser -Name "Guest" -ErrorAction SilentlyContinue
    if ($guest.Enabled -eq $true) {
        Write-Host "[FAIL] Guest account is ENABLED! Attackers love this" -ForegroundColor Red
    }
    else {
        Write-Host "[PASS] Guest account is disabled" -ForegroundColor Green
    }

    # Check 2: How many admin accounts exist?
    $admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
    $adminCount = ($admins | Measure-Object).Count

    Write-Host "[INFO] Found $adminCount Administrator account(s):" -ForegroundColor Yellow
    foreach ($admin in $admins) {
        Write-Host "       - $($admin.Name)" -ForegroundColor White
    }

    if ($adminCount -gt 2) {
        Write-Host "[WARN] Too many admin accounts! Keep it minimal" -ForegroundColor Red
    }
    else {
        Write-Host "[PASS] Admin account count looks good" -ForegroundColor Green
    }
}

# Run the function
Test-UserAccounts