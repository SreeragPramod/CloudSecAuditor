# Check if Remote Desktop is enabled

function Test-RDPStatus {
    Write-Host "[*] Checking Remote Desktop (RDP) Status..." -ForegroundColor Yellow

    $rdpEnabled = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -ErrorAction SilentlyContinue

    if ($rdpEnabled.fDenyTSConnections -eq 0) {
        Add-AuditResult -Check "RDP" -Item "Remote Desktop" -Status "WARN" -Message "Remote Desktop is ENABLED!"

        $nla = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -ErrorAction SilentlyContinue

        if ($nla.UserAuthentication -eq 1) {
            Add-AuditResult -Check "RDP" -Item "NLA" -Status "PASS" -Message "NLA (Network Level Authentication) is required"
        }
        else {
            Add-AuditResult -Check "RDP" -Item "NLA" -Status "FAIL" -Message "NLA is NOT required! Anyone can see login screen"
        }
    }
    else {
        Add-AuditResult -Check "RDP" -Item "Remote Desktop" -Status "PASS" -Message "Remote Desktop is disabled"
    }
}

Test-RDPStatus