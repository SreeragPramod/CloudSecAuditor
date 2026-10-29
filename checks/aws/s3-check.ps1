# AWS S3 Bucket Public Access Security Check

function Test-AWSS3Security {
    Write-Host "[*] Auditing AWS S3 Storage Buckets..." -ForegroundColor Yellow

    try {
        $buckets = Get-S3Bucket

        if ($null -eq $buckets -or $buckets.Count -eq 0) {
            Add-AuditResult -Check "AWS S3" -Item "S3 Buckets" -Status "INFO" -Message "No S3 buckets found in account"
            return
        }

        Write-Host "    Found $($buckets.Count) bucket(s). Checking public access settings..." -ForegroundColor Yellow

        foreach ($bucket in $buckets) {
            $name = $bucket.BucketName

            # Check if Public Access Block is enabled
            $blockConfig = Get-S3PublicAccessBlock -BucketName $name -Region "ap-southeast-2" -ErrorAction SilentlyContinue

            if ($blockConfig) {
                if ($blockConfig.BlockPublicAcls -eq $true -and $blockConfig.BlockPublicPolicy -eq $true) {
                    Add-AuditResult -Check "AWS S3" -Item "$name" -Status "PASS" -Message "Bucket '$name' has Public Access BLOCKED"
                }
                else {
                    Add-AuditResult -Check "AWS S3" -Item "$name" -Status "WARN" -Message "Bucket '$name' might allow public access!"
                }
            }
            else {
                Add-AuditResult -Check "AWS S3" -Item "$name" -Status "WARN" -Message "Bucket '$name' has NO Public Access Block configured!"
            }
        }
    }
    catch {
        Add-AuditResult -Check "AWS S3" -Item "API Error" -Status "FAIL" -Message "Could not query S3: $($_.Exception.Message)"
    }
}

# Run the function
Test-AWSS3Security