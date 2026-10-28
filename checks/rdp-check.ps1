# Check if Remote Desktop is enabled

function Test-RDPStatus {
    Write-Host "[*] Checking Remote Desktop (RDP) Status..." -ForegroundColor Yellow

    $rdpEnabled = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -ErrorAction SilentlyContinue

    if ($rdpEnabled.fDenyTSConnections -eq 0) {
        Write-Host "[WARN] Remote Desktop is ENABLED!" -ForegroundColor Red
        Write-Host "       Attackers can try to brute-force RDP" -ForegroundColor Red

        # Check if NLA is required (extra security layer)
        $nla = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -ErrorAction SilentlyContinue

        if ($nla.UserAuthentication -eq 1) {
            Write-Host "[PASS] NLA (Network Level Authentication) is required" -ForegroundColor Green
        }
        else {
            Write-Host "[FAIL] NLA is NOT required! Anyone can see the login screen" -ForegroundColor Red
        }
    }
    else {
        Write-Host "[PASS] Remote Desktop is disabled" -ForegroundColor Green
    }
}

# Run the function
Test-RDPStatus