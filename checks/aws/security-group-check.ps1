# AWS Security Group Ingress Audit Check

function Test-AWSSecurityGroups {
    Write-Host "[*] Auditing AWS Security Groups (Cloud Firewalls)..." -ForegroundColor Yellow

    try {
        # Query all security groups in your region
        $secGroups = Get-EC2SecurityGroup -Region "ap-southeast-2"

        if ($null -eq $secGroups -or $secGroups.Count -eq 0) {
            Add-AuditResult -Check "AWS Firewall" -Item "Security Groups" -Status "INFO" -Message "No Security Groups found in region"
            return
        }

        Write-Host "    Found $($secGroups.Count) Security Group(s). Inspecting inbound rules..." -ForegroundColor Yellow

        $riskyPorts = @(22, 3389, 445, 21, 23)

        foreach ($sg in $secGroups) {
            $sgName = $sg.GroupName
            $hasViolation = $false

            foreach ($rule in $sg.IpPermissions) {
                # Check if this rule is open to the entire world (0.0.0.0/0)
                $isOpenToWorld = $rule.Ipv4Ranges | Where-Object { $_.CidrIp -eq "0.0.0.0/0" }

                if ($isOpenToWorld) {
                    $fromPort = $rule.FromPort
                    $toPort = $rule.ToPort

                    # Check if any dangerous management ports fall within this rule
                    foreach ($badPort in $riskyPorts) {
                        if ($badPort -ge $fromPort -and $badPort -le $toPort) {
                            $hasViolation = $true
                            Add-AuditResult -Check "AWS Firewall" -Item "$sgName (Port $badPort)" -Status "FAIL" -Message "Security Group '$sgName' exposes port $badPort to 0.0.0.0/0 (Internet)!"
                        }
                    }
                }
            }

            if (-not $hasViolation) {
                Add-AuditResult -Check "AWS Firewall" -Item "$sgName" -Status "PASS" -Message "Security Group '$sgName' has no sensitive ports open to world"
            }
        }
    }
    catch {
        Add-AuditResult -Check "AWS Firewall" -Item "API Error" -Status "FAIL" -Message "Could not query Security Groups: $($_.Exception.Message)"
    }
}

# Run the function
Test-AWSSecurityGroups