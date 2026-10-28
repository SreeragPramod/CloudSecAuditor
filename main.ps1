## This is a comment - PowerShell ignores these lines
# CloudSecAuditor - A Cloud Secuirty Posture Auditor

# --- variable ---
$toolName = "CloudSecAuditor"
$version = "1.0"
$author = "Sreerag"

# --- Display Banner ---
Write-Host "===============================" -ForegroundColor Cyan
Write-Host "  $toolName v$version" -ForegroundColor Cyan
Write-Host "  Author: $author" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Starting security audit..." -ForegroundColor Yellow