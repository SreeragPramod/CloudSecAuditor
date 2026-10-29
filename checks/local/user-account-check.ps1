# Check for risky user accounts

function Test-UserAccounts {
    Write-Host "[*] Checking User Accounts..." -ForegroundColor Yellow

    $guest = Get-LocalUser -Name "Guest" -ErrorAction SilentlyContinue
    if ($guest.Enabled -eq $true) {
        Add-AuditResult -Check "User Accounts" -Item "Guest" -Status "FAIL" -Message "Guest account is ENABLED! Attackers love this"
    }
    else {
        Add-AuditResult -Check "User Accounts" -Item "Guest" -Status "PASS" -Message "Guest account is disabled"
    }

    $admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
    $adminCount = ($admins | Measure-Object).Count

    Add-AuditResult -Check "User Accounts" -Item "Admin Count" -Status "INFO" -Message "Found $adminCount Administrator account(s)"

    if ($adminCount -gt 2) {
        Add-AuditResult -Check "User Accounts" -Item "Admin Count" -Status "WARN" -Message "Too many admin accounts! Keep it minimal"
    }
    else {
        Add-AuditResult -Check "User Accounts" -Item "Admin Count" -Status "PASS" -Message "Admin account count looks good"
    }
}

Test-UserAccounts