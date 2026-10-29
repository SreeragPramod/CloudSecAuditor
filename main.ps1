# CloudSecAuditor - Cloud & Host Security Posture Auditor
# Author: Sreerag
# GitHub: github.com/SreeragPramod/CloudSecAuditor

$toolName = "CloudSecAuditor"
$version = "2.0"

# --- Load Helper Functions ---
. .\helpers\audit-helpers.ps1

# --- Display Banner ---
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "         $toolName v$version - Multi-Target Auditor" -ForegroundColor Cyan
Write-Host "         Author : Sreerag" -ForegroundColor Cyan
Write-Host "         Target : Local System & AWS Cloud" -ForegroundColor Cyan
Write-Host "         Date   : $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# ==========================================
# PART 1: LOCAL SYSTEM SECURITY AUDIT
# ==========================================
Write-Host ">>> [SECTION 1] LOCAL SYSTEM AUDIT <<<" -ForegroundColor Green

Write-Host "`n--- FIREWALL STATUS ---" -ForegroundColor Magenta
. .\checks\local\firewall-check.ps1

Write-Host "`n--- OPEN PORTS ---" -ForegroundColor Magenta
. .\checks\local\open-ports-check.ps1

Write-Host "`n--- ANTIVIRUS PROTECTION ---" -ForegroundColor Magenta
. .\checks\local\antivirus-check.ps1

Write-Host "`n--- LOCAL USER ACCOUNTS ---" -ForegroundColor Magenta
. .\checks\local\user-account-check.ps1

Write-Host "`n--- REMOTE DESKTOP (RDP) ---" -ForegroundColor Magenta
. .\checks\local\rdp-check.ps1


# ==========================================
# PART 2: AWS CLOUD SECURITY AUDIT
# ==========================================
Write-Host "`n>>> [SECTION 2] AWS CLOUD AUDIT <<<" -ForegroundColor Green

Write-Host "`n--- AWS S3 BUCKET STORAGE ---" -ForegroundColor Magenta
. .\checks\aws\s3-check.ps1

Write-Host "`n--- AWS SECURITY GROUPS (FIREWALL) ---" -ForegroundColor Magenta
. .\checks\aws\security-group-check.ps1

Write-Host "`n--- AWS IAM & MFA SECURITY ---" -ForegroundColor Magenta
. .\checks\aws\iam-check.ps1


# ==========================================
# PART 3: GENERATE COMPREHENSIVE HTML REPORT
# ==========================================
$reportPath = ".\reports\audit-report.html"
New-Item -ItemType Directory -Path ".\reports" -Force | Out-Null

$passCount = ($global:auditResults | Where-Object { $_.Status -eq "PASS" }).Count
$failCount = ($global:auditResults | Where-Object { $_.Status -eq "FAIL" }).Count
$warnCount = ($global:auditResults | Where-Object { $_.Status -eq "WARN" }).Count

$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>CloudSecAuditor - Unified Audit Report</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 40px; background: #0f172a; color: #f8fafc; }
        h1 { color: #38bdf8; margin-bottom: 5px; }
        .subtitle { color: #94a3b8; font-size: 14px; margin-bottom: 25px; }
        .summary { display: flex; gap: 20px; margin: 25px 0; }
        .card { padding: 20px 30px; border-radius: 12px; text-align: center; min-width: 130px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.3); }
        .card h2 { margin: 0; font-size: 32px; }
        .card p { margin: 5px 0 0 0; font-size: 13px; font-weight: bold; letter-spacing: 1px; }
        .pass { background: #064e3b; color: #34d399; border: 1px solid #059669; }
        .fail { background: #7f1d1d; color: #f87171; border: 1px solid #dc2626; }
        .warn { background: #78350f; color: #fbbf24; border: 1px solid #d97706; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #1e293b; border-radius: 8px; overflow: hidden; }
        th { background: #334155; padding: 14px; text-align: left; color: #e2e8f0; font-size: 14px; }
        td { padding: 12px 14px; border-bottom: 1px solid #334155; font-size: 14px; }
        tr:hover { background: #243247; }
        .status-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-weight: bold; font-size: 12px; }
        .badge-PASS { background: #064e3b; color: #34d399; }
        .badge-FAIL { background: #7f1d1d; color: #f87171; }
        .badge-WARN { background: #78350f; color: #fbbf24; }
        .badge-INFO { background: #1e3a8a; color: #60a5fa; }
        footer { margin-top: 40px; color: #64748b; font-size: 13px; border-top: 1px solid #334155; padding-top: 15px; }
    </style>
</head>
<body>
    <h1>CloudSecAuditor Unified Report</h1>
    <div class="subtitle">Audited by: Sreerag | Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | Target: Local Host + AWS Cloud</div>

    <div class="summary">
        <div class="card pass"><h2>$passCount</h2><p>PASSED</p></div>
        <div class="card fail"><h2>$failCount</h2><p>FAILED</p></div>
        <div class="card warn"><h2>$warnCount</h2><p>WARNINGS</p></div>
    </div>

    <h2 style="color: #c084fc; margin-top: 35px;">Detailed Findings</h2>
    <table>
        <tr><th>Domain / Target</th><th>Audited Item</th><th>Status</th><th>Finding Details</th></tr>
"@

foreach ($result in $global:auditResults) {
    $html += "<tr><td>$($result.Check)</td><td>$($result.Item)</td><td><span class='status-badge badge-$($result.Status)'>$($result.Status)</span></td><td>$($result.Message)</td></tr>`n"
}

$html += @"
    </table>
    <footer><p>CloudSecAuditor v$version | Developed by Sreerag | Portfolio: github.com/SreeragPramod/CloudSecAuditor</p></footer>
</body>
</html>
"@

$html | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  AUDIT COMPLETE! All 8 security checks finished." -ForegroundColor Green
Write-Host "  Report saved to: $reportPath" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan