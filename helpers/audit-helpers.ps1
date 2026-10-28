# Helper functions for CloudSecAuditor

# This stores all our results
$global:auditResults = @()

function Add-AuditResult {
    param(
        [string]$Check,
        [string]$Item,
        [string]$Status,
        [string]$Message
    )

    # Add result to our global list
    $global:auditResults += [PSCustomObject]@{
        Check   = $Check
        Item    = $Item
        Status  = $Status
        Message = $Message
    }

    # Also print to screen with colors
    $color = switch ($Status) {
        "PASS" { "Green" }
        "FAIL" { "Red" }
        "WARN" { "Red" }
        "INFO" { "Yellow" }
    }

    Write-Host "[$Status] $Message" -ForegroundColor $color
}