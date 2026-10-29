# Check for risky open ports

function Test-OpenPorts {
    Write-Host "[*] Checking for risky open ports..." -ForegroundColor Yellow

    $riskyPorts = @(
        @{ Port = 21;   Name = "FTP" },
        @{ Port = 23;   Name = "Telnet" },
        @{ Port = 445;  Name = "SMB" },
        @{ Port = 3389; Name = "RDP" },
        @{ Port = 5985; Name = "WinRM" }
    )

    foreach ($entry in $riskyPorts) {
        $port = $entry.Port
        $name = $entry.Name

        $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue

        if ($connection) {
            Add-AuditResult -Check "Open Ports" -Item "$port ($name)" -Status "WARN" -Message "Port $port ($name) is OPEN!"
        }
        else {
            Add-AuditResult -Check "Open Ports" -Item "$port ($name)" -Status "PASS" -Message "Port $port ($name) is closed"
        }
    }
}

Test-OpenPorts