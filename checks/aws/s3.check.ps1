# AWS S3 Bucket Public Access Security Check

function Test-AWSS3Security {
    Write-Host "[*] Auditing AWS S3 Storage Buckets..." -ForegroundColor Yellow

    try {
        # Get list of all S3 buckets in this AWS account
        $buckets = Get-S3Bucket

        if ($null -eq $buckets -or $buckets.Count -eq 0) {
            Add-AuditResult -Check "AWS S3" -Item "S3 Buckets" -Status "INFO" -Message "No S3 buckets found in account"
            return
        }

        Write-Host "    Found $($buckets.Count) bucket(s). Checking public access settings..." -ForegroundColor Yellow

        foreach ($bucket in $buckets) {
            $name = $bucket.BucketName

            # Check if Public Access Block is enabled
            $blockConfig = Get-S3PublicAccessBlock -BucketName $name -ErrorAction SilentlyContinue

            if ($blockConfig) {
                $isBlocked = $blockConfig.PublicAccessBlockConfiguration.BlockPublicAcls -and
                             $blockConfig.PublicAccessBlockConfiguration.BlockPublicPolicy

                if ($isBlocked) {
                    Add-AuditResult -Check "AWS S3" -Item $name -Status "PASS" -Message "Bucket '$name' has Public Access BLOCKED"
                }
                else {
                    Add-AuditResult -Check "AWS S3" -Item $name -Status "WARN" -Message "Bucket '$name' might allow public access!"
                }
            }
            else {
                # If no block config exists, it might be exposed
                Add-AuditResult -Check "AWS S3" -Item $name -Status "FAIL" -Message "Bucket '$name' has NO Public Access Block configured!"
            }
        }
    }
    catch {
        Add-AuditResult -Check "AWS S3" -Item "API Error" -Status "FAIL" -Message "Could not query S3: $($_.Exception.Message)"
    }
}

# Run the function
Test-AWSS3Security