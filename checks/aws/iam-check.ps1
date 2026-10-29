# AWS IAM Account Security and MFA Audit

function Test-AWSIAMSecurity {
    Write-Host "[*] Auditing AWS IAM Account & User Security..." -ForegroundColor Yellow

    try {
        # Check Account Summary (contains Root MFA status)
        $summary = Get-IAMAccountSummary

        $rootMfa = $summary.AccountMFAEnabled
        if ($rootMfa -eq 1) {
            Add-AuditResult -Check "AWS IAM" -Item "Root Account MFA" -Status "PASS" -Message "Root Account has MFA ENABLED"
        }
        else {
            Add-AuditResult -Check "AWS IAM" -Item "Root Account MFA" -Status "FAIL" -Message "Root Account has NO MFA! High risk"
        }

        # Check IAM Users for MFA
        $users = Get-IAMUserList

        if ($users) {
            foreach ($u in $users) {
                $uName = $u.UserName
                $mfas = Get-IAMMFADevice -UserName $uName -ErrorAction SilentlyContinue

                if ($mfas -and $mfas.Count -gt 0) {
                    Add-AuditResult -Check "AWS IAM" -Item "User: $uName" -Status "PASS" -Message "User '$uName' has MFA enabled"
                }
                else {
                    # Programmatic auditor users without console access often don't have MFA device attached
                    Add-AuditResult -Check "AWS IAM" -Item "User: $uName" -Status "WARN" -Message "User '$uName' has no MFA device attached"
                }
            }
        }
    }
    catch {
        Add-AuditResult -Check "AWS IAM" -Item "API Error" -Status "FAIL" -Message "Could not query IAM: $($_.Exception.Message)"
    }
}

# Run the function
Test-AWSIAMSecurity