# CloudSecAuditor - A Cloud Security Posture Auditor
# Author: Sreerag

$toolName = "CloudSecAuditor"
$version = "1.0"

# --- Load Helper Functions ---
. .\helpers\audit-helpers.ps1

# --- Display Banner ---
Write-Host ""
Write-Host "===============================" -ForegroundColor Cyan
Write-Host "  $toolName v$version" -ForegroundColor Cyan
Write-Host "  Author: Sreerag" -ForegroundColor Cyan
Write-Host "  Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
Write-Host ""

# --- Run All Checks ---
Write-Host "=== FIREWALL CHECK ===" -ForegroundColor Magenta
. .\checks\firewall-check.ps1
Write-Host ""

Write-Host "=== OPEN PORTS CHECK ===" -ForegroundColor Magenta
. .\checks\open-ports-check.ps1
Write-Host ""

Write-Host "=== ANTIVIRUS CHECK ===" -ForegroundColor Magenta
. .\checks\antivirus-check.ps1
Write-Host ""

Write-Host "=== USER ACCOUNT CHECK ===" -ForegroundColor Magenta
. .\checks\user-account-check.ps1
Write-Host ""

Write-Host "=== RDP CHECK ===" -ForegroundColor Magenta
. .\checks\rdp-check.ps1
Write-Host ""

# --- Generate HTML Report ---
$reportPath = ".\reports\audit-report.html"
New-Item -ItemType Directory -Path ".\reports" -Force | Out-Null

$passCount = ($global:auditResults | Where-Object { $_.Status -eq "PASS" }).Count
$failCount = ($global:auditResults | Where-Object { $_.Status -eq "FAIL" }).Count
$warnCount = ($global:auditResults | Where-Object { $_.Status -eq "WARN" }).Count

$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>CloudSecAuditor Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #1a1a2e; color: #eee; }
        h1 { color: #00d4ff; }
        h2 { color: #a855f7; }
        .summary { display: flex; gap: 20px; margin: 20px 0; }
        .card { padding: 20px; border-radius: 10px; text-align: center; min-width: 120px; }
        .pass { background: #064e3b; color: #34d399; }
        .fail { background: #7f1d1d; color: #f87171; }
        .warn { background: #78350f; color: #fbbf24; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #2d2d44; padding: 12px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #333; }
        .status-PASS { color: #34d399; font-weight: bold; }
        .status-FAIL { color: #f87171; font-weight: bold; }
        .status-WARN { color: #fbbf24; font-weight: bold; }
        .status-INFO { color: #60a5fa; font-weight: bold; }
        footer { margin-top: 40px; color: #666; }
    </style>
</head>
<body>
    <h1>CloudSecAuditor Report</h1>
    <p>Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
    <p>Author: Sreerag</p>

    <div class="summary">
        <div class="card pass"><h2>$passCount</h2>PASSED</div>
        <div class="card fail"><h2>$failCount</h2>FAILED</div>
        <div class="card warn"><h2>$warnCount</h2>WARNINGS</div>
    </div>

    <h2>Detailed Results</h2>
    <table>
        <tr><th>Check</th><th>Item</th><th>Status</th><th>Message</th></tr>
"@

foreach ($result in $global:auditResults) {
    $html += "<tr><td>$($result.Check)</td><td>$($result.Item)</td><td class='status-$($result.Status)'>$($result.Status)</td><td>$($result.Message)</td></tr>`n"
}

$html += @"
    </table>
    <footer><p>CloudSecAuditor v$version | github.com/SreeragPramod/CloudSecAuditor</p></footer>
</body>
</html>
"@

$html | Out-File -FilePath $reportPath -Encoding UTF8

Write-Host "===============================" -ForegroundColor Cyan
Write-Host "  Audit Complete!" -ForegroundColor Green
Write-Host "  Report saved: $reportPath" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Cyan