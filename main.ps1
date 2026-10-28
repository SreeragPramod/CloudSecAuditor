# CloudSecAuditor - A Cloud Security Posture Auditor
# Author: Sreerag

# --- Variables ---
$toolName = "CloudSecAuditor"
$version = "1.0"

# --- Display Banner ---
Write-Host ""
Write-Host "===============================" -ForegroundColor Cyan
Write-Host "  $toolName v$version" -ForegroundColor Cyan
Write-Host "  Author: Sreerag" -ForegroundColor Cyan
Write-Host "  Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
Write-Host ""

# --- Load and Run All Checks ---
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

Write-Host "===============================" -ForegroundColor Cyan
Write-Host "  Audit Complete!" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Cyan