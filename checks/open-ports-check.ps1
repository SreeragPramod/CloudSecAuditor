# Check for risky open ports

function Test-OpenPorts {
    Write-Host "[*] Checking for risky open ports..." -ForegroundColor Yellow

    # List of ports that are risky if open
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
            Write-Host "[WARN] Port $port ($name) is OPEN!" -ForegroundColor Red
        }
        else {
            Write-Host "[PASS] Port $port ($name) is closed" -ForegroundColor Green
        }
    }
}

# Run the function
Test-OpenPorts